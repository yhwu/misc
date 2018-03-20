# SGE qsub etc

## qsub file header
#!/bin/bash
#$ -N ML
#$ -cwd
#$ -V
#$ -j yes
#$ -pe smp 8
#$ -R yes
#$ -l h_vmem=15G
#$ -l mem_free=14G
#$ -t 1-2
#$ -tc 10


# list all parallel enviroments
qconf -sql

# check properties for all.q
qconf -sq all.q

qsub
qstat
qdel
qhost



