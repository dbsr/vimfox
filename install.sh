#!/bin/sh
pip=$(which pip) &> /dev/null || pip=$(which pip2) &> /dev/null
[[ -z $pip ]] && echo "ERROR: this install script requires pip: 'https://pypi.python.org/pypi/pip'" && exit 1

ext_dir="./vimfox/server/ext"
[[ -d $ext_dir ]] || mkdir $ext_dir

$pip install -t $ext_dir $(cat .requirements.txt|tail -$(($(cat .requirements.txt|wc -l)-1)))
