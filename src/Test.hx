class Test {
    static public function main():Void {
        var r = new haxe.unit.TestRunner();
        r.add(new dom.EventTarget_test());
        r.add(new dom.Node_test());
        r.run();
    }
}