<?php
namespace App;
use \Cme\Database as Database;
use \Cme\Utility as Utility;

class Starts extends Trees
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
        $starts = $this->db->getStarts($this->tree->getID());
        $this->return($starts, $response);
    }

    public function get($request, $response) {
        // set up
        $this->init($request);

        $startID = $request->getAttribute('startID');

        $start = $this->db->getStart($startID, $this->tree->getID());

        $this->return($start, $response);
    }
}
