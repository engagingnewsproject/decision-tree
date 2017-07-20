<?php
/**
* Extremely bare wrapper based on
* http://codereview.stackexchange.com/questions/52414/my-simple-pdo-wrapper-class
* & http://stackoverflow.com/questions/20664450/is-a-pdo-wrapper-really-overkill
* to make opening PDO connections and preparing, binding, and executing connections
* faster.
*
**/
namespace Enp\Database;
use PDO;

class DB extends PDO {
	protected $tables,
			  $views;
	public function __construct() {
		// check if a connection already exists
		try {
			// Table names for dynamic reference
			$this->tables = [
				 			 'tree',
							 'tree_element',
							 'tree_element_order',
							 'tree_element_container',
							 'tree_element_destination',
							 'tree_element_type'
						 	];

			$this->views = [
							'tree_column',
							'tree_question',
							'tree_option',
							'tree_end'
						   ];
			// set options for PDO connection
			$options = array(
				PDO::ATTR_PERSISTENT => true,
				PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
			);
			// create the new connection
            parent::__construct('mysql:host='.TREE_DB_HOST.';dbname='.TREE_DB_NAME,
								TREE_DB_USER,
								TREE_DB_PASSWORD,
								$options);
        } catch (Exception $e) {
            $this->errors = $e->getMessage();
        }
	}

	public function query($sql, $params = null) {
		$stmt = $this->prepare($sql);
        $stmt->execute($params);
        return $stmt;
    }

	public function get_tree($id) {
		
	}
}
