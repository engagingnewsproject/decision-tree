<?php

/**
* Extremely bare wrapper based on
* http://codereview.stackexchange.com/questions/52414/my-simple-pdo-wrapper-class
* & http://stackoverflow.com/questions/20664450/is-a-pdo-wrapper-really-overkill
* to make opening PDO connections and preparing, binding, and executing connections
* faster.
*
* @since 0.0.1
* @author jones.jeremydavid@gmail.com
**/


namespace Cme\Database;
use Cme\Utility as Utility;
use PDO;

class DB extends PDO {
	public $tables,
		   $views,
		   $errors = array();

	public function __construct() {
		// Table names for dynamic reference
		$this->tables = [
						 'tree'						=> 'tree',
						 'tree_element'				=> 'tree_element',
						 'tree_element_order'		=> 'tree_element_order',
						 'tree_element_container'	=> 'tree_element_container',
						 'tree_element_destination'	=> 'tree_element_destination',
						 'tree_element_type'		=> 'tree_element_type',
						 'tree_embed'				=> 'tree_embed',
						 'tree_interaction'			=> 'tree_interaction',
						 'tree_interaction_type'	=> 'tree_interaction_type',
						 'tree_interaction_element'	=> 'tree_interaction_element',
						 'tree_site'				=> 'tree_site',
						 'tree_state'				=> 'tree_state',
						 'tree_state_type'			=> 'tree_state_type',
						];

		$this->views = [
						'tree' 						=> 'tree_api',
						'tree_start'				=> 'tree_start',
						'tree_group'				=> 'tree_group',
						'tree_question'				=> 'tree_question',
						'tree_option'				=> 'tree_option',
						'tree_end'					=> 'tree_end',
						'tree_start_bounce'			=> 'tree_start_bounce',
						'tree_interactions'			=> 'tree_interactions',
						'tree_interaction_end'		=> 'tree_interaction_end',
						'tree_interaction_history'	=> 'tree_interaction_history',
						'tree_interaction_load'		=> 'tree_interaction_load',
						'tree_interaction_option'	=> 'tree_interaction_option',
						'tree_interaction_question'	=> 'tree_interaction_question',
						'tree_interaction_reload'	=> 'tree_interaction_reload',
						'tree_interaction_start'	=> 'tree_interaction_start',
						'tree_interactions_max_date_by_user_and_tree'	=> 'tree_interactions_max_date_by_user_and_tree' // SORRY!
					   ];
		// check if a connection already exists
		try {

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

	/**
	 * Execute a query from PDO and binds the parameters.
	 * All PDO statements should run through this.
	 *
	 * @param $sql STRING of the SQL statement you want to run
	 * @param $params ARRAY of the parameters you want to use on the PDO statement
	 * @return MIXED the results from our PDO query
	 */
	public function query($sql, $params = null) {
		$stmt = $this->prepare($sql);
        $stmt->execute($params);
        return $stmt;
    }

    /**
	 * Gets all the results from a view based on the tree ID, such as all
	 * questions by tree ID or all interactions by tree ID
	 *
	 * @param $view The string of the view you want to use for the query
	 * @param $tree_id MIXED (STRING/INT) The tree_id you want results for
	 * @param $options ARRAY of defaults you can add to the SQL statement, like an orderby option
	 * @return MIXED ARRAY from the PDO query on success, ??? if error
	 */
	public function fetch_all_by_tree($view, $tree_id, $options = array()) {
		$default_options = array('orderby'=>false);
		$options = array_merge($default_options, $options);
		// TODO: validate options
		$params = [":tree_id" => $tree_id];
		$sql = "SELECT * from ".$this->views[$view]." WHERE
				tree_id = :tree_id";

		$sql .= $this->get_orderby($options['orderby']);

		return $this->fetch_all($sql, $params);
	}

	/**
	 * Gets one row from a view based on the element type and element id
	 *
	 * @param $el_type The string of the type you want ('question','option', etc)
	 * @param $el_id ARRAY of defaults you can add to the SQL statement, like an orderby option
	 * @param $tree_id MIXED (STRING/INT) (Optional) The tree_id you want results for
	 * @return MIXED Object from the PDO query on success, ??? if error
	 */
	public function fetch_one_by_view($el_type, $el_id, $tree_id = false) {
		$params = [":${el_type}_id" => $el_id];

		$sql = "SELECT * from ".$this->views["tree_${el_type}"]." WHERE
				".$el_type."_id = :".$el_type."_id";

		// if a tree_id was passed, append it to the params and sql statement
		if($tree_id !== false) {
			$params[":tree_id"] = $tree_id;
			$sql .= " AND tree_id = :tree_id";
		}

		return $this->fetch_one($sql, $params);
	}

	public function fetch_one($sql, $params = array()) {
		$stmt = $this->query($sql, $params);
		return $stmt->fetch(PDO::FETCH_ASSOC);
	}

	public function fetch_all($sql, $params = array()) {
		$stmt = $this->query($sql, $params);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
	}

}
