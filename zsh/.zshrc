source <(kubectl completion zsh)

EDITOR=nvim
VISUAL=nvim

# ZSH PLUGINS
plugins=(zsh-autosuggestions)

# KUBE RPROMPT
function k8s_info() {
    local context=$(kubectl config current-context 2>/dev/null)
    local namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    if [[ -z "$context" ]]; then
        context="no-context"
    fi
    if [[ -z "$namespace" ]]; then
        namespace="default"
    fi
    echo "%{$fg[red]%}$context%{$reset_color%}:%{$fg[green]%}$namespace%{$reset_color%}"
}

# function kubeon() {
#     setopt PROMPT_SUBST
#     RPROMPT='[$(k8s_info)]'
#     echo "on" > ~/.kube_prompt_state
# }

# function kubeoff() {
#     RPROMPT=''
#     echo "off" > ~/.kube_prompt_state
# }

# if [ -f ~/.kube_prompt_state ]; then
#     KUBE_PROMPT_STATE=$(cat ~/.kube_prompt_state)
#     if [[ "$KUBE_PROMPT_STATE" == "on" ]]; then
#         kubeon
#     else
#         kubeoff
#     fi
# else
#     kubeon
# fi
### END KUBE RPROMPT

function bothon() {
    setopt PROMPT_SUBST
    RPROMPT='[$(git_branch)] [$(k8s_info)]'
    echo "on" > ~/.git_prompt_state
}

bothon

function bothoff() {
    RPROMPT=''
    echo "off" > ~/.git_prompt_state
}

# GIT RPROMPT
function git_branch() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -z "$branch" ]]; then
        branch="N/A"
    fi
    echo "%{$fg[yellow]%}$branch%{$reset_color%}"
}

# function giton() {
#     setopt PROMPT_SUBST
#     RPROMPT='[$(git_branch)]'
#     echo "on" > ~/.git_prompt_state
# }

# function gitoff() {
#     RPROMPT=''
#     echo "off" > ~/.git_prompt_state
# }

# if [ -f ~/.git_prompt_state ]; then
#     GIT_PROMPT_STATE=$(cat ~/.git_prompt_state)
#     if [[ "$GIT_PROMPT_STATE" == "on" ]]; then
#         giton
#     else
#         gitoff
#     fi
# else
#     giton
# fi
### END GIT RPROMPT

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

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
# zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found
zinit snippet OMZP::terraform

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(fnm env --use-on-cd)"

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
