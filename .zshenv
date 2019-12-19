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


#
# In order to keep your .zsh config files in a separate directory (e.g. ~/.zsh/)
# Write your ~/.zshenv file as follows:
#
# ZDOTDIR=$HOME/.zsh
# . $ZDOTDIR/.zshenv
#

# Use this .zshenv sparingly, as it executes for everything, including scripts.
# Most Configuration should likely be put into .zshrc.
#
# Discussion below taken from:
# https://scriptingosx.com/2019/06/moving-to-zsh-part-2-configuration-files/
# >>
#   Mac OS Terminal considers every new shell to be a login shell and an interactive shell.
#   So, in Terminal a new zsh will potentially run all configuration files.
#
#   Most tools you can download to configure zsh, such as ‘prezto’ or ‘oh-my-zsh’,
#   will override or re-configure your .zshrc.
#
#   You could consider moving your code to .zlogin instead.
#   Since .zlogin is sourced after .zshrc it can override settings from .zshrc.
#   However, .zlogin is only called for login shells.
#
#   The most common situation where you do not get a login shell with macOS Terminal,
#   is when you switch to zsh from another shell by typing the zsh command.

