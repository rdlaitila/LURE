-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define Class
--
local History = lure.lib.upperclass:define("BOMHistory")

--
-- Holds reference to the parent browser object
--
property : browserObject {
    nil;
    get='private';
    set='private';
    type='any';
}

--
-- Holds a list of history items
--
property : items {
    nil;
    get='public';
    set='public';
}

--
-- HNumber of history items
--
property : length {
    0;
    get='public';
    set='private';
}

--
-- Class Constructor
--
function private:__construct(BROWSER_OBJECT)
    -- Set reference to browser object
    self.browserObject = BROWSER_OBJECT
    
    -- Create a new history item table
    self.items = {}
end

--
-- Loads the previous URL in the history list
--
function public:back()
    error("Function Not Yet Implimented")
end

--
-- Loads the next URL in the history list
--
function public:forward()
    error("Function Not Yet Implimented")
end

--
-- Loads a specific URL from the history list
--
function public:go(INDEX)
    error("Function Not Yet Implimented")
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(History)