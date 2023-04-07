/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE IF NOT EXISTS `events` (
  `event_id` int(11) NOT NULL AUTO_INCREMENT,
  `event_type` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_data` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `origin` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `origin_idx` smallint(6) DEFAULT NULL,
  `time_fired` datetime(6) DEFAULT NULL,
  `time_fired_ts` double DEFAULT NULL,
  `context_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `context_user_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `context_parent_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`event_id`),
  KEY `ix_events_event_type_time_fired_ts` (`event_type`,`time_fired_ts`),
  KEY `ix_events_time_fired_ts` (`time_fired_ts`),
  KEY `ix_events_data_id` (`data_id`),
  KEY `ix_events_context_id` (`context_id`),
  CONSTRAINT `events_ibfk_1` FOREIGN KEY (`data_id`) REFERENCES `event_data` (`data_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `event_data` (
  `data_id` int(11) NOT NULL AUTO_INCREMENT,
  `hash` bigint(20) DEFAULT NULL,
  `shared_data` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`data_id`),
  KEY `ix_event_data_hash` (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `recorder_runs` (
  `run_id` int(11) NOT NULL AUTO_INCREMENT,
  `start` datetime(6) NOT NULL,
  `end` datetime(6) DEFAULT NULL,
  `closed_incorrect` tinyint(1) NOT NULL,
  `created` datetime(6) NOT NULL,
  PRIMARY KEY (`run_id`),
  KEY `ix_recorder_runs_start_end` (`start`,`end`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `schema_changes` (
  `change_id` int(11) NOT NULL AUTO_INCREMENT,
  `schema_version` int(11) DEFAULT NULL,
  `changed` datetime(6) NOT NULL,
  PRIMARY KEY (`change_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `states` (
  `state_id` int(11) NOT NULL AUTO_INCREMENT,
  `entity_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attributes` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `last_changed` datetime(6) DEFAULT NULL,
  `last_changed_ts` double DEFAULT NULL,
  `last_updated` datetime(6) DEFAULT NULL,
  `last_updated_ts` double DEFAULT NULL,
  `old_state_id` int(11) DEFAULT NULL,
  `attributes_id` int(11) DEFAULT NULL,
  `context_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `context_user_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `context_parent_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `origin_idx` smallint(6) DEFAULT NULL,
  PRIMARY KEY (`state_id`),
  KEY `ix_states_last_updated_ts` (`last_updated_ts`),
  KEY `ix_states_attributes_id` (`attributes_id`),
  KEY `ix_states_entity_id_last_updated_ts` (`entity_id`,`last_updated_ts`),
  KEY `ix_states_context_id` (`context_id`),
  KEY `ix_states_event_id` (`event_id`),
  KEY `ix_states_old_state_id` (`old_state_id`),
  CONSTRAINT `states_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`event_id`) ON DELETE CASCADE,
  CONSTRAINT `states_ibfk_2` FOREIGN KEY (`old_state_id`) REFERENCES `states` (`state_id`),
  CONSTRAINT `states_ibfk_3` FOREIGN KEY (`attributes_id`) REFERENCES `state_attributes` (`attributes_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `state_attributes` (
  `attributes_id` int(11) NOT NULL AUTO_INCREMENT,
  `hash` bigint(20) DEFAULT NULL,
  `shared_attrs` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`attributes_id`),
  KEY `ix_state_attributes_hash` (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `statistics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime(6) DEFAULT NULL,
  `created_ts` double DEFAULT NULL,
  `metadata_id` int(11) DEFAULT NULL,
  `start` datetime(6) DEFAULT NULL,
  `start_ts` double DEFAULT NULL,
  `mean` double DEFAULT NULL,
  `min` double DEFAULT NULL,
  `max` double DEFAULT NULL,
  `last_reset` datetime(6) DEFAULT NULL,
  `last_reset_ts` double DEFAULT NULL,
  `state` double DEFAULT NULL,
  `sum` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_statistics_statistic_id_start_ts` (`metadata_id`,`start_ts`),
  KEY `ix_statistics_metadata_id` (`metadata_id`),
  KEY `ix_statistics_start` (`start`),
  KEY `ix_statistics_start_ts` (`start_ts`),
  CONSTRAINT `statistics_ibfk_1` FOREIGN KEY (`metadata_id`) REFERENCES `statistics_meta` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `statistics_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `statistic_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unit_of_measurement` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `has_mean` tinyint(1) DEFAULT NULL,
  `has_sum` tinyint(1) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_statistics_meta_statistic_id` (`statistic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `statistics_runs` (
  `run_id` int(11) NOT NULL AUTO_INCREMENT,
  `start` datetime(6) NOT NULL,
  PRIMARY KEY (`run_id`),
  KEY `ix_statistics_runs_start` (`start`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `statistics_short_term` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime(6) DEFAULT NULL,
  `created_ts` double DEFAULT NULL,
  `metadata_id` int(11) DEFAULT NULL,
  `start` datetime(6) DEFAULT NULL,
  `start_ts` double DEFAULT NULL,
  `mean` double DEFAULT NULL,
  `min` double DEFAULT NULL,
  `max` double DEFAULT NULL,
  `last_reset` datetime(6) DEFAULT NULL,
  `last_reset_ts` double DEFAULT NULL,
  `state` double DEFAULT NULL,
  `sum` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_statistics_short_term_statistic_id_start_ts` (`metadata_id`,`start_ts`),
  KEY `ix_statistics_short_term_start_ts` (`start_ts`),
  KEY `ix_statistics_short_term_metadata_id` (`metadata_id`),
  KEY `ix_statistics_short_term_start` (`start`),
  CONSTRAINT `statistics_short_term_ibfk_1` FOREIGN KEY (`metadata_id`) REFERENCES `statistics_meta` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
