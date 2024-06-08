provider "aws" {
  region = "us-west-2"
}

resource "aws_ecs_cluster" "hello_world_cluster_1" {
  name = "hello-world-cluster_1"
}

resource "aws_ecs_task_definition" "hello_world_task_1" {
  family                = "hello-world-task_1"
  requires_compatibilities = ["FARGATE"]
  network_mode          = "awsvpc"
  cpu                   = "256"
  memory                = "512"

  container_definitions = jsonencode([
    {
      name      = "hello-world"
      image     = "sonal10/hello-world-nodejs_1:latest"
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

resource "aws_ecs_service" "hello_world_service_1" {
  name            = "hello-world-service_1"
  cluster         = aws_ecs_cluster.hello_world_cluster_1.id
  task_definition = aws_ecs_task_definition.hello_world_task_1.arn
  desired_count   = 1
  launch_type     = "FARGATE"


 network_configuration {
   subnets = ["subnet-003881cba63e2795f"]
   security_groups = ["sg-0b80b497c45782089"] 
   } 

}
