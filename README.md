# Using metaflow for an etl

[Metaflow](https://docs.metaflow.org/introduction/what-is-metaflow) is a fun tool to orchestrate data sciency workflows.

In this repo you find the bare minimum to create an csv -> parquet ETL using metaflow.

The data was taken from: https://www.kaggle.com/datasets/m000sey/save-the-honey-bees/

## Setup (linux / macOS)

    git clone https://github.com/eschmidt42/etl-with-metaflow.git
    cd etl-with-metaflow
    make install

## Usage

    make etl

or

    source .venv/bin/activate
    python src/etl_with_metaflow/flows/etl.py run --source data/

Surprisingly, one needs to call a module containing a flow directly. Currently it seems  metaflow is designed to not be run from within python (without using python's `subprocess`).
