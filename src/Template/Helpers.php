<?php
namespace Enp\Template;
/**
 * collection of helper functions for handlebars php implementation.
 * each helper here should match the JS helpers in assets/js/handlebars-helpers.js
 * Each helper has to be register in \Enp\Template\Compile.php -> compile()
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
    public static function group_start($question_id, $group_id, $groups, $options) {
        foreach($groups as $group) {
            if($group['group_id'] === $group_id) {
                // check if it's the first in the question order
                if($group['questions'][0] === $question_id) {
                    return $options['fn']($group['title']);
                } else {
                    return '';
                }
            }
        }
        return '';
    }

    /**
    * Find out if this question ends a group
    */
    public static function group_end($question_id, $group_id, $groups, $options) {
        foreach($groups as $group) {
            if($group['group_id'] === $group_id) {
                // check if it's the first in the question order
                $last_question = array_values(array_slice($group['questions'], -1))[0];
                if($last_question === $question_id) {
                    return $options['fn']();
                } else {
                    return '';
                }
            }
        }
        return '';
    }

    /**
    * Get a group title by ID
    */
    public static function group_title($group_id, $groups, $options) {

        foreach($groups as $group) {
            if($group['group_id'] === $group_id) {
                return $options['fn']($group['group_title']);
            }
        }
        return '';
    }
}

?>
