#!/bin/sh
# vimfox requirements install script

# we need virtualenv/pip for this to work.
virtualenv=$(which virtualenv) &> /dev/null || pip=$(which virtualenv2) &> /dev/null
if [[ -z $virtualenv ]]
then
  echo "ERROR: this install script requires virtualenv: 'https://pypi.python.org/pypi/virtualenv'."
  exit 1
fi

venv_dir=./venv_temp
ext_dir=./vimfox/server/ext

if ! [[ -d $venv_dir ]] 
then
    mkdir $venv_dir
fi

if ! [[ -d $ext_dir ]] 
then
    mkdir $ext_dir
fi

$virtualenv $venv_dir && \
source $venv_dir/bin/activate && \
pip install -r .requirements.txt -t $ext_dir && \
rm -rf $venv_dir
