@:expose
@:keep
class HTMLParser {
    private var stack:List<Node> = new List<Node>();

    public function new() {
    }

    public function parseFromString(str:DOMString):Document {
        var doc = new Document();
        var input:DOMString = new String(str);
        var pos:Int = 0;
        var textBuffer:DOMString = "";

        while (pos < input.length) {
            if (input.charAt(pos) == "<") {
                if (textBuffer.length > 0)
                    pos += this.openNode(input.substr(pos), Node.TEXT_NODE);

                else if (isCloseNodeAtIndex(input, pos))
                    pos += this.closeNode(pos);

                else if (isCommentNodeAtIndex(input, pos))
                    pos += this.openNode(input.substr(pos), Node.COMMENT_NODE);

                else if (isCdataNodeAtIndex(input, pos))
                    pos += this.openNode(input.substr(pos), Node.CDATA_SECTION_NODE);

                else if (isDoctypeDeclarationNodeAtIndex(input, pos))
                    pos += this.openNode(input.substr(pos), Node.PROCESSING_INSTRUCTION_NODE);

                else
                    pos += this.openNode(input.substr(pos), Node.ELEMENT_NODE);

            } else {
                textBuffer += input.charAt(pos);
                pos++;
            }
        }

        return doc;
    }

    private function isCloseNodeAtIndex(input:DOMString, index:Int):Bool {
        return input.charAt(index + 1) == "/";
    }

    private function isCommentNodeAtIndex(input:DOMString, index:Int):Bool {
        return input.indexOf("!--", index) != -1;
    }

    private function isCdataNodeAtIndex(input:DOMString, index:Int):Bool {
        return input.indexOf("![CDATA[", index) != -1;
    }

    private function isDoctypeDeclarationNodeAtIndex(input:DOMString, index:Int):Bool {
        return input.indexOf("!DOCTYPE", index) != -1;
    }

    private function openNode(input:DOMString, type:Int):Int {
        if (type == Node.ELEMENT_NODE) {

        }

        return 0;
    }

    private function makeElement(tagName:DOMString):Element {
        return new Element();
    }

    private function closeNode(index:Int):Int {
        return index;
    }
}