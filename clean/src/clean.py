#
# :date: 2020-02-14
# :author: PN
# :copyright: GPL v2 or later
#
# ice-facilities/clean/src/clean.py
#
#
import pandas as pd
import argparse
import sys
import yaml
import logging
if sys.version_info[0] < 3:
    raise "Must be using Python 3"


def _get_args():
    parser = argparse.ArgumentParser()
    # parser.add_argument("--facilities", required=True)
    parser.add_argument("--cleanrules", required=True)
    parser.add_argument("--input", required=True)
    parser.add_argument("--output", required=True)
    parser.add_argument("--header", required=True)
    return parser.parse_args()


if __name__ == "__main__":

    args = _get_args()

    logging.basicConfig(filename='output/clean.log',
                    filemode='a',
                    format=f'%(asctime)s|%(message)s',
                    level=logging.INFO)

    read_csv_opts = {'sep': '|',
                     'quotechar': '"',
                     'compression': 'gzip',
                     'encoding': 'utf-8',
                     'header': int(args.header)}

    df = pd.read_csv(args.input, **read_csv_opts)

    logging.info(f'input_file|{args.input}')
    logging.info(f'rows_in|{len(df)}')

    with open(args.cleanrules, 'r') as yamlfile:
        cleanrules = yaml.safe_load(yamlfile)

    df.columns = df.columns.str.lower()
    df.columns = df.columns.str.strip()
    for key in cleanrules['all_cols'].keys():
        df.columns = df.columns.str.replace(key, cleanrules['all_cols'][key],
                                            regex=True)

    # Very basic cleaning here; should learn how to parse common
    # symbols in Pandas without replacing strings
    for col in df.columns:
        try:
            df.loc[:, col] = df.loc[:, col].astype(str)
            df.loc[:, col] = df.loc[:, col].str.replace(',', '', regex=True)
            df.loc[:, col] = df.loc[:, col].str.replace('$', '', regex=True)
            df.loc[:, col] = df.loc[:, col].str.replace('%', '', regex=True)
            df.loc[:, col] = df.loc[:, col].astype(float)
        except ValueError:
            pass

    write_csv_opts = {'sep': '|',
                      'quotechar': '"',
                      'compression': 'gzip',
                      'encoding': 'utf-8',
                      'index': False}

    df.to_csv(args.output, **write_csv_opts)
    logging.info(f'output_file|{args.input}')
    logging.info(f'rows_out|{len(df)}')

# END.
