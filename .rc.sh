# Set LANG to english with UTF-8
export LANG=en_US.UTF-8

# Use nvim if installed or vim if not.
if which nvim > /dev/null; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

### Binary management

# Set PATH so it includes user's private bin if it exists.
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

## If asdf is installed, load it into the environment.
if [ -d "$HOME/.asdf" ]; then
  . "$HOME/.asdf/asdf.sh"
  if [ -n "$BASH_VERSION" ]; then
    . "$HOME/.asdf/completions/asdf.bash"
  fi
fi

### Node JS

# Enable the await feature in the Node repl
export NODE_OPTIONS="--experimental-repl-await"

### Golang

# Use the prefered go installation.
if [ -d "/usr/local/go" ] ; then
    # Default Go installation location.
    export GOROOT=/usr/local/go
    PATH=$GOROOT/bin:$PATH
fi

### Python

# Load pyenv and pyenv-virtualenv if it is installed.
if which pyenv > /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  command -v pyenv > /dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

### Rust

# Set up the cargo bin directory for Rust.
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# Preference to always have terminal color in Cargo.
# Can be turned off with `unset CARGO_TERM_COLOR`
export CARGO_TERM_COLOR=always

### MacOS

if [ "$(uname -s)" = Darwin ]; then
  # On Mac, add Apple's WiFi utilities to PATH.
  export PATH=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/:$PATH
  export PATH=$HOME/Library/Python/3.7/bin/:$PATH
fi

# If Homebrew is installed to /opt, add it to path.
if [ -d "/opt/homebrew" ]; then
  eval $(/opt/homebrew/bin/brew shellenv)

  # If openssh is installed via homebrew, setup PATH to point to it.
  OPENSSH_PATH="$(brew --prefix openssh)"
  if [ -d "$OPENSSH_PATH" ]; then
    export PATH="$OPENSSH_PATH/bin:$PATH"
  fi
fi

if [ -d "/Applications/CMake.app/Contents/bin/" ]; then
  export PATH="$PATH:/Applications/CMake.app/Contents/bin/"
fi

### Android Development

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

### Infrastructure

# Set up flyctl for fly.io
if [ -d "$HOME/.fly" ]; then
  export FLYCTL_INSTALL="$HOME/.fly"
  export PATH="$FLYCTL_INSTALL/bin:$PATH"
fi

### SSH

# Ensure we have a running SSH agent.
if which ssh-agent > /dev/null; then
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

# Activate the alias commands defned in .aliases.sh
if [ -f $HOME/.aliases.sh ]; then
    . $HOME/.aliases.sh
fi
