<?php
namespace Cme\Element;
use Cme\Database\Validate as Validate;
use Cme\Utility as Utility;

/**
 * Interact with Tree object
 */
class Element {
    protected $db        = null,
              $ID        = null,
              $title     = '';


    function __construct($db) {
        $this->db = $db;
    }

    // scaffold
    protected function build($ID) {

        return $this;
    }

    public function getID() {
        return $this->ID;
    }

    public function getTitle() {
        return $this->title;
    }

    public function setTitle($string) {
        if(is_string($string)) {
            $this->title = $string;
        }

        return $this->title;
    }

    public function getContent() {
        return $this->content;
    }

    public function setContent($string) {
        if(is_string($string)) {
            $this->content = $string;
        }

        return $this->content;
    }

    public function getOwner() {
        return $this->owner;
    }

    public function setOwner($userID) {
        if(Utility\validateUserID($userID)) {
            $this->owner = $userID;
        }

        return $this->owner;
    }

    public function setDestination($destinationID, $destinationType = false) {
        $validate = new Validate();

        if($destinationType === false) {
            $whitelist = ['end', 'question'];
            // if no $destinationType was passed, check all possible destination types (question and end)
            foreach($whitelist as $elType) {
                $isValid = $validate->elTypeID($elType, $destinationID);
                if($isValid === true) {
                    // if we have a valid destination ID, set it and break out
                    $destinationType = $elType;
                    break;
                }
            }
        } else {
            if(!$validate->destinationID($destinationID, ['elType'=>$destinationType])) {
                return;
            }
        }

        $this->destinationID = $destinationID;
        $this->destinationType = $destinationType;
    }

    public function getDestinationID() {
        return $this->destinationID;
    }

    public function getDestinationType() {
        return $this->destinationType;
    }

    public function save() {
        if(!Utility\isID($this->getID())) {
            // create it
            return $this->create();
        }

        return $this->update();
    }

    // scaffold
    protected function create() {

    }
    // scaffold
    protected function update() {

    }
    // scaffold
    public function delete() {

    }

    /**
     * Returns the object as an array for JSON usage
     */
    public function array($removeKeys = []) {
        $removeKeys = array_merge($removeKeys, ['db']);
        $return = [];
        // loop the properties to make it into an array
        foreach($this as $property => $val) {
            $return[$property] = $val;
        }
        // unset the DB property, and anything else
        foreach($removeKeys as $key) {
            unset($return[$key]);
        }

        return $return;
    }

    /**
     * Sets allowed tree ID (for things like questions and ends)
     * @param $treeID (INT)
     * @return $this->treeID
     */
    public function setTreeID($treeID) {
        $validate = new Validate();
        if($validate->treeID($treeID)) {
            $this->treeID = $treeID;
        }

        return $this->treeID;
    }

    /**
     * Sets allowed tree ID (for things like questions and ends)
     * @param $treeID (INT)
     * @return $this->treeID
     */
    public function getTreeID() {
        return $this->treeID;
    }

    public function getOrder() {
        return $this->order;
    }

    /**
     * Save reordered elements
     *
     * @param $IDs of element IDs
     */
    protected function updateOrder($IDs) {
        // takes an array of element IDs and saves their current order
        foreach($IDs as $order => $elID) {
            $this->db->updateOrder($elID, $order);
        }
    }

    /**
     * Saves elements to a parentID container
     *
     * @param $childIDs of element IDs
     */
    protected function updateContainer($parentID, $childIDs) {
        // takes an array of element IDs and saves their current order
        foreach($childIDs as $childID) {
            $this->db->updateContainer($parentID, $childID);
        }
    }

    /**
     * Helper for getting element
     *
     */
    public function getEls($elType, $els = false) {
        $dbGetter = 'get'.ucfirst($elType).'IDs';
        if($els === false) {
            return $this->db->$dbGetter($this->getID());
        }

        // if they passed els, make sure every el is in the array from the database
        //use a clone here so we don't actually sort the passed els array
        $elsClone = $els;
        $dbEls = $this->db->$dbGetter($this->getID());
        if(sort($dbEls) == sort($elsClone)) {
            return $els;
        } else {
            throw new \Error('Passed '.$elType.'s do not match '.$elType.'s from database.');
        }
    }

    /**
     * Save the reordered elements
     *
     */
    public function reorder($elType, $position) {
        $whitelist = ['question', 'end', 'option', 'group', 'start'];
        if(!in_array($elType, $whitelist)) {
            throw new \Error('$elType not allowed.');
        }
        // set our dynamic names:
        // ex: getQuestions, getEnds, etc
        $getter = 'get'.ucfirst($elType).'s';
        // ex: setQuestions, getEnds, etc
        $setter = 'set'.ucfirst($elType).'s';
        // ex: new Question, new End, etc
        $objName = '\Cme\Element\\'.ucfirst($elType);
        // if it's an option, the interaction needs to work with the question, otherwise it uses the tree as its parent
        if($elType === 'option') {
            $parentObj = new Question($this->db, $this->getQuestionID());
        } else {
            $parentObj = new Tree($this->db, $this->getTreeID());
        }

        // get all the els
        $els = $parentObj->$getter();
        // move it
        $els = Utility\move($els, $this->getID(), $position);

        // set this el to that position on the parent (tree or question)
        $parentObj->$setter($els);

        // save el order
        $this->updateOrder($els);

        // rebuild the el
        return $this->build($this->getID());
    }
}
