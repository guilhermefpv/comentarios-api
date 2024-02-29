resource "aws_ecr_repository" "my_ecr_repository" {
  name                 = "comentarios-api"
  image_tag_mutability = "MUTABLE"
}