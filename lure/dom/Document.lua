-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define class
--
local Document = lure.lib.upperclass:define('DOMDocument', lure.dom.Node)

--
-- Specifies whether downloading of an XML file should be handled asynchronously or not
--
property : async {
    false;
    get='public';
    set='public';
}

--
-- Returns the Document Type Declaration associated with the document
--
property : doctype {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Returns the root node of the document
--
property : documentElement {
    nil;
    get='public';
    set='protected';
    type='any';
}

--
-- Sets or returns the location of the document
--
property : documentURI {
    nil;
    get='public';
    set='public';
    type='string';
}

--
-- Returns the configuration used when normalizeDocument() is invoked
--
property : domConfig {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Returns the DOMImplementation object that handles this document
--
property : implementation {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Returns the encoding used for the document (when parsing)
--
property : inputEncoding {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Sets or returns whether error-checking is enforced or not
--
property : strictErrorChecking {
    true;
    get='public';
    set='public';
}

--
-- Returns the XML encoding of the document
--
property : xmlEncoding {
    nil;
    get='public';
    set='public';
    type='string';
}

--
-- Sets or returns whether the document is standalone
--
property : xmlStandalone {
    nil;
    get='public';
    set='public';
    type='string'
}

--
-- Sets or returns the XML version of the document
--
property : xmlVersion {
    nil;
    get='public';
    set='public';
    type='string';
}

-- 
-- Class constructor
--
function private:__construct()    
    self:__constructparent(9)
    
    -- Set the node name
    self.nodeName = "#document"
    
    -- Set the ownerDocument to self
    self.ownerDocument = self
end

--
-- Adopts a node from another document to this document, and returns the adopted node
--
function public:adoptNode(SOURCENODE)
    error("Method Not Yet Implimented")
end

--
-- Creates an attribute node with the specified name, and returns the new Attr object
--
function public:createAttribute(NAME)
    return DOMAttribute(NAME)
end

--
-- Creates an attribute node with the specified name and namespace, and returns the new Attr object
--
function public:createAttributeNS(URI, NAME)
    error("Method Not Yet Implimented")
end

--
-- Creates a CDATA section node
--
function public:createCDATASection(DATA)
    return DOMCDATA(DATA)
end

--
-- Creates a comment node
--
function public:createComment(DATA)
    return DOMComment(DATA)
end

--
-- Creates an empty DocumentFragment object, and returns it
--
function public:createDocumentFragment()
    error("Method Not Yet Implimented")
end

--
-- Creates an element node
--
function public:createElement(TAGNAME)
    return DOMElement(TAGNAME)
end

--
-- Creates an element node with a specified namespace
--
function public:createElementNS()
    error("Method Not Yet Implimented")
end

--
-- Creates an EntityReference object, and returns it
--
function public:createEntityReference(NAME)
    error("Method Not Yet Implimented")
end

--
-- Creates a ProcessingInstruction object, and returns it
--
function public:createProcessingInstruction(TARGET, DATA)
    error("Method Not Yet Implimented")
end

--
-- Creates a text node
--
function public:createTextNode(TEXT)
    return DOMText(TEXT)
end

--
-- Imports a node from another document to this document. This method creates a new copy of the source node. If the deep parameter is set to true, it imports all children of the specified node. If set to false, it imports only the node itself. This method returns the imported node
--
function public:importNode(NODE, DEEP)
    error("Method Not Yet Implimented")
end

--
-- normalizeDocument()
--
function public:normalizeDocument()
    error("Method Not Yet Implimented")
end

--
-- Renames an element or attribute node
--
function public:renameNode()
    error("Method Not Yet Implimented")
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(Document)