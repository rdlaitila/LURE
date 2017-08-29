--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

local path = ...
require(path .. ".libraries.util")
require(path .. ".libraries.skins")
require(path .. ".libraries.templates")
require(path .. ".libraries.debug")
local loveframes = require(path .. ".libraries.common")

-- library info
loveframes.author = "Kenny Shields"
loveframes.version = "0.9.8.1"
loveframes.stage = "Alpha"

-- library configurations
loveframes.config = {}
loveframes.config["DIRECTORY"] = nil
loveframes.config["DEFAULTSKIN"] = "Blue"
loveframes.config["ACTIVESKIN"] = "Blue"
loveframes.config["INDEXSKINIMAGES"] = true
loveframes.config["DEBUG"] = false
loveframes.config["ENABLE_SYSTEM_CURSORS"] = true
loveframes.config["ENABLE_UTF8_SUPPORT"] = false

-- misc library vars
loveframes.state = "none"
loveframes.drawcount = 0
loveframes.collisioncount = 0
loveframes.objectcount = 0
loveframes.hoverobject = false
loveframes.modalobject = false
loveframes.inputobject = false
loveframes.downobject = false
loveframes.resizeobject = false
loveframes.dragobject = false
loveframes.hover = false
loveframes.input_cursor_set = false
loveframes.prevcursor = nil
loveframes.basicfont = love.graphics.newFont(12)
loveframes.basicfontsmall = love.graphics.newFont(10)
loveframes.objects = {}
loveframes.collisions = {}

-- install directory of the library
local dir = loveframes.config["DIRECTORY"] or path

-- require middleclass
loveframes.class = require(dir .. ".third-party.middleclass")

-- replace all "." with "/" in the directory setting
dir = dir:gsub("\\", "/"):gsub("(%a)%.(%a)", "%1/%2")
loveframes.config["DIRECTORY"] = dir

-- enable key repeat
love.keyboard.setKeyRepeat(true)

