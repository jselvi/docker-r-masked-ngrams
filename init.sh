#!/bin/bash

cd /dga
python top15_features.py "CLEAN" alexa-32k.txt > clean.csv
python top15_features.py "MALWARE" dga-32k.txt > dga.csv

Rscript run.R
