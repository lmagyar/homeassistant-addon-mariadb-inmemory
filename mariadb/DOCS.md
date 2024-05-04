# Home Assistant Custom Add-on: In-memory MariaDB

![Warning][warning_stripe]

> This is a **fork** of the [official add-on][official_addon]!
>
> This version uses **tmpfs** to store MariaDB databases in-memory. If you are
> trying to minimize your SD-card's wear, give this add-on a try.
>
> **Even this is an in-memory database, it can automatically export (from memory
> to SD card) the database's content during backup, update, restart or even
> periodically, and can automatically import (from SD card to memory) the
> content when the add-on starts again**. The database dump is **gzip-ed**
> before written to the storage to minimize SD-card wear.
>
> Though it won't protect you from power failures completely. After a power
> failure, when the add-on is restarted, it will import the last known exported
> database content. So when eg. daily periodic export (from memory to SD card)
> is enabled, you will loose the latest sensory data within that day, but your
> long term statistics information will remain mostly intact.

![Warning][warning_stripe]

You can use this add-on to install an _**in-memory**_ MariaDB, which is an
open-source (GPLv2 licensed) database. MariaDB can be used as the database
backend for Home Assistant. For more information, please see [MariaDB][mariadb]

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** ->
   **Add-on Store**.
1. In the **...** menu at the top right corner click **Repositories**, add
   `https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory` as
   repository.
1. Find the "In-memory MariaDB" add-on and click it. If it doesn't show up, wait
   until HA refreshes the information about the add-on, or click **Check for
   updates** in the **...** menu at the top right corner.
1. Click on the "INSTALL" button.

## How to use

1. Under the Configuration tab set the `logins` -> `password` field to something
   strong and unique.
1. Save the configuration.
1. Start the add-on.
1. Check the add-on log output to see the result.
1. Add the `recorder` integration to your Home Assistant configuration. See
   details below.

## How to update

If you update or restart the add-on, please stop HA core to avoid error messages
that the database is not available (during plain backup, stopping HA core is not
necessary). **You can execute in the command line the**
`/share/bin/update-mariadb-inmemory-while-ha-core-restarted` **or**
`/share/bin/restart-mariadb-inmemory-while-ha-core-restarted` **scripts to do it
automatically.**

Or you can execute these commands step by step manually to update the add-on:
- \> ha core stop
- \> ha addons update 45207088_mariadb --backup
- \> ha addons info 45207088_mariadb | grep -E '^version'   # wait until the new version is really installed
- \> ha addons log 45207088_mariadb                         # wait until the add-on is started
- \> ha core start

## Add-on Configuration

The MariaDB server add-on can be tweaked to your likings. This section describes
each of the add-on configuration options.

Example add-on configuration:

```yaml
tmpfs:
  size: 200m
retention:
  enabled: true
  periodic: disabled
purge_statistics:
  period: monthly
  keep_periods: 6
  archive: false
databases:
  - homeassistant
logins:
  - username: homeassistant
    password: PASSWORD
  - username: read_only_user
    password: PASSWORD
rights:
  - username: homeassistant
    database: homeassistant
  - username: read_only_user
    database: homeassistant
    privileges:
      - SELECT
```

### Option: `tmpfs`

This add-on uses tmpfs to store MariaDB databases in-memory. This section
defines the tmpfs filesystem.

### Option: `tmpfs.size`

Specify an **upper limit** on the size of the in-memory filesystem. The size may
have a **k**, **m**, or **g** suffix.

