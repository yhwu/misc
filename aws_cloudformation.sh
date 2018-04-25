aws cloudformation list-stacks | grep StackName
aws cloudformation list-stack-resources --stack-name EnginFrame
aws cloudformation list-stack-resources --stack-name EnginFrame-DefaultCluster-xxx
aws cloudformation list-stack-resources --stack-name EnginFrame-DefaultCluster-xxx | grep -A4 AutoScalingGroup

myasg="EnginFrame-DefaultCluster-1DO8VE45BMXK8-ComputeFleet-1DHZ0QM5NHHTJ"
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $myasg
aws autoscaling describe-auto-scaling-instances

## set next target number of nodes at trigger up/down event, doesn't do much, useless
aws autoscaling set-desired-capacity --auto-scaling-group-name $myasg --desired-capacity 5

## maintain 5 nodes, this is the most effective way to size the cluster
aws autoscaling update-auto-scaling-group --auto-scaling-group-name $myasg --min-size 5 --max-size 5
aws autoscaling describe-auto-scaling-instances
# note: after the instances are in service, it takes a while for them to join the cluster. 

## autoscale between 0 and 10, remember to reset back to avoid unnecessary charges
aws autoscaling update-auto-scaling-group --auto-scaling-group-name $myasg --min-size 0 --max-size 10 --desired-capacity 5

## stop and resume Terminate
aws autoscaling suspend-processes --auto-scaling-group-name $myasg --scaling-processes  Terminate
aws autoscaling resume-processes --auto-scaling-group-name $myasg --scaling-processes  Terminate

## deal with hosts that are terminated but still registered by SGE
# https://forums.aws.amazon.com/thread.jspa?threadID=241553
sudo su sgeadmin
qmod -d all.q
qdel -f 307
qconf -de ip-10-0-0-xx
