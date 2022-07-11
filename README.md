# Lesbian UNIX Dev

The webspace of a lesbian UNIX developer.

## Prerequisites

 * Hugo Static Site Generator
 * GNU Make

## Development

normal hugo development things.

## Quick Setup on SmartOS

    # Install Prereqs
    pkgin up && pkgin -y in gmake git gohugo
    # clone repo
    mkdir /var/www
    git clone https://github.com/karaiwulf/lesbianunix.dev /var/www/lesbianunix.dev
    # pull submodules
    cd /var/www/lesbianunix.dev && make pull
    # install webserver (creates www user)
    pkgin -y in nginx
    # point nginx config at the correct location
    sed -i 's;share/example/nginx/html;/var/www/lesbianunix.dev/public;g' /opt/local/etc/nginx/nginx.conf
    # enable autoupdate service
    svccfg import smf.xml
    # restart nginx
    svcadm restart nginx