> ---
>
> **Important!**
>
> ---
>
> During the first days regularly check the database size from eg. HeidiSQL,
> DBeaver, BeeKeeper-Studio. Or hardcore users can use Portainer add-on to get a
> console to this add-on's container (or without Portainer add-on SSH into the
> system, use `docker exec -it addon_45207088_mariadb /bin/bash`) and see the
> container's file-system directly, use `df` or `ls` to check free space and
> file sizes (databases are located at `/tmp/databases`.
>
> **Note:** The database occupies more space on tmpfs than you see in the
> client. And it needs even more temporary space to `repack` tables after
> `purge` deleted rows.
>
> **Rule of thumb:** <minimum tmpfs size [MB]> = \<data stored daily [MB]\> *
> (\<purge_keep_days\> + 1) * 2.0 + 50[MB]
>
> **Note:** If you delete data from the database manually, use `OPTIMIZE TABLE
> states, events;` to decrease database file sizes also.
>
> Use the query below to calculate database size requirements - Click to expand!
>
> <details>
>
> ```sql
SELECT round(sum(data_length + index_length) / 1024 / 1024, 2)
INTO @database_size_in_MB
FROM information_schema.tables WHERE table_schema = database();
>
>SELECT from_unixtime(min(time_fired_ts)), from_unixtime(max(time_fired_ts)),
  round(timestampdiff(minute, from_unixtime(min(time_fired_ts)), from_unixtime(max(time_fired_ts))) / 1440, 2)
INTO @first_entry_in_UTC, @last_entry_in_UTC, @timespan_in_days
FROM `events`;
>
>SELECT @first_entry_in_UTC AS first_entry_in_UTC, @last_entry_in_UTC AS last_entry_in_UTC, @timespan_in_days AS timespan_in_days,
  @database_size_in_MB AS database_size_in_MB, round(@database_size_in_MB / @timespan_in_days, 2) AS growth_per_day_in_MB,
  round((@database_size_in_MB / @timespan_in_days) * 8 * 2.0 + 50, 0) AS suggested_tmpfs_size_for_1_week_data_in_MB;
> ```
>
> </details>

### Option: `retention`

This section defines the data retention parameters.

### Option: `retention.enabled`

Even this is an in-memory database, it can automatically export (from memory to
SD card) the database's content during backup, update, restart or even
periodically, and can automatically import (from SD card to memory) the content
when the add-on starts again. The database dump is gzip-ed before written to the
storage to minimize SD-card wear.

**Note:**
- the database dump is located in the /data folder, so it is part of the normal
  Home Assistant backup process
- the database dump is **gzip-ed** before written to the storage to minimize
  SD-card wear
- after a power failure, when the add-on is restarted, it will import the last
  known exported database content

If enabled (default) the add-on will
- export the database content before each backup and when stopped (restarted)
- import the database content when started (restarted)

If disabled the add-on will delete any previously saved database content when
started (restarted).

### Option: `retention.periodic`

This option helps to minimize data loss in case of power failure by periodically
exporting the database's content.

Though it won't protect you from power failures completely. After a power
failure, when the add-on is restarted, it will import the last known exported
database content. So when eg. daily periodic export (from memory to SD card) is
enabled, you will loose the latest sensory data within that day, but your long
term statistics information will remain mostly intact.

Possible values:
- disabled (default)
- hourly (periodically export at each hour 00 minute)
- daily (periodically export at 02:00h)
- weekly (periodically export at 03:00h on each Saturday)
- monthly (periodically export at 05:00h on the first day of each month)

**Note:** This option exports the database content from memory to SD card, but
doesn't create a complete Home Assistant backup nor uploads it to anywhere. In
case you use a periodic Home Assistant backup solution, you don't need to enable
this periodic retention option, only enable the retention functionality above,
because exporting database content is part of the add-on's backup.

### Option: `purge_statistics`

This section defines the parameters for statistics data purging.

By default, Home Assistant never deletes statistics data. This means that over 
time the size of the database can grow beyond the memory limit. 

### Option: `purge_statistics.period`

Specifies how frequently should the statistics data be purged.

Possible values:
- daily (periodically purge at 02:00h)
- weekly (periodically purge at 03:00h on each Saturday)
- monthly (periodically purge at 05:00h on the first day of each month)
  (default)

### Option: `purge_statistics.keep_periods`

The number of periods to keep in database after a purge.

Default is 6 months.

> ---
>
> **Important!**
>
> ---
>
> Purging of statistics data impacts "Energy dashboard - Energy usage" graph in
> a weird way:
> - Energy usage values are stored in the database as cumulative (continuously
>   increasing) values.
> - Energy usage *graph* values are calculated as the difference between these
>   cumulative database values.
> - After the statistics data purge, the first graph values will be compared to
>   0, so the displayed first graph values will be unrealistically high.
>
> Please consider increasing `keep_periods` to a high enough value that will not
> disturbe your Energy dashboard (eg. 13 months).
>
> <details>
>
> | <img width="75%" title="&quot;Energy dashboard - Energy usage&quot; graph after purge" src="https://user-images.githubusercontent.com/2125455/268935889-598b0e64-437b-446f-8da5-58554a690d1b.png"> |
> | :---: |
> | _"Energy dashboard - Energy usage" graph after purge_ |
>
> | Month | Energy statistic value <br> (before purge) | Change to previous value <br> (before purge) | Energy statistic value <br> (after purge) | Change to previous value <br> (after purge) |
> |:---:|:-----:|:---:|:----:|:---:|
> | Jan | 400   | 200 | 0    | 0   |
> | Feb | 600   | 200 | 0    | 0   |
> | Mar | 800   | 200 | 800  | ***800 !!!*** |
> | Apr | 1000  | 200 | 1000 | 200 |
> | May | 1200  | 200 | 1200 | 200 |
>
> For more details see [Issue
> #58](https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/issues/58)
>
> </details>

### Option: `purge_statistics.archive`

Whether export the data before deletion.

Default is disabled.

**Note:** The export location is in the `/share/purged-statistics` folder, that
can be acessed with eg. the Samba share add-on. This folder is also part of the
full backup of Home Assistant, so without moving these exported old data
anywhere, they will be part of the Home Assistant backup (not the add-on's
backup, these are deleted from the database, these are archive values, not
belonging to the add-on anymore).

### Option: `databases`

Database name, e.g., `homeassistant`. Multiple are allowed.

### Option: `logins`

This section defines a create user definition in MariaDB. [Create
User][createuser] documentation.

### Option: `logins.username`

Database user login, e.g., `homeassistant`. [User Name][username] documentation.

### Option: `logins.password`

Password for user login. This should be strong and unique.

### Option: `rights`

This section grant privileges to users in MariaDB. [Grant][grant] documentation.

### Option: `rights.username`

This should be the same user name defined in `logins` -> `username`.

### Option: `rights.database`

This should be the same database defined in `databases`.

### Option: `rights.privileges` (optional)

A list of privileges to grant to this user from [grant][grant] like `SELECT` and
`CREATE`. If omitted, grants `ALL PRIVILEGES` to the user. Restricting
privileges of the user that Home Assistant uses is not recommended but if you
want to allow other applications to view recorder data should create a user
limited to read-only access on the database.

## Home Assistant Configuration

MariaDB will be used by the `recorder` and `history` components within Home
Assistant. For more information about setting this up, see the [recorder
integration][recorder] documentation for Home Assistant.

Example Home Assistant configuration:

```yaml
recorder:
  db_url: mysql://homeassistant:<PASSWORD>@45207088-mariadb/homeassistant?charset=utf8mb4
  db_max_retries: 20
  db_retry_wait: 15
  auto_purge: false
  exclude:
    event_types:
      - call_service
  include:
    entities:
      - <the entity ids you really need>

logger:
  default: warning
  filters:
    homeassistant.components.recorder.core:
      - 'Error during connection setup: .MySQLdb.OperationalError. .2002' # Can't connect to MySQL server on '45207088_mariadb'
      - 'Error during connection setup: .MySQLdb.OperationalError. .1130' # Host '172.30.32.1' is not allowed to connect to this MariaDB server
      - 'Error during connection setup: .MySQLdb.OperationalError. .1044' # Access denied for user 'homeassistant'@'%' to database 'homeassistant'

automation:
  - alias: Auto purge with repack
    trigger:
      platform: time
      at: "04:12:00"
    action:
      service: recorder.purge
      data:
        keep_days: 7
        repack: true
```

**Note:** Change the `<PASSWORD>` string in the `db_url` field to the password
you entered in the add-on configuration.

**Note:** The `45207088-mariadb` is the Hostname displayed on the add-on's Info
tab.

> ---
>
> **Important!**
>
> ---
>
> - Don't use `auto_purge`, regular auto purge does not repack the database
>   files, they slowly grow because of fragmentation (new data will not fill
>   perfectly the temporarily unused space of deleted/purged data). Instead call
>   `recorder.purge` service with automation with `repack: true` service data.
> - Exclude all `call_service` entries from the database! These fill up the
>   database really fast with all the parameters to the service calls, MQTT
>   messages, etc.
> - Let the recorder to wait for the database to import the last known database
>   content (from SD card to memory) during Home Assistant startup (that can
>   take up to a few minutes on large databases), use the recorder's
>   `db_max_retry` and `db_retry_wait` paramaters to wait for max. 5 minutes,
>   and use the logger's `filters` parameter to filter out the recorder's error
>   messages when it waits for the database to be ready during startup.
> - See History or use eg. HeidiSQL, DBeaver, BeeKeeper-Studio to access the
>   database and analyze it's content. Search for the entries you don't need,
>   but fill up the database!

## Reported diagnostic sensor values

Values are reported in each 5 minutes.

### Sensor: `sensor.in_memory_mariadb_memory_storage_percent`

The usage of the specified tmpfs capacity in percent.

### Sensor: `sensor.in_memory_mariadb_memory_storage_capacity`

Basically the specified `tmpfs.size` option in human readable format.

### Sensor: `sensor.in_memory_mariadb_memory_storage_used`

Used capacity in human readable format.

### Sensor: `sensor.in_memory_mariadb_memory_storage_available`

Available capacity in human readable format.

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Discord Chat Server][discord].
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

In case you've found a bug, please [open an issue on our GitHub][issue].

[createuser]: https://mariadb.com/kb/en/create-user/
[discord]: https://discord.gg/c5DvZ4e
[forum]: https://community.home-assistant.io/t/in-memory-mariadb-mysql-add-on-for-recorder-history-integration/281791
[grant]: https://mariadb.com/kb/en/grant/
[issue]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/issues
[mariadb]: https://mariadb.com
[recorder]: https://www.home-assistant.io/integrations/recorder/
[reddit]: https://reddit.com/r/homeassistant
[username]: https://mariadb.com/kb/en/create-user/#user-name-component
[warning_stripe]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/raw/master/images/warning_stripe_wide.png
[official_addon]: https://github.com/home-assistant/addons/tree/master/mariadb
