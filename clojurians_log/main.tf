locals {
  instance_name = "${terraform.workspace == "default" ? "clojurians-log" : terraform.workspace}"
}

provider "exoscale" {
  version = "~> 0.10"
  key = "${var.exoscale_api_key}"
  secret = "${var.exoscale_secret_key}"
}

provider "cloudflare" {
  version = "~> 1.17"

  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_api_key}"
}

provider "template" {
   version = "~> 2.1"
}

data "template_file" "userdata" {
  template = "${file("userdata.sh.tmpl")}"
  vars = {
    # For development / testing, use (uncomment) the lines below
    # ansible_playbook_params = "--extra-vars \"ansible_python_interpreter=/usr/bin/python3 clojurians_app_fqdn=clojurians-log-staging.clojureverse.org use_demo_logs=true acme_sh_default_staging=true acme_sh_default_force_issue=true\""
    # git_clone_params = "--single-branch --branch exoscale-deploy"
    # The following can be used for production
    ansible_playbook_params = "--extra-vars \"ansible_python_interpreter=/usr/bin/python3\" --extra-vars \"clojurians_app_fqdn=${local.instance_name}.clojureverse.org\""
    git_clone_params = "--single-branch --branch exoscale-deploy"
  }
}

resource "exoscale_compute" "clojurians_log" {
  display_name = "${local.instance_name}"
  template = "Linux Ubuntu 18.04 LTS 64-bit"
  zone = "ch-gva-2"
  size = "Large"
  disk_size = 50
  key_pair = "${var.exoscale_ssh_keypair_name}"
  user_data = "${data.template_file.userdata.rendered}"

  security_groups = [
    "${exoscale_security_group.clojurians_log.name}",
  ]
}

output "ip_address" {
  value = exoscale_compute.clojurians_log.ip_address
}

output "username" {
  value = exoscale_compute.clojurians_log.username
}

resource "cloudflare_record" "clojurians_log" {
  domain = "clojureverse.org"
  name   = "${local.instance_name}"
  value  = "${exoscale_compute.clojurians_log.ip_address}"
  type   = "A"
}
