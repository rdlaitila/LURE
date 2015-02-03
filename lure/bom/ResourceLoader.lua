-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define Class
--
local ResourceLoader = lure.lib.upperclass:define("ResourceLoader")

--
-- Auto loads a resource
--
function public:load(URI)
    local url = lure.lib.url.parse(URI)
    local content = nil
    
    for key, value in pairs(url) do
        print(key, value)
    end
    
    -- Invoke file load if URI is a file
    if url.scheme:lower() == "file" then
        content = self:loadFile(URI)
    end
    
    -- Invoke http load if URI is http
    if url.scheme:lower() == "http" then
        -- do http load
    end
    
    -- Invoke https load if URI is https
    if url.scheme:lower() == "https" then
        -- do https load
    end
    
    -- If we failed to load any content
    if content == nil then
        return lure.bom.ResourceLoaderResponse(
            false,
            0,
            nil,
            "Failed To Load Content From Resource URI: "
        )
    else
        return lure.bom.ResourceLoaderResponse(
            true,
            1,
            content,
            "Successfully Loaded Content From Resource URI: "..tostring(URI)
        )
    end
end

--
-- Loads a FILE Resource
--
function private:loadFile(URI)
    local url = lure.lib.url.parse(URI)
    local filepath = tostring(url.host)..tostring(url.path)
    local content, size = love.filesystem.read(filepath)
    
    return content
end

--
-- Loads a HTTP Resource
--
function public:loadHttp(URI)
    error("Function Not Implimented")
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(ResourceLoader)