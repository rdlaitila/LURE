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
 *  HTMLLexer takes html input and emits tokens
 */
class HTMLLexer
{
    /**
     * source input
     */
    private var input:haxe.io.Input;

    /**
     *  position in input stream
     */
    private var pos:Int = 0;

    /**
     *  holds a map of emitted tokens from this lexer. The boolean indicates if
     *  the token can be re-used in another call to peek() or next()
     */
    private var emitted:Map<HTMLToken, Bool> = new Map<HTMLToken, Bool>();

    /**
     *  holds the last emitted token
     */
    private var last:HTMLToken = null;

    /**
     *  constructor
     *  @param input -
     */
    public function new(input:haxe.io.Input) {
        this.input = input;
    }

    /**
     *  peek parses and returns the next token but does not advance the lexer
     *  stream. repeated calls to peek will return the same token until next()
     *  is called. If peek is called before next() is first called peek() returns null
     *  @return HTMLToken
     */
    public function peek():HTMLToken {
        return this.last;
    }

    /**
     *  next parses and returns the next token in the lexer's stream. Each succ-
     *  essive call to next advances the stream to the next token.
     *  @return HTMLToken
     */
    public function next():HTMLToken {
        var token = this.getToken();
        var textbuffer = new String("");

        while(true)
        {
            var char = this.input.read(1).toString();

            switch(char)
            {
                case "<":
                    token.type = HTMLTokenType.TagOpen;
                    openNode(token);
                    break;
            }
        }

        return token;
    }

    /**
     *  Instructs this HTMLLexer to reclaim and re-use the supplied token for a
     *  next call to next() or peek(). Callers MUST NOT retain or access references
     *  to tokens that are passed back to the lexer for re-use. Only tokens emitted
     *  by the lexer can be passed to reclaim otherwise an exception will be thrown.
     *  token data values are appropriatly reset/cleared before being re-emitted.
     *  @param token -
     */
    public function reclaim(token:HTMLToken):Void {
        if (!this.emitted.exists(token)) {
            throw "no such token emitted";
        }

        token.clear();

        this.emitted.set(token, true);
    }

    /**
     *  gets a reclaimed or new token
     *  @return HTMLToken
     */
    private function getToken():HTMLToken {
        var emittedIter = this.emitted.keys();

        while(emittedIter.hasNext()) {
            var token = emittedIter.next();
            if (this.emitted.get(token) == true) {
                this.emitted.set(token, false);
                return token;
            }
        }

        var token = new HTMLToken();
        this.emitted.set(token, false);

        return token;
    }

    private function openNode(token:HTMLToken) {
        var fulltag = "";
        var tagbuffer = "";

        while(true)
        {
            var char = this.input.read(1).toString();

            switch(char)
            {
                case " ":
                    break;
                case
            }
        }
    }
}