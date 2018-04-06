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
		   $errors = [];

	public function __construct() {
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
	 * @param $treeID MIXED (STRING/INT) The treeID you want results for
	 * @param $options ARRAY of defaults you can add to the SQL statement, like an orderby option
	 * @return MIXED ARRAY from the PDO query on success, ??? if error
	 */
	public function fetchAllByTree($view, $treeID, $options = []) {
		$default = array('orderby'=>false);
		$options = array_merge($default, $options);
		// TODO: validate options
		$params = [":treeID" => $treeID];
		$sql = "SELECT * from ".$this->views[$view]." WHERE
				treeID = :treeID";

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
	 * @param $elType The string of the type you want ('question','option', etc)
	 * @param $elID ARRAY of defaults you can add to the SQL statement, like an orderby option
	 * @param $treeID MIXED (STRING/INT) (Optional) The treeID you want results for
	 * @return MIXED Object from the PDO query on success, ??? if error
	 */
	public function fetchOneByView($elType, $elID, $treeID = false) {
		$params = [":${elType}ID" => $elID];
		$ucfirstType = ucfirst($elType);

		$sql = "SELECT * from ".$this->views["tree${ucfirstType}"]." WHERE
				".$elType."ID = :".$elType."ID";

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
     * @param $treeID INT
     * @return ARRAY
     */
    public function getTree($treeID) {
        // Do a select query to see if we get a returned row
        $params = [":treeID" => $treeID];
        $sql = "SELECT * from ".$this->views['tree']." WHERE
                treeID = :treeID";
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
        // Do a select query to see if we get a returned row
        $params = [":treeSlug" => $treeSlug];
        $sql = "SELECT * from ".$this->views['tree']." WHERE
                treeSlug = :treeSlug";
        // return the found tree row
        return $this->fetchOne($sql, $params);
    }

    /**
     * Gets all starts from the database by treeID
     *
     * @param $treeID INT
     * @return ARRAY
     */
    public function getStarts($treeID) {
        return $this->fetchAllByTree('treeStart', $treeID);
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
     * Gets all groups from the database by treeID
     *
     * @param $treeID INT
     * @return ARRAY of Group ARRAYS
     */
    public function getGroups($treeID) {
        return $this->fetchAllByTree('treeGroup', $treeID);
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
     * Gets all questions from the database by treeID
     *
     * @param $treeID INT
     * @param $options ARRAY (Optional) sets orderby paramater in SQL statement
     * @return ARRAY of Question ARRAYS
     */
    public function getQuestions($treeID, $options = []) {
        $default = array('orderby'=>'order');
        $options = array_merge($default, $options);
        return $this->fetchAllByTree('treeQuestion', $treeID, $options);
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
        $default = array('treeID'=>false, 'orderby'=>'order');
        $options = array_merge($default, $options);

        // validate the questionID is an ID
        if(!Utility\isID($questionID)) {
            return false;
        }

        $params = [":questionID" => $questionID];
        $sql = "SELECT * from ".$this->views['treeOption']." WHERE
                questionID = :questionID";

        // if a treeID was passed, append it to the params and sql statement
        if(Utility\isID($options['treeID'])) {
            $params[":treeID"] = $options['treeID'];
            $sql .= " AND treeID = :treeID";
        }

        $sql .= $this->getOrderby($options['orderby']);

        return $this->fetchAll($sql, $params);
    }

    /**
     * Gets an option (question choice)
     *
     * @param $optionID INT
     * @param $options ARRAY (optional) 'questionID', 'treeID'
     * @return ARRAY
     */
    public function getOption($optionID, $options = []) {
        $default = array('treeID'=>false, 'questionID'=>false);
        $options = array_merge($default, $options);

        $params = [":optionID" => $optionID];

        $sql = "SELECT * from ".$this->views["treeOption"]." WHERE
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
     * @return ARRAY of End ARRAYS
     */
    public function getEnds($treeID) {
        return $this->fetchAllByTree('treeEnd', $treeID);
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

}
