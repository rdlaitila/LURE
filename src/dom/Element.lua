local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define class
--
local class = lure.lib.upperclass:define("Element", lure.dom.Node)

--
-- Is this element a self closing tag
--
class.public : isSelfClosing {
    false;
    get='public';
    set='public';
    type='boolean';
}

--
-- Returns the type information associated with the element
--
class.public : schemaTypeInfo {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Class constructor
--
function class.public:init(TAGNAME)
    lure.lib.upperclass:expect(TAGNAME):type('string'):ne(""):throw()
    
    lure.dom.Node.init(self, 1)
    
    self.nodeName = lure.lib.utils:trim(TAGNAME)    
end

--
-- __index metamethod
--
function class.private:__index(KEY)
    if KEY == 'tagName' then
        return self.nodeName
    end
end

--
-- Returns the value of an attribute
--
function class.public:getAttribute(ATTRIBUTE_NAME)
    lure.lib.upperclass:expect(ATTRIBUTE_NAME):type('string'):ne(''):throw()
    
    local attrnode = self:getAttributeNode(ATTRIBUTE_NAME)
    if attrnode ~= nil then
        return attrnode.value
    end
end

--
-- Returns the value of an attribute (with a namespace)
--
function class.public:getAttributeNS()
    error("Method Not Yet Implimented")
end

--
-- Returns an attribute node as an Attribute object
--
function class.public:getAttributeNode(ATTRIBUTE_NAME) 
    lure.lib.upperclass:expect(ATTRIBUTE_NAME):type('string'):ne(''):throw()
    
    for a=1, self.attributes.length do
        if self.attributes[a].name == lure.lib.utils:trim(ATTRIBUTE_NAME) then
            return self.attributes[a]
        end
    end
end

--
-- Returns an attribute node (with a namespace) as an Attribute object
--
function class.public:getAttributeNodeNS()
    error("Method Not Yet Implimented")
end

--
-- Adds a new attribute
--
function class.public:setAttribute(ATTRIBUTE_NAME, ATTRIBUTE_VALUE)
    lure.lib.upperclass:expect(ATTRIBUTE_NAME):type('string'):ne(''):throw()
    lure.lib.upperclass:expect(ATTRIBUTE_VALUE):ne(nil):throw()
    
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
return lure.lib.upperclass:compile(class)