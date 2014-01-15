#! /bin/sh

# This script invokes pod2cpanhtml to generate HTML from POD. 
# This is done so the rendering can be checked by eye. 

mkdir -p html
pod2html \
    --infile=lib/App/Rhea.pm \
    --outfile=html/App-Rhea.html

pod2html \
    --infile=bin/rhea.pl \
    --outfile=html/rhea.html

exit 0
