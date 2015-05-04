-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define Class
--
local ResourceLoader = lure.lib.upperclass:define("ResourceLoader")

--
-- Returns a table of resource loader threads
--
property : threads {
    nil;
    get='public';
    set='private';
    type='table';
}

--
-- Class Constructor
--
function private:__construct()
    self.threads = {}
end

--
-- Auto loads a resource
--
function public:load(URI, CALLBACK)
    -- Create a new thread
    local threadId = lure.lib.utils:uuid()
    table.insert(self.threads, {
        id          = threadId;
        thread      = love.thread.newThread(BASE_PATH:gsub("%.", "/")..'bom/ResourceLoaderThread.lua');
        callback    = CALLBACK;        
        channel     = love.thread.getChannel(threadId);
    })

    -- Start the thread
    self.threads[#self.threads].thread:start(BASE_PATH, self.threads[#self.threads].id)
    
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
function public:update(DT)
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
return lure.lib.upperclass:compile(ResourceLoader)