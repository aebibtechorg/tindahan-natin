variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "Google Cloud Region"
  type        = string
  default     = "asia-southeast1"
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token with R2 permissions"
  type        = string
  sensitive   = true
}

variable "postgres_connection_string" {
  description = "Connection string for the external PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "redis_connection_string" {
  description = "Connection string for the external Redis cache"
  type        = string
  sensitive   = true
}

variable "auth0_domain" {
  description = "Auth0 Domain"
  type        = string
}

variable "auth0_audience" {
  description = "Auth0 Audience"
  type        = string
}

variable "auth0_client_id" {
  description = "Auth0 Client ID (optional for server, but good to have)"
  type        = string
  default     = ""
}

variable "r2_bucket_name" {
  description = "Name of the Cloudflare R2 bucket"
  type        = string
  default     = "tindahannatin-products"
}

variable "r2_access_key" {
  description = "Cloudflare R2 Access Key"
  type        = string
  sensitive   = true
}

variable "r2_secret_key" {
  description = "Cloudflare R2 Secret Key"
  type        = string
  sensitive   = true
}
