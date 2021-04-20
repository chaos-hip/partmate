CREATE TABLE IF NOT EXISTS `mate_users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `password_hash` varchar(256) NOT NULL DEFAULT '',
  `permissions` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_NAME` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `mate_links` (
  `link` varchar(128) NOT NULL DEFAULT '' COMMENT 'unique link',
  `partID` int(11) DEFAULT NULL COMMENT 'the ID of the target',
  `auto_generated` tinyint(4) NOT NULL DEFAULT 1,
  `createdAt` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`link`),
  KEY `FK_Link_Part` (`partID`),
  KEY `IDX_PART_AUTOGEN` (`partID`,`auto_generated`),
  CONSTRAINT `FK_Link_Part` FOREIGN KEY (`partID`) REFERENCES `Part` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;