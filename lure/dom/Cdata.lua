-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define class
--
local Characterdata = lure.lib.upperclass:define("DOMCDATA", lure.dom.Node)

--
-- Sets or returns the text of this node
--
property : data {
    nil;
    get='public';
    set='public';
    type='string';
}

-- 
-- Class constructor
--
function private:__construct(DATA)
    self:__constructparent(4)
    self.nodeName = "#cdata-section"
    self.data = DATA        
end

--
-- __index metamethod
--
function private:__index(KEY)
    if KEY == 'length' then
        return self.data:len()
    elseif KEY == 'nodeValue' then
        return self.data
    end
    
    return lure.lib.upperclass.DEFAULT_BEHAVIOR
end

--
-- Appends data to the node
--
function public:appendData(DATA)
    error("Method Not Yet Implimented")
end

--
-- Deletes data from the node
--
function public:deleteData(DATA)
    error("Method Not Yet Implimented")
end

--
-- Inserts data into the node
--
function public:insertData(DATA)
    error("Method Not Yet Implimented")
end

--
-- Replaces data in the node
--
function public:replaceData()
    error("Method Not Yet Implimented")
end

--
-- Splits the CDATA node into two nodes
--
function public:splitText()
    error("Method Not Yet Implimented")
end

--
-- Extracts data from the node
--
function public:substringData()
    error("Method Not Yet Implimented")
end

--
-- Compile class
--
return lure.lib.upperclass:compile(Characterdata)