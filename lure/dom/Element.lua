-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define class
--
local Element = lure.lib.upperclass:define("DOMElement", lure.dom.Node)

--
-- Is this element a self closing tag
--
property : isSelfClosing {
    false;
    get='public';
    set='public';
    type='boolean';
}

--
-- Returns the type information associated with the element
--
property : schemaTypeInfo {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Class constructor
--
function private:__construct(TAGNAME)
    self:__constructparent(1)
    self.nodeName = lure.lib.utils:trim(TAGNAME)    
end

--
-- __index metamethod
--
function private:__index(KEY)
    if KEY == 'tagName' then
        return self.nodeName
    end
    
    return UPPERCLASS_DEFAULT_BEHAVIOR
end

--
-- Returns the value of an attribute
--
function public:getAttribute(ATTRIBUTE_NAME)
    local attrnode = self:getAttributeNode(ATTRIBUTE_NAME)
    if attrnode ~= nil then
        return attrnode.value
    end
end

--
-- Returns the value of an attribute (with a namespace)
--
function public:getAttributeNS()
    error("Method Not Yet Implimented")
end

--
-- Returns an attribute node as an Attribute object
--
function public:getAttributeNode(ATTRIBUTE_NAME) 
    for a=1, self.attributes.length do
        if self.attributes[a].name == lure.lib.utils:trim(ATTRIBUTE_NAME) then
            return self.attributes[a]
        end
    end
end

--
-- Returns an attribute node (with a namespace) as an Attribute object
--
function public:getAttributeNodeNS()
    error("Method Not Yet Implimented")
end

--
-- Adds a new attribute
--
function public:setAttribute(ATTRIBUTE_NAME, ATTRIBUTE_VALUE)
    for a=1, self.attributes.length do
        if self.attributes[a].name == lure.lib.utils:trim(ATTRIBUTE_NAME) then
            self.attributes[a].value = ATTRIBUTE_VALUE 
            return
        end
    end
    
    local newattribute = lure.dom.Attribute(lure.lib.utils:trim(ATTRIBUTE_NAME), ATTRIBUTE_VALUE)
    return self.attributes:setNamedItem(newattribute)
end

--
-- Compile class
--
return lure.lib.upperclass:compile(Element)