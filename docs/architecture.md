# EpicBook AWS Two-Tier Architecture

## 1. Overview

EpicBook is deployed on AWS using a two-tier architecture that separates the web/application tier from the database tier.

The infrastructure is provisioned using Terraform, while Ansible automates Linux server configuration, Nginx setup, and application deployment.

The architecture is designed to separate application processing from data storage, restrict database access, and make infrastructure deployment repeatable.

## 2. Architecture Diagram
    
![architecture-diagram](./images/)


## 3. Architecture Components

### 3.1 AWS VPC and Networking

The VPC provides the network boundary for the EpicBook application deployment.

Its networking resources define how the application server and database communicate, and how permitted traffic reaches the application.

The Terraform networking module is responsible for the networking resources defined in the project, such as:

- VPC and subnet configuration.
- Routing and internet connectivity, where configured.
- Security groups and their traffic rules.

### 3.2 Web/Application Tier — Amazon EC2

The EC2 instance runs the Linux environment used to host EpicBook.

The server hosts the application and the web server components configured through Ansible.

**Nginx**

    Nginx receives HTTP requests and forwards them to the application when configured as a reverse proxy. It can also handle web-server responsibilities such as serving static content.

**Node.js and PM2**

    Node.js runs the EpicBook application. PM2 manages the Node.js process, helping keep the application running and providing process-management capabilities.

``Ansible automates the relevant server configuration and application deployment tasks.``

### 3.3 Database Tier — Amazon RDS for MySQL

Amazon RDS for MySQL provides the database service used by EpicBook.

The database is placed in private database subnets so that it is not directly exposed to the public internet through those subnets.

The database security group should allow MySQL traffic on TCP port 3306 only from the authorized application tier, using the EC2 security group as the source where configured.

Database credentials must be protected and should not be embedded in source code or committed in plaintext.

### 3.4 Security Groups

Security groups act as virtual firewalls for the AWS resources.

The intended access model is:

- Allow only the required inbound web traffic to the application server.
- Permit administrative SSH access only from authorized sources, if SSH is used.
- Permit database connections from the authorized application server security group.
- Avoid public inbound access to the RDS database.

The actual rules should be verified in the Terraform configuration.

## 4. Application Request Flow

The expected request flow is:

1. A user accesses the EpicBook application through its configured endpoint.
2. The request reaches the EC2-hosted web server through the configured network path.
3. Nginx forwards application requests to the Node.js application.
4. The application connects to Amazon RDS for MySQL when database operations are required.
5. The application processes the request and returns a response through Nginx to the user.

The database connection should use the RDS endpoint and the credentials configured for the application.

## 5. Infrastructure Provisioning with Terraform

Terraform provisions and manages the AWS resources defined by the infrastructure configuration.

The project separates infrastructure responsibilities into three modules.

|Module| Responsibility|
|-------|----------------|
|networking| Network resources and connectivity|
|compute| EC2 application server resources and related configuration|
|database| RDS database resources and associated configuration|

The root Terraform configuration composes these modules into the overall infrastructure.

This separation improves readability, maintainability, and the potential for reuse.

## 6. Configuration Management with Ansible

Ansible configures the target Linux server and automates application deployment.

The project contains the following roles:

|Role| Responsibility|
|-------|------------|
|common| Shared Linux server configuration|
|nginx| Nginx installation and configuration|
|epicbook| EpicBook application deployment|

The "site.yml" playbook orchestrates the roles according to the project's Ansible configuration.

Ansible Vault is used to encrypt sensitive variables. The vault password should be supplied securely at runtime and must not be committed to the repository.

## 7. Deployment Workflow

The deployment process is divided into two main stages.

- [x] Stage 1: Infrastructure provisioning

Terraform initializes the working directory, validates the configuration, creates an execution plan, and provisions the AWS resources after the plan has been reviewed.

- [x] Stage 2: Server configuration and application deployment

Ansible connects to the target EC2 instance, applies the configured roles, configures Nginx, and deploys the EpicBook application.

Separating these stages makes infrastructure changes easier to review independently of application configuration changes.

## 8. Security Considerations

The deployment follows these security principles:

- Restrict network access through security groups.
- Keep the RDS database out of direct public access.
- Allow database connections only from authorized application resources.
- Protect sensitive Ansible variables with Ansible Vault.
- Never commit plaintext passwords, vault password files, SSH private keys, or cloud credentials.
- Avoid committing Terraform state files and saved plans to a public repository.
- Apply least-privilege IAM permissions.
- Review Terraform plans before applying changes.

These controls should be evaluated against the actual deployed configuration.

## 9. Verification

After deployment, verify the following:

- The EC2 instance is running and reachable through the intended access path.
- Nginx is active and using the expected configuration.
- The Node.js application is running under PM2.
- The application responds through its configured endpoint.
- The application can establish a connection to RDS MySQL.
- Database access is restricted to authorized sources.
- Terraform and Ansible complete their respective operations successfully.



## 10.  Potential Improvements

Future enhancements may include:

- CloudWatch metrics, dashboards, and alarms.
- Automated Terraform validation and security scanning in CI/CD.
- Automated testing of Ansible roles and playbooks.
- Improved secret management and access control.
- Documented backup and recovery procedures.
- Automated application health checks and deployment verification.

Only describe an enhancement as completed after it has been implemented and verified.