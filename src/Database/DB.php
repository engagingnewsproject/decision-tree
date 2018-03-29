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
	public function fetchAllByTree($view, $tree_id, $options = array()) {
		$default_options = array('orderby'=>false);
		$options = array_merge($default_options, $options);
		// TODO: validate options
		$params = [":tree_id" => $tree_id];
		$sql = "SELECT * from ".$this->views[$view]." WHERE
				tree_id = :tree_id";

		$sql .= $this->getOrderby($options['orderby']);

		return $this->fetchAll($sql, $params);
	}

	protected function getOrderby($orderby) {
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

	/**
	 * Gets one row from a view based on the element type and element id
	 *
	 * @param $el_type The string of the type you want ('question','option', etc)
	 * @param $el_id ARRAY of defaults you can add to the SQL statement, like an orderby option
	 * @param $tree_id MIXED (STRING/INT) (Optional) The tree_id you want results for
	 * @return MIXED Object from the PDO query on success, ??? if error
	 */
	public function fetchOneByView($el_type, $el_id, $tree_id = false) {
		$params = [":${el_type}_id" => $el_id];

		$sql = "SELECT * from ".$this->views["tree_${el_type}"]." WHERE
				".$el_type."_id = :".$el_type."_id";

		// if a tree_id was passed, append it to the params and sql statement
		if($tree_id !== false) {
			$params[":tree_id"] = $tree_id;
			$sql .= " AND tree_id = :tree_id";
		}

		return $this->fetchOne($sql, $params);
	}

	public function fetchOne($sql, $params = array()) {
		$stmt = $this->query($sql, $params);
		return $stmt->fetch(PDO::FETCH_ASSOC);
	}

	public function fetchAll($sql, $params = array()) {
		$stmt = $this->query($sql, $params);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
	}

	/**
     * Gets all trees from the database
     *
     * @return ARRAY of TREE ARRAYS
     */
    public function getTrees() {
        // Do a select query to see if we get a returned row
        $sql = "SELECT * from ".$this->views['tree'];
        // return the found tree row
        return $this->fetchAll($sql);
    }

    /**
     * Gets one tree from the database by id
     *
     * @param $tree_id INT
     * @return ARRAY/OBJECT of the TREE
     */
    public function getTree($tree_id) {
        // Do a select query to see if we get a returned row
        $params = [":tree_id" => $tree_id];
        $sql = "SELECT * from ".$this->views['tree']." WHERE
                tree_id = :tree_id";
        // return the found tree row
        return $this->fetchOne($sql, $params);
    }

    /**
     * Gets one tree from the database by slug
     *
     * @param $tree_slug STRING
     * @return ARRAY/OBJECT of the TREE
     */
    public function getTreeBySlug($tree_slug) {
        // Do a select query to see if we get a returned row
        $params = [":tree_slug" => $tree_slug];
        $sql = "SELECT * from ".$this->views['tree']." WHERE
                tree_slug = :tree_slug";
        // return the found tree row
        return $this->fetchOne($sql, $params);
    }

    /**
     * Gets all starts from the database by tree_id
     *
     * @param $tree_id INT
     * @return ARRAY
     */
    public function getStarts($tree_id) {
        return $this->fetchAllByTree('tree_start', $tree_id);
    }

    /**
     * Get a start from the database by id
     *
     * @param $start_id INT
     * @param $tree_id INT (Optional)
     * @return ARRAY of TREE ARRAYS
     */
    public function getStart($start_id, $tree_id = false) {
        return $this->fetchOneByView('start', $start_id, $tree_id);
    }

    /**
     * Gets all groups from the database by tree_id
     *
     * @param $tree_id INT
     * @return ARRAY
     */
    public function getGroups($tree_id) {
        return $this->fetchAllByTree('tree_group', $tree_id);
    }

    /**
     * Get a group from the database by group_id
     *
     * @param $group_id INT
     * @param $tree_id INT (Optional)
     * @return ARRAY of TREE ARRAYS
     */
    public function getGroup($group_id, $tree_id = false) {
        return $this->fetchOneByView('group', $group_id, $tree_id);
    }

    /**
     * Gets all questions from the database by tree_id
     *
     * @param $tree_id INT
     * @param $options ARRAY (Optional) sets orderby paramater in SQL statement
     * @return ARRAY
     */
    public function getQuestions($tree_id, $options = array()) {
        $default_options = array('orderby'=>'order');
        $options = array_merge($default_options, $options);
        return $this->fetchAllByTree('tree_question', $tree_id, $options);
    }

    /**
     * Get a question from the database by question_id
     *
     * @param $question_id INT
     * @param $tree_id INT (Optional)
     * @return ARRAY of TREE ARRAYS
     */
    public function getQuestion($question_id, $tree_id = false) {
        return $this->fetchOneByView('question', $question_id, $tree_id);
    }

     /**
     * Gets all questions from the database by group_id
     *
     * @param $group_id INT
     * @param $tree_id INT (optional)
     * @return ARRAY of Question IDs
     */
    public function getQuestionsByGroup($group_id, $tree_id = false) {
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

    public function getOptions($question_id, $options = array()) {
        $default_options = array('tree_id'=>false, 'orderby'=>'order');
        $options = array_merge($default_options, $options);

        // validate the question_id
        $validate = new Validate();
        if($validate->questionID($question_id) === false) {
            return false;
        }

        $params = [":question_id" => $question_id];
        $sql = "SELECT * from ".$this->views['tree_option']." WHERE
                question_id = :question_id";

        // if a tree_id was passed, append it to the params and sql statement
        if(Utility\is_id($options['tree_id'])) {
            $params[":tree_id"] = $options['tree_id'];
            $sql .= " AND tree_id = :tree_id";
        }

        $sql .= $this->getOrderby($options['orderby']);

        return $this->fetchAll($sql, $params);
    }

    public function getOption($option_id, $options = array()) {
        $default_options = array('tree_id'=>false, 'question_id'=>false);
        $options = array_merge($default_options, $options);

        $params = [":option_id" => $option_id];

        $sql = "SELECT * from ".$this->views["tree_option"]." WHERE
                option_id = :option_id";

        // if a tree_id was passed, append it to the params and sql statement
        if( Utility\is_id($options['tree_id']) ) {
            $params[":tree_id"] = $options['tree_id'];
            $sql .= " AND tree_id = :tree_id";
        }

        if( Utility\is_id($options['question_id']) ) {
            $params[":question_id"] = $options['question_id'];
            $sql .= " AND question_id = :question_id";
        }

        return $this->fetchOne($sql, $params);
    }

    public function getEnds($tree_id) {
        return $this->fetchAllByTree('tree_end', $tree_id);
    }

    public function getEnd($end_id, $tree_id = false) {
        return $this->fetchOneByView('end', $end_id, $tree_id);
    }

    public function getInteractionTypes() {
        // Do a select query to see if we get a returned row
        $sql = "SELECT * from ".$this->tables['tree_interaction_type'];
        // return the found interaction types
        return $this->fetchAll($sql);
    }

    public function getInteractionType($interaction_type) {
        if(Utility\is_id($interaction_type)) {
            return $this->getInteractionTypeById($interaction_type);
        } else {
            return $this->getInteractionTypeBySlug($interaction_type);
        }
    }

    public function getInteractionTypeById($interaction_type_id) {
        // Do a select query to see if we get a returned row
        $params = [":interaction_type_id" => $interaction_type_id];
        $sql = "SELECT * from ".$this->tables['tree_interaction_type']." WHERE
                interaction_type_id = :interaction_type_id";
        // return the found interaction type row
        return $this->fetchOne($sql, $params);
    }

    public function getInteractionTypeBySlug($interaction_type) {
        // Do a select query to see if we get a returned row
        $params = [":interaction_type" => $interaction_type];
        $sql = "SELECT * from ".$this->tables['tree_interaction_type']." WHERE
                interaction_type = :interaction_type";
        // return the found interaction type row
        return $this->fetchOne($sql, $params);
    }

    public function getStateTypes() {
        // Do a select query to see if we get a returned row
        $sql = "SELECT * from ".$this->tables['tree_state_type'];
        // return the found state types
        return $this->fetchAll($sql);
    }

    public function getStateType($state_type) {
        if(Utility\is_id($state_type)) {
            return $this->getStateTypeById($state_type);
        } else {
            return $this->getStateTypeBySlug($state_type);
        }
    }

    public function getStateTypeById($state_type_id) {
        // Do a select query to see if we get a returned row
        $params = [":state_type_id" => $state_type_id];
        $sql = "SELECT * from ".$this->tables['tree_state_type']." WHERE
                state_type_id = :state_type_id";
        // return the found state type row
        return $this->fetchOne($sql, $params);
    }

    public function getStateTypeBySlug($state_type) {
        // Do a select query to see if we get a returned row
        $params = [":state_type" => $state_type];
        $sql = "SELECT * from ".$this->tables['tree_state_type']." WHERE
                state_type = :state_type";
        // return the found interaction type row
        return $this->fetchOne($sql, $params);
    }

    public function getSite($site) {
        if(Utility\is_id($site)) {
            return $this->getSiteById($site);
        } else {
            return $this->getSiteByHost($site);
        }
    }

    public function getSiteById($site_id) {
        // Do a select query to see if we get a returned row
        $params = [":site_id" => $site_id];
        $sql = "SELECT * from ".$this->tables['tree_site']." WHERE
                site_id = :site_id";
        // return the found state type row
        return $this->fetchOne($sql, $params);
    }

    public function getSiteByHost($site_host) {
        // Do a select query to see if we get a returned row
        $params = [":site_host" => $site_host];
        $sql = "SELECT * from ".$this->tables['tree_site']." WHERE
                site_host = :site_host";
        // return the found interaction type row
        return $this->fetchOne($sql, $params);
    }

    public function getEmbedsBySite($site_id) {
        $params = [":site_id" => $site_id];
        $sql = "SELECT * from ".$this->tables['tree_embed']." WHERE
                site_id = :site_id";
        // return the found state type row
        return $this->fetchAll($sql, $params);
    }

    public function getEmbed($embed, $options) {
        if(Utility\is_id($embed)) {
            return $this->getEmbedById($embed, $options);
        } else {
            return $this->getEmbedByPath($embed, $options);
        }
    }

    public function getEmbedById($embed_id, $options) {
        // Do a select query to see if we get a returned row
        $params = [":embed_id" => $embed_id];
        $sql = "SELECT * from ".$this->tables['tree_embed']." WHERE
                embed_id = :embed_id";

        // if a tree_id was passed, append it to the params and sql statement
        if(isset($options['tree_id']) && Utility\is_id($options['tree_id'])) {
            $params[":tree_id"] = $options['tree_id'];
            $sql .= " AND tree_id = :tree_id";
        }

        // if a site_id was passed, append it to the params and sql statement
        if(isset($options['site_id']) && Utility\is_id($options['site_id'])) {
            $params[":site_id"] = $options['site_id'];
            $sql .= " AND site_id = :site_id";
        }
        // return the found state type row
        return $this->fetchOne($sql, $params);
    }

    public function getEmbedByPath($embed_path, $options) {
        // Do a select query to see if we get a returned row
        $params = [
                    ":embed_path" => $embed_path,
                  ];
        $sql = "SELECT * from ".$this->tables['tree_embed']." WHERE
                embed_path = :embed_path";

        // if a tree_id was passed, append it to the params and sql statement
        if(isset($options['tree_id']) && Utility\is_id($options['tree_id'])) {
            $params[":tree_id"] = $options['tree_id'];
            $sql .= " AND tree_id = :tree_id";
        }

        // if a tree_id was passed, append it to the params and sql statement
        if(isset($options['site_id']) && Utility\is_id($options['site_id'])) {
            $params[":site_id"] = $options['site_id'];
            $sql .= " AND site_id = :site_id";
        }
        // return the found interaction type row
        return $this->fetchOne($sql, $params);
    }

}
