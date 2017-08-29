/**
 *  Node is an interface from which a number of DOM API object types inherit; it
 *  allows these various types to be treated similarly, for example inheriting the
 *  same set of methods, or being tested in the same way.
 *
 *  The following interfaces all inherit from Node its methods and properties:
 *  Document, Element, CharacterData (which Text, Comment, and CDATASection inherit),
 *  ProcessingInstruction, DocumentFragment, DocumentType, Notation, Entity, EntityReference
 *
 *  These interfaces may return null in particular cases where the methods and
 *  properties are not relevant. They may throw an exception - for example when
 *  adding children to a node type for which no children can exist.
 *
 *  https://developer.mozilla.org/en-US/docs/Web/API/Node
 */
@:expose
@:keep
class Node extends EventTarget {
    /**
     *  An Attribute of an Element. The element attributes are no longer
     *  implementing the Node interface in DOM4 specification.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType#Constants
     */
    public static inline var ATTRIBUTE_NODE:Int = 2;

    /**
     *  A CDATASection. Removed in DOM4 specification.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType#Constants
     */
    public static inline var CDATA_SECTION_NODE:Int = 4;

    /**
     *  A Comment node.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType#Constants
     */
    public static inline var COMMENT_NODE:Int = 8;

    /**
     *  A Document node.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType#Constants
     */
    public static inline var DOCUMENT_NODE:Int = 9;

    /**
     *  A DocumentType node e.g. <!DOCTYPE html> for HTML5 documents.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType#Constants
     */
    public static inline var DOCUMENT_TYPE_NODE:Int = 10;

    /**
     *  A DocumentFragment node.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType#Constants
     */
    public static inline var DOCUMENT_FRAGMENT_NODE:Int = 11;

    /**
     *  An Element node such as <p> or <div>.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType#Constants
     */
    public static inline var ELEMENT_NODE:Int = 1;

    /**
     *  An XML Entity Reference node. Removed in DOM4 specification.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType#Constants
     */
    public static inline var ENTITY_REFERENCE_NODE:Int = 5;

    /**
     *  An XML <!ENTITY ...> node. Removed in DOM4 specification.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType#Constants
     */
    public static inline var ENTITY_NODE:Int = 6;

    /**
     *  An XML <!NOTATION ...> node. Removed in DOM4 specification.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType#Constants
     */
    public static inline var NOTATION_NODE:Int = 12;

    /**
     *  A ProcessingInstruction of an XML document such as <?xml-stylesheet ... ?>
     *  declaration.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType#Constants
     */
    public static inline var PROCESSING_INSTRUCTION_NODE:Int = 7;

    /**
     *  The actual Text of Element or Attr.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType#Constants
     */
    public static inline var TEXT_NODE:Int = 3;

    /**
     *  The Node.baseURI read-only property returns the absolute base URL of a node.
     *
     *  The base URL is used to resolve relative URLs when the browser needs to
     *  obtain an absolute URL, for example when processing the HTML <img> element's
     *  src attribute or XML xlink:href attribute.
     *
     *  In the common case the base URL is simply the location of the document,
     *  but it can be affected by many factors, including the <base> element in
     *  HTML and xml:base attribute in XML.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/baseURI
     */
    public var baseURI(default, null):DOMString;

    /**
     *  The Node.childNodes read-only property returns a live collection of child
     *  nodes of the given element where the first child node is assigned index 0.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/childNodes
     */
    public var childNodes(default, null):NodeList = new NodeList();

    /**
     *  The Node.firstChild read-only property returns the node's first child in
     *  the tree, or null if the node is childless. If the node is a Document,
     *  it returns the first node in the list of its direct children.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/firstChild
     */
    public var firstChild(default, null):Node;

    /**
     *  The Node.lastChild read-only property returns the last child of the node.
     *  If its parent is an element, then the child is generally an element node,
     *  a text node, or a comment node. It returns null if there are no child elements.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/lastChild
     */
    public var lastChild(default, null):Node;

    /**
     *  The Node.nextSibling read-only property returns the node immediately
     *  following the specified one in its parent's childNodes list, or null if
     *  the specified node is the last node in that list.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nextSibling
     */
    public var nextSibling(default, null):Node;

    /**
     *  The Node.nodeName read-only property returns the name of the current node
     *  as a string.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeName
     */
    public var nodeName(default, null):DOMString;

    /**
     *  The read-only Node.nodeType property that represents the type of the node.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeType
     */
    public var nodeType(default, null):Int;

    /**
     *  The Node.nodeValue property returns or sets the value of the current node
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/nodeValue
     */
    public var nodeValue:Any;

    /**
     *  The Node.ownerDocument read-only property returns the top-level document
     *  object for this node.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/ownerDocument
     */
    public var ownerDocument(default, null):Document;

    /**
     *  The Node.parentNode read-only property returns the parent of the
     *  specified node in the DOM tree.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/parentNode
     */
    public var parentNode(default, null):Node;

    /**
     *  The Node.parentElement read-only property returns the DOM node's parent
     *  Element, or null if the node either has no parent, or its parent isn't a
     *  DOM Element.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/parentElement
     */
    public var parentElement(default, null):Element;

    /**
     *  The Node.previousSibling read-only property returns the node immediately
     *  preceding the specified one in its parent's childNodes list, or null if
     *  the specified node is the first in that list.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/previousSibling
     */
    public var previousSibling(default, null):Node;

    /**
     *  The Node.textContent property represents the text content of a node and
     *  its descendants.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/textContent
     */
    public var textContent:DOMString;

    /**
     *  constructor
     */
    public function new() {
        super();
    }

