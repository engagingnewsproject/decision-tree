<?php
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
            curl_setopt($curl, CURLOPT_CUSTOMREQUEST, 'PUT');
            break;
        case 'DELETE':
            curl_setopt($curl, CURLOPT_CUSTOMREQUEST, 'DELETE');
            break;
    }

    if($method !== 'GET') {
        // add in authentication
        curl_setopt($curl, CURLOPT_HTTPHEADER, array(
            'X-API-Access: '.$data['user']['accessToken'],
            'X-API-Client: '.$data['user']['clientToken']
        ));
        // remove user from data
        if(isset($data['user'])) {
            unset($data['user']);
        }
        curl_setopt($curl, CURLOPT_POSTFIELDS, http_build_query($data));

    }

    // don't worry about SSL for local
    if(TREE_URL === 'https://decision-tree.test') {
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
    throw new \Error('Invalid user.');
}

// quick validate if the user ID exists
function validateUserID($userID) {

    // get the user from the DB
    $foundUser = getUser('userID', $userID);

    // make sure our users match
    if($foundUser['userID'] === $userID) {
        // passed user and found user match, so we're good!
        return true;
    }

    // invalid
    return false;
}


/**
 * Move a value in an array to a new position
 *
 * @param $array (ARRAY) we're rearranging
 * @param $val (MIXED) of element you want to move
 * @param $to MIXED (INT/STRING) 'first', 'last', INT of the position you want to move it to
 * @return ARRAY of rearranged IDs
 */
function move($array, $val, $to) {

    // The default is to insert and shift the current item in that position forward
    //
    //                    (moved to 5)
    //                         |
    // move(5) means 0 1 2 3 4 5 6 7 8 9 10
    //                           |
    //                 (was at 5, moved to 6)
    //
    // helpers: 'first', 'last'

    // validate it
    // it not INT or 'first' or 'last'
    if(!is_numeric ($to)) {
        // see if we're using a keyword instead
        switch ($to) {
            case 'first':
                $to = 0;
                break;
            case 'last':
                $to = count($array);
                break;
            default:
                throw new \Error('$to must be "first", "last", or an integer.');
        }
    }

    // make sure we're not moving it to a location that's not possible with this array. If it's greater than array count, just set it as the last one
    if(count($array) < $to) {
        $to = count($array);
    } elseif($to <= -1) {
        $to = 0;
    }

    // get index of the one you want to move
    $index = array_search($val, $array);
    // find the position of the element we want to move
    $from = array_splice($array, $index, 1);


    // actually move it
    array_splice($array, $to, 0, $from);
    return $array;
}
