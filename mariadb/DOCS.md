# Home Assistant Add-on: MariaDB

```
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv WARNING vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

This is a FORK of the official add-on! See changes below.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ WARNING ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Supervisor** -> **Add-on Store**.
2. Click **Repositories** in the **...** menu at the top right corner, add ```https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory``` as repository.
3. Find the "In-memory MariaDB" add-on and click it.
4. Click on the "INSTALL" button.

## How to use

1. Set the `logins` -> `password` field to something strong and unique.
2. Start the add-on.
3. Check the add-on log output to see the result.
4. Check the Supervisor's log (not the add-on's log), and search for a line like this:
```text
01-01-01 12:00:00 INFO (MainThread) [supervisor.services.modules.mysql] Set 12345678_mariadb as service provider for MySQL
```
Use the above `12345678` number in the `recorder` configuration below. Yes, the _ and - characters are different.
5. Add `recorder` component to your Home Assistant configuration.

## Add-on Configuration

The MariaDB server add-on can be tweaked to your likings. This section
describes each of the add-on configuration options.

Example add-on configuration:

```yaml
tmpfs:
  size: 200m
databases:
  - homeassistant
logins:
  - username: homeassistant
    password: PASSWORD
rights:
  - username: homeassistant
    database: homeassistant
```

### Option: `tmpfs` (required)

This section defines the tmpfs filesystem.

### Option: `tmpfs.size` (required)

Specify an upper limit on the size of the in-memory filesystem. The size may have a k, m, or g suffix.

> ---
>
> **Important!**
>
> ---
>
> During the first days regularly check the database size from eg. HeidiSQL, DBeaver, BeeKeeper-Studio. Or SSH into the system, use `docker ps` and `docker exec -it 123456 /bin/bash` and see the container's file-system directly, use `df` or `ls` to check free space and file sizes.
>
> **Note:** The database occupies more space on tmpfs than you see in the client.
>
> **Rule of thumb:** <minimum tmpfs size [MB]> = \<data stored daily [MB]\> * (\<purge_keep_days\> + 1) * 1.2 + 40[MB]

### Option: `databases` (required)

Database name, e.g., `homeassistant`. Multiple are allowed.

**Note:** Use the default database name `homeassistant` to create modified, storage engine compatible database schema before recorder starts (and tries to create a schema that the storage engine can't handle).

### Option: `logins` (required)

This section defines a create user definition in MariaDB. [Create User][createuser] documentation.

### Option: `logins.username` (required)

Database user login, e.g., `homeassistant`. [User Name][username] documentation.

### Option: `logins.password` (required)

Password for user login. This should be strong and unique.

### Option: `rights` (required)

This section grant privileges to users in MariaDB. [Grant][grant] documentation.

### Option: `rights.username` (required)

This should be the same user name defined in `logins` -> `username`.

### Option: `rights.database` (required)

This should be the same database defined in `databases`.

## Home Assistant Configuration

MariaDB will be used by the `recorder` and `history` components within Home Assistant. For more information about setting this up, see the [recorder integration][mariadb-ha-recorder] documentation for Home Assistant.

Example Home Assistant configuration:

```yaml
recorder:
  db_url: mysql://homeassistant:PASSWORD@12345678-mariadb/homeassistant?charset=utf8mb4
  purge_keep_days: 7
  exclude:
    event_types:
      - call_service
  include:
    entities:
      - <the entity ids you really need>
```

> ---
>
> **Important!**
>
> ---
>
> - Exclude all `call_service` entries from the database! These fill up the database really fast with all the parameters to the service calls, MQTT messages, etc.
>
> - Use eg. HeidiSQL, DBeaver, BeeKeeper-Studio to access the database and analyze it's content. Search for the entries you don't need, but fill up the database!

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Discord Chat Server][discord].
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

In case you've found a bug, please [open an issue on our GitHub][issue].

[createuser]: https://mariadb.com/kb/en/library/create-user
[username]: https://mariadb.com/kb/en/library/create-user/#user-name-component
[hostname]: https://mariadb.com/kb/en/library/create-user/#host-name-component
[grant]: https://mariadb.com/kb/en/library/grant
[mariadb-ha-recorder]: https://www.home-assistant.io/integrations/recorder/
[discord]: https://discord.gg/c5DvZ4e
[forum]: https://community.home-assistant.io
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[issue]: https://github.com/home-assistant/hassio-addons/issues
[reddit]: https://reddit.com/r/homeassistant
[repository]: https://github.com/hassio-addons/repository
