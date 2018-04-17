<?php
use PHPUnit\Framework\TestCase;
use Cme\Database as Database;
use Cme\Utility as Utility;

/**
 * @covers Cme\Database
 */
final class DBTest extends TreeTestCase
{
    protected function setUp()
    {
        $this->db = new Database\DB();
    }
    /**
     * @covers Cme\Database\fetchAllByTree()
     * @covers Cme\Database\fetchAll()
     * @covers Cme\Database\query()
     * @dataProvider fetchAllByTreeProvider
     */
    public function testFetchAllByTree($view, $treeID, $options, $expected_key, $expected) {
        $result = $this->db->fetchAllByTree($view, $treeID, $options);

        if(!isset($options['fetch'])) {
            $this->assertTrue(is_array($result));
            $this->evaluateAssert(isset($result[0][$expected_key]), $expected);
        } else {
            $this->assertTrue(is_array($result));
            $this->assertTrue(Utility\isID($result[0]));
            $this->assertEquals($result[0], $expected);
        }

    }

    public function fetchAllByTreeProvider() {
        return [
                //'valid-1'=>['123456789', true],
                'fetch all tree starts'=>['treeStart', 1, [], 'startID', true],
                'fetch all tree group'=>['treeGroup', 1, [], 'groupID', true],
                'fetch all question titles'=>['treeQuestion', 1, ['fields'=>'title'], 'title', true],
                'fetch column end ID' => [
                    'treeEnd',
                    1,
                    ['fields' => 'endID', 'fetch' => 'column'],
                    'expected key param not needed',
                    $this->getOneDynamic('end', 1)['endID']
                ],
                'invalid-1'=>['treeStart', 1, [], 'asdfasdf', false],
        ];
    }

    /**
     * @covers Cme\Database\fetchOneByView()
     * @dataProvider fetchOneByViewProvider
     */
    public function testFetchOneByView($elType, $treeID) {
        $el = $this->getOneDynamic($elType, $treeID);
        $elID = $el[$elType.'ID'];

        $result = $this->db->fetchOneByView($elType, $elID, $treeID);
        $this->assertEquals($elID, $result["${elType}ID"]);
    }

    public function fetchOneByViewProvider() {
        return [
                'valid-question'=>['question', 1],
                'valid-group'=>['group', 1],
        ];
    }

    /**
     * Gets all trees, loops 5 of them to test getTree by id and getTreeBySlug for each
     * and makes sure it matches
     *
     * @covers Cme\Database\getTrees()
     * @covers Cme\Database\getTree()
     * @covers Cme\Database\getTreeBySlug()
     */
    public function testGetTrees() {
        // get all trees
        $trees = $this->db->getTrees();
        $i = 0;
        // loop 5 of them and test each
        foreach($trees as $tree) {
            // get one tree off of the treeID
            $getTree = $this->db->getTree($tree['treeID']);
            // the treeIDs should match
            $this->assertEquals($tree, $getTree);
            // get tree by slug
            $getTreeBySlug = $this->db->getTreeBySlug($tree['treeSlug']);
            // the treeIDs should match
            $this->assertEquals($tree, $getTreeBySlug);
            if(5 < $i++) {
                break;
            }
        }
    }

    /**
     * Gets all of an element types and then tries to get the first of a type
     * and tests if the IDs equal.
     * For example, when testing 'question', it will do getQuestions(), grab the first
     * result and then try to get that result using getQuestion and see if it matches
     *
     * @covers Cme\Database\getStarts()
     * @covers Cme\Database\getStart()
     * @covers Cme\Database\getQuestions()
     * @covers Cme\Database\getQuestion()
     * @covers Cme\Database\getGroups()
     * @covers Cme\Database\getGroup()
     * @covers Cme\Database\getEnds()
     * @covers Cme\Database\getEnd()
     * @covers Cme\Database\fetchOneByView()
     * @covers Cme\Database\fetchAll()
     * @covers Cme\Database\query()
     * @dataProvider gettersProvider
     */
    public function testGetters($elType, $treeID) {

        $first_result = $this->getAllDynamic($elType, $treeID)[0];
        $one_result = $this->getOneDynamic($elType, $treeID);

        $this->assertEquals($first_result, $one_result);
    }

    public function gettersProvider() {
        return [
                'getQuestions'=>['question', 1],
                'getGroups'=>['group', 1],
                'getStarts'=>['start', 1],
                'getEnds'=>['end', 1]
        ];
    }

    /**
     * Gets a group and then tries to get all questions by that group and
     * tests to make sure all the returned questions are really in that group
     *
     * @covers Cme\Database\getQuestionsByGroup()
     */
    public function testGetQuestionsByGroup() {
        // get group
        $treeID = 1;
        $group = $this->getOneDynamic('group', $treeID);
        $groupID = $group['groupID'];
        $questionIDs = $this->db->getQuestionsByGroup($groupID);

        // Questions by group id should match if you also pass a tree
        $this->assertEquals($questionIDs, $this->db->getQuestionsByGroup($groupID, $treeID));

        $validate = new Database\Validate();
        // loop each questionID and make sure it's a question
        foreach($questionIDs as $questionID) {
            // the treeIDs should match
            $this->assertEquals($validate->questionID($questionID), true);
        }
    }

    /**
     * Gets all questions for a tree, then gets all options for the first question
     * and then gets one option by id to see if everything matches
     *
     * @covers Cme\Database\getQuestions()
     * @covers Cme\Database\getOptions()
     * @covers Cme\Database\getOption()
     */
    public function testGetOptions() {
        $treeID = 1;

        $question = $this->getOneDynamic('question', $treeID);
        $questionID = $question['questionID'];
        $options = $this->db->getOptions($questionID);

        foreach($options as $option) {
            $this->assertEquals($option, $this->db->getOption($option['optionID']));
           ;
        }

        // do one failure test for getOptions
        $this->assertEmpty($this->db->getOptions(999999999999999999));
    }
}
