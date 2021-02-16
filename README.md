# DevOps for ARCA network

This is the steps required to reproduce the actions necessary in completing the devops challenge from the ARCA network.

## Docker

The objective is to write a shell script to fire up 3 docker containers, respectively of `Kibana 6.4.2,` `Nginx` and `MySQL,` with all instances able to ping each other regardless of deployment environment. Also, Nginx needs to be configured (for immediate access, I presume).

The steps in reproducing the script are documented in the [docker.md](./docker.md) file. 

To run the resulting [docker.sh](./docker.sh) shell script, please follow the steps below:

1. Log in to bash shell with docker installed. Verify with `docker info`.

2. Run the command `bash docker.sh` and watch the outputs. Please make sure your environment has access to the internet. This process will take some time.

3. You can verify the running containers with `docker ps`. Navigate to port `8080` on your host address in a web browser to verify that Nginx is functional. For example, `http://localhost:8080`.

4. To finish the demo and clean up resources, run the cleanup script with `bash cleanup.sh`. This removes the running containers, but not the base images. To remove all docker images on the system, use `docker rmi $(docker images -q)`. 
```diff
- WARNING: This will remove all images in your local repo.
```

## CloudFormation

I'm required to write a basic cloudformation script to deploy a lone server to a region in AWS on the default VPC. The resulting script is the [instance.yml](./instance.yml) file, and below are the steps to "run" that script:

1. Have AWS cli installed. Version 2 is preferred, but version 1 will do just fine.

2. Configure the CLI with programmatic keys generated from the AWS IAM console. Also configure a default AWS region and a default output format.

3. Run `aws cloudformation deploy --stack-name temp --template-file instance.yml` from your terminal.

4. Run `aws cloudformation list-exports |grep Value` for the instance id of the resulting EC2 instance.

5. Query the list of instance ids of all running instances with this command:
`aws ec2 describe-instances --filters Name=instance-type,Values=t2.micro Name=instance-state-name,Values=running --query "Reservations[].Instances[].InstanceId"`. Verify that the instance id returned in step 4 is included.

6. This instance id will be needed in the Python section below. Once done, cleanup with:
`aws cloudformation delete --stack-name temp`.

## Python

Here, we create two identical Python scripts &mdash; one to stop, and another to start the instance created in the previous section. The resulting scripts are [power-off](./power-off) and [power-on](./power-on) respectively. To run them, 

1. Make sure python is installed.

2. Boto3 is a dependency. Install with pip or conda.

3. Replace the the `instances` list in both `power-off.py` and `power-on.py` to include the instance id of your own instance, exported in the CloudFormation section.

4. `python power-off.py` will power down the running instance. Verify with step 5 from CloudFormation section.

5. `python power-on.py` will power up the stopped instance. Verify with step 5 from CloudFormation section. You may need a few seconds for changes to propagate.

6. Cleanup the stack with step 6 in the CloudFormation section.
