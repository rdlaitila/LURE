local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define class
--
local class = lure.lib.upperclass:define("lure.dom.NamedNodeMap", lure.dom.NodeList)

--
-- Constructor
--
function class.public:init()
    lure.dom.NodeList.init(self)
end

--
-- Returns the node with the specific name
--
function class.public:getNamedItem(NAME)
    for a=1, self.length do
        if self.nodes[a].nodeName == NAME then
            return self.nodes[a]
        end
    end
end

--
-- Returns the node with the specific name and namespace
--
function class.public:getNamedItemNS(NS, NAME)
    error("Method Not Yet Implimented")
end

--
-- Removes the node with the specific name
--
function class.public:removeNamedItem(NAME)
    local node = nil
    local nodeindex = nil
    for a=1, self.length do
        if self.nodes[a].nodeName == NAME then
            node = self.nodes[a]
            nodeindex = a
        end
    end
    table.remove(self.nodes, nodeindex)
end

--
-- Removes the node with the specific name and namespace
--
function class.public:removeNamedItemNS(NS, NAME)
    error("Method Not Yet Implimented")
end

--
-- Sets the specified node (by name)
--
function class.public:setNamedItem(ATTR_NODE)
    for a=1, self.length do
        if self.nodes[a].nodeName == ATTR_NODE.nodeName then
            local returnnode = self.nodes[a]
            self.nodes[a] = ATTR_NODE
            return returnnode
        end
    end
    
    table.insert(self.nodes, ATTR_NODE)
end

--
-- Sets the specified node (by name and namespace)
--
function class.public:setNamedItemNS(NS, NAME, NODE)
    error("Method Not Yet Implimented")
end

--
-- Compile class
--
return lure.lib.upperclass:compile(class)



