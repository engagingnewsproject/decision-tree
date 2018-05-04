<?php
namespace Cme\Route;
use \Cme\Element\Start as Start;

class Starts extends Trees
{

    public function __construct($app = false) {
        $this->app = $app;

    }

    public function init($request) {
        // build the parent init
        parent::init($request);

        // set start
        $startID = $request->getAttribute('startID');
        if($startID) {
            $this->startID = $startID;
            $this->start = new Start($this->db, $startID);

            // make sure this start is owned by this tree
            if($this->start->getTreeID() != $this->treeID) {
                $this->addError('Start does not go with this Tree.');
            }
        }
    }

    public function getAll($request, $response) {
        // set up
        $this->init($request);
        $startIDs = $this->tree->getStarts();

        $allStarts = [];
        foreach($startIDs as $startID) {
            $start = new Start($this->db, $startID);
            $allStarts[] = $start->array();
        }

        $this->return($allStarts, $response);
    }

    public function get($request, $response) {
        // set up
        $this->init($request);

        return $this->return($this->start->array(), $response);
    }
}
