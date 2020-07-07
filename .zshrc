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
# Local Secrets
#
 source "${ZDOTDIR}/../.secretsrc"


#
# Shell Configuration
#

  # Lots of Config Happens in .zpreztorc,
  # which is loaded by this call.
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"

  #
  alias edit_shell='subl ~/.zsh/.zshrc'
  function reload_shell() {
    . ~/.zsh/.zshenv
    . ~/.zsh/.zshrc
  }

  # issue with HEAD^ in git
  # https://github.com/ohmyzsh/ohmyzsh/issues/449
  unsetopt nomatch


#
# Shell
#

  cdpath=(~ ~/Code)

  alias lsl="ls -la"

  port() {
    lsof -nP -i4TCP:$1 | grep LISTEN
  }

#
# Git
#

  alias g='git'
  alias gs='git status --untracked-files'
  alias ga='git add'
  alias gc='git checkout'
  alias gd='git diff'
  alias gdc='git diff --cached'
  alias gb='git branch'
  alias gcm='git commit'
  alias gcmm='git commit -m'
  alias gl='git log'
  alias push='git push'
  alias force='git push --force-with-lease'
  alias pull='git checkout master; git pull; git checkout -'
  alias rebase='git rebase'
  # alias rebase_on_self='git rebase -i `git common-ancestor`'
  alias rmaster='git rebase -i origin/master'
  alias merge='git merge'
  alias soft_reset='git reset --soft HEAD^'

  rebase_self() {
    git rebase --interactive $(git merge-base master HEAD)
  }

  ignore_changes() {
    git update-index --assume-unchanged $1
  }

  unignore_changes() {
    git update-index --no-assume-unchanged $1
  }

  # the -v is specific for finding files that are assume-unchanged,
  # and lowercase h is what is returned for files are assume-unchanged
  ignored_changes() {
    git ls-files -v | grep -I "h "
  }

  # deletes local branches that are not ahead of master / are deleted remotely
  clean_branches() {
    REMOTES="$@";
    if [ -z "$REMOTES" ]; then
      REMOTES=$(git remote);
    fi
    REMOTES=$(echo "$REMOTES" | xargs -n1 echo)
    RBRANCHES=()
    while read REMOTE; do
      CURRBRANCHES=($(git ls-remote $REMOTE | awk '{print $2}' | grep 'refs/heads/' | sed 's:refs/heads/::'))
      RBRANCHES=("${CURRBRANCHES[@]}" "${RBRANCHES[@]}")
    done < <(echo "$REMOTES" )
    [[ $RBRANCHES ]] || exit
    LBRANCHES=($(git branch | sed 's:\*::' | awk '{print $1}'))
    for i in "${LBRANCHES[@]}"; do
      skip=
      for j in "${RBRANCHES[@]}"; do
        [[ $i == $j ]] && { skip=1; echo -e "\033[32m Keeping $i \033[0m"; break; }
      done
      [[ -n $skip ]] || { echo -e "\033[31m $(git branch -D $i) \033[0m"; }
    done
  }


#
# AWS
#

  function set_aws_profile() {
    : "${1?'Usage: set_aws_profile (staging|production)'}"

    if [[ "$1" == "staging" ]] then
      export AWS_PROFILE=clearcover-staging-engineering
      echo "AWS Profile set to staging"
      return
    fi
    if [[ "$1" == "production" ]] then
      export AWS_PROFILE=clearcover-production-engineering
      echo "AWS Profile set to production"
      return
    fi
    echo "unknown clearcover account $1. Acceptable values: staging, production"
  }

  function aws_login() {
    echo "Using gimme-aws-creds to log into AWS for all roles.."
    gimme-aws-creds
    echo "Setting AWS Profile to Staging since this is most common. use 'set_aws_profile' cmd to change"
    set_aws_profile staging
  }

  function awswhoami() {
    echo "Logged into aws as:"
    aws sts get-caller-identity
    echo "Current Profile: $AWS_PROFILE"
  }


#
# Docker
#

  alias dc='docker-compose'
  alias dx="docker-compose exec -it"


#
# Kubernetes
#

  export KUBECONFIG=~/.kube/minkube-local-config:~/.kube/clearcover.staging.kubeconfig:~/.kube/clearcover.production.kubeconfig
  alias kc='kubectl'
  alias kcd='kubectl -n dev'
  alias kcs='kubectl -n staging'
  alias kcp='kubectl -n partner'
  alias kcprod='kubectl -n production'
  alias mk='minikube'

  kcgetcontext() {
    kubectl config current-context
  }
  kcsetcontext() {
    kubectl config use-context $1
  }

#
# Local Postgres Config
#
  # export DB_PORT=5442

#
# Ruby
#

  source /usr/local/share/chruby/chruby.sh

  # chruby - automatically change ruby versions when .ruby-version file found
  source /usr/local/opt/chruby/share/chruby/auto.sh

  #quick rubocop
  qr() {
    git diff --name-only master HEAD | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs rubocop --force-exclusion -a
  }

  alias rubcop="rubocop"


  alias b="bundle"
  alias bi="bundle install"
  alias be="bundle exec"
  alias bu="bundle update"


#
# Typescript / Node
#

  #
  # fnm = fast node manager
  # https://github.com/Schniz/fnm
  #
  eval "`fnm env --multi --use-on-cd`"


#
# Clearcover
#

  alias decrypt_env="jet decrypt codeship.env.encrypted codeship.env.decrypted"
  alias encrypt_env="jet encrypt codeship.env.decrypted codeship.env.encrypted"
  alias fury_push_all="rake build && fury push --api-token=fcJWjG-v9vecAtepC9dR pkg/*"

 port_forward_policy_api() {
  kubectl port-forward deployments/policy-api 1339:1338 -n staging
 }

#
# Harmony
#

  # Policy API Types
  import_types_to_package() {
    echo "deleting generated types directory: cc-typescript/packages/policy-object-model/types/generated"
    rm -rf ~/Code/cc-typescript/packages/policy-object-model/types/generated
    mkdir ~/Code/cc-typescript/packages/policy-object-model/types/generated

    # echo "importing types from policy-api-spec/generated-clients/payments/model"
    # cp -R ~/Code/policy-api-spec/generated-clients/payments/model/ ~/Code/cc-typescript/packages/policy-object-model/types/generated

    echo "importing types from policy-api-spec/generated-clients/typescript-node/model"
    cp -R ~/Code/policy-api-spec/generated-clients/typescript-node/model/ ~/Code/cc-typescript/packages/policy-object-model/types/generated

    rm -f ~/Code/cc-typescript/packages/policy-object-model/types/generated/models.ts
    echo "imported to ~/Code/cc-typescript/packages/policy-object-model/types/generated"
  }


#
# Reznor
#
  # https://stackoverflow.com/questions/52671926/rails-may-have-been-in-progress-in-another-thread-when-fork-was-called
  export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

  alias cdrez='cd ~/code/reznor'
  alias fix_coverage='gc --theirs coverage/.last_run.json'
  alias rez_container='docker-compose exec reznor bash'
  alias rez_bash='docker-compose run --entrypoint /bin/bash reznor'


#
# Rust
#

  # Rust Package Manager
  export PATH="$PATH:$HOME/.cargo/bin"
