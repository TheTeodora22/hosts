#!/bin/bash

validate_ip()
{
	local  nume = $1
	local ip=$2
	local dns_server=$3	
    if [ -z $ip ] || [[ "$ip" == \#* ]]; then
        continue
    fi

    nslookup "$nume" "$dns_server" | while read linie; do
        if echo "$linie" | grep -q "Name:*"; then
            read address_line
            read label good_ip <<< "$address_line"
            if [ $ip != $good_ip ]; then
                echo "Bogus IP for $nume in /etc/hosts !"
            fi
            break
        fi
    done
}
dns=$1
while read -r in ip host; do
	if [ -z "$ip" ] || [["$ip" == \#* ]]; then
		continue
	fi
	validate_ip "$host" "$ip" "$dns"
done < /etc/host
