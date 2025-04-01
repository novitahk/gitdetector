#!/usr/local/env bash

f="$1"
dl="index of"
refs_word="refs"
curlprecmd='curl -s -A "Mozilla/5.0" --connect-timeout 5 --max-time 5'

if [ -z "${f}" ] || ! [ -f "${f}" ]; then
    echo "No file detected. please insert file path ."
    echo "Usage: ${0} file.lst"
    exit 1
fi

while IFS= read -r i; do
    sleep 0.5
    response="$(${curlprecmd} "${i}/.git/" -w "%{http_code}" -o /dev/null)"

    if [ "${response}" == "200" ]; then
        content="$(${curlprecmd} "${i}/.git/")"
        if echo "$content" | grep -qi "${dl}"; then
            echo "${i}/.git/ this url have directory listing."
        fi
    elif [ "${response}" == "403" ]; then
        head_response="$(${curlprecmd} "${i}/.git/HEAD")"
        if echo "$head_response" | grep -qi "${refs_word}"; then
            echo "${i}/.git/ return code 403 but have the word 'refs' in HEAD."
        fi
    fi
done < "${f}"
