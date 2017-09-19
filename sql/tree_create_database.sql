-- MySQL Script generated by MySQL Workbench
-- Tue Jul 18 14:41:14 2017
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema tree
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tree` DEFAULT CHARACTER SET utf8 ;
USE `tree` ;

-- -----------------------------------------------------
-- Table `tree`.`tree`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree` (
  `tree_id` INT NOT NULL AUTO_INCREMENT,
  `tree_slug` VARCHAR(255) NOT NULL DEFAULT '',
  `tree_content` VARCHAR(512) NOT NULL DEFAULT '',
  `tree_title` VARCHAR(255) NOT NULL DEFAULT '',
  `tree_created_at` TIMESTAMP DEFAULT '1970-01-01 06:00:00',
  `tree_updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tree_deleted` TINYINT DEFAULT 0,
  `tree_owner` INT NULL,
  `tree_created_by` INT NULL,
  `tree_updated_by` INT NULL,
  PRIMARY KEY (`tree_id`),
  UNIQUE INDEX `treeSlug_UNIQUE` (`tree_slug` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tree`.`tree_element_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_element_type` (
  `el_type_id` INT NOT NULL AUTO_INCREMENT,
  `el_type` VARCHAR(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`el_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tree`.`tree_element`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_element` (
  `el_id` INT NOT NULL AUTO_INCREMENT,
  `tree_id` INT NULL,
  `el_type_id` INT NULL,
  `el_title` VARCHAR(255) NOT NULL DEFAULT '',
  `el_content` VARCHAR(512) NOT NULL DEFAULT '',
  `el_created_by` INT NULL,
  `el_updated_by` INT NULL,
  `el_created_at` TIMESTAMP DEFAULT '1970-01-01 06:00:00',
  `el_updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`el_id`),
  INDEX `el_type_id_idx` (`el_type_id` ASC),
  INDEX `tree_id_idx` (`tree_id` ASC),
  CONSTRAINT `element_el_type_id`
    FOREIGN KEY (`el_type_id`)
    REFERENCES `tree`.`tree_element_type` (`el_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `element_tree_id`
    FOREIGN KEY (`tree_id`)
    REFERENCES `tree`.`tree` (`tree_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tree`.`tree_element_container`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_element_container` (
  `el_container_id` INT NOT NULL AUTO_INCREMENT,
  `el_id` INT NULL,
  `el_id_child` INT NULL,
  PRIMARY KEY (`el_container_id`),
  INDEX `el_id_idx` (`el_id` ASC),
  INDEX `el_id_idx1` (`el_id_child` ASC),
  CONSTRAINT `container_el_id`
    FOREIGN KEY (`el_id`)
    REFERENCES `tree`.`tree_element` (`el_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `container_el_id_child`
    FOREIGN KEY (`el_id_child`)
    REFERENCES `tree`.`tree_element` (`el_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tree`.`tree_element_destination`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_element_destination` (
  `el_destination_id` INT NOT NULL AUTO_INCREMENT,
  `el_id` INT NULL,
  `el_id_destination` INT NULL,
  PRIMARY KEY (`el_destination_id`),
  INDEX `el_id_idx` (`el_id` ASC),
  INDEX `el_id_idx1` (`el_id_destination` ASC),
  CONSTRAINT `destination_el_id`
    FOREIGN KEY (`el_id`)
    REFERENCES `tree`.`tree_element` (`el_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `destination_el_id_destination`
    FOREIGN KEY (`el_id_destination`)
    REFERENCES `tree`.`tree_element` (`el_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tree`.`tree_element_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_element_order` (
  `el_order_id` INT NOT NULL AUTO_INCREMENT,
  `el_id` INT NULL,
  `el_order` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`el_order_id`),
  INDEX `el_id_idx` (`el_id` ASC),
  CONSTRAINT `order_el_id`
    FOREIGN KEY (`el_id`)
    REFERENCES `tree`.`tree_element` (`el_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tree`.`tree_interaction_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_interaction_type` (
  `interaction_type_id` INT NOT NULL AUTO_INCREMENT,
  `interaction_type` VARCHAR(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`interaction_type_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tree`.`tree_state_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_state_type` (
  `state_type_id` INT NOT NULL AUTO_INCREMENT,
  `state_type` VARCHAR(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`state_type_id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tree`.`tree_interaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_interaction` (
  `interaction_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` varchar(45) NULL,
  `tree_id` INT NULL,
  `interaction_type_id` INT NULL,
  `state_type_id` INT NULL,
  `interaction_created_at` TIMESTAMP DEFAULT '1970-01-01 06:00:00',
  `interaction_updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`interaction_id`),
  INDEX `interaction_type_id_idx` (`interaction_type_id` ASC),
  INDEX `tree_id_idx` (`tree_id` ASC),
  CONSTRAINT `interaction_el_type_id`
    FOREIGN KEY (`interaction_type_id`)
    REFERENCES `tree`.`tree_interaction_type` (`interaction_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `interaction_state_type_id`
    FOREIGN KEY (`state_type_id`)
    REFERENCES `tree`.`tree_state_type` (`state_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `interaction_tree_id`
    FOREIGN KEY (`tree_id`)
    REFERENCES `tree`.`tree` (`tree_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tree`.`tree_state`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_state` (
  `state_id` INT NOT NULL AUTO_INCREMENT,
  `interaction_id` INT NULL,
  `el_id` INT NULL,
  PRIMARY KEY (`state_id`),
  INDEX `el_id_idx` (`el_id` ASC),
  CONSTRAINT `state_interaction_id`
    FOREIGN KEY (`interaction_id`)
    REFERENCES `tree`.`tree_interaction` (`interaction_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `state_el_id`
    FOREIGN KEY (`el_id`)
    REFERENCES `tree`.`tree_element` (`el_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tree`.`tree_interaction_element`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_interaction_element` (
  `interaction_el_id` INT NOT NULL AUTO_INCREMENT,
  `interaction_id` INT NULL,
  `el_id` INT NULL,
  PRIMARY KEY (`interaction_el_id`),
  INDEX `el_id_idx` (`el_id` ASC),
  CONSTRAINT `interaction_el_interaction_id`
    FOREIGN KEY (`interaction_id`)
    REFERENCES `tree`.`tree_interaction` (`interaction_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `interaction_el_id`
    FOREIGN KEY (`el_id`)
    REFERENCES `tree`.`tree_element` (`el_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Trigger for setting "Created at" timestamp on tree table
-- -----------------------------------------------------
DELIMITER //
DROP TRIGGER IF EXISTS tree_insert_trigger//
CREATE TRIGGER tree_insert_trigger
BEFORE INSERT ON `tree`.`tree`
FOR EACH ROW
BEGIN
IF NEW.tree_created_at = '1970-01-01 06:00:00' THEN
SET NEW.tree_created_at = NOW();
END IF;
END;//
DELIMITER ;

-- -----------------------------------------------------
-- Trigger for setting "Created at" timestamp on tree_element table
-- -----------------------------------------------------
DELIMITER //
DROP TRIGGER IF EXISTS tree_element_insert_trigger//
CREATE TRIGGER tree_element_insert_trigger
BEFORE INSERT ON `tree`.`tree_element`
FOR EACH ROW
BEGIN
IF NEW.el_created_at = '1970-01-01 06:00:00' THEN
SET NEW.el_created_at = NOW();
END IF;
END;//
DELIMITER ;

-- -----------------------------------------------------
-- Trigger for setting "Created at" timestamp on tree table
-- -----------------------------------------------------
DELIMITER //
DROP TRIGGER IF EXISTS tree_insert_trigger//
CREATE TRIGGER tree_insert_trigger
BEFORE INSERT ON `tree`.`tree_interaction`
FOR EACH ROW
BEGIN
IF NEW.interaction_created_at = '1970-01-01 06:00:00' THEN
SET NEW.interaction_created_at = NOW();
END IF;
END;//
DELIMITER ;


USE `tree` ;

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`tree_question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_api` (`el_id` INT, `tree_id` INT, `el_title` INT, `el_content` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`tree_question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_question` (`el_id` INT, `tree_id` INT, `el_type` INT, `el_title` INT, `el_content` INT, `el_order` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`tree_group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_group` (`el_id` INT, `tree_id` INT, `el_type` INT, `el_title` INT, `el_content` INT, `el_order` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`tree_option`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_option` (`el_id` INT, `tree_id` INT, `el_type` INT, `el_title` INT, `el_content` INT, `el_order` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`tree_end`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_end` (`el_id` INT, `tree_id` INT, `el_type` INT, `el_title` INT, `el_content` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`tree_start`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_start` (`el_id` INT, `tree_id` INT, `el_type` INT, `el_title` INT, `el_content` INT);

-- -----------------------------------------------------
-- View `tree`.`tree_api`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_api`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_api` (tree_id, tree_slug, title, content, created_at, updated_at, owner) AS
    SELECT
        tree_id, tree_slug, tree_title, tree_content, tree_created_at, tree_updated_at, tree_owner
    FROM
        tree.tree;

-- -----------------------------------------------------
-- View `tree`.`tree_question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_question`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_question` (question_id, tree_id, group_id, title, content, `order`) AS
    SELECT
        el.el_id, el.tree_id, el_group.el_id, el.el_title, el.el_content, el_order.el_order
    FROM
        tree.tree_element el
            INNER JOIN
        tree.tree_element_type el_type ON el.el_type_id = el_type.el_type_id
            INNER JOIN
        tree.tree_element_order el_order ON el.el_id = el_order.el_id
            LEFT JOIN
        tree.tree_element_container el_group ON el.el_id = el_group.el_id_child
    WHERE
        el_type.el_type = 'question';

-- -----------------------------------------------------
-- View `tree`.`tree_end`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_end`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_end` (end_id, tree_id, title, content) AS
    SELECT
        el.el_id, el.tree_id, el.el_title, el.el_content
    FROM
        tree.tree_element el
            INNER JOIN
        tree.tree_element_type el_type ON el.el_type_id = el_type.el_type_id
    WHERE
        el_type.el_type = 'end';

-- -----------------------------------------------------
-- View `tree`.`tree_option`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_option`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_option` (option_id, tree_id, question_id, title, content, `order`, destination_id, destination_type) AS
    SELECT
        el.el_id, el.tree_id, question.el_id, el.el_title, el.el_content, el_order.el_order, destination.el_id_destination, destination_type.el_type
    FROM
        tree.tree_element el
            INNER JOIN
        tree.tree_element_type el_type ON el.el_type_id = el_type.el_type_id
            INNER JOIN
        tree.tree_element_order el_order ON el.el_id = el_order.el_id
            INNER JOIN
        tree.tree_element_container question ON el.el_id = question.el_id_child
            INNER JOIN
        tree.tree_element_destination destination ON el.el_id = destination.el_id
            INNER JOIN
        tree.tree_element destination_el ON destination_el.el_id = destination.el_id_destination
            INNER JOIN
        tree.tree_element_type destination_type ON destination_type.el_type_id = destination_el.el_type_id
    WHERE
        el_type.el_type = 'option';

-- -----------------------------------------------------
-- View `tree`.`tree_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_group`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_group` (group_id, tree_id, title, content, `order`) AS
    SELECT
        el.el_id, el.tree_id, el.el_title, el.el_content, el_order.el_order
    FROM
        tree.tree_element el
            INNER JOIN
        tree.tree_element_type el_type ON el.el_type_id = el_type.el_type_id
            INNER JOIN
        tree.tree_element_order el_order ON el.el_id = el_order.el_id
    WHERE
        el_type.el_type = 'group';

-- -----------------------------------------------------
-- View `tree`.`tree_start`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_start`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_start` (start_id, tree_id, title, content, destination_id) AS
    SELECT
        el.el_id, el.tree_id, el.el_title, el.el_content, destination.el_id_destination
    FROM
        tree.tree_element el
    INNER JOIN
        tree.tree_element_type el_type ON el.el_type_id = el_type.el_type_id
    INNER JOIN
        tree.tree_element_destination destination ON el.el_id = destination.el_id
    WHERE
        el_type.el_type = 'start';


-- -----------------------------------------------------
-- View `tree`.`tree_interactions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_interactions`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_interactions` (interaction_id, user_id, tree_id, interaction_type, state_type, interaction_created_at) AS
    SELECT
        interaction.interaction_id, interaction.user_id, interaction.tree_id, interaction_type.interaction_type, state_type.state_type, interaction.interaction_created_at
    FROM
        tree.tree_interaction interaction
    INNER JOIN
        tree.tree_interaction_type interaction_type ON interaction.interaction_type_id = interaction_type.interaction_type_id
    INNER JOIN
        tree.tree_state_type state_type ON interaction.state_type_id = state_type.state_type_id
    ORDER BY
        interaction.interaction_id;


-- -----------------------------------------------------
-- View `tree`.`tree_interaction_load`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_interaction_load`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_interaction_load` (interaction_id, user_id, tree_id, interaction_created_at) AS
    SELECT
        interactions.interaction_id, interactions.user_id, interactions.tree_id, interactions.interaction_created_at
    FROM
        tree.tree_interactions interactions
    WHERE
        interactions.interaction_type = 'load'
    ORDER BY
        interactions.interaction_id;

-- -----------------------------------------------------
-- View `tree`.`tree_interaction_reload`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_interaction_reload`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_interaction_reload` (interaction_id, user_id, tree_id, interaction_created_at) AS
    SELECT
        interactions.interaction_id, interactions.user_id, interactions.tree_id, interactions.interaction_created_at
    FROM
        tree.tree_interactions interactions
    WHERE
        interactions.interaction_type = 'reload'
    ORDER BY
        interactions.interaction_id;

-- -----------------------------------------------------
-- View `tree`.`tree_interaction_overview`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_interaction_overview`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_interaction_overview` (interaction_id, user_id, tree_id, interaction_created_at) AS
    SELECT
        interactions.interaction_id, interactions.user_id, interactions.tree_id, interactions.interaction_created_at
    FROM
        tree.tree_interactions interactions
    WHERE
        interactions.interaction_type = 'overview'
    ORDER BY
        interactions.interaction_id;

-- -----------------------------------------------------
-- View `tree`.`tree_interaction_start`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_interaction_start`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_interaction_start` (interaction_id, user_id, tree_id, destination_state_type, destination_state_id, interaction_created_at) AS
    SELECT
        interactions.interaction_id, interactions.user_id, interactions.tree_id, interactions.state_type, state.el_id, interactions.interaction_created_at
    FROM
        tree.tree_interactions interactions
    INNER JOIN
        tree.tree_state state ON interactions.interaction_id = state.interaction_id
    WHERE
        interactions.interaction_type = 'start'
    ORDER BY
        interactions.interaction_id;

-- -----------------------------------------------------
-- View `tree`.`tree_interaction_option` interactions with questions
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_interaction_option`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_interaction_option` (interaction_id, user_id, tree_id, option_id, destination_state_type, destination_state_id, interaction_created_at) AS
    SELECT
        interactions.interaction_id, interactions.user_id, interactions.tree_id, interaction_el.el_id, interactions.state_type, state.el_id, interactions.interaction_created_at
    FROM
        tree.tree_interactions interactions
    LEFT JOIN
        tree.tree_state state ON interactions.interaction_id = state.interaction_id
    INNER JOIN
        tree.tree_interaction_element interaction_el ON interactions.interaction_id = interaction_el.interaction_id
    WHERE
        interactions.interaction_type = 'option'
    ORDER BY
        interactions.interaction_id;

-- -----------------------------------------------------
-- View `tree`.`tree_interaction_overview_option` interactions with overviews and options
-- -----------------------------------------------------
/*DROP TABLE IF EXISTS `tree`.`tree_interaction_overview_option`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_interaction_option` (interaction_id, tree_id, user_id, option_id, state_type_id, state_type, state_id, `interaction_id`) AS*/


-- -----------------------------------------------------
-- View `tree`.`tree_interaction_question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_interaction_question`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_interaction_question` (interaction_id, user_id, tree_id, question_id, interaction_created_at) AS
    SELECT
        interactions.interaction_id, interactions.user_id, interactions.tree_id, state.el_id, interactions.interaction_created_at
    FROM
        tree.tree_interactions interactions
    INNER JOIN
        tree.tree_state state ON interactions.interaction_id = state.interaction_id
    WHERE
        interactions.state_type = 'question'
    ORDER BY
        interactions.interaction_id;


-- -----------------------------------------------------
-- View `tree`.`tree_interaction_end`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_interaction_end`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_interaction_end` (interaction_id, user_id, tree_id, end_id, interaction_created_at) AS
    SELECT
        interactions.interaction_id, interactions.user_id, interactions.tree_id, state.el_id, interactions.interaction_created_at
    FROM
        tree.tree_interactions interactions
    INNER JOIN
        tree.tree_state state ON interactions.interaction_id = state.interaction_id
    WHERE
        interactions.state_type = 'end'
    ORDER BY
        interactions.interaction_id;

-- -----------------------------------------------------
-- View `tree`.`tree_interaction_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_interaction_history`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_interaction_history` (interaction_id, user_id, tree_id, destination_state_type, destination_state_id, interaction_created_at) AS
    SELECT
        interactions.interaction_id, interactions.user_id, interactions.tree_id, interactions.state_type, state.el_id, interactions.interaction_created_at
    FROM
        tree.tree_interactions interactions
    LEFT JOIN
        tree.tree_state state ON interactions.interaction_id = state.interaction_id
    WHERE
        interactions.interaction_type = 'history'
    ORDER BY
        interactions.interaction_id;


-- -----------------------------------------------------
-- View `tree`.`tree_interactions_max_date_by_user_and_tree`
-- Subquery necessary for tree_bounce view
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_interactions_max_date_by_user_and_tree`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_interactions_max_date_by_user_and_tree` (user_id, tree_id, interaction_created_at) AS
SELECT
  user_id, tree_id, MAX(interaction_created_at)
 FROM
   tree.tree_interactions
 GROUP BY
   user_id, tree_id;

-- -----------------------------------------------------
-- View `tree`.`tree_state_bounce`
-- This is the state the user left the site at
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_state_bounce`;
CREATE  OR REPLACE VIEW `tree_state_bounce` (interaction_id, tree_id, state_bounced, el_id, interaction_created_at) AS
SELECT
    interactions.interaction_id, interactions.tree_id, interactions.state_type, state.el_id, interactions.interaction_created_at
  FROM
    tree.tree_interactions interactions
  LEFT JOIN
    tree.tree_state state ON interactions.interaction_id = state.interaction_id
  INNER JOIN
    tree.tree_interactions_max_date_by_user_and_tree max_date
   ON
     (interactions.user_id = max_date.user_id
      AND
      interactions.interaction_created_at = max_date.interaction_created_at)
  ORDER BY 
    interactions.interaction_id;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
