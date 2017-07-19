USE `tree`;
/*
-- Query:
-- Date: 2017-07-18 14:01
*/
INSERT INTO `tree` (`tree_id`,`tree_slug`,`tree_content`,`tree_title`,`tree_owner`,`tree_created_by`,`tree_updated_by`) VALUES (1,'citizen','','Are You Eligible to be a US Citizen',1,1,1);

/*
-- Query:
-- Date: 2017-07-18 14:02
*/
INSERT INTO `tree_element_type` (`el_type_id`,`el_type`) VALUES (1,'column');
INSERT INTO `tree_element_type` (`el_type_id`,`el_type`) VALUES (2,'question');
INSERT INTO `tree_element_type` (`el_type_id`,`el_type`) VALUES (3,'option');
INSERT INTO `tree_element_type` (`el_type_id`,`el_type`) VALUES (4,'end');


/*
-- Query:
-- Date: 2017-07-18 14:00
*/
INSERT INTO `tree_element` (`el_id`,`tree_id`,`el_type_id`,`el_title`,`el_content`,`el_created_by`,`el_updated_by`) VALUES (1,1,1,'Main Column','',1,1);
INSERT INTO `tree_element` (`el_id`,`tree_id`,`el_type_id`,`el_title`,`el_content`,`el_created_by`,`el_updated_by`) VALUES (2,1,2,'Are you at least 18 years old?','',1,1);
INSERT INTO `tree_element` (`el_id`,`tree_id`,`el_type_id`,`el_title`,`el_content`,`el_created_by`,`el_updated_by`) VALUES (3,1,3,'Yes','',1,1);
INSERT INTO `tree_element` (`el_id`,`tree_id`,`el_type_id`,`el_title`,`el_content`,`el_created_by`,`el_updated_by`) VALUES (4,1,3,'No','',1,1);
INSERT INTO `tree_element` (`el_id`,`tree_id`,`el_type_id`,`el_title`,`el_content`,`el_created_by`,`el_updated_by`) VALUES (5,1,4,'You are elegible.','You can apply for US Citizenship if you want to.',1,1);
INSERT INTO `tree_element` (`el_id`,`tree_id`,`el_type_id`,`el_title`,`el_content`,`el_created_by`,`el_updated_by`) VALUES (6,1,4,'You are not eligible.','You will get rejected from US Citizenship if you apply right now.',1,1);
INSERT INTO `tree_element` (`el_id`,`tree_id`,`el_type_id`,`el_title`,`el_content`,`el_created_by`,`el_updated_by`) VALUES (7,1,3,'Start Over','Want to go through this decision tree again?',1,1);

/*
-- Query:
-- Date: 2017-07-18 14:01
*/
INSERT INTO `tree_element_order` (`el_order_id`,`el_id`,`el_order`) VALUES (1,3,1);
INSERT INTO `tree_element_order` (`el_order_id`,`el_id`,`el_order`) VALUES (2,4,0);
INSERT INTO `tree_element_order` (`el_order_id`,`el_id`,`el_order`) VALUES (3,7,0);
INSERT INTO `tree_element_order` (`el_order_id`,`el_id`,`el_order`) VALUES (4,1,0);
INSERT INTO `tree_element_order` (`el_order_id`,`el_id`,`el_order`) VALUES (5,2,0);


/*
-- Query:
-- Date: 2017-07-18 14:01
*/
INSERT INTO `tree_element_container` (`el_container_id`,`el_id`,`el_id_child`) VALUES (1,1,2);
INSERT INTO `tree_element_container` (`el_container_id`,`el_id`,`el_id_child`) VALUES (2,2,3);
INSERT INTO `tree_element_container` (`el_container_id`,`el_id`,`el_id_child`) VALUES (3,2,4);

INSERT INTO `tree_element_destination` (`el_destination_id`,`el_id`,`el_id_destination`) VALUES (1,3,5);
INSERT INTO `tree_element_destination` (`el_destination_id`,`el_id`,`el_id_destination`) VALUES (2,4,6);
INSERT INTO `tree_element_destination` (`el_destination_id`,`el_id`,`el_id_destination`) VALUES (3,7,2);
