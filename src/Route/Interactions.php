<?php
namespace App;
use \Cme\Database as Database;

class Interactions extends Route
{

    public function __construct($app = false) {
        $this->app = $app;

    }

    public function init($request) {
        // build the parent init
        parent::init($request);

    }

    public function create($request, $response) {
        $this->init($request);
        // pass in the database connection
        $site = new Database\SaveSite($this->db);
        // get the siteID. It will either save a new one or return an existing one
        $siteResponse = $site->save($this->data['site']);

        if(isset($siteResponse['status']) && $siteResponse['status'] === 'success') {
            $this->data['site']['siteID'] = $siteResponse['siteID'];
            $this->data['site']['treeID'] = $this->data['treeID'];
        } else {
            $this->addError($siteResponse);
        }
        // no errors? get the embed
        if(empty($this->errors)) {
            // add the treeID into the site attribute cuz we'll need it
            // try to get the embed
            $saveEmbed = new Database\SaveEmbed($this->db);
            $embed = $saveEmbed->save($this->data['site']);

            if(isset($embed['status']) && $embed['status'] === 'success') {
                $this->data['site']['embedID'] = $embed['embedID'];
            } else {
                $this->addError($embed);
            }
        }

        $interaction = false;
        // no errors? save the interaction
        if(empty($this->errors)) {
            // try to save it
            $saveInteraction = new Database\SaveInteraction($this->db);
            $interaction = $saveInteraction->save($this->data);
        }


        // return the JSON
        $this->return($interaction, $response);
    }

    public function getTypes($request, $response) {
        // set up
        $this->init($request);
        $interactions = $this->db->getInteractionTypes();
        $this->return($interactions, $response);
    }

    public function getType($request, $response) {
        // set up
        $this->init($request);

        $typeID = $request->getAttribute('typeID');

        $interaction = $this->db->getInteractionType($typeID);

        $this->return($interaction, $response);
    }
}
