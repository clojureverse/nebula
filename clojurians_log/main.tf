provider "exoscale" {
  version = "~> 0.10"
  key = "${var.exoscale_api_key}"
  secret = "${var.exoscale_secret_key}"
}

resource "exoscale_compute" "clojurians_log" {
  display_name = "clojurians-log"
  template = "Linux Ubuntu 18.04 LTS 64-bit"
  zone = "de-fra-1"
  size = "Micro"
  disk_size = 10
  key_pair = "${var.exoscale_ssh_keypair_name}"

  security_groups = [
    "${exoscale_security_group.clojurians_log.name}",
  ]
}
