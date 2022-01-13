CREATE TABLE `mate_login_tokens` (
    `token` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'Token that can be used for logging in',
    `username` varchar(64) NOT NULL DEFAULT '' COMMENT 'User that will be logged in',
    `expiresAt` datetime DEFAULT NULL COMMENT 'When will this token expire?',
    `sessionLength` bigint(11) DEFAULT 3600 COMMENT 'EXP for new sessions in seconds',
    PRIMARY KEY (`token`),
    KEY `mate_token_user` (`username`),
    CONSTRAINT `mate_token_user` FOREIGN KEY (`username`) REFERENCES `mate_users` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;
