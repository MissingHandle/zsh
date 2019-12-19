#!/bin/zsh.

##
#
# ZSH Configuration Files
#
##

# file      | login shell | interactive shell | scripts | Terminal.app
# .zshenv   |      √      |         √         |    √    |        √
# .zprofile |      √      |         x         |    x    |        √
# .zshrc    |      √      |         √         |    x    |        √
# .zlogin   |      √      |         x         |    x    |        √
# .zlogout  |      √      |         x         |    x    |        √

alias lsl="ls -la"

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
