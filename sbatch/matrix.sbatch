#!/bin/sh
#SBATCH --nodes=1
#SBATCH --mem-per-gpu=64G
#SBATCH --cpus-per-gpu=8
#SBATCH -p a100
#SBATCH -t 30-00:00:00
#SBATCH -o logs/array/%A_%a.out
#SBATCH -e logs/array/%A_%a.err
#SBATCH -J job-array
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --array=0-0

# saved for debugging
echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"
python -c "\
import importlib
from torch import cuda, backends, version
print('cuda:', cuda.is_available(), version.cuda)
print('flash-attn:', importlib.util.find_spec('flash_attn') is not None, backends.cuda.is_flash_attention_available())"

# TODO: add datasets and models here
EVAL_DATASET_ARR=()
MODEL_PATH_ARR=()

set -x

task_id=${SLURM_ARRAY_TASK_ID}
num_datasets=${#EVAL_DATASET_ARR[@]}

dataset_index=$((task_id % num_datasets))
model_index=$((task_id / num_datasets))
MODEL_PATH=${MODEL_PATH_ARR[$model_index]}
EVAL_DATASET=${EVAL_DATASET_ARR[$dataset_index]}

echo "Running with task_id $task_id, dataset $EVAL_DATASET, model $MODEL_PATH"

# TODO: run here
