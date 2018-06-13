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
            throw new \Error('Invalid startID:' .$startID);
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

    protected function create() {
        /*
        // removing need for start to have valid destination when created
        if(!$validate->destinationID($this->getDestinationID())) {
            throw new \Error('Start must have a valid destination (Question ID or End ID). Likely a Question ID...');
        }*/

        // create it off the object
        // map the start object to the start parameters in the DB
        $start = [
          'elTitle'   => $this->getTitle(),
          'treeID'    => $this->getTreeID(),
          'elTypeID'  => $this->db->getElementTypeID('start')
        ];

        $result = $this->db->createElement($start);

        // it's hopefully returning the ID of the start it inserted
        if(Utility\isID($result)) {
            $startID = $result;

            // validation happens within this function
            $this->insertDestination($startID);

            // we're good! Build the start again and return it
            return $this->build($startID);
        }
        // oops. Return the errors.
        return $result;
    }

    protected function update() {
        $result = false;
        // get this start from the DB so we can figure out what got updated.
        $original = new Start($this->db, $this->getID());

        // map the start object to the database
        $start = [
            'elID'        => $this->getID(),
            'treeID'      => $this->getTreeID()
        ];

        // the only thing that we allow to change here is the Title
        if($original->getTitle() !== $this->getTitle()) {
            $start['elTitle'] = $this->getTitle();

            $result = $this->db->updateElement($start);
        }

        // this could insert, update, or delete the destination depending on new value
        $this->updateDestination();

        // rebuild it so we get the fresh copy
        $this->rebuild();
        // return the original update result
        return $result;
    }

    /**
     * Deletes a start from the DB
     */
    public function delete() {
        $treeID = $this->getTreeID();

        // delete the start
        $delete = $this->db->deleteElement(
            ['elID'=>$this->getID(), 'treeID' => $treeID]
        );
        if($delete !== true) {
            throw new \Error('Could not delete startID '.$this->getID());
        }

        return true;
    }

    public function array($removeKeys = []) {
        $removeKeys = array_merge($removeKeys, ['treeID']);
        return parent::array($removeKeys);
    }

}
