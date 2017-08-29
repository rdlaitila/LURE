local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define class
--
local class = lure.lib.upperclass:define("NodeList")

--
-- Holds a list of nodes for this NodeList
--
class.protected : nodes {
    type='table';
}
--
-- Class constructor
--
function class.public:init()
    -- generate a new nodes table
    self.nodes = {}
end

--
-- __index metamethod
--
function class.private:__index(KEY) 
    if type(KEY) == 'number' then
        return self:item(KEY)
    elseif KEY == 'length' then
        return #self.nodes
    end
    
    return lure.lib.upperclass.DEFAULT_BEHAVIOR
end

--
-- __len metamethod
--
function class.private:__len()
    return #self.nodes
end

--
-- Returns the node at the specified index in a node list
--
function class.public:item(INDEX)
    return self.nodes[INDEX] or nil
end

--
-- Adds a node to the node list
--
function class.public:add(NODE)
    table.insert(self.nodes, NODE)    
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(class)
