# Home Assistant Add-on: In-memory MariaDB

![Warning][warning_stripe]

> This is a **fork** of the official add-on! See changes below.

![Warning][warning_stripe]

In-memory MariaDB database for Home Assistant.

![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield] ![Supports armhf Architecture][armhf-shield] ![Supports armv7 Architecture][armv7-shield] ![Supports i386 Architecture][i386-shield]

## About

You can use this add-on to install MariaDB, which is an open-source (GPLv2 licensed) database.  MariaDB can be used as the database backend for Home Assistant. For more information, please see [MariaDB][mariadb]

If you are trying to minimize your SD-card's wear by using the built-in SQLite with `db_url: 'sqlite:///:memory:'` recorder configuration but fed up with the uncountable `[homeassistant.components.recorder.util] Error executing query: (sqlite3.OperationalError) cannot commit - no transaction is active` errors in your HA log, give this add-on a try.

It will also protect you from the data loss caused by HA core restarts when in-memory SQLite used. Though it won't protect you from power failures, add-on or host restarts or updates.

This version uses **tmpfs** to store MariaDB databases in-memory. The default ~~InnoDB~~ storage engine is replaced with **Aria** storage engine.

**Problem:** InnoDB storage engine wastes a great amount of disk space, but the only storage engine that is compatible with recorder.
- Memory storage engine [can't handle TEXT columns][memory-storage-engine] and
- Aria storage engine [can't handle foreign keys][aria-storage-engine] in the recorder [database schema][schema],
- MyRocks storage engine (though it has compression and flash-friendly) [is not available for 32-bit platforms][myrocks-storage-engine].

**Workaround:** A modified, storage engine compatible [database schema][modified_schema] is created when the add-on starts (ie. before recorder tries to connect and tries to create a schema that the storage engine can't handle)
:
  - foreign keys on `states.event_id` and `states.old_state_id` are removed (Aria can't handle them), but the indexes are remained,
  - `states.entity_id` and `states.state` column's length is reduced from 255 to 128 char (they were too long for Aria keys),
  - `events.event_type` column's length is increased from 32 to 64 char (it was too small for some events, causing SQL errors in recorder),
  - `events.event_data` and `states.attributes` TEXT columns got compressed.

**See the Documentation tab for the required configuration changes for the recorder integration!!!**

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[mariadb]: https://mariadb.com
[memory-storage-engine]: https://mariadb.com/kb/en/memory-storage-engine/
[aria-storage-engine]: https://mariadb.com/resources/blog/storage-engine-choice-aria/
[myrocks-storage-engine]: https://mariadb.com/kb/en/about-myrocks-for-mariadb/#requirements-and-limitations
[schema]: https://www.home-assistant.io/docs/backend/database/#schema
[modified_schema]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/blob/master/mariadb/rootfs/etc/services.d/mariadb/schema.sql
[warning_stripe]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/raw/master/mariadb/warning_stripe_wide.png
