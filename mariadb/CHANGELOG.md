# Changelog

## vNext (forked)

- Update Add-on base image to v14.0.6

## 2.6.1.1 (forked)

- Fix statistics data purge for new database schema
- Fix database export durability with fsync
- Internally store previous export in case storage (SD card) fails to execute fsync completely
- Fix issue [#46](https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/issues/46) (Table 'homeassistant.schema_changes' doesn't exist)
- Fix issue [#44](https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/issues/44) (Debian 12 (Supervised installation): Failed to connect to supervisor port 80)
- Update MariaDB to v10.11.4-r0
- Update Add-on base image to v14.0.5 (Update Alpine base image to v3.18.2)
- Sign add-on with Sigstore Cosign

## 2.6.1.0 (forked)

- Use S6 service names from the official add-on
- Use S6 service management from the official add-on for backup notifications instead of S6 fifodir

## 2.6.1

- Use proper log redirection during backup

## 2.6.0

- ~~Migrate add-on layout to S6 Overlay~~ (forked version already migrated it's layout)
- ~~Update to MariaDB version 10.6.12~~ (forked version already uses this MariaDB version)

## 2.5.2.5 (forked)

- Export and import all databases, not only `homeassistant`
- Avoid crond logging to system console
- Require Home Assistant 2023.4.0 or newer
- Remove any pre 2023.4.0 backward compatibility with exported database content (Aria storage engine is not used anymore)
- Update Add-on base image to v13.2.2

## 2.5.2.4 (forked)

- Bugfix for image location

## 2.5.2.3 (forked)

**Important:** Update this add-on first and after that update Home Assistant to the latest 2023.04.x or newer.

- Use InnoDB as storage engine ([#24](https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/issues/24))
  - Convert old Aria schema content exports into InnoDB schema
  - Don't create default schema on startup
- Update Add-on base image to v13.2.0

## 2.5.2.2 (forked)

**Important:** Add the following lines to the Home Assistant configuration (and do not delete what is already there):

```
recorder:
  db_max_retries: 20
  db_retry_wait: 15

logger:
  default: warning
  filters:
    homeassistant.components.recorder.core:
      - 'Error during connection setup: .MySQLdb.OperationalError. .2002'
      - 'Error during connection setup: .MySQLdb.OperationalError. .1130'
      - 'Error during connection setup: .MySQLdb.OperationalError. .1044'
```

For more details see the documentation.

- Finish importing the whole database before enabling external access
- Create default schema after initial setup to force using Aria instead of InnoDB
- Update to MariaDB version 10.6.12
- Bump base image to 2023.02.0

## 2.5.2.1 (forked)

- Bugfix: Change statistics dump filename separator from _ to - in timestamp

## 2.5.2

- ~~Update to MariaDB version 10.6.10~~ (forked version already uses this MariaDB version)

## 2.5.1.7 (forked)

- **New function**: Periodically purge old statistics values. Enabled by default (purge older than 6 months).
- Bump base image to 2022.11.0

## 2.5.1.6 (forked)

- Bugfix: fine tune export/import table order to avoid errors after host (re)boot [#18](https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/issues/18)

## 2.5.1.5 (forked) (unreleased see [#19](https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/issues/19))

- Bugfix: dump database export in failsafe, "transactional" way

## 2.5.1.4 (forked)

- Bump base image to 2022.09.0

## 2.5.1.3 (forked)

- Bugfix in periodic export bash script

## 2.5.1.2 (forked)

- **New function**: Periodically export homeassistant database to minimize data loss in case of power failure. Disabled by default. 

## 2.5.1.1 (forked)

- **New function**: Automatically export homeassistant database on add-on backup and stop, automatically import homeassistant database on add-on start (see documentation for details)
- Automatically apply schema modifications to the schema created by the recorder, no more add-on updates because of schema changes
- Sign add-on with Codenotary Community Attestation Service (CAS)
- Merge upstream changes

## 2.5.1

- Remove deprecated `innodb-buffer-pool-instances`

## 2.5.0

- Update alpine to 3.16 and s6 to v3

## 2.4.0.24 (forked)

- Fix issue [Backup of the add-on is impossible #11](https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/issues/11)
- Fix finish script for S6-overlay v3
- Update apparmor.txt for S6-overlay v3

## 2.4.0.23 (forked)

- Use new recorder schema from core 2022.5.0 and 2022.6.0
- Use dynamic row format
- Bump alpine base image from 3.13 to 3.15
- Bump MariaDB from 10.5.16 to 10.6.8

## 2.4.0.22 (forked)

- Use new recorder schema from core 2022.4.0

## 2.4.0.21 (forked)

- Use new recorder schema from core 2022.2.0

## 2.4.0.20 (forked)

- Use new recorder schema for statistics from core 2021.11.0

## 2.4.0.19 (forked)

- Merge unreleased changes from official add-on [#3](https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/issues/3)
- Use new recorder schema for statistics from core 2021.10.0

## 2.4.0.18 (forked)

- Use new recorder schema for statistics from core 2021.9.0

## 2.4.0.17 (forked)

- Use new recorder schema for statistics from core 2021.7.0

## 2.4.0.16 (forked)

- Merge changes from official add-on

## 2.4.0

- Add lock capabilities during snapshot

## 2.3.0.15 (forked)

- Use new recorder schema for statistics from core 2021.6.0

## 2.3.0.14 (forked)

- Use new recorder schema from core 2021.5.0
- Use new recorder schema from core 2021.4.0
- Merge changes from official add-on

## 2.3.0

- Option to grant user specific privileges for a database

## 2.2.2.13 (forked)

- Use modified recorder schema (without crash safety overhead, TRANSACTIONAL=0)

## 2.2.2.12 (forked)

- Upgrade Alpine Linux to 3.13, MariaDB to 10.5.8
- Use default recorder schema
- Merge changes from official add-on

## 2.2.2

- Update options schema for passwords

## 2.2.1.11 (forked)

- Use new tmpfs location in Supervisor 2021.2.9

## 2.2.1.10 (forked)

- Use new tmpfs add-on config format in Supervisor 2021.2.0

## 2.2.1.9 (forked)

- Use tmpfs for data storage
- Tweak InnoDB to use minimal disk space overhead
- Make the size of the tmpfs filesystem configurable

## 2.2.1

- Don't delete the mariadb.sys user, it's needed in MariaDB >= 10.4.13

## 2.2.0

- Upgrade Alpine Linux to 3.12
- Increase innodb_buffer_pool_size to 128M

## 2.1.2

- Fix S6-Overlay shutdown timeout

## 2.1.0

- Migrate to S6-Overlay
- Use jemalloc for faster database memory management

## 2.0.0

- Pin add-on to Alpine Linux 3.11
- Redirect MariaDB error log to add-on logs
- Remove grant & host options
- Add support for the mysql service
- Use a more secure default on install
- Skip DNS name resolving
- Improve integrity checks and recovery
- Tune MariaDB for lower memory usage
- Close port 3306 by default
- Ensure a proper collation set is used
- Adds database upgrade process during startup
- Change default configuration username from "hass" to "homeassistant"

## 1.3.0

- Update from bash to bashio

## 1.2.0

- Change the way to migrate data

## 1.1.0

- Fix connection issue with 10.3.13

## 1.0.0

- Update MariaDB to 10.3.13
