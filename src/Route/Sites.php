<?php
namespace Cme\Route;

class Sites extends Trees
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
        // TODO
        $sites = [['siteID'=>1, 'feature_finished'=>'nope!']];
        $this->return($sites, $response);
    }

    public function get($request, $response) {
        // set up
        $this->init($request);

        $siteID = $request->getAttribute('siteID');

        $site = $this->db->getSite($siteID, $this->tree->getID());

        $this->return($site, $response);
    }
}
