#!/bin/python3
import argparse
import json
from os import replace


def minify_json(inp_path: str, _replace: bool = False, _indent: str = "") -> str:
    out_path = f"{inp_path}.swp"
    with open(inp_path, "r") as inp, open(out_path, "w") as out:
        data = json.load(inp)
        json.dump(data, out, ensure_ascii=False, indent=_indent)

    if _replace:
        replace(out_path, inp_path)

    return out_path


def parse_args():
    parser = argparse.ArgumentParser(description="Minify JSON file.")
    parser.add_argument("input", type=str, nargs="+", help="Input JSON file path")
    parser.add_argument(
        "--inplace",
        type=bool,
        default=False,
        action=argparse.BooleanOptionalAction,
        help="Replace the original file with the minified version (default: do not replace)",
    )
    parser.add_argument(
        "--indent",
        type=bool,
        default=False,
        action=argparse.BooleanOptionalAction,
        help="Enable indentation for the output JSON file (default: no indentation)",
    )
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    for inp in args.input:
        minify_json(inp, args.replace, "\t" if args.indent else "")
