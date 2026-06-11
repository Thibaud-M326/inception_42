# USER_DOC.md

## Provided services

### Nginx
- Web server that handles HTTP/HTTPS requests
- Port 443 (HTTPS), and 80 (HTTP)
- Routes and redirects traffic to WordPress, handles SSL certificates

### WordPress
- CMS, content management
- Accessible through the browser at: https://thmaitre.42.fr
- Site administration, creation of pages, articles, etc.

### MariaDB
- Relational database
- Port 3306 (inside the Docker virtual network)
- Stores WordPress data (users, articles, comments)

---

## Getting started

|Command|Action|
|---|---|
|`make all`|Start the containers|
|`make down`|Stop the containers|
|`make clean`|Clean up the containers and cached layers|
|`make fclean`|Also removes the volumes (deletes the WordPress site files and all data in the database)|

---

## Accessing the site

| Link                            | Description   |
| ------------------------------- | ------------- |
| https://${DOMAIN_NAME}          | Site          |
| https://${DOMAIN_NAME}/wp-admin | Admin panel   |

> **Notes:**
>
> - Self-signed SSL certificates may trigger a warning in the browser (normal during the development phase)
> - Accept the security exception to continue

---

## Credentials management

**mysql:** defined in secrets/

mysql_root_password.txt
mysql_wp_database.txt
mysql_wp_password.txt
mysql_wp_user.txt

wordpress: defined in secrets/

wp_admin_email.txt
wp_admin_name.txt
wp_admin_pass.txt
wp_user_email.txt
wp_user_name.txt
wp_user_pass.txt

---

## Checking that the services are working

Display the state of the containers after startup:

```bash
docker ps
```

Check the logs:

```bash
# Nginx logs
make logs-nginx
# WordPress logs
make logs-wordpress
# MariaDB logs
make logs-mariadb
```

Nginx connection test:

```bash
curl -k https://thmaitre.42.fr
```

> The `-k` option ignores self-signed certificate warnings in dev

MariaDB test:

```bash
make exec-mariadb
mysql -u <wp user> -p <wordpress pass>
```

> The credentials are stored in the project's secrets folder
