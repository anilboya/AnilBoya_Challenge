output "elb_dns_name" {
  value = "${aws_elb.web_elb.dns_name}"
}
output "elb_dns_zone_id" {
  value = "${aws_elb.web_elb.zone_id}"
}
