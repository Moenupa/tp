#!/bin/sh
#SBATCH -o logs/%x/%j.out
#SBATCH -e logs/%x/%j.err
#SBATCH -p a100
#SBATCH --nodes=1
#SBATCH --mem=80G
#SBATCH -c 16
#SBATCH -t 30-00:00:00
#SBATCH -J cpuonly
#SBATCH --ntasks=1

set -x

# TODO: run here
