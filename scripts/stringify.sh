#!/bin/bash

json_data=$(cat $1)

formatted_string=""
for i in $(echo $json_data | jq -r '.[] | @base64'); do
    _jq() {
        echo ${i} | base64 --decode | jq -r ${1}
    }

    for key in $(echo $i | base64 --decode | jq -r 'keys_unsorted[]'); do
        value=$(_jq ".${key}")
        formatted_string+="${key}: ${value}"$'\n'
    done
    formatted_string+=$'\n'
done

echo "$formatted_string" 

