local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define
--
local class = lure.lib.upperclass:define('lure.rom.RenderObject')

--
-- parent
--
class.public : parent {
    nullable=true;
}

--
-- children
--
class.public : children {
    setter='protected';
    type='lure.rom.RenderList';
}

--
-- Constructor
--
function class.public:init()
    self.children = lure.rom.RenderList()
end

--
-- Compile
--
return lure.lib.upperclass:compile(class)