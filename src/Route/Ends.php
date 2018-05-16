<?php
namespace Cme\Route;
use \Cme\Element\End as End;

class Ends extends Trees
{

    public $endID = false,
           $end = false;

    public function __construct($app = false) {
        $this->app = $app;

    }

    public function init($request) {
        // build the parent init
        parent::init($request);

        // set group
        $endID = $request->getAttribute('endID');
        if($endID) {
            $this->endID = $endID;
            $this->end = new End($this->db, $endID);

            // make sure this end is owned by this tree
            if($this->end->getTreeID() != $this->treeID) {
                $this->addError('End does not go with this Tree.');
            }
        }
    }

    public function getAll($request, $response) {
        // set up
        $this->init($request);
        $endIDs = $this->tree->getEnds();

        $allEnds = [];
        foreach($endIDs as $endID) {
            $end = new End($this->db, $endID);
            $allEnds[] = $end->array();
        }

        $this->return($allEnds, $response);
    }

    public function get($request, $response) {
        // set up
        $this->init($request);

        return $this->return($this->end->array(), $response);
    }

    // Move an end from one position to another
    public function move($request, $response) {
        // init data
        $this->init($request);

        return parent::reorder($request, $response, 'end');
    }
}
