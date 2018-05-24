<?php

namespace Cme\Element;
use \Cme\Database\Validate as Validate;
use \Cme\Utility as Utility;


/**
 * Interact with Question object
 */
class Group extends Element {
    protected $db,
              $ID,
              $treeID,
              $title = '',
              $content = '',
              $order,
              $questions = [];



    function __construct($db, $group) {
        $this->db = $db;
        if(Utility\isID($group)) {
            return $this->build($group);
        } elseif(is_array($group)) {
            return $this->buildFromArray($group);
        }
    }

    /**
     * Gets a Question from the DB and builds the object
     *
     * @param $group INT/STRING ID of the group you want to build
     * @return MIXED OBJECT of build group ID on success, FALSE on invalid ID
     */
    protected function build($groupID) {
        // validate the group ID
        $validate = new Validate();
        //print_r($groupID);
        if($validate->groupID($groupID) !== true) {
            return false;
        }

        $group = $this->db->getGroup($groupID);
        // Map the database values to our object
        $groupID = $group['groupID'];
        // set the object values
        $this->ID = $groupID;
        $this->setTreeID($group['treeID']);
        $this->setContent($group['content']);
        $this->setTitle($group['title']);
        $this->order = $group['order'];

        // set the array of IDs for each elem
        $this->setQuestions($this->db->getQuestionsByGroup($groupID));

        return $this;
    }

    /**
     * Builds a group object from an array of attributes
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
        (isset($data['content'])) ? $this->setContent($data['content']) : false;

        return $this;
    }

    public function setQuestions($questionIDs) {
        // wipe the questions array
        $this->questions = [];
        foreach($questionIDs as $questionID) {
            $this->addQuestion($questionID);
        }

    }

    public function getQuestions() {
        return $this->questions;
    }


    protected function create() {
        // create it off the object
        // map the question object to the question parameters in the DB
        $group = [
          'treeID'    => $this->getTreeID(),
          'elTypeID'  => $this->db->getElementTypeID('group'),
          'elTitle'   => $this->getTitle(),
          'elContent' => $this->getContent()
        ];

        $result = $this->db->createElement($group);

        // it's hopefully returning the ID of the group it inserted
        if(Utility\isID($result)) {
            $groupID = $result;
            // set the ID
            $this->ID = $groupID;

            // it'll get put at the end of the order
            // find the total number of groups for this tree
            $tree = new Tree($this->db, $this->getTreeID());

            $order = count($tree->getGroups());
            $insertOrder = $this->db->insertOrder($groupID, $order);

            if(!Utility\isID($insertOrder)) {
                // oops. Return the errors.
                return $insertOrder;
            }
            // save the questions passed (if any)
            $this->saveQuestions();

            // we're good! Build the group again and return it
            return $this->build($groupID);
        }
        // oops. Return the errors.
        return $result;
    }

    protected function update() {
        $result = false;
        // get this Question from the DB so we can figure out what got updated.
        $original = new Group($this->db, $this->getID());

        // map the question object to the database
        $group = [
            'elID'        => $this->getID(),
            'elTitle'     => $this->getTitle(),
            'treeID'      => $this->getTreeID(),
            'elContent'      => $this->getContent()
        ];

        // the only thing that we allow to change here is the Title and Content
        if($original->getTitle() !== $this->getTitle() || $original->getContent() !== $this->getContent()) {
            $result = $this->db->updateElement($group);
        }

        // save the questions. This function will only update what needs updated, so no need to check against original here
        $this->saveQuestions();

        // rebuild it so we get the fresh copy
        $this->rebuild();

        // return the original update result
        return $result;
    }

    public function saveQuestions() {
        // get all questions that are in this container from the database
        $originalQuestions = $this->db->getQuestionsByGroup($this->getID());

        // delete the container of any questions that are no longer in this group
        foreach($originalQuestions as $questionID) {
          // check if it's no longer in the group
          if(!in_array($questionID, $this->getQuestions())) {
              // delete it!
              $this->db->deleteContainer($this->getID(), $questionID);
          }
        }

        // Insert any questions that were not in the original group that now are in the group
        foreach($this->getQuestions() as $questionID) {
            if(!in_array($questionID, $originalQuestions)) {
                $this->db->insertContainer($this->getID(), $questionID);
            }
        }
    }

    public function addQuestion($question) {
        $questionID = (is_object($question) ? $question->getID() : $question);
        // validate option
        $validate = new Validate();
        if(!in_array($questionID, $this->getQuestions()) && $validate->questionID($questionID)) {
            $this->questions[] = $questionID;
        }
        return $this->questions;
    }

    public function removeQuestion($question) {
        $questionID = (is_object($question) ? $question->getID() : $question);
        // validate option
        $validate = new Validate();

        if(in_array($questionID, $this->questions)) {
            foreach($this->questions as $key => $val) {
              // see if we found the right one
              if($val == $questionID) {
                unset($this->questions[$key]);
                break;
              }
            }
        }
        return $this->questions;
    }

    /**
     * Deletes a group from the DB
     */
    public function delete() {
        $treeID = $this->getTreeID();

        // delete the group
        $delete = $this->db->deleteElement(
            ['elID'=>$this->getID(), 'treeID' => $treeID]
        );
        if($delete !== true) {
            throw new \Error('Could not delete groupID '.$this->getID());
        }

        // get the tree (shouldn't include the deleted group)
        $tree = new Tree($this->db, $this->getTreeID());
        // save it so the order updates
        $tree->updateOrder($tree->getGroups());

        return true;
    }

    public function array($removeKeys = []) {
        $removeKeys = array_merge($removeKeys, ['treeID']);
        return parent::array($removeKeys);
    }

    public function move($position) {
        return $this->reorder('group', $position);
    }

}
