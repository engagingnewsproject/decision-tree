<?php
namespace Cme\Template;
/**
 * collection of helper functions for handlebars php implementation.
 * each helper here should match the JS helpers in assets/js/handlebars-helpers.js
 * Each helper has to be register in \Cme\Template\Compile.php -> compile()
 */
class Helpers {

    function __construct() {

    }

    /**
    * Get a group title by ID
    */
    public static function environment($options) {
        return 'no-js';
    }

    /**
    * Find out if this question starts a group
    */
    public static function groupStart($questionID, $groups, $options) {
        foreach($groups as $group) {
            // check if it's the first in the question order
            if($group['questions'][0] === $questionID) {
                // set the context of the values we'll need
                return $options['fn'](["groupID"=>$group['ID'], "groupTitle"=>$group['title']]);
            }
        }
        return '';
    }

    /**
    * Find out if this question ends a group
    */
    public static function groupEnd($questionID, $groups, $options) {
        foreach($groups as $group) {
            // check if it's the first in the question order
            $last_question = array_values(array_slice($group['questions'], -1))[0];
            if($last_question === $questionID) {
                return $options['fn']();
            }
        }
        return '';
    }

    public static function elNumber($order) {
        return $order + 1;
    }

    // we don't need this function for the php version
    public static function destination($destinationID, $destinationType, $optionID, $questionIndex, $options) {
        return '';
    }
}

?>
