<?php

namespace Cme\Element;
use \Cme\Database\Validate as Validate;
use \Cme\Utility as Utility;


/**
 * Interact with Question object
 */
class Question extends Element {
    protected $db        = null,
              $ID        = null,
              $treeID    = null,
              $title     = '',
              $order     = null,
              $owner     = null,
              $options   = [];



    function __construct($db, $question) {
        $this->db = $db;
        if(Utility\isID($question)) {
            return $this->build($question);
        } elseif(is_array($question)) {
            return $this->buildFromArray($question);
        }
    }

    /**
     * Gets a Question from the DB and builds the object
     *
     * @param $question INT/STRING ID of the question you want to build
     * @return MIXED OBJECT of build question ID on success, FALSE on invalid ID
     */
    protected function build($questionID) {
        // validate the question ID
        $validate = new Validate();
        //print_r($questionID);
        if($validate->questionID($questionID) !== true) {
            return false;
        }

        $question = $this->db->getQuestion($questionID);
        //var_dump($question);
        // Map the database values to our object
        $questionID = $question['questionID'];
        // set the object values
        $this->ID = $questionID;
        $this->title = $question['title'];
        $this->treeID = $question['treeID'];
        $this->order = $question['order'];

        // set the owner off the tree
        $tree = new Tree($this->db, $this->treeID);
        $this->owner = $tree->getOwner();


        // set the array of IDs for each elem
        $this->options = $this->db->getOptionIDs($questionID);

        return $this;
    }

    /**
     * Builds a question object from an array of attributes
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
        (isset($data['owner'])) ? $this->setOwner($data['owner']) : false;

        return $this;
    }

    public function getOptions() {
        return $this->options;
    }

    protected function create() {
        $question = [];
        // create it off the object
        // map the question object to the question parameters in the DB
        $question['elTitle'] = $this->getTitle();
        $question['elCreatedBy'] = $this->getOwner();
        $question['treeID'] = $this->getTreeID();
        $question['elTypeID'] = $this->db->getElementTypeID('question');

        $result = $this->db->createElement($question);

        // it's hopefully returning the ID of the question it inserted
        if(Utility\isID($result)) {
            $questionID = $result;
            // it'll get put at the end of the order
            // find the total number of questions for this tree
            $tree = new Tree($this->db, $this->getTreeID());
            $order = count($tree->getQuestions());
            $insertOrder = $this->db->insertOrder($questionID, $order);
            if(!Utility\isID($insertOrder)) {
                // oops. Return the errors.
                return $insertOrder;
            }

            // we're good! Build the question again and return it
            return $this->build($questionID);
        }
        // oops. Return the errors.
        return $result;
    }

    protected function update() {
        // map the question object to the database
        $question = [
            'elID'        => $this->getID(),
            'elTitle'     => $this->getTitle(),
            'treeID'      => $this->getTreeID()
        ];

        $result = $this->db->updateElement($question);

        // TODO: Save options (attach an option to a question)?? Or, actually, I don't think we can do that. It needs to be at the option level.

        // update the order of the options
        $this->saveOrder($this->getOptions());

        // rebuild it so we get the fresh copy
        $this->build($this->getID());
        // return the original update result
        return $result;
    }

    /**
     * Deletes a question from the DB
     */
    public function delete() {
        $treeID = $this->getTreeID();
        // delete the options
        foreach($this->getOptions() as $optionID) {
            $delete = $this->db->deleteElement(
                ['elID'=>$optionID, 'treeID' => $treeID]
            );
            if($delete !== true) {
                return false;
            }
        }
        // delete the question
        $delete = $this->db->deleteElement(
            ['elID'=>$this->getID(), 'treeID' => $treeID]
        );
        if($delete !== true) {
            return false;
        }

        // get the tree (shouldn't include the new question)
        $tree = new Tree($this->db, $this->getTreeID());
        // save it so the order updates
        $tree->save();

        return true;
    }

    // TODO: use parent function for array?
    public function array($removeKeys = []) {
        $removeKeys = array_merge($removeKeys, ['treeID']);
        return parent::array($removeKeys);
    }

}
