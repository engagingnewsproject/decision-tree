<?php
use PHPUnit\Framework\TestCase;
use Cme\Database as Database;
use Cme\Utility as Utility;

/**
 * @covers index.php API Routes
 */
final class APITest extends TreeTestCase
{
    protected function setUp() {
        $this->db = new Database\DB();
    }

    /**
     * @covers api/v1/trees/
     */
    public function testGetTrees() {
        $trees = $this->db->getTrees();
        $this->assertEquals(Utility\getEndpoint('trees/'), json_encode($trees));
    }

    /**
     * @covers api/v1/trees/{{treeID}}
     * @covers api/v1/trees/{{treeSlug}}
     * @dataProvider APIGetTreeProvider
     */
    public function testAPIGetTree($tree) {
        $getTree = $this->db->getTree($tree);
        $this->assertEquals(Utility\getEndpoint('trees/'.$tree), json_encode($getTree));
    }

    public function APIGetTreeProvider() {
        $db = new Database\DB();
        $trees = $db->getTrees();
        $i = 0;
        $provider = [];

        foreach($trees as $tree) {
            $provider['tree_'.$tree['treeID']] = [$tree['treeID']];
            $provider['tree_'.$tree['treeSlug']] = [$tree['treeSlug']];
            $i++;
            if(5 < $i) {
                break;
            }
        }
        return $provider;
    }



}
