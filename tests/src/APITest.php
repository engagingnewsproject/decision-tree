<?php
use PHPUnit\Framework\TestCase;
use Cme\Database as Database;
use Cme\Utility as Utility;
use Cme\Tree as Tree;

/**
 * @covers index.php API Routes
 */
final class APITest extends TreeTestCase
{
    protected function setUp() {
        $this->db = new Database\DB();
        // get trees, but limit to 3
        $this->trees = array_slice($this->db->getTrees(), 0, 3);

    }

    /**
     * @covers api/v1/trees
     */
    public function testGetTrees() {
        $trees = $this->db->getTrees();
        $this->assertEquals(Utility\getEndpoint('trees'), json_encode($trees));
    }

    /**
     * @covers api/v1/trees/{{treeID}}
     * @dataProvider APITreeProvider
     */
    public function testAPITree($treeID) {
        $tree = new Tree\Tree($this->db, $treeID);

        $this->assertEquals(Utility\getEndpoint('trees/'.$treeID), json_encode($tree->array()));
    }

    public function APITreeProvider() {
        $trees = $this->getTreesProvider();
        $provider = [];

        foreach($trees as $tree) {
            $provider['tree'.$tree['treeID']] = [$tree['treeID']];
        }

        return $provider;
    }

    /**
     * @covers api/v1/trees/{{treeID}}/questions
     * @covers api/v1/trees/{{treeID}}/question/{{questionID}}
     * @covers api/v1/trees/{{treeID}}/ends
     * @covers api/v1/trees/{{treeID}}/ends/{{endID}}
     * @covers api/v1/trees/{{treeID}}/starts
     * @covers api/v1/trees/{{treeID}}/starts/{{startID}}
     * @covers api/v1/trees/{{treeID}}/groups
     * @covers api/v1/trees/{{treeID}}/groups/{{groupID}}
     * @dataProvider APIGettersProvider
     */
    public function testAPIGetters($elType, $treeID) {
        $els = $this->getAllDynamic($elType, $treeID);

        $route = 'trees/'.$treeID.'/'.$elType.'s';
        $this->assertEquals(Utility\getEndpoint($route), json_encode($els));

        // test individual ones too, but only the first 5 of them so it doesn't take so long
        $els = array_splice($els, 0, 5);
        foreach($els as $el) {
            $this->assertEquals(Utility\getEndpoint($route.'/'.$el[$elType.'ID']), json_encode($el));
        }
    }

    public function APIGettersProvider() {
        $provider = [];

        $elTypes = ['question', 'end', 'group', 'start'];
        $trees = $this->getTreesProvider();
        foreach($trees as $tree) {
            $treeID = $tree['treeID'];
            foreach($elTypes as $elType) {
                // tree provider
                $provider['tree'.$treeID.ucfirst($elType)] = [$elType, $treeID];
                }
        }

        return $provider;
    }

    /**
     * @covers api/v1/trees/{{treeID}}/questions/{{questionID}}/options
     * @covers api/v1/trees/{{treeID}}/groups/{{groupID}}
     * @dataProvider APITreeProvider
     */
    public function testAPIOptions($treeID) {
        $questions = $this->getQuestionsProvider($treeID);

        if(empty($questions)) {

            $question = $this->getOneDynamic('question', 1);
            $route = 'trees/1/questions/'.$question['questionID'].'/options/99999999999999';
            // assert on one that doesn't exist to make sure it's empty
            $this->assertEquals(Utility\getEndpoint($route), json_encode(false));
        }
        foreach($questions as $question) {
            $route = 'trees/'.$treeID.'/questions/'.$question['questionID'].'/options';
            $options = $this->db->getOptions($question['questionID']);
            // check that the options match
            $this->assertEquals(Utility\getEndpoint($route), json_encode($options));

            if(empty($options)) {
                continue;
            }
            // check individual options match
            foreach($options as $option) {
                $this->assertEquals(Utility\getEndpoint($route.'/'.$option['optionID']), json_encode($option));
            }
        }

    }
}
