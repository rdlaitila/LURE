lure.dom.HTMLNodeStyleobj = {}

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.HTMLNodeStyleobj.new(pAttachNode)
	local self = {}
				
	--===================================================================
	-- OBJECT METATABLE                                                 =
	--===================================================================
	local self_mt = {}	
	---------------------------------------------------------------------
	self_mt.__tostring = function(t)
		return "[object]: HTMLNodeStyle"
	end
	---------------------------------------------------------------------
	self_mt.__index = function(t,k)
		if tostring(k) == "specificity" then
			return rawget(t, k)
		else
			return lure.dom.HTMLNodeStyleobj.getProperty(self, k)
		end
	end
	---------------------------------------------------------------------
	self_mt.__newindex = function(t,k,v)
		if tostring(k) == "specificity" then
			rawset(t,k,v)
		else
			return lure.dom.HTMLNodeStyleobj.setProperty(self,k,v)
		end
	end
	---------------------------------------------------------------------
			
	--===================================================================
	-- PROPERTIES                                                       =
	--===================================================================
	self.parent 		= pAttachNode
	---------------------------------------------------------------------
	self.specificity 	= {0, 0, 0, 0}
	---------------------------------------------------------------------
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================	
	
	setmetatable(self, self_mt)
	return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.HTMLNodeStyleobj.getProperty(pObjRef, pPropertyName)		
	local self = pObjRef
	local allowmatch = false
	for k, v in pairs(lure.dom.cssDefs) do
		if pPropertyName:upper() == lure.dom.cssDefs[k].cssToStyle:upper() then
			allowmatch = true		
		end			
	end
	if allowmatch == true then
		local style = self.parent.getAttribute('style')
		if  style ~= nil then			
			for styleName, styleValue in string.gmatch(style, "(.-):(.-);") do										
				local origStyleName = lure.trim(styleName)
				local matchStyleName = string.gsub(origStyleName, "%-", "")				
				if lure.trim(matchStyleName:upper()) == lure.trim(pPropertyName:upper()) then						
					return lure.trim(styleValue)
				end
			end
		else
			return nil
		end
	else
		print("LURE WARNING:: Getting of style '".. pPropertyName .. "' not allowed or not implimented")
	end
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.HTMLNodeStyleobj.setProperty(pObjRef, pPropertyName, pPropertyValue)
	local self 					= pObjRef
	local allowmatch 			= false	
	local propertyCssEquivalent = nil
	local newstyle 				= ""
	for k, v in pairs(lure.dom.cssDefs) do
		if pPropertyName:upper() == lure.dom.cssDefs[k].cssToStyle:upper() then
			allowmatch 				= true
			propertyCssEquivalent	= v
		end			
	end
	if allowmatch == true then
		local modified = false
		local style = self.parent.getAttribute('style')
		for styleName, styleValue in string.gmatch(style, "(.-):(.-);") do
			local origStyleName = lure.trim(styleName)
			local matchStyleName = string.gsub(origStyleName, "%-", "")		
			if lure.trim(matchStyleName:upper()) == lure.trim(pPropertyName:upper()) then						
				styleValue = pPropertyValue
				modified = true				
			end
			newstyle = newstyle .. origStyleName .. ":" .. styleValue .. ";"										
		end
		if modified == false then			
			newstyle = newstyle .. propertyCssEquivalent .. ":" .. pPropertyValue .. ";"
		end
		self.parent.setAttribute('style', newstyle) 
		return true
		
	else
		print("LURE WARNING:: Setting of style '".. pPropertyName .. "' not allowed or not implimented")
	end
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::