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
    public $tree, // place to store a temporary tree we've created for testing
           $options = [], // options we created during test
           $questions = []; // questions we created during test
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
     * Test Question and Option API methods
     * @covers api/v1/trees/ POST
     */
    public function testAPIQuestionAndOptions() {
        $data = [
            'user' => $this->getAdminUser()
        ];
        // create a tree
        $this->tree = $this->createTree($this->randomString());

        //*******************************************//
        //                                           //
        //       TEST CREATING QUESTIONS!            //
        //                                           //
        //*******************************************//
        // create a question
        $this->questions['one'] = $this->createQuestion($this->tree->getID(), 'Question One Title');
        $this->questions['two'] = $this->createQuestion($this->tree->getID(), 'Question Two Title');
        $this->questions['three'] = $this->createQuestion($this->tree->getID(), 'Question Three Title');

        // check order
        $this->assertEquals($this->questions['one']->getOrder(), 0);
        $this->assertEquals($this->questions['two']->getOrder(), 1);


        //*******************************************//
        //                                           //
        //         TEST MOVING QUESTIONS!            //
        //                                           //
        //*******************************************//

        // move first to end
        $questionOneMoved = json_decode(
            Utility\putEndpoint('trees/'.$this->tree->getID().'/questions/'.$this->questions['one']->getID().'/move/last', $data)
        );

        $this->assertEquals($questionOneMoved->order, 2);

        // get the other question and make sure it's now first
        $this->questions['two'] = $this->getQuestionFromEndpoint($this->tree->getID(), $this->questions['two']->getID());

        $this->assertEquals($this->questions['two']->getOrder(), 0);

        //*******************************************//
        //                                           //
        //       TEST UPDATING QUESTION TITLE!       //
        //                                           //
        //*******************************************//

        // update question title
        $data['title'] = $this->questions['one']->getTitle().' Updated';
        $questionOneUpdated = json_decode(
            Utility\putEndpoint('trees/'.$this->tree->getID().'/questions/'.$this->questions['one']->getID(), $data)
        );

        $this->assertEquals($questionOneUpdated->title, $data['title']);

        //*******************************************//
        //                                           //
        //         TEST CREATING OPTIONS!            //
        //                                           //
        //*******************************************//

        // create an option
        $this->options['one'] = $this->createOption($this->tree->getID(), $this->questions['one']->getID(), ['title'=>'Option One Title','destination'=>$this->questions['two']->getID()]);
        $this->options['two'] = $this->createOption($this->tree->getID(), $this->questions['one']->getID(), ['title'=>'Option Two Title','destination'=>$this->questions['two']->getID()]);
        $this->options['three'] = $this->createOption($this->tree->getID(), $this->questions['one']->getID(), ['title'=>'Option Three Title','destination'=>$this->questions['three']->getID()]);

        // check order
        $this->assertEquals($this->options['one']->getOrder(), 0);
        $this->assertEquals($this->options['two']->getOrder(), 1);

        // check destinations
        $this->assertEquals($this->options['one']->getDestinationID(), $this->questions['two']->getID());
        $this->assertEquals($this->options['two']->getDestinationID(), $this->questions['two']->getID());
        $this->assertEquals($this->options['two']->getDestinationType(), 'question');



        //*******************************************//
        //                                           //
        //         TEST MOVING OPTIONS!              //
        //                                           //
        //*******************************************//

        // move first to second
        $optionOneMoved = json_decode(
            Utility\putEndpoint('trees/'.$this->tree->getID().'/questions/'.$this->questions['one']->getID().'/options/'.$this->options['one']->getID().'/move/1', $data)
        );

        $this->assertEquals($optionOneMoved->order, 1);

        // get the other option and make sure it's now first
        $this->options['two'] = $this->getOptionFromEndpoint($this->tree->getID(), $this->questions['one']->getID(), $this->options['two']->getID());

        $this->assertEquals($this->options['two']->getOrder(), 0);


        //*******************************************//
        //                                           //
        //       TEST UPDATING OPTION TITLE!         //
        //                                           //
        //*******************************************//

        // update option title
        $data['title'] = $this->options['one']->getTitle().' Updated';
        $optionOneUpdated = json_decode(
            Utility\putEndpoint('trees/'.$this->tree->getID().'/questions/'.$this->questions['one']->getID().'/options/'.$this->options['one']->getID(), $data)
        );


        //*******************************************//
        //                                           //
        //       TEST MOVING OPTIONS                 //
        //       TO NEW QUESTION                     //
        //*******************************************//

        // move an option to another question
        $data['questionID'] = $this->questions['two']->getID();
        $data['destination'] = $this->questions['three']->getID();
        $optionOneUpdated = json_decode(
            Utility\putEndpoint('trees/'.$this->tree->getID().'/questions/'.$this->questions['one']->getID().'/options/'.$this->options['one']->getID(), $data)
        );
        //rebuild from the database so we can check for the new questionID
        $this->options['one'] = $this->options['one']->rebuild();
        $this->assertEquals($this->options['one']->getQuestionID(), $this->questions['two']->getID());
        $this->assertEquals($this->options['one']->getDestinationID(), $this->questions['three']->getID());
        // rebuild the question
        $this->questions['one'] = $this->questions['one']->rebuild();
        // check that the numbers line-up now. Option three should now be order = 1
        // rebuild it to validate
        $this->options['three'] = $this->options['three']->rebuild();
        $this->assertEquals($this->options['three']->getOrder(), 1);
        // check that it's NOT on the question it was before
        $this->assertEquals($this->questions['one']->getOptions(), [$this->options['two']->getID(), $this->options['three']->getID()]);


        //*******************************************//
        //                                           //
        //                 TEST DELETE!              //
        //                                           //
        //*******************************************//


        // Delete everything!
        // Deleting questions should delete all options. Let's delete one option first
        $this->assertTrue(
            json_decode(
                Utility\deleteEndpoint(
                    'trees/'.$this->tree->getID().'/questions/'.$this->questions['one']->getID().'/options/'.$this->options['three']->getID(),
                    $data
                )
            )
        );

        // delete the question
        foreach($this->questions as $question)  {
            $this->assertTrue(
                json_decode(
                    Utility\deleteEndpoint(
                        'trees/'.$this->tree->getID().'/questions/'.$question->getID(),
                        $data
                    )
                )
            );
        }

        // delete the tree
        $this->assertTrue(
            json_decode(
                Utility\deleteEndpoint(
                    'trees/'.$this->tree->getID(),
                    $data
                )
            )
        );

        // check to make sure the endpoints are deleted
        $treeDeleted = json_decode(
            Utility\getEndpoint('trees/'.$this->tree->getID())
        );
        // this expects that the tree status will be an error of something like 'Tree does not exist.' since we're trying to find a deleted tree
        $this->assertEquals($treeDeleted->status, 'error');

        $questionDeleted =json_decode(
            Utility\getEndpoint('trees/'.$this->tree->getID().'/questions/'.$this->questions['one']->getID())
        );
        $this->assertEquals($questionDeleted->status, 'error');

        $optionDeleted = json_decode(
            Utility\getEndpoint('trees/'.$this->tree->getID().'/questions/'.$this->questions['one']->getID().'/options/'.$this->options['three']->getID())
        );
        $this->assertEquals($optionDeleted->status, 'error');

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

    public function createOption($treeID, $questionID, $data) {
        // create a new tree
        $user = $this->getAdminUser();
        // add in the user to the request
        $data = [
            'title'       => $data['title'],
            'destination' => $data['destination'],
            'user'        => $user
        ];

        $option = json_decode(
            Utility\postEndpoint('trees/'.$treeID.'/questions/'.$questionID.'/options', $data)
        );

        // check that it's an object
        $this->assertTrue(is_object($option));

        // do we have an id?
        $this->assertTrue(Utility\isID($option->ID));

        // check that we can find it in the DB
        return new Option(new Database\DB(), $option->ID);
    }

    public function getOptionFromEndpoint($treeID, $questionID, $optionID) {
        $option = json_decode(
            Utility\getEndpoint('trees/'.$treeID.'/questions/'.$questionID.'/options/'.$optionID)
        );

        return new Option(new Database\DB(), $option->ID);
    }

}
