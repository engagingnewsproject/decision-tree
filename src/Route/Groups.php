<?php
namespace Cme\Route;
use \Cme\Element\Group as Group;

class Groups extends Trees
{
    public $groupID = false,
           $group = false;

    public function __construct($app = false) {
        $this->app = $app;

    }

    public function init($request) {
        // build the parent init
        parent::init($request);

        // set group
        $groupID = $request->getAttribute('groupID');
        if($groupID) {
            $this->groupID = $groupID;
            $this->group = new Group($this->db, $groupID);

            // make sure this group is owned by this tree
            if($this->group->getTreeID() != $this->treeID) {
                $this->addError('Group does not go with this Tree.');
            }
        }
    }

    public function getAll($request, $response) {
        // set up
        $this->init($request);
        $groupIDs = $this->tree->getGroups();

        $allGroups = [];
        foreach($groupIDs as $groupID) {
            $group = new Group($this->db, $groupID);
            $allGroups[] = $group->array();
        }

        $this->return($allGroups, $response);
    }

    public function get($request, $response) {
        // set up
        $this->init($request);

        return $this->return($this->group->array(), $response);
    }
}
