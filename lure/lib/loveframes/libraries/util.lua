--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

-- get the current require path
local path = string.sub(..., 1, string.len(...) - string.len(".util"))
local loveframes = require(path .. ".common")

-- util library
loveframes.util = {}

--[[---------------------------------------------------------
	- func: SetActiveSkin(name)
	- desc: sets the active skin
--]]---------------------------------------------------------
function loveframes.util.SetActiveSkin(name)
	
	loveframes.config["ACTIVESKIN"] = name

end

--[[---------------------------------------------------------
	- func: GetActiveSkin()
	- desc: gets the active skin
--]]---------------------------------------------------------
function loveframes.util.GetActiveSkin()
	
	local index = loveframes.config["ACTIVESKIN"]
	local skin = loveframes.skins.available[index]
	
	return skin

end

--[[---------------------------------------------------------
	- func: BoundingBox(x1, x2, y1, y2, w1, w2, h1, h2)
	- desc: checks for a collision between two boxes
	- note: I take no credit for this function
--]]---------------------------------------------------------
function loveframes.util.BoundingBox(x1, x2, y1, y2, w1, w2, h1, h2)

	if x1 > x2 + w2 - 1 or y1 > y2 + h2 - 1 or x2 > x1 + w1 - 1 or y2 > y1 + h1 - 1 then
		return false
	else
		return true
	end
	
end

--[[---------------------------------------------------------
	- func: GetCollisions(object, table)
	- desc: gets all objects colliding with the mouse
--]]---------------------------------------------------------
function loveframes.util.GetCollisions(object, t)

	local x, y = love.mouse.getPosition()
	local curstate = loveframes.state
	local object = object or loveframes.base
	local visible = object.visible
	local children = object.children
	local internals = object.internals
	local objectstate = object.state
	local t = t or {}
	
	if objectstate == curstate and visible then
		local objectx = object.x
		local objecty = object.y
		local objectwidth = object.width
		local objectheight = object.height
		local col = loveframes.util.BoundingBox(x, objectx, y, objecty, 1, objectwidth, 1, objectheight)
		local collide = object.collide
		if col and collide then
			local clickbounds = object.clickbounds
			if clickbounds then
				local cx = clickbounds.x
				local cy = clickbounds.y
				local cwidth = clickbounds.width
				local cheight = clickbounds.height
				local clickcol = loveframes.util.BoundingBox(x, cx, y, cy, 1, cwidth, 1, cheight)
				if clickcol then
					table.insert(t, object)
				end
			else
				table.insert(t, object)
			end
		end
		if children then
			for k, v in ipairs(children) do
				loveframes.util.GetCollisions(v, t)
			end
		end
		if internals then
			for k, v in ipairs(internals) do
				local type = v.type
				if type ~= "tooltip" then
					loveframes.util.GetCollisions(v, t)
				end
			end
		end
	end
	
	return t

end

--[[---------------------------------------------------------
	- func: GetAllObjects(object, table)
	- desc: gets all active objects
--]]---------------------------------------------------------
function loveframes.util.GetAllObjects(object, t)
	
	local object = object or loveframes.base
	local internals = object.internals
	local children = object.children
	local t = t or {}
	
	table.insert(t, object)
	
	if internals then
		for k, v in ipairs(internals) do
			loveframes.util.GetAllObjects(v, t)
		end
	end
	
	if children then
		for k, v in ipairs(children) do
			loveframes.util.GetAllObjects(v, t)
		end
	end
	
	return t
	
end

