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

        return $this->return($allStarts, $response);
    }

    public function get($request, $response) {
        // set up
        $this->init($request);

        return $this->return($this->start->array(), $response);
    }

    public function create($request, $response) {
        // init data
        $this->init($request);

        $start = [];
        $start['owner'] = $this->user['userID'];
        // add the user to the end data as the owner
        if(isset($this->data['owner'])) {
            $start['owner'] = $this->data['owner'];
        }

        // add in the treeID
        $start['treeID'] = $this->treeID;
        $start = new Start($this->db, $start);

        $keys = ['title', 'destination'];
        $start = $this->dynamicSet($this->data, $keys, $start);

        $start = $start->save();

        if(!is_object($start)) {
            $this->addError($start);
        }

        return $this->return($start->array(), $response);
    }

    public function update($request, $response) {
        // init data
        $this->init($request);

        $keys = ['title','destination'];
        $this->start = $this->dynamicSet($this->data, $keys, $this->start);

        $this->start->save();

        return $this->return($this->start->array(), $response);
    }

    public function delete($request, $response) {
        // init data
        $this->init($request);

        $result = $this->start->delete();

        return $this->return($result, $response);
    }
}
