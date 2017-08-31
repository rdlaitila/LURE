
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
     *  holds a map of emitted tokens from this lexer. The boolean indicates if
     *  the token can be re-used in another call to peek() or next()
     */
    private var emitted:Map<HTMLToken, Bool> = new Map<HTMLToken, Bool>();

    /**
     *  constructor
     *  @param input -
     */
    public function new(input:haxe.io.Input) {
    }

    /**
     *  peek parses and returns the next token but does not advance the lexer
     *  stream. repeated calls to peek will return the same token until next()
     *  is called. If peek is called before next() is first called peek() returns null
     *  @return HTMLToken
     */
    public function peek():HTMLToken {
        return null;
    }

    /**
     *  next parses and returns the next token in the lexer's stream. Each succ-
     *  essive call to next advances the stream to the next token.
     *  @return HTMLToken
     */
    public function next():HTMLToken {
        return null;
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
    }
}