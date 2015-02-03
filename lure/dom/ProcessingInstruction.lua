local upperclass    = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils         = require(LIBXML_REQUIRE_PATH..'lib.utils')
local DOMNode       = require(LIBXML_REQUIRE_PATH..'dom.node')

--
-- Define class
--
local ProcessingInstruction = upperclass:define("DOMProcessingInstruction", DOMNode)

--
-- Sets or returns the content of this processing instruction
--
property : data {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Returns the target of this processing instruction
--
property : target {
    nil;
    get='public';
    set='public';
    type='any';
}

--
-- Class constructor
--
function private:__construct()
    self:__constructparent(7)
end

--
-- __index metamethod
--
function private:__index(KEY)
    if KEY == 'nodeName' then
        return self.target
    elseif KEY == 'nodeValue' then
        return self.data
    end
    
    return UPPERCLASS_DEFAULT_BEHAVIOR
end

--
-- Compile class
--
return upperclass:compile(ProcessingInstruction)