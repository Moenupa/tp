#!/bin/python3
import argparse
import sys
from glob import glob

import pandas as pd


def adaptive_read_data(fp: str) -> pd.DataFrame:
    if fp.endswith(".jsonl"):
        return pd.read_json(fp, lines=True)
    elif fp.endswith(".json"):
        return pd.read_json(fp)
    elif fp.endswith(".csv"):
        return pd.read_csv(fp)
    elif fp.endswith(".tsv"):
        return pd.read_csv(fp, sep="\t")
    elif fp.endswith(".xlsx") or fp.endswith(".xls"):
        return pd.read_excel(fp)
    else:
        raise ValueError(f"Unsupported file format: {fp}")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--input",
        type=str,
        default="*.json",
        help="Input file or glob pattern (e.g., '*.json')",
    )
    return parser.parse_args()


def get_args(defaults=None):
    if len(sys.argv) > 1:
        return sys.argv[1:]
    elif defaults is not None:
        return defaults

    return glob("*.json", recursive=True)


if __name__ == "__main__":
    iterator = get_args()

    for fp in iterator:
        print(fp)
        df = adaptive_read_data(fp)
        print(df)
