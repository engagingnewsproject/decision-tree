<?php
use PHPUnit\Framework\TestCase;
use Cme\Database as Database;
use Cme\Utility as Utility;

/**
 * @covers Cme\Database
 */
final class GetTest extends DBTestCase
{
    protected function setUp()
    {
        $this->get = new Database\Get();
    }
    /**
     * @covers Cme\Database\fetch_all_by_tree()
     * @covers Cme\Database\fetch_all()
     * @covers Cme\Database\query()
     * @dataProvider testFetchAllByTreeProvider
     */
    public function testFetchAllByTree($view, $tree_id, $options, $expected_key, $expected) {
        $result = $this->get->fetch_all_by_tree($view, $tree_id, $options);
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
        $el = $this->getOneDynamic($el_type, $tree_id);
        $el_id = $el[$el_type.'_id'];

        $result = $this->get->fetch_one_by_view($el_type, $el_id, $tree_id);
        $this->assertEquals($el_id, $result["${el_type}_id"]);
    }

    public function testFetchOneByViewProvider() {
        return [
                'valid-question'=>['question', 1],
                'valid-group'=>['group', 1],
        ];
    }

    /**
     * Gets all trees, loops 5 of them to test get_tree by id and get_tree_by_slug for each
     * and makes sure it matches
     *
     * @covers Cme\Database\get_trees()
     * @covers Cme\Database\get_tree()
     * @covers Cme\Database\get_tree_by_slug()
     */
    public function testGetTrees() {
        // get all trees
        $trees = $this->get->get_trees();
        $i = 0;
        // loop 5 of them and test each
        foreach($trees as $tree) {
            // get one tree off of the tree_id
            $getTree = $this->get->get_tree($tree['tree_id']);
            // the tree_ids should match
            $this->assertEquals($tree, $getTree);
            // get tree by slug
            $getTreeBySlug = $this->get->get_tree_by_slug($tree['tree_slug']);
            // the tree_ids should match
            $this->assertEquals($tree, $getTreeBySlug);
            if(5 < $i++) {
                break;
            }
        }
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

        $question = $this->getOneDynamic('question', $tree_id);
        $question_id = $question['question_id'];
        $options = $this->get->get_options($question_id);

        foreach($options as $option) {
            $this->assertEquals($option, $this->get->get_option($option['option_id']));
           ;
        }

        // do one failure test for get_options
        $this->assertFalse($this->get->get_options(999999999999999999));

        // do one failure test for get_option
        $this->assertFalse($this->get->get_option(999999999999999999));
    }
}
