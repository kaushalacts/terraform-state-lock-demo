output "instance_ids" {
  value       = [aws_instance.demo.id]
  description = "IDs of the created EC2 instances"
}

output "instance_public_ips" {
  value       = [aws_instance.demo.public_ip]
  description = "Public IP addresses of the instances"
}

output "instance_states" {
  value       = [aws_instance.demo.instance_state]
  description = "Current states of the instances"
}

output "random_string" {
  value       = random_string.demo.result
  description = "Random string for demo purposes"
}

output "deployment_timestamp" {
  value       = timestamp()
  description = "When this configuration was last applied"
}
