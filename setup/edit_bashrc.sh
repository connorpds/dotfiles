if [ "$EUID" -eq 0 ]; then
  echo "Running with sudo is unnecessary and breaks this script."
  exit 1
fi

#first: let's get our bashrc updated so it automatically sources SOURCEME.sh
#1. check if there already is a .bashrc present in ~/.
#     1.f -> if user approves, copy bashrc from common_defaults most righteously
#2. append "source $HOME/bash/SOURCEME.sh" to the end of 
#   $HOME/.bashrc most definitely and spectacularly via sed
#3. re-source the bashrc!!
echo "Checking for bashrc."
#check and supply bashrc if necessary
if [ ! -f "${HOME}/.bashrc" ]; then
  read -p "No bashrc detected. May I supply one with Ubuntu Server 24.04 defaults? (y/n)"
  while true; do
    case $yn in
      [Yy]* ) echo "Making it so." 
              cp  "${HOME}/dotfiles/ubuntu_server_bashrc" "${HOME}/.bashrc"
              break
              ;;
      [Nn]* ) echo "This will break everything else. Finish setup manually. Aborting..." 
              exit
              ;;
      *     ) echo "This will break everything else. Finish setup manually. Aborting..."
              exit
              ;;
    esac
  done
fi

echo "Editing ${HOME}/.bashrc to automatically source the files outlined in ${HOME}/.config/bash/SOURCEME.sh. This change is persistent."
sed -i '$ a\source "${HOME}/.config/bash/SOURCEME.sh"' ~/.bashrc
