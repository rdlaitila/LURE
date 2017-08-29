local DOMParser = {}
lure.dom.DOMParser = DOMParser


--[[
-- @function: CONSTRUCTOR
--]]
function DOMParser:new()
    -- Whether to dump debug output information
	self.parsedebug = false	
    
    -- Source text passed to DOMParser
	self.srcText = nil	
    
    -- Table to track open nodes in the stack
	self.openNodes = {}	
	
    -- Maintain the last node reference in the stack
	self.lastNodeReference = nil	
    
    -- List of available self closing tags
	self.selfCloseElements = {"base", "basefont", "frame", "link", "meta", "area", "br", "col", "hr", "img", "input", "param"}	
    
    -- Text node buffer when parsing cdata or text nodes
	self.textNodeCharBuffer = nil	
    
    -- Target XML/HTML document
	self.document = lure.dom.createDocumentNodeObj()
    
    print(self.parseFromString)
    
    return self
end

--[[
-- @function: parseFromString
-- @description: 
-- @arg[string]: SOURCE_XML: source xml/html text 
--]]
function DOMParser:parseFromString(SOURCE_XML)
    local index = 1
	local char = function(charIndex) return  self.srcText:sub(charIndex,charIndex) end	
    
	self.srcText = string.gsub(SOURCE_XML, "[\t]", "")
	--self.srcText = string.gsub(pSrcText, "[\r\n]", "")		
    
	while index <= self.srcText:len() do			
		if char(index) == "<" then				
			if self.textNodeCharBuffer ~= nil then					
				self:openNode(index, "text") 								
			elseif char(index + 1) == "/" then					
				index = self.closeNode(index)				
			elseif self.srcText:sub(index+1, index+3) == "!--" then					
				index = self:openNode(index, "comment")
			elseif self.srcText:sub(index+1, index+7) == "!CDATA[" then					
				index = self:openNode(index, "CDATASection")					
			else					
				index = self:openNode(index, "tag")
			end
		else				
			if self.textNodeCharBuffer == nil then self.textNodeCharBuffer = "" end
			self.textNodeCharBuffer = self.textNodeCharBuffer .. char(index)				
			index = index +1
		end			
	end				
		
	return self.document
end

--[[
-- @function: openNode
-- @description: 
-- @arg[int]: INDEX: return index of new open node in stack
-- @arg[string]: TYPE: type of node to open
--]]
function DOMParser:openNode(INDEX, TYPE)
    local nI = nil --nodeIndex
	local rI = INDEX --returnIndex		
	
	if TYPE == "tag" then			
		local tagContent = string.match(self.srcText, "<(.-)>", INDEX)
		local tagName = lure.trim(string.match(tagContent, "([%a%d]+)%s?", 1))			
		
		table.insert(self.openNodes, lure.dom.createElementNodeObj(tagName))			
		nI = table.getn(self.openNodes)						
		
		-- get attributes from tagContent			
		for matchedAttr in string.gmatch(string.sub(tagContent,tagName:len()+1), "(.-=\".-\")") do			
			for attr, value in string.gmatch(matchedAttr, "(.-)=\"(.-)\"") do
				self.openNodes[nI].setAttribute(lure.trim(attr), lure.trim(value))					
			end				
		end
		
		-- compute element style specificity
		if self.openNodes[nI].hasAttribute('style') then
			if self.openNodes[nI].style ~= nil then
				self.openNodes[nI].style.specificity = lure.dom.css.computeElementStyleSpecificity( self.openNodes[nI] )
			end
		end
		
		-- append new node to document
		if nI == 1 then				
			self.lastNodeReference = self.document.appendChild(self.openNodes[nI])					
		else				
			self.lastNodeReference = self.lastNodeReference.appendChild(self.openNodes[nI])				
		end			
		
		-- for HTML, set shorthand element references
		if self.lastNodeReference.tagName:upper() == "HTML" then
			self.document.html = self.lastNodeReference
		elseif self.lastNodeReference.tagName:upper() == "HEAD" then
			self.document.head = self.lastNodeReference
		elseif self.lastNodeReference.tagName:upper() == "BODY" then
			self.document.body = self.lastNodeReference
		elseif self.lastNodeReference.tagName:upper() == "TITLE" then
			self.document.title = self.lastNodeReference
		end
		
		-- check to see if the tag is self closing, else check against self.selfCloseElements			
		if string.match(tagContent, "/$") then				
			self.closeNode(INDEX)
			nI = table.getn(self.openNodes)
		else
			for k,v in ipairs(self.selfCloseElements) do
				if v:upper() == self.openNodes[nI].tagName:upper() then						
					self.closeNode(INDEX)
					nI = table.getn(self.openNodes)						
				end
			end
		end
		
		rI = rI + string.match(self.srcText, "(<.->)", INDEX):len()
		
		-- watch out for special tags such as script/style etc. They require special processing
		if self.lastNodeReference.tagName == "script" then				
			rI = self.parseScriptTags(rI)
			return rI
		elseif self.lastNodeReference.tagName == "style" then				
			rI = self.parseStyleTags(rI)
			return rI
		else
			return rI
		end				
	elseif TYPE == "comment" then
		local commentText = string.match(self.srcText, "<!%-%-(.-)%-%->", INDEX)						
		local newTextNode = self.lastNodeReference.appendChild(lure.dom.createCommentNodeObj(lure.trim(commentText)))			
		rI = INDEX + string.match(self.srcText, "(<!%-%-.-%-%->)", INDEX):len()
		return rI	
	elseif TYPE == "text" then
		local text = lure.trim(self.textNodeCharBuffer)
		if text ~= "" then
			self.lastNodeReference.appendChild(lure.dom.createTextNodeObj(text))			
		end		
		self.textNodeCharBuffer = nil				
	elseif TYPE == "CDATASection" then
		local cdataText = string.match(self.srcText, "<!CDATA%[(.-)%]%]>", INDEX)
		local newNode = lure.dom.createCharacterDataNodeObj(cdataText)												
		self.lastNodeReference.appendChild(newNode)			
		return INDEX + string.match(self.srcText, "(<!CDATA%[.-%]%]>)", INDEX):len()
	end	
