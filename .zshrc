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

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

alias lsl="ls -la"
