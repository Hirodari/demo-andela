import unittest
import pandas as pd
from pandas.testing import assert_frame_equal # <-- for testing dataframes

class DFTests(unittest.TestCase):

    """
        class for running unittests, this testing of checking if the
        the excel was read
    """

    def setUp(self):
        """ Your setUp """
        TEST_INPUT_DIR = ''
        test_file_name =  'supermarkt_sales.xlsx'
        try:
            data = pd.read_excel(
                    io=test_file_name,
                    engine="openpyxl",
                    sheet_name="Sales",
                    skiprows=3,
                    usecols="B:R",
                    nrows=1000,
                )
        except IOError:
            print('cannot open file')
        self.fixture = data
        return data

    def test_dataFrame_constructedAsExpected(self):
        """ Test that the dataframe read in equals what you expect"""
        data = pd.DataFrame(self.setUp())
        assert_frame_equal(self.fixture, data)
if __name__ == '__main__':
    unittest.main()
