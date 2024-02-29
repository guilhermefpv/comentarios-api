resource "aws_cloudwatch_log_group" "my_ecs_service_log_group" {
  name = "my-ecs-service-loggroup"
}

resource "aws_ecs_cluster" "my_ecs_cluster" {
  name = "my-ecs-cluster"
}

resource "aws_ecs_service" "my_ecs_service" {
  name                               = "my-ecs-service"
  cluster                            = aws_ecs_cluster.my_ecs_cluster.id
  task_definition                    = aws_ecs_task_definition.main_task_definition.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_services_sg.id]
    subnets          = module.vpc.private_subnets
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.my_ecs_target_group.arn
    container_name   = var.app_name
    container_port   = var.container_port
  }
}

# Create an ECS task definition
resource "aws_ecs_task_definition" "main_task_definition" {
  family                   = "my-task-definition"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 256

  container_definitions = templatefile("containers/task.tpl.json",
    { CONTAINER_PORT              = var.container_port,
      REGION                      = var.region,
      LOG_GROUP                   = aws_cloudwatch_log_group.my_ecs_service_log_group.name,
      APP_NAME                    = var.app_name,
  })
}

# Create an ECS task definition Grafana
# resource "aws_ecs_task_definition" "grafana_task_definition" {
#   family                   = "grafana"
#   requires_compatibilities = ["FARGATE"]
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   task_role_arn            = aws_iam_role.ecs_task_role.arn
#   network_mode             = "awsvpc"
#   cpu                      = 256
#   memory                   = 512

#   container_definitions = templatefile("containers/task.tpl.json",
#     { CONTAINER_PORT              = 3000,
#       REGION                      = var.region,
#       LOG_GROUP                   = aws_cloudwatch_log_group.my_ecs_service_log_group.name,
#       APP_NAME                    = "grafana",
#   })
# }

# resource "aws_ecs_service" "grafana" {
#   name                               = "grafana"
#   cluster                            = aws_ecs_cluster.my_ecs_cluster.id
#   task_definition                    = aws_ecs_task_definition.grafana_task_definition.arn
#   desired_count                      = 1
#   deployment_minimum_healthy_percent = 50
#   deployment_maximum_percent         = 200
#   launch_type                        = "FARGATE"
#   scheduling_strategy                = "REPLICA"

#   network_configuration {
#     security_groups  = [aws_security_group.ecs_services_sg.id]
#     subnets          = module.vpc.private_subnets
#     assign_public_ip = true
#   }

#   # load_balancer {
#   #   target_group_arn = aws_alb_target_group.my_ecs_target_group.arn
#   #   container_name   = var.app_name
#   #   container_port   = var.container_port
#   # }
# }