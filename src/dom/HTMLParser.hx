package dom;

@:expose
class HTMLParser {
    public function new() {
    }

    public function parseFromString(str:DOMString):Document {
        throw lib.Exceptions.NotImplemented;
        return null;
    }
}