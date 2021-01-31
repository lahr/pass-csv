#!/bin/bash

[[ $# -lt 1 ]] && die "Usage: $PROGRAM $COMMAND key1 key2 ..."

#TODO validate no commas and no literal double quotes

AWK_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/csv.awk"
SUFFIX=".gpg"

printf -v columns '%s,' "${@}"
columns=${columns%,}

printf -v header '"%s",' "${@}"
header=${header%,}

echo "\"name\",${header}"

find "${PREFIX}" -name "*.gpg" -print0 | sort -z | xargs -0 -I {} sh -c "${GPG}"' -d '"${GPG_OPTS[*]}"' "$1" | tail -n +2 | awk -v columns="'"${columns}"'" -v fname="$(echo "$1" | sed -e "s#'"${PREFIX}"'/##" -e "s#'"${SUFFIX}"'\$##")" -f "'"${AWK_FILE}"'"' _ {}