end

--[[
-- @function: closeNode
-- @description: closes an open node on the parse stack
-- @arg[int]: INDEX: return index of new open node in stack
--]]
function DOMParser:closeNode(INDEX)
    local tagname = lure.trim(string.match(self.srcText, "/?([%a%d]+)%s?", INDEX))		
		local nI = table.getn(self.openNodes)		
		if lure.trim(self.openNodes[nI].tagName:upper()) == lure.trim(tagname):upper() then			
			table.remove(self.openNodes, table.getn(self.openNodes))			
			self.lastNodeReference = self.lastNodeReference.parentNode
		end			
		return INDEX + string.match(self.srcText, "(<.->)", INDEX):len()
end

--[[
-- @function: parseScriptTags
-- @description: helper function to parse script tags
-- @arg[int]: INDEX: index of node to parse
--]]
function DOMParser:parseScriptTags(INDEX)
    local index 		= INDEX
	local closeTagMatch = false
	local char 			= function(charIndex) return  self.srcText:sub(charIndex,charIndex) end
	local textBuffer 	= ""
		
	while closeTagMatch ~= true do
		if char(index) == "<" then
			if char(index + 1) == "/" then
				closeTagMatch = true
			else
				textBuffer = textBuffer .. char(index)
			end
		else
			textBuffer = textBuffer .. char(index)
		end
		index = index + 1
	end		
	textBuffer = lure.trim(textBuffer)		
	self.lastNodeReference.appendChild(lure.dom.createTextNodeObj(textBuffer))		
	return index - 1
end

--[[
-- @function: parseStyleTags
-- @description: helper function to parse style tags
-- @arg[int]: INDEX: index of node to parse
--]]
function DOMParser:parseStyleTags(INDEX)
    local index = INDEX
	local closeTagMatch = false
	local char = function(charIndex) return  self.srcText:sub(charIndex,charIndex) end
	local textBuffer = ""
	while closeTagMatch ~= true do
		if char(index) == "<" then
			if char(index + 1) == "/" then
				closeTagMatch = true
			end
		else
			textBuffer = textBuffer .. char(index)
		end
		index = index + 1
	end		
	textBuffer = lure.trim(textBuffer)		
	self.lastNodeReference.appendChild(lure.dom.createTextNodeObj(textBuffer))
	-- create the stylesheet for this style tag
	self.document.stylesheets.addItem(self.document.createStylesheet(textBuffer))				
	return index - 1
end