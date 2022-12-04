import boto3, os, json

# Boto connection
region = os.environ['region']
asg = boto3.client('autoscaling',region)

def scaleUpHandler(event, context):

    #launch_template_id = os.environ["launch_template_id"]
    asg_name           = os.environ["asg_name"]

    # Actual capacity   
    response_desired = asg.describe_auto_scaling_groups(AutoScalingGroupNames=[ asg_name ])
    actual_capacity = response_desired["AutoScalingGroups"][0]["DesiredCapacity"]
    maximum_capacity = response_desired["AutoScalingGroups"][0]["MaxSize"]
    print("actual_capacity : " + str(actual_capacity))
    print("maximum_capacity : " + str(maximum_capacity))
    
    desired_capacity = 0
    if (actual_capacity < maximum_capacity):
        desired_capacity = actual_capacity + 1
        asg.set_desired_capacity(AutoScalingGroupName=asg_name,DesiredCapacity=desired_capacity)
    else:
        desired_capacity = maximum_capacity
    

    return {
        'statusCode': 200,
        'body': 'Scale Up : ' + str(desired_capacity)
    }

def scaleDownHandler(event, context):
    #launch_template_id = os.environ["launch_template_id"]
    asg_name           = os.environ["asg_name"]
 
    # Actual capacity
    response_desired = asg.describe_auto_scaling_groups(AutoScalingGroupNames=[ asg_name ])
    actual_capacity = response_desired["AutoScalingGroups"][0]["DesiredCapacity"]
    print("actual_capacity : " + str(actual_capacity))

    desired_capacity = 0
    if (actual_capacity >= 1):
        desired_capacity = actual_capacity - 1
        asg.set_desired_capacity(AutoScalingGroupName=asg_name,DesiredCapacity=desired_capacity)
    

    return {
        'statusCode': 200,
        'body': 'Scale up : ' + str(desired_capacity)
    }