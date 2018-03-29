<?php
/**
* Data validation functions for verifying data
*
* @since 0.0.1
* @author jones.jeremydavid@gmail.com
**/


namespace Cme\Database;
use Cme\Utility as Utility;
use PDO;

class Validate extends DB {
    public function __construct() {
        // create a GET instance
        $this->get = new Get();
    }

    // Make sure the tree_id exists
    public function validate_tree_id($tree_id) {
        $is_valid = false;

        // try to get the tree by id
        $tree = $this->get->get_tree($tree_id);
        // see if the tree_id exists in the returned results and if that tree_id equals the passed tree_id
        if(isset($tree['tree_id']) && $tree['tree_id'] == $tree_id) {
            $is_valid = true;
        }

        return $is_valid;
    }

    // Make sure the id is what it's supposed to be ( ie, that el_id 2 is a 'question')
    /**
     * Validates that an ID is an ID of a certain type. IE if you need to know that
     * ID #2 is a question, use this.
     *
     * @param $el_type STRING of the element type (ex: question, option, end, etc)
     * @param $el_type_id INT
     * @param $tree_id INT (OPTIONAL) strict mode if you want to validate by tree id as well
     * @return BOOLEAN
     */
    public function validate_el_type_id($el_type, $el_type_id, $tree_id = false) {

        $is_valid = false;

        // Query the $el_type_id
        $whitelist = ['question', 'option', 'end', 'start', 'group'];
        if(!in_array($el_type, $whitelist)) {
            return false;
        }

        // get the element
        if($el_type === 'option') {
            $el_data = $this->get->get_option($el_type_id, ['tree_id' => $tree_id]);
        } else {
            // dynamically get the element
        $function = 'get_'.$el_type;
            $el_data = $this->get->$function($el_type_id, $tree_id);
        }

        if(isset($el_data[$el_type.'_id']) && (int)$el_data[$el_type.'_id'] === (int)$el_type_id) {
            $is_valid = true;
        }

        return $is_valid;
    }

    // check if it's a valid option_id
    public function validate_option_id($option_id, $tree_id = false) {
        return $this->validate_el_type_id('option', $option_id, $tree_id);
    }

    public function validate_question_id($question_id, $tree_id = false) {
        return $this->validate_el_type_id('question', $question_id, $tree_id);
    }

    public function validate_group_id($group_id, $tree_id = false) {
        return $this->validate_el_type_id('group', $group_id, $tree_id);
    }

    public function validate_end_id($end_id, $tree_id = false) {
        return $this->validate_el_type_id('end', $end_id, $tree_id);
    }

    public function validate_start_id($start_id, $tree_id = false) {
        return $this->validate_el_type_id('start', $start_id, $tree_id);
    }

    /**
     * Validates that an ID is a valid destination ID by checking if it's
     * a question or end ID
     *
     * @param $id INT
     * @param $options ARRAY (optional) Faster check if these are provided ['el_type' => 'question', 'tree_id'=>1]
     * @return BOOLEAN
     */
    public function validate_destination_id($id, $options = []) {
        // see if there's a desired type
        $el_type = false;
        $tree_id = false;
        $whitelist = ['end', 'question'];

        // check for a passed type
        if( isset($options['el_type']) && in_array($options['el_type'], $whitelist) ) {
            $el_type = $options['el_type'];
        }

        // check for a passed tree ID
        if( isset($options['tree_id']) && Utility\is_id($options['tree_id'])) {
            $tree_id = $options['tree_id'];
        }

        // if no $el_type was passed, check all possible destination types (question and end)
        if($el_type === false) {
            // try to get this destination by both question and end
            foreach($whitelist as $el_type) {
                $is_valid = $this->validate_el_type_id($el_type, $id, $tree_id);
                if($is_valid === true) {
                    // if we have a valid destination ID, break out and return
                    break;
                }
            }
        } else {
            // get it only by the passed ID
            $is_valid = $this->validate_el_type_id($el_type, $id, $tree_id);
        }

        return $is_valid;
    }

    /**
     * Validates interaction type, such as 'load', 'start', 'option', etc
     *
     * @param $interaction_type STRING
     * @return BOOLEAN
     */
    public function validate_interaction_type($interaction_type) {
        $is_valid = false;

        // if we can find that interaction type and it matches the passed one, it's valid
        $get_interaction = $this->get->get_interaction_type($interaction_type);
        if(isset($get_interaction['interaction_type']) && $get_interaction['interaction_type'] === $interaction_type) {
            $is_valid = true;
        }

        return $is_valid;
    }

    // Make sure the state type exists
    public function validate_state_type($state_type) {
        $is_valid = false;

        // if we can find that state type and it matches the passed one, it's valid
        $get_state = $this->get->get_state_type($state_type);
        if(isset($get_state['state_type']) && $get_state['state_type'] === $state_type) {
            $is_valid = true;
        }

        return $is_valid;
    }

    // Make sure the site exists
    public function validate_site($site) {
        $is_valid = false;
        // if we can find that site, it's valid
        if($this->get->get_site($site) !== false) {
            $is_valid = true;
        }

        return $is_valid;
    }

    // Make sure the embed exists
    public function validate_embed($embed, $options) {
        $is_valid = false;
        // if we can find that embed, it's valid
        if($this->get->get_embed($embed, $options) !== false) {
            $is_valid = true;
        }

        return $is_valid;
    }
}
