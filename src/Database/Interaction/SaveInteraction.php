<?php

namespace Cme\Database;
use Cme\Utility as Utility;

/**
 * Add a question to the database
 */
class SaveInteraction extends DB {
    public $DB;

    function __construct($db = false) {
        // allow a database connection to be passed in
        if($db !== false) {
            $this->DB = $db;
        } else {
            $this->DB = new \Cme\Database\DB();
        }
    }

    /**
     *
     * @param $data (ARRAY) needs all the info to be saved
     * @return ARRAY with saved data or Errors
     */
    public function save($data) {

        // decide how to save it...
        return $this->insert($data);
    }

    /* Validates data structure
     * @param $data (ARRAY) needs all the info to be saved
     *    [
     *        'interaction'=> [
     *            'type'=> 'load', // load, reload, start, restart, option, history
     *            'id' => null // null, optionID
     *        ],
     *        'destination' => [
     *            'type'  => 'question', // question, end, overview, intro
     *            'id'    => (INT)
     *        ],
     *        'userID' => '123dsfa1231sdfa'
     *    ]
     *
     * @return true or false
     */
    protected function validate($data) {
        $isValid = false;

        // check if we have all the data we need
        if(!isset($data['interaction'])) {
            $this->errors[] = 'No interaction data.';
        }

        if(!isset($data['interaction']['type'])) {
            $this->errors[] = 'No interaction type.';
        }

        if(!isset($data['interaction']['id'])) {
            $this->errors[] = 'No interaction id.';
        }

        if(!isset($data['destination'])) {
            $this->errors[] = 'No destination data.';
        }

        if(!isset($data['destination']['type'])) {
            $this->errors[] = 'No destination type.';
        }

        if(!isset($data['destination']['id'])) {
            $this->errors[] = 'No destination id.';
        }

        if(!isset($data['userID'])) {
            $this->errors[] = 'No user id.';
        }

        if(!isset($data['treeID'])) {
            $this->errors[] = 'No tree id.';
        }

        if(!isset($data['site']['embedID'])) {
            $this->errors[] = 'No embed id.';
        }

        // if we have any errors, return false. Passes first round of being the correct data structure
        if(!empty($this->errors)) {
            return $isValid;
        }

        // we have all the data, now to validate it
        $treeID = $data['treeID'];
        $userID = $data['userID'];
        $interactionType = $data['interaction']['type'];
        $interactionID = $data['interaction']['id'];
        $destinationType = $data['destination']['type'];
        $destinationID = $data['destination']['id'];
        $embedID = $data['site']['embedID'];

        // open the validator
        $validate = new Validate();
        // check that it's a valid Tree
        if($validate->treeID($treeID) === false) {
            $this->errors[] = 'Invalid treeID.';
            // return here because the next ones will get messed up if this isn't valid
            return false;
        }

        // check that it's a valid Embed ID
        if($validate->embed($embedID, $data) === false) {
            $this->errors[] = 'Invalid embedID.';
        }

        // check that it's a valid interaction type
        if($validate->interactionType($interactionType) === false) {
            $this->errors[] = 'Invalid interaction type.';
		}

        // check that it's a valid destination type
        if($validate->stateType($destinationType) === false) {
            $this->errors[] = 'Invalid destination type.';
		}

        // if it's an option interaction, check that it's a valid optionID
        if($interactionType === 'question' && $validate->elTypeID($interactionType, $interactionID, $treeID) === false) {
            $this->errors[] = 'Invalid interaction id.';
        }

        // if it's a question or end destination, check that it's a valid id for that type
        if(($destinationType === 'question' || $destinationType === 'end') && $validate->elTypeID($destinationType, $destinationID, $treeID) === false) {
            $this->errors[] = 'Invalid destination id.';
        }

        // check that it's a valid userID
        if(Utility\isSlug($userID) === false) {
            $this->errors[] = 'Invalid userID.';
        }

        // if we have don't have any errors, it's valid!
        if(empty($this->errors)) {
            $isValid = true;
        }

        return $isValid;

    }

