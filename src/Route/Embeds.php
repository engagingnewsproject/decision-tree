<?php
namespace App;
use \Cme\Database as Database;
use \Cme\Utility as Utility;

class Embeds extends Trees
{

    public function __construct($app = false) {
        $this->app = $app;

    }

    public function init($request) {
        // build the parent init
        parent::init($request);

    }

    public function getAllEmbedsByTree($request, $response) {
        // set up
        $this->init($request);
        // TODO: returns array of all embeds that match this treeID
        $embeds = [[]];
        $this->return($embeds, $response);
    }

    public function getEmbedByTree($request, $response) {
        // set up
        $this->init($request);

        $embedID = $request->getAttribute('embedID');

        // TODO: returns array of the embed with that embedID
        $embed = [];

        $this->return($embed, $response);
    }


    public function getAllEmbedsBySite($request, $response) {
        // set up
        $this->init($request);
        $siteID = $request->getAttribute('siteID');
        //TODO: see if the site ID is an ID or a URL
        $embeds = $this->db->getEmbedsBySite($siteID);
        $this->return($embeds, $response);
    }

    public function getEmbedBySite($request, $response) {
        // set up
        $this->init($request);

        $siteID = $request->getAttribute('siteID');
        $embedID = $request->getAttribute('embedID');

        // TODO: returns array of the embed with that embedID
        $embed = $this->db->getEmbed($embedID, ['siteID'=>$siteID]);

        $this->return($embed, $response);
    }
}
