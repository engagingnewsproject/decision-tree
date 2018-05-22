<?php
use PHPUnit\Framework\TestCase;
use Cme\Database as Database;
use Cme\Utility as Utility;
use Cme\Element as Element;
use Cme\Element\Tree as Tree;
use Cme\Element\Start as Start;
use Cme\Element\Group as Group;
use Cme\Element\Question as Question;
use Cme\Element\End as End;
use Cme\Element\Option as Option;



/**
 * @covers index.php API Routes
 */
final class APITest extends TreeTestCase
{
    public $data = []; // sets user for api calls

    public static
           $treeTitle, // string of title we're using to create tre
           $tree, // place to store a temporary tree we've created for testing
           $options = [], // options we created during test
           $questions = [], // questions we created during test
           $ends = [], // questions we created during test
           $groups = [],
           $db; // database connection

    public static function setUpBeforeClass() {
        self::$db = new Database\DB();

        // create a new tree via the API
        self::$treeTitle = self::randomString();
        self::$tree = self::createTree(self::$treeTitle);
        // create a question via the API
        self::$questions['one'] = self::createQuestion(self::$tree->getID(), 'Question One Title');
        self::$questions['two'] = self::createQuestion(self::$tree->getID(), 'Question Two Title');
        self::$questions['three'] = self::createQuestion(self::$tree->getID(), 'Question Three Title');

        // create options
        self::$options['one'] = self::createOption(self::$tree->getID(), self::$questions['one']->getID(), ['title'=>'Option One Title','destination'=>self::$questions['two']->getID()]);
        self::$options['two'] = self::createOption(self::$tree->getID(), self::$questions['one']->getID(), ['title'=>'Option Two Title','destination'=>self::$questions['two']->getID()]);
        self::$options['three'] = self::createOption(self::$tree->getID(), self::$questions['one']->getID(), ['title'=>'Option Three Title','destination'=>self::$questions['three']->getID()]);

    }

    public function setUp() {
        $this->data = [
            'user' => self::getAdminUser()
        ];

        // rebuild each of the trees so they're always up to date
        try {
            if(!empty(self::$tree)) {
                self::$tree->rebuild();
            }

            if(!empty(self::$questions)) {
                foreach(self::$questions as $question) {
                    $question->rebuild();
                }
            }
            if(!empty(self::$options)) {
                foreach(self::$options as $option) {
                    $option->rebuild();
                }
            }

        } catch(\Error $e) {
            echo $e->getMessage();
        }


    }

    /**
     * @covers api/v1/trees
     */
    public function testGetTrees() {
        $trees = self::$db->getTrees();
        $this->assertEquals(Utility\getEndpoint('trees'), json_encode($trees));
    }

    /**
     * @covers api/v1/trees/{{treeID}}
     * @dataProvider APITreeProvider
     */
    public function testAPITree($treeID) {
        $tree = new Tree(self::$db, $treeID);

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
            $elObject = new $elObject(self::$db, $el);
            $elements[] = $elObject->array();
        }
        $this->assertEquals(Utility\getEndpoint($route), json_encode($elements));


