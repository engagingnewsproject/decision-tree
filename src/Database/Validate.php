<?php
/**
* Data validation functions for verifying data
*
* @since 0.0.1
* @author jones.jeremydavid@gmail.com
**/


namespace Cme\Database;
use Cme\Utility as Utility;
use PDO;

class Validate extends DB {
    public function __construct() {
        // create a DB instance
        parent::__construct();
    }

    // Make sure the treeID exists
    public function treeID($treeID) {
        $isValid = false;

        // try to get the tree by id
        $tree = $this->getTree($treeID);
        // see if the treeID exists in the returned results and if that treeID equals the passed treeID
        if(isset($tree['treeID']) && $tree['treeID'] == $treeID) {
            $isValid = true;
        }

        return $isValid;
    }

    // Make sure the id is what it's supposed to be ( ie, that elID 2 is a 'question')
    /**
     * Validates that an ID is an ID of a certain type. IE if you need to know that
     * ID #2 is a question, use this.
     *
     * @param $elType STRING of the element type (ex: question, option, end, etc)
     * @param $elTypeID INT
     * @param $treeID INT (OPTIONAL) strict mode if you want to validate by tree id as well
     * @return BOOLEAN
     */
    public function elTypeID($elType, $elTypeID, $treeID = false) {

        $isValid = false;

        // Query the $elTypeID
        $whitelist = ['question', 'option', 'end', 'start', 'group'];
        if(!in_array($elType, $whitelist)) {
            return false;
        }

        // get the element
        if($elType === 'option') {
            $elData = $this->getOption($elTypeID, ['treeID' => $treeID]);
        } else {
            // dynamically get the element
        $function = 'get'.ucfirst($elType);
            $elData = $this->$function($elTypeID, $treeID);
        }

        if(isset($elData[$elType.'ID']) && (int)$elData[$elType.'ID'] === (int)$elTypeID) {
            $isValid = true;
        }

        return $isValid;
    }

    // check if it's a valid optionID
    public function optionID($optionID, $treeID = false) {
        return $this->elTypeID('option', $optionID, $treeID);
    }

    public function questionID($questionID, $treeID = false) {
        return $this->elTypeID('question', $questionID, $treeID);
    }

    public function groupID($groupID, $treeID = false) {
        return $this->elTypeID('group', $groupID, $treeID);
    }

    public function endID($endID, $treeID = false) {
        return $this->elTypeID('end', $endID, $treeID);
    }

    public function startID($startID, $treeID = false) {
        return $this->elTypeID('start', $startID, $treeID);
    }

    /**
     * Validates that an ID is a valid destination ID by checking if it's
     * a question or end ID
     *
     * @param $id INT
     * @param $options ARRAY (optional) Faster check if these are provided ['elType' => 'question', 'treeID'=>1]
     * @return BOOLEAN
     */
    public function destinationID($id, $options = []) {
        // see if there's a desired type
        $elType = false;
        $treeID = false;
        $whitelist = ['end', 'question'];

        // check for a passed type
        if( isset($options['elType']) && in_array($options['elType'], $whitelist) ) {
            $elType = $options['elType'];
        }

        // check for a passed tree ID
        if( isset($options['treeID']) && Utility\isID($options['treeID'])) {
            $treeID = $options['treeID'];
        }

        // if no $elType was passed, check all possible destination types (question and end)
        if($elType === false) {
            // try to get this destination by both question and end
            foreach($whitelist as $elType) {
                $isValid = $this->elTypeID($elType, $id, $treeID);
                if($isValid === true) {
                    // if we have a valid destination ID, break out and return
                    break;
                }
            }
        } else {
            // get it only by the passed ID
            $isValid = $this->elTypeID($elType, $id, $treeID);
        }

        return $isValid;
    }

    /**
     * Validates interaction type, such as 'load', 'start', 'option', etc
     *
     * @param $interactionType STRING
     * @return BOOLEAN
     */
    public function interactionType($interactionType) {
        $isValid = false;

        // if we can find that interaction type and it matches the passed one, it's valid
        $getInteraction = $this->getInteractionType($interactionType);
        if(isset($getInteraction['interactionType']) && $getInteraction['interactionType'] === $interactionType) {
            $isValid = true;
        }

        return $isValid;
    }

    /**
     * Validates that the stateType is a valid state type
     *
     * @param $stateType STRING
     * @return BOOLEAN
     */
    public function stateType($stateType) {
        $isValid = false;

        // if we can find that state type and it matches the passed one, it's valid
        $getState = $this->getStateType($stateType);
        if(isset($getState['stateType']) && $getState['stateType'] === $stateType) {
            $isValid = true;
        }

        return $isValid;
    }

    /**
     * Validates that the site exists in the database
     *
     * @param $site STRING
     * @return BOOLEAN
     */
    public function site($site) {
        $isValid = false;
        // check if we should compare by ID or host
        if(Utility\isID($site)) {
            $key = 'siteID';
        } else {
            $key = 'siteHost';
        }


        $getSite = $this->getSite($site);
        // check if it's set and it equals the passed value
        if(isset($getSite[$key]) && (string) $getSite[$key] === (string) $site) {
            $isValid = true;
        }

        return $isValid;
    }

    /**
     * Validates that the embed exists in the database
     *
     * @param $embed STRING
     * @param $options ARRAY
     * @return BOOLEAN
     */
    public function embed($embed, $options = []) {
        $isValid = false;
        // check if we should compare by ID or path
        if(Utility\isID($embed)) {
            $key = 'embedID';
        } else {
            $key = 'embedPath';
        }

        $getEmbed = $this->getEmbed($embed, $options);
        // check if it's set and it equals the passed value
        if(isset($getEmbed[$key]) && (string) $getEmbed[$key] === (string) $embed) {
            $isValid = true;
        }

        return $isValid;
    }
}
