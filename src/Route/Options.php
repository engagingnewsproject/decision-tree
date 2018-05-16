<?php
namespace Cme\Route;
use \Cme\Element\Option as Option;

class Options extends Questions
{
    public $optionID,
           $option;

    public function __construct($app = false) {
        $this->app = $app;

    }

    public function init($request) {
        // build the parent init
        parent::init($request);

        // set option
        $optionID = $request->getAttribute('optionID');
        if($optionID) {
            $this->optionID = $optionID;
            $this->option = new Option($this->db, $optionID);

            // make sure this question is owned by this tree
            if($this->question->getTreeID() != $this->treeID) {
                $this->addError('Question does not go with this Tree.');
            }

            // make sure this option is owned by this question
            if($this->option->getQuestionID() != $this->questionID) {
                $this->addError('Option does not go with this Question.');
            }
        }

    }

    public function getAll($request, $response) {
        // set up
        $this->init($request);


        $optionIDs = $this->question->getOptions();

        $allOptions = [];
        foreach($optionIDs as $optionID) {
            $option = new Option($this->db, $optionID);
            $allOptions[] = $option->array();
        }

        $this->return($allOptions, $response);
    }

    public function get($request, $response) {
        // set up
        $this->init($request);

        return $this->return($this->option->array(), $response);
    }

    /**
     * params: destination = ID, title = string
     */
    public function create($request, $response) {
        // init data
        $this->init($request);

        $option = [];
        $option['owner'] = $this->user['userID'];
        // add the user to the question data as the owner
        if(isset($this->data['owner'])) {
            $option['owner'] = $this->data['owner'];
        }

        // add in the questionID
        $option['questionID'] = $this->questionID;

        $option = new Option($this->db, $option);
        // allow them to move questions
        $keys = ['title', 'destination', 'questionID'];
        $option = $this->dynamicSet($this->data, $keys, $option);

        $option = $option->save();

        /*if(!is_object($option)) {
            $this->addError('Option could not be created.');
        }*/

        $this->return($option->array(), $response);
    }

    public function update($request, $response) {
        // init data
        $this->init($request);

        $keys = ['questionID', 'destination', 'title'];
        $this->option = $this->dynamicSet($this->data, $keys, $this->option);

        $this->option->save();

        return $this->return($this->option->array(), $response);
    }

    // Move an option from one position to another
    public function move($request, $response) {
        // init data
        $this->init($request);

        return parent::reorder($request, $response, 'option');
    }

    // TODO
    public function prune() {
        // remove all options that don't have a destination (maybe the destination was deleted)
    }
}
