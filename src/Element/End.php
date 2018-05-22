<?php

namespace Cme\Element;
use \Cme\Database\Validate as Validate;
use \Cme\Utility as Utility;


/**
 * Interact with End object
 */
class End extends Element {
    protected $db        = null,
              $ID        = null,
              $treeID    = null,
              $title     = null,
              $content   = null;



    function __construct($db, $end) {
        $this->db = $db;
        if(Utility\isID($end)) {
            return $this->build($end);
        } elseif(is_array($end)) {
            return $this->buildFromArray($end);
        }
    }

    /**
     * Gets a End from the DB and builds the object
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

        return $this;
    }

    /**
     * Builds a end object from an array of attributes
     *
     * @param $data ARRAY // 'ID' is not allowed
     * @return OBJECT of End
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

    protected function create() {
        $end = [];
        // create it off the object
        // map the end object to the end parameters in the DB
        $end['elTitle'] = $this->getTitle();
        $end['treeID'] = $this->getTreeID();
        $end['elTypeID'] = $this->db->getElementTypeID('end');

        $result = $this->db->createElement($end);

        // it's hopefully returning the ID of the end it inserted
        if(Utility\isID($result)) {
            $endID = $result;
            // it'll get put at the end of the order
            // find the total number of ends for this tree
            $tree = new Tree($this->db, $this->getTreeID());

            $order = count($tree->getEnds());
            $insertOrder = $this->db->insertOrder($endID, $order);
            if(!Utility\isID($insertOrder)) {
                // oops. Return the errors.
                return $insertOrder;
            }

            // we're good! Build the end again and return it
            return $this->build($endID);
        }
        // oops. Return the errors.
        return $result;
    }

    protected function update() {
        // map the end object to the database
        $end = [
            'elID'        => $this->getID(),
            'elTitle'     => $this->getTitle(),
            'treeID'      => $this->getTreeID()
        ];

        $result = $this->db->updateElement($end);

        // rebuild it so we get the fresh copy
        $this->rebuild();
        // return the original update result
        return $result;
    }

    /**
     * Deletes a end from the DB
     */
    public function delete() {
        $treeID = $this->getTreeID();

        // delete the end
        $delete = $this->db->deleteElement(
            ['elID'=>$this->getID(), 'treeID' => $treeID]
        );
        if($delete !== true) {
            throw new \Error('Could not delete endID '.$optionID);
        }

        return true;
    }

    public function array($removeKeys = []) {
        $removeKeys = array_merge($removeKeys, ['treeID']);
        return parent::array($removeKeys);
    }

}
