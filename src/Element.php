<?php

namespace Cme;
use Cme\Database as Database;
use Cme\Database\Validate as Validate;
use Cme\Utility as Utility;

/**
 * Interact with Tree object
 */
class Element {
    protected $db        = null,
              $ID        = null,
              $title     = '';


    function __construct($db) {
        $this->db = $db;
    }

    // scaffold
    public function build($ID) {

        return $this;
    }

    public function getID() {
        return $this->ID;
    }

    public function getTitle() {
        return $this->title;
    }

    public function setTitle($string) {
        if(is_string($string)) {
            $this->title = $string;
        }

        return $this->title;
    }


    public function save() {
        if(!Utility\isID($this->getID())) {
            // create it
            return $this->create();
        }

        return $this->update();
    }

    // scaffold
    protected function create() {

    }
    // scaffold
    protected function update() {

    }
    // scaffold
    public function delete() {

    }

    /**
     * Returns the object as an array for JSON usage
     */
    public function array() {
        $return = [];
        // loop the properties to make it into an array
        foreach($this as $property => $val) {
            $return[$property] = $val;
        }
        // unset the DB property
        unset($return['db']);

        return $return;
    }
}
