#!/usr/bin/python

import sys

filename   = sys.argv[1]
search_str = sys.argv[2]
delim      = sys.argv[3]

if delim == "":
    delim = ","

file = open(filename, "r")
header_line = file.readline()

headers = header_line.strip().split(delim)

match=False
for line in file:
    line = line.strip()
    if search_str in line:
        match=True
        break

if not match:
    print("Cannot find", search_str)
else:
    values = line.split(delim)
    for index in range(len(headers)):
        print(index+1, headers[index], values[index])