-- check if utf8 support is enabled
if loveframes.config["ENABLE_UTF8_SUPPORT"] then
	require(path .. ".libraries.utf8")
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates all library objects
--]]---------------------------------------------------------
function loveframes.update(dt)

	local base = loveframes.base
	local input_cursor_set = loveframes.input_cursor_set
	
	loveframes.collisioncount = 0
	loveframes.objectcount = 0
	loveframes.hover = false
	loveframes.hoverobject = false
	
	local downobject = loveframes.downobject
	if #loveframes.collisions > 0 then
		local top = loveframes.collisions[#loveframes.collisions]
		if not downobject then
			loveframes.hoverobject = top
		else
			if downobject == top then
				loveframes.hoverobject = top
			end
		end
	end
	
	if loveframes.config["ENABLE_SYSTEM_CURSORS"] then 
		local hoverobject = loveframes.hoverobject
		local arrow = love.mouse.getSystemCursor("arrow")
		local curcursor = love.mouse.getCursor()
		if hoverobject then
			local ibeam = love.mouse.getSystemCursor("ibeam")
			local mx, my = love.mouse.getPosition()
			if hoverobject.type == "textinput" and not loveframes.resizeobject then
				if curcursor ~= ibeam then
					love.mouse.setCursor(ibeam)
				end
			elseif hoverobject.type == "frame" then
				if not hoverobject.dragging and hoverobject.canresize then
					if loveframes.util.BoundingBox(hoverobject.x, mx, hoverobject.y, my, 5, 1, 5, 1) then
						local sizenwse = love.mouse.getSystemCursor("sizenwse")
						if curcursor ~= sizenwse then
							love.mouse.setCursor(sizenwse)
						end
					elseif loveframes.util.BoundingBox(hoverobject.x + hoverobject.width - 5, mx, hoverobject.y + hoverobject.height - 5, my, 5, 1, 5, 1) then
						local sizenwse = love.mouse.getSystemCursor("sizenwse")
						if curcursor ~= sizenwse then
							love.mouse.setCursor(sizenwse)
						end
					elseif loveframes.util.BoundingBox(hoverobject.x + hoverobject.width - 5, mx, hoverobject.y, my, 5, 1, 5, 1) then
						local sizenesw = love.mouse.getSystemCursor("sizenesw")
						if curcursor ~= sizenesw then
							love.mouse.setCursor(sizenesw)
						end
					elseif loveframes.util.BoundingBox(hoverobject.x, mx, hoverobject.y + hoverobject.height - 5, my, 5, 1, 5, 1) then
						local sizenesw = love.mouse.getSystemCursor("sizenesw")
						if curcursor ~= sizenesw then
							love.mouse.setCursor(sizenesw)
						end
					elseif loveframes.util.BoundingBox(hoverobject.x + 5, mx, hoverobject.y, my, hoverobject.width - 10, 1, 2, 1) then
						local sizens = love.mouse.getSystemCursor("sizens")
						if curcursor ~= sizens then
							love.mouse.setCursor(sizens)
						end
					elseif loveframes.util.BoundingBox(hoverobject.x + 5, mx, hoverobject.y + hoverobject.height - 2, my, hoverobject.width - 10, 1, 2, 1) then
						local sizens = love.mouse.getSystemCursor("sizens")
						if curcursor ~= sizens then
							love.mouse.setCursor(sizens)
						end
					elseif loveframes.util.BoundingBox(hoverobject.x, mx, hoverobject.y + 5, my, 2, 1, hoverobject.height - 10, 1) then
						local sizewe = love.mouse.getSystemCursor("sizewe")
						if curcursor ~= sizewe then
							love.mouse.setCursor(sizewe)
						end
					elseif loveframes.util.BoundingBox(hoverobject.x + hoverobject.width - 2, mx, hoverobject.y + 5, my, 2, 1, hoverobject.height - 10, 1) then
						local sizewe = love.mouse.getSystemCursor("sizewe")
						if curcursor ~= sizewe then
							love.mouse.setCursor(sizewe)
						end
					else
						if not loveframes.resizeobject then
							local arrow = love.mouse.getSystemCursor("arrow")
							if curcursor ~= arrow then
								love.mouse.setCursor(arrow)
							end
						end
					end
				end
			elseif hoverobject.type == "text" and hoverobject.linkcol and not loveframes.resizeobject then
				local hand = love.mouse.getSystemCursor("hand")
				if curcursor ~= hand then
					love.mouse.setCursor(hand)
				end
			end
			if curcursor ~= arrow then
				if hoverobject.type ~= "textinput" and hoverobject.type ~= "frame" and not hoverobject.linkcol and not loveframes.resizeobject then
					love.mouse.setCursor(arrow)
				elseif hoverobject.type ~= "textinput" and curcursor == ibeam then
					love.mouse.setCursor(arrow)
				end
			end
		else
			if curcursor ~= arrow and not loveframes.resizeobject then
				love.mouse.setCursor(arrow)
			end
		end
	end
	
	loveframes.collisions = {}
	base:update(dt)

end

--[[---------------------------------------------------------
	- func: draw()
	- desc: draws all library objects
--]]---------------------------------------------------------
function loveframes.draw()

	local base = loveframes.base
	local r, g, b, a = love.graphics.getColor()
	local font = love.graphics.getFont()
	
	base:draw()
	
	loveframes.drawcount = 0
	loveframes.debug.draw()
	
	love.graphics.setColor(r, g, b, a)
	
	if font then
		love.graphics.setFont(font)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
--]]---------------------------------------------------------
function loveframes.mousepressed(x, y, button)

	local base = loveframes.base
	base:mousepressed(x, y, button)
	
	-- close open menus
	local bchildren = base.children
	local hoverobject = loveframes.hoverobject
	for k, v in ipairs(bchildren) do
		local otype = v.type
		local visible = v.visible
		if hoverobject then
			local htype = hoverobject.type
			if otype == "menu" and visible and htype ~= "menu" and htype ~= "menuoption" then
				v:SetVisible(false)
			end
		else
			if otype == "menu" and visible then
				v:SetVisible(false)
			end
		end
	end
	
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function loveframes.mousereleased(x, y, button)

	local base = loveframes.base
	base:mousereleased(x, y, button)
	
	-- reset the hover object
	if button == "l" then
		loveframes.downobject = false
		loveframes.selectedobject = false
	end
	
end

--[[---------------------------------------------------------
	- func: keypressed(key, isrepeat)
	- desc: called when the player presses a key
--]]---------------------------------------------------------
function loveframes.keypressed(key, isrepeat)

	local base = loveframes.base
	base:keypressed(key, isrepeat)
	
end

--[[---------------------------------------------------------
	- func: keyreleased(key)
	- desc: called when the player releases a key
--]]---------------------------------------------------------
function loveframes.keyreleased(key)

	local base = loveframes.base
	base:keyreleased(key)
	
