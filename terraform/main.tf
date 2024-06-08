provider "aws" {
  region = "us-west-2"
}

resource "aws_ecs_cluster" "hello_world_cluster" {
  name = "hello-world-cluster"
}

resource "aws_ecs_task_definition" "hello_world_task" {
  family                = "hello-world-task"
  requires_compatibilities = ["FARGATE"]
  network_mode          = "awsvpc"
  cpu                   = "256"
  memory                = "512"

  container_definitions = jsonencode([
    {
      name      = "hello-world"
      image     = "sonal10/hello-world-nodejs:latest"
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "hello_world_service" {
  name            = "hello-world-service"
  cluster         = aws_ecs_cluster.hello_world_cluster.id
  task_definition = aws_ecs_task_definition.hello_world_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"


 network_configuration {
   subnets = ["subnet-003881cba63e2795f"]
   security_groups = ["sg-0b80b497c45782089"] 
   } 

}
