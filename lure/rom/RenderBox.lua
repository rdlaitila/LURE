local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define
--
local class = lure.lib.upperclass:define('lure.rom.RenderBox', lure.rom.RenderObject)

--
-- display
--
class.public : cssDisplay {
    default='block';
    setter='protected';
    type='string';
}



--
-- Compile
--
return lure.lib.upperclass:compile(class)