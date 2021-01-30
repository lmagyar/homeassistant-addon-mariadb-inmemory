# Changelog

```
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv WARNING vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
```
> This is a **fork** of the official add-on!
>
> ### 2.2.1.4 - 2.2.1.3
> - Enable mount in apparmor.
>
> ### 2.2.1.2
> - The size of the tmpfs is configurable. Though it required SYS_ADMIN privilege.
>
> ### 2.2.1.1
> - Moved from `inmemory` branch to `master` to get rid of error: `stderr: 'fatal: couldn't find remote ref refs/heads/inmemory'.` **Please uninstall the add-on, delete repository, add repository, install add-on.**
> - Tweaking InnoDB to use minimal disk space overhead.

```
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ WARNING ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

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
