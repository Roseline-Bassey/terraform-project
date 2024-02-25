resource "aws_lb" "loadbalancer" {
  name               = "elb-asg"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ssh.id]
  subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id,  aws_subnet.subnet_3.id]
  depends_on         = [aws_internet_gateway.main]
}

resource "aws_lb_target_group" "alb" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "app-server" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb.arn
  }
}