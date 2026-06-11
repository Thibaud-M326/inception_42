_this project has been created as part of the 42 curriculum by thmaitre_

# Description

L objectif de se projet est de se plonger dans l univers passionant des container et de leur interaction, en effet docker est aujourd hui un incontournable.

L utilite de Docker est principalement de pouvoir faire run des application sur n'importe quel machine, os ou architecture, en emulant des micro environement a l interieur de container.

Une application est alors decoupee en micro service, chacun dans son container propre et communique entre eux grace a un reseaux prive a docker, puis disponible sur la machine host par port forwarding.

Ce projet est accessile depuis une kvm (kernel virtual machine), soit une machine virtuelle d'hyperviseur type 1, soit un hyperviseur qui execute la virtualisation directement depuis le kernel, la ou un hyperviseur de type 2, serais une application execute depuis une application elle meme execute par dessus notre OS. Les performance d'une KVM sont proche des performance reelle de notre machine Hote.

La mandatory inception nous demande de creer 3 conteneur relie entre eux dans un reseaux privee :

- **MariaDb** : une base de donnee qui serviras a stocker les donne de Wordpress
- **Wordpress + php fpm** : Creer et gerer un site web sans avoir besoin de coder : site vitrine, blog, boutique en ligne, portfolio. (CMS – Content Management System). Php fpm vas generer les pages statique depuis les requette redirige par nginx.
- **Nginx** : Serveur web sert les fichier statique, sert de reverse proxy pour rediriger les requettes exterieur par des route configurable vers les application et services de nos conteneur, les page statique auront ete genere par php fpm dans le conteneur wordpress

Pour la validation du projet il est necessaire de securiser la connexion avec https (port 443) avec des clef de certification pouvant etre auto genere pour le projet. Apres la configuration de nos docker, wordpress sera accessible : https://thmaitre.42.fr

---

# Instruction

### Utilisation KVM

Lancer la KVM :

```bash
$ myKvm
```

Connexion en ssh :

```bash
$ ssh root@localhost
```

Dossier partage avec Host, contenant le projet :

```bash
cd /mtn/shared
```

### Utilisation Docker

Lancer les container Docker :

```bash
docker compose up -d --build
```

avec Makefile :

```bash
make
```

Fermer les conteneur :

```bash
docker compose down
```

avec Makefile :

```bash
make down
```

Autres commandes utiles :

|Commande|Description|
|---|---|
|`docker logs [container]`|Afficher les logs|
|`docker volume ls`|Lister les volumes|
|`docker volume rm [volume]`|Supprimer un volume|
|`docker exec -it [container] [shell]`|Entrer dans un container en ligne de commande|

---

# Ressources

|Sujet|Lien|
|---|---|
|Docker official documentation|https://docs.docker.com/|
|Docker tutorial|https://blog.stephane-robert.info/docs/conteneurs/moteurs-conteneurs/docker/|
|Alpine Linux|https://docs.alpinelinux.org/user-handbook/0.1a/index.html|
|Alpine package manager|https://pkgs.alpinelinux.org/packages|
|MariaDB - tuto installation Alpine Linux|https://linuxtricks.fr/wiki/alpine-linux-installer-et-configurer-un-serveur-de-base-de-donnees-mariadb|
|Wordpress cli|https://fr.wordpress.org/cli/|
|Nginx Official Documentation|https://nginx.org/en/docs/|
|Nginx beginners guide|https://nginx.org/en/docs/beginners_guide.html|
|Nginx configure https server|https://nginx.org/en/docs/http/configuring_https_servers.html|

---

# Project description

Pour le projet inception j ai decide d optimiser et d utiliser les outils les plus leger possible afin de preserver les ressource de mon Host :

- **KVM** : Alpine
- **Docker** : Alpine

### Virtual Machines vs Docker

**Machine virtuelle :**

Une machine virtuelle est une machine simule entierement, kernel, pilote materiel compris, il existe deux type de machine virtuelle. Les machines virtuelle sont gerer par un logiciel appele hyperviseur.

- **Hyperviseur type 1** : tourne directement sur le kernel, optimise, les performances de la machine host et de la vm seront pratiquement equivalente, c'est la version optimise des machines virtuelle
- **Hyperviseur type 2** : notre host possede un OS, qui lui vas faire tourner un logiciel hyperviseur, qui lui executera un machine virtuelle, beaucoup plus couteux en ressource.

**Docker :**

Docker a ete creer en 2013 par Solomon Hykes. Contrairement aux machine virtuelles, un conteneur Docker n'inclu pas de systeme d exploitation, elle s appuie sur des fonctionalite du systeme d exploitation fourni par le systeme hote. L avantage de Docker sera qu'il permet de creer des conteneur d'application isole les une des autres, et pouvant tourner sur toutes les machines de maniere legere, portable et flexible. AWS Amazon web service, utilise docker et kubernetes pour gerer la demande de connexion a votre server en genrant des container a la vole en fonction de la demande, sur un parc de machine differentes.

### Secret vs variable d'environnement

Tout deux des moyen de parametrer nos configuration docker avec des variables d environement.

- **Secrets** : ne seront pas disponible dans les logs de notre container et represente une securite totale si nos container venais a etre attaque.
- **Variables d'environnement classiques** : lisibles depuis l interieur du container et ne doivent jamais contenir de donnee sensible.

> Evidement aucun de ces deux methode de stockage de variable ne doivent etre pousse sur un repo github.

### Docker Network vs Host Network

Lorsque Docker lance un ou plusieurs conteneur, il doit decider de la maniere avec laquelle les connecter aux reseaux.

**Docker network (bridge) :**

Docker va generer un reseaux virtuelle (docker0), les containeur et services pourront communiquer a l'interieur de ce reseaux et on peut faire du port forwarding pour rediriger un port de notre hote vers un port d'un de nos conteneur :

```bash
docker run -p 8080:80 nginx
```

Le traffic qui arrive sur 8080 sur notre machine hote vas etre redirige vers le port 80, utilise ici par nginx pour un connection http. On peut aussi creer nous meme nos propre sous reseaux personalise.

**Host network :**

Ici le reseaux est directement partage avec notre machine hote, les application lancer dans des conteneur seront directement accessible depuis notre hote. Utile pour des application qui necessite une latence minimale. Pour du monitoring reseaux qui doivent observer tous les port de l'hote ou application qui ouvrent beaucoup de port, plus difficile a mapper. Le host network est moin safe que le bridge car il expose directement nos services sans isolation.

### Docker volumes vs bind mounts

Servent a faire persister les donne en dehor des cycle de vie d un conteneur. Par default tous ce qu un conteneur ecrit dans son systeme de fichie est ephemere.

- **Bind mount** : les fichier sont synchronise en temp reel entre l hote et le container. Utile en phase de developpement.
- **Docker volume** : Docker cree un espace de stockage dans son propre repertoire interne `/var/lib/docker/volumes/`. Cela rend les volume portable entres machines. Meilleur performance. Utilise en production / base de donnee.