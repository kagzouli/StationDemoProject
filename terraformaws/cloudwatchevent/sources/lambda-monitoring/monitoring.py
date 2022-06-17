import os
import re
import boto3
import botocore
from botocore.exceptions import ClientError
from datetime import datetime,timedelta

# Tout ce qui est avant le handler est exécuté seulement quand lambda fait un cold start (nouvelle micro VM). 
# => La connexion à la BDD repose sur une global variable (cf handler) réinitialisée uniquement au cold start.
# => On optimise les perfs en conservant la connexion entre plusieurs exécutions tant qu'on reste sur la même micro VM
aws_account_id       = os.environ['AWS_ACCOUNT_ID']
aws_env              = os.environ['ENV_NAME'] 
aws_region           = os.environ['REGION'] 
station_front_lb_arn = os.environ['STATION_FRONT_LB_ARN']
station_front_tg_arn = os.environ['STATION_FRONT_TG_ARN']
station_back_lb_arn  = os.environ['STATION_BACK_LB_ARN']
station_back_tg_arn  = os.environ['STATION_BACK_TG_ARN']


def lambda_handler(event, context):
    nb_instances_up = 1
    nbInstancesTotalAlb = getNombreInstancesTargetGroup(aws_env)
    print("nbInstancesTotalAlb : " + str(nbInstancesTotalAlb))
    publish_to_cloudwatch(aws_env, "nbInstancesComponentUp", nbInstancesTotalAlb)
    return {"nbInstancesComponentUp": nbInstancesTotalAlb}





#######################################################################
####### Methode permettant de recuperer le nombre d'instances up pour #
####### Target Group et le load balancer                              #
#######################################################################
def getNombreInstancesTargetGroup(env):
    elbList  = boto3.client('elbv2', region_name=aws_region) 

    # Recherche load balancer ext et int 
    #albList = elbList.describe_load_balancers()    
    #for elb in albList['LoadBalancers']:
    #    loadBalancerArn = elb['LoadBalancerArn']
        # Recherche mario pour n'afficher que les ALB mario api management
     #   if "station-front" in loadBalancerArn:
     #       stationFrontLoadBalancerDim = loadBalancerArn.partition("loadbalancer/")[2]
     #   elif "station-back" in loadBalancerArn:
     #       stationBackLoadBalancerDim = loadBalancerArn.partition("loadbalancer/")[2]

    # Load balancer
    stationFrontLoadBalancerDim     = station_front_lb_arn.partition("loadbalancer/")[2] 
    stationBackLoadBalancerDim      = station_back_lb_arn.partition("loadbalancer/")[2] 
    print("stationFrontLoadBalancerDimm : " + stationFrontLoadBalancerDim)
    print("stationBackLoadBalancerDim : "   + stationBackLoadBalancerDim)

    # Target group
    stationFrontTargetGroupDim      = "targetgroup/" + station_front_tg_arn.partition("targetgroup/")[2]    
    stationBackTargetGroupDim       = "targetgroup/" + station_back_tg_arn.partition("targetgroup/")[2]    
    print(" stationFrontTargetGroupDim : " +  stationFrontTargetGroupDim)
    print("stationBackTargetGroupDim : " + stationBackTargetGroupDim)

    # stationfront Get Metric Data cloudwatch
    nbrInstanceStationFront = getNbrInstanceTargetGroupLoadBalancer(stationFrontLoadBalancerDim , stationFrontTargetGroupDim)
    # stationBack Get Metric Data cloudwatch
    nbrInstanceStationBack = getNbrInstanceTargetGroupLoadBalancer(stationBackLoadBalancerDim , stationBackTargetGroupDim)
    print("nbrInstanceStationFront : " + str(nbrInstanceStationFront))
    print("nbrInstanceStationBack : " + str(nbrInstanceStationBack))

    nbInstancesTotalAlb = int(nbrInstanceStationFront + nbrInstanceStationBack)
    return nbInstancesTotalAlb

    

def getNbrInstanceTargetGroupLoadBalancer(loadBalancer, targetGroup):
    cloudwatch = boto3.client('cloudwatch', region_name=aws_region)
    response = cloudwatch.get_metric_data(
        MetricDataQueries=[
        {
            'Id': 'getTargetGroup',
            'MetricStat': {
                'Metric': {
                    'Namespace': 'AWS/ApplicationELB',
                    'MetricName': 'HealthyHostCount',
                    'Dimensions': [
                    {
                        'Name': 'LoadBalancer',
                        'Value': loadBalancer
                    },
                    {                        
                        'Name': 'TargetGroup',
                        'Value': targetGroup
                    },
                    ]
                },
                'Period': 60,
                'Stat': 'Maximum',
                'Unit': 'Count'
            }
        }
        ],
        StartTime=datetime.utcnow() - timedelta(seconds = 60), 
        EndTime=datetime.utcnow(),   
    )
    
    valueCloudWatch =  sum(response['MetricDataResults'][0]['Values'])
    return valueCloudWatch   


#######################################################################
####### Publish elements to cloudwatch
#######################################################################
def publish_to_cloudwatch(env, metric_name, metric_value):
    namespace_name = "station-monitoring"
    try:
        cloudwatch = boto3.client('cloudwatch', region_name=aws_region)    
        response = cloudwatch.put_metric_data(
            Namespace = namespace_name,
            MetricData = [
                {
                    'MetricName': metric_name,
                    'Dimensions': [
                        {
                            'Name': 'Environment',
                            'Value': env
                        }
                    ],
                    'Value': metric_value,
                    'Unit': 'Count'
                }
            ]
        )    
    except ClientError as e:
        print("Unexpected error: %s" % e)
               

