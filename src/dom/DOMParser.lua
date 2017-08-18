local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define class
--
local class = lure.lib.upperclass:define('DOMParser')

--
-- Parse Debug
--
class.public : parsedebug {
    default=false;
    type='boolean';
}

--
-- Source Text
--
class.private : srcText {
    default="";
    type='string';
}

--
-- Open Nodes
--
class.private : openNodes {
    type='table';
}

--
-- Text Node Character Buffer
--
class.private : textNodeCharBuffer {
    default='';
    type='string';
}

--
-- DOM Document
--
class.private : document {    
    type='lure.dom.Document';
}   

--
-- Last Node Reference
--
class.private : lastNodeReference {
    type='any';
}

--
-- Class Constructor
--
function class.public:init(DOCUMENT)
    self.document = DOCUMENT or lure.dom.Document()
    
    self.lastNodeReference = self.document
    
    self.openNodes = {}
end

--
-- ParseFromString
--
function class.public:parseFromString(XML_STRING)
    lure.lib.upperclass:expect(XML_STRING):type('string'):ne(""):throw()
    
    local charindex = 1
    
    self.srcText = string.gsub(XML_STRING, "[\t]", "")
    
    --self.srcText = string.gsub(pSrcText, "[\r\n]", "")        
    
    -- Begin walking document text
    while charindex <= self.srcText:len() do        
        if self:char(charindex) == "<" then                
            if self.textNodeCharBuffer:len() > 0 then                    
                self:openNode(charindex, "text") 
                
            elseif self:char(charindex + 1) == "/" then                    
                charindex = self:closeNode(charindex) 
                
            elseif self.srcText:sub(charindex+1, charindex+3) == "!--" then                    
                charindex = self:openNode(charindex, "comment")
                
            elseif self.srcText:sub(charindex+1, charindex+8) == "![CDATA[" then                    
                charindex = self:openNode(charindex, "CDATASection")
                
            elseif self.srcText:sub(charindex+1, charindex+4) == "?xml" then
                charindex = self:openNode(charindex, "XMLDeclaration")
                
            elseif self.srcText:sub(charindex+1, charindex+8) == "!DOCTYPE" then
                charindex = self:openNode(charindex, "DOCTYPE")
                
            else                    
                charindex = self:openNode(charindex, "tag")
            end
        else
            self.textNodeCharBuffer = self.textNodeCharBuffer .. self:char(charindex)                
            charindex = charindex +1
        end            
    end                
    
    -- Fire HTML5 DOMContentLoaded Event
    self.document:dispatchEvent(
        lure.dom.Event('DOMContentLoaded', {
            target = self.document,
            bubbles = true
        })
    )
    
    return self.document
end

--
-- OpenNode
--
function class.private:openNode(NODE_INDEX, NODE_TYPE)
    lure.lib.upperclass:expect(NODE_INDEX):type('number'):throw()
    lure.lib.upperclass:expect(NODE_TYPE):type('string'):ne(""):throw()
    
    if NODE_TYPE == "tag" then
        -- Obtain the full content between opening < and closing >
        local tagContent = string.match(self.srcText, "<(.-)>", NODE_INDEX)
        
        -- Obtain the tag name from tagContent
        local tagName = lure.lib.utils:trim(string.match(tagContent, "([%a%d]+)%s?", 1))            
            
        -- Create a new Element from the tag and insert into node stack
        table.insert(self.openNodes, lure.dom.Element(tagName))                    
            
        -- get attributes from tagContent            
        for matchedAttr in string.gmatch(string.sub(tagContent,tagName:len()+1), "(.-=\".-\")") do            
            for attr, value in string.gmatch(matchedAttr, "(.-)=\"(.-)\"") do                
                self.openNodes[#self.openNodes]:setAttribute(lure.lib.utils:trim(attr), lure.lib.utils:trim(value))
            end                
        end
        
        -- Append new node to last node, and update lastNodeReference
        self.lastNodeReference = self.lastNodeReference:appendChild(self.openNodes[#self.openNodes])
            
        -- check to see if the tag is self closing, else check against self.selfCloseElements            
        if string.match(tagContent, "/$") then                
            self.openNodes[#self.openNodes].isSelfClosing = true
            self:closeNode(NODE_INDEX)            
        end
        
        -- Return our text position
        return NODE_INDEX + string.match(self.srcText, "(<.->)", NODE_INDEX):len()    
    elseif NODE_TYPE == "comment" then
        local commentText = string.match(self.srcText, "<!%-%-(.-)%-%->", NODE_INDEX)   
        return NODE_INDEX + string.match(self.srcText, "(<!%-%-.-%-%->)", NODE_INDEX):len()
    elseif NODE_TYPE == "text" then
        local text = lure.lib.utils:trim(self.textNodeCharBuffer)                
        self.lastNodeReference:appendChild(lure.dom.Text(text))                    
        self.textNodeCharBuffer = ""               
    elseif NODE_TYPE == "CDATASection" then
        local cdataText = string.match(self.srcText, "<!%[CDATA%[(.-)%]%]>", pIndex)            
        local newNode = libxml.dom.createCharacterData(cdataText)                                                
        self.lastNodeReference:appendChild(newNode)            
        return NODE_INDEX + string.match(self.srcText, "(<!%[CDATA%[.-%]%]>)", NODE_INDEX):len()
    elseif NODE_TYPE == "XMLDeclaration" then
        local declarationContent = string.match(self.srcText, "<?xml(.-)?>", NODE_INDEX)
        
        -- get attributes from tagContent            
        for matchedAttr in string.gmatch(declarationContent, "(.-=\".-\")") do            
            for attr, value in string.gmatch(matchedAttr, "(.-)=\"(.-)\"") do                            
                if lure.lib.utils:trim(attr:lower()) == "version" then
                    self.document.xmlVersion = value
                elseif lure.lib.utils:trim(attr:lower()) == "encoding" then
                    self.document.xmlEncoding = value
                elseif lure.lib.utils:trim(attr:lower()) == "standalone" then
                    self.document.xmlStandalone = value
                end
            end                
        end
        
        return string.match(self.srcText, "<?xml(.-)?>", NODE_INDEX):len()
    elseif NODE_TYPE == "DOCTYPE" then
        return string.match(self.srcText, "<!DOCTYPE(.-)>", NODE_INDEX):len()
    end    
end

--
-- CloseNode
--
function class.private:closeNode(NODE_INDEX)
    lure.lib.upperclass:expect(NODE_INDEX):type('number'):throw()
    
    local tagname = lure.lib.utils:trim(string.match(self.srcText, "/?([%a%d]+)%s?", NODE_INDEX))            
    if lure.lib.utils:trim(self.openNodes[#self.openNodes].tagName:upper()) == lure.lib.utils:trim(tagname):upper() then
        table.remove(self.openNodes, #self.openNodes)            
        self.lastNodeReference = self.lastNodeReference.parentNode
    end            
    return NODE_INDEX + string.match(self.srcText, "(<.->)", NODE_INDEX):len()
end

--
-- Char
--
function class.private:char(INDEX)
    lure.lib.upperclass:expect(INDEX):type('number'):throw()
    
    return self.srcText:sub(INDEX, INDEX)
end

--
-- Compile
--
return lure.lib.upperclass:compile(class)