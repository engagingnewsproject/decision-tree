<?php
namespace Enp\Template;
/**
 * collection of helper functions for handlebars php implementation.
 * each helper here should match the JS helpers in assets/js/handlebars-helpers.js
 */
class Helpers {

    function __construct() {

    }

    public static function upper($str) {
        return strtoupper($str);
    }

    public static function ifIn($id, $array) {
        if(in_array($id, $array)) {
            return true;
        } else {
            return false;
        }
    }

}

 ?>
