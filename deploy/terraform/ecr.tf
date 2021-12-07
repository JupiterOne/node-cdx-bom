resource "aws_ecr_repository" "node-cdx-bom" {
  name                 = "node-cdx-bom"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

#   TODO: Understand the value in AES256 vs. KMS
  encryption_configuration {
      encryption_type = "AES256"
  }
}