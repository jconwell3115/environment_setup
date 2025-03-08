#!/bin/bash

# Get project name
read -rp "Enter the project name: " PROJECT_NAME
read -rp "Enter the full repo ssh info: " REPO
read -rp "Enter the repo name: " REPO_NAME

# Variable Configuration
WORK_ENV_DIR="$HOME/Work_Environments/"
WORK_TOOLS_DIR="$HOME/my_work_tools"
BIN_DIR=$WORK_TOOLS_DIR/bin/
GLOBAL_PIPENV_DIR="$WORK_TOOLS_DIR/environment_setup"
PROJECT_DIR="$WORK_ENV_DIR/$PROJECT_NAME"
CONDA_DIR="/home/jconw483/miniconda3/"
USERNAME="Jonathan Conwell"

# Set variables for key generation
KEY_NAME="id_ed25519"
KEY_PATH="$HOME/.ssh/$KEY_NAME"
KEY_TYPE="ed25519"
KEY_SIZE="2048"
EMAIL="jconwell3115@gmail.com"

# Define a function to handle errors
handle_error() {
  echo ""
  echo "*******************************************************************************"
  echo "Error: Command failed with exit code $?"
  echo "*******************************************************************************"
  echo ""
}

# Set the trap to call handle_error on ERR signal
trap handle_error ERR

# Commented out for now
#echo ""
#echo "*******************************************************************************"
##echo "Removing old virtualenvs if they exist"
#echo "*******************************************************************************"
#echo ""
#rm -rf /home/jconw483/.local/share/virtualenvs/

#Get and Install Miniconda3-latest-Linux-x86_64
if [ ! -d "$CONDA_DIR" ]; then
  echo ""
  echo "*******************************************************************************"
  echo "Installing Miniconda3 to handle python versions ..."
  echo "*******************************************************************************"
  echo ""
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  echo ""
  bash ~/Miniconda3-latest-Linux-x86_64.sh
  echo ""

  #Set conda init
  source /home/jconw483/.bashrc
  # Just in case conda doesn't initialize
  conda activate

  #Set python 3.12 as default
  conda install python=3.12

  # Install Pipenv
  echo ""
  echo "*******************************************************************************"
  echo "Installing pipenv to setup virtual environments and handle Python packages ..."
  echo "*******************************************************************************"
  echo ""
  pip3 install --user pipenv


  #Turn off auto activate base
  conda config --set auto_activate_base false
  source /home/jconw483/.bashrc
else
  echo ""
  echo "*******************************************************************************"
  echo "Microconda3 already installed, nothing to do!"
  echo "*******************************************************************************"
  echo ""
fi

# Create the ~/my_work_tools/ directory
if [ ! -d "$WORK_TOOLS_DIR" ]; then
  echo ""
  echo "*******************************************************************************"
  echo "Creating work directory at $WORK_TOOLS_DIR ..."
  echo "*******************************************************************************"
  echo ""
	mkdir "$WORK_TOOLS_DIR"
else
  echo ""
  echo "*******************************************************************************"
	echo "Work directory already exists at $WORK_TOOLS_DIR ..."
  echo "*******************************************************************************"
  echo ""
fi
# Generate the SSH keypair, overwriting if it exists
ssh-keygen -t $KEY_TYPE -b $KEY_SIZE -N "" -f "$KEY_PATH" -C "$EMAIL"

# Set permissions for the private key
chmod 600 "$KEY_PATH"

# Display success message and key locations
echo ""
echo "*******************************************************************************"
echo "SSH keypair generated successfully!"
echo "*******************************************************************************"
echo ""
cat "$KEY_PATH.pub"
echo ""
echo "*******************************************************************************"
echo ""

# Add key to GH
read -rp "Press Enter to continue after uploading the key to GitHub ..."

cd "$WORK_TOOLS_DIR" || exit
echo ""
echo "*******************************************************************************"
echo "Changed to the $(pwd) directory ..."
echo "*******************************************************************************"
echo ""

# Clone my_work_tools repo
echo ""
echo "*******************************************************************************"
echo "Cloning $WORK_TOOLS_DIR repos ..."
echo "*******************************************************************************"
echo ""
git clone git@github.com:jconwell3115/environment_setup.git

