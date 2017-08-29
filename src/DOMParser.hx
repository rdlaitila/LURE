/**
 *  Valid types to supply to DOMParser.parseFromString
 *
 *  https://w3c.github.io/DOM-Parsing/#x2.-apis-for-parsing-and-serializing-dom
 */
enum DOMParserSupportedType {
    TextHtml;
    TextXml;
    ApplicationXml;
    ApplicationXHtmlXml;
    ImageSvgXml;
}

/**
 *  DOMParser can parse XML or HTML source stored in a string into a DOM Document.
 *  DOMParser is specified in DOM Parsing and Serialization (https://w3c.github.io/DOM-Parsing/)
 *
 *  https://developer.mozilla.org/en-US/docs/Web/API/DOMParser
 */
@:expose
class DOMParser {
    /**
     *  constructor
     */
    public function new() {
    }

    /**
     *  Parse str using a parser that matches type's supported MIME types
     *  (either XML or HTML), and return a Document object contained the parsed
     *  content if successful. If not successful, returns a Document describing
     *  the error. If type does not match a value in the SupportedType
     *  enumeration, an exception is thrown
     *
     *  https://w3c.github.io/DOM-Parsing/#apis-for-parsing-and-serializing-dom
     *
     *  @param srcText -
     *  @param mime -
     *  @return Document
     */
    public function parseFromString(str:DOMString, type:DOMParserSupportedType):Document {
        switch(type) {
            case DOMParserSupportedType.TextHtml:
                return new HTMLParser().parseFromString(str);

            case DOMParserSupportedType.TextXml:
                return new XMLParser().parseFromString(str);

            case DOMParserSupportedType.ApplicationXml:
                return new XMLParser().parseFromString(str);

            case DOMParserSupportedType.ApplicationXHtmlXml:
                return new XMLParser().parseFromString(str);

            case DOMParserSupportedType.ImageSvgXml:
                return new XMLParser().parseFromString(str);

            default:
                throw 'unsupported type ${Std.string(type)}';
        }
    }
}