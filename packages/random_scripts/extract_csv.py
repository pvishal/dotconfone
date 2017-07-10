#!/usr/bin/python

from __future__ import print_function

import sys

def clean_value(value):
    if (value[0] == "\"" ) and (value[-1] == "\""):
        return value[1:len(value)-1]

filename   = sys.argv[1]
column_ids = [int(x) for x in sys.argv[2:]]

file = open(filename, "r")
header_line = file.readline()

headers = header_line.strip().split(",")

new_headers = [headers[x-1] for x in column_ids]
print(",".join(new_headers))

match=False
for line in file:
    line = line.strip()
    values = line.split(",")
    new_values = [values[x-1] for x in column_ids]
    new_values = [clean_value(value) for value in new_values]
    print(",".join(new_values))

