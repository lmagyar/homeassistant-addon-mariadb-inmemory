
CREATE TABLE `events` (
  `event_id` int(11) NOT NULL AUTO_INCREMENT,
  `event_type` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_data` text COMPRESSED COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `origin` varchar(32) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `time_fired` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `context_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `context_user_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `context_parent_id` varchar(36) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`event_id`),
  KEY `ix_events_time_fired` (`time_fired`),
  KEY `ix_events_context_id` (`context_id`),
  KEY `ix_events_event_type_time_fired` (`event_type`,`time_fired`),
  KEY `ix_events_context_user_id` (`context_user_id`),
  KEY `ix_events_context_parent_id` (`context_parent_id`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci PAGE_CHECKSUM=0 TRANSACTIONAL=0;

CREATE TABLE `recorder_runs` (
  `run_id` int(11) NOT NULL AUTO_INCREMENT,
  `start` datetime DEFAULT NULL,
  `end` datetime DEFAULT NULL,
  `closed_incorrect` tinyint(1) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`run_id`),
  KEY `ix_recorder_runs_start_end` (`start`,`end`),
  CONSTRAINT `CONSTRAINT_1` CHECK (`closed_incorrect` in (0,1))
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci PAGE_CHECKSUM=0 TRANSACTIONAL=0;

CREATE TABLE `schema_changes` (
  `change_id` int(11) NOT NULL AUTO_INCREMENT,
  `schema_version` int(11) DEFAULT NULL,
  `changed` datetime DEFAULT NULL,
  PRIMARY KEY (`change_id`)
) AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci PAGE_CHECKSUM=0 TRANSACTIONAL=0;

CREATE TABLE `states` (
  `state_id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `entity_id` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `attributes` text COMPRESSED COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `last_changed` datetime DEFAULT NULL,
  `last_updated` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `old_state_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`state_id`),
  KEY `ix_states_entity_id_last_updated` (`entity_id`,`last_updated`),
  KEY `ix_states_old_state_id` (`old_state_id`),
  KEY `ix_states_event_id` (`event_id`),
  KEY `ix_states_last_updated` (`last_updated`)
) DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci PAGE_CHECKSUM=0 TRANSACTIONAL=0;

-- schema_version 11 commit https://github.com/home-assistant/core/commit/12af87bc6e85f98623afc2231c55bb30aeb38938
INSERT IGNORE INTO `schema_changes` (`change_id`, `schema_version`, `changed`) VALUES
	(1, 11, '2021-01-04 09:51:00');
