provider "exoscale" {
  version = "~> 0.10"
  key = "${var.exoscale_api_key}"
  secret = "${var.exoscale_secret_key}"
}

data "template_file" "userdata" {
  template = "${file("userdata.sh.tmpl")}"
}

resource "exoscale_compute" "clojurians_log" {
  display_name = "clojurians-log"
  template = "Linux Ubuntu 18.04 LTS 64-bit"
  zone = "de-fra-1"
  size = "Medium"
  disk_size = 10
  key_pair = "${var.exoscale_ssh_keypair_name}"
  user_data = "${data.template_file.userdata.rendered}"

  security_groups = [
    "${exoscale_security_group.clojurians_log.name}",
  ]
}
