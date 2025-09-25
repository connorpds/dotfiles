
if [ "$EUID" -eq 0 ]; then
  echo "Running with sudo is unnecessary and breaks this script."
  exit 1
fi

#zer0th:
#1. check for existence of $HOME/.config, prompt user for overwrite perms
#2. most magnanimously copy/overwrite dotfiles/config to $HOME/.config 
if [ -d "${HOME}/.config" ]; then 
  echo "~/.config directory already present. Contents:"
  ls -la "${HOME}/.config"
  while true; do
    read -p "Do you wish to irreversibly overwrite the contents of ~/.config? (y/n)" yn 
    case $yn in 
      [Yy]* ) echo "Overwriting."
              cp -r "${HOME}/dotfiles/config" "${HOME}/.config"
              echo "Verify the contents below:"
              ls -la "${HOME}/.config"
              break
              ;;
      [Nn]* ) echo "Negative acknowledged. Aborting..."
              exit
              ;;
      *     ) echo "Illiteracy detected. Aborting."
              exit
              ;;
    esac
  done
else 
  echo "Copying the contents of ${HOME}/dotfiles/config to ${HOME}/.config."
  cp -r "${HOME}/dotfiles/config" "${HOME}/.config"
  echo "Verify the contents below:"
  ls -la "${HOME}/.config"
fi
