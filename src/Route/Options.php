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

            // make sure this option is owned by this tree
            if($this->option->getTreeID() != $this->treeID) {
                $this->addError('Option does not go with this Tree.');
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

    // Move an option from one position to another
    public function move($request, $response) {
        // init data
        $this->init($request);

        return parent::reorder($request, $response, 'option');
    }
}
