resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}

data "aws_vpc" "my_vpc" {
  default = true
}

data "aws_subnets" "my_subnets" {
    # filter {
    #     name = "vpc_id"
    #     values = [data.aws_vpc.my_vpc.id]
    # }

}

resource "aws_ecs_task_definition" "my_app" {
  family                   = "my-app"
  network_mode             = "awsvpc"
  
  container_definitions = jsonencode([{
    name  = "my-app-container"
    image = "rfojta/rfojta-covid-data:0.2"
    memory = 1024
    portMappings = [{
      containerPort = 5000     # Port inside the container
      hostPort      = 5000     # Port on the host
    }]
  }])
}

resource "aws_ecs_service" "my_app" {
  name            = "my-app-service"
  cluster         = aws_ecs_cluster.my_cluster.id # Replace with your ECS cluster name
  task_definition = aws_ecs_task_definition.my_app.arn
  launch_type     = "EC2"  # Use "FARGATE" for Fargate
  network_configuration {
     subnets = data.aws_subnets.my_subnets.ids
  }
  desired_count = 1
}

# Optional: Create an Application Load Balancer and Target Group
resource "aws_lb" "my_app" {
  name               = "my-app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets = data.aws_subnets.my_subnets.ids
  
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "my_app" {
  name     = "my-app-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = "vpc-615cf608"  # Replace with your VPC ID
}

resource "aws_lb_listener" "my_app" {
  load_balancer_arn = aws_lb.my_app.arn
  port              = 5000
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.my_app.arn
    type             = "forward"
  }
}
