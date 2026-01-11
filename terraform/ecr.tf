resource "aws_ecr_repository" "foo" {
    name = "bar"
    image_tag_mutability = "MUTABLE"

    image_scanning_configuration {
      scan_on_push = true
    }
}

output "ecr_repository_url" {
  description = "Docker image repository URL"
  value       = aws_ecr_repository.foo.repository_url
}