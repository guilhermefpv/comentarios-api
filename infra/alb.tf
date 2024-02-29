resource "aws_lb" "main_lb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.vpc.public_subnets
 }

resource "aws_alb_target_group" "my_ecs_target_group" {
  name        = "my-app-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
 
  health_check {
   healthy_threshold   = "3"
   interval            = "30"
   protocol            = "HTTP"
   matcher             = "200"
   timeout             = "3"
   path                = "/"
   unhealthy_threshold = "2"
  }
} 

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main_lb.id
  port              = 80
  protocol          = "HTTP"
 
  default_action {
    target_group_arn = aws_alb_target_group.my_ecs_target_group.id
    type             = "forward"
  }
}

# outputs.tf

output "alb_hostname" {
  value = "${aws_lb.main_lb.dns_name}:3000"
}