aws cloudformation list-stacks
aws cloudformation list-stack-resources --stack-name EnginFrame
aws cloudformation list-stack-resources --stack-name EnginFrame-DefaultCluster-11221

myasg="EnginFrame-DefaultCluster-1DO8VE45BMXK8-ComputeFleet-1DHZ0QM5NHHTJ"
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $myasg

aws autoscaling set-desired-capacity --auto-scaling-group-name $myasg --desired-capacity 5

aws autoscaling suspend-processes --auto-scaling-group-name $myasg --scaling-processes  Terminate
aws autoscaling resume-processes --auto-scaling-group-name $myasg --scaling-processes  Terminate

aws autoscaling update-auto-scaling-group --auto-scaling-group-name $myasg --min-size 5 --max-size 5
