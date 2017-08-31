class HTMLToken {
    /**
     *  Provides the type of this token
     */
    public var type(default, null):HTMLTokenType;

    /**
     *  Contains the parsed token data if this token is of type HTMLTokenType.TagOpen
     */
    public var tagOpenData = {
        ns: "",
        name: "",
        attr: new List<Attr>()
    };

    /**
     *  Contains the parsed token data if this token is of type HTMLTokenType.TagClose
     */
    public var tagCloseData = {
        ns: "",
        name: "",
    };
}