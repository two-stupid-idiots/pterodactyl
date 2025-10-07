# Pterodactyl

Our configuration of Pterodactyl.

## Content

- [1 Nginx](#1-nginx)
  - [1.1 Installation](#11-installation)
  - [1.2 Configuration](#12-configuration)
  - [1.3 Start](#13-start)
  - [1.4 Status](#14-status)
- [2 Dehydrated](#2-dehydrated)
  - [2.1 Installation](#21-installation)
  - [2.2 Configuration](#22-configuration)
  - [2.3 Create certificates](#23-create-certificates)
  - [2.4 Auto renew](#24-auto-renew)
- [3 Pterodactyl](#3-pterodactyl-panel)
  - [3.1 Copy config](#31-copy-config)
  - [3.2 Set variables](#32-set-variables)
  - [3.3 Start](#33-start)
  - [3.4 Add UI user](#34-add-ui-user)
  - [3.5 Add node](#35-add-node)
- [Ports](#ports)
- [Variables](#variables)

## 1 Nginx

### 1.1 Installation

Install `Nginx` on host.

```sh
sudo apt install nginx
```

### 1.2 Configuration

Copy the `nginx/` configs to your `sites-available` and **CHANGE** the domain.

Enable this config:

```sh
sudo ln -s /etc/nginx/sites-available/panel.{YOUR_DOMAIN} /etc/nginx/sites-enabled/panel.{YOUR_DOMAIN}
sudo ln -s /etc/nginx/sites-available/wings.{YOUR_DOMAIN} /etc/nginx/sites-enabled/wings.{YOUR_DOMAIN}
```

### 1.3 Start

```sh
sudo systemctl enable nginx
sudo systemctl restart nginx
```

### 1.4 Status

```sh
sudo systemctl status nginx
```

## 2 Dehydrated

### 2.1 Installation

Install `Dehydrated` on host.

```sh
sudo apt install dehydrated
```

### 2.2 Configuration

Edit `/etc/dehydrated/domains.txt`

```txt
panel.{YOUR_DOMAIN}
wings.{YOUR_DOMAIN}
```

### 2.3 Create certificates

```sh
sudo dehydrated -c
```

### 2.4 Auto renew

```sh
sudo crontab -e
```

Add this line:

```sh
0 3 * * * /usr/local/bin/dehydrated -c >/dev/null 2>&1
```

## 3 Pterodactyl

### 3.1 Copy config

Copy this [Docker Compose config](panel/docker-compose.yml) to your directory.

### 3.2 Set variables

Copy `.env.example` to `.env` and **edit** it. Check [Variables List](#variables) for more information.

### 3.3 Start

```sh
sudo docker compose up -d
```

### 3.4 Add UI user

The following command starts a dialog.

```sh
sudo docker compose run --rm panel php artisan p:user:make
```

### 3.5 Add node

First create a `location` within the UI. Then create a node with the following settings:

| Setting | Description |
| --- | --- |
| `Name` | Name your node |
| `Location` | Choose your created `location` |
| `Visibility` | `public` |
| `FQDN` | Set to full domain of node |
| `SSL` | `Use SSL` |
| `Proxy` | `Behind Proxy` |
| `Memory` | Choose according to your server |
| `Storage` | Choose according to your server | 
| `Daemon Port` | `443` |
| `Daemon SFTP Port` | `2022` |


## Information

### Ports

**Default:** `deny` (incoming), `allow` (outgoing), `deny` (routed),

| Port | Protocol | Status | Usage |
| --- | --- | --- | --- |
| `22/tcp` | `SSH` | `LIMIT IN` | `SSH` |
| `80/tcp` | `HTTP` | `ALLOW IN` | `NGINX` |
| `443/tcp` | `HTTPS` | `ALLOW IN` | `NGINX` |
| `2022/tcp` | `SFTP` | `ALLOW IN` | `WINGS` |
| `8080/tcp` | `HTTP` | `local` | `Panel` |
| `8443/tcp` | `HTTPS` | `local` | `Wings` |
| `24454/udp` |  | `ALLOW IN` | `Simple Voice Chat` | 
| `25565:25575/tcp` |  | `ALLOW IN` | `Minecraft` |

### Variables

| Option | Value |
| --- | --- |
| `TIMEZONE` | Set to your timezone |
| `PANEL_URL` | Set to the panel url |
| `PANEL_SERVICE_AUTHOR` | Set to your mail |
| `PANEL_TRUSTED_PROXIES` | Set to IP address of your proxy |
| `MYSQL_ROOT_PASSWORD` | Set mysql root pwd |
| `MYSQL_DATABASE` | Set db name |
| `MYSQL_USER` | Set db username |
| `MYSQL_PASSWORD` | Set user pwd |
