<div align="center">
  <img src="docs/images/epicbook-logo.svg" alt="EpicBook Logo" width="360"/>

  # EpicBook — Two-Tier Application Deployment

  **Infrastructure as Code · Configuration Management · Automated Deployment**

  *Automated infrastructure provisioning with Terraform and configuration/application deployment with Ansible on AWS.*

  [![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
  [![Terraform](https://img.shields.io/badge/Terraform-Infrastructure_as_Code-7B42BC?logo=terraform&logoColor=white)](https://developer.hashicorp.com/terraform)
  [![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible&logoColor=white)](https://docs.ansible.com/)
  [![Linux](https://img.shields.io/badge/Linux-Server-FCC624?logo=linux&logoColor=black)](https://www.linux.org/)
  [![Nginx](https://img.shields.io/badge/Nginx-Web_Server-009639?logo=nginx&logoColor=white)](https://nginx.org/)
  [![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

  [GitHub](https://github.com/tobilee10) · [LinkedIn](https://www.linkedin.com/in/oluwatobiloba-adeje-2572b42a6)
</div>

---

## Overview

This project demonstrates the deployment of a two-tier **EpicBook** application on AWS using **Terraform** and **Ansible**.

Terraform provisions the cloud infrastructure, while Ansible automates server configuration and application deployment. The infrastructure code is organized into separate networking, database, and compute modules, and the Ansible configuration uses modular roles to separate common server setup, EpicBook deployment, and Nginx reverse proxy configuration.

The project demonstrates practical DevOps skills in Infrastructure as Code (IaC), configuration management, Linux system administration, cloud networking, application deployment, and secure secret management.

---

## Project Objectives

- Provision AWS infrastructure using modular Terraform templates.
- Organize infrastructure into modular components (`networking`, `database`, and `compute`).
- Automate Linux server configuration and service hardening using Ansible.
- Deploy and configure the EpicBook application using Ansible playbooks, roles, and handlers.
- Configure Nginx as a reverse proxy and web server.
- Protect sensitive configuration variables using **Ansible Vault**.
- Document deployment, verification, troubleshooting, and maintenance procedures.

---

## Architecture

The application follows a standard **two-tier design**:

1. **Web / Application Tier**: Hosts the EpicBook Node.js application process and Nginx reverse proxy to handle incoming public requests.
2. **Database Tier**: Stores persistent application data (AWS RDS / MySQL) in private subnet boundaries, isolated from public access.

Terraform manages the complete infrastructure lifecycle, while Ansible configures the target compute nodes and manages application deployments.

### Architecture Diagram

![EpicBook Two-Tier AWS Architecture](docs/images/architecture.png)



---

## Technology Stack

| Technology | Purpose |
| :--- | :--- |
| **AWS** | Cloud infrastructure provider (VPC, EC2, RDS, Security Groups) |
| **Terraform** | Infrastructure as Code (IaC) provisioning and lifecycle management |
| **Ansible** | Configuration management, service configuration, and deployment automation |
| **Linux (Ubuntu)** | Server operating system and administration |
| **Nginx** | Web server and reverse proxy |
| **Git & GitHub** | Version control and documentation hosting |
| **Ansible Vault** | Encrypted variable and secret protection |

---

## Repository Structure

```text
terraform-ansible-epicbook/
├── ansible/
│   ├── ansible.cfg
│   ├── group_vars/
│   │   └── web/
│   │       ├── web.yml
│   │       └── vault.yml
│   ├── inventory.ini
│   ├── roles/
│   │   ├── common/
│   │   │   ├── handlers/
│   │   │   ├── tasks/
│   │   │   └── README.md
│   │   ├── epicbook/
│   │   │   ├── tasks/
│   │   │   └── README.md
│   │   └── nginx/
│   │       ├── handlers/
│   │       ├── tasks/
│   │       ├── templates/
│   │       └── README.md
│   └── site.yml
├── terraform/
│   └── aws/
│       ├── modules/
│       │   ├── networking/
│       │   ├── database/
│       │   └── compute/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── providers.tf
│       └── versions.tf
├── docs/
│   ├── images/
│   │   ├── epicbook-logo.svg
│   │   └── architecture.png
│   ├── architecture.md
│   ├── deployment-guide.md
│   └── troubleshooting.md
├── .gitignore
├── LICENSE
└── README.md
```



## Deployment Workflow

### Prerequisites

Before starting, ensure you have:

- An AWS account with appropriate IAM permissions.
- AWS CLI configured with credentials.
- Terraform installed.
- Ansible installed.
- SSH access to the target Linux server.
- Network connectivity between the Ansible control machine and the target server.

### 1. Provision Infrastructure with Terraform

Navigate to the Terraform root directory:

    cd terraform/

Initialize the working directory:

    terraform init

Format and validate the configuration:

    terraform fmt -check -recursive
    terraform validate

Review the proposed changes:

    terraform plan

Apply the changes to provision cloud infrastructure

    terraform apply

### NB: AWS Free Tier Notice & Cost Warning:

- [x] This project is designed to be compatible with AWS Free Tier limits (utilizing eligible resources such as t2.micro/t3.micro instances and standard RDS micro classes) to make optimal use of free tier credits.

- [x] However, provisioning cloud infrastructure still carries potential costs if usage limits are exceeded or if resources are left running indefinitely. Always review terraform plan, monitor your AWS billing dashboard, and run terraform destroy when you are finished testing.

### 2. Verify the Ansible Inventory

Return to the project root directory and test connection to provisioned hosts:

Verify Inventory grouping

    ansible-inventory -i ansible/inventory/inventory.ini --list

Test connectivity to the web group server

    ansible -i ansible/inventory/inventory.ini web -m ping



### 3. Validate the Ansible Playbook

Run a syntax check across playbooks and roles before deployment

    ansible-playbook -i ansible/inventory/inventory.ini ansible/site.yml --syntax-check

### 4. Deploy the Application

Run the playbook and enter the Ansible Vault password when prompted:

    ansible-playbook -i ansible/inventory/inventory.ini ansible/site.yml -ask-vault-pass

The playbook should execute the configuration and deployment tasks defined by your existing Ansible roles.

### 5. Verify the Deployment

After deployment, verify the following:

- Ansible completes the expected tasks successfully.
- The application process is running.
- Nginx is running and using the intended configuration.
- The application responds through the intended endpoint.
- The application can reach the database.
- Network security rules restrict access to the required ports and sources.

Detailed execution logs and verification tests are documneted in "docs/deployment-guide.md".

Security Practices

Security is an important part of this project.

- Use least-privilege IAM permissions.
- Restrict inbound traffic through appropriately configured security groups.
- Keep the database inaccessible from unauthorized sources.
- Store sensitive Ansible variables in an encrypted Vault file.
- Never commit vault passwords, SSH private keys, or plaintext credentials.
- Exclude Terraform state, plan files, and sensitive variable files from Git.
- Review Terraform plans before applying infrastructure changes.
- Rotate credentials immediately if they are exposed.

Important: ".gitignore" does not remove files already tracked by Git. Verify the repository history before publishing it publicly.

### Documentation

Additional project documentation is available here:

- "Architecture" (docs/architecture.md) — infrastructure design and request flow.
- "Deployment Guide" (docs/deployment-guide.md): Step-by-step execution, playbook runs, and verification steps.
- "Troubleshooting" (docs/troubleshooting.md): Common error resolution for terraform, Ansible, Nginx, and RDS connectivit.

### Lessons and Skills Demonstrated

This project provides evidence of hands-on experience with:

- Infrastructure as Code: Writeing modula, scalable Terraform configurations.
- Configuration Management: Designing reusable Ansible roles, handlers, templates, and vault management
- Cloud Architecture: Segmenting public/private networking on AWS using VPCs, subnets, and security groups.
- Linux Administration: managing systemd services, wweb proxying, and operational monitoring.
- DevOps Best Practices: Decoupling infrastructure provisioning from application deployment workflows

### Future Improvements

Potential enhancements include:

- Add Terraform validation and security scanning (trivy) to a CI/CD pipeline (GitHub Actions/ Azure DevOps).
- Introduce automated Ansible testing.
- Implement CloudWatch monitoring, dashboards, and alarms.
- Improve infrastructure state management and access controls.
- Add automated deployment verification.
- Record a short walkthrough demonstrating the infrastructure and deployment workflow.



Author

Oluwatobiloba Adeje

DevOps Engineer & Linux System Administrator

- GitHub: "tobilee10" (https://github.com/tobilee10)
- LinkedIn: "Oluwatobiloba Adeje" (https://www.linkedin.com/in/oluwatobiloba-adeje-2572b42a6)

License

This project is licensed under the MIT License. See the "LICENSE" (LICENSE) file for details.