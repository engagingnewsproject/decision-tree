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

    public function getOwner() {
        return $this->owner;
    }

    public function setOwner($userID) {
        if(Utility\validateUserID($userID)) {
            $this->owner = $userID;
        }

        return $this->owner;
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
     * @param $array of element IDs
     */
    public function saveOrder($array) {
        // takes an array of element IDs and saves their current order
        foreach($array as $order => $elID) {
            $this->db->updateOrder($elID, $order);
        }
    }
}
