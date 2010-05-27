#! /bin/bash

#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2, or (at your option)
#   any later version.

# bash_completion for latexmk
#
#
# Author:  Christoph Junghans
#          junghans@mpip-mainz.mpg.de
#
# Revision history:
#  0.1   26-05-10 --- initial version
#
# HOWTO:
# source this file to enable it

_latexmk()
{
  #we have perl due to the fact that latexmk is written in perl
  local cur output opts prev
  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]}

  output=$( $1 -help 2> /dev/null)
  #options with args
  aopts=" $( echo " $output" | sed -n 's/^[[:space:]]\+\(-[^[:space:]]\+\)[[:space:]]\+<[^>]\+>.*$/\1/p' | sort -u | tr '\n' ' ')"
  #if previous option in in $aopts
  if [[ -n "$prev" ]] && [[ -z "${aopts//* $prev *}" ]]; then
    #argument of $pres
    opts=$(echo "$output" | sed -n "s/^[[:space:]]\+$prev[[:space:]]\+\(<[^>]\+>\).*\$/\1/p")
    COMPREPLY=( $( compgen -W '$opts' -- $cur ) )
  elif [[ "$cur" == -* ]]; then
    #all options
    opts=$( echo "$output" | sed -n 's/^[[:space:]]\+\(-[^[:space:]]\+\).*$/\1/p'| sort -u )
    COMPREPLY=( $( compgen -W '$opts' -- $cur ) )
  else
    #filenames *.tex and dirs, rest is done by '-o filenames' below
    COMPREPLY=( $( eval compgen -f -X "!*.tex" -- ${cur} ) $( compgen -d -- $cur ) )
  fi
}

complete -F _latexmk -o filenames latexmk
