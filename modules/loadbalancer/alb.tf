# Create load balancing resource and associate it with both public subnets
resource "aws_alb" "lb-tf" {
  name = var.lb_name
  internal = var.internal
  load_balancer_type = var.lb_type
  security_groups = [
    var.aws_security_group]
  subnets = [
    var.sub1_id,
    var.sub2_id]

  tags = {
    Environment = "sandbox"
  }
}

# Create load balance target group on port 80
resource "aws_lb_target_group" "sub3_target" {
  name = var.lb_target_name
  port = var.target_port
  protocol = var.target_protocol
  vpc_id = var.aws_vpc
}

# Create load balance target group attachment pointing to EC2 instance in sub3
resource "aws_lb_target_group_attachment" "sub3_target_group" {
  target_group_arn = aws_lb_target_group.sub3_target.arn
  target_id = var.sub3_instance_id
  port = var.target_port
}

# Create load balance listener on port 80 with forward action
resource "aws_lb_listener" "lb-tf" {
  load_balancer_arn = aws_alb.lb-tf.arn
  port = "80"
  protocol = var.target_protocol

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.sub3_target.arn
  }
}