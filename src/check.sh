#!/usr/bin/env bash

# @file Check
# @brief Helper functions.

# @description Check if the command exists in the system.
#
# @example
#   check::command_exists "tput" && echo "yes" || echo "no"
#
# @arg $1 string Command name to be searched.
#
# @exitcode 0 If the command exists.
# @exitcode 1 If the command does not exist.
# @exitcode 2 Function missing arguments.
check::command_exists() {
    (( $# == 0 )) && return 2
    hash "${1}" 2> /dev/null
}

# @description Check if the script is running with root privileges.
#
# @example
#   check::is_sudo && echo "yes" || echo "no"
#
# @noargs
#
# @exitcode 0 If the script is executed with root privilege.
# @exitcode 1 If the script is not executed with root privilege
check::is_sudo() {
    (( $(id -u) == 0 )) && return 0 || return 1
}
