-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require dependencies
local lure = require(BASE_PATH..'init')

--
-- Define Class
--
local XMLHttpRequest = lure.lib.upperclass:define("XMLHttpRequest")

--
-- Returns a list of active xmlHttpRequst objects
--
property : activeRequests {
    {};
    get='public';
    set='private';
    type='table';
}

--
-- Returns the socket.http module
--
property : sockethttp {
    require('socket.http');
    get='public';
    set='private';
    type='any';
}

--
-- Returns the socket.mime module
--
property : mime {
    require('mime');
    get='public';
    set='private';
    type='any';
}

--
-- Returns the socket.url module
--
property : socketurl {
    require('socket.url');
    get='public';
    set='private';
    type='any';
}

--
-- Returns http params
--
property : httpParams {
    nil;
    get='private';
    set='private';
    type='table';
}

--
-- Returns ltn12
--
property : ltn12 {
    require('ltn12');
    get='public';
    set='private';
    type='any';
}

--
-- Returns this ID
--
property : id {
    nil;
    get='public';
    set='private';
    type='string';
}

--
-- Returns the XmlHTTPRequest Thread Object
--
property : requestThread {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Returns the XMLHTTPRequest Thread ID
--
property : requestThreadID {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Gets or Sets the onReadyStateChange callback
--
property : onreadystatechange {
    function() end;
    get='public';
    set='public';
    type='any';
}

--
-- Returns the readystate
--
property : readystate {
    0;
    get='public';
    set='private';
    type='number';
}

--
-- Returns the response text
--
property : responseText {
    nil;
    get='public';
    set='private';
    type='string';
}

--
-- Returns the response xml
--
property : responseXML {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Returns the status
--
property : status {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Returns the status text
--
property : statusText {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Returns if request is async
--
property : async {
    false;
    get='public';
    set='private';
    type='boolean';
}

--
-- Returns the timeout
--
property : timeout {
    10;
    get='public';
    set='public';
    type='number';
}

--
-- Cancels the current request
--
function public:abort()
    error("Function Not Implimented")
end

--
-- Returns header information
--
function public:getAllResponseHeaders()
    error("Function Not Implimented")
end

--
-- Specifies the type of request, the URL, if the request should be handled asynchronously or not, and other optional attributes of a request
--
-- method: the type of request: GET or POST
-- url: the location of the file on the server
-- async: true (asynchronous) or false (synchronous)
--
function public:open(METHOD, URL, ASYNC, USERNAME, PASSWORD)
    error("Function Not IMplimented")
end

--
-- send(string) Sends the request off to the server.
-- string: Only used for POST requests
--
function public:send(string)
    error("Function Not Implimented")
end

--
-- Adds a label/value pair to the header to be sent
--
function public:setRequestHeader()
    error("Function Not Implimented")
end

--
-- Update loop
--
function public:update(DT)
    for a=1, #self.activeRequests do
    end
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(XMLHttpRequest)