#!/bin/bash

cat /etc/hosts | while read ip nume; do
    if [ -z $ip ] || [[ "$ip" == \#* ]]; then
        continue
    fi

    nslookup "$nume" | while read linie; do
        if echo "$linie" | grep -q "Name:*"; then
            read address_line
            read label good_ip <<< "$address_line"
            if [ $ip != $good_ip ]; then
                echo "Bogus IP for $nume in /etc/hosts !"
            fi
            break
        fi
    done
done
