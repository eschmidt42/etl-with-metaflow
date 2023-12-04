# -*- coding: utf-8 -*-
from pathlib import Path


def dummy_function():
    print("Dummy function")


# find csvs in path
def find_csvs(path: Path):
    csvs = list(path.glob("*.csv"))
    return csvs