--[[---------------------------------------------------------
	- func: GetDirectoryContents(directory, table)
	- desc: gets the contents of a directory and all of
			its subdirectories
--]]---------------------------------------------------------
function loveframes.util.GetDirectoryContents(dir, t)

	local dir = dir
	local t = t or {}
	local dirs = {}
	local files = love.filesystem.getDirectoryItems(dir)
	
	for k, v in ipairs(files) do
		local isdir = love.filesystem.isDirectory(dir.. "/" ..v)
		if isdir == true then
			table.insert(dirs, dir.. "/" ..v)
		else
			local parts = loveframes.util.SplitString(v, "([.])")
			local extension = #parts > 1 and parts[#parts]
			if #parts > 1 then
				parts[#parts] = nil
			end
			local name = table.concat(parts, ".")
			table.insert(t, {
				path = dir, 
				fullpath = dir.. "/" ..v, 
				requirepath = dir:gsub("/", ".") .. "." ..name, 
				name = name, 
				extension = extension
			})
		end
	end
	
	for k, v in ipairs(dirs) do
		t = loveframes.util.GetDirectoryContents(v, t)
	end
	
	return t
	
end


--[[---------------------------------------------------------
	- func: Round(num, idp)
	- desc: rounds a number based on the decimal limit
	- note: I take no credit for this function
--]]---------------------------------------------------------
function loveframes.util.Round(num, idp)

	local mult = 10^(idp or 0)
	
    if num >= 0 then 
		return math.floor(num * mult + 0.5) / mult
    else 
		return math.ceil(num * mult - 0.5) / mult 
	end
	
end

--[[---------------------------------------------------------
	- func: SplitString(string, pattern)
	- desc: splits a string into a table based on a given pattern
	- note: I take no credit for this function
--]]---------------------------------------------------------
function loveframes.util.SplitString(str, pat)

	local t = {}  -- NOTE: use {n = 0} in Lua-5.0
	
	if pat == " " then
		local fpat = "(.-)" .. pat
		local last_end = 1
		local s, e, cap = str:find(fpat, 1)
		while s do
			if s ~= #str then
				cap = cap .. " "
			end
			if s ~= 1 or cap ~= "" then
				table.insert(t,cap)
			end
			last_end = e+1
			s, e, cap = str:find(fpat, last_end)
		end
		if last_end <= #str then
			cap = str:sub(last_end)
			table.insert(t, cap)
		end
	else
		local fpat = "(.-)" .. pat
		local last_end = 1
		local s, e, cap = str:find(fpat, 1)
		while s do
			if s ~= 1 or cap ~= "" then
				table.insert(t,cap)
			end
			last_end = e+1
			s, e, cap = str:find(fpat, last_end)
		end
		if last_end <= #str then
			cap = str:sub(last_end)
			table.insert(t, cap)
		end
	end
	
	return t
	
end

--[[---------------------------------------------------------
	- func: RemoveAll()
	- desc: removes all gui elements
--]]---------------------------------------------------------
function loveframes.util.RemoveAll()

	loveframes.base.children = {}
	loveframes.base.internals = {}
	
	loveframes.hoverobject = false
	loveframes.downobject = false
	loveframes.modalobject = false
	loveframes.inputobject = false
	loveframes.hover = false
	
end

--[[---------------------------------------------------------
	- func: TableHasValue(table, value)
	- desc: checks to see if a table has a specific value
--]]---------------------------------------------------------
function loveframes.util.TableHasValue(table, value)
	
	for k, v in pairs(table) do
		if v == value then
			return true
		end
	end
	
	return false
	
end

--[[---------------------------------------------------------
	- func: TableHasKey(table, key)
	- desc: checks to see if a table has a specific key
--]]---------------------------------------------------------
function loveframes.util.TableHasKey(table, key)

	return table[key] ~= nil
	
end

--[[---------------------------------------------------------
	- func: Error(message)
	- desc: displays a formatted error message
--]]---------------------------------------------------------
function loveframes.util.Error(message)

	error("[Love Frames] " ..message)
	
end

--[[---------------------------------------------------------
	- func: GetCollisionCount()
	- desc: gets the total number of objects colliding with
			the mouse
--]]---------------------------------------------------------
function loveframes.util.GetCollisionCount()

	return loveframes.collisioncount

end

--[[---------------------------------------------------------
	- func: GetHover()
	- desc: returns loveframes.hover, can be used to check
			if the mouse is colliding with a visible
			Love Frames object
--]]---------------------------------------------------------
function loveframes.util.GetHover()

	return loveframes.hover
	
end

--[[---------------------------------------------------------
	- func: RectangleCollisionCheck(rect1, rect2)
	- desc: checks for a collision between two rectangles
			based on two tables containing rectangle sizes
			and positions
--]]---------------------------------------------------------
function loveframes.util.RectangleCollisionCheck(rect1, rect2)

	return loveframes.util.BoundingBox(rect1.x, rect2.x, rect1.y, rect2.y, rect1.width, rect2.width, rect1.height, rect2.height)
	
end

--[[---------------------------------------------------------
	- func: DeepCopy(orig)
	- desc: copies a table
	- note: I take not credit for this function
--]]---------------------------------------------------------
function loveframes.util.DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[loveframes.util.DeepCopy(orig_key)] = loveframes.util.DeepCopy(orig_value)
        end
        setmetatable(copy, loveframes.util.DeepCopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--[[---------------------------------------------------------
	- func: GetHoverObject()
	- desc: returns loveframes.hoverobject
--]]---------------------------------------------------------
function loveframes.util.GetHoverObject()
	
	return loveframes.hoverobject
	
end

--[[---------------------------------------------------------
	- func: IsCtrlDown()
	- desc: checks for ctrl, for use with multiselect, copy,
			paste, and such. On OS X it actually looks for cmd.
--]]---------------------------------------------------------
function loveframes.util.IsCtrlDown()
	if love._os == "OS X" then
		return love.keyboard.isDown("lmeta") or love.keyboard.isDown("rmeta") or
			love.keyboard.isDown("lgui") or love.keyboard.isDown("rgui")
	end
	return love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")
end
