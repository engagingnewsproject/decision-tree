<?php
use PHPUnit\Framework\TestCase;
use Cme\Utility as Utility;
/**
 * @covers Cme\Utility
 */
final class UtilityTest extends TreeTestCase
{
    /**
     * @covers Cme\Utility\isID()
     * @dataProvider validateIdProvider
     */
    public function testValidateId($id, $expected) {
        $valid = Utility\isID($id);
        $this->evaluateAssert($valid, $expected);
    }

    public function validateIdProvider() {
        return [
                'valid-1'=>['123456789', true],
                'valid-2'=>[1, true],
                'valid-3'=>['999', true],
                'invalid-1'=>['0', false],
                'invalid-2'=>['h123', false],
                'invalid-3'=>['!12', false],
                'invalid-4'=>['', false],
                'invalid-5'=>[true, false],
                'invalid-6'=>[false, false]
        ];
    }

    /**
     * @covers Cme\Utility\isSlug()
     * @dataProvider isSlugProvider
     */
    public function testIsSlug($slug, $expected) {
        $valid = Utility\isSlug($slug);
        $this->evaluateAssert($valid, $expected);
    }

    public function isSlugProvider() {
        return [
                'valid-1'=>['yes', true],
                'valid-2'=>['wut-up-dawg', true],
                'valid-3'=>['of-curze-123', true],
                'invalid-1'=>['NoPe', false],
                'invalid-2'=>['notaslug!!!!', false],
                'invalid-3'=>[0, false],
                'invalid-4'=>[1, false],
                'invalid-5'=>['', false],
                'invalid-6'=>[true, false],
                'invalid-7'=>['-hi', false],
                'invalid-8'=>['hi-', false],
        ];
    }

    /**
     * @covers Cme\Utility\getTreeSlugById($treeID)
     * @dataProvider getTreeSlugByIdProvider
     */
    public function testGetTreeSlugById($id, $expected) {
        // $cme_save = new Cme_quiz_Save();
        $treeSlug = Utility\getTreeSlugById($id);
        $this->assertEquals($treeSlug, $expected);
    }

    public function getTreeSlugByIdProvider() {
        return [
                'integer'           =>[1, 'citizen'],
                'integer-as-string' =>['1', 'citizen'],
                'invalid-string'    =>['alwiheawra848aasdlkfnalsdkfnadf', null],
                'invalid-zero'      =>['0', null],
                'invalid-empty'     =>['', false],
                'invalid-bool-true' =>[true, false],
                'invalid-bool-false'=>[false, false]
        ];
    }

    /**
     * @covers Cme\Utility\getTreeIDBySlug($treeID)
     * @dataProvider getTreeIdBySlugProvider
     */
    public function testGetTreeIdBySlug($slug, $expected) {
        $treeID = Utility\getTreeIDBySlug($slug);
        $this->assertEquals($treeID, $expected);
    }

    public function getTreeIdBySlugProvider() {
        return [
                'valid-slug'        =>['citizen', '1'],
                'invalid-slug'      =>['alwiheawra848aasdlkfnalsdkfnadf', null],
                'invalid-empty'     =>['', false],
                'invalid-bool-true' =>[true, false],
                'invalid-bool-false'=>[false, false]
        ];
    }

    /**
     * @covers Cme\Utility\move()
     * @dataProvider moveProvider
     */
    public function testMove($array, $val, $to, $expected) {
        $moved = Utility\move($array, $val, $to);
        $this->assertEquals($moved, $expected);
    }

    public function moveProvider() {
        return [
                'move-to-front'=>[[2, 1, 3, 4], 1, 'first', [1,2,3,4]],
                'move-to-end'=>[[4,1,2,3], 4, 'last', [1,2,3,4]],
                'move-to-second'=>[[1,3,2,4], 2, 1, [1,2,3,4]],
                'move-to-third'=>[[1,2,4,3], 3, 2, [1,2,3,4]]
        ];
    }
}
