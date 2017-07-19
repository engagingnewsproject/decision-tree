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
  `tree_created_at` TIMESTAMP DEFAULT '1970-01-01 00:00:00',
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
  `el_created_at` TIMESTAMP DEFAULT '1970-01-01 00:00:00',
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
  `el_order_id` INT NOT NULL,
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
-- Trigger for setting "Created at" timestamp on tree table
-- -----------------------------------------------------
DELIMITER //
DROP TRIGGER IF EXISTS tree_insert_trigger//
CREATE TRIGGER tree_insert_trigger
BEFORE INSERT ON `tree`.`tree`
FOR EACH ROW
BEGIN
IF NEW.tree_created_at = '1970-01-01 00:00:00' THEN
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
IF NEW.el_created_at = '1970-01-01 00:00:00' THEN
SET NEW.el_created_at = NOW();
END IF;
END;//
DELIMITER ;


USE `tree` ;

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`tree_question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_question` (`el_id` INT, `tree_id` INT, `el_type` INT, `el_title` INT, `el_content` INT, `el_order` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`tree_column`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_column` (`el_id` INT, `tree_id` INT, `el_type` INT, `el_title` INT, `el_content` INT, `el_order` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`tree_option`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_option` (`el_id` INT, `tree_id` INT, `el_type` INT, `el_title` INT, `el_content` INT, `el_order` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`tree_end`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`tree_end` (`el_id` INT, `tree_id` INT, `el_type` INT, `el_title` INT, `el_content` INT);

-- -----------------------------------------------------
-- View `tree`.`tree_question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_question`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_question` (question_id, tree_id, column_id, el_title, el_content, el_order) AS
    SELECT
        el.el_id, el.tree_id, column.el_id, el.el_title, el.el_content, el_order.el_order
    FROM
        tree.tree_element el
            INNER JOIN
        tree.tree_element_type el_type ON el.el_type_id = el_type.el_type_id
            INNER JOIN
        tree.tree_element_order el_order ON el.el_id = el_order.el_id
            INNER JOIN
        tree.tree_element_container column ON el.el_id = column.el_id_child
    WHERE
        el_type.el_type = 'question';

-- -----------------------------------------------------
-- View `tree`.`tree_end`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_end`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_end` (end_id, tree_id, el_title, el_content) AS
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
CREATE  OR REPLACE VIEW `tree_option` (option_id, tree_id, question_id, el_title, el_content, el_order, destination_id) AS
    SELECT
        el.el_id, el.tree_id, question.el_id, el.el_title, el.el_content, el_order.el_order, destination.el_id_destination
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
    WHERE
        el_type.el_type = 'option';

-- -----------------------------------------------------
-- View `tree`.`tree_column`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`tree_column`;
USE `tree`;
CREATE  OR REPLACE VIEW `tree_column` (column_id, tree_id, el_title, el_content, el_order) AS
    SELECT
        el.el_id, el.tree_id, el.el_title, el.el_content, el_order.el_order
    FROM
        tree.tree_element el
            INNER JOIN
        tree.tree_element_type el_type ON el.el_type_id = el_type.el_type_id
            INNER JOIN
        tree.tree_element_order el_order ON el.el_id = el_order.el_id
    WHERE
        el_type.el_type = 'column';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
