This is a simple terraform that create an ec2 instance 
with 2 additional volumes for application code tree and logs.

This script also demonstrates how to pass terraform variables
to the userdata script (see DOMAIN and S3BUCKET variable).

You can create as many servers like this one very quick. Just 
clone this folder, update the hostname variable in the vars.tf 
file and run the terraform init, plan, apply -auto-approve.
