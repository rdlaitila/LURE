local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define Class
--
local class = lure.lib.upperclass:define("ResourceLoader")

--
-- Returns the base path to lure
--
class.private : basePath {
    default=select('1', ...):match(".-lure%.");
    type='string';
}

--
-- Returns a table of resource loader threads
--
class.public : threads {
    setter='private';
    type='table';
}

--
-- Class Constructor
--
function class.public:init()
    self.threads = {}
end

--
-- Auto loads a resource
--
function class.public:load(URI, CALLBACK)
    lure.lib.upperclass:expect(URI):type('string'):throw()
    
    -- Create a new thread
    local threadId = lure.lib.utils:uuid()
    table.insert(self.threads, {
        id          = threadId;
        thread      = love.thread.newThread(self.basePath:gsub("%.", "/")..'bom/ResourceLoaderThread.lua');
        callback    = CALLBACK;        
        channel     = love.thread.getChannel(threadId);
    })

    -- Start the thread
    self.threads[#self.threads].thread:start(self.basePath, self.threads[#self.threads].id)
    
    if CALLBACK == nil then
        -- Supply the thread with the URI
        self.threads[#self.threads].channel:supply(URI)
        
        -- Wait for thread if no callback supplied
        local response = self.threads[#self.threads].channel:demand()
        
        -- Remove the thread from our table
        table.remove(self.threads, #self.threads)
        
        -- Return a resource response
        return lure.bom.ResourceLoaderResponse(response.result, response.code, response.content, response.message)
    else
        -- Push th thread with the URI
        self.threads[#self.threads].channel:supply(URI)
    end
end

--
-- Update
--
function class.public:update(DT)
    for a=1, #self.threads do
        -- Get channel data, if any
        local response = self.threads[a].channel:pop()
        
        -- Ensure our response is not null
        if response ~= nil then
            -- Create resource response
            response = lure.bom.ResourceLoaderResponse(response.result, response.code, response.content, response.message)
            
            -- Call callback
            self.threads[a].callback(response)
            
            -- Remove thread from list
            table.remove(self.threads, a)
            
            -- Break from loop
            break
        end
    end
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(class)