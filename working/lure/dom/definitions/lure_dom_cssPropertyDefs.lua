-- CSS 2.1 PROPERTY DEFINITIONS
--[[
Value					:  	legal values & syntax
Initial					:  	initial value
Applies to				:  	elements this property applies to
Inherited				:  	whether the property is inherited
Percentages				:  	how percentage values are interpreted
Media					:  	which media groups the property applies to
Computed value			:  	how to compute the computed value 
style to css equivelent	: the equivilent name of the element.style.propertyName 
]]

lure.dom.css_property_definitions = {}
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.dom.css_property_definitions_init()		
	---------------------------------------------------
	-- background-color
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "background-color"
	cssdef.value              = "<color> | transparent | inherit"
	cssdef.initial            = "transparent"
	cssdef.applies_to         = "all"
	cssdef.inherited          = false
	cssdef.css_to_style_equiv = "backgroundColor"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		local foundMatch = false
		for a=1, table.getn(lure.rom.color_definitions) do
			if string.lower(value) == string.lower(lure.rom.color_definitions[a].name) then
				foundMatch = true
				break
			end
		end			
		if foundMatch == true then
			return true
		elseif string.match(value, "#[%d%a]+") ~= nil then
			return true				
		else
			return false
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- display
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "display"
	cssdef.value              = "inline | block | list-item | inline-block | table | inline-table | table-row-group | table-header-group | table-footer-group | table-row | table-column-group | table-column | table-cell | table-caption | none | inherit"
	cssdef.initial            = nil
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "display"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "block" then
			return true
		elseif value == "inline" then
			return true
		elseif value == "inline-block" then
			return true
		else
			return false
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- position
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "position"
	cssdef.value              = ""
	cssdef.initial            = "static"
	cssdef.applies_to         = "all"
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "position"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then
			return true
		elseif value == "static" then
			return true
		elseif value == "fixed" then
			return true
		elseif value == "absolute" then
			return true
		elseif value == "relative" then
			return true
		else
			return false
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- padding
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "padding"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "padding"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then
			return true
		else
			local returnVal = true
			for dec, meas in string.gmatch(value, "(%d+)(p?x?e?m?%%?)") do
				if tonumber(dec) ~= nil then
					if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
						returnVal = true
					else							
						returnVal = false
					end	
				else						
					returnVal = false
				end					
			end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- padding-top
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "padding-top"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "paddingTop"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then return true 
		else
			local returnVal =  true
			dec, meas = string.match(value, "(%d+)(p?x?e?m?%%?)")
			if tonumber(dec) ~= nil then
				if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
					returnVal = true
				else returnVal = false end	
			else returnVal = false end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- padding-right
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "padding-right"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "paddingRight"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then return true 
		else
			local returnVal =  true
			dec, meas = string.match(value, "(%d+)(p?x?e?m?%%?)")
			if tonumber(dec) ~= nil then
				if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
					returnVal = true
				else returnVal = false end	
			else returnVal = false end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- padding-bottom
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "padding-bottom"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "paddingBottom"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then return true 
		else
			local returnVal =  true
			dec, meas = string.match(value, "(%d+)(p?x?e?m?%%?)")
			if tonumber(dec) ~= nil then
				if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
					returnVal = true
				else returnVal = false end	
			else returnVal = false end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- padding-left
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "padding-left"
	cssdef.value              = ""
	cssdef.initial            = "0px"
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "paddingLeft"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then return true 
		else
			local returnVal =  true
			dec, meas = string.match(value, "(%d+)(p?x?e?m?%%?)")				
			if tonumber(dec) ~= nil then
				if meas == "px" or meas == "em" or meas == "%" or meas == "" then													
					returnVal = true
				else returnVal = false 	end	
			else returnVal = false end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- width
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "width"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "width"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then return true 
		else
			local returnVal =  true
			dec, meas = string.match(value, "(%d+)(p?x?e?m?%%?)")
			if tonumber(dec) ~= nil then
				if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
					returnVal = true
				else returnVal = false end	
			else returnVal = false end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- height
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "height"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "height"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then return true 
		elseif value == "auto" then return true
		else
			local returnVal =  true
			dec, meas = string.match(value, "(%d+)(p?x?e?m?%%?)")
			if tonumber(dec) ~= nil then
				if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
					returnVal = true
				else returnVal = false end	
			else returnVal = false end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- margin
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "margin"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "margin"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then
			return true
		else
			local returnVal = true
			for dec, meas in string.gmatch(value, "(%d+)(p?x?e?m?%%?)") do
				if tonumber(dec) ~= nil then
					if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
						returnVal = true
					else							
						returnVal = false
					end	
				else						
					returnVal = false
				end					
			end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- margin-top
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "margin-top"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "marginTop"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then
			return true
		else
			local returnVal = true
			for dec, meas in string.gmatch(value, "(%d+)(p?x?e?m?%%?)") do
				if tonumber(dec) ~= nil then
					if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
						returnVal = true
					else							
						returnVal = false
					end	
				else						
					returnVal = false
				end					
			end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- margin-right
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "margin-right"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "marginRight"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then
			return true
		else
			local returnVal = true
			for dec, meas in string.gmatch(value, "(%d+)(p?x?e?m?%%?)") do
				if tonumber(dec) ~= nil then
					if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
						returnVal = true
					else							
						returnVal = false
					end	
				else						
					returnVal = false
				end					
			end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- margin-bottom
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "margin-bottom"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "marginBottom"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then
			return true
		else
			local returnVal = true
			for dec, meas in string.gmatch(value, "(%d+)(p?x?e?m?%%?)") do
				if tonumber(dec) ~= nil then
					if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
						returnVal = true
					else							
						returnVal = false
					end	
				else						
					returnVal = false
				end					
			end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- margin-left
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "margin-left"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "marginLeft"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then
			return true
		else
			local returnVal = true
			for dec, meas in string.gmatch(value, "(%d+)(p?x?e?m?%%?)") do
				if tonumber(dec) ~= nil then
					if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
						returnVal = true
					else							
						returnVal = false
					end	
				else						
					returnVal = false
				end					
			end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- top
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "top"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "top"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then return true 
		else
			local returnVal =  true
			dec, meas = string.match(value, "(%d+)(p?x?e?m?%%?)")
			if tonumber(dec) ~= nil then
				if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
					returnVal = true
				else returnVal = false end	
			else returnVal = false end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- right
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "right"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "right"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then return true 
		else
			local returnVal =  true
			dec, meas = string.match(value, "(%d+)(p?x?e?m?%%?)")
			if tonumber(dec) ~= nil then
				if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
					returnVal = true
				else returnVal = false end	
			else returnVal = false end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- bottom
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "bottom"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "bottom"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then return true 
		else
			local returnVal =  true
			dec, meas = string.match(value, "(%d+)(p?x?e?m?%%?)")
			if tonumber(dec) ~= nil then
				if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
					returnVal = true
				else returnVal = false end	
			else returnVal = false end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- left
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "left"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "left"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then return true 
		else
			local returnVal =  true
			dec, meas = string.match(value, "(%d+)(p?x?e?m?%%?)")
			if tonumber(dec) ~= nil then
				if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
					returnVal = true
				else returnVal = false end	
			else returnVal = false end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- font-size
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "font-size"
	cssdef.value              = ""
	cssdef.initial            = "15px"
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "fontSize"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" then return true 
		else
			local returnVal =  true
			dec, meas = string.match(value, "(%d+)(p?x?e?m?%%?)")
			if tonumber(dec) ~= nil then
				if meas == "px" or meas == "em" or meas == "%" or meas == "" then							
					returnVal = true
				else returnVal = false end	
			else returnVal = false end
			return returnVal
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- text-wrap
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "text-wrap"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "textWrap"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" or value == "character" or value == "word" or value == "none" then
			return true
		else
			return false
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
	-- color
	---------------------------------------------------
	local cssdef = {}
	cssdef.name               = "color"
	cssdef.value              = ""
	cssdef.initial            = 0
	cssdef.applies_to         = nil
	cssdef.inherited          = true
	cssdef.css_to_style_equiv = "color"
	cssdef.validateValue      = function(pValue)
		local value = lure.trim(pValue)
		local foundMatch = false
		for a=1, table.getn(lure.rom.color_definitions) do
			if string.lower(value) == string.lower(lure.rom.color_definitions[a].name) then
				foundMatch = true
				break
			end
		end			
		if foundMatch == true then
			return true
		elseif string.match(value, "#[%d%a]+") ~= nil then
			return true				
		else
			return false
		end
	end
	table.insert(lure.dom.css_property_definitions, cssdef)
	---------------------------------------------------
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
lure.dom.css_property_definitions_init()