end

--[[---------------------------------------------------------
	- func: textinput(text)
	- desc: called when the user inputs text
--]]---------------------------------------------------------
function loveframes.textinput(text)

	local base = loveframes.base
	base:textinput(text)
	
end

--[[---------------------------------------------------------
	- func: Create(type, parent)
	- desc: creates a new object or multiple new objects
			(based on the method used) and returns said
			object or objects for further manipulation
--]]---------------------------------------------------------
function loveframes.Create(data, parent)
	
	if type(data) == "string" then
	
		local objects = loveframes.objects
		local object = objects[data]
		local objectcount = loveframes.objectcount
		
		if not object then
			loveframes.util.Error("Error creating object: Invalid object '" ..data.. "'.")
		end
		
		-- create the object
		local newobject = object:new()
		
		-- apply template properties to the object
		loveframes.templates.ApplyToObject(newobject)
		
		-- if the object is a tooltip, return it and go no further
		if data == "tooltip" then
			return newobject
		end
		
		-- remove the object if it is an internal
		if newobject.internal then
			newobject:Remove()
			return
		end
		
		-- parent the new object by default to the base gui object
		newobject.parent = loveframes.base
		table.insert(loveframes.base.children, newobject)
		
		-- if the parent argument is not nil, make that argument the object's new parent
		if parent then
			newobject:SetParent(parent)
		end
		
		loveframes.objectcount = objectcount + 1
		
		-- return the object for further manipulation
		return newobject
		
	elseif type(data) == "table" then

		-- table for creation of multiple objects
		local objects = {}
		
		-- this function reads a table that contains a layout of object properties and then
		-- creates objects based on those properties
		local function CreateObjects(t, o, c)
			local child = c or false
			local validobjects = loveframes.objects
			for k, v in pairs(t) do
				-- current default object
				local object = validobjects[v.type]:new()
				-- insert the object into the table of objects being created
				table.insert(objects, object)
				-- parent the new object by default to the base gui object
				object.parent = loveframes.base
				table.insert(loveframes.base.children, object)
				if o then
					object:SetParent(o)
				end
				-- loop through the current layout table and assign the properties found
				-- to the current object
				for i, j in pairs(v) do
					if i ~= "children" and i ~= "func" then
						if child then
							if i == "x" then
								object["staticx"] = j
							elseif i == "y" then
								object["staticy"] = j
							else
								object[i] = j
							end
						else
							object[i] = j
						end
					elseif i == "children" then
						CreateObjects(j, object, true)
					end
				end
				if v.func then
					v.func(object)
				end
			end
		end
		
		-- create the objects
		CreateObjects(data)
		
		return objects
		
	end
	
end

--[[---------------------------------------------------------
	- func: NewObject(id, name, inherit_from_base)
	- desc: creates a new object
--]]---------------------------------------------------------
function loveframes.NewObject(id, name, inherit_from_base)
	
	local objects = loveframes.objects
	local object = false
	
	if inherit_from_base then
		local base = objects["base"]
		object = loveframes.class(name, base)
		objects[id] = object
	else
		object = loveframes.class(name)
		objects[id] = object
	end
	
	return object
	
end

--[[---------------------------------------------------------
	- func: SetState(name)
	- desc: sets the current state
--]]---------------------------------------------------------
function loveframes.SetState(name)

	loveframes.state = name
	loveframes.base.state = name
	
end

--[[---------------------------------------------------------
	- func: GetState()
	- desc: gets the current state
--]]---------------------------------------------------------
function loveframes.GetState()

	return loveframes.state
	
end

-- create a list of gui objects, skins and templates
local objects = loveframes.util.GetDirectoryContents(dir .. "/objects")
local skins = loveframes.util.GetDirectoryContents(dir .. "/skins")
local templates = loveframes.util.GetDirectoryContents(dir .. "/templates")

-- loop through a list of all gui objects and require them
for k, v in ipairs(objects) do
	if v.extension == "lua" then
		require(v.requirepath)
	end
end

-- loop through a list of all gui templates and require them
for k, v in ipairs(templates) do
	if v.extension == "lua" then
		local template = require(v.requirepath)
		loveframes.templates.Register(template)
	end
end

-- loop through a list of all gui skins and require them
for k, v in ipairs(skins) do
	if v.extension == "lua" then
		require(v.requirepath)
	end
end

-- create the base gui object
local base = loveframes.objects["base"]
loveframes.base = base:new()

return loveframes
