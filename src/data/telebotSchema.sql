CREATE TABLE `client` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `chat_id` varchar(45) NOT NULL,
  `telegram_user_id` varchar(45) NOT NULL,
  `waiting_for_answer` bit(1) DEFAULT NULL COMMENT '1: yes;\n0: not',
  `questions_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_client_questions1_idx` (`questions_id`),
  CONSTRAINT `fk_client_questions1` FOREIGN KEY (`questions_id`) REFERENCES `questions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `client_has_questions` (
  `client_id` int NOT NULL,
  `questions_id` int NOT NULL,
  `options_id` int NOT NULL,
  `date` datetime NOT NULL,
  `state` bit(1) NOT NULL COMMENT '1: active;\n0: deleted',
  KEY `fk_client_has_questions_questions1_idx` (`questions_id`),
  KEY `fk_client_has_questions_client1_idx` (`client_id`),
  KEY `fk_client_has_questions_options1_idx` (`options_id`),
  CONSTRAINT `fk_client_has_questions_client1` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`),
  CONSTRAINT `fk_client_has_questions_options1` FOREIGN KEY (`options_id`) REFERENCES `options` (`id`),
  CONSTRAINT `fk_client_has_questions_questions1` FOREIGN KEY (`questions_id`) REFERENCES `questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `options` (
  `id` int NOT NULL AUTO_INCREMENT,
  `option` varchar(1000) NOT NULL,
  `questions_id` int NOT NULL,
  `is_correct` bit(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_options_questions1_idx` (`questions_id`),
  CONSTRAINT `fk_options_questions1` FOREIGN KEY (`questions_id`) REFERENCES `questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `questions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `question` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `references` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `text` varchar(2000) NOT NULL,
  `questions_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_references_questions1_idx` (`questions_id`),
  CONSTRAINT `fk_references_questions1` FOREIGN KEY (`questions_id`) REFERENCES `questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
