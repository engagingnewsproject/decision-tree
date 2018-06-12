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
 * Functions for use by tests
 */
class TreeTestCase extends TestCase
{

    public function evaluateAssert($val, $expected) {
        if($expected === false) {
            $this->assertFalse($val);
        } else {
            $this->assertTrue($val);
        }
    }

    public function treeSetUp() {
        // $_SERVER["DOCUMENT_ROOT"] = "/Users/jj/Dropbox/mamp/sites/quiz";
    }

    public function treeTearDown() {
      // unset($_SERVER["DOCUMENT_ROOT"]);
    }

    public function getTreesProvider() {
        $db = new Database\DB();
        // get first three trees
        return array_slice($db->getTrees(), 0, 3);
    }

    public function getQuestionsProvider($treeID) {
        $db = new Database\DB();
        // get first three trees
        return array_slice($db->getQuestions($treeID), 0, 3);
    }

    public function getEndsProvider($treeID) {
        $db = new Database\DB();
        // get first three trees
        return array_slice($db->getEnds($treeID), 0, 3);
    }


    /**
    * Dynamically uses getter functions (like getQuestions) and returns the results
    *
    * @param $elType STRING of the el type you want ('question', 'end', 'group', or 'start')
    * @return ARRAY of first result from get_$elTypeS vs get_$elType($elID)
    */
    public function getAllDynamic($elType, $treeID) {
        $get = new Database\DB();
        $get_all_function = 'get'.ucfirst($elType).'s';

        return $get->$get_all_function($treeID);
    }

    /**
    * Dynamically uses single getter functions (like getQuestion) and returns the result
    *
    * @param $elType STRING of the el type you want ('question', 'end', 'group', or 'start')
    * @return ARRAY of first result from get_$elTypeS vs get_$elType($elID)
    */
    public function getOneDynamic($elType, $treeID, $elID = false) {
        $get = new Database\DB();

        if($elType === 'option') {
            return $this->getOneOptionDynamic($treeID);
        }

        if($elID === false) {
            // let's find one
            $elID = $this->getAllDynamic($elType, $treeID)[0][$elType.'ID'];
        }
        $get_one_function = 'get'.ucfirst($elType);
        return $get->$get_one_function($elID);
    }

    /**
    * Gets an option row from a tree
    */
    public function getOneOptionDynamic($treeID) {
        $get = new Database\DB();

        $question = $this->getOneDynamic('question', $treeID);
        $options = $get->getOptions($question['questionID']);
        return $options[0];
    }

    /**
     * Gets a random string
     * @param $length INT MUST BE LESS THAN 32
     * @return STRING
     */
    public static function randomString($length = 32) {
        $str = substr( "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" ,mt_rand( 0 ,51 ) ,1 ) .substr( md5( time() ), 1);

        return substr($str, 0, $length);
    }

    public static function getAdminUser() {
        return Utility\getUser('userRole', 'admin');
    }

    public static function createQuestion($treeID, $title) {
        // add in the user to the request
        $data = [
            'title' => $title,
            'user' => self::getAdminUser()
        ];

        $question = json_decode(
            Utility\postEndpoint('trees/'.$treeID.'/questions', $data)
        );

        // return from the DB
        return new Question(new Database\DB(), $question->ID);
    }

    public function getQuestionFromEndpoint($treeID, $questionID) {
        $question = json_decode(
            Utility\getEndpoint('trees/'.$treeID.'/questions/'.$questionID)
        );

        return new Question(new Database\DB(), $question->ID);
    }

    public static function createOption($treeID, $questionID, $data) {
        // add in the user to the request
        $data = [
            'title'       => $data['title'],
            'destinationID' => $data['destinationID'],
            'user'        => self::getAdminUser()
        ];

        $option = json_decode(
            Utility\postEndpoint('trees/'.$treeID.'/questions/'.$questionID.'/options', $data)
        );


        // check that we can find it in the DB
        return new Option(new Database\DB(), $option->ID);
    }

    public function getOptionFromEndpoint($treeID, $questionID, $optionID) {
        $option = json_decode(
            Utility\getEndpoint('trees/'.$treeID.'/questions/'.$questionID.'/options/'.$optionID)
        );

        return new Option(new Database\DB(), $option->ID);
    }

    public static function createTree($title) {
        // add in the user to the request
        $data = [
            'title' => $title,
            'user' => self::getAdminUser()
        ];

        $response = Utility\postEndpoint('trees', $data);

        $tree = json_decode($response);

        // check that we can find it in the DB
        return new Tree(new Database\DB(), $tree->ID);
    }

     // $options should have 'title' and 'destinationID'
    public static function createStart($treeID, $options = []) {
        // add in the user to the request
        $data = [
            'user' => self::getAdminUser()
        ];

        $data = array_merge($data, $options);

        $start = json_decode(
            Utility\postEndpoint('trees/'.$treeID.'/starts', $data)
        );

        // return from the DB
        return new Start(new Database\DB(), $start->ID);
    }

    public function getStartFromEndpoint($treeID, $startID) {
        $start = json_decode(
            Utility\getEndpoint('trees/'.$treeID.'/starts/'.$startID)
        );

        return new Start(new Database\DB(), $start->ID);
    }

    // $options should have 'title', 'content', 'questions'
    public static function createGroup($treeID, $options = []) {
        // add in the user to the request
        $data = [
            'user' => self::getAdminUser()
        ];

        $data = array_merge($data, $options);

        $group = Utility\postEndpoint('trees/'.$treeID.'/groups', $data);

        $group = json_decode($group);

        // return from the DB
        return new Group(new Database\DB(), $group->ID);
    }

    public function getGroupFromEndpoint($treeID, $groupID) {
        $group = json_decode(
            Utility\getEndpoint('trees/'.$treeID.'/groups/'.$groupID)
        );

        return new Group(new Database\DB(), $group->ID);
    }


    // $options should have 'content' and or 'title'
    public static function createEnd($treeID, $options = []) {
        // add in the user to the request
        $data = [
            'user' => self::getAdminUser()
        ];

        $data = array_merge($data, $options);

        $end = json_decode(
            Utility\postEndpoint('trees/'.$treeID.'/ends', $data)
        );

        // return from the DB
        return new End(new Database\DB(), $end->ID);
    }

    public function getEndFromEndpoint($treeID, $endID) {
        $end = json_decode(
            Utility\getEndpoint('trees/'.$treeID.'/ends/'.$endID)
        );

        return new End(new Database\DB(), $end->ID);
    }
}
