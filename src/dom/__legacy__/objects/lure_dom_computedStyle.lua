lure.dom.computedStyleObj = {}
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.dom.createComputedStyleObj(pAttachNode)
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
		--print(tostring(t) .. "[" .. tostring(k) ..  "]")
		if k == "styleRefStore" or
		   k == "specificity" or
		   k == "getProperty" or
		   k == "setProperty" or
		   k == "parent" then
			return rawget(t, k)
		else
			return rawget(self, 'getProperty')(k)
			--return lure.dom.computedStyleObj.getProperty(self, k)		
		end		
	end
	---------------------------------------------------------------------
	self_mt.__newindex = function(t,k,v)
		if k == "styleRefStore" or
		   k == "specificity" or
		   k == "getProperty" or
		   k == "setProperty" or
		   k == "parent" then
		   rawset(t, k, v)
		else		
			return rawget(t, 'setProperty')(k,v)
			--return lure.dom.computedStyleObj.setProperty(self,k,v)
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
	---------------------------------------------------------------------
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================
	self.getStyleText = function()
		local cssText = ""
		for a=1, table.getn(self.styleRefStore) do
			cssText = cssText .. self.styleRefStore[a].key .. ":" .. self.styleRefStore[a].value .. ";"
		end
		return cssText		
	end
	---------------------------------------------------------------------
	self.getProperty = function( pPropertyName )
		--print("GETTING PROPERTY: " .. pPropertyName)
		local isValidPropertyName	= false	
		local cssDef				= nil
		local returnValue			= ""
		
		for k1, v1 in pairs(lure.dom.cssDefs) do		
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
			return cssDef.initial
		else
			lure.throw(1, "Cannot get unsupported CSS key '".. pPropertyName .."'")
		end	
	end
	---------------------------------------------------------------------
	self.setProperty = function( pPropertyName, pPropertyValue )
		--print("SETTING PROPERTY: " .. tostring(pPropertyName) .. " with value: " .. tostring(pPropertyValue))				
		local isValidPropertyName	= false
		local isValidPropertyValue	= false
		local cssDef				= nil
		
		for k1, v1 in pairs(lure.dom.cssDefs) do		
			if pPropertyName == lure.dom.cssDefs[k1].cssToStyle then			
				cssDef = lure.dom.cssDefs[k1]
				isValidPropertyName = true			
			end
		end
		
		if isValidPropertyName == true then
			if cssDef.validateValue(pPropertyValue) == true then
				--if style already exists in the reference store, set it
				for a=1, table.getn(self.styleRefStore) do
					if self.styleRefStore[a].key == pPropertyName then
						self.styleRefStore[a].value = lure.trim(pPropertyValue)
						return true
					end				
				end
				--else create a new entry in the style reference store 
				newStyleRef = table.insert(self.styleRefStore, 
				{
					key		=	lure.trim(pPropertyName),
					value	=	lure.trim(pPropertyValue)
				})
			else
				lure.throw(1, "CSS Definition value '".. pPropertyName .. ":" .. pPropertyValue ..";' is malformed or unsupported. Declaration will be dropped")
			end
		else
			lure.throw(1, "Unsupported CSS key '"..pPropertyName.."' Declaration will be dropped.")
		end		
	end
	---------------------------------------------------------------------
	
	setmetatable(self, self_mt)
	return self
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
