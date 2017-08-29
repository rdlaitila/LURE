local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define Class
--
local class = lure.lib.upperclass:define("XMLHttpRequest")

--
-- Returns a list of active xmlHttpRequst objects
--
class.public : activeRequests {
    default={};
    setter='private';
    type='table';
}

--
-- Returns the socket.http module
--
class.public : sockethttp {
    default=require('socket.http');
    setter='private';
    type='any';
}

--
-- Returns the socket.mime module
--
class.public : mime {
    default=require('mime');
    setter='private';
    type='any';
}

--
-- Returns the socket.url module
--
class.public : socketurl {
    default=require('socket.url');
    setter='private';
    type='any';
}

--
-- Returns http params
--
class.public : httpParams {
    setter='private';
    type='table';
}

--
-- Returns ltn12
--
class.public : ltn12 {
    default=require('ltn12');
    setter='private';
    type='any';
}

--
-- Returns this ID
--
class.public : id {
    setter='private';
    type='string';
}

--
-- Returns the XmlHTTPRequest Thread Object
--
class.public : requestThread {
    setter='private';
    type='any';
}

--
-- Returns the XMLHTTPRequest Thread ID
--
class.public : requestThreadID {
    setter='private';
    type='any';
}

--
-- Gets or Sets the onReadyStateChange callback
--
class.public : onreadystatechange {
    default=function() end;
    type='function';
    nullable=true;
}

--
-- Returns the readystate
--
class.public : readystate {
    default=0;
    setter='private';
    type='number';
}

--
-- Returns the response text
--
class.public : responseText {
    setter='private';
    type='string';
}

--
-- Returns the response xml
--
class.public : responseXML {
    setter='private';
    type='string';
}

--
-- Returns the status
--
class.public : status {
    setter='private';
    type='any';
}

--
-- Returns the status text
--
class.public : statusText {
    setter='private';
    type='string';
}

--
-- Returns if request is async
--
class.public : async {
    default=false;
    setter='private';
    type='boolean';
}

--
-- Returns the timeout
--
class.public : timeout {
    default=10;
    type='number';
}

--
-- Cancels the current request
--
function class.public:abort()
    error("Function Not Implimented")
end

--
-- Returns header information
--
function class.public:getAllResponseHeaders()
    error("Function Not Implimented")
end

--
-- Specifies the type of request, the URL, if the request should be handled asynchronously or not, and other optional attributes of a request
--
-- method: the type of request: GET or POST
-- url: the location of the file on the server
-- async: true (asynchronous) or false (synchronous)
--
function class.public:open(METHOD, URL, ASYNC, USERNAME, PASSWORD)
    error("Function Not IMplimented")
end

--
-- send(string) Sends the request off to the server.
-- string: Only used for POST requests
--
function class.public:send(string)
    error("Function Not Implimented")
end

--
-- Adds a label/value pair to the header to be sent
--
function class.public:setRequestHeader()
    error("Function Not Implimented")
end

--
-- Update loop
--
function class.public:update(DT)
    for a=1, #self.activeRequests do
    end
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(class)