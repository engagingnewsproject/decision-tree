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

    public static function starts_group($question_id, $group_id, $groups, $options) {
        foreach($groups as $group) {
            if($group['group_id'] === $group_id) {
                // check if it's the first in the question order
                if($group['questions'][0] === $question_id) {
                    return $options['fn']($html);
                } else {
                    return '';
                }
            }
        }
    }

    public static function ends_group($question_id, $group_id, $groups, $options) {
        foreach($groups as $group) {
            if($group['group_id'] === $group_id) {
                // check if it's the first in the question order
                $last_question = array_values(array_slice($group['questions'], -1))[0];
                if($last_question === $question_id) {
                    return $options['fn']($html);
                } else {
                    return '';
                }
            }
        }
    }
}

 ?>
