# Home Assistant Custom Add-on: In-memory MariaDB

In-memory MariaDB database for Home Assistant.

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
> long term statistics information will remain mostly intact:

| <img width="75%" title="Long term statistics" src="https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/raw/master/images/long_term_statistics.png"> |
| :---: |
| _Long term statistics from an in-memory database_ |

![Warning][warning_stripe]

[![GitHub Release][releases-shield]][releases]
[![Last Updated][updated-shield]][updated]
![Reported Installations][installations-shield]
![Project Stage][project-stage-shield]
[![License][license-shield]][licence]

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

[![Github Actions][github-actions-shield]][github-actions]
![Project Maintenance][maintenance-shield]
[![GitHub Activity][commits-shield]][commits]

## About

You can use this add-on to install an _**in-memory**_ MariaDB, which is an
open-source (GPLv2 licensed) database. MariaDB can be used as the database
backend for Home Assistant. For more information, please see [MariaDB][mariadb]

**See the Documentation tab for the required configuration changes for the
recorder integration!!!**

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-no-red.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-no-red.svg
[commits-shield]: https://img.shields.io/github/commit-activity/y/lmagyar/homeassistant-addon-mariadb-inmemory.svg
[commits]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/commits/master
[github-actions-shield]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/workflows/Publish/badge.svg
[github-actions]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/actions
[installations-shield]: https://img.shields.io/badge/dynamic/json?label=reported%20installations&query=$[%2745207088_mariadb%27].total&url=https%3A%2F%2Fanalytics.home-assistant.io%2Faddons.json
[license-shield]: https://img.shields.io/github/license/lmagyar/homeassistant-addon-mariadb-inmemory.svg
[licence]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/blob/master/LICENSE
[maintenance-shield]: https://img.shields.io/maintenance/yes/2024.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-production%20ready-green.svg
[releases-shield]: https://img.shields.io/github/tag/lmagyar/homeassistant-addon-mariadb-inmemory.svg?label=release
[releases]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/tags
[updated-shield]: https://img.shields.io/github/last-commit/lmagyar/homeassistant-addon-mariadb-inmemory/master?label=updated
[updated]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/commits/master
[mariadb]: https://mariadb.com
[warning_stripe]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/raw/master/images/warning_stripe_wide.png
[official_addon]: https://github.com/home-assistant/addons/tree/master/mariadb
