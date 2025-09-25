echo "Preparing to copy ${HOME}/dotfiles/config to ${HOME}/.config."
bash "${HOME}/dotfiles/setup/copy_configs.sh"

echo "Performing bashrc edits and replacement, if necessary."
bash  "${HOME}/dotfiles/setup/edit_bashrc.sh"
