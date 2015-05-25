require('love.thread')
require('love.filesystem')

local args = {...}

-- Obtain our base require path
local BASE_PATH = args[1]

-- Obtain our thread id
local THREAD_ID = args[2]

-- Require dependencies
local lure = require(BASE_PATH..'init')

-- Get our channel
local channel = love.thread.getChannel(THREAD_ID)

-- Wait for incoming URI
local uri = channel:demand()

-- Parse into url table
local url = lure.lib.url.parse(uri)

-- Holds our response data
local response = {}

-- Load the resource
if url.scheme == "file" then
    local filepath = url.host..url.path  
    
    if love.filesystem.exists(filepath) then        
        response.result = true
        response.code = 200
        response.content = love.filesystem.read(filepath)
        response.message = "Successfully loaded file URI: "..filepath
    else
        response.result = false
        response.code = 404
        response.content = nil
        response.message = "Failed to load file URI: "..filepath.. " file not found"
    end
end

-- Push Response
channel:supply(response)