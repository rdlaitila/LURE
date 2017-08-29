local upperclass    = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils         = require(LIBXML_REQUIRE_PATH..'lib.utils')
local DOMNode       = require(LIBXML_REQUIRE_PATH..'dom.node')

--
-- Define class
--
local Attribute = upperclass:define("DOMAttribute", DOMNode)

--
-- Returns true if the attribute is known to be of type ID, otherwise it returns false
--
property : isId {
    false;
    get='public';
    set='private';
}

--
-- Returns the element node the attribute is attached to
--
property : ownerElement {
    nil;
    get='public';
    set='public';
    type='any';
}

--
-- Class Constructor
--
function private:__construct(ATTR_NAME, ATTR_VALUE)
    self:__constructparent(2)
    
    self.nodeName = ATTR_NAME
    self.nodeValue = ATTR_VALUE
    
    if ATTR_NAME == "id" then
        self.isId = true
    end
end

--
-- __index metamethod
--
function private:__index(KEY)
    if KEY == 'name' then
        return self.nodeName
    elseif KEY == 'value' then
        return self.nodeValue
    end
    
    return UPPERCLASS_DEFAULT_BEHAVIOR
end

--
-- __Newindex metamethod
--
function private:__newindex(KEY, VALUE)
    if KEY == 'name' then
        self.nodeName = VALUE
        return
    elseif KEY == 'value' then
        self.nodeValue = VALUE
        return
    end
    
    return UPPERCLASS_DEFAULT_BEHAVIOR
end

--
-- Compile class
--
 return upperclass:compile(Attribute)

