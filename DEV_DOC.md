# Developer documentation

## Prerequisites

Use a Linux VM with:

- Docker
- Docker Compose v2
- `make`

The project expects the root directory to contain:

```text
Makefile
README.md
USER_DOC.md
DEV_DOC.md
srcs/
secrets/
```

The `secrets/` directory is local only and ignored by Git.

## Environment setup from scratch

Edit `srcs/.env` and set the values that match your 42 login:

```text
LOGIN=thibaud
DOMAIN_NAME=thibaud.42.fr
DATA_PATH=/home/thibaud/data
```

The database and WordPress usernames can also be changed in this file. Passwords must
stay out of `.env` and must be stored in the secret files.

Create the secret files:

```sh
make init-secrets
```

Then replace every placeholder in:

```text
secrets/db_root_password.txt
secrets/db_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
```

Point the domain name to the VM. Example for local testing:

```sh
echo "127.0.0.1 thibaud.42.fr" | sudo tee -a /etc/hosts
```

## Build and launch

Build and start everything:

```sh
make
```

This runs:

```sh
docker compose -f srcs/docker-compose.yml up --build -d
```

Build only:

```sh
make build
```

Stop and remove containers:

```sh
make down
```

Rebuild from scratch:

```sh
make re
```

## Container layout

`srcs/docker-compose.yml` defines three services:

- `mariadb`: builds `srcs/requirements/mariadb/Dockerfile`
- `wordpress`: builds `srcs/requirements/wordpress/Dockerfile`
- `nginx`: builds `srcs/requirements/nginx/Dockerfile`

The images use explicit local tags:

```text
mariadb:inception
wordpress:inception
nginx:inception
```

No service uses the `latest` tag.

## Managing containers and volumes

Show running containers:

```sh
make ps
```

Follow logs:

```sh
make logs
```

Stop containers without deleting volumes:

```sh
make down
```

Delete containers, named volumes, and local data:

```sh
make fclean
```

## Persistent data

The Compose file declares two named volumes:

- `mariadb_data`
- `wordpress_data`

They store their data under:

```text
/home/thibaud/data/mariadb
/home/thibaud/data/wordpress
```

If you change `LOGIN` or `DATA_PATH` in `srcs/.env`, the Makefile and Compose volumes
use the new path.

## Service details

### MariaDB

The MariaDB entrypoint:

1. Reads the root and WordPress database passwords from Docker secrets.
2. Initializes `/var/lib/mysql` if needed.
3. Creates the WordPress database and database user.
4. Starts `mariadbd` in the foreground.

### WordPress

The WordPress entrypoint:

1. Copies WordPress into the persistent volume if it is empty.
2. Waits for MariaDB with a bounded retry loop.
3. Creates `wp-config.php`.
4. Installs WordPress if it is not installed yet.
5. Creates the non-admin WordPress user.
6. Starts `php-fpm` in the foreground.

The administrator username is `wp_owner` by default, so it does not contain `admin` or
`administrator`.

### NGINX

NGINX:

1. Generates a self-signed certificate during image build.
2. Listens only on port 443.
3. Allows only TLSv1.2 and TLSv1.3.
4. Serves static WordPress files from the WordPress volume.
5. Sends PHP requests to `wordpress:9000`.
