
/**
 *  Element is the most general base class from which all objects in a Document
 *  inherit. It only has methods and properties common to all kinds of element.
 *  More specific classes inherit from Element. For example, the HTMLElement interface
 *  is the base interface for HTML elements, while the SVGElement interface is
 *  the basis for all SVG elements. Most functionality is specified further down
 *  the class hierarchy.
 *
 *  https://developer.mozilla.org/en-US/docs/Web/API/Element
 */
@:expose
@:keep
class Element extends Node {
    /**
     *  The Element.attributes property returns a live collection of all attribute
     *  nodes registered to the specified node. It is a NamedNodeMap, not an Array,
     *  so it has no Array methods and the Attr nodes' indexes may differ among
     *  browsers. To be more specific, attributes is a key/value pair of strings
     *  that represents any information regarding that attribute.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/attributes
     */
    public var attributes(default, null):NamedNodeMap = new NamedNodeMap();

    /**
     *  The Element.classList is a read-only property which returns a live
     *  DOMTokenList collection of the class attributes of the element.
     *
     *  Using classList is a convenient alternative to accessing an element's
     *  list of classes as a space-delimited string via element.className.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/classList
     */
    public var classList(default, null):DOMTokenList = new DOMTokenList();

    /**
     *  className gets and sets the value of the class attribute of the specified
     *  element.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/className
     */
    public var className:DOMString = "";

    /**
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/computedName
     */
    public var computedName(default, null):DOMString = "";

    /**
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/computedRole
     */
    public var computedRole(default, null):DOMString = "";

    /**
     *  The Element.id property represents the element's identifier, reflecting
     *  the id global attribute.
     *
     *  It must be unique in a document, and is often used to retrieve the element
     *  using getElementById. Other common usages of id include using the element's
     *  ID as a selector when styling the document with CSS.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/id
     */
    public var id:DOMString = "";

    /**
     *  The Element.innerHTML property sets or gets the HTML syntax describing
     *  the element's descendants.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML
     */
    public var innerHTML(default, set):DOMString = "";

    /**
     *  The Element.localName read-only property returns the local part of the
     *  qualified name of an element.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/localName
     */
    public var localName(default, null):DOMString = "";

    /**
     *  The Element.namespaceURI read-only property returns the namespace URI
     *  of the element, or null if the element is not in a namespace.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/namespaceURI
     */
    public var namespaceURI(default, null):DOMString = null;

    /**
     *  The NonDocumentTypeChildNode.nextElementSibling read-only property returns
     *  the element immediately following the specified one in its parent's children
     *  list, or null if the specified element is the last one in the list.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/NonDocumentTypeChildNode/nextElementSibling
     */
    public var nextElementSibling(default, null):Element;

    /**
     *  The Element.prefix read-only property returns the namespace prefix of
     *  the specified element, or null if no prefix is specified.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/prefix
     */
    public var prefix(default, null):DOMString;

    /**
     *  The NonDocumentTypeChildNode.previousElementSibling read-only property
     *  returns the Element immediately prior to the specified one in its parent's
     *  children list, or null if the specified element is the first one in the list.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/NonDocumentTypeChildNode/previousElementSibling
     */
    public var previousElementSibling(default, null):Element;

    /**
     *  Returns the name of the element.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/tagName
     */
    public var tagName(default, null):String = "";

    /**
     *  constructor
     */
    public function new() {
        super();
    }

    /**
     *  getAttribute() returns the value of a specified attribute on the element.
     *  If the given attribute does not exist, the value returned will either be
     *  null or "" (the empty string); see Notes for details.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/getAttribute
     */
    public function getAttribute(name:DOMString):Attr {
        throw Exceptions.NotImplemented;
        return null;
    }

    /**
     *  Element.getAttributeNames returns the attribute names of the element as
     *  an Array of strings. If the element has no attributes it returns an empty
     *  array.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/getAttributeNames
     *  @return Array<String>
     */
    public function getAttributeNames():Array<String> {
        throw Exceptions.NotImplemented;
        return null;
    }

    /**
     *  getAttributeNS returns the string value of the attribute with the specified
     *  namespace and name. If the named attribute does not exist, the value returned
     *  will either be null or "" (the empty string); see Notes for details.
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/Element/getAttributeNS
     *  @param namespace -
     *  @param name -
     *  @return DOMString
     */
    public function getAttributeNS(namespace:DOMString, name:DOMString):DOMString {
        throw Exceptions.NotImplemented;
        return null;
    }

    function set_innerHTML(html:DOMString) {
        throw Exceptions.NotImplemented;
        return null;
    }
}