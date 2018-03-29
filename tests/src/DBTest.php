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
        $db = new Database\DB();
        $get_all_function = 'get_'.$el_type.'s';

        return $db->$get_all_function($tree_id);
    }

    /**
    * Dynamically uses single getter functions (like get_question) and returns the result
    *
    * @param $el_type STRING of the el type you want ('question', 'end', 'group', or 'start')
    * @return ARRAY of first result from get_$el_typeS vs get_$el_type($el_id)
    */
    public function getOneDynamic($el_type, $tree_id, $el_id = false) {
        $db = new Database\DB();

        if($el_type === 'option') {
            return $this->getOneOptionDynamic($tree_id);
        }

        if($el_id === false) {
            // let's find one
            $el_id = $this->getAllDynamic($el_type, $tree_id)[0][$el_type.'_id'];
        }
        $get_one_function = 'get_'.$el_type;
        return $db->$get_one_function($el_id);
    }

    /**
    * Gets an option row from a tree
    */
    public function getOneOptionDynamic($tree_id) {
        $db = new Database\DB();

        $question = $this->getOneDynamic('question', $tree_id);
        $options = $db->get_options($question['question_id']);
        return $options[0];
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
     */
    public function testGetOptions() {
        $tree_id = 1;
        $questions = $this->db->get_questions($tree_id);
        $question_id = $questions[0]['question_id'];

        $options = $this->db->get_options($question_id);

        foreach($options as $option) {
            $this->assertEquals($option, $this->db->get_option($option['option_id']));
           ;
        }

        // do one failure test for get_options
        $this->assertFalse($this->db->get_options(999999999999999999));

        // do one failure test for get_option
        $this->assertFalse($this->db->get_option(999999999999999999));
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
     * @dataProvider testValidateElTypeIDProvider
     */
    public function testValidateElTypeID($el_type, $el_type_id, $tree_id, $expected) {
        $this->evaluateAssert($this->db->validate_el_type_id($el_type, $el_type_id, $tree_id), $expected);
    }

    public function testValidateElTypeIDProvider() {

        $provider =  [
                'invalid_type'=> ['blarg', 2, 1, false],
                'invalid_question_id'=> ['question', 1, false, false]
        ];

        $types = ['option', 'question', 'group', 'end', 'start'];
        $tree_id = 1;
        // loops through each type and gets a valid id for that type
        foreach($types as $type) {
            $valid_el_id = $this->getOneDynamic($type, $tree_id)[$type.'_id'];
            $provider['valid_'.$type.'_with_tree'] = [$type, $valid_el_id, $tree_id, true];
            $provider['valid_'.$type.'_without_tree'] = [$type, $valid_el_id, false, true];
            $provider['invalid_tree_with_valid_'.$type] = [$type, $valid_el_id, 999999999999999999, false];
        }

        return $provider;
    }

    /**
     * @covers Cme\Database\validate_option_id()
     * @dataProvider testValidateOptionIDProvider
     */
    public function testValidateOptionID($option_id, $tree_id, $expected) {
        $this->evaluateAssert($this->db->validate_option_id($option_id, $tree_id), $expected);
    }

    public function testValidateOptionIDProvider() {
        $option_id = $this->getOneDynamic('option', 1)['option_id'];
        return  [
            'valid'                 => [$option_id, false, true],
            'valid_with_tree_id'    => [$option_id, 1, true],
            'valid_option_with_invalid_tree_id' => [$option_id, 99999999999, false],
            'invalid'               => [9999999999999, false, false],
            'invalid_with_tree_id'  => [9999999999999, 1, false]
        ];
    }

    /**
     * @covers Cme\Database\validate_question_id()
     * @dataProvider testValidateQuestionIDProvider
     */
    public function testValidateQuestionID($question_id, $tree_id, $expected) {
        $this->evaluateAssert($this->db->validate_question_id($question_id, $tree_id), $expected);
    }

    public function testValidateQuestionIDProvider() {
        $question_id = $this->getOneDynamic('question', 1)['question_id'];
        return  [
            'valid'                 => [$question_id, false, true],
            'valid_with_tree_id'    => [$question_id, 1, true],
            'valid_question_with_invalid_tree_id' => [$question_id, 99999999999, false],
            'invalid'               => [9999999999999, false, false],
            'invalid_with_tree_id'  => [9999999999999, 1, false]
        ];
    }

    /**
     * @covers Cme\Database\validate_end_id()
     * @dataProvider testValidateEndIDProvider
     */
    public function testValidateEndID($end_id, $tree_id, $expected) {
        $this->evaluateAssert($this->db->validate_end_id($end_id, $tree_id), $expected);
    }

    public function testValidateEndIDProvider() {
        $end_id = $this->getOneDynamic('end', 1)['end_id'];
        $question_id = $this->getOneDynamic('question', 1)['question_id'];
        return  [
            'valid'                 => [$end_id, false, true],
            'valid_with_tree_id'    => [$end_id, 1, true],
            'valid_end_with_invalid_tree_id' => [$end_id, 99999999999, false],
            'invalid'               => [$question_id, false, false],
            'invalid_with_tree_id'  => [9999999999999, 1, false]
        ];
    }


    /**
     * @covers Cme\Database\validate_group_id()
     * @dataProvider testValidateGroupIDProvider
     */
    public function testValidateGroupID($group_id, $tree_id, $expected) {
        $this->evaluateAssert($this->db->validate_group_id($group_id, $tree_id), $expected);
    }

    public function testValidateGroupIDProvider() {
        $group_id = $this->getOneDynamic('group', 1)['group_id'];
        $question_id = $this->getOneDynamic('question', 1)['question_id'];
        return  [
            'valid'                 => [$group_id, false, true],
            'valid_with_tree_id'    => [$group_id, 1, true],
            'valid_group_with_invalid_tree_id' => [$group_id, 99999999999, false],
            'invalid'               => [$question_id, false, false],
            'invalid_with_tree_id'  => [9999999999999, 1, false]
        ];
    }

    /**
     * @covers Cme\Database\validate_start_id()
     * @dataProvider testValidateStartIDProvider
     */
    public function testValidateStartID($start_id, $tree_id, $expected) {
        $this->evaluateAssert($this->db->validate_start_id($start_id, $tree_id), $expected);
    }

    public function testValidateStartIDProvider() {
        $start_id = $this->getOneDynamic('start', 1)['start_id'];
        $question_id = $this->getOneDynamic('question', 1)['question_id'];
        return  [
            'valid'                 => [$start_id, false, true],
            'valid_with_tree_id'    => [$start_id, 1, true],
            'valid_start_with_invalid_tree_id' => [$start_id, 99999999999, false],
            'invalid'               => [$question_id, false, false],
            'invalid_with_tree_id'  => [9999999999999, 1, false]
        ];
    }

    /**
     * @covers Cme\Database\validate_destination_id()
     * @dataProvider testValidateDestinationIDProvider
     */
    public function testValidateDestinationID($destination_id, $options, $expected) {
        $this->evaluateAssert($this->db->validate_destination_id($destination_id, $options), $expected);
    }

    public function testValidateDestinationIDProvider() {
        $start_id = $this->getOneDynamic('start', 1)['start_id'];
        $end_id = $this->getOneDynamic('end', 1)['end_id'];
        $question_id = $this->getOneDynamic('question', 1)['question_id'];

        return  [
            'end_id'             => [$end_id, ['el_type' => 'end'], true],
            'end_id_with_tree'   => [$end_id, ['el_type' => 'end', 'tree_id'=>1], true],
            'end_id_no_options'  => [$end_id, [], true],
            'question_id'             => [$question_id, ['el_type' => 'question'], true],
            'question_id_with_tree'   => [$question_id, ['el_type' => 'question', 'tree_id'=>1], true],
            'question_id_no_options'  => [$question_id, [], true],
            'invalid_id'               => [$start_id, ['el_type' => 'question'], false],
            'invalid_end_id_with_tree'   => [$start_id, ['el_type' => 'end', 'tree_id'=>1], false],
            'invalid_end_id_no_options'  => [$start_id, [], false],
        ];
    }

    /**
     * @covers Cme\Database\validate_interaction_type()
     * @dataProvider testValidateInteractionTypeProvider
     */
    public function testValidateInteractionType($interaction_type, $expected) {
        $this->evaluateAssert($this->db->validate_interaction_type($interaction_type), $expected);
    }

    public function testValidateInteractionTypeProvider() {
        $interaction_types = ['load', 'reload', 'start', 'overview', 'option', 'history', 'restart'];

        $provider = [
            'invalid_empty'   => ['', false],
            'invalid_type'    => ['adfasdfasdfa', false],
            'invalid_format'  => [123, false]
        ];

        foreach($interaction_types as $type) {
            $provider[$type] = [$type, true];
        }

        return $provider;
    }
}
