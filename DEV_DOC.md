## Prerequisites

### Required software

- **Docker**
- **Docker Compose**
- **Make**
- **Git**

---

## Environment setup

### Step 1: Launch KVM

#headlesslaunch: launch without a graphical interface:
qemu-system-x86_64 
-enable-kvm 
-m 3G 
-smp 2 
-cpu host 
-hda ./vm-disk.qcow2 
-display none 
-daemonize 
-netdev user,id=net0,hostfwd=tcp::2222-:22 
-device virtio-net-pci,netdev=net0 
-monitor tcp:127.0.0.1:4444,server,nowait 
-virtfs local,path=/home/thmaitre/Documents/6_cercle/inception/alpine-shared,mount_tag=hostshare,security_model=mapped-xattr"

or with the ~/.zshrc alias: myKvm

#launch: launch with the XFCE graphical interface:
qemu-system-x86_64 
-enable-kvm 
-m 3G 
-smp 2 
-cpu host 
-hda ./vm-disk.qcow2 
-display gtk 
-daemonize 
-netdev user,id=net0,hostfwd=tcp::2222-:22 
-device virtio-net-pci,netdev=net0 
-monitor tcp:127.0.0.1:4444,server,nowait 
-virtfs local,path=/home/thmaitre/Documents/6_cercle/inception/alpine-shared,mount_tag=hostshare,security_model=mapped-xattr"

or with the ~/.zshrc alias: myKvmGtk

#close: shut down the KVM from the outside:
echo \"system_powerdown\" | nc 127.0.0.1 4444"

or with the ~/.zshrc alias: myKvmClose

A bind folder, linked to /mnt/shared inside the KVM, is accessible from the host at the following path. It is only useful for
editing the configuration; to launch the containers you must be inside the KVM:

```bash
cd /home/thmaitre/Documents/6_cercle/inception/alpine-shared
```

You can also connect to the KVM via SSH if it is launched without a display:

```bash
ssh root@localhost
```
the root user's password is required

or with another user:
```bash
ssh thmaitre@localhost
```
the thmaitre user's password is required

### Step 2: Create the required directories

The project uses Docker bind mounts to persist data on the host machine. Create the volume directories:

```bash
mkdir -p /home/thmaitre/data/mariadb_volume
mkdir -p /home/thmaitre/data/wp_volume
```

The creation of these paths is defined in the Makefile with the rule: all

### Step 3: Configure the secrets

Secrets are stored in the `srcs/secrets/` directory.

```bash
mkdir -p srcs/secrets
```


| File                      | Role                                |
| ------------------------- | ----------------------------------- |
| `mysql_root_password.txt` | MariaDB root password               |
| `mysql_wp_user.txt`       | WordPress database user             |
| `mysql_wp_password.txt`   | WordPress database password         |
| `mysql_wp_database.txt`   | WordPress database name             |
| `wp_admin_name.txt`       | WordPress administrator username    |
| `wp_admin_pass.txt`       | WordPress administrator password    |
| `wp_admin_email.txt`      | WordPress administrator email       |
| `wp_user_name.txt`        | WordPress username                  |
| `wp_user_pass.txt`        | WordPress user password             |
| `wp_user_email.txt`       | WordPress user email                |

Never add secrets to git. Add `srcs/secrets/` to `.gitignore`.

**Expected output:**
```
Building and starting containers...
[+] Building 45.3s (25/25) FINISHED
...
Containers are up and running!
```

### Using Docker Compose

Builds the containers in detached mode

```bash
docker compose -f srcs/docker-compose.yml up --build -d
```

### Verify that the containers are running

```bash
docker ps
```

### Access the application

- **HTTPS**: https://${DOMAIN_NAME}

> **Note**: The application uses self-signed SSL certificates. Firefox's warning about self-signed certificates is normal. This is a development environment practice.

---

### Makefile commands

| Command       | Description                                                                                |
| ------------- | ------------------------------------------------------------------------------------------ |
| `make`        | Build and start the containers                                                              |
| `make down`   | Stop and remove all containers                                                              |
| `make re`     | Restart the containers (equivalent to `make down && make all`)                              |
| `make clean`  | Stop the containers and remove all Docker images and dangling resources                    |
| `make fclean` | Full cleanup: removes containers, images, AND all persistent volume data                   |

### Container-specific commands

**Open an interactive shell in a container:**

```bash
make exec-mariadb    # MariaDB container
make exec-wordpress  # WordPress container
make exec-nginx      # Nginx container
```

**Display container logs:**

```bash
make logs-mariadb    # MariaDB logs
make logs-wordpress  # WordPress logs
make logs-nginx      # Nginx logs
```

### Manual Docker commands

**Show all containers:**
```bash
docker ps -a
```

**Show running containers:**
```bash
docker ps
```

**Stop all containers:**
```bash
docker compose -f srcs/docker-compose.yml down
```

**Start the containers (if already built):**
```bash
docker compose -f srcs/docker-compose.yml up -d
```

**Display logs of a specific container:**
```bash
docker logs -f container_name  # Follow the logs
docker logs container_name     # Display historical logs
```

**Run a command in a running container:**
```bash
docker exec -it container_name command
docker exec -it wordpress sh   # Open a shell in the WordPress container
```

---

## Data persistence

### View persistent data

**Check the database volume:**
```bash
ls -la /home/thmaitre/data/mariadb_volume/
```

**Check the WordPress volume:**
```bash
ls -la /home/thmaitre/data/wp_volume/
```

**Disk usage:**
```bash
du -sh /home/thmaitre/data/mariadb_volume/
du -sh /home/thmaitre/data/wp_volume/
```

### Delete the data

**To delete all persistent data (full cleanup):**
```bash
make fclean
```

**To list the volumes:**
```bash
docker volume ls
```

**To remove a volume:**
```bash
docker volume rm <volume name>
```
