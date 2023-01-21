# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Common utility aliases.
alias g="git "
alias py2="python "
alias py="python3 "
alias ipy="ipython3 "
alias ipy2="ipython "
alias ovs="ovs-vsctl "
alias kc="kubectl "
alias netadminsh='sudo setpriv --inh-caps "+net_admin,+net_raw,+net_bind_service" --ambient-caps "+net_admin,+net_raw,+net_bind_service" --reuid $USER --regid $(id -g) --init-groups --reset-env $SHELL'

s(){
    command sudo "$@"
}
export -f s

capme() {
    if [ -z "$1" ]; then
        echo "usage: capme <capability string>; see man setpriv" && return 1
    fi

    capstring=$1
    shift

    sudo setpriv --inh-caps "$capstring" --ambient-caps "$capstring" --reuid $USER --regid $(id -g) --init-groups --reset-env $SHELL
}

# Use sudo on linux, but not on Mac
case "$(uname -s)" in
    Darwin*)    DOCKER_CMD_PREFIX="";;
    *)          DOCKER_CMD_PREFIX="sudo"
esac

dk() {
    case "$1" in
        purge)
            shift
            command $DOCKER_CMD_PREFIX docker rm -f $($DOCKER_CMD_PREFIX docker ps -qa) "$@"
            ;;
        *)
            command $DOCKER_CMD_PREFIX docker "$@"
            ;;
    esac
}
export -f dk

dkc() {
    case "$1" in
        kick)
            shift
            command $DOCKER_CMD_PREFIX docker-compose up -d --force-recreate $@
            ;;
        watch)
            while /bin/true; do
                shift
                $DOCKER_CMD_PREFIX docker-compose logs -f $@
                sleep 2
                clear
            done
            ;;
        *)
            command $DOCKER_CMD_PREFIX docker-compose $@
            ;;
    esac
}
export -f dkc

dkenter() {
    if [ -z "$1" ]; then
        echo "usage: dkenter <container> [nsenter flags]" && return 1
    fi
    container=$1
    shift
    sudo nsenter -t $($DOCKER_CMD_PREFIX docker inspect "$container" -f '{{ .State.Pid }}') $@
}
export -f dkenter

bell() {
    tput bel
}
export -f bell

ttime() {
    WAIT="$(bc -l <<< "${1:-5}*60")"
    echo "Tea ready in $WAIT seconds" && \
    sleep "$WAIT" && \
    echo 'TEA TIME!' && \
    bell && \
    if [ -n $(which say) ]; then
        say "tea is ready"
    fi
}
export -f ttime

randstring() {
    python3 -c "import os; import base64; print(base64.b32encode(os.urandom(${1:-32})).decode('utf-8').strip('='))"
}
export -f randstring

randhex() {
    python3 -c "import os; import base64; print(base64.b16encode(os.urandom(${1:-32})).decode('utf-8').lower())"
}
export -f randhex

# Add some modifications to Node.js REPL
nodex() {
    if [ $(command -v rlwrap) ]; then
        NODE_NO_READLINE=1 rlwrap node --experimental-repl-await
    else
        node --experimental-repl-await
    fi
}
export -f nodex

cdtmp() {
  cd $(mktemp -d)
}
export -f cdtmp

math() {
  echo "$*" | bc -l
}
export -f math

# Utility on Linux to add the provided capabilties to a new as ambient, makes them automatically
# See `man capabilties` for more details.
# Note: Requires a recent build of capsh (e.g. from git.kernel.org/pub/scm/libs/libcap/libcap.git)
reqcaps() {
  if [ -z "$1" ]; then
      echo "usage: reqcaps <capabilties>" && return 1
  fi
  capabilties=$1
  shift
  calling_user=$USER

  # Why isn't there a shorter command for this? ¯\_(ツ)_/¯
  sudo capsh --caps="${capabilties}+i" -- -c "capsh --user=${calling_user} --addamb='${capabilties}' --"
}
export -f reqcaps

# Open stdin in Vim read-only mode. Useful for looking at command outputs.
vimr() {
    vim -R - $@
}

# Only define the following functions when in Bash.
# These use non-standard names and I am too stuborn to change them.
if [ "$0" = "-bash" ]; then
  dkln() {
      if [ -z "$1" ]; then
          echo "usage: dkln <container> <ln path>" && return 1
      fi

      id=$($DOCKER_CMD_PREFIX docker inspect -f '{{.Id}}' $1)
      if [ -z "$id" ]; then
          echo "container $1 not found" && return 1
      fi
      shift

      root="$(sudo cat /var/run/docker/runtime-runc/moby/$id/state.json | python3 -c 'import sys, json; sys.stdout.write(json.load(sys.stdin)["config"]["rootfs"])')"
      if [ -z "$root" ]; then
          echo "failed to identify rootfs for $id" && return 1
      fi

      sudo ln -s $root $@
  }
  export -f dkln

  # Kill all but the most recent mosh session.
  mosh-highlander() {
      zombies=$(ps h -C mosh-server -o pid --sort start_time | head -n -1)
      if [ -z "$zombies" ]; then
          echo "There is only one!";
      else
          echo "There can only be one!"
          kill $zombies
      fi
  }

  # Quickly create an ssh tunnel
  ssh-tunnel() {
      if [ -z "$1" ] || [ -z "$2" ]; then
          echo "usage (see man ssh -L option): ssh-tunnel [bind_address:]port:host:hostport remote" && return 1
      fi
      ssh -N -L "$1" "$2"
  }
fi

