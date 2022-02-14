#!/bin/bash

# util-linux-user: provides chsh command
# zsh: provides zsh shell
# vim: provides enhanced vi text editor
echo "Installing packages"
sudo dnf install util-linux-user zsh vim -y

echo "Downloading Oh My Zsh"
cd ~
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Download antigen plugin manager for zsh
echo "Downloading antigen"
curl -L git.io/antigen > ~/antigen.zsh

# Overwrite zsh config (.zshrc)
echo "Creating zsh config"
cat > ~/.zshrc << 'EOL'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/antigen.zsh
antigen init ~/.antigenrc

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
path+=("$HOME/gems/bin")
path+=("$HOME/.local/bin")
export PATH
EOL

# Create antigen config
echo "Creating antigen config"
cat > ~/.antigenrc << 'EOL'
# Load the oh-my-zsh library
antigen use oh-my-zsh

# PLugins with oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle command-not-found
antigen bundle sudo  # double esc

# External plugins
antigen bundle MichaelAquilina/zsh-you-should-use
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting  # Must be the last plugin to take effect

# Theme
antigen theme romkatv/powerlevel10k

# Apply config
antigen apply
EOL

# Download vim-plug plugin manager for vim
echo "Downloading vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Create vim-plug config
echo "Creating vim-plug config"
cat > ~/.vimrc << 'EOL'
" Specify a directory for plugins
" - Avoid using standard Vim directory names like 'plugin'
" Apply changes with :PlugInstall

call plug#begin('~/.vim/plugged')


Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'

Plug 'yggdroot/indentline'

" :UndotreeToggle
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-sensible'


" Initialize plugin system
call plug#end()

:set number
EOL

# Install nerd fonts which work best with Powerlevel10k for zsh
echo "Installing MesloLGS fonts"
mkdir --parents ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLo "MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
curl -fLo "MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
curl -fLo "MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
curl -fLo "MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

# Update font cache
echo "Updating font cache"
sudo fc-cache -vf ~/.local/share/fonts

# Change shell to zsh (user interaction required)
echo "Changing shell to zsh"
chsh -s $(which zsh)

echo "All done!"
echo "You may need to log out and back in again"
echo "You may also need to configure your terminal to use \"MesloLGS\" fonts for Powerlevel10k to display correctly."
