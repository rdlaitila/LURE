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
 * Represents a single token emited from the HTMLLexer
 */
 @:expose
 @:keep
class HTMLToken {
    /**
     *  Provides the type of this token
     */
    @:allow(HTMLLexer.next)
    public var type(default, null):HTMLTokenType;

    /**
     *  Contains the parsed token data if this token is of type HTMLTokenType.TagOpen
     */
    public var tagOpenData = {
        ns: "",
        name: "",
        attr: new Map<String, Attr>(),
    };

    /**
     *  Contains the parsed token data if this token is of type HTMLTokenType.TagClose
     */
    public var tagCloseData = {
        ns: "",
        name: "",
    };

    /**
     *  Contains the parsed token data if this token is of type HTMLTokenType.CdataSection
     */
    public var cdataSectionData = {
        text: "",
    }

    /**
     *  Contains the parsed token data if this token is of type HTMLTokenType.Comment
     */
    public var commentData = {
        text: "",
    }

    /**
     *  constructor
     */
    public function new() {
    }

    /**
     *  clears token data back to defaults
     */
    @:allow(HTMLLexer.reclaim)
    private function clear() {
        this.type = HTMLTokenType.Unknown;

        // clear cdata
        this.cdataSectionData.text = "";

        // clear comment
        this.commentData.text = "";

        // clear tagClose
        this.tagCloseData.name = "";
        this.tagCloseData.ns = "";

        // clear tagOpen
        this.tagOpenData.name = "";
        this.tagOpenData.ns = "";

        var todi = this.tagOpenData.attr.keys();
        while(todi.hasNext()) {
            this.tagOpenData.attr.remove(todi.next());
        }
    }
}