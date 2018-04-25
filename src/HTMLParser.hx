/*
 * Copyright (c) 2017 Regan Daniel Laitila
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/**
 *  parser for html
 *
 *  https://www.w3.org/TR/2011/WD-html5-20110113/parsing.html
 */
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

    /**
     *  produces a HTML Document from HTML source string
     *  @param str - source html string
     *  @return HTMLDocument
     */
    public function parseFromString(str:DOMString):HTMLDocument {
        var doc = new HTMLDocument();
        var lex = new HTMLLexer(new haxe.io.StringInput(str));
        var eof = false;

        while(!eof) {
            var token = lex.next();

            switch(token.type) {
                case HTMLTokenType.TagOpen:
                    this.openTag(token);

                case HTMLTokenType.TagClose:
                    this.closeTag(token);

                case HTMLTokenType.CdataSection:
                    this.handleCdata(token);

                case HTMLTokenType.Comment:
                    this.handleComment(token);

                case HTMLTokenType.EOF:
                    eof = true;

                default:
                    throw "unknown token";
            }
        }

        return doc;
    }

    /**
     *  opens and adds a new tag element on the stack
     *  @param token -
     */
    private function openTag(token:HTMLToken):Void {
        var isUnknownElement = (HTMLParser.elements.indexOf(token.tagOpenData.name.toLowerCase()) > -1);
    }

    /**
     *  closes a matching tag on the stack
     *  @param token -
     */
    private function closeTag(token:HTMLToken):Void {
    }

    /**
     *  handles incoming cdata section
     *  @param token -
     */
    private function handleCdata(token:HTMLToken):Void {
    }

    /**
     *  handles incoming comment
     *  @param token -
     */
    private function handleComment(token:HTMLToken):Void {
    }
}