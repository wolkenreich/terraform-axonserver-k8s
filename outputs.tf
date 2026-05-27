

output "axonserver_token" {
  value     = random_uuid.token.result
  sensitive = true
}
