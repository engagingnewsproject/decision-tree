<?php
use PHPUnit\Framework\TestCase;
use Cme\Database as Database;
use Cme\Utility as Utility;
use Cme\Element as Element;
use Cme\Element\Tree as Tree;
use Cme\Element\Question as Question;



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
        $tree = new Tree($this->db, $treeID);

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
        $elObject = '\\Cme\\Element\\'.ucfirst($elType);
        $route = 'trees/'.$treeID.'/'.$elType.'s';

        $elements = [];
        foreach($els as $el) {
            $el['ID'] = $el[$elType.'ID'];
            $elObject = new $elObject($this->db, $el);
            $elements[] = $elObject->array();
        }
        $this->assertEquals(Utility\getEndpoint($route), json_encode($elements));


        // test individual ones too, but only the first 5 of them so it doesn't take so long
        $els = array_splice($els, 0, 5);
        foreach($els as $el) {
            $elFromEndpoint = Utility\getEndpoint($route.'/'.$el[$elType.'ID']);

            // get the object
            $el['ID'] = $el[$elType.'ID'];
            $elObject = new $elObject($this->db, $el);
            $this->assertEquals($elFromEndpoint, json_encode($elObject->array()));

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
            $response = json_decode(Utility\getEndpoint($route));
            // assert on one that doesn't exist to make sure it's empty
            $this->assertEquals($response->status, 'error');
        }
        foreach($questions as $question) {
            $questionID = $question['questionID'];
            $route = 'trees/'.$treeID.'/questions/'.$questionID.'/options';

            $optionIDs = $this->db->getOptionIDs($questionID);

            if(empty($optionIDs)) {
                $this->assertEquals(Utility\getEndpoint($route), json_encode([]));
                continue;
            }

            $optionObjs = [];
            foreach($optionIDs as $optionID) {
                $option = new Element\Option($this->db, $optionID);
                // check that the individual option matches the endpoint
                $this->assertEquals(Utility\getEndpoint($route.'/'.$optionID), json_encode($option->array()));
                // ad to the options array
                $optionObjs[] = $option->array();
            }

            // check that the options match
            $this->assertEquals(Utility\getEndpoint($route), json_encode($optionObjs));
        }
    }


    /**
     * Test creating a tree
     * @covers api/v1/trees/ POST
     */
    public function testAPITreeCreate() {
        // create a new tree
        $title = $this->randomString();
        // create a new tree
        $tree = $this->createTree($title);

        // compare details
        $this->assertEquals($tree->getTitle(),  $title);
        $this->assertEquals($tree->getOwner(),  $this->getAdminUser()['userID']);
        $this->assertEquals($tree->getSlug(), Utility\slugify($title));
    }


    /**
     * Test Question API methods
     * @covers api/v1/trees/ POST
     */
    public function testAPIQuestion() {
        $data = [
            'user' => $this->getAdminUser()
        ];
        // create a tree
        $tree = $this->createTree($this->randomString());
        // create a question
        $question = $this->createQuestion($tree->getID(), 'Question One Title');
        $questionTwo = $this->createQuestion($tree->getID(), 'Question Two Title');

        // check order
        $this->assertEquals($question->getOrder(), 0);
        $this->assertEquals($questionTwo->getOrder(), 1);

        // move first to end
        $questionOneMoved = json_decode(
            Utility\putEndpoint('trees/'.$tree->getID().'/questions/'.$question->getID().'/move/last', $data)
        );

        $this->assertEquals($questionOneMoved->order, 1);

        // get the other question and make sure it's now first
        $questionTwo = $this->getQuestionFromEndpoint($tree->getID(), $questionTwo->getID());

        $this->assertEquals($questionTwo->getOrder(), 0);

        // update question title
        $data['title'] = $question->getTitle().' Updated';
        $questionOneUpdated = json_decode(
            Utility\putEndpoint('trees/'.$tree->getID().'/questions/'.$question->getID(), $data)
        );

        $this->assertEquals($questionOneUpdated->title, $data['title']);


    }

    public function createTree($title) {
        // add in the user to the request
        $data = [
            'title' => $title,
            'user' => $this->getAdminUser()
        ];

        $response = Utility\postEndpoint('trees', $data);

        $tree = json_decode($response);
        // check that it's an object
        $this->assertTrue(is_object($tree));

        // do we have an id?
        $this->assertTrue(Utility\isID($tree->ID));

        // check that we can find it in the DB
        return new Tree(new Database\DB(), $tree->ID);
    }

    public function createQuestion($treeID, $title) {
        // create a new tree
        $user = $this->getAdminUser();
        // add in the user to the request
        $data = [
            'title' => $title,
            'user' => $user
        ];

        $question = json_decode(
            Utility\postEndpoint('trees/'.$treeID.'/questions', $data)
        );

        // check that it's an object
        $this->assertTrue(is_object($question));

        // do we have an id?
        $this->assertTrue(Utility\isID($question->ID));

        // check that we can find it in the DB
        return new Question(new Database\DB(), $question->ID);
    }

    public function getQuestionFromEndpoint($treeID, $questionID) {
        $question = json_decode(
            Utility\getEndpoint('trees/'.$treeID.'/questions/'.$questionID)
        );

        return new Question(new Database\DB(), $question->ID);
    }

}
