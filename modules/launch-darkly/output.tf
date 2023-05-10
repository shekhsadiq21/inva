output "launch_darkly_environment_client_side_id" {
  value     = data.launchdarkly_environment.environments.client_side_id
  sensitive = true
}
