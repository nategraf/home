# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Load configurations shared in Bash and ZSH
# NOTE: Starts tmux if this shell is not already attached. This line will only return if tmux is
# exited, or the shell is already running in tmux.
source ~/.shrc

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# FZF settings
if [ -f ~/.fzf.zsh ]; then
  # HACK: Load fzf keybindings in the zsh vi mode hook for post-init.
  # This allows the fzf keybinds (ctrl-r in particular) to take precedence over vi modes.
  function load_fzf_keybinds() {
    source ~/.fzf.zsh

    bindkey -M vicmd '^p' fzf-file-widget
    bindkey -M viins '^p' fzf-file-widget
  }
  zvm_after_init_commands+=load_fzf_keybinds
elif [ -d ~/.fzf ]; then
  # If fzf is cloned, but not installed, install it now.
  ~/.fzf/install --no-bash --key-bindings --completion --no-update-rc
fi

# Load antigen and Oh My ZSH with ZSH plugins
#
# Awesome Zsh Plugins: https://github.com/unixorn/awesome-zsh-plugins
# Antigen: https://github.com/zsh-users/antigen
# Oh My Zsh: https://github.com/ohmyzsh/ohmyzsh

source ~/.antigen.zsh

antigen use oh-my-zsh

antigen bundles <<BUNDLES
  extract
  colorize

  git
  git-extras
  docker
  tailscale
  github
  tmux
  screen

  ael-code/zsh-colored-man-pages
  jeffreytse/zsh-vi-mode
BUNDLES

antigen theme romkatv/powerlevel10k
antigen apply

# Bind the up and down arrows to use history-substring-search and set search options.
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/history-substring-search
#bindkey '^[[A' history-substring-search-up
#bindkey '^[[B' history-substring-search-down
#bindkey -M viins '^[[A' history-substring-search-up
#bindkey -M viins '^[[B' history-substring-search-down
#bindkey -M vicmd 'k' history-substring-search-up
#bindkey -M vicmd 'j' history-substring-search-down

HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE="true"

# Completion settings.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'               # case insensitive completion.
zstyle ':completion:*' insert-tab pending                               # pasting with tabs doesn't perform completion
zstyle ':completion:*' completer _extensions _expand _complete _correct # default to file completion
zstyle ':completion:*' use-cache on

setopt GLOB_COMPLETE # trigger the completion after a glob * instead of expanding it.

# Add .zfunc and asdf to ZSH fpath to load completion scripts stored there.
fpath+="$HOME/.zfunc"
fpath=(${ASDF_DIR}/completions $fpath)

# Bind ctrl-j/k/h/l to naviagte the completion list.
zmodload zsh/complist
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^j' vi-down-line-or-history
bindkey -M menuselect '^l' vi-forward-char
bindkey -M menuselect '^l' vi-forward-char

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder    # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Load p10k command prompt configuration.
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# bun completions
[ -s "/Users/victorgraf/.bun/_bun" ] && source "/Users/victorgraf/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
