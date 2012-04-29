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

lure.dom.css_property_definitions = 
{
	--------------------------------------------------------------------------------
	[1] = 
	{
		name				= "background-color",		
		value 				= "<color> | transparent | inherit",
		initial 			= "transparent",
		applies_to 			= "all",
		inherited 			= false,		
		css_to_style_equiv	= "backgroundColor",
		validateValue 		= function(pValue)
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
	},		
	--------------------------------------------------------------------------------
	[2] = 
	{
		name				= "display",		 
		value 				= "inline | block | list-item | inline-block | table | inline-table | table-row-group | table-header-group | table-footer-group | table-row | table-column-group | table-column | table-cell | table-caption | none | inherit",
		initial 			= nil,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "display",
		validateValue 		= function(pValue)
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
	},	
	--------------------------------------------------------------------------------	
	[3] = 
	{
		name				= "position",		
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "position",
		validateValue 		= function(pValue)
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
	},		
	--------------------------------------------------------------------------------	
	[4] = 
	{
		name				= "padding",		
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "padding",
		validateValue 		= function(pValue)
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
	},
	--------------------------------------------------------------------------------
	[5] = 
	{
		name				= "padding-top",		
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "paddingTop",
		validateValue 		= function(pValue)
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
	},	
	--------------------------------------------------------------------------------	
	[6] = 
	{
		name				= "padding-right",		
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "paddingRight",
		validateValue 		= function(pValue)
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
	},	
	--------------------------------------------------------------------------------	
	[7] = 
	{
		name				= "padding-bottom",		
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "paddingBottom",
		validateValue 		= function(pValue)
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
	},	
	--------------------------------------------------------------------------------
	[8] = 
	{
		name				= "padding-left",		
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "paddingLeft",
		validateValue 		= function(pValue)
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
	},	
	--------------------------------------------------------------------------------	
	[9] = 
	{
		name				= "width",		
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "width",
		validateValue 		= function(pValue)
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
	},	
	--------------------------------------------------------------------------------	
	[10] = 
	{
		name				= "height",		
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "height",
		validateValue 		= function(pValue)
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
	},
	--------------------------------------------------------------------------------
	[11] = 
	{
		name				= "margin",		
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "margin",		
		validateValue 		= function(pValue)
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
	},	
	--------------------------------------------------------------------------------	
	[12] =
	{
		name				= "margin-top",
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "marginTop",		
		validateValue 		= function(pValue)
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
	},
	--------------------------------------------------------------------------------
	[13] =
	{
		name				= "margin-right",
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "marginRight",		
		validateValue 		= function(pValue)
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
	},
	--------------------------------------------------------------------------------
	[14] =
	{
		name				= "margin-bottom",
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "marginBottom",		
		validateValue 		= function(pValue)
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
	},
	--------------------------------------------------------------------------------
	[15] =
	{
		name				= "margin-left",
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "marginLeft",		
		validateValue 		= function(pValue)
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
	},
	--------------------------------------------------------------------------------
	[16] =
	{
		name				= "top",
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "top",		
		validateValue 		= function(pValue)
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
	},
	--------------------------------------------------------------------------------
	[17] =
	{
		name				= "right",
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "right",		
		validateValue 		= function(pValue)
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
	},
	--------------------------------------------------------------------------------
	[18] =
	{
		name				= "bottom",
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "bottom",		
		validateValue 		= function(pValue)
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
	},
	--------------------------------------------------------------------------------
	[19] =
	{
		name				= "left",
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "left",		
		validateValue 		= function(pValue)
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
	},
	--------------------------------------------------------------------------------
	[20] = 
	{
		name				= "font-size",
		initial 			= 0,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "fontSize",		
		validateValue 		= function(pValue)
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
	},
	--------------------------------------------------------------------------------
	[21] = 
	{
		name				= "text-wrap",
		initial 			= "character",
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "textWrap",		
		validateValue 		= function(pValue)
			local value = lure.trim(pValue)
			if value == "inherit" or value == "character" or value == "word" or value == "none" then
				return true
			else
				return false
			end
		end
	},
	--------------------------------------------------------------------------------
	[22] = 
	{
		name				= "color",
		initial 			= nil,
		applies_to 			= nil,
		inherited 			= true,		
		css_to_style_equiv	= "color",		
		validateValue 		= function(pValue)
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
	}
	--------------------------------------------------------------------------------
}