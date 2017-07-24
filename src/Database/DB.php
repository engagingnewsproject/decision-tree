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


namespace Enp\Database;
use PDO;

class DB extends PDO {
	public $tables,
			  $views;
	public function __construct() {
		// Table names for dynamic reference
		$this->tables = [
						 'tree'=>'tree',
						 'tree_element'=>'tree_element',
						 'tree_element_order'=>'tree_element_order',
						 'tree_element_container'=>'tree_element_container',
						 'tree_element_destination'=>'tree_element_destination',
						 'tree_element_type'=>'tree_element_type'
						];

		$this->views = [
						'tree' 			=> 'tree_api',
						'tree_group'	=> 'tree_group',
						'tree_question'	=> 'tree_question',
						'tree_option'	=> 'tree_option',
						'tree_end'		=> 'tree_end'
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

	public function query($sql, $params = null) {
		$stmt = $this->prepare($sql);
        $stmt->execute($params);
        return $stmt;
    }

	public function fetch_all_by_tree($view, $tree_id) {
		// TODO: validate options
		$params = [":tree_id" => $tree_id];
		$sql = "SELECT * from ".$view." WHERE
				tree_id = :tree_id";

		return $this->fetch_all($sql, $params);
	}

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

	public function get_trees() {
        // Do a select query to see if we get a returned row
        $sql = "SELECT * from ".$this->views['tree'];
        // return the found tree row
        return $this->fetch_one($sql);
	}

	public function get_tree($tree_id) {
		// Do a select query to see if we get a returned row
		$params = [":tree_id" => $tree_id];
		$sql = "SELECT * from ".$this->views['tree']." WHERE
				tree_id = :tree_id";
		// return the found tree row
		return $this->fetch_one($sql, $params);
	}

	public function get_tree_by_slug($tree_slug) {
		// Do a select query to see if we get a returned row
		$params = [":tree_slug" => $tree_slug];
		$sql = "SELECT * from ".$this->views['tree']." WHERE
				tree_slug = :tree_slug";
		// return the found tree row
		return $this->fetch_one($sql, $params);
	}

	public function get_groups($tree_id) {
		return $this->fetch_all_by_tree($this->views['tree_group'], $tree_id);
	}

	public function get_group($group_id, $tree_id = false) {
		return $this->fetch_one_by_view('group', $group_id, $tree_id);
	}

	public function get_questions($tree_id, $orderby = false) {
		return $this->fetch_all_by_tree($this->views['tree_question'], $tree_id);
		$sql .= $this->get_orderby($orderby);
	}

	public function get_question($question_id, $tree_id = false) {
		return $this->fetch_one_by_view('question', $question_id, $tree_id);
	}

	public function get_questions_by_group($group_id, $tree_id = false) {
		$params = [":group_id" => $group_id];
		$sql = "SELECT question_id from ".$this->views['tree_question']." WHERE
				group_id = :group_id";

		// if a tree_id was passed, append it to the params and sql statement
		if($tree_id !== false) {
			$params[":tree_id"] = $tree_id;
			$sql .= " AND tree_id = :tree_id";
		}

		$sql .= " ORDER BY `order`";

		$stmt = $this->query($sql, $params);
		return $stmt->fetchAll(PDO::FETCH_COLUMN, 0);
	}

	public function get_options($question_id, $options) {
		$default_options = array('tree_id'=>false, 'orderby'=>'order');
		$options = array_merge($default_options, $options);

		$params = [":question_id" => $question_id];
		$sql = "SELECT * from ".$this->views['tree_option']." WHERE
				question_id = :question_id";

		// if a tree_id was passed, append it to the params and sql statement
		if(array_key_exists('tree_id', $options) && $options['tree_id'] !== false) {
			$params[":tree_id"] = $tree_id;
			$sql .= " AND tree_id = :tree_id";
		}

		if(array_key_exists('orderby', $options) && $options['orderby'] !== false) {
			$sql .= $this->get_orderby($orderby);
		}

		return $this->fetch_all($sql, $params);
	}

	public function get_option($option_id, $question_id = false, $tree_id = false) {
		$params = [":option_id" => $option_id];

		$sql = "SELECT * from ".$this->views["tree_option"]." WHERE
				option_id = :option_id";

		// if a tree_id was passed, append it to the params and sql statement
		if($tree_id !== false) {
			$params[":tree_id"] = $tree_id;
			$sql .= " AND tree_id = :tree_id";
		}

		if($question_id !== false) {
			$params[":question_id"] = $question_id;
			$sql .= " AND question_id = :question_id";
		}

		return $this->fetch_one($sql, $params);
	}

	public function get_ends($tree_id) {
		return $this->fetch_all_by_tree($this->views['tree_end'], $tree_id);
	}

	public function get_end($end_id, $tree_id = false) {
		return $this->fetch_one_by_view('end', $end_id, $tree_id);
	}

	protected function get_orderby($orderby) {
		if($orderby === 'order') {
			// order by order
			$sql = " ORDER BY `order`";
		} else if(is_string($orderby)) {
			$sql = " ".$orderby;
		} else {
			// do nothing
			$sql = '';
		}
		return $sql;
	}



}
