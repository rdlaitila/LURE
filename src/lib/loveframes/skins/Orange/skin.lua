--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

-- get the current require path
local path = string.sub(..., 1, string.len(...) - string.len(".skins.Orange.skin"))
local loveframes = require(path .. ".libraries.common")

-- skin table
local skin = {}

-- skin info (you always need this in a skin)
skin.name = "Orange"
skin.author = "Nikolai Resokav"
skin.version = "1.0"
skin.base = "Blue"

-- controls 
skin.controls = {}

-- multichoicerow
skin.controls.multichoicerow_body_hover_color       = {255, 153, 0, 255}

-- slider
skin.controls.slider_bar_outline_color              = {220, 220, 220, 255}

-- checkbox
skin.controls.checkbox_check_color                  = {255, 153, 0, 255}

-- radiobutton
skin.controls.radiobutton_body_color                = {255, 255, 255, 255}
skin.controls.radiobutton_check_color               = {255, 153, 0, 255}
skin.controls.radiobutton_inner_border_color        = {204, 122, 0, 255}
skin.controls.radiobutton_text_font                 = smallfont


-- columnlistrow
skin.controls.columnlistrow_body_selected_color     = {255, 153, 0, 255}
skin.controls.columnlistrow_body_hover_color        = {255, 173, 51, 255}

-- menuoption
skin.controls.menuoption_body_hover_color           = {255, 153, 0, 255}

-- register the skin
loveframes.skins.Register(skin)
