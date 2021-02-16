# Home Assistant Add-on: MariaDB

![Warning][warning_stripe]

> This is a **fork** of the official add-on! See changes below.

![Warning][warning_stripe]

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Supervisor** -> **Add-on Store**.
2. Click **Repositories** in the **...** menu at the top right corner, add `https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory` as repository.
3. Find the "In-memory MariaDB" add-on and click it.
4. Click on the "INSTALL" button.

## How to use

1. Set the `logins` -> `password` field to something strong and unique.
2. Start the add-on.
3. Check the add-on log output to see the result.
4. Add `recorder` component to your Home Assistant configuration.

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

Specify an **upper limit** on the size of the in-memory filesystem. The size may have a **k**, **m**, or **g** suffix.

> ---
>
> **Important!**
>
> ---
>
> During the first days regularly check the database size from eg. HeidiSQL, DBeaver, BeeKeeper-Studio. Or hardcore users can SSH into the system, use `docker ps` and `docker exec -it 123456 /bin/bash` and see the container's file-system directly, use `df` or `ls` to check free space and file sizes (database is located at `/tmp/databases`.
>
> **Note:** The database occupies more space on tmpfs than you see in the client.
>
> **Rule of thumb:** <minimum tmpfs size [MB]> = \<data stored daily [MB]\> * (\<purge_keep_days\> + 1) * 1.1 + 10[MB]
>
> <details>
> <summary>Use the query below to calculate database size requirements - Click to expand!</summary>
>
> ```sql
SELECT round(sum(data_length + index_length) / 1024 / 1024, 2)
INTO @database_size_in_MB
FROM information_schema.tables WHERE table_schema = database();
>
>SELECT min(time_fired), max(time_fired), timediff(max(time_fired), min(time_fired)),
  round(timestampdiff(minute, min(time_fired), max(time_fired)) / 1440, 2)
INTO @first_entry_in_UTC, @last_entry_in_UTC, @timespan, @timespan_in_days
FROM `events`;
>
>SELECT @first_entry_in_UTC AS first_entry_in_UTC, @last_entry_in_UTC AS last_entry_in_UTC,
  @timespan AS timespan, @timespan_in_days AS timespan_in_days,
  @database_size_in_MB AS database_size_in_MB, round(@database_size_in_MB / @timespan_in_days, 2) AS growth_per_day_in_MB,
  round((@database_size_in_MB / @timespan_in_days) * 8 * 1.1 + 10, 0) AS suggested_tmpfs_size_for_1_week_data_in_MB;
> ```
> </details>
>
> ---
>
> **Important!**
>
> ---
>
> If you delete data from the database manually, use `OPTIMIZE TABLE states, events;` to decrease database file sizes also. Or you can call the `recorder.purge` service from Developer Tools / Services menu with `repack: true` service data:
> ```yaml
keep_days: your_number_here
repack: true
> ```
> **Note:** Regular auto purge does not repack the database files, but under normal operation you don't need to decrease file sizes, new data will fill the temporarily unused space.

### Option: `databases` (required)

Database name, e.g., `homeassistant`. Multiple are allowed.

> ---
>
> **Important!**
>
> ---
>
> Use the default database name `homeassistant` to automatically create modified, storage engine compatible database schema when the add-on starts (ie. before recorder tries to connect and tries to create a schema that the storage engine can't handle).

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
  db_url: mysql://homeassistant:PASSWORD@45207088-mariadb/homeassistant?charset=utf8mb4
  purge_keep_days: 7
  exclude:
    event_types:
      - call_service
  include:
    entities:
      - <the entity ids you really need>
```

**Note:** The `45207088-mariadb` is the Hostname displayed on the add-on's Info tab.

> ---
>
> **Important!**
>
> ---
>
> - Exclude all `call_service` entries from the database! These fill up the database really fast with all the parameters to the service calls, MQTT messages, etc.
>
> - See History or use eg. HeidiSQL, DBeaver, BeeKeeper-Studio to access the database and analyze it's content. Search for the entries you don't need, but fill up the database!

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Discord Chat Server][discord].
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

In case you've found a bug, please open an issue on our GitHub: [issue with the official add-on][issue] or [issue with the forked, in-memory add-on][issue-forked]

[createuser]: https://mariadb.com/kb/en/library/create-user
[username]: https://mariadb.com/kb/en/library/create-user/#user-name-component
[hostname]: https://mariadb.com/kb/en/library/create-user/#host-name-component
[grant]: https://mariadb.com/kb/en/library/grant
[mariadb-ha-recorder]: https://www.home-assistant.io/integrations/recorder/
[discord]: https://discord.gg/c5DvZ4e
[forum]: https://community.home-assistant.io
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[issue]: https://github.com/home-assistant/hassio-addons/issues
[issue-forked]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/issues
[reddit]: https://reddit.com/r/homeassistant
[repository]: https://github.com/hassio-addons/repository
[warning_stripe]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/raw/master/mariadb/warning_stripe_wide.png
