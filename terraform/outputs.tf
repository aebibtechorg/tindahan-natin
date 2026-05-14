output "cloud_run_url" {
  value = google_cloud_run_v2_service.server.uri
}

output "artifact_registry_repo" {
  value = google_artifact_registry_repository.repo.name
}

output "r2_bucket_name" {
  value = cloudflare_r2_bucket.products.name
}
