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

