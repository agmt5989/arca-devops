import boto3
region = 'us-east-2'
instances = ['i-0a3820f219beb611c']
ec2 = boto3.client('ec2', region_name=region)

def start_instance():
	ec2.start_instances(InstanceIds=instances)
	print(str(instances) + ' successfully started.')

# To start the instance(s), call the function
start_instance()
