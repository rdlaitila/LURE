--===================================================================
-- LOCAL PROPERTIES                                                 =
--===================================================================	
local threadId			= nil
---------------------------------------------------------------------
local socketTImeout		= 10
---------------------------------------------------------------------
local httpRequest 		= require("socket.http")
---------------------------------------------------------------------
local httpMime			= require("mime")
---------------------------------------------------------------------
local ltn12 			= require("ltn12")
---------------------------------------------------------------------
local httpResponseBody 	= {}
---------------------------------------------------------------------
local httpResponseText 	= ""
---------------------------------------------------------------------
local httpParams 		= {}
---------------------------------------------------------------------
local requestDebug		= false
---------------------------------------------------------------------

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function waitForInstructions()
	--set message vars
	local threadIdMsg		= love.thread.getThread():receive("threadId")
	local socketTimeoutMsg	= love.thread.getThread():receive("socketTimeout")
	local httpParamMsg 		= love.thread.getThread():receive("httpParams")	
	
	-- receive thread id
	if threadIdMsg ~= nil then
		threadId = threadIdMsg
		-- DEBUG CODE
		if requestDebug == true then
			print(" ")
			print("---REQUEST THREAD ID--")
			print("threadId: "..threadId)
			print(" ")
		end
	end
	
	-- receive socket timeout
	if socketTimeoutMsg ~= nil then
		socketTimeout = tonumber(socketTimeoutMsg)		
		-- DEBUG CODE
		if requestDebug == true then
			print("---REQUEST TIMEOUT----")
			print("timeout: "..socketTimeout)
			print(" ")
		end
	end
	
	-- receive request params
	if httpParamMsg ~= nil and threadIdMsg ~= nil then
		httpParams = TSerial.unpack(httpParamMsg)
		
		-- DEBUG CODE
		if requestDebug == true then
			print("---REQUEST PARAMS-----")
			for k,v in pairs(httpParams) do
				if k ~= "headers" then
					print(k .. ": " .. tostring(httpParams[k]))
				end
			end
			print(" ")
			print("---REQUEST HEADERS----")
			for k,v in pairs(httpParams) do
				--print(k .. ": " .. tostring(httpParams[k]))
				if k == "headers" then
					for k2,v2 in pairs(httpParams[k]) do
						print("header: ["..tostring(k2).."] = "..tostring(v2))
					end
				end
			end
			print("     ")
		end
			
		sendRequest()		
	else
		waitForInstructions()
	end	
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function sendRequest()

	--local mysocket = require("socket.http")
	httpRequest.TIMEOUT = socketTimeout
	
	
	
	-- send request:
	local result  = 
	{
		httpRequest.request
		{
			method 		= httpParams.method,
			url			= httpParams.url,
			headers		= httpParams.headers,
			source		= ltn12.source.string(httpParams.body),
			sink		= ltn12.sink.table(httpResponseBody),
			redirect	= true
		}
	}	
	
	-- compile responseText
	for k,v in ipairs(httpResponseBody) do
		httpResponseText = httpResponseText .. tostring(v)
	end
		
	-- insert responseText in to result table
	table.insert(result, httpResponseText)
	
	-- DEBUG CODE
	if requestDebug == true then
		print("---RESPONSE HEADERS---")
		for k, v in pairs(result) do
			if type(result[k]) == "table" then
				for k2, v2 in pairs(result[k]) do
					local tbl = result[k]
					print("header: " .. "["..tostring(k2).."] = ".. tbl[k2])
				end
			end		
		end
		print(" ")
		print("---RESPONSE PARAMS---")
		print("readyState: ".. tostring(result[1]) )
		print("statusCode: ".. tostring(result[2]) )
		print("statusText: ".. tostring(result[4]) )
		print("responseText: " .. httpResponseText )		
		print("---------------------")
		
	end
	
	-- send results back to main thread
	love.thread.getThread("main"):send(threadId.."_response", TSerial.pack(result))
	
	--love.thread.getThread().kill()
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

-- TSerial v1.23, a simple table serializer which turns tables into Lua script
-- by Taehl (SelfMadeSpirit@gmail.com)

-- Usage: table = TSerial.unpack( TSerial.pack(table) )
TSerial = {}
function TSerial.pack(t)
	assert(type(t) == "table", "Can only TSerial.pack tables.")
	local s = "{"
	for k, v in pairs(t) do
		local tk, tv = type(k), type(v)
		if tk == "boolean" then k = k and "[true]" or "[false]"
		elseif tk == "string" then if string.find(k, "[%c%p%s]") then k = '["'..k..'"]' end
		elseif tk == "number" then k = "["..k.."]"
		elseif tk == "table" then k = "["..TSerial.pack(k).."]"
		else error("Attempted to Tserialize a table with an invalid key: "..tostring(k))
		end
		if tv == "boolean" then v = v and "true" or "false"
		elseif tv == "string" then v = string.format("%q", v)
		elseif tv == "number" then	-- no change needed
		elseif tv == "table" then v = TSerial.pack(v)
		else error("Attempted to Tserialize a table with an invalid value: "..tostring(v))
		end
		s = s..k.."="..v..","
	end
	return s.."}"
end

function TSerial.unpack(s)
	assert(type(s) == "string", "Can only TSerial.unpack strings.")
	assert(loadstring("TSerial.table="..s))()
	local t = TSerial.table
	TSerial.table = nil
	return t
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

waitForInstructions()