#!/usr/bin/env bash

# @file File
# @brief Functions for handling files.

# @description Create temp file.
# This function creates temp file with random name and prints its name to stdout.
#
# @example
#   temp=$(file::make_temp_file)
#   trap "rm -f \"$temp\"" EXIT
#   printf "%s\n" "$temp"
#   #Output
#   /tmp/tmp.vgftzy
#
# @arg $1 string Directory where to create the file (optional). Defaults to /tmp.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure to create temp file.
#
# @stdout Name of the created temp file.
file::make_temp_file() {
    local pre="${1:-/tmp}"

    type -p mktemp &> /dev/null && mktemp -p "$pre" || {
        local tmp="${pre}/tmp.$((RANDOM * RANDOM))"
        touch "$tmp" && printf "%s\n" "$tmp"
    }
}

# @description Create temp directory.
# This function creates temp directory with random name and prints its name to stdout.
#
# @example
#   temp=$(file::make_temp_dir)
#   trap "rm -rf \"$temp\"" EXIT
#   printf "%s\n" "$temp"
#   #Output
#   /tmp/tmp.rtfsxy
#
# @arg $1 string Temp directory prefix (optional). Defaults to /tmp.
#
# @exitcode 0 If successful.
# @exitcode 1 On failure to create temp directory.
#
# @stdout Name of the created temp directory.
file::make_temp_dir() {
    local pre="${1:-/tmp}"

    type -p mktemp &> /dev/null && mktemp -d -p "$pre" || {
        local tmp="${pre}/tmp.$((RANDOM * RANDOM))"
        mkdir "$tmp" && printf "%s\n" "$tmp"
    }
}

# @description Strip leading directory(ies) from a given path.
#
# @example
#   file::basename "/path/to/test.tar.gz"
#   #Output
#   test.tar.gz
#
# @example
#   file::basename "/foo/bar/"
#   #Output
#   bar
#
# @arg $1 string Path to file or directory.
#
# @exitcode 0 If successful.
# @exitcode 2 Function missing arguments.
#
# @stdout Final component of the path without the leading directory(ies).
file::basename() {
    (( $# == 0 )) && return 2

    local old_state="$(shopt -p extglob)"
    shopt -s extglob
    local clean="${1%%+(/)}"
    eval "$old_state"

    printf "%s" "${clean##*/}"
}

# @description Extract final extension from a given path.
#
# @example
#   file::extension "/path/to/test.tar.gz"
#   #Output
#   .gz
#
# @example
#   file::extension "/foo.bar/baz" || echo "none"
#   #Output
#   none
#
# @arg $1 string Path to file or directory.
#
# @exitcode 0 If successful.
# @exitcode 1 If no extension was found.
# @exitcode 2 Function missing arguments.
#
# @stdout Final extension.
file::extension() {
    local base
    base="$(file::basename "$1")" || return

    local ext="${base##*.}"
    [[ "$ext" != "$base" ]] && printf ".%s" "$ext" || return 1
}

# @description Remove final extension from a given path.
#
# @example
#   file::name "foo.bar.baz"
#   #Output
#   foo.bar
#
# @example
#   file::name "/path/to/test.tar.gz"
#   #Output
#   /path/to/test.tar
#
# @arg $1 string Path to file or directory.
#
# @exitcode 0 If successful.
# @exitcode 2 Function missing arguments.
#
# @stdout Path without the final extension.
file::name() {
    local ext
    ext="$(file::extension "$1")" || return

    local old_state="$(shopt -p extglob)"
    shopt -s extglob
    local name="${1%${ext}+(/)}"
    eval "$old_state"

    printf "%s" "$name"
}

# @description Extract leading directory(ies) from a given path.
#
# @example
#   file::dirname "/path/to/test.tar.gz"
#   #Output
#   /path/to
#
# @example
#   file::dirname "/foo/bar/"
#   #Output
#   /foo
#
# @arg $1 string Path to file or directory.
#
# @exitcode 0 If successful.
# @exitcode 2 Function missing arguments.
#
# @stdout Leading directory(ies) of the path.
file::dirname() {
    (( $# == 0 )) && return 2

    local dirs="$1"
    [[ "$dirs" =~ ^/+$ ]] && dirs="/x" # make our life easier

    local old_state="$(shopt -p extglob)"
    shopt -s extglob
    dirs="${dirs%%+([^/])*(/)}"
    eval "$old_state"

    [[ "$dirs" != "/" ]] && dirs="${dirs%/}"

    printf "%s" "${dirs:-.}"
}

# @description Convert given path to an absolute (full) path.
#
# @example
#   file::full_path "../path/to/file.md"
#   #Output
#   /home/user/doc/path/to/file.md
#
# @arg $1 string Path to file or directory.
#
# @exitcode 0 If successful.
# @exitcode 1 If the file/directory does not exist.
# @exitcode 2 Function missing arguments.
#
# @stdout Absolute (full) path to the file or directory.
file::full_path() {
    (( $# == 0 )) && return 2

    if [[ -f "$1" ]]; then
        local dir="$(file::dirname "$1")" base="$(file::basename "$1")"
        printf "%s/%s" "$(cd "$dir" && pwd)" "$base"
    elif [[ -d "$1" ]]; then
        printf "%s" "$(cd "$1" && pwd)"
    else
        return 1
    fi
}

# @description Get MIME type of a given path.
#
# @example
#   file::mime_type "../src/file.sh"
#   #Output
#   application/x-shellscript
#
# @arg $1 string Path to file or directory.
#
# @exitcode 0 If successful.
# @exitcode 1 If the file/directory does not exist.
# @exitcode 2 Function missing arguments.
# @exitcode 3 If neither `file` nor `mimetype` were found on the system.
#
# @stdout MIME type of the file/directory.
file::mime_type() {
    (( $# == 0 )) && return 2

    [[ ! -f "$1" && ! -d "$1" ]] && return 1

    if type -p mimetype &> /dev/null; then
        printf "%s" "$(mimetype --output-format %m "$1")"
    elif type -p file &> /dev/null; then
        printf "%s" "$(file --brief --mime-type "$1")"
    else
        return 3
    fi
}

# @description Check if the file contains given pattern.
#
# @example
#   file::contains "./file.sh" "^[ @[:alpha:]]*"
#   file::contains "./file.sh" "@file"
#   #Output
#   0
#
# @arg $1 string Path to file.
# @arg $2 string Pattern (regular expression) to be searched.
#
# @exitcode 0 If the given pattern was found in file.
# @exitcode 1 Otherwise.
# @exitcode 2 Function missing arguments.
file::contains() {
    (( $# != 2 )) && return 2
    grep -q "$2" "$1"
}
