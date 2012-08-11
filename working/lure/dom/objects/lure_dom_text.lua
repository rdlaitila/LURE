function lure.dom.createTextNodeObj(pText)
	local self = lure.dom.createCharacterDataNodeObj(pText)	
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.nodeName = "#text"	
	---------------------------------------------------------------------
	self.nodeType = 3
	---------------------------------------------------------------------
	self.nodeDesc = lure.dom.nodeTypes[3]
	---------------------------------------------------------------------
	
	--===================================================================
	-- MUTATORS                                                         =
	--===================================================================
	
	--===================================================================
	-- METHODS	                                                        =	
	--===================================================================	
	self.attach = function()				
		local newRomNode = lure.rom.newTextNodeObject(self.data, true, nil, 1)
		
		--set dom to rom references
		newRomNode.domNode 						= self
		self.romNode							= newRomNode
		
		dec, meas = string.match(self.parentNode.computedStyle.fontSize, "(%d+)(p?x?e?m?%%?)") 		
		newRomNode.font = love.graphics.newFont(tonumber(dec))
		
		--get parent text-wrap value
		local textWrap = self.parentNode.computedStyle.textWrap
		if textWrap == "character" then
			newRomNode.wrapType = 1
		elseif textWrap == "word" then
			newRomNode.wrapType = 2
		elseif textWrap == "inherit" then
		end
		
		--get parent text color
		local color = self.parentNode.computedStyle.color
		if color ~= nil then
			newRomNode.renderStyle.color = color
		end
		
		self.parentNode.romNode.appendChild(newRomNode)		
		return newRomNode
	end
	
	return self
end