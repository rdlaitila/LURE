import haxe.unit.TestCase;

class HTMLParser_test extends haxe.unit.TestCase {
    public function test_parseFromString_throws_not_implemented() {
        try {
            var parser = new HTMLParser();
            parser.parseFromString(null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }
}
