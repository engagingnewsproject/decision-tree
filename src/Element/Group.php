<?php

namespace Cme\Element;
use \Cme\Database\Validate as Validate;
use \Cme\Utility as Utility;


/**
 * Interact with Question object
 */
class Group extends Element {
    protected $db        = null,
              $ID        = null,
              $treeID    = null,
              $title     = null,
              $content   = null,
              $order     = null,
              $owner     = null,
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
        //var_dump($group);
        // Map the database values to our object
        $groupID = $group['groupID'];
        // set the object values
        $this->ID = $groupID;
        $this->setTreeID($group['treeID']);
        $this->setContent($group['content']);
        $this->setTitle($group['title']);
        $this->order = $group['order'];

        // set the owner off the tree
        $tree = new Tree($this->db, $this->getTreeID());
        $this->setOwner($tree->getOwner());

        // set the array of IDs for each elem
        $this->questions = $this->db->getQuestionsByGroup($groupID);

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
        (isset($data['owner'])) ? $this->setOwner($data['owner']) : false;

        return $this;
    }

    public function getQuestions() {
        return $this->questions;
    }

    public function array($removeKeys = []) {
        $removeKeys = array_merge($removeKeys, ['treeID']);
        return parent::array($removeKeys);
    }

}
