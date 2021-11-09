aws cloudformation list-stacks | grep StackName
aws cloudformation list-stack-resources --stack-name EnginFrame
aws cloudformation list-stack-resources --stack-name EnginFrame-DefaultCluster-xxx
aws cloudformation list-stack-resources --stack-name EnginFrame-DefaultCluster-xxx | grep -A4 AutoScalingGroup

mystack=EnginFrame-DefaultCluster-xxx
aws cloudformation describe-stacks --stack-name EnginFrame
aws cloudformation describe-stacks --stack-name $mystack

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
qconf -sql
qmod -d all.q
qdel -f 307
qconf -de ip-10-0-0-xx

## in case failed to remove a node
https://forums.aws.amazon.com/thread.jspa?threadID=241553

HOST_TO_REMOVE=ip-xxx-xx-xx-xx
# first, you need to delete jobs on this host
qdel -f <job id>
# disable the host from queue to avoid any jobs to be allocated to this host
qmod -d all.q@$HOST_TO_REMOVE
# wait for jobs to be finished execution on this host, then kill the execution script
qconf -ke $HOST_TO_REMOVE
# remove it from the cluster, this opens an editor, just remove the lines referring to this host
qconf -mq all.q
# remove it from allhosts group, this also opens an editor, remove lines referring to this host
qconf -mhgrp @allhosts
# remove it from execution host list
qconf -de $HOST_TO_REMOVE
 
#If the host isn't removed then:
#Remove worker's files
rm -rf /opt/sge/default/common/local_conf/$HOST_TO_REMOVE.eu-west-1.compute.internal
rm -rf /opt/sge/default/spool/qmaster/qinstances/all.q/$HOST_TO_REMOVE.eu-west-1.compute.internal
rm -rf /opt/sge/default/spool/qmaster/exec_hosts/$HOST_TO_REMOVE.eu-west-1.compute.internal
#restart sge
/etc/init.d/sgemaster.p6444 restart 
