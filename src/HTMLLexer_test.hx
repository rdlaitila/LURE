import haxe.unit.TestCase;

class HTMLLexer_test extends haxe.unit.TestCase {
    public function test_lexer_detects_single_open_tag() {
        var input = new haxe.io.StringInput("<namespace:some-tag>");
        var lexer = new HTMLLexer(input);

        var token = lexer.next();

        assertEquals(HTMLTokenType.TagOpen, token.type);
        assertEquals("namespace", token.tagOpenData.ns);
    }

}
