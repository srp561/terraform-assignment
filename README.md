# Technical Assignment
You need to fix terraform code and/or Dockerfile.

Please
1. Create your own free AWS account
2. Create VPC 
3. Create ecs registry
4. Create and push container to the registry
5. Fix state.tf file. Create new terraform workspace, for instance in code we have dev
6. Deploy cluster
7. Go to ALB DNS name and check if you see succesfull code
8. Share updated code, LB URL  and your findings



## Deployment
1. Create new terraform workspace
2. terraform deploy

```
terraform workspace new dev
terraform apply
```

## Steps Performed while doing this Assignmenet and finding are below points.

1. Created VPC, ECR repo manually in AWS account (region: us-east-1)
2. Cloned given code **https://github.com/anton-demydov-zoral/tech_assignment.git** and used **terraform workspace dev**.
3. Modified **code/docker-entrypoint.sh** --> added **fi at end of file**
4. Modified **Dockerfile** by adding **executable** permissions to docker-entrypoint.sh **RUN chmod +x /usr/local/bin/docker-entrypoint.sh**
5. Built image using Docker and pushed image to created ECR repository.
6. Modified **state.tf** file with values (bucketname, key, region, workspace_key_prefix).
7. Modified **alb.tf** - **target group health check status code from 404 to 200.**
8. Modified **policy document** - **added access permissions to pull image from ECR.**
9. Modified **Security group** - **In ALB SG, allow http port from 81 to 80 and allowed 8080 on TCP**, egress all traffic.In Container SG, ingress all traffic on ALB SG and egress all traffic.
10. Modified **variables.tf** file - **image tag - lab to latest and ECR repository url in repo_url**.
11. Modified **main.tf** file - network configuration subnets - **public and enabled assign public ip's to true**, modified load balancer container **port from 8888 to 8080**.
12. ALB URL dev-assignment-613199568.us-east-1.elb.amazonaws.com
