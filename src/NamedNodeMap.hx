/**
 *  The NamedNodeMap interface represents a collection of Attr objects. Objects
 *  inside a NamedNodeMap are not in any particular order, unlike NodeList, although
 *  they may be accessed by an index as in an array.
 *
 *  A NamedNodeMap object is live and will thus be auto-updated if changes are
 *  made to its contents internally or elsewhere.
 *
 *  https://developer.mozilla.org/en-US/docs/Web/API/NamedNodeMap
 */
 @:keep
abstract NamedNodeMap(Map<DOMString, Attr>) {
    /**
     *  constructor
     */
    public function new() {
        this = new Map<DOMString, Attr>();
    }
}