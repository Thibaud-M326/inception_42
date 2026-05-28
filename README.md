*This project has been created as part of the 42 curriculum by thibaud.*

# Inception

## Description

Inception is a small Docker infrastructure built from custom images. It runs a
WordPress site behind NGINX, stores the site content in one named volume, and stores
the MariaDB database in another named volume.

The mandatory services are:

- `nginx`: the only public entrypoint, exposed on port 443 with TLSv1.2 and TLSv1.3.
- `wordpress`: WordPress with PHP-FPM only, listening inside the Docker network.
- `mariadb`: MariaDB only, also listening inside the Docker network.

No ready-made WordPress, NGINX, or MariaDB application image is used. Each service is
built from its own Dockerfile based on Alpine.

## Project description

The source files live in `srcs/`. The root `Makefile` drives Docker Compose, creates
the host data directories, checks that local secrets exist, and starts the stack.

Main design choices:

- NGINX is the only container with a published port. WordPress and MariaDB are only
  reachable through the internal Docker network.
- WordPress uses PHP-FPM, so NGINX forwards PHP requests to `wordpress:9000`.
- MariaDB reads its root password and WordPress database password from Docker secrets.
- WordPress reads its administrator and regular user passwords from Docker secrets.
- Persistent data is kept in Docker named volumes backed by `/home/thibaud/data`.

### Virtual machines vs Docker

A virtual machine runs a full guest operating system with its own kernel. Docker
containers share the host kernel and isolate processes with namespaces, cgroups,
networks, and mounts. For this project, Docker is lighter and fits the goal: one
process-oriented container per service.

### Secrets vs environment variables

Environment variables are useful for non-sensitive configuration such as database names,
usernames, hostnames, and paths. Secrets are better for passwords because Docker mounts
them as files inside the container and they do not need to appear in the Compose file or
Git history.

### Docker network vs host network

The stack uses a dedicated bridge network named `inception`. Containers can resolve each
other by service name, for example `wordpress` connects to `mariadb`. Host networking
would remove that isolation and is forbidden by the subject.

### Docker volumes vs bind mounts

The project uses Docker named volumes for persistent storage. The volumes are configured
to store their data under `/home/thibaud/data`, so the data survives container rebuilds
and remains easy to inspect on the VM.

## Instructions

1. Make sure Docker and Docker Compose are installed on the VM.
2. Edit `srcs/.env` if your 42 login is not `thibaud`.
3. Point the domain to the VM IP address. For local testing, add a line like this to
   `/etc/hosts`:

   ```text
   127.0.0.1 thibaud.42.fr
   ```

4. Create local secrets:

   ```sh
   make init-secrets
   ```

5. Replace every placeholder value in `secrets/*.txt`.
6. Start the infrastructure:

   ```sh
   make
   ```

7. Open the website:

   ```text
   https://thibaud.42.fr
   ```

Useful commands:

```sh
make ps       # show containers
make logs     # follow logs
make down     # stop and remove containers
make fclean   # remove containers, named volumes, and local data
make re       # rebuild from scratch
```

## Resources

- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- Alpine Linux packages: https://pkgs.alpinelinux.org/packages
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- WordPress CLI documentation: https://wp-cli.org/
- NGINX documentation: https://nginx.org/en/docs/
- PHP-FPM configuration reference: https://www.php.net/manual/en/install.fpm.configuration.php

AI was used as an implementation assistant to compare the repository against the
Inception subject, draft the Docker and documentation files, and point out validation
risks. The generated work still needs to be read, tested, and defended by the student.
