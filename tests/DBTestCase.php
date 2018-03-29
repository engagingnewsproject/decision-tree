<?php
use PHPUnit\Framework\TestCase;
use Cme\Database as Database;

/**
 * Helper functions for DB Tests
 * @covers Cme\Database
 */
class DBTestCase extends TreeTestCase
{
    protected $db;

    protected function setUp()
    {

        $this->get = new Database\Get();
    }

    /**
    * Dynamically uses getter functions (like get_questions) and returns the results
    *
    * @param $el_type STRING of the el type you want ('question', 'end', 'group', or )
    * @return ARRAY of first result from get_$el_typeS vs get_$el_type($el_id)
    */
    public function getAllDynamic($el_type, $tree_id) {
        $get = new Database\Get();
        $get_all_function = 'get_'.$el_type.'s';

        return $get->$get_all_function($tree_id);
    }

    /**
    * Dynamically uses single getter functions (like get_question) and returns the result
    *
    * @param $el_type STRING of the el type you want ('question', 'end', 'group', or 'start')
    * @return ARRAY of first result from get_$el_typeS vs get_$el_type($el_id)
    */
    public function getOneDynamic($el_type, $tree_id, $el_id = false) {
        $get = new Database\Get();

        if($el_type === 'option') {
            return $this->getOneOptionDynamic($tree_id);
        }

        if($el_id === false) {
            // let's find one
            $el_id = $this->getAllDynamic($el_type, $tree_id)[0][$el_type.'_id'];
        }
        $get_one_function = 'get_'.$el_type;
        return $get->$get_one_function($el_id);
    }

    /**
    * Gets an option row from a tree
    */
    public function getOneOptionDynamic($tree_id) {
        $get = new Database\Get();

        $question = $this->getOneDynamic('question', $tree_id);
        $options = $get->get_options($question['question_id']);
        return $options[0];
    }
}
