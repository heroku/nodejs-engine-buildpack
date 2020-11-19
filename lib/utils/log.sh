#!/usr/bin/env bash

status() {
  local color="\033[1;38;2;157;112;208m"
  local no_color="\033[0m"
  echo -e "\n${color}[${1:-""}]${no_color}"
}

info() {
  echo -e "[INFO] ${1:-""}"
}

error() {
  local color="\033[1;38;2;0;0;0;48;2;214;65;65m"
  local no_color="\033[0m"

  echo -e "\n${color}[Error: ${1:-""}]${no_color}"
}

warning() {
  local color="\033[1;38;2;0;0;0;48;2;250;159;71m"
  local no_color="\033[0m"

  echo -e "\n${color}[Warning: ${1:-""}]${no_color}"
}

notice() {
  local color="\033[1;38;2;64;143;236m"
  local no_color="\033[0m"

  echo -e "\n${color}[Notice: ${1:-""}]${no_color}"
}
