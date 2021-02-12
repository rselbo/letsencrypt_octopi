## docker-compose ##

docker-compose.yaml is only used to mount the volumes. It could be replaced with docker -v options

## Dockerfile ##

The dockerfile builds a ubuntu image with Letencrypt certbot and certbot-dns-cloudflare plugin.
The cloudflare plugin allows us to fetch certificates without exposing any services on the local system.

## config Folder ##

The config folder contains 2 important files.

The file cloudflare contains the API Token that the certbot plugin needs to be allowed to change the DNS.
To create the token you need to log in to cloudflare, go to My profile and on the profile page, go to
API Tokens and create an "Edit zone DNS" token.
https://support.cloudflare.com/hc/en-us/articles/200167836-Managing-API-Tokens-and-Keys

The file renew.sh is the script that is the entrypoint for the Docker image and where the magic happens.
It runs the certbot that will fetch a certificate if it is not present. If the certificate already exists
but is not close to running ut the program will do nothing and exit. And if the certificate is close
to running out it will renew the certificate. The certificate files will be placed in the
config/live/sub.domain.com folder.

The docker image is created to be run once per day since the certificates have a lifetime of 90 days.
The certbot will try to renew the certificate if there is less than 30 days until it expires.

## Cron ##

To run the script daily you can either add an entry in crontab or copy the cron/letsencrypt script
into /etc/cron.daily.
If you are running this on a windows system it will be your problem to figure out how to periodically
run this.

## octopi ##

Log in to the ssh shell of the octopi with the pi user. Make sure there is a .ssh folder or create it
with `mkdir ~/.ssh; chmod 0700 ~/.ssh`. Once the .ssh folder exists create a ssh key that we can use
in the cronscript on the host machine that runs the docker image `ssh-keygen -t ed25519`. Leave the
filenames as the default and use an empty password. Afterwards run
`cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys; chmod 0600 ~/.ssh/authorized_keys`
Now you need to copy the ~/.ssh.id_ed25519 over to the host and put the full path to the file in
OCTOPI_KEY in cron/letsencrypt.
Finally copy the file in octopi_cron over to the octopi and place it in /etc/cron.daily

IMPORTANT
1. Replace the API Token in config/cloudflare
2. Replace the email "<your email>" in config/renew.sh
3. Replace the domain "<sub.domain.com>" in config/renew.sh
4. Replace the DOCKERFILE_PATH in cron/letsencrypt
5. Replace the OCTOPI_DOMAIN in cron/letsencrypt
6. Replace the OCTOPI_KEY in cron/letsencrypt