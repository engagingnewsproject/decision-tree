<?php
use PHPUnit\Framework\TestCase;
use Cme\Database as Database;
use Cme\Utility as Utility;

/**
 * @covers Cme\Database
 */
final class DBTest extends TreeTestCase
{
    protected $db;

    protected function setUp()
    {

        $this->db = new Database\DB();
    }

    /**
    * Dynamically uses getter functions (like get_questions) and returns the results
    *
    * @param $el_type STRING of the el type you want ('question', 'end', 'group', or )
    * @return ARRAY of first result from get_$el_typeS vs get_$el_type($el_id)
    */
    public function getAllDynamic($el_type, $tree_id) {
        $get_all_function = 'get_'.$el_type.'s';
        return $this->db->$get_all_function($tree_id);
    }

    /**
    * Dynamically uses single getter functions (like get_question) and returns the result
    *
    * @param $el_type STRING of the el type you want ('question', 'end', 'group', or 'start')
    * @return ARRAY of first result from get_$el_typeS vs get_$el_type($el_id)
    */
    public function getOneDynamic($el_type, $tree_id, $el_id = false) {
        if($el_id === false) {
            // let's find one
            $el_id = $this->getAllDynamic($el_type, $tree_id)[0][$el_type.'_id'];
        }
        $get_one_function = 'get_'.$el_type;
        return $this->db->$get_one_function($el_id);
    }

    /**
    *
    */
    public function getOneOptionDynamic($tree_id) {

    }
    /**
     * @covers Cme\Database\fetch_all_by_tree()
     * @covers Cme\Database\fetch_all()
     * @covers Cme\Database\query()
     * @dataProvider testFetchAllByTreeProvider
     */
    public function testFetchAllByTree($view, $tree_id, $options, $expected_key, $expected) {
        $result = $this->db->fetch_all_by_tree($view, $tree_id, $options);
        $this->evaluateAssert(isset($result[0][$expected_key]), $expected);
    }

    public function testFetchAllByTreeProvider() {
        return [
                //'valid-1'=>['123456789', true],
                'valid-1'=>['tree_start', 1, [], 'start_id', true],
                'valid-2'=>['tree_group', 1, [], 'group_id', true],
                'invalid-1'=>['tree_start', 1, [], 'asdfasdf', false],
        ];
    }

    /**
     * @covers Cme\Database\fetch_one_by_view()
     * @dataProvider testFetchOneByViewProvider
     */
    public function testFetchOneByView($el_type, $tree_id) {
        // get all questions for tree 1
        $get_function = 'get_'.$el_type.'s';
        $els = $this->db->$get_function($tree_id);
        // pick the first one
        if(isset($els[0]["${el_type}_id"])) {
            $el_id = $els[0]["${el_type}_id"];
        } else {
            // force it to fail
            $this->assertEquals(true, false);
        }

        $result = $this->db->fetch_one_by_view($el_type, $el_id, $tree_id);
        $this->assertEquals($el_id, $result["${el_type}_id"]);
    }

    public function testFetchOneByViewProvider() {
        return [
                'valid-question'=>['question', 1],
                'valid-group'=>['group', 1],
        ];
    }

    /**
     * Gets all of an element types and then tries to get the first of a type
     * and tests if the IDs equal.
     * For example, when testing 'question', it will do get_questions(), grab the first
     * result and then try to get that result using get_question and see if it matches
     *
     * @covers Cme\Database\get_starts()
     * @covers Cme\Database\get_start()
     * @covers Cme\Database\get_questions()
     * @covers Cme\Database\get_question()
     * @covers Cme\Database\get_groups()
     * @covers Cme\Database\get_group()
     * @covers Cme\Database\get_ends()
     * @covers Cme\Database\get_end()
     * @covers Cme\Database\fetch_one_by_view()
     * @covers Cme\Database\fetch_all()
     * @covers Cme\Database\query()
     * @dataProvider testGettersProvider
     */
    public function testGetters($el_type, $tree_id) {

        $first_result = $this->getAllDynamic($el_type, $tree_id)[0];
        $one_result = $this->getOneDynamic($el_type, $tree_id);

        $this->assertEquals($first_result, $one_result);
    }

    public function testGettersProvider() {
        return [
                'get_questions'=>['question', 1],
                'get_groups'=>['group', 1],
                'get_starts'=>['start', 1],
                'get_ends'=>['end', 1]
        ];
    }

    /**
     * Gets all questions for a tree, then gets all options for the first question
     * and then gets one option by id to see if everything matches
     *
     * @covers Cme\Database\get_questions()
     * @covers Cme\Database\get_options()
     * @covers Cme\Database\get_option()
     * @dataProvider testGetOptionsProvider
     */
    public function testGetOptions($tree_id) {

        $questions = $this->db->get_questions($tree_id);
        $question_id = $questions[0]['question_id'];

        $options = $this->db->get_options($question_id);

        foreach($options as $option) {
            $this->assertEquals($option, $this->db->get_option($option['option_id']));
           ;
        }
    }

    public function testGetOptionsProvider() {
        return [
                'tree_one'=>[1],
        ];
    }

    /**
     * @covers Cme\Database\validate_tree_id()
     * @dataProvider testValidateTreeIDProvider
     */
    public function testValidateTreeID($tree_id, $expected) {
        $this->evaluateAssert($this->db->validate_tree_id($tree_id), $expected);
    }

    public function testValidateTreeIDProvider() {
        return [
                'valid_tree'=>[1, true],
                'invalid_tree'=>[123124143423423, false],
                'invalid_tree_slug' => ['hitherestres', false]
        ];
    }

    /**
     * @covers Cme\Database\validate_el_type_id()
     * @covers Cme\Database\validate_option_id()
     * @dataProvider testValidateElTypeIDProvider
     */
    public function testValidateElTypeID($tree_id, $el_type, $expected) {
        if($el_type === 'option') {
            $question = $this->getOneDynamic('question', $tree_id);
            $options = $this->db->get_options($question['question_id']);
            $result = $options[0];
            $el_type_id = $options[0]['option_id'];
        }
        elseif($el_type === 'blarg') {
            // set the ID from a question
            $question = $this->getOneDynamic('question', $tree_id);
            $el_type_id = $question['question_id'];
        }
        elseif($el_type === 'invalid_question_id') {
            $el_type = 'question';
            $el_type_id = $tree_id;
        }
        elseif($el_type === 'false_id') {
            $el_type = 'question';
            $el_type_id = false;
        }
        else {
            $result = $this->getOneDynamic($el_type, $tree_id);
            $el_type_id = $result[$el_type.'_id'];
        }

        $this->evaluateAssert($this->db->validate_el_type_id($tree_id, $el_type_id, $el_type), $expected);
    }

    public function testValidateElTypeIDProvider() {
        return [
                'valid_question'=>[1, 'question', true],
                'valid_option'=>[1, 'option', true],
                'valid_group' => [1, 'group', true],
                'valid_start' => [1, 'start', true],
                'valid_end' => [1, 'end', true],
                'invalid_type'=> [1, 'blarg', false],
                'invalid_id'=> [1, 'invalid_question_id', false],
                'invalid_false_id'=> [1, 'false_id', false],
        ];
    }

}
