-- Filename: lure
-- Author: Regan Laitila
-- Date: N/A
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
lure = {} -- :D
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.init()	

	-- SET COMMON CONFIGS
	lure.require_path 		= "lure//"
	lure.use_short_objrefs	= true
	lure.debug 				= false
	
	-- BASE DEPENDENCIES
	require(lure.require_path .. "core//ns_lure_core")
	require(lure.require_path .. "dom//ns_lure_dom")	
	require(lure.require_path .. "rom//ns_lure_rom")	
			
	-- CREATE INITIAL OBJECTS	
	lure.window 	= lure.core.windowObj.new()
	lure.layers		= {}	
	
	-- SET SHORT OBJECT REFERENCES
	if lure.use_short_objrefs == true then
		window 			= lure.window
		layers			= lure.layers
		document 		= lure.document		
		alert 			= lure.window.alert
		setTimeout 		= lure.window.setTimeout
		setInterval 	= lure.window.setInterval
		clearTimeout	= lure.window.clearTimeout
		clearInterval	= lure.window.clearInterval
		
		XMLHttpRequest 	= lure.dom.XMLHttpRequest
		DOMParser		= lure.dom.DOMParser		
	end
	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.load(pObj)
	--create new lure layer
	local newLayer = lure.core.layers.new()
	
	--pass to layer load() method
	if type(pObj) == "string" then
		returnDocument = newLayer.load(pObj)		
	end

	--add new layer to lure.layers
	table.insert(lure.layers, newLayer)
	
	--return new document to caller
	return returnDocument
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.update(dt)		
	lure.game_time = dt	

	--Keep an eye on active XMLHttpRequests	
	lure.dom.XMLHttpRequest.checkRequests(lure.game_time)
	
	--update lure.window
	lure.window.update(lure.game_time)
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.draw()
	--loop through layers and call draw
	for k1, v1 in ipairs(lure.layers) do
		lure.layers[k1].viewport.draw()
	end
	
	--draw lure window
	lure.window.draw()
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.keypressed(pKey, pUnicode)
	love.event.push("keypressed", pKey)
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.throw(pErrorType, pErrorText)
	local errorTypes = {}
	errorTypes[1] = "INFORMATION"
	errorTypes[2] = "WARNING"
	errorTypes[3] = "ERROR"
	errorTypes[4] = "FATAL ERROR"
	
	print("LURE::"..errorTypes[pErrorType] .. "::"..pErrorText)
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.sleep(n)  -- seconds
	local clock = os.clock
	local t0 = clock()
	while clock() - t0 <= n do end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.trim(s)
	if s ~= nil then
		return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
	end	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.hex2rgb(hex)
  hex = hex:gsub("#","")
  return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
-- tserial v1.23, a simple table serializer which turns tables into Lua script
-- by Taehl (SelfMadeSpirit@gmail.com)

-- Usage: table = lure.tserial.unpack( lure.tserial.pack(table) )
lure.tserial = {}
function lure.tserial.pack(t)
	assert(type(t) == "table", "Can only tserial.pack tables.")
	local s = "{"
	for k, v in pairs(t) do
		local tk, tv = type(k), type(v)
		if tk == "boolean" then k = k and "[true]" or "[false]"
		elseif tk == "string" then if string.find(k, "[%c%p%s]") then k = '["'..k..'"]' end
		elseif tk == "number" then k = "["..k.."]"
		elseif tk == "table" then k = "["..lure.tserial.pack(k).."]"
		else error("Attempted to Tserialize a table with an invalid key: "..tostring(k))
		end
		if tv == "boolean" then v = v and "true" or "false"
		elseif tv == "string" then v = string.format("%q", v)
		elseif tv == "number" then	-- no change needed
		elseif tv == "table" then v = lure.tserial.pack(v)
		else error("Attempted to Tserialize a table with an invalid value: "..tostring(v))
		end
		s = s..k.."="..v..","
	end
	return s.."}"
end

function lure.tserial.unpack(s)
	assert(type(s) == "string", "Can only tserial.unpack strings.")
	assert(loadstring("lure.tserial.table="..s))()
	local t = lure.tserial.table
	lure.tserial.table = nil
	return t
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
module(..., package.seeall);
 
pcall(require,"BinDecHex")
local Hex2Dec, BMOr, BMAnd, Dec2Hex
if(BinDecHex)then
	Hex2Dec, BMOr, BMAnd, Dec2Hex = BinDecHex.Hex2Dec, BinDecHex.BMOr, BinDecHex.BMAnd, BinDecHex.Dec2Hex
end 
 
--- Returns a UUID/GUID in string format - this is a "random"-UUID/GUID at best or at least a fancy random string which looks like a UUID/GUID. - will use BinDecHex module if present to adhere to proper UUID/GUID format according to RFC4122v4.
--@Usage after require("UUID"), then UUID.UUID() will return a 36-character string with a new GUID/UUID.
--@Return String - new 36 character UUID/GUID-complient format according to RFC4122v4.
function lure.UUID()
	local chars = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"}
	local uuid = {[9]="-",[14]="-",[15]="4",[19]="-",[24]="-"}
	local r, index
	for i = 1,36 do
		if(uuid[i]==nil)then
			-- r = 0 | Math.random()*16;
			r = math.random (16)
			if(i == 20 and BinDecHex)then 
				-- (r & 0x3) | 0x8
				index = tonumber(Hex2Dec(BMOr(BMAnd(Dec2Hex(r), Dec2Hex(3)), Dec2Hex(8))))
				if(index < 1 or index > 16)then 
					print("WARNING Index-19:",index)
					return UUID() -- should never happen - just try again if it does ;-)
				end
			else
				index = r
			end
			uuid[i] = chars[index]
		end
	end
	return table.concat(uuid)
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.literalize(str)
    text, occur =  str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c)		
		return "%" .. c 
	end)
	return lure.trim(text)
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.printf(pData, pX, pY, pWrap)
	local currFont 	= love.graphics.getFont()
	local currLeft	= pX
	local currTop	= pY	
	local lineWidth = 0
	local cBuffer	= ""
	local cLines	= {}
	
	if currFont == nil then
		currFont = love.graphics.newFont(15)
		love.graphics.setFont( currFont )
	end		
	
	for a=1, pData:len() do
		hSize = currFont:getWidth(pData:sub(a,a))
		vSize = currFont:getHeight()				
		love.graphics.print(pData:sub(a, a), currLeft, currTop)
		if lineWidth == 0 and pData:sub(a, a) == " " then
		else
			currLeft = currLeft + hSize
		end
		lineWidth = lineWidth + hSize
		if lineWidth >= pWrap then
			currLeft = pX
			currTop = currTop + vSize + currFont:getLineHeight()
			lineWidth = 0
		end
	end		
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.convertPXtoEM(pSrcSize, pCompSize)
	local src = pSrcSize
	local comp = pCompSize
	return src / comp
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.convertEMtoPX(pSrcEm, pCompPx)
	local src = pSrcEm
	local comp = pCompPx
	
	return src * comp	
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
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
   return t
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
function lure.trace (event, line)
	local a = debug.getinfo(2).name
	local b = debug.getinfo(2).source
	print(tostring(a) .. ":::" .. tostring(b))
	lure.sleep(.01)
end
-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
lure.init()
