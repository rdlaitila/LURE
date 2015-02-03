lure.dom.XMLHttpRequest = {}

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

lure.dom.XMLHttpRequest.activeRequests = {}

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.XMLHttpRequest.new()
	local self = {}	
	
	--===================================================================
	-- LOCAL PROPERTIES                                                 =
	--===================================================================	
	local httpRequest 		= require("socket.http")
	---------------------------------------------------------------------
	local httpMime			= require("mime")
	---------------------------------------------------------------------
	local httpUrl			= require("socket.url")
	---------------------------------------------------------------------
	local httpParams 		= {}	
	---------------------------------------------------------------------
	httpParams.headers		= {}	
	---------------------------------------------------------------------
	local ltn12 			= require("ltn12")
	---------------------------------------------------------------------
	
	--===================================================================
	-- PROPERTIES                                                       =	
	--===================================================================
	self.id					= lure.UUID()
	---------------------------------------------------------------------
	self.requestThread		= nil  -- will hold the request thread
	---------------------------------------------------------------------
	self.requestThreadId	= "XMLHttpRequestThread_"..self.id
	---------------------------------------------------------------------
	self.onreadystatechange = function() end
	---------------------------------------------------------------------
	self.readyState			= 0
	---------------------------------------------------------------------
	self.responseText		= ""
	---------------------------------------------------------------------
	self.responseXML		= nil
	---------------------------------------------------------------------
	self.status				= nil
	---------------------------------------------------------------------
	self.statusText			= nil
	---------------------------------------------------------------------	
	self.isAsync			= false
	---------------------------------------------------------------------
	self.timeout			= 10
	---------------------------------------------------------------------
	
	--====================================================================
	-- METHODS	                                                         =	
	--====================================================================
	self.abort = function()
	end
	---------------------------------------------------------------------
	self.getAllResponseHeaders = function()
	end
	---------------------------------------------------------------------
	self.getResponseHeader = function()
	end
	---------------------------------------------------------------------
	self.open = function(pMethod, pUrl, pAsync, pUsername, pPassword)	
		self.isAsync 		= pAsync or false
		httpParams.method 	= pMethod or "GET"
		httpParams.url		= pUrl
		
		if pUsername ~= nil and type(pUsername) == "string" then
			local username = pUsername
			local password = pPassword
			if pPassword == nil then password = "" end
			self.setRequestHeader("authentication", "basic " .. (mime.b64(username..":"..password)))
		end			
	end	
	---------------------------------------------------------------------
	self.send = function(pString)		
		httpParams.body = pString or ""	
		
		self.requestThread = love.thread.newThread(self.requestThreadId, lure.require_path .. "dom//objects//lure_dom_XMLHttpRequest//XMLHttpRequest_thread")		
		self.requestThread:start()
		self.requestThread:send("threadId", self.requestThreadId)
		self.requestThread:send("socketTimeout", tostring(self.timeout))
		self.requestThread:send("httpParams", lure.tserial.pack(httpParams))
		
		if self.isAsync == false then
			--if not async, wait for thread to finish.
			self.requestThread:wait()			
		end		
	end
	---------------------------------------------------------------------
	self.setRequestHeader = function(pName, pValue)
		httpParams.headers[pName] = pValue
	end
	---------------------------------------------------------------------		
	self.receiveThreadResponse = function()			
		-- look for async thread response message
		local result = love.thread.getThread("main"):receive(self.requestThreadId.."_response")
		if result ~= nil then		
			--unpack message
			result = lure.tserial.unpack(result)			
			-- set readyState			
			self.readyState = 4
			--set status			
			self.status = result[2]			
			--set statusText			
			self.statusText = result[4]
			--set responseText			
			self.responseText = result[5]
			
			--remove request from activeRequests
			local index = 1
			for k, v in ipairs(lure.dom.XMLHttpRequest.activeRequests) do
				if lure.dom.XMLHttpRequest.activeRequests[k].id == self.id then
					table.remove(lure.dom.XMLHttpRequest.activeRequests, index)
				end
				index = index + 1
			end
			
			--kill thread
			self.requestThread:kill()
		
			--finally call onReadyStateChange callback
			self.onReadyStateChange()
		end		
	end
	---------------------------------------------------------------------		
	
	table.insert(lure.dom.XMLHttpRequest.activeRequests, self)	
	return lure.dom.XMLHttpRequest.activeRequests[table.getn(lure.dom.XMLHttpRequest.activeRequests)]
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function lure.dom.XMLHttpRequest.checkRequests()
	XHR = lure.dom.XMLHttpRequest
	for k, v in ipairs(XHR.activeRequests) do
		if XHR.activeRequests[k] ~= nil then
			XHR.activeRequests[k].receiveThreadResponse()						
		end
	end
end

-- ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::