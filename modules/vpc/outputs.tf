#################################################################################
# Outputs
#################################################################################

output "vpc_id" {
  value = "${element(concat(aws_vpc.this.*.id, list("")), 0)}"
}

output "public_subnets" {
  value = "${aws_subnet.public.*.id}"
}

output "private_subnets" {
  value = "${aws_subnet.private.*.id}"
}

output "route_tables" {
  value = "${concat(aws_route_table.private.*.id, list(aws_route_table.public.id))}"
}

output "route_tables_private" {
  value = "${aws_route_table.private.*.id}"
}

output "route_table_public" {
  value = "${aws_route_table.public.id}"
}
