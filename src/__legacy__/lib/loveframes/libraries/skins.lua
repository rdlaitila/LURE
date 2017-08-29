--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

-- get the current require path
local path = string.sub(..., 1, string.len(...) - string.len(".skins"))
local loveframes = require(path .. ".common")

-- skins library
loveframes.skins = {}

-- available skins
loveframes.skins.available = {}

--[[---------------------------------------------------------
	- func: Register(skin)
	- desc: registers a skin
--]]---------------------------------------------------------
function loveframes.skins.Register(skin)
	
	local name = skin.name
	local author = skin.author
	local version = skin.version
	local base = skin.base
	local newskin = false
	
	if name == "" or not name then
		loveframes.util.Error("Skin registration error: Invalid or missing name data.")
	end
	
	if author == "" or not author then
		loveframes.util.Error("Skin registration error: Invalid or missing author data.")
	end
	
	if version == "" or not version then
		loveframes.util.Error("Skin registration error: Invalid or missing version data.")
	end
	
	local namecheck = loveframes.skins.available[name]
	if namecheck then
		loveframes.util.Error("Skin registration error: A skin with the name '" ..name.. "' already exists.")
	end
	
	local dir = skin.directory or loveframes.config["DIRECTORY"] .. "/skins/" ..name
	local dircheck = love.filesystem.isDirectory(dir)
	if not dircheck then
		loveframes.util.Error("Skin registration error: Could not find a directory for skin '" ..name.. "'.")
	end
	
	local imagedir = skin.imagedir or dir .. "/images"
	local imagedircheck = love.filesystem.isDirectory(imagedir)
	if not imagedircheck then
		loveframes.util.Error("Skin registration error: Could not find an image directory for skin '" ..name.. "'.")
	end
	
	if base then
		local basename = base
		base = loveframes.skins.Get(base)
		if not base then
			loveframes.util.Error("Could not find base skin '" ..basename.. "' for skin '" ..name.. "'.")
		end
		newskin = loveframes.util.DeepCopy(base)
		newskin.name = name
		newskin.author = author
		newskin.version = version
		newskin.imagedir = imagedir
		local skincontrols = skin.controls
		local basecontrols = base.controls
		if skincontrols and basecontrols then
			for k, v in pairs(skincontrols) do
				newskin.controls[k] = v
			end
			for k, v in pairs(skin) do
				if type(v) == "function" then
					newskin[k] = v
				end
			end
		end
	end
	
	if newskin then
		loveframes.skins.available[name] = newskin
	else
		loveframes.skins.available[name] = skin
	end
	
	loveframes.skins.available[name].dir = dir
	loveframes.skins.available[name].images = {}
	
	local indeximages = loveframes.config["INDEXSKINIMAGES"]
	if indeximages then
		local images = loveframes.util.GetDirectoryContents(imagedir)
		for k, v in ipairs(images) do
			local filename = v.name
			local extension = v.extension
			local fullpath = v.fullpath
			local key = filename .. "." .. extension
			if extension ~= "db" and extension ~= "DS_Store" then
				loveframes.skins.available[name].images[key] = love.graphics.newImage(fullpath)
			end
		end
	end
	
end

--[[---------------------------------------------------------
	- func: GetAvailable()
	- desc: gets all available skins
--]]---------------------------------------------------------
function loveframes.skins.GetAvailable()

	local available = loveframes.skins.available
	return available
	
end

--[[---------------------------------------------------------
	- func: Get(name)
	- desc: gets a skin by its name
--]]---------------------------------------------------------
function loveframes.skins.Get(name)

	local available = loveframes.skins.available
	local skin = available[name] or false
	
	return skin
	
end

--[[---------------------------------------------------------
	- func: SetControl(name, control, value)
	- desc: changes the value of a control in the 
			specified skin
--]]---------------------------------------------------------
function loveframes.skins.SetControl(name, control, value)

	local skin = loveframes.skins.Get(name)
	
	if skin then
		if skin.controls and skin.controls[control] then
			skin.controls[control] = value
		end
	end
	
end

--[[---------------------------------------------------------
	- func: SetImage(name, image, value)
	- desc: changes the value of an image index in
			the images table of the specified skin
--]]---------------------------------------------------------
function loveframes.skins.SetImage(name, image, value)

	local skin = loveframes.skins.Get(name)
	
	if skin then
		if skin.images and skin.images[image] then
			skin.images[image] = value
		end
	end
	
end

--[[---------------------------------------------------------
	- func: SetImageDirectory(name, dir)
	- desc: sets the image directory of a skin
--]]---------------------------------------------------------
function loveframes.skins.SetImageDirectory(name, dir)

	local skin = loveframes.skins.Get(name)
	
	if skin then
		skin.imagedir = dir
	end
	
end

--[[---------------------------------------------------------
	- func: ReloadImages(name)
	- desc: reloads a skin's images
--]]---------------------------------------------------------
function loveframes.skins.ReloadImages(name)

	local skin = loveframes.skins.Get(name)
	local indeximages = loveframes.config["INDEXSKINIMAGES"]
	
	if skin and indeximages then
		local basedir = loveframes.config["DIRECTORY"]
		local imagedir = skin.imagedir or basedir .. "/skins/" ..name.. "/images"
		local dircheck = love.filesystem.isDirectory(imagedir)
		if dircheck then
			local images = loveframes.util.GetDirectoryContents(imagedir)
			for k, v in ipairs(images) do
				local filename = v.name
				local extension = v.extension
				local fullpath = v.fullpath
				loveframes.skins.available[name].images[filename .. "." .. extension] = love.graphics.newImage(fullpath)
			end
		end
	end
	
end
