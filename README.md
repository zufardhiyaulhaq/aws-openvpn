# AWS OpenVPN
Spine Instance in AWS & automatically configure OpenVPN.

### Requirement:
- terraform
- ansible
- aws-cli

### Installation
- setup aws credential & profile
- change variable in `terraform/terraform.tfvars`
```bash
vi terraform/terraform.tfvars
```
- provision instance with terraform
```bash
terraform init
terraform validate
terraform apply
```
- run ansible
```
cd ansible/
ansible-playbook -i hosts/hosts.ini setup.yml
ansible-playbook -i hosts/hosts.ini add_client.yml
```
- ovpn generated in `fetched_creds`, use `*-pki-embedded.ovpn` for simplicity.
- use password generated in *_pk_pass.txt`

ansible fork & modify from [this repository](https://github.com/BastiPaeltz/ansible-openvpn)
