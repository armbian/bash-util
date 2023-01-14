#!/usr/bin/env bash

# @file Debug
# @brief Functions to facilitate debugging.

# @description Print the contents of an array as key-value pairs.
# Pass the name of the array variable instead of its value.
#
# @example
#   arr=(foo bar baz)
#   printf "Array:\n"
#   debug::print_array "arr"
#   #Output
#   Array:
#   0 = foo
#   1 = bar
#   2 = baz
#
# @example
#   declare -A arr2=([foo]=bar [baz]=qux)
#   printf "Associative array:\n"
#   debug::print_array "arr2"
#   #Output
#   Associative Array:
#   foo = bar
#   baz = qux
#
# @arg $1 string Name of the array variable.
#
# @stdout Formatted key-value pairs of the array.
debug::print_array() {
    local -n ref="$1"
    for i in "${!ref[@]}"; do
        printf "%s = %s\n" "$i" "${ref[$i]}"
    done
}

# @description Print ANSI escape sequences as-is.
# This function helps debug ANSI escape sequences in text by displaying the escape codes as-is.
#
# @example
#   txt="$(tput bold)$(tput setaf 9)This is bold red text$(tput sgr0). $(tput setaf 10)This is green text$(tput sgr0)."
#   debug::print_ansi "$txt"
#   #Output
#   \e[1m\e[91mThis is bold red text\e(B\e[m. \e[92mThis is green text\e(B\e[m.
#
# @arg $1 string Input string with optional ANSI escape sequence(s).
#
# @stdout Input string with ANSI escape sequence(s) printed as-is.
debug::print_ansi() {
    printf "%s" "${1//$'\e'/\\e}"
}
