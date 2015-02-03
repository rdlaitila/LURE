-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define Class
--
local Navigator = lure.lib.upperclass:define("LURENavigator")

--
-- Returns the code name of the browser
--
property : appCodeName {
    "LURE";
    get='public';
    set='private';
}

--
-- Returns the name of the browser
--
property : appName {
    "Browser";
    get='public';
    set='private';
}

--
-- Returns the version information of the browser
--
property : appVersion {
    "0.0.0";
    get='public';
    set='private';
}

--
-- Determines whether cookies are enabled in the browser
--
property : cookieEnabled {
    false;
    get='public';
    set='private';
}

--
-- Returns a Geolocation object that can be used to locate the user's position
--
property : geolocation {
    nil;
    get='public';
    set='nobody';
}

--
-- Returns the language of the browser
--
property : language {
    "en-us";
    get='public';
    set='private';
}

--
-- Determines whether the browser is online
--
property : onLine {
    false;
    get='public';
    set='private';
}

--
-- Returns for which platform the browser is compiled
--
property : platform {
    "Lua";
    get='public';
    set='private';
}

--
-- Returns the engine name of the browser
--
property : product {
    "LURE";
    get='public';
    set='private';
}

--
-- Returns the user-agent header sent by the browser to the server
--
property : userAgent {
    "LURE UserAgent";
    get='public';
    set='private';
}

--
-- Class Constructor
--
function private:__construct()
end

--
-- Specifies whether or not the browser has Java enabled
--
function public:javaEnabled()
    return false
end

-- 
-- Compile Class
--
return lure.lib.upperclass:compile(Navigator)