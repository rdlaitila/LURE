local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define
--
local class = lure.lib.upperclass:define('lure.rom.RenderList')

--
-- length
--
class.public : length {
    default=0;
    setter='private';
    type='number';
}

--
-- items
--
class.private : items {
    default={};
    type='table';
}

--
-- Constructor
--
function class.public:init()
    self.items = {}
end

--
-- push
--
function class.public:push(node)
    lure.lib.upperclass:expect(node):ne(nil):throw()
    
    table.insert(self.items, node)
    
    self.length = self.length + 1
end

--
-- pop
--
function class.public:pop(index)
    if self.length == 0 then
        error("No items to pop")
    end
    
    if index ~= nil and type(index) == 'number' then
        table.remove(self.items, index)    
    else
        table.remove(self.items, #self.items)
    end
    
    self.length = self.length - 1
end

--
-- Compile
--
return lure.lib.upperclass:compile(class)