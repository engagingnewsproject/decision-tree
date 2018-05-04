<?php
namespace Cme\Route;
use Cme\Database as Database;

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
        $this->errors[] = $string;
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

        foreach($data as $key => $val) {
            if(in_array($key, $keys)) {
                $function = 'set'.ucfirst($key);
                $obj->$function($val);
            }
        }

        return $obj;
    }

}