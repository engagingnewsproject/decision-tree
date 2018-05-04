<?php

namespace Cme\Element;
use \Cme\Database\Validate as Validate;
use \Cme\Utility as Utility;


/**
 * Interact with Question object
 */
class Start extends Element {
    protected $db,
              $ID,
              $treeID,
              $title,
              $destinationID,
              $destinationType;

    function __construct($db, $start) {
        $this->db = $db;
        if(Utility\isID($start)) {
            return $this->build($start);
        } elseif(is_array($start)) {
            return $this->buildFromArray($start);
        }
    }

    /**
     * Gets a Question from the DB and builds the object
     *
     * @param $start INT/STRING ID of the start you want to build
     * @return MIXED OBJECT of build start ID on success, FALSE on invalid ID
     */
    protected function build($startID) {
        // validate the start ID
        $validate = new Validate();
        //print_r($startID);
        if($validate->startID($startID) !== true) {
            return false;
        }

        $start = $this->db->getStart($startID);
        //var_dump($start);
        // Map the database values to our object
        $startID = $start['startID'];
        // set the object values
        $this->ID = $startID;
        $this->setTreeID($start['treeID']);
        $this->setTitle($start['title']);
        $this->setDestination($start['destinationID'], 'question');

        return $this;
    }

    /**
     * Builds a start object from an array of attributes
     *
     * @param $data ARRAY // 'ID' is not allowed
     * @return OBJECT of Question
     */
    public function buildFromArray($data) {
        // if there's an ID, build that first, then set the rest of the vars
        if(isset($data['ID']) && Utility\isID($data['ID'])) {
            $this->build($data['ID']);
        }

        (isset($data['treeID'])) ? $this->setTreeID($data['treeID']) : false;
        (isset($data['title'])) ? $this->setTitle($data['title']) : false;

        return $this;
    }

    public function array($removeKeys = []) {
        $removeKeys = array_merge($removeKeys, ['treeID']);
        return parent::array($removeKeys);
    }

}
