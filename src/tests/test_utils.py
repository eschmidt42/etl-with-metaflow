# -*- coding: utf-8 -*-
import unittest
from pathlib import Path

import etl_with_metaflow.utils as utils


class TestUtils(unittest.TestCase):
    def setUp(self):
        self.tmp_path = Path("tmp")
        self.tmp_path.mkdir(exist_ok=True)

    def tearDown(self):
        # Remove the non-empty temporary directory
        for child in self.tmp_path.iterdir():
            child.unlink()
        self.tmp_path.rmdir()

    def test_find_csvs(self):
        # Create some dummy CSV files
        self.tmp_path.joinpath("file1.csv").touch()
        self.tmp_path.joinpath("file2.csv").touch()
        self.tmp_path.joinpath("file3.txt").touch()

        # Call the function
        csvs = utils.find_csvs(self.tmp_path)

        # Check the result
        self.assertEqual(len(csvs), 2)
        self.assertIn(self.tmp_path.joinpath("file1.csv"), csvs)
        self.assertIn(self.tmp_path.joinpath("file2.csv"), csvs)
        self.assertNotIn(self.tmp_path.joinpath("file3.txt"), csvs)
