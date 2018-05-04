<?php
namespace Cme\Route;

class Options extends Questions
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
        $options = $this->db->getOptions($this->questionID, ['treeID' => $this->treeID]);
        $this->return($options, $response);
    }

    public function get($request, $response) {
        // set up
        $this->init($request);

        $optionID = $request->getAttribute('optionID');

        $option = $this->db->getOption($optionID, ['treeID' => $this->treeID, 'questionID' => $this->questionID]);

        $this->return($option, $response);
    }
}
