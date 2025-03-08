# Environment Setup

> This repo is used to setup my virtual environments.
>
> I use linux as the base for my development environment.

## Usage
1. In the $HOME folder of the development environment, creaet a file called `environment_setup.sh` with vim or your favorite textfile editor.
2. Copy the contents of the `environment_setup.sh` file from this repo into the newly created file
   > Modify the folder paths to fit your environment
4. Make the newly created file executable
     ```bash
      chmod +x environment_setup.sh
     ```
5. Run the file
    ```bash
    ./environment_setup.sh
    ```
6. When promted enter the project and repo name
   > I use a specific folder structure, the project is the name of the folder where I create the pipenv environment.
   > 
   > The repo folder is then cloned into that folder.
7. Follow the prompts onscreen to install conda, set python 3.12 as the default and create the ssh key .

> **This will take approximately 10-15 minutes to complete if this is the initial setup**


