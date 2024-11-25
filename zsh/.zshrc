source <(kubectl completion zsh) # Load kubectl completion

add-zsh-hook precmd reload_history # Set up a hook to reload history before each prompt, ensuring up-to-date history across all terminal sessions

EDITOR=nvim # Set the default editor to neovim
VISUAL=nvim # Set the default visual editor to neovim
export KUBE_EDITOR=$(which nvim)

# ZSH PLUGINS
plugins=(zsh-autosuggestions) # Load zsh-autosuggestions

# RPROMPT START
function k8s_info() { # Function to display the current k8s context and namespace
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

function git_branch() { # Function to display the current git branch
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [[ -z "$branch" ]]; then
        branch="N/A"
    fi
    echo "%{$fg[yellow]%}$branch%{$reset_color%}"
}

function bothon() { # Function to enable both git and k8s info in the rprompt
    setopt PROMPT_SUBST
    RPROMPT='[$(git_branch)] [$(k8s_info)]'
    echo "on" > ~/.git_prompt_state
}

function bothoff() { # Function to disable both git and k8s info in the rprompt
    RPROMPT=''
    echo "off" > ~/.git_prompt_state
}

bothon # Enable both git and k8s info in the rprompt by default

# RPROMPT END

# RANDOM EMOJI ON LOAD
emojis=("⚡️" "🔥" "🍕" "🍔" "👑" "😎" "🙈" "🐵" "🦄" "🌈" "🚀" "🎉" "🔑" "👀" "🚦" "🎲" "❤️")
RAND_EMOJI_N=$(($RANDOM % ${#emojis[@]} + 1))
PS1="${emojis[$RAND_EMOJI_N]} %1~: "

# LOG ALL HISTORY TO FILE
# Original idea came from https://www.justinjoyce.dev/save-your-shell-history-to-log-files/
preexec() {
  if [ "$(id -u)" -ne 0 ]; then
    local git_branch="N/A"
    local kube_context="N/A"
    local user="$(whoami)"
    local pwd="$(pwd)"
    local date="$(date "+%d-%m-%YT%H:%M:%S")"
    local uptime="$(uptime)"
    local pid="$$"
    local command="$3"

    if command -v git &>/dev/null; then
      git_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A")"
    fi

    if command -v kubectl &>/dev/null; then
      kube_context="$(kubectl config current-context 2>/dev/null || echo "N/A")"
    fi

    echo "{
      \"date\": \"$date\",
      \"user\": \"$user\",
      \"pwd\": \"$pwd\",
      \"uptime\": \"$uptime\",
      \"pid\": \"$pid\",
      \"git_branch\": \"$git_branch\",
      \"kube_context\": \"$kube_context\",
      \"command\": \"$command\"
    }," >> ~/.logs/zsh-history-$(date "+%d-%m-%Y").log
  fi
}

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
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY          # Share history between all sessions

reload_history() { # Function to reload history
    fc -R ~/.zsh_history
}

add-zsh-hook precmd reload_history # Set up a hook to reload history before each prompt, ensuring up-to-date history across all terminal sessions

# ALIASES
if [ -e $HOME/.zsh_aliases ]; then # Load aliases if the file exists
  source $HOME/.zsh_aliases
fi

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # Load fzf if it exists

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ZINIT
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git" # Set the directory we want to store zinit and plugins

if [ ! -d "$ZINIT_HOME" ]; then # If zinit is not installed, install it
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
eval "$(fzf --zsh)" # Load fzf shell integrations
eval "$(zoxide init --cmd cd zsh)" # Load zoxide shell integrations
eval "$(fnm env --use-on-cd)" # Load fnm shell integrations

generateEmptyNpmrcFile() { # Function to generate an empty npmrc file
  echo "" >~/.npmrc
}

generateEmptyYarnrcFile() { # Function to generate an empty yarnrc file
  echo "" >~/.yarnrc.yml
}

npmPersonal() { # Function to set up the npmrc and yarnrc files for personal use
  generateEmptyNpmrcFile
  generateEmptyYarnrcFile
  cp ~/.npmrc-personal ~/.npmrc
  cp ~/.yarnrc-personal.yml ~/.yarnrc.yml
}

npmTrayioRead() { # Function to set up the npmrc and yarnrc files for Tray.io read access
  generateEmptyNpmrcFile
  generateEmptyYarnrcFile
  cp ~/.npmrc-trayio-read ~/.npmrc
  cp ~/.yarnrc-trayio-read.yml ~/.yarnrc.yml
}

npmTrayioWrite() { # Function to set up the npmrc and yarnrc files for Tray.io write access
  generateEmptyNpmrcFile
  generateEmptyYarnrcFile
  cp ~/.npmrc-trayio-write ~/.npmrc
  cp ~/.yarnrc-trayio-write.yml ~/.yarnrc.yml
}

gitClean() { # Function to clean up git branches that have been deleted
  git branch -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -d
}

gitCleanF() { # Function to clean up git branches that have been deleted FORCEFULLY
  git branch -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -D
}

gitCleanFA() { # Function to clean up ALL git branches FORCEFULLY
  git branch -vv | grep -v "\*" | awk '{ print $1; }' | xargs -r git branch -D
}
