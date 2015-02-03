local upperclass    = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils         = require(LIBXML_REQUIRE_PATH..'lib.utils')
local DOMCDATA      = require(LIBXML_REQUIRE_PATH..'dom.cdata')

--
-- Define class
-- 
local Comment = upperclass:define("DOMComment", DOMCDATA)

--
-- Class constructor
--
function private:__construct(DATA)
    self:__constructparent(DATA)
    self.nodeType = 8
    self.nodeName = "#comment"
end

--
-- Compile class
--
return upperclass:compile(Comment)