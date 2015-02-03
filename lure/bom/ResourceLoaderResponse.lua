-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define Class
--
local ResourceLoaderResponse = lure.lib.upperclass:define("ResourceLoaderResponse")

--
-- Holds the resource error html content
--
property : content {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Holds the resource response code
--
property : code {
    0;
    get='public';
    set='private';
    type='number';
}

--
-- Holds the resource response success 
--
property : result {
    true;
    get='public';
    set='private';
    type='boolean';
}

--
-- Holds the resource response message
--
property : message {
    nil;
    get='public';
    set='private';
    type='string';
}

--
-- Class Constructor
--
function private:__construct(RESULT, CODE, CONTENT, MESSAGE)
    self.result = RESULT
    self.code = CODE
    self.content = CONTENT
    self.message = MESSAGE
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(ResourceLoaderResponse)