import haxe.unit.TestCase;

class XMLParser_test extends haxe.unit.TestCase {
    public function test_parseFromString_throws_not_implemented() {
        try {
            var parser = new XMLParser();
            parser.parseFromString(null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }
}
