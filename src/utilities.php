<?php
/**
 *  Utility functions for use throughout code
 */
namespace Enp\Utility;

/**
* Check if we're in the dev environment or on a live site
*
* @return Boolean (static)
*/
function is_dev() {
    static $is_dev = false;

    // Regex check to see if starts with http:// or https://
    $url = $_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
    $matches = null;
    preg_match('/^https?:\/\/(dev|localhost:[0-9]+)\//', $url, $matches);
    // if there's a match, then we're in dev
    if(!empty($matches)) {
        $is_dev = true;
    }

    return $is_dev;
}

/**
* Get the URL of the current environment
*
* @return String (static)
*/
function get_server_url() {
    static $url = false;

    if($url === false) {
        if(is_dev() === true) {
            $url = 'http://dev/decision-tree/';
        } else {
            $url = $_SERVER['HTTP_HOST'].'/decision-tree/';
        }
    }

    return $url;
}

function get_api_base_url() {
    static $base_url = false;

    if($base_url === false) {
        $base_url = get_server_url().'api/v1/';
    }

    return $base_url;
}

/**
* Build the data URL to get the JSON data
*
* @return String
*/
function get_data_url($slug) {
    return get_server_url()."/data/$slug.json";
}

/**
* Checks to see if it's a slug or not
* Allowed characters are A-Z, a-z, 0-9, and dashes (-)
*
* @param $string (STRING)
* @return  BOOLEAN
*/
function is_slug($string) {
    $is_slug = false;
    // check for disallowed characters and strings that starts or ends in a dash (-)
    // if matches === 1, then it's a slug
    preg_match('/[^a-z0-9-]+|^-|-$/', $string, $matches);

    // check to make sure it's not null/empty
    // if there's a match, it's not a slug
    // also make sure $string !== boolean
    if(is_bool($string) === false && is_int($string) !== true && !empty($string) && empty($matches)) {
        $is_slug = true;
    }

    return $is_slug;
}

/**
* Checks if a string is probably an ID (contains only numbers)
* This could likely live in a better locale, but don't have a good place for it
* and it makes sense that you'd be doing this alongside slugs
*
* @param $string (MIXED String/Integer)
* @return BOOLEAN
*/
function is_id($string) {
    $is_id = false;

    // make sure it's a valid string
    if(is_bool($string) === false && !empty($string)) {
        $string = (string) $string;
        // Regex check where the only allowed characters are 0-9
        // if a match is found, then it's not an ID
        $matches = null;
        preg_match('/[^0-9]/', $string, $matches);
        // if preg_match returns false (0) & it's not null/empty then it's an ID
        if(empty($matches)) {
            $is_id = true;
        }
    }

    return $is_id;
}
