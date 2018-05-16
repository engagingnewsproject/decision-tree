<?php

namespace Cme\Element;
use \Cme\Database\Validate as Validate;
use \Cme\Utility as Utility;


/**
 * Interact with Option object
 */
class Option extends Element {
    protected $db,
              $ID,
              $questionID,
              $title,
              $order,
              $destinationID,
              $destinationType;

    function __construct($db, $option) {
        $this->db = $db;
        if(Utility\isID($option)) {
            return $this->build($option);
        } elseif(is_array($option)) {
            return $this->buildFromArray($option);
        }
    }

    /**
     * Gets a Option from the DB and builds the object
     *
     * @param $option INT/STRING ID of the option you want to build
     * @return MIXED OBJECT of build option ID on success, FALSE on invalid ID
     */
    protected function build($optionID) {
        // validate the option ID
        $validate = new Validate();
        //print_r($optionID);
        if($validate->optionID($optionID) !== true) {
            return false;
        }

        $option = $this->db->getOption($optionID);
        //var_dump($option);
        // Map the database values to our object
        $optionID = $option['optionID'];
        // set the object values
        $this->ID = $optionID;
        $this->setQuestionID($option['questionID']);
        $this->setTitle($option['title']);
        $this->setDestination($option['destinationID'], $option['destinationType']);
        $this->order = $option['order'];

        return $this;
    }

    /**
     * Builds a option object from an array of attributes
     *
     * @param $data ARRAY // 'ID' is not allowed
     * @return OBJECT of Option
     */
    public function buildFromArray($data) {
        // if there's an ID, build that first, then set the rest of the vars
        if(isset($data['ID']) && Utility\isID($data['ID'])) {
            $this->build($data['ID']);
        }

        (isset($data['questionID'])) ? $this->setQuestionID($data['questionID']) : false;
        (isset($data['title'])) ? $this->setTitle($data['title']) : false;
        (isset($data['destinationID']) && $data['destinationType']) ? $this->setDestination($data['destinationID'], $data['destinationType']) : false;

        return $this;
    }


    public function setQuestionID($questionID) {
        $validate = new Validate();
        if($validate->questionID($questionID)) {
            $this->questionID = $questionID;
        }

        return $this->questionID;
    }

    public function getQuestionID() {
      return $this->questionID;
    }

    protected function create() {
        $option = [];
        // create it off the object
        // map the option object to the option parameters in the DB
        $option['elTitle'] = $this->getTitle();
        $option['elTypeID'] = $this->db->getElementTypeID('option');

        $question = new Question($this->db, $this->getQuestionID());
        $option['treeID'] = $question->getTreeID();
        if(!Utility\isID($this->getDestinationID())) {
          throw new \Error('Option must have a destination.');
        }



        $result = $this->db->createElement($option);

        // it's hopefully returning the ID of the option it inserted
        if(!Utility\isID($result)) {
            return $result;
        }

        $optionID = $result;

        $order = count($question->getOptions());
        $this->db->insertOrder($optionID, $order);

        // assign it to the question container
        $this->db->insertContainer($this->getQuestionID(), $optionID);

        $this->db->insertDestination($optionID, $this->getDestinationID());

        // we're good! Build the option again and return it
        return $this->build($optionID);
    }

    protected function update() {
        $question = new Question($this->db, $this->getQuestionID());
        // map the question object to the database
        $option = [
            'elID'          => $this->getID(),
            'elTitle'       => $this->getTitle(),
            'treeID'        => $question->getTreeID()
        ];

        $result = $this->db->updateElement($option);
        $question->addOption($this);
        // update the question container
        $question->saveOptions();
        // ORDER gets updated by the Question object
        // update the destination
        $this->db->updateDestination($this->getID(), $this->getDestinationID());
        // rebuild it so we get the fresh copy
        $this->build($this->getID());
        // return the original update result
        return $result;
    }

    public function array($removeKeys = []) {
        $removeKeys = array_merge($removeKeys, ['treeID', 'questionID']);
        return parent::array($removeKeys);
    }

    public function move($position) {
        return $this->reorder('option', $position);
    }

}
