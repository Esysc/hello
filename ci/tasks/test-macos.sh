#! /bin/sh

set -o errexit
set -o xtrace

echo "\n\n*** Printing directory information"
ls -lart

echo "\n\n*** Run the artifact"
./build-dir/greet
