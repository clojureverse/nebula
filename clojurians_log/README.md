## Clojurians Log

This deploys the [clojurians-log](https://github.com/clojureverse/clojurians-log-app) app onto Exoscale.

Initially its setup using [Terraform](https://www.terraform.io/) and provisioned by [Ansible](https://www.ansible.com/).

This is a work in progress and is subject to significant changes over time.

### Any and all contributions is most welcome!

## How to use it

- Get an account on Exoscale for the org. Contact @plexus or @victorb or @lispyclouds for this.
- Create your own SSH keypair on the Console: [guide](https://community.exoscale.com/documentation/compute/ssh-keypairs/)
- Install Terraform v0.11+.
- Download the latest Exoscale terraform provider for your OS from [here](https://github.com/exoscale/terraform-provider-exoscale/releases).
- Decompress the archive and follow [the plugin installation](https://www.terraform.io/docs/configuration/providers.html#third-party-plugins).
- Clone this repo.
- In the clojurians_log dir:
  - Run `export TF_VAR_exoscale_api_key=$(The API key here)`
  - Run `export TF_VAR_exoscale_secret_key=$(The secret key here)`
  - Run `export TF_VAR_exoscale_ssh_keypair_name=$(The key pair you created)`
  - Run:
      ```
      terraform init \
        -backend-config="access_key=${TF_VAR_exoscale_api_key}" \
        -backend-config="secret_key=${TF_VAR_exoscale_secret_key}"
      ```
  - Run `terraform plan -out plan`
  - Make sure all looks good.
  - Run `terraform apply plan`
  - To destroy: `terrafrom destroy`