    /**
    * Inserts a new interaction
    * @param $data (ARRAY) See validate for structure
    * @return (ARRAY)
    */
    protected function insert($data) {
        $response = [];
        // make sure it's valid
        $isValid = $this->validate($data);

        // if validation doesn't pass, return the errors
        if($isValid !== true) {
            return $this->errors;
        }

        $treeID = $data['treeID'];
        $userID = $data['userID'];
        $interactionType = $this->DB->getInteractionType($data['interaction']['type']);
        $interactionID = $data['interaction']['id'];
        $destinationType = $this->DB->getStateType($data['destination']['type']);
        $destinationID = $data['destination']['id'];
        $embedID = $data['site']['embedID'];

        // Get our Parameters ready
        $params = [
                    ':treeID'              => $treeID,
                    ':userID'              => $userID,
                    ':embedID'             => $embedID,
                    ':interactionTypeID'  => $interactionType['interactionTypeID'],
                    ':stateTypeID'        => $destinationType['stateTypeID'],
                  ];
        // write our SQL statement
        $sql = 'INSERT INTO '.$this->DB->tables['treeInteraction'].' (
                                            treeID,
                                            userID,
                                            embedID,
                                            interactionTypeID,
                                            stateTypeID
                                        )
                                        VALUES(
                                            :treeID,
                                            :userID,
                                            :embedID,
                                            :interactionTypeID,
                                            :stateTypeID
                                        )';
        // insert the mc_option into the database
        $stmt = $this->DB->query($sql, $params);

        // success!
        if($stmt !== false) {
            $insertedInteractionID = $this->DB->lastInsertId();

            $response = [
                            'interactionID'   => $insertedInteractionID,
                            'status'           => 'success',
                            'action'           => 'insertInteraction'
                        ];

            // if it's one that has a stateID with it, then let's save that too
            $interactions = ['option', 'history', 'start'];
            if(in_array($interactionType['interactionType'], $interactions) && $destinationType['stateType'] !== 'overview') {
                $this->insertState($insertedInteractionID, $destinationID);
            }

            // if we interacted with an option, save the interactionID to the elment_interactions
            $interactions = ['option'];
            if(in_array($interactionType['interactionType'], $interactions)) {
                $this->insertInteractionElement($insertedInteractionID, $interactionID);
            }
        } else {
            // handle errors
            $this->errors[] = 'Insert interaction failed.';
            $this->errors['status'] = 'error';
        }


        if(!empty($this->errors)) {
            return $this->errors;
        }

        return $response;
    }

    /**
    * Saves a state related to an interactionID. Example:
    * Clicking an option will bring you to a new question state. We want to know
    * what the resulting state (or destination) of this interaction on the option brought someone to.
    * This insertion will allow us to track that.
    *
    * @param $interactionID (STRING/INT) ID from the `tree_interaction` table
    * @param $stateID (STRING/INT) from the elID of the resulting state (usually a questionID)
    * @return (MIXED) false on error, (STRING) of the inserted row on success
    */
    private function insertState($interactionID, $stateID) {
        /**************************************
        **         WARNING!!!!!!             **
        **                                   **
        **   NO VALIDATION OCCURS HERE.      **
        **   ONLY CALL FROM $this->insert()  **
        ***************************************/
        // save the state too
        $params = [
                    ':interactionID'  => $interactionID,
                    ':elID'           => $stateID
                  ];
        // write our SQL statement
        $sql = 'INSERT INTO '.$this->DB->tables['treeState'].' (
                                            interactionID,
                                            elID
                                        )
                                        VALUES(
                                            :interactionID,
                                            :elID
                                        )';
        // insert the mc_option into the database
        $stmt = $this->DB->query($sql, $params);

        if($stmt !== false) {
            // return the inserted ID
            return $this->DB->lastInsertId();
        } else {
            // handle errors
            $this->errors[] = 'Insert state failed.';
            return false;
        }
    }

    /**
    * Saves the element interacted with (like a click) related to an interactionID. Example:
    * Clicking an option will bring you to a new question state. We want to know
    * what element (option) was clicked on. This insertion will allow us to track that.
    *
    * @param $interactionID (STRING/INT) ID from the `tree_interaction` table
    * @param $elID (STRING/INT) of the element interacted with (usually an optionID)
    * @return (MIXED) false on error, (STRING) of the inserted row on success
    */
    private function insertInteractionElement($interactionID, $elID) {
        /**************************************
        **         WARNING!!!!!!             **
        **                                   **
        **   NO VALIDATION OCCURS HERE.      **
        **   ONLY CALL FROM $this->insert()  **
        ***************************************/

        // save the interaction
        $params = [
                    ':interactionID'  => $interactionID,
                    ':elID'           => $elID
                  ];
        // write our SQL statement
        $sql = 'INSERT INTO '.$this->DB->tables['treeInteractionElement'].' (
                                            interactionID,
                                            elID
                                        )
                                        VALUES(
                                            :interactionID,
                                            :elID
                                        )';
        // insert the mc_option into the database
        $stmt = $this->DB->query($sql, $params);

        if($stmt !== false) {
            // return the inserted ID
            return $this->DB->lastInsertId();
        } else {
            // handle errors
            $this->errors[] = 'Insert interaction element failed.';
            return false;
        }
    }

    protected function update($data) {

    }

}
