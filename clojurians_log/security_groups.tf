resource "exoscale_security_group" "clojurians_log" {
  name = "clojurians_log"
  description = "Security Group for Clojurians Log"
}

resource "exoscale_security_group_rules" "clojurians_log" {
  security_group_id = "${exoscale_security_group.clojurians_log.id}"

  ingress {
    description = "Ping"
    protocol = "ICMP"
    icmp_type = 8
    icmp_code = 0
    cidr_list = [
      "0.0.0.0/0"]
  }

  ingress {
    description = "Ping6"
    protocol = "ICMPv6"
    icmp_type = 128
    icmp_code = 0
    cidr_list = [
      "::/0"]
  }

  ingress {
    description = "SSH"
    protocol = "TCP"
    ports = [
      "22"]
    cidr_list = [
      "0.0.0.0/0",
      "::/0"]
  }

  ingress {
    description = "HTTP"
    protocol = "TCP"
    ports = [
      "80"]
    cidr_list = [
      "0.0.0.0/0",
      "::/0"]
  }

  ingress {
    description = "HTTPS"
    protocol = "TCP"
    ports = [
      "443"]
    cidr_list = [
      "0.0.0.0/0",
      "::/0"]
  }
}
