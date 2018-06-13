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
  `treeID` INT NOT NULL AUTO_INCREMENT,
  `treeSlug` VARCHAR(255) NOT NULL DEFAULT '',
  `treeContent` VARCHAR(512) NOT NULL DEFAULT '',
  `treeTitle` VARCHAR(255) NOT NULL DEFAULT '',
  `treeCreatedAt` TIMESTAMP DEFAULT '1970-01-01 06:00:00',
  `treeUpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `treeDeleted` TINYINT(1) DEFAULT 0,
  `treeOwner` INT NULL,
  `treeCreatedBy` INT NULL,
  `treeUpdatedBy` INT NULL,
  PRIMARY KEY (`treeID`),
  UNIQUE INDEX `treeSlug_UNIQUE` (`treeSlug` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tree`.`treeElementType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeElementType` (
  `elTypeID` INT NOT NULL AUTO_INCREMENT,
  `elType` VARCHAR(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`elTypeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tree`.`treeElement`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeElement` (
  `elID` INT NOT NULL AUTO_INCREMENT,
  `treeID` INT NULL,
  `elTypeID` INT NULL,
  `elTitle` VARCHAR(255) NOT NULL DEFAULT '',
  `elContent` VARCHAR(512) NOT NULL DEFAULT '',
  `elCreatedBy` INT NULL,
  `elUpdatedBy` INT NULL,
  `elCreatedAt` TIMESTAMP DEFAULT '1970-01-01 06:00:00',
  `elUpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `elDeleted` TINYINT(1) DEFAULT 0,
  PRIMARY KEY (`elID`),
  INDEX `elTypeIDIDx` (`elTypeID` ASC),
  INDEX `treeIDIDx` (`treeID` ASC),
  CONSTRAINT `elementElTypeID`
    FOREIGN KEY (`elTypeID`)
    REFERENCES `tree`.`treeElementType` (`elTypeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `elementTreeID`
    FOREIGN KEY (`treeID`)
    REFERENCES `tree`.`tree` (`treeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tree`.`treeElementContainer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeElementContainer` (
  `elContainerID` INT NOT NULL AUTO_INCREMENT,
  `elID` INT NULL,
  `elIDChild` INT NULL,
  PRIMARY KEY (`elContainerID`),
  INDEX `elIDIDx` (`elID` ASC),
  INDEX `elIDIDx1` (`elIDChild` ASC),
  CONSTRAINT `containerElID`
    FOREIGN KEY (`elID`)
    REFERENCES `tree`.`treeElement` (`elID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `containerElIDChild`
    FOREIGN KEY (`elIDChild`)
    REFERENCES `tree`.`treeElement` (`elID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tree`.`treeElementDestination`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeElementDestination` (
  `elDestinationID` INT NOT NULL AUTO_INCREMENT,
  `elID` INT NULL,
  `elIDDestination` INT NULL,
  PRIMARY KEY (`elDestinationID`),
  INDEX `elIDIDx` (`elID` ASC),
  INDEX `elIDIDx1` (`elIDDestination` ASC),
  CONSTRAINT `destinationElID`
    FOREIGN KEY (`elID`)
    REFERENCES `tree`.`treeElement` (`elID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `destinationElIDDestination`
    FOREIGN KEY (`elIDDestination`)
    REFERENCES `tree`.`treeElement` (`elID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tree`.`treeElementOrder`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeElementOrder` (
  `elOrderID` INT NOT NULL AUTO_INCREMENT,
  `elID` INT NULL,
  `elOrder` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`elOrderID`),
  INDEX `elIDIDx` (`elID` ASC),
  CONSTRAINT `orderElID`
    FOREIGN KEY (`elID`)
    REFERENCES `tree`.`treeElement` (`elID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tree`.`treeInteractionType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeInteractionType` (
  `interactionTypeID` INT NOT NULL AUTO_INCREMENT,
  `interactionType` VARCHAR(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`interactionTypeID`))
ENGINE = InnoDB;

INSERT INTO `tree`.`treeInteractionType` (`interactionTypeID`, `interactionType`) VALUES
(1, 'load'),
(2, 'reload'),
(3, 'start'),
(4, 'overview'),
(5, 'option'),
(6, 'history'),
(7, 'restart');

-- -----------------------------------------------------
-- Table `tree`.`treeStateType`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeStateType` (
  `stateTypeID` INT NOT NULL AUTO_INCREMENT,
  `stateType` VARCHAR(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`stateTypeID`))
ENGINE = InnoDB;

INSERT INTO `tree`.`treeStateType` (`stateTypeID`, `stateType`) VALUES
(1, 'intro'),
(2, 'question'),
(3, 'end'),
(4, 'overview');

-- -----------------------------------------------------
-- Table `tree`.`treeSite`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeSite` (
  `siteID` INT NOT NULL AUTO_INCREMENT,
  `siteName` VARCHAR(255) NOT NULL DEFAULT '',
  `siteHost` VARCHAR(255) NOT NULL DEFAULT '',
  `siteCreatedAt` TIMESTAMP DEFAULT '1970-01-01 06:00:00',
  `siteUpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `siteIsDev` BOOLEAN DEFAULT 0,
  PRIMARY KEY (`siteID`),
  CONSTRAINT `treeSiteSiteHost` UNIQUE(`siteHost`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tree`.`treeEmbed`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeEmbed` (
  `embedID` INT NOT NULL AUTO_INCREMENT,
  `siteID` INT NULL,
  `treeID` INT NULL,
  `embedPath` VARCHAR(255) NOT NULL DEFAULT '',
  `embedCreatedAt` TIMESTAMP DEFAULT '1970-01-01 06:00:00',
  `embedUpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `embedIsIframe` BOOLEAN DEFAULT 0,
  `embedIsDev` BOOLEAN DEFAULT 0,
  PRIMARY KEY (`embedID`),
  CONSTRAINT `embedSiteID`
    FOREIGN KEY (`siteID`)
    REFERENCES `tree`.`treeSite` (`siteID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `embedTreeID`
    FOREIGN KEY (`treeID`)
    REFERENCES `tree`.`tree` (`treeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `treeEmbedUnique`
    UNIQUE(`siteID`, `treeID`, `embedPath`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tree`.`treeInteraction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeInteraction` (
  `interactionID` INT NOT NULL AUTO_INCREMENT,
  `userID` varchar(45) NULL,
  `embedID` INT NULL,
  `treeID` INT NULL,
  `interactionTypeID` INT NULL,
  `stateTypeID` INT NULL,
  `interactionCreatedAt` TIMESTAMP DEFAULT '1970-01-01 06:00:00',
  `interactionUpdatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`interactionID`),
  INDEX `interactionTypeIDIDx` (`interactionTypeID` ASC),
  INDEX `treeIDIDx` (`treeID` ASC),
  CONSTRAINT `interactionElTypeID`
    FOREIGN KEY (`interactionTypeID`)
    REFERENCES `tree`.`treeInteractionType` (`interactionTypeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `interactionStateTypeID`
    FOREIGN KEY (`stateTypeID`)
    REFERENCES `tree`.`treeStateType` (`stateTypeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `interactionTreeID`
    FOREIGN KEY (`treeID`)
    REFERENCES `tree`.`tree` (`treeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `interactionEmbedID`
    FOREIGN KEY (`embedID`)
    REFERENCES `tree`.`treeEmbed` (`embedID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tree`.`treeState`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeState` (
  `stateID` INT NOT NULL AUTO_INCREMENT,
  `interactionID` INT NULL,
  `elID` INT NULL,
  PRIMARY KEY (`stateID`),
  INDEX `elIDIDx` (`elID` ASC),
  CONSTRAINT `stateInteractionID`
    FOREIGN KEY (`interactionID`)
    REFERENCES `tree`.`treeInteraction` (`interactionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `stateElID`
    FOREIGN KEY (`elID`)
    REFERENCES `tree`.`treeElement` (`elID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `tree`.`treeInteractionElement`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeInteractionElement` (
  `interactionElID` INT NOT NULL AUTO_INCREMENT,
  `interactionID` INT NULL,
  `elID` INT NULL,
  PRIMARY KEY (`interactionElID`),
  INDEX `elIDIDx` (`elID` ASC),
  CONSTRAINT `interactionElInteractionID`
    FOREIGN KEY (`interactionID`)
    REFERENCES `tree`.`treeInteraction` (`interactionID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `interactionElID`
    FOREIGN KEY (`elID`)
    REFERENCES `tree`.`treeElement` (`elID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Trigger for setting "Created at" timestamp on tree table
-- -----------------------------------------------------
DELIMITER //
DROP TRIGGER IF EXISTS treeInsertTrigger//
CREATE TRIGGER treeInsertTrigger
BEFORE INSERT ON `tree`.`tree`
FOR EACH ROW
BEGIN
IF NEW.treeCreatedAt = '1970-01-01 06:00:00' THEN
SET NEW.treeCreatedAt = NOW();
END IF;
END;//
DELIMITER ;

-- -----------------------------------------------------
-- Trigger for setting "Created at" timestamp on treeElement table
-- -----------------------------------------------------
DELIMITER //
DROP TRIGGER IF EXISTS treeElementInsertTrigger//
CREATE TRIGGER treeElementInsertTrigger
BEFORE INSERT ON `tree`.`treeElement`
FOR EACH ROW
BEGIN
IF NEW.elCreatedAt = '1970-01-01 06:00:00' THEN
SET NEW.elCreatedAt = NOW();
END IF;
END;//
DELIMITER ;

-- -----------------------------------------------------
-- Trigger for setting "Created at" timestamp on tree table
-- -----------------------------------------------------
DELIMITER //
DROP TRIGGER IF EXISTS treeInteractionTrigger//
CREATE TRIGGER treeInteractionTrigger
BEFORE INSERT ON `tree`.`treeInteraction`
FOR EACH ROW
BEGIN
IF NEW.interactionCreatedAt = '1970-01-01 06:00:00' THEN
SET NEW.interactionCreatedAt = NOW();
END IF;
END;//
DELIMITER ;

-- -----------------------------------------------------
-- Trigger for setting "Created at" timestamp on site table
-- -----------------------------------------------------
DELIMITER //
DROP TRIGGER IF EXISTS treeSiteTrigger//
CREATE TRIGGER treeSiteTrigger
BEFORE INSERT ON `tree`.`treeSite`
FOR EACH ROW
BEGIN
IF NEW.siteCreatedAt = '1970-01-01 06:00:00' THEN
SET NEW.siteCreatedAt = NOW();
END IF;
END;//
DELIMITER ;

-- -----------------------------------------------------
-- Trigger for setting "Created at" timestamp on embed table
-- -----------------------------------------------------
DELIMITER //
DROP TRIGGER IF EXISTS treeEmbedTrigger//
CREATE TRIGGER treeEmbedTrigger
BEFORE INSERT ON `tree`.`treeEmbed`
FOR EACH ROW
BEGIN
IF NEW.embedCreatedAt = '1970-01-01 06:00:00' THEN
SET NEW.embedCreatedAt = NOW();
END IF;
END;//
DELIMITER ;


USE `tree` ;

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`treeQuestion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeAPI` (`elID` INT, `treeID` INT, `elTitle` INT, `elContent` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`treeQuestion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeQuestion` (`elID` INT, `treeID` INT, `elType` INT, `elTitle` INT, `elContent` INT, `elOrder` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`treeGroup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeGroup` (`elID` INT, `treeID` INT, `elType` INT, `elTitle` INT, `elContent` INT, `elOrder` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`treeOption`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeOption` (`elID` INT, `treeID` INT, `elType` INT, `elTitle` INT, `elContent` INT, `elOrder` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`treeEnd`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeEnd` (`elID` INT, `treeID` INT, `elType` INT, `elTitle` INT, `elContent` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tree`.`treeStart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tree`.`treeStart` (`elID` INT, `treeID` INT, `elType` INT, `elTitle` INT, `elContent` INT);

-- -----------------------------------------------------
-- View `tree`.`treeAPI`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeAPI`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeAPI` (treeID, treeSlug, title, content, createdAt, updatedAt, owner, deleted) AS
    SELECT
        treeID, treeSlug, treeTitle, treeContent, treeCreatedAt, treeUpdatedAt, treeOwner, treeDeleted
    FROM
        tree.tree;

-- -----------------------------------------------------
-- View `tree`.`treeQuestion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeQuestion`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeQuestion` (questionID, treeID, groupID, title, content, `order`, deleted) AS
    SELECT
        el.elID, el.treeID, elGroup.elID, el.elTitle, el.elContent, elOrder.elOrder, el.elDeleted
    FROM
        tree.treeElement el
            INNER JOIN
        tree.treeElementType elType ON el.elTypeID = elType.elTypeID
            INNER JOIN
        tree.treeElementOrder elOrder ON el.elID = elOrder.elID
            LEFT JOIN
        tree.treeElementContainer elGroup ON el.elID = elGroup.elIDChild
    WHERE
        elType.elType = 'question';

-- -----------------------------------------------------
-- View `tree`.`treeEnd`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeEnd`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeEnd` (endID, treeID, title, content, deleted) AS
    SELECT
        el.elID, el.treeID, el.elTitle, el.elContent, el.elDeleted
    FROM
        tree.treeElement el
            INNER JOIN
        tree.treeElementType elType ON el.elTypeID = elType.elTypeID
    WHERE
        elType.elType = 'end';

-- -----------------------------------------------------
-- View `tree`.`treeOption`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeOption`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeOption` (optionID, treeID, questionID, title, content, `order`, destinationID, destinationType, deleted) AS
    SELECT
        el.elID, el.treeID, question.elID, el.elTitle, el.elContent, elOrder.elOrder, destination.elIDDestination, destinationType.elType, el.elDeleted
    FROM
        tree.treeElement el
            INNER JOIN
        tree.treeElementType elType ON el.elTypeID = elType.elTypeID
            INNER JOIN
        tree.treeElementOrder elOrder ON el.elID = elOrder.elID
            INNER JOIN
        tree.treeElementContainer question ON el.elID = question.elIDChild
            LEFT JOIN
        tree.treeElementDestination destination ON el.elID = destination.elID
            LEFT JOIN
        tree.treeElement destinationEl ON destinationEl.elID = destination.elIDDestination
            LEFT JOIN
        tree.treeElementType destinationType ON destinationType.elTypeID = destinationEl.elTypeID
    WHERE
        elType.elType = 'option';

-- -----------------------------------------------------
-- View `tree`.`treeGroup`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeGroup`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeGroup` (groupID, treeID, title, content, `order`, deleted) AS
    SELECT
        el.elID, el.treeID, el.elTitle, el.elContent, elOrder.elOrder, el.elDeleted
    FROM
        tree.treeElement el
            INNER JOIN
        tree.treeElementType elType ON el.elTypeID = elType.elTypeID
            INNER JOIN
        tree.treeElementOrder elOrder ON el.elID = elOrder.elID
    WHERE
        elType.elType = 'group';

-- -----------------------------------------------------
-- View `tree`.`treeStart`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeStart`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeStart` (startID, treeID, title, content, destinationID, deleted) AS
    SELECT
        el.elID, el.treeID, el.elTitle, el.elContent, destination.elIDDestination, el.elDeleted
    FROM
        tree.treeElement el
    INNER JOIN
        tree.treeElementType elType ON el.elTypeID = elType.elTypeID
    LEFT JOIN
        tree.treeElementDestination destination ON el.elID = destination.elID
    WHERE
        elType.elType = 'start';


-- -----------------------------------------------------
-- View `tree`.`treeInteractions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeInteractions`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeInteractions` (interactionID, userID, treeID, interactionType, stateType, interactionCreatedAt) AS
    SELECT
        interaction.interactionID, interaction.userID, interaction.treeID, interactionType.interactionType, stateType.stateType, interaction.interactionCreatedAt
    FROM
        tree.treeInteraction interaction
    INNER JOIN
        tree.treeInteractionType interactionType ON interaction.interactionTypeID = interactionType.interactionTypeID
    INNER JOIN
        tree.treeStateType stateType ON interaction.stateTypeID = stateType.stateTypeID
    ORDER BY
        interaction.interactionID;


-- -----------------------------------------------------
-- View `tree`.`treeInteractionLoad`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeInteractionLoad`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeInteractionLoad` (interactionID, userID, treeID, interactionCreatedAt) AS
    SELECT
        interactions.interactionID, interactions.userID, interactions.treeID, interactions.interactionCreatedAt
    FROM
        tree.treeInteractions interactions
    WHERE
        interactions.interactionType = 'load'
    ORDER BY
        interactions.interactionID;

-- -----------------------------------------------------
-- View `tree`.`treeInteractionReload`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeInteractionReload`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeInteractionReload` (interactionID, userID, treeID, interactionCreatedAt) AS
    SELECT
        interactions.interactionID, interactions.userID, interactions.treeID, interactions.interactionCreatedAt
    FROM
        tree.treeInteractions interactions
    WHERE
        interactions.interactionType = 'reload'
    ORDER BY
        interactions.interactionID;

-- -----------------------------------------------------
-- View `tree`.`treeInteractionOverview`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeInteractionOverview`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeInteractionOverview` (interactionID, userID, treeID, interactionCreatedAt) AS
    SELECT
        interactions.interactionID, interactions.userID, interactions.treeID, interactions.interactionCreatedAt
    FROM
        tree.treeInteractions interactions
    WHERE
        interactions.interactionType = 'overview'
    ORDER BY
        interactions.interactionID;

-- -----------------------------------------------------
-- View `tree`.`treeInteractionStart`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeInteractionStart`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeInteractionStart` (interactionID, userID, treeID, destinationStateType, destinationStateID, interactionCreatedAt) AS
    SELECT
        interactions.interactionID, interactions.userID, interactions.treeID, interactions.stateType, state.elID, interactions.interactionCreatedAt
    FROM
        tree.treeInteractions interactions
    INNER JOIN
        tree.treeState state ON interactions.interactionID = state.interactionID
    WHERE
        interactions.interactionType = 'start'
    ORDER BY
        interactions.interactionID;

-- -----------------------------------------------------
-- View `tree`.`treeInteractionOption` interactions with questions
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeInteractionOption`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeInteractionOption` (interactionID, userID, treeID, optionID, destinationStateType, destinationStateID, interactionCreatedAt) AS
    SELECT
        interactions.interactionID, interactions.userID, interactions.treeID, interactionEl.elID, interactions.stateType, state.elID, interactions.interactionCreatedAt
    FROM
        tree.treeInteractions interactions
    LEFT JOIN
        tree.treeState state ON interactions.interactionID = state.interactionID
    INNER JOIN
        tree.treeInteractionElement interactionEl ON interactions.interactionID = interactionEl.interactionID
    WHERE
        interactions.interactionType = 'option'
    ORDER BY
        interactions.interactionID;

-- -----------------------------------------------------
-- View `tree`.`treeInteractionOverviewOption` interactions with overviews and options
-- -----------------------------------------------------
/*DROP TABLE IF EXISTS `tree`.`treeInteractionOverviewOption`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeInteractionOption` (interactionID, treeID, userID, optionID, stateTypeID, stateType, stateID, `interactionID`) AS*/


-- -----------------------------------------------------
-- View `tree`.`treeInteractionQuestion`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeInteractionQuestion`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeInteractionQuestion` (interactionID, userID, treeID, questionID, interactionCreatedAt) AS
    SELECT
        interactions.interactionID, interactions.userID, interactions.treeID, state.elID, interactions.interactionCreatedAt
    FROM
        tree.treeInteractions interactions
    INNER JOIN
        tree.treeState state ON interactions.interactionID = state.interactionID
    WHERE
        interactions.stateType = 'question'
    ORDER BY
        interactions.interactionID;


-- -----------------------------------------------------
-- View `tree`.`treeInteractionEnd`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeInteractionEnd`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeInteractionEnd` (interactionID, userID, treeID, endID, interactionCreatedAt) AS
    SELECT
        interactions.interactionID, interactions.userID, interactions.treeID, state.elID, interactions.interactionCreatedAt
    FROM
        tree.treeInteractions interactions
    INNER JOIN
        tree.treeState state ON interactions.interactionID = state.interactionID
    WHERE
        interactions.stateType = 'end'
    ORDER BY
        interactions.interactionID;

-- -----------------------------------------------------
-- View `tree`.`treeInteractionHistory`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeInteractionHistory`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeInteractionHistory` (interactionID, userID, treeID, destinationStateType, destinationStateID, interactionCreatedAt) AS
    SELECT
        interactions.interactionID, interactions.userID, interactions.treeID, interactions.stateType, state.elID, interactions.interactionCreatedAt
    FROM
        tree.treeInteractions interactions
    LEFT JOIN
        tree.treeState state ON interactions.interactionID = state.interactionID
    WHERE
        interactions.interactionType = 'history'
    ORDER BY
        interactions.interactionID;


-- -----------------------------------------------------
-- View `tree`.`treeInteractionsMaxDateByUserAndTree`
-- Subquery necessary for treeBounce view
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeInteractionsMaxDateByUserAndTree`;
USE `tree`;
CREATE  OR REPLACE VIEW `treeInteractionsMaxDateByUserAndTree` (userID, treeID, interactionCreatedAt) AS
SELECT
  userID, treeID, MAX(interactionCreatedAt)
 FROM
   tree.treeInteractions
 GROUP BY
   userID, treeID;

-- -----------------------------------------------------
-- View `tree`.`treeStateBounce`
-- This is the state the user left the site at
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tree`.`treeStateBounce`;
CREATE  OR REPLACE VIEW `treeStateBounce` (interactionID, treeID, stateBounced, elID, interactionCreatedAt) AS
SELECT
    interactions.interactionID, interactions.treeID, interactions.stateType, state.elID, interactions.interactionCreatedAt
  FROM
    tree.treeInteractions interactions
  LEFT JOIN
    tree.treeState state ON interactions.interactionID = state.interactionID
  INNER JOIN
    tree.treeInteractionsMaxDateByUserAndTree maxDate
   ON
     (interactions.userID = maxDate.userID
      AND
      interactions.interactionCreatedAt = maxDate.interactionCreatedAt)
  ORDER BY
    interactions.interactionID;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
