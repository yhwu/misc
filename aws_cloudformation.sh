aws cloudformation list-stacks | grep StackName
aws cloudformation list-stack-resources --stack-name EnginFrame
aws cloudformation list-stack-resources --stack-name EnginFrame-DefaultCluster-xxx
aws cloudformation list-stack-resources --stack-name EnginFrame-DefaultCluster-xxx | grep -A4 AutoScalingGroup

myasg="EnginFrame-DefaultCluster-1DO8VE45BMXK8-ComputeFleet-1DHZ0QM5NHHTJ"
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $myasg

## set next target number of nodes at trigger up/down event, doesn't do much, useless
aws autoscaling set-desired-capacity --auto-scaling-group-name $myasg --desired-capacity 5

## maintain 5 nodes
aws autoscaling update-auto-scaling-group --auto-scaling-group-name $myasg --min-size 5 --max-size 5

## autoscale between 0 and 10
aws autoscaling update-auto-scaling-group --auto-scaling-group-name $myasg --min-size 0 --max-size 10

## stop and resume Terminate
aws autoscaling suspend-processes --auto-scaling-group-name $myasg --scaling-processes  Terminate
aws autoscaling resume-processes --auto-scaling-group-name $myasg --scaling-processes  Terminate

