local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define class
--
local Node = lure.lib.upperclass:define('DOMNode')

--
-- A NamedNodeMap containing the attributes of this node
--
property : attributes { 
    nil; 
    get='public'; 
    set='protected';
    type='table'
}

--
-- Returns the absolute base URI of a node
--
property : baseURI {
    "";
    get='public';
    set='protected'
}

--
-- Returns a NodeList of child nodes for a node
--
property : childNodes { 
    nil; 
    get='public'; 
    set='protected';
    type='table'
}

--
-- Returns a list of registered eventListeners
--
property : eventListeners {
    nil;
    get='public';
    set='protected';
    type='table';
}

--
-- Returns the first child of a node
--
property : firstChild { 
    nil; 
    get='public'; 
    set='protected';
    type='table';
}

--
-- Returns the last child of a node
--
property : lastChild { 
    nil; 
    get='public'; 
    set='protected';
    type='any'
}

--
-- Returns the local part of the name of a node
--
property : localName {
    "";
    get='public';
    set='protected'
}

--
-- Returns the namespace URI of a node
--
property : namespaceURI {
    "";
    get='public';
    set='protected';
}

--
-- Returns the node immediately following a node
--
property : nextSibling {
    nil;
    get='public';
    set='protected';
    type='any'
}

--
-- Returns the name of a node, depending on its type
--
property : nodeName { 
    nil; 
    get='public'; 
    set='protected';
    type='string';
}

--
-- Returns the type of a node
--
property : nodeType { 
    0; 
    get='public'; 
    set='protected';
}

--
-- Sets or returns the value of a node, depending on its type
--
property : nodeValue {
    nil;
    get='public';
    set='public';
    type='any'
}

--
-- Returns the root element (document object) for a node
--
property : ownerDocument {
    nil;
    get='public';
    set='protected';
    type='any'
}

--
-- Returns the parent node of a node
--
property : parentNode { 
    nil; 
    get='public'; 
    set='public';
    type='any'
}

--
-- Sets or returns the namespace prefix of a node
--
property : prefix {
    nil;
    get='public';
    set='public';
    type='any'
}

--
-- Returns the node immediately before a node
--
property : previousSibling {
    nil;
    get='public';
    set='protected';
    type='any';
}

--
-- Sets or returns the textual content of a node and its descendants
--
property : textContent {
    nil;
    get='public';
    set='public';
    type='any';
}

--
-- Class Construct
--
function private:__construct(NODETYPE) 
    if type(NODETYPE) == "number" then        
        self.nodeType = NODETYPE
    else
        error("NodeType must be a number")
    end
    
    -- Initialize attributes nodemap
    self.attributes = lure.dom.NamedNodeMap()
    
    -- Initialize childNodes NodeList
    self.childNodes = lure.dom.NodeList()
    
    -- Initialize eventListeners table
    self.eventListeners = {}
end

--
-- Appends a new child node to the end of the list of children of a node
--
function public:appendChild(NODE) 
    -- Set the incoming node's parentNode to self
    NODE.parentNode = self
    
    -- Set the incoming node's ownerDocument
    NODE.ownerDocument = self.ownerDocument
    
    -- Push the childNode
    self.childNodes:add(NODE)
    
    -- Set self's firstChild
    self.firstChild = self.childNodes[1]
    
    -- Set self's lastChild
    self.lastChild = self.childNodes[self.childNodes.length]
    
    -- If this node is a document node (type 9) and the appending node is 
    -- a element node (type 1) then set documentElement to self
    if self.nodeType == 9 and NODE.nodeType == 1 then
        self.documentElement = NODE
    end
    
    -- Fire a DOM level 3 DOMNodeInsertedIntoDocument event        
    self:dispatchEvent(
        lure.dom.Event('DOMNodeInsertedIntoDocument', {            
            target = NODE,
            bubbles = true
        })    
    )
    
    return NODE
end

--
-- Clones a node
--
function public:cloneNode()
    error("Method Not Yet Implimented")
end

--
-- Compares the placement of two nodes in the DOM hierarchy (document)
--
function public:compareDocumentPosition()
    error("Method Not Yet Implimented")
end

--
-- Returns a DOM object which implements the specialized APIs of the specified feature and version
--
function public:getFeature()
    error("Method Not Yet Implimented")
end

--
-- Returns the object associated to a key on a this node. The object must first have been set to this node by calling setUserData with the same key
--
function public:getUserData()
    error("Method Not Yet Implimented")
end

--
-- Returns true if the specified node has any attributes, otherwise false
--
function public:hasAttributes()
    if self.attributes.length > 0 then
        return true
    else
        return false
    end    
end

--
-- Returns true if the specified node has any child nodes, otherwise false
--
function public:hasChildNodes()
    if self.childNodes.length > 0 then
        return true
    else
        return false
    end
end

--
-- Inserts a new child node before an existing child node
--
function public:insertBefore()
    error("Method Not Yet Implimented")
end

--
-- Returns whether the specified namespaceURI is the default
--
function public:isDefaultNamespace()
    error("Method Not Yet Implimented")
end

--
-- Tests whether two nodes are equal
--
function public:isEqualNode()
    error("Method Not Yet Implimented")
end

--
-- Tests whether the two nodes are the same node
--
function public:isSameNode()
    error("Method Not Yet Implimented")
end

--
-- Tests whether the DOM implementation supports a specific feature and that the feature is supported by the specified node
--
function public:isSupported()
    error("Method Not Yet Implimented")
end

