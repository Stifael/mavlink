
#!/bin/bash

# Fail on error
set -e

# Do only build for Python 2.7
# as we only want to deploy for one
# unique generator.
PYTHONVER=$(python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')

if [[ $PYTHONVER != "2.7"* ]]
then
	echo -e "Skipping header generation for Python $PYTHONVER"
	exit 0
fi

# Do not build pull requests
if [[ $TRAVIS_PULL_REQUEST != "false" ]]
then
	exit 0
fi

# Do only build master
if [[ $TRAVIS_BRANCH != "master" ]]
then
	exit 0
fi

# Config for auto-building
git config --global user.email "dennis.mannhart@gmail.com"
git config --global user.name "Stifael"
git config --global credential.helper "store --file=$HOME/.git-credentials"
echo "https://${GH_TOKEN}:@github.com" > "$HOME"/.git-credentials

# Build C library
GEN_START_PATH=$PWD
mkdir -p include/mavlink/v2.0
cd include/mavlink/v2.0
git clone https://github.com/Stifael/c_library_v2.git -b master
cd ../../..
./scripts/update_c_library.sh 2
