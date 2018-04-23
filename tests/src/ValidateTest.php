<?php
use PHPUnit\Framework\TestCase;
use Cme\Database as Database;
use Cme\Utility as Utility;

/**
 * @covers Cme\Database
 */
final class ValidateTest extends TreeTestCase
{
    protected function setUp()
    {
        $this->validate = new Database\Validate();
    }

    /**
     * @covers Cme\Database\Validate\tree()
     * @dataProvider validateTreeProvider
     */
    public function testValidateTree($tree, $expected) {
        $this->evaluateAssert($this->validate->tree($tree), $expected);
    }

    public function validateTreeProvider() {
        return [
                'treeID'=>[1, true],
                'treeSlug' => ['citizen', true],
                'invalid_treeID'=>[123124143423423, false],
                'invalid_treeSlug' => ['hitherestres', false],
                'invalid_boolean' => [true, false]
        ];
    }

    /**
     * @covers Cme\Database\Validate\treeID()
     * @dataProvider validateTreeIdProvider
     */
    public function testValidateTreeId($treeID, $expected) {
        $this->evaluateAssert($this->validate->treeID($treeID), $expected);
    }

    public function validateTreeIdProvider() {
        return [
                'valid_tree'=>[1, true],
                'invalid_tree'=>[123124143423423, false],
                'invalid_treeSlug' => ['hitherestres', false],
                'invalid_butExists' => ['citizen', false]
        ];
    }

    /**
     * @covers Cme\Database\Validate\treeSlug()
     * @dataProvider validateTreeSlugProvider
     */
    public function testValidateTreeSlug($treeSlug, $expected) {
        $this->evaluateAssert($this->validate->treeSlug($treeSlug), $expected);
    }

    public function validateTreeSlugProvider() {
        return [
                'valid_tree'=>['citizen', true],
                'invalid_treeSlug'=>[123124143423423, false],
                'invalid_notFoundtreeSlug' => ['hithereadfasasdfstres', false],
                'invalid_boolean' => [true, false]
        ];
    }

    /**
     * @covers Cme\Database\Validate\elTypeID()
     * @dataProvider validateElTypeIdProvider
     */
    public function testValidateElTypeId($elType, $elTypeID, $treeID, $expected) {
        $this->evaluateAssert($this->validate->elTypeID($elType, $elTypeID, $treeID), $expected);
    }

    public function validateElTypeIdProvider() {

        $provider =  [
                'invalid_type'=> ['blarg', 2, 1, false],
                'invalid_questionID'=> ['question', 1, false, false]
        ];

        $types = ['option', 'question', 'group', 'end', 'start'];
        $treeID = 1;
        // loops through each type and gets a valid id for that type
        foreach($types as $type) {
            $valid_elID = $this->getOneDynamic($type, $treeID)[$type.'ID'];
            $provider['valid_'.$type.'_with_tree'] = [$type, $valid_elID, $treeID, true];
            $provider['valid_'.$type.'_without_tree'] = [$type, $valid_elID, false, true];
            $provider['invalid_tree_with_valid_'.$type] = [$type, $valid_elID, 999999999999999999, false];
        }

        return $provider;
    }

    /**
     * @covers Cme\Database\Validate\optionID()
     * @dataProvider validateOptionIdProvider
     */
    public function testValidateOptionId($optionID, $treeID, $expected) {
        $this->evaluateAssert($this->validate->optionID($optionID, $treeID), $expected);
    }

    public function validateOptionIdProvider() {
        $optionID = $this->getOneDynamic('option', 1)['optionID'];
        return  [
            'valid'                 => [$optionID, false, true],
            'valid_with_treeID'    => [$optionID, 1, true],
            'valid_option_with_invalid_treeID' => [$optionID, 99999999999, false],
            'invalid'               => [9999999999999, false, false],
            'invalid_with_treeID'  => [9999999999999, 1, false]
        ];
    }

    /**
     * @covers Cme\Database\Validate\questionID()
     * @dataProvider validateQuestionIdProvider
     */
    public function testValidateQuestionId($questionID, $treeID, $expected) {
        $this->evaluateAssert($this->validate->questionID($questionID, $treeID), $expected);
    }

    public function validateQuestionIdProvider() {
        $questionID = $this->getOneDynamic('question', 1)['questionID'];
        return  [
            'valid'                 => [$questionID, false, true],
            'valid_with_treeID'    => [$questionID, 1, true],
            'valid_question_with_invalid_treeID' => [$questionID, 99999999999, false],
            'invalid'               => [9999999999999, false, false],
            'invalid_with_treeID'  => [9999999999999, 1, false]
        ];
    }

    /**
     * @covers Cme\Database\Validate\endID()
     * @dataProvider validateEndIdProvider
     */
    public function testValidateEndId($endID, $treeID, $expected) {
        $this->evaluateAssert($this->validate->endID($endID, $treeID), $expected);
    }

    public function validateEndIdProvider() {
        $endID = $this->getOneDynamic('end', 1)['endID'];
        $questionID = $this->getOneDynamic('question', 1)['questionID'];
        return  [
            'valid'                 => [$endID, false, true],
            'valid_with_treeID'    => [$endID, 1, true],
            'valid_end_with_invalid_treeID' => [$endID, 99999999999, false],
            'invalid'               => [$questionID, false, false],
            'invalid_with_treeID'  => [9999999999999, 1, false]
        ];
    }


    /**
     * @covers Cme\Database\Validate\groupID()
     * @dataProvider validateGroupIdProvider
     */
    public function testValidateGroupId($groupID, $treeID, $expected) {
        $this->evaluateAssert($this->validate->groupID($groupID, $treeID), $expected);
    }

