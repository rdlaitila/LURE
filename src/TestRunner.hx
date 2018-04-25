class TestRunner {
    static public function main():Void {
        var r = new haxe.unit.TestRunner();

        r.add(new DOMParser_test());
        r.add(new DOMString_test());
        r.add(new EventTarget_test());
        r.add(new HTMLParser_test());
        r.add(new Node_test());
        r.add(new NodeList_test());
        r.add(new XMLParser_test());
        r.add(new HTMLLexer_test());

        r.run();
    }
}