#!/usr/bin/env python

from __future__ import print_function

import os
import sys
import argparse
import logging
import logging.handlers

logger = logging.getLogger()
LOG_FORMATTER = logging.Formatter(
    "%(asctime)s - %(name)s - %(levelname)s - " +
    "%(lineno)s - %(funcName)s - " +
    "%(message)s")

def setup_logging(level=logging.INFO):
    file_log_handler = logging.handlers.RotatingFileHandler(
        "__" + os.path.basename(__file__) + ".main__" + ".log",
        maxBytes = 1000000,
        backupCount = 5)
    console_log_handler = logging.StreamHandler()
    logger = logging.getLogger()
    logger.addHandler(file_log_handler)
    logger.addHandler(console_log_handler)
    logger.setLevel(level)
    for handler in logging.root.handlers:
        handler.setFormatter(fmt=LOG_FORMATTER)


def process(myargs, *args, **kwargs):
    logger.debug("debug")
    logger.info("info")
    logger.warning("warning")
    logger.error("error")
    logger.critical("critical")

    print(myargs.arg1, myargs.arg2)

    return 0


def main():
    parser = argparse.ArgumentParser(description="Generic Application")
    parser.add_argument(
        "--arg1",
        dest="arg1",
        choices=["opt1", "opt2"],
        type=str.lower, # Make case-insensitive
        help="Some Argument",
        required=True
    )
    parser.add_argument(
        "--arg2",
        dest="arg2",
        choices=[3, 4],
        help="Some Argument",
        type=int,
        default=4,
        required=True
    )

    myargs = parser.parse_args()

    return process(myargs)

if __name__ == '__main__':
    setup_logging(level=logging.INFO)
    sys.exit(main())

