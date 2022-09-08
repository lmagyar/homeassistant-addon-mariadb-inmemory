# Home Assistant Custom Add-on: In-memory MariaDB

![Warning][warning_stripe]

> This is a **fork** of the [official add-on][official_addon]! See changes below.

![Warning][warning_stripe]

In-memory MariaDB database for Home Assistant.

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

You can use this add-on to install MariaDB, which is an open-source (GPLv2 licensed) database. MariaDB can be used as the database backend for Home Assistant. For more information, please see [MariaDB][mariadb]

If you are trying to minimize your SD-card's wear, give this add-on a try.

**Even this is an in-memory database, it can automatically export the database content during backup, update or restart and can automatically import the content when the add-on starts again**.

Though it won't protect you from power failures. After a power failure, when the add-on is restarted, it will import the last known exported database content.

This version uses **tmpfs** to store MariaDB databases in-memory. The default ~~InnoDB~~ storage engine is replaced with **Aria** storage engine (because InnoDB storage engine wastes a great amount of disk space, and Memory storage engine can't handle TEXT columns).

**See the Documentation tab for the required configuration changes for the recorder integration!!!**

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[commits-shield]: https://img.shields.io/github/commit-activity/y/lmagyar/homeassistant-addon-mariadb-inmemory.svg
[commits]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/commits/master
[github-actions-shield]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/workflows/Publish/badge.svg
[github-actions]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/actions
[installations-shield]: https://img.shields.io/badge/dynamic/json?label=reported%20installations&query=$[%2745207088_mariadb%27].total&url=https%3A%2F%2Fanalytics.home-assistant.io%2Faddons.json
[license-shield]: https://img.shields.io/github/license/lmagyar/homeassistant-addon-mariadb-inmemory.svg
[licence]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/blob/master/LICENSE
[maintenance-shield]: https://img.shields.io/maintenance/yes/2022.svg
[project-stage-shield]: https://img.shields.io/badge/project%20stage-custom-orange.svg
[releases-shield]: https://img.shields.io/github/tag/lmagyar/homeassistant-addon-mariadb-inmemory.svg?label=release
[releases]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/tags
[updated-shield]: https://img.shields.io/github/last-commit/lmagyar/homeassistant-addon-mariadb-inmemory/master?label=updated
[updated]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/commits/master
[mariadb]: https://mariadb.com
[warning_stripe]: https://github.com/lmagyar/homeassistant-addon-mariadb-inmemory/raw/master/images/warning_stripe_wide.png
[official_addon]: https://github.com/home-assistant/addons/tree/master/mariadb
