# https://docs.gitlab.com/ee/ci/cloud_deployment/ecs/deploy_to_aws_ecs.html

Create an infrastructure and initial deployment on AWS
For deploying an application from GitLab, you must first create an infrastructure and initial deployment on AWS. This includes an ECS cluster and related components, such as ECS task definitions, ECS services, and containerized application image.

  #execution_role_arn = "arn:aws:iam::532199187081:role/ecsTaskExecutionRole"