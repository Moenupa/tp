#!/bin/sh
#SBATCH --nodes=1
#SBATCH --mem=80G
#SBATCH -c 16
#SBATCH -p a100
#SBATCH -t 30-00:00:00
#SBATCH -o logs/cpuonly/%j.out
#SBATCH -e logs/cpuonly/%j.err
#SBATCH -J cpuonly
#SBATCH --ntasks=1

set -x

# TODO: run here
