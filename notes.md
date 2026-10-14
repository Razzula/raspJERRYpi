- When changing to Virgin Media Hub 5 the DNS record for `vault.razzula.uk` --> `192.168.0.2` seems to have been blocked. Solved this with PiHole: `Settings/Local DNS Records`.
- This actually means, the global DNS can be removed (but no harm in keeping it)

Manual steps for a new router:
- Disable DHCP (once raspJERRYpi is connected)
- Port Forwarding, `192.168.0.2`, `51820`, `UDP`
