# HostingProject
Solution for the Cloud Deployment and Hosting Project.
A live version can be accessed at http://staticwebsite.permacrypt.com/

## Setting Up
The following tools are required to deploy this solution:
- Terraform binary

## Deploying Manually
Use these commands to setup and deploy the solution:
```
export AWS_ACCESS_KEY_ID=********
export AWS_SECRET_ACCESS_KEY=********
```
```
terraform get
```
```
terraform init
```
```
terraform plan
```
```
terraform apply
```

## Deploying Automatically
On a commit to the terraform/* directory, the terraform code will automatically be deployed using the configured AWS credentials in the Git Repo's secrets.

## Further Information
For more information about this project please see the following files:
- AWS Architecture Diagram.png
- Solution Overview.pdf
- terraform/modules/static_hosting/README.md