        // test individual ones too, but only the first 5 of them so it doesn't take so long
        $els = array_splice($els, 0, 5);
        foreach($els as $el) {
            $elFromEndpoint = Utility\getEndpoint($route.'/'.$el[$elType.'ID']);

            // get the object
            $el['ID'] = $el[$elType.'ID'];
            $elObject = new $elObject(self::$db, $el);
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

            $optionIDs = self::$db->getOptionIDs($questionID);

            if(empty($optionIDs)) {
                $this->assertEquals(Utility\getEndpoint($route), json_encode([]));
                continue;
            }

            $optionObjs = [];
            foreach($optionIDs as $optionID) {
                $option = new Element\Option(self::$db, $optionID);
                // check that the individual option matches the endpoint
                $this->assertEquals(Utility\getEndpoint($route.'/'.$optionID), json_encode($option->array()));
                // ad to the options array
                $optionObjs[] = $option->array();
            }

            // check that the options match
            $this->assertEquals(Utility\getEndpoint($route), json_encode($optionObjs));
        }
    }

    /*
     * we're going to check to make sure the tree we
     * created in set-up indeed did get created
     *
     * @covers POST api/v1/trees
     * @provider from setUpBeforeClass()
     */
    public function testAPITreeCreate() {
        // check that it's an object
        $this->assertTrue(is_object(self::$tree));
        // do we have an id?
        $this->assertTrue(Utility\isID(self::$tree->getID()));
        // compare details
        $this->assertEquals(self::$tree->getTitle(),  self::$treeTitle);
        $this->assertEquals(self::$tree->getOwner(),  self::getAdminUser()['userID']);
        $this->assertEquals(self::$tree->getSlug(), Utility\slugify(self::$treeTitle));
    }

    /*
     * we're going to check to make sure the questions we
     * created in set-up indeed did get created
     *
     * @covers POST api/v1/trees/{treeID}/questions
     * @provider from setUpBeforeClass()
     */
    public function testAPIQuestionCreate() {
        $i = 0;
        foreach(self::$questions as $question) {
            // check that it's an object
            $this->assertTrue(is_object($question));
            // do we have an id?
            $this->assertTrue(Utility\isID($question->getID()));
            // check order
            $this->assertEquals($question->getOrder(), $i);
            $i++;
        }

    }

    /*
     * we're going to check to make sure the questions we
     * created in set-up indeed did get created
     *
     * @covers POST api/v1/trees/{treeID}/questions/{questionID}/options
     * @provider from setUpBeforeClass()
     */
    public function testAPIOptionCreate() {
        $i = 0;
        foreach(self::$options as $key => $option) {
            // check that it's an object
            $this->assertTrue(is_object($option));
            // do we have an id?
            $this->assertTrue(Utility\isID($option->getID()));
            // does the order match the order it was created?
            $this->assertEquals($option->getOrder(), $i);

            // check destinations. Options one and two go to question two as their destination
            if($key === 'one' || $key === 'two') {
                $this->assertEquals($option->getDestinationID(), self::$questions['two']->getID());
                $this->assertEquals($option->getDestinationType(), 'question');
            }

            $i++;
        }
    }


    public function testAPIQuestionUpdate() {

        // update question title
        $this->data['title'] = self::$questions['one']->getTitle().' Updated';
        $questionOneUpdated = json_decode(
            Utility\putEndpoint('trees/'.self::$tree->getID().'/questions/'.self::$questions['one']->getID(), $this->data)
        );

        $this->assertEquals($questionOneUpdated->title, $this->data['title']);
    }

    public function testAPIQuestionMove() {
        // move first to end
        $questionOneMoved = json_decode(
            Utility\putEndpoint('trees/'.self::$tree->getID().'/questions/'.self::$questions['one']->getID().'/move/last', $this->data)
        );

        $this->assertEquals($questionOneMoved->order, 2);

        // get the other question and make sure it's now first
        self::$questions['two'] = $this->getQuestionFromEndpoint(self::$tree->getID(), self::$questions['two']->getID());

        $this->assertEquals(self::$questions['two']->getOrder(), 0);
    }


    public function testAPIOptionUpdate() {


        $option = self::$options['one'];
        $questionID = $option->getQuestionID();
        $question = new Question(self::$db, $questionID);
        $treeID = $question->getTreeID();

        // update option title
        $this->data['title'] = $option->getTitle().' Updated';

        $optionOneUpdated = json_decode(
            Utility\putEndpoint('trees/'.$treeID.'/questions/'.$questionID.'/options/'.$option->getID(), $this->data)
        );

        $this->assertEquals($optionOneUpdated->title, $this->data['title']);
    }



    public function testAPIOptionMove() {
        // move first to second
        $optionOneMoved = json_decode(
            Utility\putEndpoint('trees/'.self::$tree->getID().'/questions/'.self::$questions['one']->getID().'/options/'.self::$options['one']->getID().'/move/1', $this->data)
        );

        $this->assertEquals($optionOneMoved->order, 1);

        // get the other option and make sure it's now first
        self::$options['two'] = $this->getOptionFromEndpoint(self::$tree->getID(), self::$questions['one']->getID(), self::$options['two']->getID());

        $this->assertEquals(self::$options['two']->getOrder(), 0);
    }

    public function testAPIOptionMoveToDifferentQuestion() {
        $this->data['questionID'] = self::$questions['two']->getID();
        $this->data['destination'] = self::$questions['three']->getID();
        $optionOneUpdated = json_decode(
            Utility\putEndpoint('trees/'.self::$tree->getID().'/questions/'.self::$questions['one']->getID().'/options/'.self::$options['one']->getID(), $this->data)
        );
        //rebuild from the database so we can check for the new questionID
        self::$options['one'] = self::$options['one']->rebuild();
        $this->assertEquals(self::$options['one']->getQuestionID(), self::$questions['two']->getID());
        $this->assertEquals(self::$options['one']->getDestinationID(), self::$questions['three']->getID());
        // rebuild the question
        self::$questions['one'] = self::$questions['one']->rebuild();
        // check that the numbers line-up now. Option three should now be order = 1
        // rebuild it to validate
        self::$options['three'] = self::$options['three']->rebuild();
        $this->assertEquals(self::$options['three']->getOrder(), 1);
        // check that it's NOT on the question it was before
        $this->assertEquals(self::$questions['one']->getOptions(), [self::$options['two']->getID(), self::$options['three']->getID()]);
    }

    /**
     * Delete an option
     *
     * @covers DELETE api/v1/trees/{treeID}/question/{questionID}/options/{optionID}
     */
    public function testAPIOptionDelete() {
        // Deleting questions should delete all options. Let's delete one option first

        // delete the option
        $endpoint = 'trees/'.self::$tree->getID().'/questions/'.self::$questions['one']->getID().'/options/'.self::$options['three']->getID();

        $deleteOption = Utility\deleteEndpoint(
            $endpoint,
            $this->data
        );

        $this->assertTrue(json_decode($deleteOption));


        $optionDeleted = json_decode(
            Utility\getEndpoint($endpoint)
        );

        $this->assertEquals($optionDeleted->status, 'error');

        // unset option three from the options since we just deleted it
        unset(self::$options['three']);

    }

    /**
     * Delete a question (and all its options)
     *
     * @covers DELETE api/v1/trees/{treeID}/question/{questionID}

    public function testAPIQuestionDelete() {
        // Deleting questions should delete all its options.

        // delete the question
        foreach(self::$questions as $question)  {
            $questionID = $question->getID();
            $optionsIDs = $question->getOptions();

            $this->assertTrue(
                json_decode(
                    Utility\deleteEndpoint(
                        'trees/'.self::$tree->getID().'/questions/'.$question->getID(),
                        $this->data
                    )
                )
            );

            // check that it was deleted
            $questionDeleted =json_decode(
                Utility\getEndpoint('trees/'.self::$tree->getID().'/questions/'.$questionID)
            );
            $this->assertEquals($questionDeleted->status, 'error');


            // check to make sure its options were deleted
            if(empty($optionsIDS)) {
                continue;
            }

            foreach($optionIDs as $optionID) {
                $optionDeleted =json_decode(
                    Utility\getEndpoint('trees/'.self::$tree->getID().'/questions/'.$questionID.'/options/'.$optionID)
                );

                $this->assertEquals($optionDeleted->status, 'error');
            }
        }


        // delete the static questions and options
        self::$questions = false;
        self::$options = false;
    }

    */
    /**
     * Test Question and Option API methods
     * @covers DELETE api/v1/trees/{treeID}

    public function testAPITreeDelete() {

        // delete the tree
        $this->assertTrue(
            json_decode(
                Utility\deleteEndpoint(
                    'trees/'.self::$tree->getID(),
                    $this->data
                )
            )
        );

        // check to make sure the endpoints are deleted
        $treeDeleted = json_decode(
            Utility\getEndpoint('trees/'.self::$tree->getID())
        );

        // this expects that the tree status will be an error of something like 'Tree does not exist.' since we're trying to find a deleted tree
        $this->assertEquals($treeDeleted->status, 'error');

        // delete the static tree
        self::$tree = false;

    }

    */
}
