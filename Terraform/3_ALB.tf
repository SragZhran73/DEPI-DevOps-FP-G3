# resource "aws_lb" "alb" {
#   name               = "cluster-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = [aws_subnet._prSubnet_1.id, aws_subnet._prSubnet_2.id]

#   enable_deletion_protection = false
# }

# resource "aws_lb_target_group" "tg" {
#   vpc_id   = aws_vpc.eks_vpc.id
#   name     = "my-target-group"
#   port     = 80
#   protocol = "HTTP"
# }

# resource "aws_lb_listener" "frontend_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = 80
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg.arn
#   }
# }

# output "load_balancer_DNS" {
#   value = aws_lb.alb.dns_name
# }