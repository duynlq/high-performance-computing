#!/bin/sh

#SBATCH -J assignment_05
#SBATCH -o assignment_05_%j.out
#SBATCH -p htc
#SBATCH --mem=4G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1

module purge

wget https://github.com/duynlq/high-performance-computing/blob/main/project/df_for_R.csv

spack env activate r-base
Rscript project.R

cat /proc/cpuinfo

echo "Job ID: $SLURM_JOBID"
echo "Job Name: $SLURM_JOB_NAME"
echo "Cluster Name: $SLURM_CLUSTER_NAME"
echo "Number of Nodes: $SLURM_NNODES"
echo "Memory per Node: $SLURM_MEM_PER_NODE"
echo "Memory per CPU: $SLURM_MEM_PER_CPU"
echo "Cores per Node: $SLURM_CPUS_ON_NODE"