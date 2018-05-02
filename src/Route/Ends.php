<?php
namespace App;

class Ends extends Trees
{

    public function __construct($app = false) {
        $this->app = $app;

    }

    public function init($request) {
        // build the parent init
        parent::init($request);

    }

    public function getAll($request, $response) {
        // set up
        $this->init($request);
        $ends = $this->db->getEnds($this->tree->getID());
        $this->return($ends, $response);
    }

    public function get($request, $response) {
        // set up
        $this->init($request);

        $endID = $request->getAttribute('endID');

        $end = $this->db->getEnd($endID, $this->tree->getID());

        $this->return($end, $response);
    }
}
