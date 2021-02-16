import boto3
region = 'us-east-2'
instances = ['i-0a3820f219beb611c']
ec2 = boto3.client('ec2', region_name=region)

def stop_instance():
    ec2.stop_instances(InstanceIds=instances)
    print(str(instances) + ' successfully stopped.')

# To stop the instance(s), simply call the function
stop_instance()
