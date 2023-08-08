#!/bin/sh

#SBATCH -J assignment_05
#SBATCH -o assignment_05_%j.out
#SBATCH -p htc
#SBATCH --mem=4G
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1

module purge