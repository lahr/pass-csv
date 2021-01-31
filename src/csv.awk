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