    /**
     *  The Node.appendChild() method adds a node to the end of the list of children
     *  of a specified parent node. If the given child is a reference to an existing
     *  node in the document, appendChild() moves it from its current position to
     *  the new position (there is no requirement to remove the node from its parent
     *  node before appending it to some other node).
     *
     *  This means that a node can't be in two points of the document simultaneously.
     *  So if the node already has a parent, the node is first removed, then appended
     *  at the new position. The Node.cloneNode() can be used to make a copy of the
     *  node before appending it under the new parent. Note that the copies made
     *  with cloneNode will not be automatically kept in sync.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/appendChild
     *
     *  @param Node -
     */
    public function appendChild(child:Node):Node {
        throw Exceptions.NotImplemented;
        return null;
    }

    /**
     *  The Node.cloneNode() method returns a duplicate of the node on which this
     *  method was called.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/cloneNode
     *
     *  @param deep - true if the children of the node should also be cloned, or
     *  false to clone only the specified node.
     *  @return Node - The new node that will be a clone of node
     */
    public function cloneNode(deep:Bool):Node {
        throw Exceptions.NotImplemented;
        return null;
    }

    /**
     *  The Node.compareDocumentPosition() method compares the position of the
     *  current node against another node in any other document.The return value
     *  is a bitmask with the following values:
     *
     *  Name 	Value
     *  DOCUMENT_POSITION_DISCONNECTED 	1
     *  DOCUMENT_POSITION_PRECEDING 	2
     *  DOCUMENT_POSITION_FOLLOWING 	4
     *  DOCUMENT_POSITION_CONTAINS 	8
     *  DOCUMENT_POSITION_CONTAINED_BY 	16
     *  DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC 	32
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/compareDocumentPosition
     *
     *  @param node -
     */
    public function compareDocumentPosition(node:Node):Void {
        throw Exceptions.NotImplemented;
    }

    /**
     *  The Node.contains() method returns a Boolean value indicating whether a
     *  node is a descendant of a given node or not.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/contains
     *
     *  @param node -
     *  @return Bool
     */
    public function contains(node:Node):Bool {
        throw Exceptions.NotImplemented;
        return false;
    }

    /**
     *  The Node.hasChildNodes() method returns a Boolean value indicating whether
     *  the current Node has child nodes or not.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/hasChildNodes
     *
     *  @return Bool
     */
    public function hasChildNodes():Bool {
        throw Exceptions.NotImplemented;
        return false;
    }

    /**
     *  The Node.insertBefore() method inserts the specified node before the reference
     *  node as a child of the current node.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/insertBefore
     *
     *  @param newNode -
     *  @param referenceNode -
     *  @return Node
     */
    public function insertBefore(newNode:Node, referenceNode:Node):Node {
        throw Exceptions.NotImplemented;
        return null;
    }

    /**
     *  The Node.isDefaultNamespace() method accepts a namespace URI as an argument
     *  and returns a Boolean with a value of true if the namespace is the default
     *  namespace on the given node or false if not.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/isDefaultNamespace
     *
     *  @param namespaceURI -
     *  @return Bool
     */
    public function isDefaultNamespace(namespaceURI):Bool {
        throw Exceptions.NotImplemented;
        return false;
    }

    /**
     *  The Node.isEqualNode() method tests whether two nodes are equal. Two nodes
     *  are equal when they have the same type, defining characteristics (for
     *  elements, this would be their ID, number of children, and so forth), its
     *  attributes match, and so on. The specific set of data points that must
     *  match varies depending on the types of the nodes.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/isEqualNode
     *
     *  @param otherNode -
     *  @return Bool
     */
    public function isEqualNode(otherNode:Node):Bool {
        throw Exceptions.NotImplemented;
        return false;
    }

    /**
     *  The Node.isSameNode() method tests whether two nodes are the same, that
     *  is if they reference the same object.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/isSameNode
     *
     *  @param other -
     *  @return Bool
     */
    public function isSameNode(other:Node):Bool {
        throw Exceptions.NotImplemented;
        return false;
    }

    /**
     *  The Node.lookupNamespaceURI() method accepts a prefix and returns the namespace
     *  URI associated with it on the given node if found (and null if not). Supplying
     *  null for the prefix will return the default namespace.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/lookupNamespaceURI
     */
    public function lookupNamespaceURI(prefix:String):String {
        throw Exceptions.NotImplemented;
        return null;
    }

    /**
     *  The Node.lookupPrefix() method returns a DOMString containing the prefix
     *  for a given namespace URI, if present, and null if not. When multiple
     *  prefixes are possible, the result is implementation-dependent.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/lookupPrefix
     *
     *  @return DOMString
     */
    public function lookupPrefix():DOMString {
        throw Exceptions.NotImplemented;
        return null;
    }

    /**
     *  The Node.normalize() method puts the specified node and all of its sub-tree
     *  into a "normalized" form. In a normalized sub-tree, no text nodes in the
     *  sub-tree are empty and there are no adjacent text nodes.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/normalize
     */
    public function normalize():Void {
        throw Exceptions.NotImplemented;
    }

    /**
     *  The Node.removeChild() method removes a child node from the DOM. Returns
     *  removed node.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/removeChild
     *
     *  @param child -
     *  @return Node
     */
    public function removeChild(child:Node):Node {
        throw Exceptions.NotImplemented;
        return null;
    }

    /**
     *  The Node.replaceChild() method replaces one child node of the specified
     *  node with another.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Node/replaceChild
     *
     *  @param newChild - is the new node to replace oldChild. If it already
     *  exists in the DOM, it is first removed.
     *  @param oldChild - is the existing child to be replaced.
     *  @return Node is the replaced node. This is the same node as oldChild.
     */
    public function replaceChild(newChild:Node, oldChild:Node):Node {
        throw Exceptions.NotImplemented;
        return null;
    }
}