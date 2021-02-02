#!/bin/bash

[[ $# -lt 1 ]] && die "Usage: $PROGRAM $COMMAND key1 key2 ..."
for key in "$@"; do
    [[ -z "$key" || "$key" == *"\""* || "$key" == *","* || "$key" == *":"* ]] && die "Arguments may not contain double quotes, commas and colons"
done

AWK=$(cat - <<-'EOF'
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function quotes(s) { gsub(/\"/, "\"\"", s); return s } # double quote -> 2x double quote
function sanitize(s) { return rtrim(ltrim(quotes(s))); }
BEGIN {
    numKeys = split(columns, keys, ",")
    FS=":"; OFS=","
}
{ fnameMap[fname,sanitize($1)] = sanitize($2) }
END {
    printf "\"%s\"%s", fname, OFS
    for (keyNr=1; keyNr<=numKeys; keyNr++) {
        key = keys[keyNr]
        val = (fnameMap[fname,key] == "" ? "-" : fnameMap[fname,key])
        printf "\"%s\"%s", val, (keyNr<numKeys ? OFS : ORS)
    }
}
EOF
)

SUFFIX=".gpg"

printf -v columns '%s,' "${@}"
columns=${columns%,}

printf '"name"'
printf ',"%s"' "${@}"
printf '\n'

find "${PREFIX}" -name "*${SUFFIX}" -print0 | sort -z | 
    while IFS= read -r -d '' path; do
        file=$(echo "$path" | sed -e "s#^${PREFIX}/##" -e "s#${SUFFIX}\$##")
        "$GPG" -d "${GPG_OPTS[@]}" "$path" | tail -n +2 | awk -v columns="$columns" -v fname="$file" "${AWK}" || exit 1
    done
