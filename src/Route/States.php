<?php
namespace Cme\Route;

class States extends Route
{

    public function __construct($app = false) {
        $this->app = $app;

    }

    public function init($request) {
        // build the parent init
        parent::init($request);

    }

    public function getStateTypes($request, $response) {
        // set up
        $this->init($request);
        $interactions = $this->db->getStateTypes();
        $this->return($interactions, $response);
    }

    public function getStateType($request, $response) {
        // set up
        $this->init($request);

        $typeID = $request->getAttribute('typeID');

        $interaction = $this->db->getStateType($typeID);

        $this->return($interaction, $response);
    }
}
