resource "aws_security_group" "assignment-alb-sg" {
  vpc_id = data.aws_vpc.vpc.id
  name   = "${local.env}-${local.application}-alb"
}

resource "aws_security_group_rule" "assignment-alb-allow-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.assignment-alb-sg.id
}

resource "aws_security_group_rule" "assignment-alb-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "All"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.assignment-alb-sg.id
}

resource "aws_security_group" "assignment-alb-sg-containers" {
  vpc_id = data.aws_vpc.vpc.id
  name   = "${local.env}-${local.application}-containers"
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "All"
    # Only allowing traffic in from the load balancer security group
    security_groups = [aws_security_group.assignment-alb-sg.id]
  }

  egress {
    from_port = 0    # Allowing any incoming port
    to_port   = 0    # Allowing any outgoing port
    protocol  = "All" # Allowing any outgoing protocol 
    #security_groups = [aws_security_group.assignment-alb-sg.id]
    cidr_blocks = ["0.0.0.0/0"]
  }
}
