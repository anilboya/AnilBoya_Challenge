
provider "aws" {
  version = "~> 1.8"
  region  = "${var.region}"
}

variable "ami_instance_type" {
  default = "m5.2xlarge"
}

variable "image_id" {
  default = "ami-6d1c2007"
}
variable "asg_min_size" {
  default = 0
}

variable "asg_max_size" {
  default = 0
}

variable "asg_desired_capacity" {
  default = 0
}

variable "healthchk_port" {
        description = "The port the server will use for HTTP requests"
        default = 443
}

variable "ssl_certificate" {}




# availability zone
data "aws_availability_zones" "all" {}

#ASG

resource "aws_autoscaling_group" "web_asg" {
	launch_configuration = "${aws_launch_configuration.web_lc.id}"
	availability_zones = ["${data.aws_availability_zones.all.names}"]
  min_size           = "${var.asg_min_size}"
  max_size           = "${var.asg_max_size}"
  desired_capacity   = "${var.asg_desired_capacity}"

	load_balancers = ["${aws_elb.web_elb.name}"]
	health_check_type = "ELB"

	tag {
	 key = "Name"
	 value = "terraform_autoscaling"
	 propagate_at_launch = true

     }
}

#Launch configuration

resource "aws_launch_configuration" "web_lc" {
	      image_id = "${var.image_id}"
        instance_type = "${var.ami_instance_type}"
        security_groups = ["${aws_security_group.web_sg.id}"]
        key_name = "webadmin"
        user_data = "${file("userdatascript")}"
	lifecycle {
		create_before_destroy = true
	}
}

# Security group for ec2

resource "aws_security_group" "web_sg" {
	name = "web_sg"

        ingress {
                from_port = "22"
                to_port   = "22"
                protocol  = "tcp"
                cidr_blocks= ["0.0.0.0/0"]
                }
        ingress {
                from_port = "80"
                to_port   = "80"
                protocol  = "tcp"
                cidr_blocks= ["0.0.0.0/0"]
                }
        ingress {
                from_port = "443"
                to_port   = "443"
               protocol  = "tcp"
                cidr_blocks= ["0.0.0.0/0"]
                }
        egress {
                from_port = "0"
                to_port = "1000"
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
               }
	lifecycle {
		create_before_destroy = true
	}
}



# Elastic Load Balancer
resource "aws_elb" "web_elb" {
	name = "web-elb"
	security_groups = ["${aws_security_group.web-elb_sg.id}"]
	availability_zones = ["${data.aws_availability_zones.all.names}"]

	health_check {
		healthy_threshold = 2
		unhealthy_threshold = 10
		timeout = 3
		interval = 30
	#	target = "HTTP:80/index.html"
		target = "HTTPS:${var.healthchk_port}/index.html"
	}

	listener {
		lb_port = 80
		lb_protocol = "http"
		instance_port = "80"
		instance_protocol = "http"
	}
	listener {
         lb_port = 443
         lb_protocol = "https"
         instance_port = "443"
         instance_protocol = "https"
         ssl_certificate_id = "${var.ssl_certificate}"

	}

}

# Security group for ELB

resource "aws_security_group" "web-elb_sg" {
	name = "web-sg-elb"
	egress {
   		 from_port = 0
    		to_port = 0
    		protocol = "-1"
   		 cidr_blocks = ["0.0.0.0/0"]
  	}

	ingress {
                from_port = "80"
                to_port   = "80"
                protocol  = "tcp"
                cidr_blocks= ["0.0.0.0/0"]
                }
       ingress {
        from_port = "443"
        to_port   = "443"
        protocol  = "tcp"
        cidr_blocks= ["0.0.0.0/0"]
        }

}

# route53

data "aws_route53_zone" "selected" {
  name         = "boya.com."
  private_zone = true
}

resource "aws_route53_record" "route53terraform" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name = "webserver.boya.com"
  type = "A"
  ttl     = "300"
}
