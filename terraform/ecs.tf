resource "aws_ecs_cluster" "ecs_cluster" {
  name = "webapp"
}

resource "aws_ecs_task_definition" "ecs_task" {
  family             = "ecs-task"
  network_mode       = "awsvpc"
  cpu                = 512
  memory             = 1024
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name  = "app"
    image = "${aws_ecr_repository.foo.repository_url}:latest"
    portMappings = [
      {
        hostPort      = 80
        containerPort = 80
        protocol      = "tcp"
      }
    ]
    environment = [
      { name = "DB_HOST",     value = aws_db_instance.db.address },
      { name = "DB_USER",     value = aws_db_instance.db.username },
      { name = "DB_PASSWORD", value = aws_db_instance.db.password }
    ]
    }

  ])
}

resource "aws_ecs_service" "ecs_service" {
  depends_on = [ aws_lb_listener.http ]
  name            = "webapp-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  launch_type     = "FARGATE"

  desired_count = 1

  network_configuration {
    subnets          = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "app"
    container_port   = 80
  }


}