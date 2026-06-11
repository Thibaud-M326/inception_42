# Documentation du projet

## Services fournis

### Nginx

- Serveur web qui gere les requettes http/https
- Port 443 (HTTPS), et 80 (HTTP)
- Route et redirige le traffic vers wordpress, gere les certificats ssl

### Wordpress

- CMS, gestion de contenu
- Acces grace au navigateur sur : https://thmaitre.42.fr
- Administration du site, creation des pages, articles etc

### MariaDB

- Base de donnee relationnelle
- Port 3306 (dans le reseaux virtuel docker)
- Stockage des donnees de wordpress (user, article, commentaire)

---

## Demarrage

|Commande|Action|
|---|---|
|`make all`|Demarer les conteneurs|
|`make down`|Arreter les conteneurs|
|`make clean`|Nettoyage des conteneurs et des layers mis en cache|
|`make fclean`|Supprime aussi les volumes (supprime les fichiers du site wordpress et toutes les donnees en base de donnee)|

---

## Acces au site

| Lien                            | Description   |
| ------------------------------- | ------------- |
| https://thmaitre.42.fr          | Site          |
| https://thmaitre.42.fr/wp-admin | Panneau admin |

> **Notes :**
> 
> - Les certificats SSL auto signes peuvent generer un avertissement dans le navigateur (normal en phase de developpement)
> - Accepter l'exception de securite pour continuer

---

## Gestion des identifiants

**Wordpress :** defini dans les secrets :

- ///////////////////////////////// a finir ///////////////////////////

---

## Verification du fonctionnement des services

Afficher l'etat des conteneurs apres lancement :

```bash
docker ps
```

Consulter les logs :

```bash
# Logs Nginx
make logs-nginx

# Logs WordPress
make logs-wordpress

# Logs MariaDB
make logs-mariadb
```

Test de connexion Nginx :

```bash
curl -k https://thmaitre.42.fr
```

> L'option `-k` permet d'ignorer les avertissements de certificat auto signe en dev

Test MariaDB :

```bash
make exec-mariadb
mysql -u <wp user> -p <wordpress pass>
```

> Les credentials sont stockes dans le dossier secret du projet