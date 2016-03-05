local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define class
--
local class = lure.lib.upperclass:define("Text", lure.dom.CDATA)

--
-- Returns true if the text node contains content whitespace, otherwise it returns false
--
class.public : isElementContentWhitespace {
    default=false;    
    setter='private';
    type='boolean';
}

--
-- Returns all text of text nodes adjacent to this node, concatenated in document order
--
class.public : wholeText {    
    setter='private';
    type='string';
}

--
-- Class constructor
--
function class.public:init(TEXT)
    lure.lib.upperclass:expect(TEXT):type('string'):throw()
    
    lure.dom.CDATA.init(self, TEXT)        
    
    self.nodeType = 3
    self.nodeName = "#text"
end

--
-- Replaces the text of this node and all adjacent text nodes with the specified text
--
function class.public:replaceWholeText(TEXT)
    error("Method Not Yet Implimented")
end

--
-- Compile class
--
return lure.lib.upperclass:compile(class)
