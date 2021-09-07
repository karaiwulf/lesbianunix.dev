+++
title = "How to Install Animal Shelter Manager3"
date = "2021-09-06T17:32:27-06:00"
author = "Kararou Ren"
authorTwitter = "karaiwulf" #do not include @
cover = ""
tags = ["asm3", "how-to"]
keywords = ["install", "asm3", "animal shelter", "http", "web-management",
"manager", "animal", "shelter"]
description = "A stopgap how-to on installing the asm3, as the current install
guide is behind a paywall."
showFullContent = false
draft = false
+++

First, let me be 150% frank here: FOSS developers *should be paid for work*.
Period.  End of conversation.  This article provides install instructions for
those *trying out* the software.  If you intend to use it in any capacity
afterwards, please either pay for a support subscription, or toss a couple
dollars at the developers for making something you can use.

### Setup

If you are on a modern Debian-based Linux, please feel free to download the
asm3 package from their website.  We will run with the assumption that you are
for the rest of this guide, but gathering and installing dependencies on other
systems shouldn't be hard, as they are listed in the README.

The only other requirement is a database server.  ASM supports PostgreSQL,
MySQL (and MariaDB by extension), and SQLite.  These can be installed either on
a remote system or on the local system.  In this tutorial, we'll assume you are
installing to the local system, but setup would be *identical*.

```bash
# download ASM3
wget https://public.sheltermanager.com/deb/sheltermanager3_44_all.deb

# install ASM3 and PostgreSQL
sudo apt install ./sheltermanager3_44_all.deb postgresql

# install some required apache things due to asm3 package not including them
# literally despite the README saying they are included
sudo apt install apache2 libapache2-mod-wsgi-py3

# enable the new module and the asm3 site
sudo a2enmod wsgi
sudo a2ensite asm3

# enable and start apache2 httpd
sudo systemctl enable apache2
sudo systemctl start apache2
```

Okay, so now you should have a base configuration asm3 install.  It will work,
but you won't be able to complete setup because no database is configured.

### Database Configuration

```bash
# enable and start postgresql
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

Now lets create a user and database for the ASM.
```bash
# become postgres user
sudo -u postgres -i

# create asm postgresql user
createuser --pwprompt asm

# create asm database
createdb --owner=asm asm

# add asm to login file
printf "host\tasm\tasm\t127.0.0.1/32\tpassword" | \
sudo tee /etc/postgresql/12/main/pg_hba.conf
```

Now modify the database configuration of asm3, which is located at
`/etc/asm3.conf`.  It should look like:

```
db_type = POSTGRESQL # MYSQL, POSTGRESQL, SQLITE or DB2
db_host = localhost # or an IP if you're using a remote system
db_port = 5432
db_username = asm
db_password = somePasswordHere
db_name = asm
```

### Starting the System

Before we really dig into the system, there are two more configuration items
that desperately need attention in `/etc/asm3.conf`: `base_url` and
`service_url`.

I've configured mine with the internal IP of the ASM system, then when I
deployed it, as ASM will always auto-redirect to this URL.

For setup, you should use:

```
base_url = http://192.168.0.199/
service_url = http://192.168.0.199/service
```

Then restart apache2 using `systemctl` and navigate to the ASM machine's IP.
It will auto redirect you to the `/database` endpoint and create your database.
Once that's done, you can login and manage the system.

Don't forget to change the `base_url` and `service_url` before moving to
production.  Enabling the apache site `default-ssl.conf`, will also enable ssl
on the system.  You will again have to change `base_url` and `service_url` to
use https instead of http.

