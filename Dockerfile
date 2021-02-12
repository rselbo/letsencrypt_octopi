FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install python3 python3-pip -y
RUN pip3 install certbot certbot-dns-cloudflare

RUN useradd -ms /bin/bash letsencrypt
USER letsencrypt

WORKDIR /home/letsencrypt

ENTRYPOINT ["/home/letsencrypt/config/renew.sh"]