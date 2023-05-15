# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
if [ -n "$(which nvim)" ]; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Virualenvwrapper
for VENV_PATH in /usr/local/bin/virtualenvwrapper.sh /usr/share/virtualenvwrapper/virtualenvwrapper.sh $HOME/.local/bin/virtualenvwrapper.sh $HOME/Library/Python/3.7/bin/virtualenvwrapper.sh; do
  if [ -f "$VENV_PATH" ]; then
    export WORKON_HOME=$HOME/virtenvs
    export VIRTUALENVWRAPPER_PYTHON=$(which python3)
    source $VENV_PATH
    break
  fi;
done

if [ -d /usr/local/cuda/extras/CUPTI/lib64 ]; then
  export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64
fi;

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f $HOME/.bash_aliases ]; then
    . $HOME/.bash_aliases
fi

# Setup node env variables.
export NODE_OPTIONS="--experimental-repl-await"

if [ "$(uname -s)" = Darwin ]; then
  # On Mac, add Apple's WiFi utilities to PATH.
  export PATH=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/:$PATH
  export PATH=$HOME/Library/Python/3.7/bin/:$PATH
fi

# Add Android home env variables to make Android development work properly.
if [ -d "/usr/local/share/android-sdk" ]; then
  export ANDROID_HOME=/usr/local/share/android-sdk
  export ANDROID_NDK=/usr/local/share/android-ndk
  export ANDROID_SDK_ROOT=/usr/local/share/android-sdk
  # this is an optional gradle configuration that should make builds faster
  export GRADLE_OPTS='-Dorg.gradle.daemon=true -Dorg.gradle.parallel=true -Dorg.gradle.jvmargs="-Xmx4096m -XX:+HeapDumpOnOutOfMemoryError"'
  # Add the emulator and Android tools to path
  export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$PATH"
fi

# Setup jenv for Java version management.
if [ -n "$(which jenv)" ]; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# Set PATH so it includes user's private bin if it exists.
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Use the prefered go installation.
#if [ -d "$HOME/go" ] ; then
#    export GOROOT=$HOME/go
#    PATH=$GOROOT/bin:$PATH
if [ -d "/usr/local/go" ] ; then
    # Default Go installation location.
    export GOROOT=/usr/local/go
    PATH=$GOROOT/bin:$PATH
fi

## If asdf is installed, load it into the environment.
if [ -d "$HOME/.asdf" ]; then
  . "$HOME/.asdf/asdf.sh"
  . "$HOME/.asdf/completions/asdf.bash"
fi

# Load pyenv and pyenv-virtualenv if it is installed.
if [ -n "$(which pyenv)" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv > /dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Set up the cargo bin directory for Rust.
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Disable the "deprecation" notice for bash on MacOS Catalina.
export BASH_SILENCE_DEPRECATION_WARNING=1

# On MacOS, If Homebrew is installed to /opt, add it to path.
if [ -d "/opt/homebrew" ]; then
  eval $(/opt/homebrew/bin/brew shellenv)

  # If openssh is installed via homebrew, setup PATH to point to it.
  OPENSSH_PATH="$(brew --prefix openssh)"
  if [ -d "$OPENSSH_PATH" ]; then
    export PATH="$OPENSSH_PATH/bin:$PATH"
  fi
fi

if [ -n "$(which brew)" ]; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# Set up git tab completion.
if [ -f "$HOME/.git-completion.bash" ]; then
    . "$HOME/.git-completion.bash" 
fi

# Set up flyctl for fly.io
if [ -d "$HOME/.fly" ]; then
  export FLYCTL_INSTALL="$HOME/.fly"
  export PATH="$FLYCTL_INSTALL/bin:$PATH"
fi

# Set up kubectl tab completion.
if [ -n "$(which kubectl)" ]; then
    . <(kubectl completion bash)
fi

# Ensure we have a running SSH agent.
if [ -n "$(which ssh-agent)" ]; then
  # Where this script stores info about the running SSH agent.
  export SSH_AGENT_INFO=$HOME/.ssh/agent_info

  # If there is an agent info file, load it.
  if [ -f $SSH_AGENT_INFO ]; then
    . $SSH_AGENT_INFO > /dev/null
  fi

  # First check if a socket path is defined. Note that OSX defines this as the keychain agent.
  if [ -z "$SSH_AUTH_SOCK" ]; then
    export SSH_AUTH_SOCK=$HOME/.ssh/auth_sock
  fi

  # If a previously started SSH agent is using the socket, we are done.
  case $SSH_AUTH_SOCK in
    # If the AUTH_SOCK is in the private Apple directory, we won't be able to test it. Skip.
    /private/tmp/com.apple.launchd*);;

    # Check that the auth agent is alive, and start it if it is not.
    *) if \
        ([ -z "$SSH_AGENT_PID" ] || ! kill -0 "$SSH_AGENT_PID") &&\
        ! fuser "$SSH_AUTH_SOCK" >/dev/null 2>/dev/null; then
        # A running ssh agent has not been found, so start one now.
        ssh-agent -a "$SSH_AUTH_SOCK" -s > $HOME/.ssh/agent_info
      else
        printf "export SSH_AGENT_PID=\"$SSH_AGENT_PID\"\nexport SSH_AUTH_SOCK=\"$SSH_AUTH_SOCK\"\n" \
          > "$SSH_AGENT_INFO"
      fi;;
    esac
fi

# This must be at the end of the file for sdkman to work.
if [[ -s "/home/nate/.sdkman/bin/sdkman-init.sh" ]]; then
    export SDKMAN_DIR="/home/nate/.sdkman"
    source "/home/nate/.sdkman/bin/sdkman-init.sh"
fi

# If tmux is installed attach atomatically and exit bash when it quits
if command -v tmux>/dev/null; then
    if [[ ! $TERM =~ screen ]] && [ -z $TMUX ]; then
        # Now attach to the existing tmux session or start a new one.
        tmux attach -t "^-^" || tmux new-session -s "^-^"
    fi
fi
