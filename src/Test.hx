class Test {
    static public function main():Void {
        var r = new haxe.unit.TestRunner();

        r.add(new dom.DOMParser_test());
        r.add(new dom.DOMString_test());
        r.add(new dom.EventTarget_test());
        r.add(new dom.HTMLParser_test());
        r.add(new dom.Node_test());
        r.add(new dom.XMLParser_test());

        r.run();

    }
}