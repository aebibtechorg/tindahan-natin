# Deployment Plan: Google Cloud Run + Cloudflare R2

## Objective
Set up a production deployment for the `TindahanNatin.Server` API to Google Cloud Run. The deployment will use an external PostgreSQL database, an external Redis cache, and Cloudflare R2 for S3-compatible object storage. Infrastructure will be provisioned using Terraform, and deployments will be automated via GitHub Actions using a Terraform-driven CI/CD approach.

## Background & Motivation
Currently, the application relies on .NET Aspire to orchestrate local development containers (Postgres, Redis, MinIO). For production, we need a robust, scalable, and automated deployment strategy. Google Cloud Run provides a serverless environment for the API, while Cloudflare R2 offers cost-effective S3-compatible storage. A Terraform-driven pipeline ensures that both infrastructure and application deployments are version-controlled and reproducible.

## Scope & Impact
*   **Infrastructure as Code**: Add Terraform configurations (`terraform/` folder) to manage GCP Artifact Registry, Google Cloud Run, and the Cloudflare R2 bucket.
*   **CI/CD**: Add a GitHub Actions workflow (`.github/workflows/deploy.yml`) to build the .NET application container, push it to Artifact Registry, and trigger `terraform apply` to deploy the new revision.
*   **Application Config**: Rely on Aspire's built-in support for connection strings provided via environment variables in production.

## Proposed Solution
1.  **Terraform Configuration**:
    *   Configure the `google` and `cloudflare` providers.
    *   Create a GCP Artifact Registry repository for Docker images.
    *   Create a Cloudflare R2 bucket.
    *   Define a Google Cloud Run service for `TindahanNatin.Server`, configuring environment variables to inject external dependencies (Postgres URL, Redis URL, Cloudflare R2 credentials, Auth0 settings).
2.  **Container Build**:
    *   Use .NET's native SDK container build feature (`dotnet publish -t:PublishContainer`) in the GitHub Action to produce the Docker image, avoiding the need for a manual `Dockerfile`.
3.  **GitHub Actions**:
    *   Authenticate to GCP using Workload Identity Federation (recommended) or a Service Account key.
    *   Build and push the image tagged with the Git commit SHA.
    *   Run `terraform apply` passing the new image tag and necessary secrets as variables.

## Alternatives Considered
*   **Split Deployment (gcloud deploy)**: We considered using Terraform only for base infrastructure and `gcloud run deploy` for image updates. This was rejected in favor of a Terraform-driven approach for a single source of truth.
*   **Managed GCP Databases**: We considered provisioning Google Cloud SQL and Memorystore via Terraform. This was rejected; the user opted to use external/third-party services for Postgres and Redis.

## Implementation Plan
1.  **Phase 1: Terraform Authoring**
    *   Create `terraform/main.tf`, `terraform/variables.tf`, and `terraform/outputs.tf`.
    *   Define the GCP Artifact Registry and Cloud Run service resources.
    *   Define the Cloudflare R2 bucket resource.
2.  **Phase 2: CI/CD Pipeline**
    *   Create `.github/workflows/deploy.yml`.
    *   Configure steps to setup .NET, authenticate to GCP, setup Terraform, publish the container, and run `terraform init`/`plan`/`apply`.
3.  **Phase 3: Documentation**
    *   Update `README.md` with deployment architecture details.

## Migration & Rollback
*   **Migration**: No existing production state to migrate. Initial deployment will create a new state file. It is recommended to use a remote backend (like Google Cloud Storage) for Terraform state.
*   **Rollback**: Since Terraform manages the Cloud Run revisions, rolling back involves either reverting the Git commit and letting CI/CD run, or running `terraform apply` locally with a previous image tag variable.

## Manual Preparations Required
Before the pipeline can run successfully, you will need to manually prepare the following:

1.  **Google Cloud Platform**:
    *   Create a GCP Project and link a Billing Account.
    *   Enable APIs: Cloud Run API, Artifact Registry API, Cloud Resource Manager API, IAM API.
    *   Create a Google Cloud Storage (GCS) bucket to store the Terraform state.
    *   Configure Workload Identity Federation for GitHub Actions (or generate a Service Account JSON key).
2.  **External Services**:
    *   Provision your external PostgreSQL database and obtain the connection string.
    *   Provision your external Redis cache and obtain the connection string.
3.  **Cloudflare**:
    *   Create a Cloudflare API Token with permissions to edit R2 buckets.
    *   Obtain your Cloudflare Account ID.
4.  **GitHub Repository Secrets**:
    *   `GCP_PROJECT_ID`
    *   `GCP_WIF_PROVIDER` and `GCP_WIF_SA` (if using WIF) OR `GCP_SA_KEY` (if using JSON key)
    *   `TF_STATE_BUCKET` (Name of the GCS bucket for Terraform state)
    *   `CLOUDFLARE_API_TOKEN`
    *   `CLOUDFLARE_ACCOUNT_ID`
    *   `POSTGRES_CONNECTION_STRING`
    *   `REDIS_CONNECTION_STRING`
    *   `R2_ACCESS_KEY`
    *   `R2_SECRET_KEY`
    *   `AUTH0_DOMAIN`
    *   `AUTH0_AUDIENCE`
    *   `AUTH0_CLIENT_ID` (If required by the server)
