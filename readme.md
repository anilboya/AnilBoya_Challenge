# DevOps project to automate the deployment process of Scalable and Secure web application into AWS


##DevOps Project Scenario

For this project, please think about how you would architect a scalable and secure static web application in AWS or another IaaS provider.

Create and deploy a running instance of a web server using a configuration management tool of your choice. The web server should serve one page with the following content.

<title>Hello World</title>
# Hello World!
Secure this application and host such that only appropriate ports are publicly exposed and any http requests are redirected to https. This should be automated using a configuration management tool of your choice and you should feel free to use a self-signed certificate for the web server.

Develop and apply automated tests to validate the correctness of theserver configuration.

Express everything in code and provide your code via a Git repository in GitHub.


##Implementation

.  Install Terraform (https://www.terraform.io/intro/getting-started/install.html)
.  Add the AWS IAM AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to the environment variable
.  cd into the terraform folder and run the terraform plan and terraform apply command to launch the     scalable and secure web cluster over AWS.
.  Login into the AWS Console and the copy the AWS ELB endpoint (DNS Name) and run in the browser to test the website or test it with DNS Route53 Record set name.
. Clean up all the AWS resources once done with the lab by running the command terraform destroy and type yes at the prompt.

```
terraform destroy
Do you really want to destroy?
  Terraform will delete all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
```
Files

Main.tf -> Actual code to launch the web cluster
Variabes.tf -> File holds the variables to reference in the Main.tf
Userdatascript -> File holds the user data script, that's been referenced in the Main.tf
output.tf -> Prints the ELB DNS name and ELB Zone Id


# Validating Credit Card Numbers

. run Python code newcredit.py
