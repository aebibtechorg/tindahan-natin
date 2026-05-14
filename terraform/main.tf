terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }

  backend "gcs" {
    # Bucket name will be passed via -backend-config during init
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Artifact Registry for Docker images
resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "tindahannatin-server"
  description   = "Docker repository for TindahanNatin Server"
  format        = "DOCKER"
}

# Cloudflare R2 Bucket
resource "cloudflare_r2_bucket" "products" {
  account_id = var.cloudflare_account_id
  name       = var.r2_bucket_name
  location   = "APAC"
}

# Cloud Run Service
resource "google_cloud_run_v2_service" "server" {
  name     = "tindahannatin-server"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.repo.name}/tindahannatin-server:${var.image_tag}"

      env {
        name  = "ConnectionStrings__tindahandb"
        value = var.postgres_connection_string
      }

      env {
        name  = "ConnectionStrings__cache"
        value = var.redis_connection_string
      }

      # For Cloudflare R2, we use the S3-compatible connection string format
      # Format: Endpoint=https://<account_id>.r2.cloudflarestorage.com;AccessKey=...;SecretKey=...
      # We assume these keys are passed in via variables for now as R2 keys are often account-level.
      env {
        name  = "ConnectionStrings__minio"
        value = "Endpoint=https://${var.cloudflare_account_id}.r2.cloudflarestorage.com;AccessKey=${var.r2_access_key};SecretKey=${var.r2_secret_key}"
      }

      env {
        name  = "Auth0__Domain"
        value = var.auth0_domain
      }

      env {
        name  = "Auth0__Audience"
        value = var.auth0_audience
      }

      # Required for Aspire to know it's in a production-like env if needed,
      # though it's standard ASP.NET Core.
      env {
        name  = "ASPNETCORE_ENVIRONMENT"
        value = "Production"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      client,
      client_version,
    ]
  }
}

# Allow unauthenticated access (public API)
resource "google_cloud_run_v2_service_iam_member" "public_access" {
  location = google_cloud_run_v2_service.server.location
  name     = google_cloud_run_v2_service.server.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
