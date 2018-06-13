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
           $starts = [],
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
        self::$questions['four'] = self::createQuestion(self::$tree->getID(), 'Question Four Title');

        // create ends via the API
        self::$ends['one'] = self::createEnd(self::$tree->getID(), ['title' => 'End One Title', 'content' => 'End One Content']);
        self::$ends['two'] = self::createEnd(self::$tree->getID(), ['title' => 'End Two Title', 'content' => 'End Two Content']);

        // create starts via the API
        self::$starts['one'] = self::createStart(self::$tree->getID(), ['title' => 'Start One Title', 'destinationID' => self::$questions['one']->getID()]);

        // create options
        self::$options['one'] = self::createOption(self::$tree->getID(), self::$questions['one']->getID(), ['title'=>'Option One Title','destinationID'=>self::$questions['three']->getID()]);
        self::$options['two'] = self::createOption(self::$tree->getID(), self::$questions['one']->getID(), ['title'=>'Option Two Title','destinationID'=>self::$questions['two']->getID()]);
        self::$options['three'] = self::createOption(self::$tree->getID(), self::$questions['one']->getID(), ['title'=>'Option Three Title','destinationID'=>self::$questions['three']->getID()]);

        $groupQuestions = [
                    self::$questions['one']->getID(),
                    self::$questions['two']->getID()
                ];
        self::$groups['one'] = self::createGroup(self::$tree->getID(),
            [
                'title' => 'Group One Title',
                'questions' => $groupQuestions
            ]
        );
        self::$groups['two'] = self::createGroup(self::$tree->getID(), ['title' => 'Group Two Title', 'content'=>'Group Two Content']);

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

    public static function tearDownAfterClass() {
        // remove the files from the data direcory
        unlink(dirname(__FILE__).'/../../data/'.self::$tree->getSlug().'.json');
        unlink(dirname(__FILE__).'/../../data/'.self::$tree->getSlug().'.min.json');
        // delete the static tree
        self::$tree = false;
    }

    /**
     * @covers api/v1/trees
     */
    public function testApiGetTrees() {
        $trees = self::$db->getTrees();
        $this->assertEquals(Utility\getEndpoint('trees'), json_encode($trees));
    }

    /**
     * @covers api/v1/trees/{{treeID}}
     * @dataProvider APITreeProvider
     */
    public function testApiTree($treeID) {
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
     * @covers GET api/v1/trees/{{treeID}}/questions
     * @covers GET api/v1/trees/{{treeID}}/question/{{questionID}}
     * @covers GET api/v1/trees/{{treeID}}/ends
     * @covers GET api/v1/trees/{{treeID}}/ends/{{endID}}
     * @covers GET api/v1/trees/{{treeID}}/starts
     * @covers GET api/v1/trees/{{treeID}}/starts/{{startID}}
     * @covers GET api/v1/trees/{{treeID}}/groups
     * @covers GET api/v1/trees/{{treeID}}/groups/{{groupID}}
     * @dataProvider APIGettersProvider
     */
    public function testApiGetters($elType, $treeID) {
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
     * @covers GET api/v1/trees/{{treeID}}/questions/{{questionID}}/options
     * @covers GET api/v1/trees/{{treeID}}/questions/{{questionID}}/options/{{optionID}}
     * @dataProvider APITreeProvider
     */
    public function testApiOptions($treeID) {
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
    public function testApiTreeCreate() {
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
    public function testApiQuestionCreate() {
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
     * we're going to check to make sure the options we
     * created in set-up indeed did get created
     *
     * @covers POST api/v1/trees/{treeID}/questions/{questionID}/options
     * @provider from setUpBeforeClass()
     */
    public function testApiOptionCreate() {
        $i = 0;
        foreach(self::$options as $key => $option) {
            // check that it's an object
            $this->assertTrue(is_object($option));
            // do we have an id?
            $this->assertTrue(Utility\isID($option->getID()));
            // does the order match the order it was created?
            $this->assertEquals($option->getOrder(), $i);

            // check a destination to make sure it got set as well. This is manually done.
            if($key === 'two') {
                $this->assertEquals($option->getDestinationID(), self::$questions['two']->getID());
                $this->assertEquals($option->getDestinationType(), 'question');
            }

            $i++;
        }
    }

    /*
     * @covers PUT api/v1/trees/{treeID}/questions/{questionID}
     * @provider from setUpBeforeClass()
     */
    public function testApiQuestionUpdate() {

        // update question title
        $this->data['title'] = self::$questions['one']->getTitle().' Updated';
        $questionOneUpdated = json_decode(
            Utility\putEndpoint('trees/'.self::$tree->getID().'/questions/'.self::$questions['one']->getID(), $this->data)
        );

        $this->assertEquals($questionOneUpdated->title, $this->data['title']);
    }
    /*
     * @covers PUT api/v1/trees/{treeID}/questions/{questionID}/move/{position}
     * @provider from setUpBeforeClass()
     */
    public function testApiQuestionMove() {
        $question = self::$questions['one'];
        // move first to end
        $questionOneMoved = json_decode(
            Utility\putEndpoint('trees/'.self::$tree->getID().'/questions/'.$question->getID().'/move/last', $this->data)
        );

        $this->assertEquals($questionOneMoved->order, (count(self::$questions) - 1) );

        // get the other question and make sure it's now first
        $newFirstQuestion = $this->getQuestionFromEndpoint(self::$tree->getID(), self::$questions['two']->getID());

        $this->assertEquals($newFirstQuestion->getOrder(), 0);
    }

    /*
     * @covers PUT api/v1/trees/{treeID}/questions/{questionID}/options/{optionID}
     * @provider from setUpBeforeClass()
     */
    public function testApiOptionUpdate() {


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


    /*
     * @covers PUT api/v1/trees/{treeID}/questions/{questionID}/options/{optionID}/move/{position}
     * @provider from setUpBeforeClass()
     */
    public function testApiOptionMove() {
        // move first to second
        $optionOneMoved = json_decode(
            Utility\putEndpoint('trees/'.self::$tree->getID().'/questions/'.self::$questions['one']->getID().'/options/'.self::$options['one']->getID().'/move/1', $this->data)
        );

        $this->assertEquals($optionOneMoved->order, 1);

        // get the other option and make sure it's now first
        self::$options['two'] = $this->getOptionFromEndpoint(self::$tree->getID(), self::$questions['one']->getID(), self::$options['two']->getID());

        $this->assertEquals(self::$options['two']->getOrder(), 0);
    }

    /*
     * Moving an option from one question to another.
     * It should:
     * - remove the option from the current question,
     * - rebuild the question so the order is set correctly,
     * - move the option to the new question
     * - rebuild the question
     *
     * @covers PUT api/v1/trees/{treeID}/questions/{questionID}/options/{optionID}
     * @provider from setUpBeforeClass()
     */
    public function testApiOptionMoveToDifferentQuestion() {
        // moving this option to question two
        $this->data['questionID'] = self::$questions['two']->getID();

        $optionOneUpdated = Utility\putEndpoint('trees/'.self::$tree->getID().'/questions/'.self::$questions['one']->getID().'/options/'.self::$options['one']->getID(), $this->data);
        $optionOneUpdated = json_decode($optionOneUpdated);

        //rebuild from the database so we can check for the new questionID
        self::$options['one'] = self::$options['one']->rebuild();

        $this->assertEquals(self::$options['one']->getQuestionID(), self::$questions['two']->getID());

        // rebuild the question
        self::$questions['one'] = self::$questions['one']->rebuild();

        // check that the numbers line-up now. Option three should now be order = 1
        // rebuild it to validate
        self::$options['three'] = self::$options['three']->rebuild();
        $this->assertEquals(self::$options['three']->getOrder(), 1);

        // check that it's NOT on the question it was before
        $this->assertEquals(self::$questions['one']->getOptions(), [self::$options['two']->getID(), self::$options['three']->getID()]);
    }


    /*
     * @covers PUT api/v1/trees/{treeID}/questions/{questionID}/options/{optionID}
     * @provider from setUpBeforeClass()
     */
    public function testApiOptionChangeDestination() {
        $option = self::$options['one'];
        $newDestinationID = self::$ends['one']->getID();
        $this->data['destinationID'] = $newDestinationID;

        $optionOneUpdated = Utility\putEndpoint('trees/'.self::$tree->getID().'/questions/'.$option->getQuestionID().'/options/'.$option->getID(), $this->data);
        $optionOneUpdated = json_decode($optionOneUpdated);

        //rebuild from the database so we can check for the new questionID
        $option->rebuild();

        $this->assertEquals($option->getDestinationID(), $newDestinationID);
    }

    /*
     * we're going to check to make sure the starts we
     * created in set-up indeed did get created
     *
     * @covers POST api/v1/trees/{treeID}/starts
     * @provider from setUpBeforeClass()
     */
    public function testApiStartCreate() {
        $i = 0;
        foreach(self::$starts as $start) {
            // check that it's an object
            $this->assertTrue(is_object($start));
            // do we have an id?
            $this->assertTrue(Utility\isID($start->getID()));

            $i++;
        }
    }

    /*
     * @covers PUT api/v1/trees/{treeID}/starts/{startID}
     * @provider from setUpBeforeClass()
     */
    public function testApiStartUpdate() {

        // update start title
        $this->data['title'] = self::$starts['one']->getTitle().' Updated';
        $startOneUpdated = json_decode(
            Utility\putEndpoint('trees/'.self::$tree->getID().'/starts/'.self::$starts['one']->getID(), $this->data)
        );

        $this->assertEquals($startOneUpdated->title, $this->data['title']);
    }

    /*
     * @covers PUT api/v1/trees/{treeID}/starts/{startID}
     * @provider from setUpBeforeClass()
     */
    public function testApiStartDestinationChange() {
        $newDestinationID = self::$questions['two']->getID();
        // update start destination
        $this->data['destinationID'] = $newDestinationID;
        $startOneUpdated = json_decode(
            Utility\putEndpoint('trees/'.self::$tree->getID().'/starts/'.self::$starts['one']->getID(), $this->data)
        );

        $this->assertEquals($startOneUpdated->destinationID, $newDestinationID);
    }

    /*
     * we're going to check to make sure the groups we
     * created in set-up indeed did get created
     *
     * @covers POST api/v1/trees/{treeID}/groups
     * @provider from setUpBeforeClass()
     */
    public function testApiGroupCreate() {
        $i = 0;
        $groupQuestions = [
                    self::$questions['one']->getID(),
                    self::$questions['two']->getID()
                ];

        foreach(self::$groups as $group) {
            // check that it's an object
            $this->assertTrue(is_object($group));
            // do we have an id?
            $this->assertTrue(Utility\isID($group->getID()));

            // if it's the first group, check that it has questions
            if($group->getID() === self::$groups['one']) {
                $this->assertEquals($group->getQuestions(), $groupQuestions);
            }
            $i++;
        }
    }

    /*
     * @covers PUT api/v1/trees/{treeID}/groups/{groupID}
     * @provider from setUpBeforeClass()
     */
    public function testApiGroupUpdate() {

        // update group title
        $this->data['title'] = self::$groups['one']->getTitle().' Updated';
        $groupOneUpdated = Utility\putEndpoint('trees/'.self::$tree->getID().'/groups/'.self::$groups['one']->getID(), $this->data);
        $groupOneUpdated = json_decode(
            $groupOneUpdated
        );

        $this->assertEquals($groupOneUpdated->title, $this->data['title']);
    }

    /*
     * Updating all questions in a group
     *
     * @covers PUT api/v1/trees/{treeID}/groups/{groupID}
     * @provider from setUpBeforeClass()
     */
    public function testApiGroupUpdateQuestions() {


        $this->data['questionsArray'] = [
            self::$questions['three']->getID(),
            self::$questions['four']->getID()
        ];

        $this->data['questions'] = implode(',', $this->data['questionsArray']);

        $groupTwoUpdated = Utility\putEndpoint('trees/'.self::$tree->getID().'/groups/'.self::$groups['two']->getID(), $this->data);

        $groupTwoUpdated = json_decode($groupTwoUpdated);

        $this->assertEquals($groupTwoUpdated->questions, $this->data['questionsArray']);

        $this->data['questions'] = self::$questions['two']->getID();

        $groupOneUpdated = Utility\putEndpoint('trees/'.self::$tree->getID().'/groups/'.self::$groups['one']->getID(), $this->data);

        $groupOneUpdated = json_decode($groupOneUpdated);

         $this->assertEquals($groupOneUpdated->questions, [$this->data['questions']]);

    }

    /*
     * @covers POST api/v1/trees/{treeID}/groups/{groupID}/questions
     * @provider from setUpBeforeClass()
     */
    public function testApiGroupAddQuestion() {

        $this->data['question'] = self::$questions['two']->getID();

        $groupOneUpdated = Utility\putEndpoint('trees/'.self::$tree->getID().'/groups/'.self::$groups['one']->getID().'/questions', $this->data);

        $groupOneUpdated = json_decode($groupOneUpdated);

        // rebuild group One so we can see if it matches
        self::$groups['one']->rebuild();

        $this->assertEquals($groupOneUpdated->questions, self::$groups['one']->getQuestions());

    }

    /*
     * @covers DELETE api/v1/trees/{treeID}/groups/{groupID}/questions/{questionID}
     * @provider from setUpBeforeClass()
     */
    public function testApiGroupRemoveQuestion() {

        $questions = self::$groups['one']->getQuestions();
        $questionCount = count($questions);

        $groupOneUpdated = Utility\deleteEndpoint('trees/'.self::$tree->getID().'/groups/'.self::$groups['one']->getID().'/questions/'.$questions[0], $this->data);
        $groupOneUpdated = json_decode($groupOneUpdated);

        // unset the question we removed
        unset($questions[0]);
        // reindex it so our keys match
        $questions = array_values($questions);

        $this->assertEquals($groupOneUpdated->questions, $questions);

        // questions should be one less than before
        $this->assertEquals(count($groupOneUpdated->questions), ($questionCount - 1));
        // check off the object too
        self::$groups['one']->rebuild();
        $this->assertEquals($groupOneUpdated->questions, self::$groups['one']->getQuestions());

    }

    /*
     * @covers PUT api/v1/trees/{treeID}/groups/{groupID}/move/{position}
     * @provider from setUpBeforeClass()
     */
    public function testApiGroupMove() {
        $group = self::$groups['one'];
        // move first to end
        $groupOneMoved = Utility\putEndpoint('trees/'.self::$tree->getID().'/groups/'.$group->getID().'/move/last', $this->data);

        $groupOneMoved = json_decode($groupOneMoved);

        $this->assertEquals($groupOneMoved->order, (count(self::$groups) - 1) );

        // get the other group and make sure it's now first
        $newFirstGroup = $this->getGroupFromEndpoint(self::$tree->getID(), self::$groups['two']->getID());

        $this->assertEquals($newFirstGroup->getOrder(), 0);
    }

    /*
     * we're going to check to make sure the ends we
     * created in set-up indeed did get created
     *
     * @covers POST api/v1/trees/{treeID}/ends
     * @provider from setUpBeforeClass()
     */
    public function testApiEndCreate() {
        $i = 0;
        foreach(self::$ends as $end) {
            // check that it's an object
            $this->assertTrue(is_object($end));
            // do we have an id?
            $this->assertTrue(Utility\isID($end->getID()));

            $i++;
        }
    }

    /*
     * @covers PUT api/v1/trees/{treeID}/ends/{endID}
     * @provider from setUpBeforeClass()
     */
    public function testApiEndUpdate() {

        // update end title
        $this->data['title'] = self::$ends['one']->getTitle().' Updated';
        $endOneUpdated = json_decode(
            Utility\putEndpoint('trees/'.self::$tree->getID().'/ends/'.self::$ends['one']->getID(), $this->data)
        );

        $this->assertEquals($endOneUpdated->title, $this->data['title']);

        // update end content and title
        $this->data['title'] = self::$ends['two']->getTitle().' Updated';
        $this->data['content'] = self::$ends['two']->getContent().' Updated';

        $endTwoUpdated = json_decode(
            Utility\putEndpoint('trees/'.self::$tree->getID().'/ends/'.self::$ends['two']->getID(), $this->data)
        );

        $this->assertEquals($endTwoUpdated->title, $this->data['title']);
        $this->assertEquals($endTwoUpdated->content, $this->data['content']);


    }


    /*
     * @covers POST api/v1/trees/compiled
     */
    public function testApiCompile() {
        $compiled = Utility\postEndpoint('trees/'.self::$tree->getID().'/compiled', $this->data);
        $compiled = json_decode($compiled);

        // check structure
        $this->validateCompiledStructure($compiled);

        // check that a file was created
        $this->assertTrue(file_exists(dirname(__FILE__).'/../../data/'.self::$tree->getSlug().'.json'));
        // check that a minified file was created
        $this->assertTrue(file_exists(dirname(__FILE__).'/../../data/'.self::$tree->getSlug().'.min.json'));
    }

        /*
     * @covers GET api/v1/trees/compiled
     */
    public function testApiGetCompiled() {
        $compiled = Utility\getEndpoint('trees/'.self::$tree->getID().'/compiled');
        $compiled = json_decode($compiled);

        // check structure
        $this->validateCompiledStructure($compiled);
    }

    public function validateCompiledStructure($compiled) {
        // top level keys
        $keys = ['ID', 'title', 'slug', 'starts', 'groups', 'questions', 'ends', 'stats'];

        foreach($keys as $key) {
            $this->assertObjectHasAttribute($key, $compiled);
        }
    }

    /*
     * @covers DELETE api/v1/trees/{treeID}/starts/{startID}
     * @provider from setUpBeforeClass()
     */
    public function testApiStartDelete() {
               // delete the question
        foreach(self::$starts as $start)  {
            $startID = $start->getID();
            $this->assertTrue(
                json_decode(
                    Utility\deleteEndpoint(
                        'trees/'.self::$tree->getID().'/starts/'.$start->getID(),
                        $this->data
                    )
                )
            );
            // check that it was deleted
            $startDeleted =json_decode(
                Utility\getEndpoint('trees/'.self::$tree->getID().'/starts/'.$startID)
            );
            $this->assertEquals($startDeleted->status, 'error');
        }
        // delete the static starts
        self::$starts = false;
    }
    /*
     * @covers DELETE api/v1/trees/{treeID}/ends/{endID}
     * @provider from setUpBeforeClass()
     */
    public function testApiEndDelete() {
        // delete the ends
        foreach(self::$ends as $end)  {
            $endID = $end->getID();
            $this->assertTrue(
                json_decode(
                    Utility\deleteEndpoint(
                        'trees/'.self::$tree->getID().'/ends/'.$end->getID(),
                        $this->data
                    )
                )
            );
            // check that it was deleted
            $endDeleted =json_decode(
                Utility\getEndpoint('trees/'.self::$tree->getID().'/ends/'.$endID)
            );
            $this->assertEquals($endDeleted->status, 'error');
        }
        // delete the static ends
        self::$ends = false;
    }
    /*
     * @covers DELETE api/v1/trees/{treeID}/groups/{groupID}
     * @provider from setUpBeforeClass()
     */
    public function testApiGroupDelete() {
        // delete the groups
        foreach(self::$groups as $group)  {
            $groupID = $group->getID();
            $this->assertTrue(
                json_decode(
                    Utility\deleteEndpoint(
                        'trees/'.self::$tree->getID().'/groups/'.$group->getID(),
                        $this->data
                    )
                )
            );
            // check that it was deleted
            $groupDeleted =json_decode(
                Utility\getEndpoint('trees/'.self::$tree->getID().'/groups/'.$groupID)
            );
            $this->assertEquals($groupDeleted->status, 'error');
        }
        // delete the static groups
        self::$groups = false;
    }
    /**
     * Delete an option
     *
     * @covers DELETE api/v1/trees/{treeID}/question/{questionID}/options/{optionID}
     */
    public function testApiOptionDelete() {
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
     */
    public function testApiQuestionDelete() {
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
    /**
     * Test Question and Option API methods
     * @covers DELETE api/v1/trees/{treeID}
    */
    public function testApiTreeDelete() {
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
    }

}
