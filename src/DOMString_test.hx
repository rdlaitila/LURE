import haxe.unit.TestCase;

class DOMString_test extends haxe.unit.TestCase {
    public function test_DOMString_is_string() {
        var str1:String = "hello";
        var str2:DOMString = "hello";
        assertEquals(str1, str2);
    }
}