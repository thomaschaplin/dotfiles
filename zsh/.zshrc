eval "$(fnm env --use-on-cd)"

# ZSH PLUGINS
plugins=(zsh-autosuggestions)

# RANDOM EMOJI ON LOAD
emojis=("⚡️" "🔥" "🍕" "🍔" "👑" "😎" "🙈" "🐵" "🦄" "🌈" "🚀" "🎉" "🔑" "👀" "🚦" "🎲" "❤️")
RAND_EMOJI_N=$(($RANDOM % ${#emojis[@]} + 1))
PS1="${emojis[$RAND_EMOJI_N]} %1~: "

# ALIAS
if [ -e $HOME/.zsh_aliases ]; then
  source $HOME/.zsh_aliases
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

generateEmptyNpmrcFile() {
  echo "" >~/.npmrc
}

generateEmptyYarnrcFile() {
  echo "" >~/.yarnrc.yml
}

npmPersonal() {
  generateEmptyNpmrcFile
  generateEmptyYarnrcFile
  cp ~/.npmrc-personal ~/.npmrc
  cp ~/.yarnrc-personal.yml ~/.yarnrc.yml
}

npmTrayioRead() {
  generateEmptyNpmrcFile
  generateEmptyYarnrcFile
  cp ~/.npmrc-trayio-read ~/.npmrc
  cp ~/.yarnrc-trayio-read.yml ~/.yarnrc.yml
}

npmTrayioWrite() {
  generateEmptyNpmrcFile
  generateEmptyYarnrcFile
  cp ~/.npmrc-trayio-write ~/.npmrc
  cp ~/.yarnrc-trayio-write.yml ~/.yarnrc.yml
}

gitClean() {
  git branch -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -d
}

gitCleanF() {
  git branch -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -D
}

gitCleanFA() {
  git branch -vv | grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -D
}
