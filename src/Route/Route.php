<?php
namespace Cme\Route;
use Cme\Database as Database;
use Cme\Utility as Utility;

class Route
{
    protected $app,
              $db = false,
              $data = [], // the passed data in the request
              $user = false,
              $errors = [];

    public function __construct($app) {
        $this->app = $app;
    }

    public function init($request) {
         // set the user, if any
        $this->user = $request->getAttribute('user');

        // pass the user to the database. If the user is false, it will connect but all POST/PUT/DELETE requests will be disabled
        $this->db = new Database\DB($this->user);

        // set the data, if any
        $data = $request->getParsedBody();
        if($data) {
            $this->data = $request->getParsedBody();
        }

    }

    public function addError($string) {
        throw new \Error($string);
    }

    public function getErrors() {
        return $this->errors;
    }

    /**
     * Util function for returning a response but checking for errors first
     *
     * @param $return MIXED whatever you want to be JSON encoded for the return
     * @param $response SLIM Response object
     * @return SLIM response
     */
    public function return($return, $response) {

        if($this->getErrors()) {
            $response->getBody()->write(json_encode($this->getErrors()));
        } else {
            $response->getBody()->write(json_encode($return));
        }
        return $response;
    }

    /**
     * Util function for dynamically running set{$key} so you can easily set an object's params
     *
     * @param $data ARRAY of data passed to the request, like ['title'=>'howdy']
     * @param $keys ARRAY of keys you want to dynamically set, like ['title']
     * @param $obj OBJECT of the object to run the set{$key} functions on
     * @return OBJECT
     */
    public function dynamicSet($data, $keys, $obj) {

        if(empty($data) || empty($keys)) {
            // nothin to set
            return $obj;
        }

        // keys that are comma separated values that need to get exploded into an array
        $exploders = ['questions'];

        foreach($data as $key => $val) {
            if(in_array($key, $keys)) {

                // handle destination differently
                if($key === 'destinationID') {
                    $obj->setDestination($val);
                    // go to next cycle
                    continue;
                }

                $function = 'set'.ucfirst($key);

                // if we need to explode the value and it's not already an array
                if(in_array($key, $exploders) && !is_array($val)) {
                    $val = explode(',', $val);
                }

                $obj->$function($val);
            }
        }

        return $obj;
    }




    /**
     * Moves an element on the tree and updates it. Use it for
     * reordering questions, options, groups, and ends
     *
     * @param $elType STRING question, option, group, or end
     */
    public function reorder($request, $response, $elType) {
        // get the location they want to move it to
        $position = $request->getAttribute('position');

        $el = $this->$elType->move($position);

        return $this->return($el->array(), $response);
    }

}
