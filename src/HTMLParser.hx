@:expose
@:keep
class HTMLParser {
    /**
     *  List of valid html element names sorted alphebetically
     *
     *  https://developer.mozilla.org/en-US/docs/Web/HTML/Element
     */
    private static var elements:Array<String> = [
        "a", "abbr", "acronym", "address", "applet", "area", "article", "aside", "audio",
        "b", "base", "basefont", "bdi", "bdo", "bgsound", "big", "blink", "blockquote", "body", "br","button",
        "canvas", "caption", "center", "cite", "code", "col", "colgroup", "command", "content",
        "data", "datalist", "dd", "del", "details", "dfn", "dialog", "dir", "div", "dl", "dt",
        "element", "em", "embed", "fieldset", "figcaption", "figure", "font", "footer", "form", "frame", "frameset",
        "h1", "h2", "h3", "h4", "h5", "h6", "head", "header", "hgroup", "hr", "html",
        "i", "iframe", "image", "img", "input", "ins", "isindex", "kbd", "keygen", "label", "legend", "li", "link", "listing",
        "main", "map", "mark", "marquee", "menu", "menuitem", "meta", "meter", "multicol",
        "nav", "nobr", "noembed", "noframes", "noscript",
        "object", "ol", "optgroup", "option", "output",
        "p", "param", "picture", "plaintext", "pre", "progress",
        "q",
        "rp", "rt", "rtc", "ruby",
        "s", "samp", "script", "section", "select", "shadow", "slot", "small", "source", "spacer", "span", "strike", "strong", "style", "sub", "summary", "sup",
        "table", "tbody", "td", "template", "textarea", "tfoot", "th", "thead", "time", "title", "tr", "track", "tt",
        "u", "ul",
        "var", "video",
        "wbr",
        "xmp"
    ];

    /**
     *  map of attribute names to html element names denoting which attributes
     *  are valid for which html elements. '*' indicates the attribute can be
     *  used on all elements
     *
     *  https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes#Attribute_list
     */
    private static var attr2elem:Map<String, Array<String>> = [
        "accept" => ["form", "input"],
        "accept-charset" => ["form"],
        "accesskey" => ["*"],
        "action" => ["form"],
        "align" => ["applet", "caption", "col", "colgroup", "hr", "iframe", "img", "table", "tbody", "td", "tfoot", "th", "thead", "tr"],
        "alt" => ["applet", "area", "img", "input"],
        "async" => ["script"],
        "autocomplete" => ["form", "input"],
        "autofocus" => ["button", "input", "keygen", "select", "textarea"],
        "autoplay" => ["audio", "video"],
        "autosave" => ["input"],
        "bgcolor" => ["body", "col", "colgroup", "marquee", "table", "tbody", "tfoot", "td", "th", "tr"],
        "border" => ["img", "object", "table"],
        "buffered" => ["audio", "video"],
        "challenge" => ["keygen"],
        "charset" => ["meta", "script"],
        "checked" => ["command", "input"],
        "cite" => ["blockquote", "del", "ins", "q"],
        "class" => ["*"],
        "code" => ["applet"],
        "codebase" => ["applet"],
        "color" => ["basefont", "font", "hr"],
        "cols" => ["textarea"],
        "colspan" => ["td", "th"],
        "content" => ["meta"],
        "contenteditable" => ["*"],
        "contextmenu" => ["*"],
        "controls" => ["audio", "video"],
        "coords" => ["area"],
        "crossorigin" => ["audio", "img", "link", "script", "video"],
        "data" => ["object"],
        "data-*" => ["*"],
        "datetime" => ["del", "ins", "time"],
        "default" => ["track"],
        "defer" => ["script"],
        "dir" => ["*"],
        "dirname" => ["input", "textarea"],
        "disabled" => ["button", "command", "fieldset", "input", "keygen", "optgroup", "option", "select", "textarea"],
        "download" => ["a", "area"],
        "draggable" => ["*"],
        "dropzone" => ["*"],
        "enctype" => ["form"],
        "for" => ["label", "output"],
        "form" => ["button", "fieldset", "input", "keygen", "label", "meter", "object", "progress", "select", "textarea"],
        "formaction" => ["input", "button"],
        "headers" => ["td", "th"],
        "height" => ["canvas", "embed", "iframe", "img", "input", "object", "video"],
        "hidden" => ["*"],
        "high" => ["meter"],
        "href" => ["a", "area", "base", "link"],
        "hreflang" => ["a", "area", "link"],
        "http-equiv" => ["meta"],
        "icon" => ["command"],
        "id" => ["*"],
        "integrity" => ["link", "script"],
        "ismap" => ["img"],
        "itemprop" => ["*"],
        "keytype" => ["keygen"],
        "kind" => ["track"],
        "label" => ["track"],
        "lang" => ["*"],
        "language" => ["script"],
        "list" => ["input"],
        "loop" => ["audio", "bgsound", "marquee", "video"],
        "low" => ["meter"],
        "manifest" => ["html"],
        "max" => ["input", "meter", "progress"],
        "maxlength" => ["input", "textarea"],
        "minlength" => ["input", "textarea"],
        "media" => ["a", "area", "link", "source", "style"],
        "method" => ["form"],
        "min" => ["input", "meter"],
        "multiple" => ["input", "select"],
        "muted" => ["video"],
        "name" => ["button", "form", "fieldset", "iframe", "input", "keygen", "object", "output", "select", "textarea", "map", "meta", "param"],
        "novalidate" => ["form"],
        "open" => ["details"],
        "optimum" => ["meter"],
        "pattern" => ["input"],
        "ping" => ["a", "area"],
        "placeholder" => ["input", "textarea"],
        "poster" => ["video"],
        "preload" => ["audio", "video"],
        "radiogroup" => ["command"],
        "readonly" => ["input", "textarea"],
        "rel" => ["a", "area", "link"],
        "required" => ["input", "select", "textarea"],
        "reversed" => ["ol"],
        "rows" => ["textarea"],
        "rowspan" => ["td", "th"],
        "sandbox" => ["iframe"],
        "scope" => ["th"],
        "scoped" => ["style"],
        "seamless" => ["iframe"],
        "selected" => ["option"],
        "shape" => ["a", "area"],
        "size" => ["input", "select"],
        "sizes" => ["link", "img", "source"],
        "slot" => ["*"],
        "span" => ["col", "colgroup"],
        "spellcheck" => ["*"],
        "src" => ["audio", "embed", "iframe", "img", "input", "script", "source", "track", "video"],
        "srcdoc" => ["iframe"],
        "srclang" => ["track"],
        "srcset" => ["img"],
        "start" => ["ol"],
        "step" => ["input"],
        "style" => ["*"],
        "summary" => ["table"],
        "tabindex" => ["*"],
        "target" => ["a", "area", "base", "form"],
        "title" => ["*"],
        "type" => ["button", "input", "command", "embed", "object", "script", "source", "style", "menu"],
        "usemap" => ["img", "input", "object"],
        "value" => ["button", "option", "input", "li", "meter", "progress", "param"],
        "width" => ["canvas", "embed", "iframe", "img", "input", "object", "video"],
        "wrap" => ["textarea"]
    ];

    /**
     *  maintains a list of open nodes in which we have not encountered their
     *  closing tag token
     */
    private var stack:List<Node> = new List<Node>();

    /**
     *  constructor
     */
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