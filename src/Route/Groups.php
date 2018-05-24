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

        return $this->return($allGroups, $response);
    }

    public function get($request, $response) {
        // set up
        $this->init($request);

        return $this->return($this->group->array(), $response);
    }

    public function create($request, $response) {
        // init data
        $this->init($request);

        $group = [];
        $group['owner'] = $this->user['userID'];
        // add the user to the end data as the owner
        if(isset($this->data['owner'])) {
            $group['owner'] = $this->data['owner'];
        }

        // add in the treeID
        $group['treeID'] = $this->treeID;
        $group = new Group($this->db, $group);

        $keys = ['title', 'content', 'questions'];
        $group = $this->dynamicSet($this->data, $keys, $group);

        $group = $group->save();

        if(!is_object($group)) {
            $this->addError($group);
        }

        return $this->return($group->array(), $response);
    }

    public function update($request, $response) {
        // init data
        $this->init($request);

        // using 'questions' here will overwrite any questions that were already in the group. To individually add or remove them, put-> to the groups/{groupID}/questions endpoint
        $keys = ['title', 'content', 'questions'];
        $this->group = $this->dynamicSet($this->data, $keys, $this->group);

        $this->group->save();

        return $this->return($this->group->array(), $response);
    }

    public function delete($request, $response) {
        // init data
        $this->init($request);

        $result = $this->group->delete();

        return $this->return($result, $response);
    }

    // Move a group from one position to another
    public function move($request, $response) {
        // init data
        $this->init($request);

        return parent::reorder($request, $response, 'group');
    }

    // add a question to a group
    public function addQuestion($request, $response) {
        // init data
        $this->init($request);

        if(!isset($this->data['question'])) {
            // add one question
            $this->addError('Must include a "question" parameter with a valid question ID.');
        }

        $this->group->addQuestion($this->data['question']);
        $this->group->save();

        return $this->return($this->group->array(), $response);
    }


    // remove a question from a group
    public function removeQuestion($request, $response) {
        // init data
        $this->init($request);

         // get the question ID
        $questionID = $request->getAttribute('questionID');

        $this->group->removeQuestion($questionID);
        $this->group->save();

        return $this->return($this->group->array(), $response);
    }

}
