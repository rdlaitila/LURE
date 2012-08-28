lure.dom.DOMParser = {}

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.DOMParser.new()
	local self = {}
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.parsedebug 				= false
	---------------------------------------------------------------------	
	self.srcText					= nil
	---------------------------------------------------------------------	
	self.openNodes	 				= {}	
	---------------------------------------------------------------------	
	self.lastNodeReference 			= nil
	---------------------------------------------------------------------	
	self.selfCloseElements 			= {"base", "basefont", "frame", "link", "meta", "area", "br", "col", "hr", "img", "input", "param"}
	---------------------------------------------------------------------	
	self.textNodeCharBuffer 		= nil
	---------------------------------------------------------------------
	self.document					= lure.dom.createDocumentNodeObj()
	---------------------------------------------------------------------
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================	
	self.parseFromString = function(pSrcText)
		local index = 1
		local char = function(charIndex) return  self.srcText:sub(charIndex,charIndex) end	
		self.srcText = string.gsub(pSrcText, "[\t]", "")
		--self.srcText = string.gsub(pSrcText, "[\r\n]", "")		
		while index <= self.srcText:len() do			
			if char(index) == "<" then				
				if textNodeCharBuffer ~= nil then					
					self.openNode(index, "text") 								
				elseif char(index + 1) == "/" then					
					index = self.closeNode(index)				
				elseif self.srcText:sub(index+1, index+3) == "!--" then					
					index = self.openNode(index, "comment")
				elseif self.srcText:sub(index+1, index+7) == "!CDATA[" then					
					index = self.openNode(index, "CDATASection")					
				else					
					index = self.openNode(index, "tag")
				end
			else				
				if textNodeCharBuffer == nil then textNodeCharBuffer = "" end
				textNodeCharBuffer = textNodeCharBuffer .. char(index)				
				index = index +1
			end			
		end				
		
		return self.document
	end	
	---------------------------------------------------------------------		
	self.openNode = function(pIndex, pType)
		local nI = nil --nodeIndex
		local rI = pIndex --returnIndex		
		-----------------------------------------------------------------
		if pType == "tag" then			
			local tagContent = string.match(self.srcText, "<(.-)>", pIndex)
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
				lastNodeReference = self.document.appendChild(self.openNodes[nI])					
			else				
				lastNodeReference = lastNodeReference.appendChild(self.openNodes[nI])				
			end			
			
			-- for HTML, set shorthand element references
			if lastNodeReference.tagName:upper() == "HTML" then
				self.document.html = lastNodeReference
			elseif lastNodeReference.tagName:upper() == "HEAD" then
				self.document.head = lastNodeReference
			elseif lastNodeReference.tagName:upper() == "BODY" then
				self.document.body = lastNodeReference
			elseif lastNodeReference.tagName:upper() == "TITLE" then
				self.document.title = lastNodeReference
			end
			
			-- check to see if the tag is self closing, else check against self.selfCloseElements			
			if string.match(tagContent, "/$") then				
				self.closeNode(pIndex)
				nI = table.getn(self.openNodes)
			else
				for k,v in ipairs(self.selfCloseElements) do
					if v:upper() == self.openNodes[nI].tagName:upper() then						
						self.closeNode(pIndex)
						nI = table.getn(self.openNodes)						
					end
				end
			end
			
			rI = rI + string.match(self.srcText, "(<.->)", pIndex):len()
			
			-- watch out for special tags such as script/style etc. They require special processing
			if lastNodeReference.tagName == "script" then				
				rI = self.parseScriptTags(rI)
				return rI
			elseif lastNodeReference.tagName == "style" then				
				rI = self.parseStyleTags(rI)
				return rI
			else
				return rI
			end			
		-----------------------------------------------------------------
		elseif pType == "comment" then
			local commentText = string.match(self.srcText, "<!%-%-(.-)%-%->", pIndex)						
			local newTextNode = 
			lastNodeReference.appendChild(lure.dom.createCommentNodeObj(lure.trim(commentText)))			
			rI = pIndex + string.match(self.srcText, "(<!%-%-.-%-%->)", pIndex):len()
			return rI
		-----------------------------------------------------------------
		elseif pType == "text" then
			local text = lure.trim(textNodeCharBuffer)
			if text ~= "" then
				lastNodeReference.appendChild(lure.dom.createTextNodeObj(text))			
			end		
			textNodeCharBuffer = nil			
		-----------------------------------------------------------------
		elseif pType == "CDATASection" then
			local cdataText = string.match(self.srcText, "<!CDATA%[(.-)%]%]>", pIndex)
			local newNode = lure.dom.createCharacterDataNodeObj(cdataText)												
			lastNodeReference.appendChild(newNode)			
			return pIndex + string.match(self.srcText, "(<!CDATA%[.-%]%]>)", pIndex):len()
		end
		-----------------------------------------------------------------
	end
	---------------------------------------------------------------------	
	self.closeNode = function(pIndex)		
		local tagname = lure.trim(string.match(self.srcText, "/?([%a%d]+)%s?", pIndex))		
		local nI = table.getn(self.openNodes)		
		if lure.trim(self.openNodes[nI].tagName:upper()) == lure.trim(tagname):upper() then			
			table.remove(self.openNodes, table.getn(self.openNodes))			
			lastNodeReference = lastNodeReference.parentNode
		end			
		return pIndex + string.match(self.srcText, "(<.->)", pIndex):len()
	end	
	---------------------------------------------------------------------		
	self.parseScriptTags = function(pIndex)				
		local index 		= pIndex
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
		lastNodeReference.appendChild(lure.dom.createTextNodeObj(textBuffer))		
		return index - 1
	end
	---------------------------------------------------------------------	
	self.parseStyleTags = function(pIndex)		
		local index = pIndex
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
		lastNodeReference.appendChild(lure.dom.createTextNodeObj(textBuffer))
		-- create the stylesheet for this style tag
		self.document.stylesheets.addItem(self.document.createStylesheet(textBuffer))				
		return index - 1
	end
	---------------------------------------------------------------------		
	
	return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::