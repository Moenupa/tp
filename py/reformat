#!/bin/python3
# convert to easyR1 format
# see https://huggingface.co/datasets/hiyouga/rl-mixed-dataset
# containing cols:
# - images/videos
# - problem
# - answer

import os.path as osp
import sys

import numpy as np
import pandas as pd
from tqdm.contrib.concurrent import process_map

# change these to match the dataset
COL_PROBLEM = "question"
COL_ANSWER = "answers"
COL_IMG = "image"


def convert_to_easyR1_format(
    df: pd.DataFrame, image_root: str = "/public/datasets/MMVet/images"
) -> pd.DataFrame:
    # we need these three columns as src
    req_cols = set([COL_IMG, COL_PROBLEM, COL_ANSWER])
    assert req_cols.issubset(df.columns), f"{req_cols} !<= {df.columns}"

    def image_value_mapper(x: str | dict | list) -> list:
        if isinstance(x, (list, tuple, np.ndarray)):
            return x

        # paths
        if isinstance(x, str):
            return [f"{image_root}/{osp.basename(x)}"]

        # dict or bytes image
        return [x]

    def problem_value_mapper(x: str | list[dict]) -> str:
        if isinstance(x, str):
            if "<image>" not in x:
                return f"<image>{x}"
            return x
        return x[0]["content"]

    def answer_value_mapper(x: str | dict) -> str:
        if isinstance(x, str):
            return x
        # if x is array like
        if isinstance(x, (list, tuple, np.ndarray)):
            if isinstance(x[-1], str):
                return x[-1]
            return x[0]["content"]
        return x["ground_truth"]

    df[COL_IMG] = df[COL_IMG].apply(image_value_mapper)
    df[COL_PROBLEM] = df[COL_PROBLEM].apply(problem_value_mapper)
    df[COL_ANSWER] = df[COL_ANSWER].apply(answer_value_mapper)
    df = df[[COL_IMG, COL_PROBLEM, COL_ANSWER]].copy()
    df.rename(
        columns={COL_PROBLEM: "problem", COL_ANSWER: "answer", COL_IMG: "images"},
        inplace=True,
    )

    # from easyR1 math.jinja
    df["instruction"] = (
        "You FIRST think about the reasoning process as an internal monologue and then provide the final answer. The reasoning process MUST BE enclosed within <think> </think> tags. The final answer MUST BE put in \\boxed{}."
    )

    return df


def worker(fp: str) -> None:
    assert fp.endswith(".parquet"), f"{fp} is not a parquet file"
    df = pd.read_parquet(fp)
    df = convert_to_easyR1_format(df)

    df.to_parquet(f"swp_{fp}", index=False)


if __name__ == "__main__":
    process_map(
        worker,
        sys.argv[1:],
        max_workers=8,
        chunksize=1,
        desc="Converting to easyR1 format",
        unit="file",
    )
