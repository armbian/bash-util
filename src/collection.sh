#!/usr/bin/env bash

# @file Collection
# @brief (Experimental) Functions to iterate over a list of elements, yielding each in turn to a predicate function.

# @description Iterate over elements of a collection and invoke predicate function for each one.
# Input to the function can be pipe output, here-string or a file.
#
# @example
#   test_func() {
#      printf "print value: %s\n" "$1"
#   }
#   arr=("a b" "c d" "a" "d")
#   printf "%s\n" "${arr[@]}" | collection::each test_func
#   # alternative version
#   collection::each test_func  < <(printf "%s\n" "${arr[@]}")
#   #Output
#   print value: a b
#   print value: c d
#   print value: a
#   print value: d
#
# @example
#   arr=("a" "a b" "c d" "a" "d")
#   out=("$(array::dedupe "${arr[@]}")")
#   collection::each test_func  <<< "${out[@]}"
#   #Output
#   print value: a
#   print value: a b
#   print value: c d
#   print value: d
#
# @arg $1 string Name of the predicate function.
#
# @exitcode 0 If successful.
# @exitcode 2 Function missing arguments.
# @exitcode ? Exit code returned by the predicate.
#
# @stdout Output of the predicate function.
collection::each() {
    (( $# == 0 )) && return 2

    local it pred="$1" IFS=$'\n'
    while read -r it; do
        if [[ "$pred" == *"$"* ]]; then
            eval "$pred"
        else
            eval "$pred" "'$it'"
        fi || return
    done
}

# @description Check if the predicate returns true for all elements of the collection. Iteration is stopped once the predicate returns false.
# Input to the function can be pipe output, here-string or a file.
#
# @example
#   arr=("1" "2" "3" "4")
#   printf "%s\n" "${arr[@]}" | collection::every "variable::is_numeric"
#
# @arg $1 string Name of the predicate function.
#
# @exitcode 0 If the predicate was true for every element.
# @exitcode 1 Otherwise.
# @exitcode 2 Function missing arguments.
collection::every() {
    (( $# == 0 )) && return 2

    local it pred="$1" IFS=$'\n'
    while read -r it; do
        if [[ "$pred" == *"$"* ]]; then
            eval "$pred"
        else
            eval "$pred" "'$it'"
        fi || return 1
    done
}

# @description Iterate over elements of a collection, returning all elements for which the predicate is true.
# Input to the function can be pipe output, here-string or a file.
#
# @example
#   arr=("1" "2" "3" "a")
#   printf "%s\n" "${arr[@]}" | collection::filter "variable::is_numeric"
#   #Output
#   1
#   2
#   3
#
# @arg $1 string Name of the predicate function.
#
# @exitcode 0 If successful.
# @exitcode 2 Function missing arguments.
#
# @stdout array Values for which the predicate is true.
collection::filter() {
    (( $# == 0 )) && return 2

    local it pred="$1" IFS=$'\n'
    while read -r it; do
        if [[ "$pred" == *"$"* ]]; then
            eval "$pred"
        else
            eval "$pred" "'$it'"
        fi && printf "%s\n" "$it"
    done
}

# @description Iterates over elements of collection, returning the first element where iteratee returns true.
# Input to the function can be a pipe output, here-string or file.
# @example
#   arr=("1" "2" "3" "a")
#   check_a(){
#       [[ "$1" = "a" ]]
#   }
#   printf "%s\n" "${arr[@]}" | collection::find "check_a"
#   #Output
#   a
#
# @arg $1 string Iteratee function.
#
# @exitcode 0  If successful.
# @exitcode 1 If no match found.
# @exitcode 2 Function missing arguments.
#
# @stdout first array value matching the iteratee function.
collection::find() {
    (( $# == 0 )) && return 2

    local func="${1}"
    local IFS=$'\n'
    while read -r it; do

        if [[ "${func}" == *"$"* ]]; then
            eval "${func}"
        else
            eval "${func}" "'${it}'"
        fi
        local -i ret="$?"
        if [[ $ret = 0 ]]; then
            printf "%s" "${it}"
            return 0
        fi
    done

    return 1
}

# @description Invokes the iteratee with each element passed as argument to the iteratee.
# Input to the function can be a pipe output, here-string or file.
# @example
#   opt=("-a" "-l")
#   printf "%s\n" "${opt[@]}" | collection::invoke "ls"
#
# @arg $1 string Iteratee function.
#
# @exitcode 0  If successful.
# @exitcode 2 Function missing arguments.
# @exitcode other exitcode returned by iteratee.
#
# @stdout Output from the iteratee function.
collection::invoke() {
    (( $# == 0 )) && return 2

    local -a args=()
    local func="${1}"
    while read -r it; do
        args=("${args[@]}" "$it")
    done

    eval "${func}" "${args[@]}"
}

# @description Creates an array of values by running each element in array through iteratee.
# Input to the function can be a pipe output, here-string or file.
# @example
#   arri=("1" "2" "3")
#   add_one(){
#     i=${1}
#     i=$(( i + 1 ))
#     printf "%s\n" "$i"
#   }
#   printf "%s\n" "${arri[@]}" | collection::map "add_one"
#
# @arg $1 string Iteratee function.
#
# @exitcode 0  If successful.
# @exitcode 2 Function missing arguments.
# @exitcode other exitcode returned by iteratee.
#
# @stdout Output result of iteratee on value.
collection::map() {
    (( $# == 0 )) && return 2

    local func="${1}"
    local IFS=$'\n'
    local out

    while read -r it; do

        if [[ "${func}" == *"$"* ]]; then
            out="$("${func}")"
        else
            out="$("${func}" "$it")"
        fi

        local -i ret=$?

        if [[ $ret -ne 0 ]]; then
            return $ret
        fi

        printf "%s\n" "${out}"
    done
}

# @description The opposite of filter function; this method returns the elements of collection that iteratee does not return true.
# Input to the function can be a pipe output, here-string or file.
# @example
#   arri=("1" "2" "3" "a")
#   printf "%s\n" "${arri[@]}" | collection::reject "variable::is_numeric"
#   #Ouput
#   a
#
# @arg $1 string Iteratee function.
#
# @exitcode 0  If successful.
# @exitcode 2 Function missing arguments.
#
# @stdout array values not matching the iteratee function.
# @see collection::filter
collection::reject() {
    (( $# == 0 )) && return 2

    local func="${1}"
    local IFS=$'\n'
    while read -r it; do

        if [[ "${func}" == *"$"* ]]; then
            eval "${func}"
        else
            eval "${func}" "'$it'"
        fi
        local -i ret=$?
        if [[ $ret -ne 0 ]]; then
            echo "$it"
        fi

    done
}

# @description Checks if iteratee returns true for any element of the array.
# Input to the function can be a pipe output, here-string or file.
# @example
#   arr=("a" "b" "3" "a")
#   printf "%s\n" "${arr[@]}" | collection::reject "variable::is_numeric"
#
# @arg $1 string Iteratee function.
#
# @exitcode 0  If match successful.
# @exitcode 1 If no match found.
# @exitcode 2 Function missing arguments.
collection::some() {
    (( $# == 0 )) && return 2

    local func="${1}"
    local IFS=$'\n'
    while read -r it; do

        if [[ "${func}" == *"$"* ]]; then
            eval "${func}"
        else
            eval "${func}" "'$it'"
        fi

        local -i ret=$?

        if [[ $ret -eq 0 ]]; then
            return 0
        fi
    done

    return 1
}