    public function validateGroupIdProvider() {
        $groupID = $this->getOneDynamic('group', 1)['groupID'];
        $questionID = $this->getOneDynamic('question', 1)['questionID'];
        return  [
            'valid'                 => [$groupID, false, true],
            'valid_with_treeID'    => [$groupID, 1, true],
            'valid_group_with_invalid_treeID' => [$groupID, 99999999999, false],
            'invalid'               => [$questionID, false, false],
            'invalid_with_treeID'  => [9999999999999, 1, false]
        ];
    }

    /**
     * @covers Cme\Database\Validate\startID()
     * @dataProvider validateStartIdProvider
     */
    public function testValidateStartId($startID, $treeID, $expected) {
        $this->evaluateAssert($this->validate->startID($startID, $treeID), $expected);
    }

    public function validateStartIdProvider() {
        $startID = $this->getOneDynamic('start', 1)['startID'];
        $questionID = $this->getOneDynamic('question', 1)['questionID'];
        return  [
            'valid'                 => [$startID, false, true],
            'valid_with_treeID'    => [$startID, 1, true],
            'valid_start_with_invalid_treeID' => [$startID, 99999999999, false],
            'invalid'               => [$questionID, false, false],
            'invalid_with_treeID'  => [9999999999999, 1, false]
        ];
    }

    /**
     * @covers Cme\Database\Validate\destinationID()
     * @dataProvider validateDestinationIdProvider
     */
    public function testValidateDestinationId($destinationID, $options, $expected) {
        $this->evaluateAssert($this->validate->destinationID($destinationID, $options), $expected);
    }

    public function validateDestinationIdProvider() {
        $startID = $this->getOneDynamic('start', 1)['startID'];
        $endID = $this->getOneDynamic('end', 1)['endID'];
        $questionID = $this->getOneDynamic('question', 1)['questionID'];

        return  [
            'endID'             => [$endID, ['el_type' => 'end'], true],
            'endID_with_tree'   => [$endID, ['el_type' => 'end', 'treeID'=>1], true],
            'endID_no_options'  => [$endID, [], true],
            'questionID'             => [$questionID, ['el_type' => 'question'], true],
            'questionID_with_tree'   => [$questionID, ['el_type' => 'question', 'treeID'=>1], true],
            'questionID_no_options'  => [$questionID, [], true],
            'invalidID'               => [$startID, ['el_type' => 'question'], false],
            'invalid_endID_with_tree'   => [$startID, ['el_type' => 'end', 'treeID'=>1], false],
            'invalid_endID_no_options'  => [$startID, [], false],
        ];
    }

    /**
     * @covers Cme\Database\Validate\interactionType()
     * @dataProvider validateInteractionTypeProvider
     */
    public function testValidateInteractionType($interactionType, $expected) {
        $this->evaluateAssert($this->validate->interactionType($interactionType), $expected);
    }

    public function validateInteractionTypeProvider() {
        $interactionTypes = ['load', 'reload', 'start', 'overview', 'option', 'history', 'restart'];

        $provider = [
            'invalid_empty'   => ['', false],
            'invalid_type'    => ['adfasdfasdfa', false],
            'invalid_format'  => [123, false]
        ];

        foreach($interactionTypes as $type) {
            $provider[$type] = [$type, true];
        }

        return $provider;
    }

    /**
     * @covers Cme\Database\Validate\stateType()
     * @dataProvider validateStateTypeProvider
     */
    public function testValidateStateType($state_type, $expected) {
        $this->evaluateAssert($this->validate->stateType($state_type), $expected);
    }

    public function validateStateTypeProvider() {
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

    /**
     * @covers Cme\Database\Validate\site()
     * @dataProvider validateSiteProvider
     */
    public function testValidateSite($state_type, $expected) {
        $this->evaluateAssert($this->validate->site($state_type), $expected);
    }

    public function validateSiteProvider() {
        $sites = ['localhost:3000', 'decision-tree.dev', 1];

        $provider = [
            'invalid_empty'   => ['', false],
            'invalid_site'    => ['adfasdfasdfa', false],
            'invalid_not_exists'  => [99999999999, false]
        ];

        foreach($sites as $site) {
            $provider[$site] = [$site, true];
        }

        return $provider;
    }

    /**
     * @covers Cme\Database\Validate\embed()
     * @dataProvider validateEmbedProvider
     */
    public function testValidateEmbed($embed, $options, $expected) {
        $this->evaluateAssert($this->validate->embed($embed, $options), $expected);
    }

    public function validateEmbedProvider() {
        $embeds = ['/example.php', 1];

        $provider = [
            'invalid_empty'   => ['', [], false],
            'invalid_embed'    => ['adfasdfasdfa', [], false],
            'invalid_format'  => [99999999999, [], false]
        ];

        foreach($embeds as $embed) {
            $provider[$embed] = [$embed, [], true];
            $provider[$embed.'_siteID'] = [$embed, ['siteID' => 1], true];
            $provider[$embed.'_treeID'] = [$embed, ['treeID' => 1], true];
            $provider[$embed.'_siteID_treeID'] = [$embed, ['treeID' => 1, 'siteID' => 1], true];
            $provider[$embed.'_invalid_treeID'] = [$embed, ['treeID' => 9999999999], false];
            $provider[$embed.'_invalid_siteID'] = [$embed, ['siteID' => 9999999999], false];
        }

        return $provider;
    }
}