# Wait for 30 seconds
echo ""
echo "*******************************************************************************"
read -t 30 -rp "Pausing for 30 seconds or until you press enter ..."
echo "*******************************************************************************"
echo ""

# This will be created later, it contains useful scripts for the development environment
#git clone git@github.com:jconwell3115/bin.git

# Setup Pipenv for my_work_tools
/home/jconw483/my_work_tools/environment_setup/manage_pipenv.sh "$WORK_TOOLS_DIR"

echo ""
echo "*******************************************************************************"
echo "Setting up pre-commit in $(pwd)"
echo "*******************************************************************************"
echo ""
cd /home/jconw483/my_work_tools/environment_setup/ || exit
pipenv run pre-commit install

# cd /home/jconw483/my_work_tools/bin/ || exit
# echo ""
#echo "*******************************************************************************"
#echo "Setting up pre-commit in $(pwd)"
#echo "*******************************************************************************"
#echo ""
#scp -p "$environment_setup_DIR/.pre-commit-config.yaml" "$BIN_DIR"
#pipenv run pre-commit install
#scp -p "$environment_setup_DIR/.pre-commit-config.yaml" "$BIN_DIR"

# Set .bashrc parameters
echo ""
echo "*******************************************************************************"
echo "Setting .bashrc parameters ..."
echo "*******************************************************************************"
echo ""
cat  "$environment_setup_DIR/mybashrc" > ~/.bashrc
source /home/jconw483/.bashrc

# Create the ~/Work_Environments/ directory
if [ ! -d "$WORK_ENV_DIR" ]; then
  echo ""
  echo "*******************************************************************************"
  echo "Creating work directory at $WORK_ENV_DIR ..."
  echo "*******************************************************************************"
  echo ""
	mkdir "$WORK_ENV_DIR"
else
  echo ""
  echo "*******************************************************************************"
	echo "Work directory already exists at $WORK_ENV_DIR ..."
  echo "*******************************************************************************"
  echo ""
fi

# Move to Work_Environments directory
cd "$WORK_ENV_DIR" || exit
echo ""
echo "*******************************************************************************"
echo "Changed to the $(pwd) directory ..."
echo "*******************************************************************************"
echo ""

# Create the Project directory
if [ ! -d "$PROJECT_DIR" ]; then
  echo ""
  echo "*******************************************************************************"
  echo "Creating project directory at $PROJECT_DIR ..."
  echo "*******************************************************************************"
  echo ""
	mkdir "$PROJECT_DIR"
else
  echo ""
  echo "*******************************************************************************"
	echo "Project directory already exists at $PROJECT_DIR ..."
  echo "*******************************************************************************"
  echo ""
fi

cd "$PROJECT_DIR" || exit
echo ""
echo "*******************************************************************************"
echo "Changed to the $(pwd) directory ..."
echo "*******************************************************************************"
echo ""

# Clone my_work_tools repo
echo ""
echo "*******************************************************************************"
echo "Attempting to Clone $REPO_NAME repos"
echo "*******************************************************************************"
echo ""
git clone "$REPO"

/home/jconw483/my_work_tools/environment_setup/manage_pipenv.sh "$PROJECT_DIR"


cd "$PROJECT_DIR/$REPO_NAME" || exit
echo ""
echo "*******************************************************************************"
echo "Setting up pre-commit in $(pwd)"
echo "*******************************************************************************"
echo ""
# Remove and existing .pre-commit-config.yml file
rm -f .pre-commit-config.yaml
rm -f .pre-commit-config.yml
scp -p "$GLOBAL_PIPENV_DIR/.pre-commit-config.yml" "$PROJECT_DIR/$REPO_NAME"
pipenv run pre-commit install


echo ""
echo "*******************************************************************************"
echo "Setting Global Git Parameters"
echo "*******************************************************************************"
echo ""
git config --global credential.helper "cache --timeout=86400" --replace-all
git config --global pull.rebase false --replace-all
git config --global user.name "$USERNAME" --replace-all
git config --global user.email "$EMAIL" --replace-all
git config --global alias.bc "branch --show-current" --replace-all

echo ""
echo "*********************************************"
echo "Environment setup complete please check for errors"
echo "*********************************************"
echo ""
