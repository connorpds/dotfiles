#copies the contents of dotfiles/config to ~/.config, adds a 
#source line to the bashrc. bashrc and config together activity
#together handle tmux configuration.

echo "Preparing to copy ${HOME}/dotfiles/config to ${HOME}/.config."
bash "${HOME}/dotfiles/setup/copy_configs.sh"

echo "Performing bashrc edits and replacement, if necessary."
bash  "${HOME}/dotfiles/setup/edit_bashrc.sh"
