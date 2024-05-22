eval "$(fnm env --use-on-cd)"

source <(kubectl completion zsh)

EDITOR=nvim
VISUAL=nvim

# ZSH PLUGINS
plugins=(zsh-autosuggestions)

# RANDOM EMOJI ON LOAD
emojis=("⚡️" "🔥" "🍕" "🍔" "👑" "😎" "🙈" "🐵" "🦄" "🌈" "🚀" "🎉" "🔑" "👀" "🚦" "🎲" "❤️")
RAND_EMOJI_N=$(($RANDOM % ${#emojis[@]} + 1))
PS1="${emojis[$RAND_EMOJI_N]} %1~: "

# LOG ALL HISTORY TO FILE
# https://www.justinjoyce.dev/save-your-shell-history-to-log-files/
preexec() {if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%d-%m-%Y.%H:%M:%S") $(pwd) $ $3" >> ~/.logs/zsh-history-$(date "+%d-%m-%Y").log; fi}

# HISTORY
HISTSIZE=100000               # https://www.reddit.com/r/zsh/comments/x7uj9e/measuring_the_best_value_of_histsize/
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase                 # If set to `erase' and the same event is found in the history list, that old event gets erased and the current one gets inserted
setopt appendhistory          # Append history to the history file (no overwriting)
setopt sharehistory           # Share history across terminals
setopt hist_expire_dups_first # Expire dupe event first when trimming hist
setopt hist_ignore_space      # Do not record event starting with a space
setopt hist_ignore_all_dups   # Delete old event if new is dupe
setopt hist_save_no_dups      # Do not write dupe event to hist file
setopt hist_ignore_dups       # Do not record consecutive dupe events
setopt hist_find_no_dups      # Do not display previously found event

# Load Aliases
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
