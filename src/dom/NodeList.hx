package dom;

/**
 *  NodeList objects are collections of nodes such as those returned by properties
 *  such as Node.childNodes and the document.querySelectorAll() method.
 *
 *  https://developer.mozilla.org/en-US/docs/Web/API/NodeList
 */
@:expose
class NodeList {
    /**
     *  length returns the number of items in a NodeList.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/NodeList/length
     */
    public var length(default, null):Int;

    /**
     *  internal store of available nodes in the list
     */
    private var items:Array<Node> = new Array<Node>();

    /**
     *  Constructor
     */
    public function new() {
        this.length = 0;
    }

    /**
     *  Returns a node from a NodeList by index. This method doesn't throw
     *  exceptions as long as you provide arguments. A value of null is returned
     *  if the index is out of range, and a TypeError is thrown if no argument is
     *  provided.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/NodeList/item
     *  @param index -
     *  @return dom.Node
     */
    public function item(index:Int):Node {
        if (index < 0) return null;
        if (index > this.items.length) return null;
        return this.items[index];
    }

    /**
     *  The NodeList.entries() method returns an iterator allowing to go through
     *  all key/value pairs contained in this object. The values are Node objects.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/NodeList/entries
     *  @return Iterator<null>
     */
    public function entries():Void {
        throw lib.Exceptions.NotImplemented;
    }

    /**
     *  The forEach() method of the NodeList interface calls the callback given
     *  in parameter once for each value pair in the list, in insertion order.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/NodeList/forEach
     */
    public function forEach():Void {
        throw lib.Exceptions.NotImplemented;
    }

    /**
     *  The NodeList.keys() method returns an iterator allowing to go through
     *  all keys contained in this object. The keys are unsigned integer.
     *  https://developer.mozilla.org/en-US/docs/Web/API/NodeList/keys
     *  @return void
     */
    public function keys():Void {
        throw lib.Exceptions.NotImplemented;
    }

    /**
     *  The NodeList.values() method returns an iterator allowing to go through
     *  all values contained in this object. The values are Node objects.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/NodeList/values
     *  @return void
     */
    public function values():Void {
        throw lib.Exceptions.NotImplemented;
    }
}