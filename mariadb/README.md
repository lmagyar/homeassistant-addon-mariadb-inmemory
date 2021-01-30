# Home Assistant Add-on: MariaDB

```
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv WARNING vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
```
> This is a **fork** of the official add-on!
>
> This version uses **tmpfs** to store MariaDB database in-memory. The Memory storage engine is not suitable, because that [can't handle TEXT columns](https://mariadb.com/kb/en/memory-storage-engine/) in the recorder [database](https://www.home-assistant.io/docs/backend/database/#schema).
>
> If you use the built-in SQLite with `db_url: 'sqlite:///:memory:'` recorder configuration and fed up with the uncountable `[homeassistant.components.recorder.util] Error executing query: (sqlite3.OperationalError) cannot commit - no transaction is active` errors in your HA log, give this add-on a try.
>
> **See the Documentation tab for the required configuration changes for the `recorder` integration!!!**
>
> It will also protect you from the data loss caused by HA core restarts when in-memory SQLite used. Though it won't protect you from power failures, add-on or host restarts.

```
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ WARNING ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

MariaDB database for Home Assistant.

![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield] ![Supports armhf Architecture][armhf-shield] ![Supports armv7 Architecture][armv7-shield] ![Supports i386 Architecture][i386-shield]

## About

You can use this add-on to install MariaDB, which is an open-source (GPLv2 licensed) database.  MariaDB can be used as the database backend for Home Assistant. For more information, please see [MariaDB][mariadb]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[mariadb]: https://mariadb.com
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
