CREATE TABLE IF NOT EXISTS `mate_users` (
  `name` varchar(64) NOT NULL,
  `password_hash` varchar(256) NOT NULL DEFAULT '',
  `permissions` text NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE `mate_links` (
  `link` varchar(128) NOT NULL DEFAULT '' COMMENT 'unique link',
  `partID` int(11) DEFAULT NULL COMMENT 'the ID of the target if target is a part',
  `partAttachmentID` int(11) DEFAULT NULL COMMENT 'the ID of the target if target is a part attachment',
  `storageID` int(11) DEFAULT NULL COMMENT 'the ID of the target if target is a storage location',
  `auto_generated` tinyint(4) NOT NULL DEFAULT 1,
  `createdAt` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  PRIMARY KEY (`link`),
  KEY `IDX_PART_AUTOGEN` (`partID`, `auto_generated`),
  CONSTRAINT `FK_Link_Part` FOREIGN KEY (`partID`) REFERENCES `Part` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Link_PartAttachment` FOREIGN KEY (`partAttachmentID`) REFERENCES `PartAttachment` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_Link_Storage` FOREIGN KEY (`storageID`) REFERENCES `StorageLocation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
