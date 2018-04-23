<?php
use PHPUnit\Framework\TestCase;
use Cme\Database as Database;
use Cme\Utility as Utility;

/**
 * @covers index.php API Routes
 */
final class APITest extends TreeTestCase
{
    public $testTree; // place to store a temporary tree we've created for testing
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
        $tree = new \Cme\Tree($this->db, $treeID);

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


    /**
     * Test creating a tree
     * @covers api/v1/trees/ POST
     */
    public function testAPITreeCreate() {
        // create a new tree
        $db = false;
        $tree = new Cme\Tree($db);
        $treeTitle = $this->randomString();
        // set title
        $tree->setTitle($treeTitle);
        $user = $this->getAdminUser();

        // add in the user to the request
        $data = [
            'tree' => $tree->array(),
            'user' => $user
        ];

        $response = Utility\postEndpoint('trees', $data);

        $responseTree = json_decode($response);
        // check that it's an object
        $this->assertTrue(is_object($responseTree));

        // do we have an id?
        $this->assertTrue(Utility\isID($responseTree->ID));

        // check that we can find it in the DB
        $newTree = new Cme\Tree(new Database\DB(), $responseTree->ID);
        // compare details
        $this->assertEquals($newTree->getTitle(),  $treeTitle);
        $this->assertEquals($newTree->getOwner(),  $user['userID']);
        $this->assertEquals($newTree->getSlug(), Utility\slugify($treeTitle));
    }

}
