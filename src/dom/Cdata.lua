local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define class
--
local class = lure.lib.upperclass:define("CDATA", lure.dom.Node)

--
-- Sets or returns the text of this node
--
class.public : data {
    default="";
    type='string';
}

-- 
-- Class constructor
--
function class.public:init(DATA)
    lure.lib.upperclass:expect(DATA):type('string'):throw()
    
    lure.dom.Node.init(self, 4)
    
    self.nodeName = "#cdata-section"
    
    self.data = DATA        
end

--
-- __index metamethod
--
function class.private:__index(KEY)
    if KEY == 'length' then
        return self.data:len()
    elseif KEY == 'nodeValue' then
        return self.data
    end
end

--
-- Appends data to the node
--
function class.public:appendData(DATA)
    error("Method Not Yet Implimented")
end

--
-- Deletes data from the node
--
function class.public:deleteData(DATA)
    error("Method Not Yet Implimented")
end

--
-- Inserts data into the node
--
function class.public:insertData(DATA)
    error("Method Not Yet Implimented")
end

--
-- Replaces data in the node
--
function class.public:replaceData()
    error("Method Not Yet Implimented")
end

--
-- Splits the CDATA node into two nodes
--
function class.public:splitText()
    error("Method Not Yet Implimented")
end

--
-- Extracts data from the node
--
function class.public:substringData()
    error("Method Not Yet Implimented")
end

--
-- Compile class
--
return lure.lib.upperclass:compile(class)