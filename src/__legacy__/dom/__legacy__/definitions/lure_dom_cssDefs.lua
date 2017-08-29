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

lure.dom.cssDefs = {}
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
---------------------------------------------------
-- background-color
---------------------------------------------------	
table.insert(lure.dom.cssDefs, 
{
	name            = "background-color",
	value           = "<color> | transparent | inherit",
	initial         = "transparent",
	applies_to      = "all",
	inherited       = false,
	cssToStyle 		= "backgroundColor",
	validateValue 	= function(pValue)
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
})	
---------------------------------------------------
-- display
---------------------------------------------------	
table.insert(lure.dom.cssDefs, 
{
	name            = "display",
	value           = "inline | block | list-item | inline-block | table | inline-table | table-row-group | table-header-group | table-footer-group | table-row | table-column-group | table-column | table-cell | table-caption | none | inherit",
	initial         = nil,
	applies_to      = nil,
	inherited       = true,
	cssToStyle 		= "display",
	validateValue   = function(pValue)
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
})
---------------------------------------------------
-- position
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "position",
	value              = "",
	initial            = "static",
	applies_to         = "all",
	inherited          = true,
	cssToStyle = "position",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- padding
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "padding",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "padding",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- padding-top
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "padding-top",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "paddingTop",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- padding-right
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "padding-right",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "paddingRight",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- padding-bottom
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "padding-bottom",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "paddingBottom",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- padding-left
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "padding-left",
	value              = "",
	initial            = "0px",
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "paddingLeft",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- width
---------------------------------------------------	
table.insert(lure.dom.cssDefs, 
{
	name               = "width",
	value              = "",
	initial            = "100%",
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "width",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- height
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "height",
	value              = "",
	initial            = "auto",
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "height",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- margin
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "margin",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "margin",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- margin-top
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "margin-top",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "marginTop",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- margin-right
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "margin-right",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "marginRight",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- margin-bottom
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "margin-bottom",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "marginBottom",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- margin-left
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "margin-left",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "marginLeft",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- top
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "top",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "top",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- right
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "right",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "right",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- bottom
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "bottom",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "bottom",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- left
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "left",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "left",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- font-size
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "font-size",
	value              = "",
	initial            = "15px",
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "fontSize",
	validateValue      = function(pValue)
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
})
---------------------------------------------------
-- text-wrap
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "text-wrap",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "textWrap",
	validateValue      = function(pValue)
		local value = lure.trim(pValue)
		if value == "inherit" or value == "character" or value == "word" or value == "none" then
			return true
		else
			return false
		end
	end
})
---------------------------------------------------
-- color
---------------------------------------------------
table.insert(lure.dom.cssDefs, 
{
	name               = "color",
	value              = "",
	initial            = 0,
	applies_to         = nil,
	inherited          = true,
	cssToStyle = "color",
	validateValue      = function(pValue)
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
})
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::