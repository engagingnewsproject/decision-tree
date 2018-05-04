<?php

namespace Cme\Element;
use \Cme\Database\Validate as Validate;
use \Cme\Utility as Utility;


/**
 * Interact with Question object
 */
class End extends Element {
    protected $db        = null,
              $ID        = null,
              $treeID    = null,
              $title     = null,
              $content   = null,
              $owner     = null;



    function __construct($db, $end) {
        $this->db = $db;
        if(Utility\isID($end)) {
            return $this->build($end);
        } elseif(is_array($end)) {
            return $this->buildFromArray($end);
        }
    }

    /**
     * Gets a Question from the DB and builds the object
     *
     * @param $end INT/STRING ID of the end you want to build
     * @return MIXED OBJECT of build end ID on success, FALSE on invalid ID
     */
    protected function build($endID) {
        // validate the end ID
        $validate = new Validate();
        //print_r($endID);
        if($validate->endID($endID) !== true) {
            return false;
        }

        $end = $this->db->getEnd($endID);
        //var_dump($end);
        // Map the database values to our object
        $endID = $end['endID'];
        // set the object values
        $this->ID = $endID;
        $this->setTreeID($end['treeID']);
        $this->setContent($end['content']);
        $this->setTitle($end['title']);

        // set the owner off the tree
        $tree = new Tree($this->db, $this->getTreeID());
        $this->setOwner($tree->getOwner());


        return $this;
    }

    /**
     * Builds a end object from an array of attributes
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

    public function array($removeKeys = []) {
        $removeKeys = array_merge($removeKeys, ['treeID']);
        return parent::array($removeKeys);
    }

}
