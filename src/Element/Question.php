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
            throw new \Error('Question does not exist.');
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

        return $this;
    }

    public function setOptions($options = false) {
        $this->options = $this->getEls('option', $options);
        return $this->options;
    }

    public function getOptions() {
        return $this->options;
    }

    protected function create() {
        $question = [];
        // create it off the object
        // map the question object to the question parameters in the DB
        $question['elTitle'] = $this->getTitle();
        $question['treeID'] = $this->getTreeID();
        $question['elTypeID'] = $this->db->getElementTypeID('question');

        $result = $this->db->createElement($question);

        // it's hopefully returning the ID of the question it inserted
        if(Utility\isID($result)) {
            $questionID = $result;
            // it'll get put at the end of the order
            // find the total number of questions for this tree
            $tree = new Tree($this->db, $this->getTreeID());

            /* TODO: Way to set the order when creating the question
            if(isset($question['order']) && $question['order'] <= count($tree->getQuestions()) && 0 <= $question['order'] ) {
                $order = $question['order'];
            } else {
                $order = count($tree->getQuestions());
            }*/

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

        $this->saveOptions();

        // rebuild it so we get the fresh copy
        $this->build($this->getID());
        // return the original update result
        return $result;
    }

    public function saveOptions() {
        $this->updateContainer($this->getID(), $this->getOptions());

        // update the order of the options
        $this->saveOrder();
    }

    public function addOption($option) {
        // validate option
        $validate = new Validate();
        if(!in_array($option->getID(), $this->getOptions()) && $validate->optionID($option->getID())) {
            $this->options[] = $option->getID();
        }
        return;
    }

    /**
     * Deletes a question from the DB
     */
    public function delete() {
        $treeID = $this->getTreeID();
        // delete the options
        foreach($this->getOptions() as $optionID) {
            $option = new Option($this->db, $optionID);
            $option->delete();
        }

        // delete the question
        $delete = $this->db->deleteElement(
            ['elID'=>$this->getID(), 'treeID' => $treeID]
        );
        if($delete !== true) {
            throw new \Error('Could not delete questionID '.$optionID);
        }

        // get the tree (shouldn't include the new question)
        $tree = new Tree($this->db, $this->getTreeID());
        // save it so the order updates
        $tree->updateOrder($tree->getQuestions());

        return true;
    }

    public function saveOrder() {
        // save the order of the options for this question
        return $this->updateOrder($this->getOptions());
    }

    public function array($removeKeys = []) {
        $removeKeys = array_merge($removeKeys, ['treeID']);
        return parent::array($removeKeys);
    }

    public function move($position) {
        return $this->reorder('question', $position);
    }

}
