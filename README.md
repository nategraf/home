## Install

In the home directory, running the following commands will setup this repo (and demolish anything that was already there).

```sh
git init -b main
git remote add https://github.com/nategraf/home
git reset --hard origin/main
git submodule update --init
```

## Tools

Here is a listed of the tools that should additionally be installed to make use of this working setup:

* git
* zsh
* tmux
* neovim (https://github.com/neovim/neovim/blob/master/INSTALL.md)
* bat (https://github.com/sharkdp/bat) (`cargo install --locked bat`)
* delta (https://github.com/dandavison/delta.git) (`cargo insall --locked git-delta`)
* mosh (https://mosh.org/)
* ag (https://github.com/ggreer/the_silver_searcher)

### Rust

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### asdf

In asdf, install the following runtimes:

```sh
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs $(asdf list nodejs | head -n1)
asdf plugin add python
asdf install python latest
asdf global python $(asdf list python | head -n1)
asdf current
```

Python is built from source, and so will require a C compiler along with some libraries.
On Debian, this can be installed as:

```sh
apt install build-essential zlib1g-dev libssl-dev libreadline-dev libffi-dev
```
