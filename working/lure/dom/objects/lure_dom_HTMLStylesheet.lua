lure.dom.HTMLStylesheetObj = {}

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.HTMLStylesheetObj.new()
	local self = {}	
	
	--===================================================================
	-- OBJECT METATABLE                                                 =
	--===================================================================
	local self_mt = {}
	self_mt.__tostring = function()
		return "[object]:HTMLStyleSheet"
	end
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================	
	self.title 		= nil
	---------------------------------------------------------------------
	self.cssRules 	= lure.dom.createNodeListObj()
	---------------------------------------------------------------------
	self.rules		= self.cssRules
	---------------------------------------------------------------------
	self.type		= nil
	---------------------------------------------------------------------
	self.disabled 	= false
	---------------------------------------------------------------------
	self.href		= nil
	---------------------------------------------------------------------
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================
	self.addRule = function( pSelector, pDeclaration, pIndex, pSpecificity )
		local newCssRule = lure.dom.HTMLCssRule.new(pSelector, pDeclaration)		
		
		if pSpecificity ~= nil then
			newCssRule.style.specificity 	= pSpecificity		
		end
		
		return self.cssRules.addItem(newCssRule, pIndex)
	end
	---------------------------------------------------------------------
	self.removeRule = function( pIndex )
		self.cssRules.removeItem(self.cssRules.item( pIndex ))
	end
	---------------------------------------------------------------------
	self.deleteRule = function( pIndex )
		self.cssRules.removeItem(self.cssRules.item( pIndex ))
	end	
	---------------------------------------------------------------------
	self.insertRule = function(pStyleText, pIndex)
		local index 			= 1
		local styleText			= pStyleText
		local selectorBuffer 	= ""
		local declarationBuffer = ""		
		local parseSelector 	= true
		local parseDeclaration 	= false		
		local char 				= function(charIndex) return  styleText:sub(charIndex,charIndex) end
		
		--remove all comment text
		styleText = string.gsub(styleText, "/%*(.-)%*/", "")		
		
		while index <= styleText:len() do
			if char(index) ~= "{" and char(index) ~= "}" then
				if parseSelector == true then
					selectorBuffer = selectorBuffer .. char(index)
				end
				if parseDeclaration ==  true then
					declarationBuffer = declarationBuffer .. char(index)
				end
			end
			
			if char(index) == "{" then
				parseSelector 		= false
				parseDeclaration 	= true			
			elseif char(index) == "}" then
				parseSelector 		= true
				parseDeclaration 	= false
				
				--remove tabs && newlines
				selectorBuffer = string.gsub(selectorBuffer, "[\t]", "")
				selectorBuffer = string.gsub(selectorBuffer, "[\r\n]", "")
				selectorBuffer = lure.trim(selectorBuffer)
				
				declarationBuffer = string.gsub(declarationBuffer, "[\t]", "")
				declarationBuffer = string.gsub(declarationBuffer, "[\r\n]", "")
				declarationBuffer = lure.trim(declarationBuffer)
				
				-- calculate it's specificity
				local specificity = lure.dom.css.computeCssRuleSpecificity( selectorBuffer )
							
				-- add thew new css rule
				local rule = self.addRule(selectorBuffer, declarationBuffer, pIndex, specificity)								
				
				selectorBuffer 		= ""
				declarationBuffer 	= ""
			end
			index = index + 1
		end
	end
	---------------------------------------------------------------------
	
	setmetatable(self, self_mt)
	return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::