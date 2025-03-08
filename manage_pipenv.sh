#!/bin/bash

# Check if any arguments were provided
if [ $# -eq 0 ]; then
  echo ""
  echo "*********************************************"
  echo "No arguments provided."
  echo "*********************************************"
  echo ""
  exit 1
fi

# Configuration
PIPENV_DIR=$1
REQUIREMENTS_TXT="$HOME/my_work_tools/environment_setup/requirements.txt"
REQUIREMENTS_YML="$HOME/my_work_tools/environment_setup/requirements.yml"

if [ "$(pwd)" = "$PIPENV_DIR" ]; then
  echo ""
else
  cd "$PIPENV_DIR" || exit
fi
# Create or activate the global virtual environment
echo ""
echo "*********************************************"
echo "Creating virtual environment at $PIPENV_DIR ..."
echo "*********************************************"
echo ""
cd "$PIPENV_DIR" || exit
pipenv install --python=3.12

# Ensure pip and pip-tools are installed and up to date
echo ""
echo "*********************************************"
echo "Installing/updating pip and pip-tools ..."
echo "*********************************************"
echo ""
pipenv run pip install --upgrade pip
pipenv run pip install --upgrade pip-tools

# Install the dependencies
if [ -f "$REQUIREMENTS_TXT" ]; then
    echo ""
    echo "*********************************************"
    echo "Installing dependencies from $REQUIREMENTS_TXT ..."
    echo "*********************************************"
    echo ""
    pipenv run pipenv install -r "$REQUIREMENTS_TXT"
else
    echo ""
    echo "*********************************************"
    echo "Error: Failed to generate $REQUIREMENTS_TXT ..."
    echo "*********************************************"
    echo ""
fi

# Sync the global virtual environment
echo ""
echo "*********************************************"
echo "Syncing the environment ..."
echo "*********************************************"
echo ""
pipenv run pipenv sync

# Cleanup and finalize
echo ""
echo "*********************************************"
echo "Pipdeptree created ..."
echo "*********************************************"
echo ""
pipenv run pipdeptree | grep -E "^[a-z]" > pipdeptree_current.txt
cat pipdeptree_current.txt

# Install the dependencies
if [ -f "$REQUIREMENTS_YML" ]; then
    echo ""
    echo "*********************************************"
    echo "Installing dependencies from $REQUIREMENTS_YML ..."
    echo "*********************************************"
    echo ""
    pipenv run ansible-galaxy collection install --force --force-with-deps --requirements-file "$REQUIREMENTS_YML"
else
    echo ""
    echo "*********************************************"
    echo "Error: Failed to generate $REQUIREMENTS_YML ..."
    echo "*********************************************"
    echo ""
fi

pipenv run python3 --version
pipenv run pip3 --version
echo ""
echo ""
echo "*********************************************"
echo "Global virtual environment setup and dependency installation complete."
echo "*********************************************"
echo ""
echo ""
read -t 30 -rp "Pausing for 30 seconds or until you press enter ..."
echo ""
echo ""
