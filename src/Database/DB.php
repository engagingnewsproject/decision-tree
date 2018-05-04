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
           $getColumns,
		   $errors = [];
    protected $user;

    // pass a user to the database to create elements
	public function __construct($user = false) {

        if(!empty($user)) {
            // validate the user
            if(Utility\validateUser($user) !== true) {
                return 'Invalid user.';
            }
            $this->user = $user;
        }
		// Table names for dynamic reference
		$this->tables = [
						 'tree'						=> 'tree',
						 'treeElement'				=> 'treeElement',
						 'treeElementOrder'		=> 'treeElementOrder',
						 'treeElementContainer'	=> 'treeElementContainer',
						 'treeElementDestination'	=> 'treeElementDestination',
						 'treeElementType'		=> 'treeElementType',
						 'treeEmbed'				=> 'treeEmbed',
						 'treeInteraction'			=> 'treeInteraction',
						 'treeInteractionType'	=> 'treeInteractionType',
						 'treeInteractionElement'	=> 'treeInteractionElement',
						 'treeSite'				=> 'treeSite',
						 'treeState'				=> 'treeState',
						 'treeStateType'			=> 'treeStateType',
						];

		$this->views = [
						'tree' 						=> 'treeapi',
						'treeStart'					=> 'treestart',
						'treeGroup'					=> 'treegroup',
						'treeQuestion'				=> 'treequestion',
						'treeOption'				=> 'treeoption',
						'treeEnd'					=> 'treeend',
						'treeStartBounce'			=> 'treestartbounce',
						'treeInteractions'			=> 'treeinteractions',
						'treeInteractionEnd'		=> 'treeinteractionend',
						'treeInteractionHistory'	=> 'treeInteractionHistory',
						'treeInteractionLoad'		=> 'treeinteractionload',
						'treeInteractionOption'		=> 'treeInteractionOption',
						'treeInteractionQuestion'	=> 'treeInteractionQuestion',
						'treeInteractionReload'		=> 'treeInteractionReload',
						'treeInteractionStart'		=> 'treeinteractionstart',
						'treeInteractionsMaxDateByUserAndTree'	=> 'treeinteractionsmaxdatebyuserandtree' // SORRY!
					   ];

        // define columns we want on different getters (that don't return all)
        $this->getColumns = [
            'tree'     => 'treeID, treeSlug, title, owner, createdAt, updatedAt',
            'start' => 'startID, treeID, title, destinationID',
            'group' => 'groupID, treeID, title, content, `order`',
            'question' => 'questionID, treeID, groupID, title, `order`',
            'option' => 'optionID, treeID, questionID, title, `order`, destinationID, destinationType',
            'end' => 'endID, treeID, title, content',
        ];
		// check if a connection already exists
		try {

			// set options for PDO connection
			$options = [
				PDO::ATTR_PERSISTENT => true,
				PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
			];
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
     * Builds out bound parameters in the array by adding a : to the beginning of the array keys
     *
     * @param $params ARRAY
     * @return ARRAY
     */
    public function buildParams($params) {
        $bound = [];

        foreach($params as $key => $val) {
            $bound[$key] = $val;
        }

        return $bound;
    }

    /**
     * Builds out bound update SQL string
     *
     * @param $vals ARRAY
     * @return STRING
     */
    public function buildUpdate($vals) {
        $set = '';

        $i = 1;
        foreach($vals as $key => $val) {
            $set .= "$key=:$key";

            if($i !== count($vals)) {
                // not the last one, so add a comma and space
                $set .= ", ";
                $i++;
            }
        }

        return $set;
    }

    /**
     * Builds out a simple WHERE statement with &
     *
     * @param $vals ARRAY
     * @return STRING
     */
    public function buildWhere($vals) {
        $where = '';

        $i = 1;
        foreach($vals as $key => $val) {
            $where .= "$key=:$key";

            if($i !== count($vals)) {
                // not the last one, so add an AND statement
                $where .= " AND ";
                $i++;
            }
        }

        return $where;
    }

    /**
     * Builds out a comma string of all passed parameters in the params
     *
     * @param $params ARRAY
     * @param $removeColon BOOL flag to remove the : from the beginning of the param keys
     * @return STRING $params[0], $params[1]
     */
    public function paramKeysToString($params, $removeColon = false) {
        $keys = array_keys($params);
        if($removeColon === false) {
            return implode(', ', $keys);
        }

        $keys = array_map(function($str) {
            return ltrim($str, ':');
        }, $keys);

        return implode(', ', $keys);
    }

    /**
	 * Gets all the results from a view based on the tree ID, such as all
	 * questions by tree ID or all interactions by tree ID
	 *
	 * @param $elType The string of the element type you want to get
	 * @param $treeID MIXED (STRING/INT) The treeID you want results for
	 * @param $options ARRAY of defaults you can add to the SQL statement, like an orderby option or which fields you want
	 * @return MIXED ARRAY from the PDO query on success, ??? if error
	 */
	public function fetchAllByTree($elType, $treeID, $options = []) {
        $default = [
            'orderby'=>false,
            'fields' => $this->getColumns[$elType],
            'fetch' => 'all'
        ];

		$options = array_merge($default, $options);
		// TODO: validate options
		$params = [":treeID" => $treeID];
		$sql = "SELECT ".$options['fields']." from ".$this->views['tree'.ucfirst($elType)]." WHERE
				treeID = :treeID
                AND deleted = 0";

		$sql .= $this->getOrderby($options['orderby']);

        if($options['fetch'] === 'column') {
            return $this->fetchAllColumn($sql, $params);
        } else {
            return $this->fetchAll($sql, $params);
        }

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
	 * @param $elType The string of the type you want ('question','option', etc)
	 * @param $elID ARRAY of defaults you can add to the SQL statement, like an orderby option
	 * @param $treeID MIXED (STRING/INT) (Optional) The treeID you want results for
	 * @return MIXED Object from the PDO query on success, ??? if error
	 */
	public function fetchOneByView($elType, $elID, $treeID = false) {
		$params = [":${elType}ID" => $elID];
		$ucfirstType = ucfirst($elType);

		$sql = "SELECT ".$this->getColumns[$elType]." from ".$this->views["tree${ucfirstType}"]." WHERE
				".$elType."ID = :".$elType."ID
                AND deleted = 0";

		// if a treeID was passed, append it to the params and sql statement
		if($treeID !== false) {
			$params[":treeID"] = $treeID;
			$sql .= " AND treeID = :treeID";
		}

		return $this->fetchOne($sql, $params);
	}

	public function fetchOne($sql, $params = []) {
		$stmt = $this->query($sql, $params);
		return $stmt->fetch(PDO::FETCH_ASSOC);
	}

	public function fetchAll($sql, $params = []) {
		$stmt = $this->query($sql, $params);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
	}

    public function fetchAllColumn($sql, $params = []) {
        $stmt = $this->query($sql, $params);
        return $stmt->fetchAll(PDO::FETCH_COLUMN);
    }

	/**
     * Gets all trees from the database
     *
     * @return ARRAY of TREE ARRAYS
     */
    public function getTrees() {
        // Do a select query to see if we get a returned row
        $sql = "SELECT ".$this->getColumns['tree']." from ".$this->views['tree'];
        // return the found tree row
        return $this->fetchAll($sql);
    }

    /**
     * Gets one tree from the database by id or slug, making a guess as to which one is wanted
     *
     * @param $tree MIXED(INT/STRING) for ID or Slug
     * @return ARRAY
     */
    public function getTree($tree) {
        // check if it's a slug instead
        if(Utility\isID($tree)) {
            return $this->getTreeByID($tree);
        } elseif(Utility\isSlug($tree)) {
            return $this->getTreeBySlug($tree);
        } else {
            return [];
        }
    }

    /**
     * Gets one tree from the database by ID
     *
     * @param $treeSlug STRING
     * @return ARRAY
     */
    public function getTreeByID($treeID) {
        $params = [":treeID" => $treeID];

        $sql = "SELECT ".$this->getColumns['tree']." from ".$this->views['tree']."
                WHERE treeID = :treeID";
        // return the found tree row
        return $this->fetchOne($sql, $params);
    }

    /**
     * Gets one tree from the database by slug
     *
     * @param $treeSlug STRING
     * @return ARRAY
     */
    public function getTreeBySlug($treeSlug) {
        $params = [":treeSlug" => $treeSlug];

        $sql = "SELECT ".$this->getColumns['tree']." from ".$this->views['tree']."
                WHERE treeSlug = :treeSlug";
        // return the found tree row
        return $this->fetchOne($sql, $params);
    }

    /**
     * Dynamic insert function to streamline the insert process
     *
     * $insert = ['vals' => ['treeslug'=>'mytree'], 'user' => $user, 'required'=> ['treeSlug', 'treeName'], 'table'=>$this->views['tree']]
     * return MIXED Inserted row on success, ARRAY of errors on fail
     */
    protected function insert($insert) {

        // get the values we'll be inserting
        $vals = $insert['vals'];
        $table = $insert['table'];

        if(isset($insert['required'])) {
            $hasRequired = $this->hasRequired($vals, $insert['required']);

            if($hasRequired !== true) {
                // returns array of the missing fields
                return $hasRequired;
            }
        }

        // build params
        $params = $this->buildParams($vals);

        // dynamic expanding of passed keys and bound params
        $sql = "INSERT INTO ".$table."
                (".implode(', ', array_keys($vals)).")
                VALUES (:".implode(', :', array_keys($params)).")";

        // attempt to create the tree
        $stmt = $this->query($sql, $params);
        // return whatever ID just got inserted
        return $this->lastInsertId();
    }

    /**
     * Dynamic delete function to streamline the delete process
     *
     * $update = [
     *           'vals' => ['treeslug'=>'mytree'],
     *           'user' => $user,
     *           'required'=> ['treeSlug', 'treeName'],
     *           'table'=>$this->views['tree']],
     *           'where' => ['treeID' = $treeID]
     *       ]
     * return MIXED BOOL on success (true), ARRAY of errors on fail
     */
    protected function update($update) {

        // get the values we'll be inserting
        $vals = $update['vals'];
        $table = $update['table'];

        if(isset($update['required'])) {
            $hasRequired = $this->hasRequired($vals, $update['required']);

            if($hasRequired !== true) {
                // returns array of the missing fields
                return $hasRequired;
            }
        }

        // build params on the vals and where statement vals
        $params = array_merge($this->buildParams($vals), $this->buildParams($update['where']));

        // dynamic expanding of passed keys and bound params
        $sql = "UPDATE ".$table."
                SET
                  ".$this->buildUpdate($vals)."
                WHERE
                  ".$this->buildWhere($update['where'])."
                  ";

        // attempt to create the tree
        $stmt = $this->query($sql, $params);

        if($stmt !== false) {
            return true;
        } else {
            return false;
        }
    }

    /**
     * Creates a tree in the DB
     *
     * @param $tree ARRAY Data to create tree with
     * @return ARRAY
     */
    public function createTree($tree) {
        $validate = new Validate();
        // validate the user
        if(Utility\validateUser($this->user) !== true) {
            return 'Invalid user.';
        }

        // see if this tree already exists
        if(isset($tree['treeSlug']) && $validate->treeSlug($tree['treeSlug'])) {
            return 'Tree Slug already in use.';
        }
        // if no tree owner is passed, set it as this user
        if(!isset($tree['treeOwner'])) {
            $tree['treeOwner'] = $this->user['userID'];
        }

        $tree['treeCreatedBy'] = $this->user['userID'];
        $tree['treeUpdatedBy'] = $this->user['userID'];

        return $this->insert([
            'vals'      => $tree,
            'required'  => ['treeSlug', 'treeOwner'],
            'table'     => $this->tables['tree']
        ]);
    }

    /**
     * Updates a tree in the DB
     *
     * @param $tree ARRAY Data to update
     * @return updated tree
     */
    public function updateTree($tree) {
        $treeID = $tree['treeID'];
        // validate the user
        if(Utility\validateUser($this->user) !== true) {
            return 'Invalid user.';
        }

        $validate = new Validate();
        if(!$validate->treeID($treeID)) {
            return 'Invalid tree.';
        }

        // find the tree and make sure the owner owns this tree
        $getTree = $this->getTree($treeID);
        if($getTree['owner'] !== $this->user['userID']) {
            return 'Not tree owner.';
        }
        // unset the tree ID so we don't try updating that.
        unset($tree['treeID']);
        // attempt to create the tree
        return $this->update([
            'vals'      => $tree,
            'required'  => [],
            'table'     => $this->tables['tree'],
            'where'     => ['treeID' => $treeID, 'treeOwner' => $this->user['userID']]
        ]);
    }


    /**
     * Deletes a tree from the DB
     *
     * @param $tree ARRAY Data to create tree with
     * @return ARRAY
     */
    public function deleteTree($tree) {
        $tree['treeDeleted'] = 1;
        return $this->updateTree($tree);
    }


    /**
     * Checks if all required fields are present
     *
     * @param $fields ARRAY of KEY/VALUE pairs
     * @param $required ARRAY of KEYS
     * @return MIXED BOOL/ARRAY True on success, ARRAY on error
     */
    public function hasRequired($fields, $required) {
        $missingFields = [];
        foreach($required as $key) {
            if(!isset($fields[$key])) {
                $missingFields[] = $key. ' is a required field.';
            }
        }

        if(empty($missingFields)) {
            return true;
        }

        return $missingFields;
    }

    /**
     * Gets all starts from the database by treeID
     *
     * @param $treeID INT
     * @param $options ARRAY
     * @return ARRAY
     */
    public function getStarts($treeID, $options = []) {
        return $this->fetchAllByTree('start', $treeID, $options);
    }

    /**
     * Get a start from the database by id
     *
     * @param $startID INT
     * @param $treeID INT (Optional)
     * @return ARRAY
     */
    public function getStart($startID, $treeID = false) {
        return $this->fetchOneByView('start', $startID, $treeID);
    }

    /**
     * Gets all start IDs from the database by treeID
     *
     * @param $treeID INT
     * @return ARRAY of startIDs, order by 'order' by default
     */
    public function getStartIDs($treeID) {
        return $this->getStarts($treeID, ['fields'=>'startID', 'fetch' => 'column']);
    }

    /**
     * Gets all groups from the database by treeID
     *
     * @param $treeID INT
     * @param $options ARRAY
     * @return ARRAY of Group ARRAYS
     */
    public function getGroups($treeID, $options = []) {
        return $this->fetchAllByTree('group', $treeID, $options);
    }

    /**
     * Get a group from the database by groupID
     *
     * @param $groupID INT
     * @param $treeID INT (Optional)
     * @return ARRAY
     */
    public function getGroup($groupID, $treeID = false) {
        return $this->fetchOneByView('group', $groupID, $treeID);
    }

    /**
     * Gets all group IDs from the database by treeID
     *
     * @param $treeID INT
     * @return ARRAY of groupIDs, order by 'order' by default
     */
    public function getGroupIDs($treeID) {
        return $this->getGroups($treeID, ['fields'=>'groupID', 'fetch' => 'column']);
    }

    /**
     * Gets all questions from the database by treeID
     *
     * @param $treeID INT
     * @param $options ARRAY (Optional) sets orderby paramater in SQL statement
     * @return ARRAY of Question ARRAYS
     */
    public function getQuestions($treeID, $options = []) {
        $default = ['orderby'=>'order'];
        $options = array_merge($default, $options);
        return $this->fetchAllByTree('question', $treeID, $options);
    }

    /**
     * Get a question from the database by questionID
     *
     * @param $questionID INT
     * @param $treeID INT (Optional)
     * @return ARRAY
     */
    public function getQuestion($questionID, $treeID = false) {
        return $this->fetchOneByView('question', $questionID, $treeID);
    }

    /**
     * Gets all question IDs from the database by treeID
     *
     * @param $treeID INT
     * @return ARRAY of questionIDs, order by 'order' by default
     */
    public function getQuestionIDs($treeID) {
        return $this->getQuestions($treeID, ['fields'=>'questionID', 'fetch' => 'column']);
    }

    /**
     * Gets all questions from the database by groupID
     *
     * @param $groupID INT
     * @param $treeID INT (optional)
     * @return ARRAY of Question ARRAYS
     */
    public function getQuestionsByGroup($groupID, $treeID = false) {
        $params = [":groupID" => $groupID];
        $sql = "SELECT questionID from ".$this->views['treeQuestion']." WHERE
                groupID = :groupID";

        // if a treeID was passed, append it to the params and sql statement
        if($treeID !== false) {
            $params[":treeID"] = $treeID;
            $sql .= " AND treeID = :treeID";
        }

        $sql .= " ORDER BY `order`";

        $stmt = $this->query($sql, $params);
        return $stmt->fetchAll(PDO::FETCH_COLUMN, 0);
    }

    /**
     * Gets all options (question choices) for a question
     *
     * @param $questionID INT Question ID to get the options of
     * @param $options ARRAY (optional)
     * @return ARRAY of optionIDs
     */
    public function getOptions($questionID, $options = []) {
        $default = [
                    'treeID'=>false,
                    'orderby'=>'order',
                    'fields' => $this->getColumns['option'],
                    'fetch' => 'all'
                ];

        $options = array_merge($default, $options);

        // validate the questionID is an ID
        if(!Utility\isID($questionID)) {
            return false;
        }

        $params = [":questionID" => $questionID];
        $sql = "SELECT ".$options['fields']." from ".$this->views['treeOption']." WHERE
                questionID = :questionID";

        // if a treeID was passed, append it to the params and sql statement
        if(Utility\isID($options['treeID'])) {
            $params[":treeID"] = $options['treeID'];
            $sql .= " AND treeID = :treeID";
        }

        $sql .= $this->getOrderby($options['orderby']);

        if($options['fetch'] === 'column') {
            return $this->fetchAllColumn($sql, $params);
        } else {
            return $this->fetchAll($sql, $params);
        }
    }

    /**
     * Gets all option IDs from the database by treeID
     *
     * @param $questionID INT
     * @return ARRAY of optionIDs, order by 'order' by default
     */
    public function getOptionIDs($questionID) {
        return $this->getOptions($questionID, ['fields'=>'optionID', 'fetch' => 'column']);
    }

    /**
     * Gets an option (question choice)
     *
     * @param $optionID INT
     * @param $options ARRAY (optional) 'questionID', 'treeID'
     * @return ARRAY
     */
    public function getOption($optionID, $options = []) {
        $default = ['treeID'=>false, 'questionID'=>false];
        $options = array_merge($default, $options);

        $params = [":optionID" => $optionID];

        $sql = "SELECT ".$this->getColumns['option']." from ".$this->views["treeOption"]." WHERE
                optionID = :optionID";

        // if a treeID was passed, append it to the params and sql statement
        if( Utility\isID($options['treeID']) ) {
            $params[":treeID"] = $options['treeID'];
            $sql .= " AND treeID = :treeID";
        }

        if( Utility\isID($options['questionID']) ) {
            $params[":questionID"] = $options['questionID'];
            $sql .= " AND questionID = :questionID";
        }

        return $this->fetchOne($sql, $params);
    }

    /**
     * Gets all ends from the database by treeID
     *
     * @param $treeID INT
     * @param $options ARRAY (Optional) sets orderby paramater in SQL statement
     * @return ARRAY of End ARRAYS
     */
    public function getEnds($treeID, $options = []) {
        return $this->fetchAllByTree('end', $treeID, $options);
    }

    /**
     * Gets an end from the database by endID
     *
     * @param $endID INT
     * @param $treeID INT (optional)
     * @return ARRAY
     */
    public function getEnd($endID, $treeID = false) {
        return $this->fetchOneByView('end', $endID, $treeID);
    }

    /**
     * Gets all end IDs from the database by treeID
     *
     * @param $treeID INT
     * @return ARRAY of EndIDs, order by 'order' by default
     */
    public function getEndIDs($treeID) {
        return $this->getEnds($treeID, ['fields'=>'endID', 'fetch' => 'column']);
    }

    /**
     * Gets all possible el types from database
     *
     * @return ARRAY of ARRAYS
     */
    public function getElementTypes() {
        // Do a select query to see if we get a returned row
        $sql = "SELECT * from ".$this->tables['treeElementType'];
        // return the found el types
        return $this->fetchAll($sql);
    }

    /**
     * Gets an el type from database
     *
     * @param $elType STRING
     * @return ARRAY Row of desired eleemnt
     */
    public function getElementType($elType) {
        $params = [':elType' => $elType];
        // Do a select query to see if we get a returned row
        $sql = "SELECT * from ".$this->tables['treeElementType']."
                WHERE elType = :elType";
        // return the found el types
        return $this->fetchOne($sql, $params);
    }

    /**
     * Gets an el type from database
     *
     * @param $elType STRING
     * @return ID of desired element
     */
    public function getElementTypeID($elType) {
        $elType = $this->getElementType($elType);
        if(isset($elType['elTypeID'])) {
            return $elType['elTypeID'];
        } else {
            return $elType;
        }
    }

    /**
     * Gets all possible interaction types from database
     *
     * @return ARRAY of ARRAYS
     */
    public function getInteractionTypes() {
        // Do a select query to see if we get a returned row
        $sql = "SELECT * from ".$this->tables['treeInteractionType'];
        // return the found interaction types
        return $this->fetchAll($sql);
    }

    /**
     * Gets an interaction type from database
     *
     * @param $interactionType MIXED (INT/STRING)
     * @return ARRAY
     */
    public function getInteractionType($interactionType) {
        if(Utility\isID($interactionType)) {
            return $this->getInteractionTypeByID($interactionType);
        } else {
            return $this->getInteractionTypeBySlug($interactionType);
        }
    }

    /**
     * Gets an interaction type from database by ID
     *
     * @param $interactionTypeID MIXED (INT/STRING)
     * @return ARRAY
     */
    public function getInteractionTypeByID($interactionTypeID) {
        // Do a select query to see if we get a returned row
        $params = [":interactionTypeID" => $interactionTypeID];
        $sql = "SELECT * from ".$this->tables['treeInteractionType']." WHERE
                interactionTypeID = :interactionTypeID";
        // return the found interaction type row
        return $this->fetchOne($sql, $params);
    }

    /**
     * Gets an interaction type from database by slug
     *
     * @param $interactionType (STRING)
     * @return ARRAY
     */
    public function getInteractionTypeBySlug($interactionType) {
        // Do a select query to see if we get a returned row
        $params = [":interactionType" => $interactionType];
        $sql = "SELECT * from ".$this->tables['treeInteractionType']." WHERE
                interactionType = :interactionType";
        // return the found interaction type row
        return $this->fetchOne($sql, $params);
    }

    /**
     * Gets all possible state types from database
     *
     * @return ARRAY
     */
    public function getStateTypes() {
        // Do a select query to see if we get a returned row
        $sql = "SELECT * from ".$this->tables['treeStateType'];
        // return the found state types
        return $this->fetchAll($sql);
    }

    /**
     * Gets a state type from database
     *
     * @param $stateType MIXED (INT/STRING)
     * @return ARRAY
     */
    public function getStateType($stateType) {
        if(Utility\isID($stateType)) {
            return $this->getStateTypeByID($stateType);
        } else {
            return $this->getStateTypeBySlug($stateType);
        }
    }

    /**
     * Gets a state type from database by ID
     *
     * @param $stateTypeID MIXED (INT/STRING)
     * @return ARRAY
     */
    public function getStateTypeByID($stateTypeID) {
        // Do a select query to see if we get a returned row
        $params = [":stateTypeID" => $stateTypeID];
        $sql = "SELECT * from ".$this->tables['treeStateType']." WHERE
                stateTypeID = :stateTypeID";
        // return the found state type row
        return $this->fetchOne($sql, $params);
    }

    /**
     * Gets a state type from database by slug
     *
     * @param $stateType (STRING)
     * @return ARRAY
     */
    public function getStateTypeBySlug($stateType) {
        // Do a select query to see if we get a returned row
        $params = [":stateType" => $stateType];
        $sql = "SELECT * from ".$this->tables['treeStateType']." WHERE
                stateType = :stateType";
        // return the found interaction type row
        return $this->fetchOne($sql, $params);
    }

    public function getSite($site) {
        if(Utility\isID($site)) {
            return $this->getSiteByID($site);
        } else {
            return $this->getSiteByHost($site);
        }
    }

    public function getSiteByID($siteID) {
        // Do a select query to see if we get a returned row
        $params = [":siteID" => $siteID];
        $sql = "SELECT * from ".$this->tables['treeSite']." WHERE
                siteID = :siteID";
        // return the found state type row
        return $this->fetchOne($sql, $params);
    }

    public function getSiteByHost($siteHost) {
        // Do a select query to see if we get a returned row
        $params = [":siteHost" => $siteHost];
        $sql = "SELECT * from ".$this->tables['treeSite']." WHERE
                siteHost = :siteHost";
        // return the found interaction type row
        return $this->fetchOne($sql, $params);
    }

    public function getEmbedsBySite($siteID) {
        $params = [":siteID" => $siteID];
        $sql = "SELECT * from ".$this->tables['treeEmbed']." WHERE
                siteID = :siteID";
        // return the found state type row
        return $this->fetchAll($sql, $params);
    }

    public function getEmbed($embed, $options = []) {
        if(Utility\isID($embed)) {
            return $this->getEmbedByID($embed, $options);
        } else {
            return $this->getEmbedByPath($embed, $options);
        }
    }

    public function getEmbedByID($embedID, $options = []) {
        // Do a select query to see if we get a returned row
        $params = [":embedID" => $embedID];
        $sql = "SELECT * from ".$this->tables['treeEmbed']." WHERE
                embedID = :embedID";

        // if a treeID was passed, append it to the params and sql statement
        if(isset($options['treeID']) && Utility\isID($options['treeID'])) {
            $params[":treeID"] = $options['treeID'];
            $sql .= " AND treeID = :treeID";
        }

        // if a siteID was passed, append it to the params and sql statement
        if(isset($options['siteID']) && Utility\isID($options['siteID'])) {
            $params[":siteID"] = $options['siteID'];
            $sql .= " AND siteID = :siteID";
        }
        // return the found state type row
        return $this->fetchOne($sql, $params);
    }

    public function getEmbedByPath($embedPath, $options = []) {
        // Do a select query to see if we get a returned row
        $params = [
                    ":embedPath" => $embedPath,
                  ];
        $sql = "SELECT * from ".$this->tables['treeEmbed']." WHERE
                embedPath = :embedPath";

        // if a treeID was passed, append it to the params and sql statement
        if(isset($options['treeID']) && Utility\isID($options['treeID'])) {
            $params[":treeID"] = $options['treeID'];
            $sql .= " AND treeID = :treeID";
        }

        // if a treeID was passed, append it to the params and sql statement
        if(isset($options['siteID']) && Utility\isID($options['siteID'])) {
            $params[":siteID"] = $options['siteID'];
            $sql .= " AND siteID = :siteID";
        }
        // return the found interaction type row
        return $this->fetchOne($sql, $params);
    }

    public function getElement($elID) {

        // Do a select query to see if we get a returned row
        $params = [":elID" => $elID];
        $sql = "SELECT * from ".$this->tables['treeElement']." WHERE
                elID = :elID";
        // return the found element type row
        return $this->fetchOne($sql, $params);
    }

    public function createElement($el) {
        // validate the user
        if(Utility\validateUser($this->user) !== true) {
            return 'Invalid user.';
        }
        $validate = new Validate();
        // check that the tree ID is a valid Tree ID and owned by this user
        if($validate->treeOwner($el['treeID'], $el['elCreatedBy']) !== true && $this->user['userRole'] !== 'admin') {
            return 'Invalid tree or user does not own tree.';
        }

        $el['elUpdatedBy'] = $el['elCreatedBy'];
        return $this->insert([
            'vals'      => $el,
            'required'  => ['treeID', 'elTypeID', 'elTitle', 'elCreatedBy', 'elUpdatedBy'],
            'table'     => $this->tables['treeElement']
        ]);
    }

    /**
     * Updates an element in the DB
     *
     * @param $element ARRAY Data to update
     * @return updated element
     */
    public function updateElement($el) {
        $elID = $el['elID'];
        // validate the user
        if(Utility\validateUser($this->user) !== true) {
            return 'Invalid user.';
        }

        $validate = new Validate();
        if(!$validate->elID($elID)) {
            return 'Invalid el.';
        }

        if(!isset($el['treeID'])) {
            return 'No treeID.';
        }

        // find the el and make sure the owner owns this el
        $tree = $this->getTree($el['treeID']);
        if($tree['treeID'] !== $el['treeID']) {
            return 'Incorrect treeID.';
        }

        if($tree['owner'] !== $this->user['userID'] && $this->user['userRole'] !== 'admin') {
            return 'Not el owner.';
        }

        // unset the el ID so we don't try updating that.
        unset($el['elID']);
        // attempt to create the el
        return $this->update([
            'vals'      => $el,
            'required'  => [],
            'table'     => $this->tables['treeElement'],
            'where'     => ['elID' => $elID]
        ]);
    }

    /**
     * Deletes an element from the DB
     *
     * @param $tree ARRAY Data to create tree with
     * @return ARRAY
     */
    public function deleteElement($el) {
        $el['elDeleted'] = 1;
        return $this->updateElement($el);
    }

    /**
     * Inserts the order of an element
     *
     * @param $elID ID
     * @param $order
     * @return
     */
    public function insertOrder($elID, $elOrder) {
        // validate the user
        if(Utility\validateUser($this->user) !== true) {
            return 'Invalid user.';
        }

        // find the element and make sure the owner owns this element
        $el = $this->getElement($elID);

        if($el['elCreatedBy'] !== $this->user['userID'] && $this->user['userRole'] !== 'admin') {
            return 'Not element owner.';
        }

        return $this->insert([
            'vals'      => [
                            'elID' => $elID,
                            'elOrder' => $elOrder
            ],
            'required'  => ['elID', 'elOrder'],
            'table'     => $this->tables['treeElementOrder']
        ]);
    }


    /**
     * Updates the order of an element
     *
     * @param $elID ID
     * @param $order
     * @return
     */
    public function updateOrder($elID, $elOrder) {
        // validate the user
        if(Utility\validateUser($this->user) !== true) {
            return 'Invalid user.';
        }

        // find the element and make sure the owner owns this element
        $el = $this->getElement($elID);

        if($el['elCreatedBy'] !== $this->user['userID']) {
            return 'Not element owner.';
        }

        return $this->update([
            'vals'      => ['elOrder' => $elOrder],
            'required'  => ['elOrder'],
            'table'     => $this->tables['treeElementOrder'],
            'where'     => ['elID' => $elID]
        ]);
    }

}
