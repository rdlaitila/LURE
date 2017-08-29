local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define class
--
local class = lure.lib.upperclass:define('lure.dom.Document', lure.dom.Node)

--
-- Specifies whether downloading of an XML file should be handled asynchronously or not
--
class.public : async {
    default=false;
    type='boolean';
}

--
-- Indicates if the document is closed for writing
--
class.private : closed {
    default=true;
    type='boolean';
}

--
-- Returns the Document Type Declaration associated with the document
--
class.public : doctype {
    setter='private';
    type='any';
}

--
-- Returns the root node of the document
--
class.public : documentElement {
    setter='protected';
    type='any';
}

--
-- Sets or returns the location of the document
--
class.public : documentURI {
    type='string';
}

--
-- Returns the configuration used when normalizeDocument() is invoked
--
class.public : domConfig {
    setter='private';
    type='any';
}

--
-- Document's private domParser
--
class.private : domParser {
    type='DOMParser';
}

--
-- Returns the DOMImplementation object that handles this document
--
class.public : implementation {
    setter='private';
    type='any';
}

--
-- Returns the encoding used for the document (when parsing)
--
class.public : inputEncoding {
    setter='private';
    type='any';
}

--
-- Sets or returns whether error-checking is enforced or not
--
class.public : strictErrorChecking {
    default=true;
    type='boolean';
}

--
-- Returns the XML encoding of the document
--
class.public : xmlEncoding {
    type='string';
}

--
-- Sets or returns whether the document is standalone
--
class.public : xmlStandalone {
    type='string'
}

--
-- Sets or returns the XML version of the document
--
class.public : xmlVersion {
    type='string';
}

-- 
-- Class constructor
--
function class.public:init()    
    lure.dom.Node.init(self, 9)
    
    -- Set the node name
    self.nodeName = "#document"
    
    -- Set the ownerDocument to self
    self.ownerDocument = self
end

--
-- appends a new child node to the end of the list of children of a node
-- shadows Node:appendChild
--
function class.public:appendChild(NODE)
    -- Call append child of base Node
    lure.dom.Node.appendChild(self, NODE)
    
    -- Set documentElement
    if NODE.nodeType == 1 and self.documentElement == nil then
        self.documentElement = NODE
    end
    
    return NODE
end

--
-- Adopts a node from another document to this document, and returns the adopted node
--
function class.public:adoptNode(SOURCENODE)
    error("Method Not Yet Implimented")
end

--
-- finishes writing to a document, opened with document.open().
--
function class.public:close()
    if self.closed then
        error("Cannot close an already closed document")
    else
        self.closed = true
    end
end

--
-- Creates an attribute node with the specified name, and returns the new Attr object
--
function class.public:createAttribute(NAME)
    return DOMAttribute(NAME)
end

--
-- Creates an attribute node with the specified name and namespace, and returns the new Attr object
--
function class.public:createAttributeNS(URI, NAME)
    error("Method Not Yet Implimented")
end

--
-- Creates a CDATA section node
--
function class.public:createCDATASection(DATA)
    return DOMCDATA(DATA)
end

--
-- Creates a comment node
--
function class.public:createComment(DATA)
    return DOMComment(DATA)
end

--
-- Creates an empty DocumentFragment object, and returns it
--
function class.public:createDocumentFragment()
    error("Method Not Yet Implimented")
end

--
-- Creates an element node
--
function class.public:createElement(TAGNAME)
    lure.lib.upperclass:expect(TAGNAME):type('string'):ne(''):throw()
    
    return lure.dom.Element(TAGNAME)
end

--
-- Creates an element node with a specified namespace
--
function class.public:createElementNS()
    error("Method Not Yet Implimented")
end

--
-- Creates an EntityReference object, and returns it
--
function class.public:createEntityReference(NAME)
    error("Method Not Yet Implimented")
end

--
-- Creates a ProcessingInstruction object, and returns it
--
function class.public:createProcessingInstruction(TARGET, DATA)
    error("Method Not Yet Implimented")
end

--
-- Creates a text node
--
function class.public:createTextNode(TEXT)
    return DOMText(TEXT)
end

--
-- Imports a node from another document to this document. This method creates a new copy of the source node. If the deep parameter is set to true, it imports all children of the specified node. If set to false, it imports only the node itself. This method returns the imported node
--
function class.public:importNode(NODE, DEEP)
    error("Method Not Yet Implimented")
end

--
-- normalizeDocument()
--
function class.public:normalizeDocument()
    error("Method Not Yet Implimented")
end

--
-- opens a document for writing.
--
function class.public:open()
    if self.closed == false then
        error("Cannot open an already opened document")
    end
    
    self.closed = false
    
    self.childNodes = lure.dom.NodeList()
    self.domParser = lure.dom.DOMParser(self)
end

--
-- Renames an element or attribute node
--
function class.public:renameNode()
    error("Method Not Yet Implimented")
end

--
-- Writes a string of text to a document stream opened by document.open()
--
function class.public:write(markup)
    lure.lib.upperclass:expect(markup):type('string'):ne(''):throw()
    
    if self.closed then
        self:open()
    end
    
    self.domParser:parseFromString(markup)
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(class)