resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = module.vpc.vpc_id
  description = "Allow inbound traffic from port 80 and 443, to the ALB"
 
  ingress {
   protocol         = "tcp"
   from_port        = 80
   to_port          = 80
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
 
  ingress {
   protocol         = "tcp"
   from_port        = 443
   to_port          = 443
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "ecs_services_sg" {
  name   = "ecs-service-sg"
  vpc_id = module.vpc.vpc_id
  description = "Allow inbound access from the ALB only"
 
  ingress {
   protocol         = "tcp"
   from_port        = 80
   to_port          = 80
   security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
   protocol         = "tcp"
   from_port        = 8080
   to_port          = 8080
   security_groups = [aws_security_group.alb_sg.id]
  }
   
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
  }
}
