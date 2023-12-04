# -*- coding: utf-8 -*-
from pathlib import Path

import pandas as pd
from metaflow import FlowSpec, Parameter, step

import etl_with_metaflow.utils as utils


class ETLFlow(FlowSpec):
    "detect csv files in the data directory, load them into pandas dataframes and save them as artifacts"

    source = Parameter("source", default=Path("data"))

    @step
    def start(self):
        self.path = Path.cwd()
        print(f"Current working directory: {self.path}")
        print(f"Source path: {self.source}")
        self.next(self.find_csvs)

    @step
    def find_csvs(self):
        self.csvs = utils.find_csvs(self.source)
        print(f"Found {len(self.csvs)} csvs in {self.source}: {self.csvs}")
        self.next(self.load_csvs, foreach="csvs")

    @step
    def load_csvs(self):
        self.csv_file = self.input
        self.df = pd.read_csv(self.input)
        print(
            f"Loaded {self.input} into dataframe, reading {self.df.shape[0]:_d} rows and {self.df.shape[1]} columns"
        )
        self.next(self.save_to_parquet)

    @step
    def save_to_parquet(self):
        self.parquet_file = (
            self.csv_file.parent / f"{self.csv_file.stem}.parquet"
        )
        self.df.to_parquet(self.parquet_file)
        print(f"Saved {self.input} as {self.parquet_file}")
        self.next(self.cleanup)

    @step
    def cleanup(self, inputs):
        utils.dummy_function()
        print("Cleaned up")
        self.next(self.end)

    @step
    def end(self):
        print("Done")


if __name__ == "__main__":
    ETLFlow()
