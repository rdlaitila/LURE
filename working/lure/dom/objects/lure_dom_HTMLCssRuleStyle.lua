lure.dom.HTMLCssRuleStyleobj = {}

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.HTMLCssRuleStyleobj.new(pAttachNode)
	local self = {}
				
	--===================================================================
	-- OBJECT METATABLE                                                 =
	--===================================================================
	local self_mt = {}	
	---------------------------------------------------------------------
	self_mt.__tostring = function(t)
		return "[object]:CssRuleStyleObject"
	end
	---------------------------------------------------------------------
	self_mt.__index = function(t,k)
		if rawget(t, k) ~= nil then
			return rawget(t, k)
		else
			return lure.dom.HTMLCssRuleStyleobj.getProperty(self, k)
		end			
	end
	---------------------------------------------------------------------
	self_mt.__newindex = function(t,k,v)
		if rawget(t, k) ~= nil then
			rawset(t, k, b)
		else
			return lure.dom.HTMLCssRuleStyleobj.setProperty(self,k,v)
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
	self.styleRefStore 	= {}
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================
	self.getCssText = function()
		local cssText = ""
		for a=1, table.getn(self.styleRefStore) do			
			cssText = cssText .. self.styleRefStore[a].cssDef.name .. ":" .. self.styleRefStore[a].value .. ";"
		end
		return cssText		
	end
	
	setmetatable(self, self_mt)
	return self
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.HTMLCssRuleStyleobj.getProperty(pObjRef, pPropertyName)		
	local self = pObjRef
	local isValidPropertyName	= false	
	local cssDef				= nil
	
	for k1 in ipairs(lure.dom.cssDefs) do		
		if pPropertyName == lure.dom.cssDefs[k1].cssToStyle then			
			cssDef = lure.dom.cssDefs[k1]
			isValidPropertyName = true			
		end
	end
	
	if isValidPropertyName then
		for a=1, table.getn(self.styleRefStore) do
			if self.styleRefStore[a].key == pPropertyName then
				return self.styleRefStore[a].value
			end
		end
	else
		lure.throw(1, "Cannot get unsupported CSS key '".. pPropertyName .."'")
	end	
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.HTMLCssRuleStyleobj.setProperty(pObjRef, pPropertyName, pPropertyValue)
	local self 					= pObjRef
	local isValidPropertyName	= false
	local isValidPropertyValue	= false
	local cssDef				= nil
	
	for k1 in ipairs(lure.dom.cssDefs) do		
		if pPropertyName == lure.dom.cssDefs[k1].cssToStyle then			
			cssDef = lure.dom.cssDefs[k1]
			isValidPropertyName = true			
		end
	end
	
	if isValidPropertyName == true then
		if cssDef.validateValue(pPropertyValue) == true then
			isValidPropertyValue 	= true
			newStyleRef 			= table.insert(self.styleRefStore, 
			{
				key		=	lure.trim(pPropertyName),
				value	=	lure.trim(pPropertyValue),
				cssDef 	=	cssDef
			})
		else
			lure.throw(1, "CSS Definition value '".. pPropertyName .. ":" .. pPropertyValue ..";' is malformed or unsupported. Declaration will be dropped")
		end
	else
		lure.throw(1, "Unsupported CSS key '"..pPropertyName.."' Declaration will be dropped.")
	end	
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::