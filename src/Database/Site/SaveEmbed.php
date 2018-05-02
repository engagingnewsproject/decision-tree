<?php

namespace Cme\Database;
use Cme\Utility as Utility;

/**
 * Add a question to the database
 */
class SaveEmbed extends DB {
    public $DB;

    function __construct($db = false) {
        // allow a database connection to be passed in
        if($db !== false) {
            $this->DB = $db;
        } else {
            $this->DB = new \Cme\Database\DB();
        }
    }

    /**
     *
     * @param $data (ARRAY) needs all the info to be saved
     * @return ARRAY with saved data or Errors
     */
    public function save($embed) {
        // decide how to save it...
        return $this->insert($embed);
    }

    /* Validates data structure
     * @param $data (ARRAY) needs all the info to be saved
     *
     *    'embed'=> [
     *       'treeID'=> (STRING/INT), // from tree table
     *       'siteID'=> (STRING/INT), // from tree_site table
     *       'path'   => (STRING), // ex. '/path/to/embed/'
     *       'iframe' => (BOOLEAN), // is it in an iframe or not?
     *     ]
     *
     * @return true or false
     */
    protected function validate($embed) {
        $is_valid = false;

        // check if we have all the data we need
        if(!isset($embed['treeID'])) {
            $this->errors[] = 'No Tree ID sent.';
        }

        if(!isset($embed['siteID'])) {
            $this->errors[] = 'No Site ID sent.';
        }

        if(!isset($embed['path'])) {
            $this->errors[] = 'No Embed Path sent.';
        }

        if(empty($embed['path'])) {
            $this->errors[] = 'Embed Path is empty.';
        }

        if(!isset($embed['isIframe'])) {
            $this->errors[] = 'Is it an iframe? Set isIframe to true or false.';
        }

        // if we have any errors, return false. Passes first round of being the correct data structure
        if(!empty($this->errors)) {
            return $is_valid;
        }

        // check that it's a valid pathname by adding 'http://example.com' to test it
        if(filter_var('http://example.com'.$embed['path'], FILTER_VALIDATE_URL) === false) {
            $this->errors[] = 'Invalid path.';
        }
        // open the validator
        $validate = new Validate();
        // check that the site exists
        $site = $this->DB->getSite($embed['siteID']);
        if($site === false) {
            $this->errors[] = 'Site doesn\'t exist.';
        }

        // check that it doesn't already exist
        if($this->DB->getSite($embed['path']) !== false) {
            $this->errors[] = 'Site already exists.';
        }

        // check that it's a valid Tree
        if($validate->treeID($embed['treeID']) === false) {
            $this->errors[] = 'Invalid treeID.';
        }

        // check that isIframe is boolean
        if(is_bool( $embed['isIframe'] ) === false) {
            $this->errors[] = 'isIframe must be boolean.';
        }

        // if we have don't have any errors, it's valid!
        if(empty($this->errors)) {
            $is_valid = true;
        }

        return $is_valid;

    }

    protected function sanitize($embed) {
        if(isset($embed['path'])) {
            $embed['path'] = filter_var($embed['path'], FILTER_SANITIZE_URL);
        }

        return $embed;
    }

    /**
    * Inserts a new interaction
    * @param $data (ARRAY) See validate for structure
    * @return (ARRAY)
    */
    protected function insert($embed) {
        // sanitize data
        $embed = $this->sanitize($embed);
        // make sure it's valid
        $is_valid = $this->validate($embed);

        // if validation doesn't pass, return the errors
        if($is_valid !== true) {
            return $this->errors;
        }
        // check if it exists already
        $embed_check = $this->DB->getEmbed($embed['path'],
                                        ['siteID' => $embed['siteID'],
                                         'treeID' => $embed['treeID']
                                        ]);
        if($embed_check !== false) {
            $response = [
                            'embedID'   => $embed_check['embedID'],
                            'status'     => 'success',
                            'action'     => 'embedExists'
                        ];

            return $response;
        }


        // Get our Parameters ready
        $params = [
                    ':treeID'              => $embed['treeID'],
                    ':siteID'              => $embed['siteID'],
                    ':embedPath'           => $embed['path'],
                    ':embedIsIframe'      => $embed['isIframe']
                  ];
        // write our SQL statement
        $sql = 'INSERT INTO '.$this->DB->tables['tree_embed'].' (
                                            siteID,
                                            treeID,
                                            embedPath,
                                            embedIsIframe
                                        )
                                        VALUES(
                                            :siteID,
                                            :treeID,
                                            :embedPath,
                                            :embedIsIframe
                                        )';
        // insert the mc_option into the database
        $stmt = $this->DB->query($sql, $params);

        // success!
        if($stmt !== false) {
            $embedID = $this->DB->lastInsertId();

            $response = [
                            'embedID'          => $embedID,
                            'status'           => 'success',
                            'action'           => 'insertEmbed'
                        ];
        } else {
            // handle errors
            $this->errors[] = 'Insert embed failed.';
            $this->errors['status'] = 'error';
        }


        if(!empty($this->errors)) {
            return $this->errors;
        }

        return $response;
    }

}
