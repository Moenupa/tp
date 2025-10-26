#!/bin/sh
#SBATCH -o logs/%x/%j.out
#SBATCH -e logs/%x/%j.err
#SBATCH -p a100
#SBATCH --nodes=1
#SBATCH --mem-per-gpu=80G
#SBATCH --cpus-per-gpu=12
#SBATCH -t 30-00:00:00
#SBATCH -J job
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1

# saved for debugging
echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"
python -c "\
import importlib
from torch import cuda, backends, version
print('cuda:', cuda.is_available(), version.cuda)
print('flash-attn:', importlib.util.find_spec('flash_attn') is not None, backends.cuda.is_flash_attention_available())"

set -x

# TODO: run here
