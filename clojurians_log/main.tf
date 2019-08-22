provider "exoscale" {
  version = "~> 0.10"
  key = "${var.exoscale_api_key}"
  secret = "${var.exoscale_secret_key}"
}

data "template_file" "userdata" {
  template = "${file("userdata.sh.tmpl")}"
  vars = {
    # For development / testing, use (uncomment) the lines below
    # ansible_playbook_params = "--extra-vars \"ansible_python_interpreter=/usr/bin/python3 clojurians_app_fqdn=clojurians-log-staging.clojureverse.org use_demo_logs=true acme_sh_default_staging=true acme_sh_default_force_issue=true\""
    # git_clone_params = "--single-branch --branch exoscale-deploy"
    # The following can be used for production
    ansible_playbook_params = "--extra-vars \"ansible_python_interpreter=/usr/bin/python3\""
    git_clone_params = "--single-branch --branch exoscale-deploy"
  }
}

# TODO: It would be useful to have the instance name and the state to be
# parameterized so that you could use this same terraform file for the
# staging server and the production server.
resource "exoscale_compute" "clojurians_log" {
  display_name = "clojurians-log"
  template = "Linux Ubuntu 18.04 LTS 64-bit"
  zone = "de-fra-1"
  size = "Large"
  disk_size = 10
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
