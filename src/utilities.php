<?php
/**
 *  Utility functions for use throughout code
 */
namespace Cme\Utility;



/**
* Build the data URL to get the JSON data
*
* @return String

function get_data_url($slug) {
    return get_server_url()."/data/$slug.json";
}
*/


/**
* Checks to see if it's a slug or not
* Allowed characters are A-Z, a-z, 0-9, and dashes (-)
*
* @param $string (STRING)
* @return  BOOLEAN
*/
function isSlug($string) {
    // check to make sure it is, in fact, a string
    if(!is_string($string)) {
        return false;
    }

    $isSlug = false;
    // check for disallowed characters and strings that starts or ends in a dash (-)
    // if matches === 1, then it's a slug
    preg_match('/[^a-z0-9-]+|^-|-$/', $string, $matches);

    // check to make sure it's not null/empty
    // if there's a match, it's not a slug
    // also make sure $string !== boolean
    if(is_bool($string) === false && is_int($string) !== true && !empty($string) && empty($matches)) {
        $isSlug = true;
    }

    return $isSlug;
}

/**
 * Enter a string and it'll pop out a slug.
 * Allowed characters are A-Z, a-z, 0-9, and dashes (-)
 * Disallowed characters are replaced with a dash (-)
 * and if the last character in the string is a dash it'll remove it.
 *
 * @param $string (STRING)
 * @return $slug (STRING) in format this-is-a-slug
 */
function slugify($string) {
    // check if it's a slug already
    $isSlug = isSlug($string);
    if($isSlug === true) {
        // already a slug
        $slug = $string;
    } else {
        // turn it into a slug!
        // trim it
        $slug = trim($string);
        // replace disallowed characters
        $slug = preg_replace('/[^A-Za-z0-9-]+/', '-', $string);
        // pop off dash(es) from beginning and end of string
        $slug = preg_replace('/^-+|-+$/', '', $slug);
        // make it lowercase
        $slug = strtolower($slug);
    }

    return $slug;
}

/**
* Checks if a string is probably an ID (contains only numbers)
* This could likely live in a better locale, but don't have a good place for it
* and it makes sense that you'd be doing this alongside slugs
*
* @param $string (MIXED String/Integer)
* @return BOOLEAN
*/
function isID($string) {
    $isID = false;

    // make sure it's a valid string or integer
    if((is_string($string) || is_int($string)) && !empty($string)) {
        $string = (string) $string;
        // Regex check where the only allowed characters are 0-9
        // if a match is found, then it's not an ID
        $matches = null;
        preg_match('/[^0-9]/', $string, $matches);
        // if preg_match returns false (0) & it's not null/empty then it's an ID
        if(empty($matches)) {
            $isID = true;
        }
    }

    return $isID;
}

function getTreeSlugById($treeID) {
    // test if it's a valid ID or not
    if(!isID($treeID)) {
        return false;
    }
    // use the id to get the slug. Switch to $treeID bc that's what it is
    $db = new \Cme\Database\DB();
    $tree = $db->getTree($treeID);
    // return the tree slug
    return $tree['treeSlug'];
}

function getTreeIDBySlug($treeSlug) {
    // test if it's a valid ID or not
    if(!isSlug($treeSlug)) {
        return false;
    }
    // use the id to get the slug. Switch to $treeID bc that's what it is
    $db = new \Cme\Database\DB();
    $tree = $db->getTreeBySlug($treeSlug);
    // return the tree slug
    return $tree['treeID'];
}


/**
 * really bare curl implementation to consume our own api
 * @param $path STRING
 * @param $data data ARRAY to post/put if you need to
 * @param $method GET
 * @return MIXED response
 */
function requestEndpoint($path, $data = [], $method = 'GET') {
    // Get cURL resource
    $curl = curl_init();
    // Set options
    curl_setopt_array($curl, array(
        CURLOPT_RETURNTRANSFER => 1, // get response as string
        CURLOPT_URL => TREE_URL.'/api/v1/'.$path
    ));

    switch ($method) {
        case 'POST':
            curl_setopt($curl, CURLOPT_POST, true);
            break;
        case 'PUT':
            curl_setopt($curl, CURLOPT_PUT, true);
            break;
        case 'DELETE':
            curl_setopt($curl, CURLOPT_CUSTOMREQUEST, 'DELETE');
            break;
    }

    if($method !== 'GET') {
        curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query($data));
    }

    // don't worry about SSL for local
    if(TREE_URL === 'https://decision-tree.dev') {
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
    }

    // Send the request
    $response = curl_exec($curl);
    // Close request to clear up some resources
    curl_close($curl);

    return $response;
}

/**
 * Wrapper function for requestEndpoint
 *
 * @param $path STRING
 * @return MIXED response
 */
function getEndpoint($path) {
    return requestEndpoint($path);
}
/**
 * Wrapper function for requestEndpoint
 *
 * @param $path STRING
 * @param $data data ARRAY
 * @return MIXED response
 */
function postEndpoint($path, $data) {
    return requestEndpoint($path, $data, 'POST');
}
/**
 * Wrapper function for requestEndpoint
 *
 * @param $path STRING
 * @param $data data ARRAY
 * @return MIXED response
 */
function putEndpoint($path, $data) {
    return requestEndpoint($path, $data, 'PUT');
}
/**
 * Wrapper function for requestEndpoint
 *
 * @param $path STRING
 * @param $data data ARRAY
 * @return MIXED response
 */
function deleteEndpoint($path, $data) {
    return requestEndpoint($path, $data, 'DELETE');
}


/**
 * Find a user by a key that matches the value you want
 *
 * @param $key STRING
 * @param $val MIXED
 * @return MIXED found user ARRAY or FALSE if not found
 */
function getUser($key, $val) {
    $users = TREE_USERS;
    foreach($users as $user) {
        if($user[$key] === $val) {
            return $user;
        }
    }
    // could not locate user
    return false;
}


// quick validate if the user token is valid
function validateUserToken($clientToken, $accessToken) {
    $user = getUser('clientToken', $clientToken);
    if(empty($user)) {
        return false;
    }

    // validate access token
    if($user['accessToken'] === $accessToken) {
        return true;
    }

    // invalid
    return false;
}

// quick validate if the user token is valid
function validateUser($user) {

    // validate userID
    if(!isset($user['userID']) || !isID($user['userID'])) {
        return false;
    }

    // get the user from the DB
    $foundUser = getUser('userID', $user['userID']);

    // make sure our users match
    if($foundUser === $user) {
        // passed user and found user match, so we're good!
        return true;
    }

    // invalid
    return false;
}
