#!/bin/bash
## BASE CONFIG

case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*)
    export OS='linux'
    ;;
  darwin*)
    export OS='macosx'
    ;;
  *)
    export OS='unknown'
    ;;
esac


