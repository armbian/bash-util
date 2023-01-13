#!/usr/bin/env bash

# @file Date
# @brief Functions for manipulating dates.

# @description Get current time as unix timestamp.
#
# @example
#   date::now
#   #Output
#   1591554426
#
# @noargs
#
# @exitcode 0 If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout Current timestamp.
date::now() {
    local ts
    ts="$(date --universal +%s)" || return
    printf "%s" "$ts"
}

# @description Convert datetime string to unix timestamp.
#
# @example
#   date::epoch "2020-07-07 18:38"
#   #Output
#   1594143480
#
# @arg $1 string Datetime in any format.
#
# @exitcode 0 If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout Timestamp for the specified datetime.
date::epoch() {
    (( $# == 0 )) && return 2

    local ts
    ts=$(date -d "$1" +"%s") || return
    printf "%s" "$ts"
}

# @description Add number of days to the specified timestamp.
#
# @example
#   date::add_days_to 1594143480 1
#   #Output
#   1594229880
#
# @arg $1 int Unix timestamp.
# @arg $2 int Number of days to add.
#
# @exitcode 0 If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout New timestamp.
date::add_days_to() {
    (( $# < 2 )) && return 2

    local ts="$1" new_ts days=$2
    new_ts="$(date -d "$(date -d "@$ts" '+%F %T %Z') + $days day" +'%s')" || return
    printf "%s" "$new_ts"
}

# @description Add number of months to the specified timestamp.
#
# @example
#   date::add_months_to 1594143480 1
#   #Output
#   1596821880
#
# @arg $1 int Unix timestamp.
# @arg $2 int Number of months to add.
#
# @exitcode 0 If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout New timestamp.
date::add_months_to() {
    (( $# == 0 )) && return 2

    local ts="$1" new_ts months=$2
    new_ts="$(date -d "$(date -d "@$ts" '+%F %T %Z') + $months month" +'%s')" || return
    printf "%s" "$new_ts"
}

# @description Add number of years to the specified timestamp.
#
# @example
#   date::add_years_to 1594143480 1
#   #Output
#   1625679480
#
# @arg $1 int Unix timestamp.
# @arg $2 int Number of years to add.
#
# @exitcode 0 If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout New timestamp.
date::add_years_to() {
    (( $# == 0 )) && return 2

    local ts="$1" new_ts years=$2
    new_ts="$(date -d "$(date -d "@$ts" '+%F %T %Z') + $years year" +'%s')" || return
    printf "%s" "$new_ts"
}

# @description Add number of weeks to the specified timestamp.
#
# @example
#   date::add_weeks_to 1594143480 1
#   #Output
#   1594748280
#
# @arg $1 int Unix timestamp.
# @arg $2 int Number of weeks to add.
#
# @exitcode 0 If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout New timestamp.
date::add_weeks_to() {
    (( $# == 0 )) && return 2

    local ts="$1" new_ts weeks=$2
    new_ts="$(date -d "$(date -d "@$ts" '+%F %T %Z') + $weeks week" +'%s')" || return
    printf "%s" "$new_ts"
}

# @description Add number of hours from specified timestamp.
# If number of hours not specified then it defaults to 1 hour.
#
# @example
#   echo "$(date::add_hours_to "1594143480")"
#   #Output
#   1594147080
#
# @arg $1 int unix timestamp.
# @arg $2 int number of hours (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout timestamp.
date::add_hours_to() {
    (( $# == 0 )) && return 2

    local ts new_ts hour
    ts="${1}"
    hour=${2:-1}
    new_ts="$(date -d "$(date -d "@${ts}" '+%F %T')+${hour} hour" +'%s')" || return $?
    printf "%s" "${new_ts}"
}

# @description Add number of minutes from specified timestamp.
# If number of minutes not specified then it defaults to 1 minute.
#
# @example
#   echo "$(date::add_minutes_to "1594143480")"
#   #Output
#   1594143540
#
# @arg $1 int unix timestamp.
# @arg $2 int number of minutes (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout timestamp.
date::add_minutes_to() {
    (( $# == 0 )) && return 2

    local ts new_ts minute
    ts="${1}"
    minute=${2:-1}
    new_ts="$(date -d "$(date -d "@${ts}" '+%F %T')+${minute} minute" +'%s')" || return $?
    printf "%s" "${new_ts}"
}

# @description Add number of seconds from specified timestamp.
# If number of seconds not specified then it defaults to 1 second.
#
# @example
#   echo "$(date::add_seconds_to "1594143480")"
#   #Output
#   1594143481
#
# @arg $1 int unix timestamp.
# @arg $2 int number of seconds (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout timestamp.
date::add_seconds_to() {
    (( $# == 0 )) && return 2

    local ts new_ts minute
    ts="${1}"
    second=${2:-1}
    new_ts="$(date -d "$(date -d "@${ts}" '+%F %T')+${second} second" +'%s')" || return $?
    printf "%s" "${new_ts}"
}

# @description Add number of days from current day timestamp.
# If number of days not specified then it defaults to 1 day.
#
# @example
#   echo "$(date::add_days "1")"
#   #Output
#   1591640826
#
# @arg $1 int number of days (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::add_days() {
    local ts new_ts day
    ts="$(date::now)"
    day=${1:-1}
    new_ts="$(date::add_days_to "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Add number of months from current day timestamp.
# If number of months not specified then it defaults to 1 month.
#
# @example
#   echo "$(date::add_months "1")"
#   #Output
#   1594146426
#
# @arg $1 int number of months (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::add_months() {
    local ts new_ts month
    ts="$(date::now)"
    month=${1:-1}
    new_ts="$(date::add_months_to "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Add number of years from current day timestamp.
# If number of years not specified then it defaults to 1 year.
#
# @example
#   echo "$(date::add_years "1")"
#   #Output
#   1623090426
#
# @arg $1 int number of years (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::add_years() {
    local ts new_ts year
    ts="$(date::now)"
    year=${1:-1}
    new_ts="$(date::add_years_to "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Add number of weeks from current day timestamp.
# If number of weeks not specified then it defaults to 1 year.
#
# @example
#   echo "$(date::add_weeks "1")"
#   #Output
#   1592159226
#
# @arg $1 int number of weeks (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::add_weeks() {
    local ts new_ts week
    ts="$(date::now)"
    week=${1:-1}
    new_ts="$(date::add_weeks_to "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Add number of hours from current day timestamp.
# If number of hours not specified then it defaults to 1 hour.
#
# @example
#   echo "$(date::add_hours "1")"
#   #Output
#   1591558026
#
# @arg $1 int number of hours (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::add_hours() {
    local ts new_ts hour
    ts="$(date::now)"
    hour=${1:-1}
    new_ts="$(date::add_hours_to "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Add number of minutes from current day timestamp.
# If number of minutes not specified then it defaults to 1 minute.
#
# @example
#   echo "$(date::add_minutes "1")"
#   #Output
#   1591554486
#
# @arg $2 int number of minutes (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::add_minutes() {
    local ts new_ts minute
    ts="$(date::now)"
    minute=${1:-1}
    new_ts="$(date::add_minutes_to "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Add number of seconds from current day timestamp.
# If number of seconds not specified then it defaults to 1 second.
#
# @example
#   echo "$(date::add_seconds "1")"
#   #Output
#   1591554427
#
# @arg $2 int number of seconds (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::add_seconds() {
    local ts new_ts minute
    ts="$(date::now)"
    second=${1:-1}
    new_ts="$(date::add_seconds_to "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of days from specified timestamp.
# If number of days not specified then it defaults to 1 day.
#
# @example
#   echo "$(date::sub_days_from "1594143480")"
#   #Output
#   1594057080
#
# @arg $1 int unix timestamp.
# @arg $2 int number of days (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout timestamp.
date::sub_days_from() {
    (( $# == 0 )) && return 2

    local ts new_ts day
    ts="${1}"
    day=${2:-1}
    new_ts="$(date -d "$(date -d "@${ts}" '+%F %T') ${day} days ago" +'%s')" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of months from specified timestamp.
# If number of months not specified then it defaults to 1 month.
#
# @example
#   echo "$(date::sub_months_from "1594143480")"
#   #Output
#   1591551480
#
# @arg $1 int unix timestamp.
# @arg $2 int number of months (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout timestamp.
date::sub_months_from() {
    (( $# == 0 )) && return 2

    local ts new_ts month
    ts="${1}"
    month=${2:-1}
    new_ts="$(date -d "$(date -d "@${ts}" '+%F %T') ${month} months ago" +'%s')" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of years from specified timestamp.
# If number of years not specified then it defaults to 1 year.
#
# @example
#   echo "$(date::sub_years_from "1594143480")"
#   #Output
#   1562521080
#
# @arg $1 int unix timestamp.
# @arg $2 int number of years (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout timestamp.
date::sub_years_from() {
    (( $# == 0 )) && return 2

    local ts new_ts year
    ts="${1}"
    year=${2:-1}
    new_ts="$(date -d "$(date -d "@${ts}" '+%F %T') ${year} years ago" +'%s')" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of weeks from specified timestamp.
# If number of weeks not specified then it defaults to 1 week.
#
# @example
#   echo "$(date::sub_weeks_from "1594143480")"
#   #Output
#   1593538680
#
# @arg $1 int unix timestamp.
# @arg $2 int number of weeks (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout timestamp.
date::sub_weeks_from() {
    (( $# == 0 )) && return 2

    local ts new_ts week
    ts="${1}"
    week=${2:-1}
    new_ts="$(date -d "$(date -d "@${ts}" '+%F %T') ${week} weeks ago" +'%s')" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of hours from specified timestamp.
# If number of hours not specified then it defaults to 1 hour.
#
# @example
#   echo "$(date::sub_hours_from "1594143480")"
#   #Output
#   1594139880
#
# @arg $1 int unix timestamp.
# @arg $2 int number of hours (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout timestamp.
date::sub_hours_from() {
    (( $# == 0 )) && return 2

    local ts new_ts hour
    ts="${1}"
    hour=${2:-1}
    new_ts="$(date -d "$(date -d "@${ts}" '+%F %T') ${hour} hours ago" +'%s')" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of minutes from specified timestamp.
# If number of minutes not specified then it defaults to 1 minute.
#
# @example
#   echo "$(date::sub_minutes_from "1594143480")"
#   #Output
#   1594143420
#
# @arg $1 int unix timestamp.
# @arg $2 int number of minutes (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout timestamp.
date::sub_minutes_from() {
    (( $# == 0 )) && return 2

    local ts new_ts minute
    ts="${1}"
    minute=${2:-1}
    new_ts="$(date -d "$(date -d "@${ts}" '+%F %T') ${minute} minutes ago" +'%s')" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of seconds from specified timestamp.
# If number of seconds not specified then it defaults to 1 second.
#
# @example
#   echo "$(date::sub_seconds_from "1594143480")"
#   #Output
#   1594143479
#
# @arg $1 int unix timestamp.
# @arg $2 int number of seconds (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
# @exitcode 2 Function missing arguments.
#
# @stdout timestamp.
date::sub_seconds_from() {
    (( $# == 0 )) && return 2

    local ts new_ts minute
    ts="${1}"
    second=${2:-1}
    new_ts="$(date -d "$(date -d "@${ts}" '+%F %T') ${second} seconds ago" +'%s')" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of days from current day timestamp.
# If number of days not specified then it defaults to 1 day.
#
# @example
#   echo "$(date::sub_days "1")"
#   #Output
#   1588876026
#
# @arg $1 int number of days (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::sub_days() {
    local ts new_ts day
    ts="$(date::now)"
    day=${1:-1}
    new_ts="$(date::sub_days_from "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of months from current day timestamp.
# If number of months not specified then it defaults to 1 month.
#
# @example
#   echo "$(date::sub_months "1")"
#   #Output
#   1559932026
#
# @arg $1 int number of months (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::sub_months() {
    local ts new_ts month
    ts="$(date::now)"
    month=${1:-1}
    new_ts="$(date::sub_months_from "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of years from current day timestamp.
# If number of years not specified then it defaults to 1 year.
#
# @example
#   echo "$(date::sub_years "1")"
#   #Output
#   1591468026
#
# @arg $1 int number of years (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::sub_years() {
    local ts new_ts year
    ts="$(date::now)"
    year=${1:-1}
    new_ts="$(date::sub_years_from "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of weeks from current day timestamp.
# If number of weeks not specified then it defaults to 1 week.
#
# @example
#   echo "$(date::sub_weeks "1")"
#   #Output
#   1590949626
#
# @arg $1 int number of weeks (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::sub_weeks() {
    local ts new_ts week
    ts="$(date::now)"
    week=${1:-1}
    new_ts="$(date::sub_weeks_from "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of hours from current day timestamp.
# If number of hours not specified then it defaults to 1 hour.
#
# @example
#   echo "$(date::sub_hours "1")"
#   #Output
#   1591550826
#
# @arg $1 int number of hours (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::sub_hours() {
    local ts new_ts hour
    ts="$(date::now)"
    hour=${1:-1}
    new_ts="$(date::sub_hours_from "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of minutes from current day timestamp.
# If number of minutes not specified then it defaults to 1 minute.
#
# @example
#   echo "$(date::sub_minutes "1")"
#   #Output
#   1591554366
#
# @arg $1 int number of minutes (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::sub_minutes() {
    local ts new_ts minute
    ts="$(date::now)"
    minute=${1:-1}
    new_ts="$(date::sub_minutes_from "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Subtract number of seconds from current day timestamp.
# If number of seconds not specified then it defaults to 1 second.
#
# @example
#   echo "$(date::sub_seconds "1")"
#   #Output
#   1591554425
#
# @arg $1 int number of seconds (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate timestamp.
#
# @stdout timestamp.
date::sub_seconds() {
    local ts new_ts minute
    ts="$(date::now)"
    second=${1:-1}
    new_ts="$(date::sub_seconds_from "${ts}" "${second}")" || return $?
    printf "%s" "${new_ts}"
}

# @description Format unix timestamp to human readable format.
# If format string is not specified then it defaults to "yyyy-mm-dd hh:mm:ss" format.
#
# @example
#   echo echo "$(date::format "1594143480")"
#   #Output
#   2020-07-07 18:38:00
#
# @arg $1 int unix timestamp.
# @arg $2 string format control characters based on `date` command (optional).
#
# @exitcode 0  If successful.
# @exitcode 1 If unable to generate time string.
# @exitcode 2 Function missing arguments.
#
# @stdout formatted time string.
date::format() {
    (( $# == 0 )) && return 2

    local ts format out
    ts="${1}"
    format="${2:-"%F %T"}"
    out="$(date -d "@${ts}" +"${format}")" || return $?
    printf "%s" "${out}"

}
