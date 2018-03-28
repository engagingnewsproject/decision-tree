<?php
use PHPUnit\Framework\TestCase;
use Cme\Utility as Utility;
use Cme\Database as Database;
/**
 * @covers Cme\Database
 */
final class DBTest extends TreeTestCase
{
    /**
     * @covers Cme\Utility\is_id()
     * @dataProvider testValidateIDProvider
     */
    public function testValidateID($id, $expected) {
        $valid = Utility\is_id($id);
        $this->evaluateAssert($valid, $expected);
    }

    public function testValidateIDProvider() {
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


}
