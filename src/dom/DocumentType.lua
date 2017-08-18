local upperclass        = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils             = require(LIBXML_REQUIRE_PATH..'lib.utils')
local DOMNode           = require(LIBXML_REQUIRE_PATH..'dom.node')
local DOMNamedNodeMap   = require(LIBXML_REQUIRE_PATH..'dom.namednodemap')

--
-- Define class
--
local DocumentType = upperclass:define("DOMDocumentType", DOMNode)

--
-- Returns a NamedNodeMap containing the entities declared in the DTD
--
property : entities {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Returns the internal DTD as a string
--
property : internalSubset {
    nil;
    get='public';
    set='private';
    type='string';
}

--
-- Returns the name of the DTD
--
property : name {
    nil;
    get='public';
    set='private';
    type='string';
}

--
-- Returns a NamedNodeMap containing the notations declared in the DTD
--
property : notations {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Class constructor
--
function private:__construct()
    self:__constructparent(10)
    self.entities = DOMNamedNodeMap()
    self.notations = DOMNamedNodeMap()
end

--
-- __index metamethod
--
function private:__index(KEY)
    if KEY == 'nodeName' then
        return self.name
    end
    
    return UPPERCLASS_DEFAULT_BEHAVIOR
end

--
-- Compile class
--
return upperclass:compile(DocumentType)