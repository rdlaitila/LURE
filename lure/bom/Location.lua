-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define Class
--
local Location = lure.lib.upperclass:define("BOMLocation")

--
-- Sets or returns the anchor part (#) of a URL
--
property : hash {
    nil;
    get='public';
    set='private';
    type='string';
}

--
-- Sets or returns the hostname and port number of a URL
--
property : host {
    nil;
    get='public';
    set='public';
    type='string';
}

--
-- Sets or returns the hostname of a URL
--
property : hostname {
    nil;
    get='public';
    set='public';
    type='string';
}

--
-- Sets or returns the entire URL
--
property : href {
    nil;
    get='public';
    set='public';
    type='string';
}

--
-- Returns the protocol, hostname and port number of a URL
--
property : origin {
    nil;
    get='public';
    set='private';
    type='string';
}

--
-- Sets or returns the path name of a URL
--
property : pathname {
    nil;
    get='public';
    set='private';
    type='string';
}

--
-- Sets or returns the port number of a URL
--
property : port {
    0;
    get='public';
    set='public';
    type='number';
}

--
-- Sets or returns the protocol of a URL
--
property : protocol {
    nil;
    get='public';
    set='public';
    type='string';
}

--
-- Sets or returns the querystring part of a URL
--
property : search {
    nil;
    get='public';
    set='public';
    type='string';
}

--
-- Loads a new document
--
function public:assign()
    error("Function Not Yet Implimented")
end

--
-- Reloads the current document
--
function public:reload() 	
    error("Function Not Yet Implimented")
end

--
-- Replaces the current document with a new one
--
function public:replace() 	
    error("Function Not Yet Implimented")
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(Location)