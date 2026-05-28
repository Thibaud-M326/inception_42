# User documentation

## Services provided

This stack provides a WordPress website secured behind NGINX:

- NGINX exposes HTTPS on port 443.
- WordPress runs with PHP-FPM and serves the site content.
- MariaDB stores the WordPress database.

Only NGINX is reachable from outside Docker. WordPress and MariaDB stay on the internal
`inception` Docker network.

## Start and stop the project

Before the first start, create the local secrets:

```sh
make init-secrets
```

Edit every file in `secrets/` and replace the placeholder values:

```text
secrets/db_root_password.txt
secrets/db_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
```

Start the project:

```sh
make
```

Stop and remove the containers:

```sh
make down
```

Remove containers, volumes, and local data:

```sh
make fclean
```

## Access the website and administration panel

The default domain is:

```text
thibaud.42.fr
```

If your login is different, edit `srcs/.env` and change:

```text
LOGIN=thibaud
DOMAIN_NAME=thibaud.42.fr
DATA_PATH=/home/thibaud/data
```

Then point the domain to the VM IP address. For local testing on the VM, this is enough:

```text
127.0.0.1 thibaud.42.fr
```

Open the website:

```text
https://thibaud.42.fr
```

Open the WordPress administration panel:

```text
https://thibaud.42.fr/wp-admin
```

The administrator username is configured in `srcs/.env` with
`WORDPRESS_ADMIN_USER`. Its password is stored in
`secrets/wp_admin_password.txt`.

## Locate and manage credentials

Credentials are local files in `secrets/`. They are ignored by Git and are mounted into
containers as Docker secrets.

Do not commit those files. If a password must change, edit the relevant secret file and
recreate the stack:

```sh
make down
make
```

For a clean database and WordPress install, use:

```sh
make fclean
make
```

This deletes `/home/thibaud/data`, so use it only when you want a fresh install.

## Check that services are running

List containers:

```sh
make ps
```

Follow logs:

```sh
make logs
```

Expected containers:

```text
nginx
wordpress
mariadb
```

Expected public port:

```text
443
```

No public port should be exposed for WordPress or MariaDB.
