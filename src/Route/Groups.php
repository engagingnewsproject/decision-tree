<?php
namespace App;
use \Cme\Database as Database;
use \Cme\Utility as Utility;

class Groups extends Trees
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
        $groups = $this->db->getGroups($this->tree->getID());
        $this->return($groups, $response);
    }

    public function get($request, $response) {
        // set up
        $this->init($request);

        $groupID = $request->getAttribute('groupID');

        $group = $this->db->getGroup($groupID, $this->tree->getID());

        $this->return($group, $response);
    }
}