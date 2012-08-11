lure.dom.HTMLCssRule = {}

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.HTMLCssRule.new(pSelectorText, pDeclarationText)
	local self = {}
	
	--===================================================================
	-- OBJECT METATABLE                                                 =
	--===================================================================
	local self_mt = {}
	---------------------------------------------------------------------
	self_mt.__tostring = function()
		return "[object]:HTMLCssRule"
	end
	---------------------------------------------------------------------
	self_mt.__index = function(t, k)
		if k == "cssText" then
			return self.style.getCssText()
		end		
	end
	---------------------------------------------------------------------
	
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================	
	self.selectorText 	= nil
	---------------------------------------------------------------------
	self.style 			= lure.dom.HTMLCssRuleStyleobj.new(self)
	---------------------------------------------------------------------		
	self.length 		= nil
	---------------------------------------------------------------------	
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================
	self.parseDeclaration = function(pDeclaration)		
		for key, value in string.gmatch(pDeclaration, "(.-):(.-);") do			
			local isValidKey = false
			local cssDefinition = nil
			for a=1, table.getn(lure.dom.css_property_definitions) do
				if lure.dom.css_property_definitions[a].name == lure.trim(key) then
					isValidKey = true
					cssDefinition = lure.dom.css_property_definitions[a]
					self.style[cssDefinition.css_to_style_equiv] = lure.trim(value)
					break
				end				
			end
			if isValidKey == false then
				lure.throw(1, "Unsupported CSS key '"..key.."' Declaration will be dropped.")
			end
		end
	end
	---------------------------------------------------------------------
	
	self.selectorText	= pSelectorText
	self.parseDeclaration(pDeclarationText)
	
	setmetatable(self, self_mt)
	return self	
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::