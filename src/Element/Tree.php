<?php
namespace Cme\Element;
use \Cme\Database\Validate as Validate;
use \Cme\Utility as Utility;

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


    function __construct($db, $tree = false) {
        $this->db = $db;
        if(Utility\isID($tree) || Utility\isSlug($tree)) {
            return $this->build($tree);
        } elseif(is_array($tree)) {
            return $this->buildFromArray($tree);
        }
    }

    /**
     * Gets a Tree from the DB and builds the object
     *
     * @param $tree INT/STRING ID or Slug of the tree you want to build
     * @return MIXED OBJECT of build tree ID on success, FALSE on invalid ID
     */
    protected function build($tree) {
        // validate the tree ID
        $validate = new Validate();
        //print_r($tree);
        if($validate->tree($tree) !== true) {
            throw new \Error('Tree does not exist.');
        }

        $tree = $this->db->getTree($tree);

        // Map the database values to our object
        $treeID = $tree['treeID'];
        // set the object values
        $this->ID = $tree['treeID'];
        $this->slug = $tree['treeSlug'];
        $this->title = $tree['title'];
        $this->owner = $tree['owner'];
        $this->setGroups();
        $this->setStarts();
        $this->setQuestions();
        $this->setEnds();

        return $this;
    }

    /**
     * Builds a tree object from an array of attributes
     *
     * @param $data ARRAY // 'ID' is not allowed
     * @return OBJECT of Tree
     */
    public function buildFromArray($data) {
        (isset($data['slug'])) ? $this->setSlug($data['slug']) : false;
        (isset($data['title'])) ? $this->setTitle($data['title']) : false;
        (isset($data['owner'])) ? $this->setOwner($data['owner']) : false;

        return $this;
    }

    public function getSlug() {
        return $this->slug;
    }

    public function setSlug($slug) {
        if(Utility\isSlug($slug)) {
            $this->slug = $slug;
        }

        return $this->slug;
    }

    public function setGroups($groups = false) {
        $this->groups = $this->getEls('group');
        return $this->groups;
    }

    public function getGroups() {
        return $this->groups;
    }

    public function setStarts($starts = false) {
        $this->starts = $this->getEls('start');
        return $this->starts;
    }

    public function getStarts() {
        return $this->starts;
    }

    public function setQuestions($questions = false) {
        $this->questions = $this->getEls('question', $questions);
        return $this->questions;
    }

    public function getQuestions() {
        return $this->questions;
    }

    public function setEnds($ends = false) {
        $this->ends = $this->getEls('end');
        return $this->ends;
    }

    public function getEnds() {
        return $this->ends;
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
                // error!
                return 'You must include a slug or title';
                // random slug?
                // $tree['treeSlug'] = substr(md5(microtime()),rand(0,26),12);
            }
        }

        if(!empty($this->getOwner())) {
            $tree['treeOwner'] = $this->getOwner();
        }

        $result = $this->db->createTree($tree);
        // it's hopefully returning the ID of the tree it inserted
        if(Utility\isID($result)) {
            return $this->build($result);
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


        // update the order of the Starts
        $this->updateOrder($this->getStarts());
        // update the order of the Groups
        $this->updateOrder($this->getGroups());
        // update the order of the Questions
        $this->updateOrder($this->getQuestions());
        // update the order of the Ends
        $this->updateOrder($this->getEnds());

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
