#!/bin/sh

while true; do
    IP="$(curl -4 -sS https://api.ipify.org)"

    RECORD="$(
        curl -sS \
            -H "Authorization: Bearer $CLOUDFLARE_TOKEN" \
            -H "Content-Type: application/json" \
            "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records?type=A&name=$CF_RECORD_NAME"
    )"

    RECORD_ID="$(echo "$RECORD" | jq -r '.result[0].id // empty')"
    CURRENT="$(echo "$RECORD" | jq -r '.result[0].content // empty')"

    if [ -z "$RECORD_ID" ]; then
        echo "Creating $CF_RECORD_NAME: $IP"

        curl -sS -X POST \
            -H "Authorization: Bearer $CLOUDFLARE_TOKEN" \
            -H "Content-Type: application/json" \
            "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records" \
            --data "$(jq -n \
                --arg name "$CF_RECORD_NAME" \
                --arg ip "$IP" \
                '{
                    type: "A",
                    name: $name,
                    content: $ip,
                    ttl: 300,
                    proxied: false
                }'
            )"

        echo
    elif [ "$IP" != "$CURRENT" ]; then
        echo "Updating $CF_RECORD_NAME: $CURRENT -> $IP"

        curl -sS -X PUT \
            -H "Authorization: Bearer $CLOUDFLARE_TOKEN" \
            -H "Content-Type: application/json" \
            "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$RECORD_ID" \
            --data "$(jq -n \
                --arg name "$CF_RECORD_NAME" \
                --arg ip "$IP" \
                '{
                    type: "A",
                    name: $name,
                    content: $ip,
                    ttl: 300,
                    proxied: false
                }'
            )"

        echo
    else
        echo "IP unchanged: $IP"
    fi

    sleep 300
done
