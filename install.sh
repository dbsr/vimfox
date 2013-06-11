#!/bin/sh

pip=$(which pip) &> /dev/null || pip=$(which pip2) &> /dev/null

[[ -z $pip ]] && echo "ERROR: this install script requires pip: 'https://pypi.python.org/pypi/pip'" && exit 1

$pip install -t ./lib $(cat .requirements.txt|tail -$(($(cat .requirements.txt|wc -l)-1)))
