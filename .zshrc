# NVM SETTINGS
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# AUTOLOAD NVM VERSION
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# ZSH PLUGINS
plugins=(zsh-autosuggestions)

# RANDOM EMOJI ON LOAD
emojis=("⚡️" "🔥" "🍕" "🍔" "👑" "😎" "🙈" "🐵" "🦄" "🌈" "🚀" "🎉" "🔑" "👀" "🚦" "🎲" "❤️")
RAND_EMOJI_N=$(( $RANDOM % ${#emojis[@]} + 1))
PS1="${emojis[$RAND_EMOJI_N]} %1~: "

# ALIAS
if [ -e $HOME/.zsh_aliases ]; then
    source $HOME/.zsh_aliases
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

npmPersonal() {
    cp ~/personal/.npmrc-personal ~/.npmrc
    cp ~/personal/.yarnrc-personal.yml ~/.yarnrc.yml
}

npmTrayioRead() {
    cp ~/trayio/.npmrc-trayio-read ~/.npmrc
    cp ~/trayio/.yarnrc-trayio-read.yml ~/.yarnrc.yml
}

npmTrayioWrite() {
    cp ~/trayio/.npmrc-trayio-write ~/.npmrc
    cp ~/trayio/.yarnrc-trayio-write.yml ~/.yarnrc.yml
}
