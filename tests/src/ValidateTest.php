<?php
use PHPUnit\Framework\TestCase;
use Cme\Database as Database;
use Cme\Utility as Utility;

/**
 * @covers Cme\Database
 */
final class ValidateTest extends DBTestCase
{
    protected function setUp()
    {
        $this->validate = new Database\Validate();
    }
    /**
     * @covers Cme\Database\validate_tree_id()
     * @dataProvider testValidateTreeIDProvider
     */
    public function testValidateTreeID($tree_id, $expected) {
        $this->evaluateAssert($this->validate->validate_tree_id($tree_id), $expected);
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
        $this->evaluateAssert($this->validate->validate_el_type_id($el_type, $el_type_id, $tree_id), $expected);
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
        $this->evaluateAssert($this->validate->validate_option_id($option_id, $tree_id), $expected);
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
        $this->evaluateAssert($this->validate->validate_question_id($question_id, $tree_id), $expected);
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
        $this->evaluateAssert($this->validate->validate_end_id($end_id, $tree_id), $expected);
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
        $this->evaluateAssert($this->validate->validate_group_id($group_id, $tree_id), $expected);
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
        $this->evaluateAssert($this->validate->validate_start_id($start_id, $tree_id), $expected);
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
        $this->evaluateAssert($this->validate->validate_destination_id($destination_id, $options), $expected);
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
        $this->evaluateAssert($this->validate->validate_interaction_type($interaction_type), $expected);
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

    /**
     * @covers Cme\Database\validate_state_type()
     * @dataProvider testValidateStateTypeProvider
     */
    public function testValidateStateType($state_type, $expected) {
        $this->evaluateAssert($this->validate->validate_state_type($state_type), $expected);
    }

    public function testValidateStateTypeProvider() {
        $state_types = ['intro', 'question', 'end', 'overview'];

        $provider = [
            'invalid_empty'   => ['', false],
            'invalid_type'    => ['adfasdfasdfa', false],
            'invalid_format'  => [123, false]
        ];

        foreach($state_types as $type) {
            $provider[$type] = [$type, true];
        }

        return $provider;
    }
}
