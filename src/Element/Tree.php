<?php

namespace Cme;
use Cme\Database as Database;
use Cme\Database\Validate as Validate;
use Cme\Utility as Utility;

/**
 * Interact with Tree object
 */
class Tree extends Element {
    protected $db        = null,
              $ID        = null,
              $slug      = '',
              $title     = '',
              $owner     = null,
              $starts    = [],
              $groups    = [],
              $questions = [],
              $ends      = [];


    function __construct($db, $treeID = false) {
        $this->db = $db;
        if(Utility\isID($treeID)) {
            return $this->build($treeID);
        }
    }

    /**
     * Gets a Tree from the DB and builds the object
     *
     * @param $treeID INT ID of the tree you want to build
     * @return MIXED OBJECT of build tree ID on success, FALSE on invalid ID
     */
    public function build($treeID) {
        // validate the tree ID
        $validate = new Validate();
        if(!$validate->treeID($treeID)) {
            return false;
        }

        $tree = $this->db->getTree($treeID);
        // Map the database values to our object

        // set the object values
        $this->ID = $tree['treeID'];
        $this->slug = $tree['treeSlug'];
        $this->title = $tree['title'];
        $this->owner = $tree['owner'];
        // set the array of IDs for each elem
        $this->starts = $this->db->getStartIDs($treeID);
        $this->groups = $this->db->getGroupIDs($treeID);
        $this->questions = $this->db->getQuestionIDs($treeID);
        $this->ends = $this->db->getEndIDs($treeID);

        return $this;
    }

    public function getSlug() {
        return $this->slug;
    }

    public function setSlug($string) {
        if(Utility\isSlug($string)) {
            $this->slug = $string;
        }

        return $this->slug;
    }

    public function getOwner() {
        return $this->owner;
    }

    public function setOwner($userID) {
        if(Utility\validateUser($userID)) {
            $this->owner = $userID;
        }

        return $this->owner;
    }

    protected function create() {
        // create it off the object
        $tree = [];
        $title = $this->getTitle();

        // map the tree object to the tree parameters in the DB
        if(!empty($title)) {
            $tree['treeTitle'] = $title;
        }

        if(!empty($this->getSlug())) {
            $tree['treeSlug'] = $this->getSlug();
        } else {
            // do we have a title?
            if(!empty($title)) {
                $tree['treeSlug'] = Utility\slugify($title);
            } else {
                // random slug?
                $tree['treeSlug'] = substr(md5(microtime()),rand(0,26),12);
            }
        }

        if(!empty($this->getOwner())) {
            $tree['treeOwner'] = $this->getOwner();
        }

        $result = $this->db->createTree($tree);

        // it's hopefully returning the ID of the tree it inserted
        if(Utility\isID($result)) {
            return $this->build();
        }
        // oops. Return the errors.
        return $result;
    }

    protected function update() {
        // map the tree object to the database
        $tree = [
            'treeID'    => $this->getID(),
            'treeSlug'  => $this->getSlug(),
            'treeTitle' => $this->getTitle(),
            'treeOwner' => $this->getOwner()
        ];

        $result = $this->db->updateTree($tree);

         // rebuild it so we get the fresh copy
        $this->build($this->getID());
        // return the original update result
        return $result;
    }

    /**
     * Deletes a tree from the DB
     */
    public function delete() {
        return $this->db->deleteTree(['treeID' => $this->getID()]);
    }
}
