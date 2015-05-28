-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define class
--
local NodeList = lure.lib.upperclass:define("NodeList")

--
-- Holds a list of nodes for this NodeList
--
protected.nodes = nil

--
-- Class constructor
--
function private:__construct()
    -- generate a new nodes table
    self.nodes = {}
end

--
-- __index metamethod
--
function private:__index(KEY) 
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
function private:__len()
    return #self.nodes
end

--
-- Returns the node at the specified index in a node list
--
function public:item(INDEX)
    return self.nodes[INDEX] or nil
end

--
-- Adds a node to the node list
--
function public:add(NODE)
    table.insert(self.nodes, NODE)    
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(NodeList)
