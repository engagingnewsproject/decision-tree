<?php
use PHPUnit\Framework\TestCase;
use Cme\Database as Database;

/**
 * Helper functions for DB Tests
 * @covers Cme\Database
 */
class DBTestCase extends TreeTestCase
{
    protected $db;

    protected function setUp()
    {

        $this->db = new Database\DB();
    }

    /**
    * Dynamically uses getter functions (like getQuestions) and returns the results
    *
    * @param $elType STRING of the el type you want ('question', 'end', 'group', or )
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
}
