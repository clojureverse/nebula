## Clojurians Log

This deploys the [clojurians-log](https://github.com/clojureverse/clojurians-log-app) app onto Exoscale.

Initially its setup using [Terraform](https://www.terraform.io/) and provisioned by [Ansible](https://www.ansible.com/).

This is a work in progress and is subject to significant changes over time.

### Any and all contributions is most welcome!

## How to use Terraform

- Get an account on Exoscale for the org.
  Contact either of the [maintainers](https://github.com/clojureverse/nebula#maintainers)
  for this.
- Create your own SSH keypair on the Console: [guide](https://community.exoscale.com/documentation/compute/ssh-keypairs/)
- Install Terraform v0.11+.
- Download the latest Exoscale terraform provider for your OS from [here](https://github.com/exoscale/terraform-provider-exoscale/releases).
- Decompress the archive and follow [the plugin installation](https://www.terraform.io/docs/configuration/providers.html#third-party-plugins).
- Install [GPG](https://gnupg.org/download/)
- Send your GPG public key ID to either of the maintainers to be added to the secrets file.
- Clone this repo.
- In the clojurians_log dir:
  - Run `export TF_VAR_exoscale_api_key="The API key here"`
  - Run `export TF_VAR_exoscale_secret_key="The secret key here"`
  - In the `playbooks/vars` dir:
    - Run `export TF_VAR_exoscale_ssh_keypair_name="The key pair name you created"`
    - Run `gpg --decrypt clojurians_log_secrets.yml.gpg > clojurians_log_secrets.yml`
    - (Optional, for maintainers) Run:
      ```bash
      gpg --encrypt --recipient your_email \
                    --recipient others_emails \
                    ... all the other maintainers \
      clojurians_log_secrets.yml
      ```
      to produce a newly encrypted file and check it in. 
  - Run:
    ```bash
    terraform init \
      -backend-config="access_key=${TF_VAR_exoscale_api_key}" \
      -backend-config="secret_key=${TF_VAR_exoscale_secret_key}"
    ```
  - Run `terraform plan -out plan`
  - Make sure all looks good.
  - Run `terraform apply plan`
  - To destroy: `terraform destroy`

## How to use Vagrant

- [Vagrant](https://www.vagrantup.com/) is a tool to build and provision virtual machines
  (VMs). Mostly used for building VMs locally. We are using it to first
  build and provision a local Ubuntu VM, so that we can test out the
  Ansible scripts without incurring costs on Exoscale. More rationale
  is at the [Why Vagrant? page](https://www.vagrantup.com/intro/index.html).
- Generally, it's best to use the package manager of your OS to install programs.
  But sometimes, the package managers are not always up-to-date,
  so best to check with the main website and verify the versions.
- Before downloading Vagrant, you will likely need a "provider" for
  the virtual machine. The most common is [VirtualBox](https://www.virtualbox.org/).
  When downloading VirtualBox, please also install the appropriate "guest additions" or "extensions pack".
  This will allow easier access to host resources from the guest VM.
  - On Ubuntu or Debian Linux, you can install via `apt`.
	- `sudo apt install virtualbox`
	- `sudo apt install virtualbox-guest-additions-iso`
  - On Mac OS, you can install via the [brew](https://brew.sh/) package manager.
    - `brew cask install virtualbox`
	- `brew cask install virtualbox-extension-pack`
  - You can download VirtualBox from their [download page](https://www.virtualbox.org/wiki/Downloads).
- We are using [Ansible](https://www.ansible.com/) for provisioning the VM,
  so you'll have to install that as well. Check out the
  [installation page](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
  for instructions on installation.
- Download and install Vagrant on your local host.
  - On Ubuntu or Debian Linux, you can install via `apt`.
	- `sudo apt install vagrant`
  - On Mac OS, you can install via the [brew](https://brew.sh/) package manager.
    - `brew cask install vagrant`
  - You can download directly from the [Vagrant download page](https://www.vagrantup.com/downloads.html).
- To fire up a Vagrant host VM
  - `vagrant init`
  - `vagrant up`
- At that point, you should have a Vagrant VM provisioned and running.
  You can log into it using `vagrant ssh`.
- If you need to re-provision (for example, if you edit the Ansible scripts)
  you can use `vagrant provision`.
- To shut down the VM, use `vagrant halt`. 

## How to deploy the Clojurians-log app

- Deploy an instance of the server at Exoscale (using Terraform) or Vagrant.
- Clone the master branch of the clojurian-log-app to a local repository on your machine.
  - `git clone --single-branch --branch master https://github.com/clojureverse/clojurians-log-app`
  - `cd clojurians-log-app`
- Add a remote repo that points at the deployed instance with user `clojure_app`.
  The path to the repo is `/var/clojure_app/repo`.
  So, for a local vagrant instance you might use:
  - `git remote add vagrant ssh://clojure_app@127.0.0.1:2222/var/clojure_app/repo`
- You can now make changes (if any) to the local repo and when ready to deploy to vagrant, use:
  - `git push vagrant master`
- Then log into the vagrant guest as `clojure_app`.
- On the vagrant guest, connect to the app and load up the demo log files, then restart the app.
  - `echo '(use '"'"'clojurians-log.repl) (load-demo-data! "/var/clojure_app/logs/logs")' | nc -N localhost 50505`
  - `sudo systemctl restart clojure_app`
- On the host running vagrant, you can access the app at
  - `http://127.0.0.1:2200/`
