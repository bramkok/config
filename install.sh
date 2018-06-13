#!/bin/sh

function _remove() {
  __path=${1:-}
  if [ -f "${__path}" ]; then
    rm "${__path}" && echo "Removed file ${__path}"
  elif [ -d "${__path}" ]; then
    rm -rf "${__path}" && echo "Removed directory ${__path}"
  fi
}

function _create_symlink() {
  __source=${1:-}; __destination=${2:-}
  if [ -f "${__destination}" ]; then _remove "${__destination}"; fi
  ln -s "${__source}" "${__destination}" && echo "${__source} ${__destination}"
}

echo -e # Authenticate

sudo echo "Installing config files" && sleep 1

echo -e # Decrypt ssh key archive

gpg --output ssh.tar.xz --decrypt ssh.tar.xz.gpg

echo -e # Extract ssh key from archive

tar -xJvf ssh.tar.xz

echo -e # Create/remove user dirs/files

mkdir -p "${HOME}/docs" "${HOME}/code" "${HOME}/temp"
_remove "${HOME}/.bashrc"
_remove "${HOME}/.bash_profile"
_remove "${HOME}/.config"
_remove "${HOME}/.bash_logout"
_remove "${HOME}/.zcompdump"
_remove "${HOME}/.zhistory"
_remove "${HOME}/.lesshst"
_remove "${HOME}/ssh.tar.xz"
_remove "${HOME}/ssh.tar.xz.gpg"

echo -e # Clone configuration repository

git clone --recurse-submodules git@github.com:bramkok/config "${HOME}/.config"

echo -e # Create symlinks for other files

_create_symlink "${HOME}/.config/zsh/zshrc" "${HOME}/.zshrc"

echo -e # Install pacman packages from list

sudo pacman -Sy && sudo pacman -S yay
yay -Sy && yay -S $(cat "${HOME}/.config/yay/packages" | tr '\n' ' ')

echo -e # Install base16-manager themes and plugins

yay -S base16-manager && base16-manager install chriskempson/base16-shell chriskempson/base16-vim chriskempson/base16-xresources nicodebo/base16-fzf
base16-manager set google-dark

echo -e # Install neovim plugins

mkdir -p "${HOME}/.config/nvim/plug"
nvim +PlugInstall +quitall

echo -e # Install tmux plugins

git clone https://github.com/tmux-plugins/tpm "${HOME}/.config/tmux/plugins/tpm"

echo -e # Enable dhcpcd.service

sudo systemctl enable dhcpcd.service

echo -e "Installation complete"
