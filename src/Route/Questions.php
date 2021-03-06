<?php
namespace Cme\Route;
use Cme\Element\Question as Question;
use Cme\Utility as Utility;

class Questions extends Trees
{
    public $questionID = false,
           $question = false;
    public function __construct($app = false) {
        $this->app = $app;
    }

    public function init($request) {
        // build the parent init
        parent::init($request);

        // set question
        $questionID = $request->getAttribute('questionID');
        if($questionID) {
            $this->questionID = $questionID;
            $this->question = new Question($this->db, $questionID);

            // make sure this question is owned by this tree
            if($this->question->getTreeID() != $this->treeID) {
                $this->addError('Question does not go with this Tree.');
            }
        }
    }

    public function getAll($request, $response) {
        // set up
        $this->init($request);

        $questionIDs = $this->tree->getQuestions();
        $allQuestions = [];
        foreach($questionIDs as $questionID) {
            $question = new Question($this->db, $questionID);
            $allQuestions[] = $question->array();
        }

        return $this->return($allQuestions, $response);
    }

    public function create($request, $response) {
        // init data
        $this->init($request);

        $question = [];
        $question['owner'] = $this->user['userID'];
        // add the user to the question data as the owner
        if(isset($this->data['owner'])) {
            $question['owner'] = $this->data['owner'];
        }

        // add in the treeID
        $question['treeID'] = $this->treeID;
        $question = new Question($this->db, $question);

        $keys = ['title'];
        $question = $this->dynamicSet($this->data, $keys, $question);

        $question = $question->save();

        if(!is_object($question)) {
            $this->addError($question);
        }

        return $this->return($question->array(), $response);
    }

    public function get($request, $response) {
        // set up
        $this->init($request);
        return $this->return($this->question->array(), $response);
    }

    public function update($request, $response) {
        // init data
        $this->init($request);

        $keys = ['treeID','title'];
        $this->question = $this->dynamicSet($this->data, $keys, $this->question);

        $this->question->save();

        return $this->return($this->question->array(), $response);
    }

    public function delete($request, $response) {
        // init data
        $this->init($request);

        $result = $this->question->delete();

        return $this->return($result, $response);
    }

    // Move a question from one position to another
    public function move($request, $response) {
        // init data
        $this->init($request);

        return parent::reorder($request, $response, 'question');
    }
}