--
-- Returns the namespace URI associated with a given prefix
--
function public:lookupNamespaceURI()
    error("Method Not Yet Implimented")
end

--
-- Returns the prefix associated with a given namespace URI
--
function public:lookupPrefix()
    error("Method Not Yet Implimented")
end

--
-- Puts all Text nodes underneath a node (including attribute nodes) into a "normal" form where only structure 
-- (e.g., elements, comments, processing instructions, CDATA sections, and entity references) separates Text nodes, 
-- i.e., there are neither adjacent Text nodes nor empty Text nodes
--
function public:normalize()
    error("Method Not Yet Implimented")
end

--
-- Removes a specified child node from the current node 
--
function public:removeChild()
    error("Method Not Yet Implimented")
end

--
-- Replaces a child node with a new node
--
function public:replaceChild()
    error("Method Not Yet Implimented")
end

--
-- Associates an object to a key on a node
--
function public:setUserData()
    error("Method Not Yet Implimented")
end

--
-- Returns the element that has an ID attribute with the given value. If no such element exists, it returns null
--
function public:getElementById(ID)
    error("Method Not Yet Implimented")
end

--
-- Returns a NodeList of all elements with a specified name
--
function public:getElementsByTagName(TAGNAME)
    local nodelist = lure.dom.NodeList()
    local targetElement = self
    
    if targetElement.nodeType == 1 and targetElement.tagName == TAGNAME then
        nodelist:add(targetElement)
    end
    
    if targetElement:hasChildNodes() then        
        for a=1, targetElement.childNodes.length do
            local childNodes = targetElement.childNodes[a]:getElementsByTagName(TAGNAME)
            for b=1, childNodes.length do
                nodelist:add(childNodes[b])
            end
        end
    end

    return nodelist
end

--
-- Returns a NodeList of all elements with a specified name and namespace
--
function public:getElementsByTagNameNS()
    error("Method Not Yet Implimented")
end

--
-- Register an event handler of a specific event type on the EventTarget.
-- @param EVENT_TYPE string
-- @param CALLBACK 
--
function public:addEventListener(EVENT_TYPE, CALLBACK, USE_CAPTURE)
    -- Generate our EventListener object
    local listener = lure.dom.EventListener(EVENT_TYPE, CALLBACK, USE_CAPTURE)
    
    -- Insert into our list of eventListeners
    table.insert(self.eventListeners, listener)
      
    return listener
end

--
-- Removes an event listener from the EventTarget.
-- @param LISTENER lure.dom.EventListener
--
function public:removeEventListener(LISTENER)
    local targetlistener = nil
    
    for a=1, #self.eventListeners do
        if self.eventListeners[a] == LISTENER then
            targetlistener = self.eventListeners[a]
            break
        end
    end
    
    if targetlistener ~= nil then
        table.remove(self.eventListeners, targetlistener)
    end
    
    return targetlistener
end

--
-- Dispatch an event to this EventTarget.
-- @param EVENT lure.dom.Event
--
function public:dispatchEvent(EVENT)
    -- Build the upward callstack to top level node, generally the Document Object
    local callstack = lure.dom.NodeList()
    local currentNode = self
    callstack:add(currentNode)    
    while true do
        -- Check to ensure we do not have a recursive parentNode reference
        if currentNode.parentNode == currentNode then
            error("Node Parent References same node in DispatchEvent. Invalid DOM structure.")
        end
        
        -- Lazy sanity check to ensure we don't lock the program if we have a recursive parentNode reference
        if callstack.length > 10000 then
            error("Callstack To Large In DispatchEvent")
        end
        
        -- Check if we have a parent node
        if currentNode.parentNode ~= nil then
            currentNode = currentNode.parentNode
            callstack:add(currentNode)
        elseif currentNode.parentNode == nil then
            EVENT.currentTarget = currentNode            
            break
        end
    end
    
    -- Begin capturing phase
    EVENT.eventPhase = lure.dom.Event.CAPTURING_PHASE
    for a=callstack.length, 1, -1 do        
        if EVENT.isCanceled == true then            
            return
        end
        
        -- Set the current Target
        EVENT.currentTarget = callstack[a]
        
        -- Begin looping through event listeners        
        for b=1, #callstack[a].eventListeners do            
            if callstack[a] ~= EVENT.target then
                EVENT.eventPhase = lure.dom.Event.CAPTURING_PHASE
                if callstack[a].eventListeners[b].useCapture == true then
                    if callstack[a].eventListeners[b].name == EVENT.type then
                        callstack[a].eventListeners[b]:handleEvent(EVENT)
                    end                    
                end
            elseif callstack[a] == EVENT.target then
                EVENT.eventPhase = lure.dom.Event.AT_TARGET
                if callstack[a].eventListeners[b].useCapture == false then
                    if callstack[a].eventListeners[b].name == EVENT.type then
                        callstack[a].eventListeners[b]:handleEvent(EVENT)
                    end                    
                end
            end
        end
    end
    
    -- Begin bubble phase
    if EVENT.bubbles == false then
        return
    end
    EVENT.eventPhase = lure.dom.Event.BUBBLING_PHASE
    for a=1, callstack.length do        
        if EVENT.isCanceled == true then            
            return
        end
        
        if callstack[a] ~= EVENT.target then
            EVENT.eventPhase = lure.dom.Event.BUBBLING_PHASE
            for b=1, #callstack[a].eventListeners do
                if callstack[a].eventListeners[b].name == EVENT.type then
                    callstack[a].eventListeners[b]:handleEvent(EVENT)
                end
            end
        end
    end    
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(Node)