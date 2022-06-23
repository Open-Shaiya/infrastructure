# OpenShaiya Infrastructure

This repository contains the machine infrastructure and configuration for the OpenShaiya services.

---
## Terraform

Machines are provisioned on AWS via Terraform. This requires that the [AWS CLI][aws-cli] is installed, and the
following environment variables be set:

```
AWS_SECRET_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
```
---
## Ansible

Once the machines are created with Terraform, we can configure aspects of the environment with Ansible.

Install Ansible dependencies by executing:
```
pip install -r ansible/requirements.txt
ansible-galaxy collection install -r ansible/requirements.yml
```

---
## Usage

Provisioning the infrastructure:
`terraform -chdir=terraform apply`

[aws-cli]: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html