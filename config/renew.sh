#!/usr/bin/env /bin/bash

certbot certonly \
  --config-dir ~/config \
  --work-dir ~/work \
  --logs-dir ~/logs \
  --email <your email> \
  --agree-tos \
  --dns-cloudflare \
  --dns-cloudflare-credentials ~/config/cloudflare \
  --keep \
  -d <sub.domain.com>
#Should be able to handle multiple -d arguments for multiple domains

echo done
exit
