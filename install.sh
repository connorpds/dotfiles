#!/usr/bin/env bash

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

rm -rf ~/.config/nvim
ln -sF ${DOTFILES}/nvim ~/.config/nvim
