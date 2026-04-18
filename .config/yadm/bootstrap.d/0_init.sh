#!/bin/bash
## BASE CONFIG

case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*)
    export OS='linux'
    sudo apt -y install \
        fontconfig
    ;;
  darwin*)
    export OS='macosx'
    ;;
  *)
    export OS='unknown'
    ;;
esac

# Set yadm class if not already configured.
# Override on work machines with: yadm config local.class BlackDuck
if [[ -z "$(yadm config local.class)" ]]; then
  echo "Setting yadm local.class to Personal (default)"
  yadm config local.class Personal
fi

yadm alt

