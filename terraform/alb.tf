resource "aws_lb" "lb" {
    load_balancer_type = "application"
    subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_groups = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "target_group" {
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.ecs_vpc.id
    target_type = "ip"
    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 15
        timeout             = 3
        healthy_threshold   = 2
        unhealthy_threshold = 2      
    }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn

  port = 80

  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}