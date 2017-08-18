local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define Class
--
local Browser = lure.lib.upperclass:define("BOMBrowser")

--
-- Holds a list of window objects this browser controls
--
property : windows {
    nil;
    get='public';
    set='private';
    type='table';
}

--
-- Holds the browser's Navigator Object
--
property : navigator {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Holds the browser's History Object
--
property : history {
    nil;
    get='public';
    set='private';
    type='any';
}

--
-- Class Constructor
--
function private:__construct()
    -- Create new empty table to hold our windows
    self.windows = {}
    
    -- Generate Navigator Object
    self.navigator = lure.bom.Navigator()
    
    -- Generate History Object
    self.history = lure.bom.History(self)
end

--
-- draw loop
--
function public:draw()
    -- Call draw on all child windows
    for a=1, #self.windows do
        self.windows[a]:draw()
    end
end

--
-- update loop
--
function public:update(DT)
    -- Call update on all child windows
    for a=1, #self.windows do
        self.windows[a]:update(DT)
    end
end

--
-- LOVE Keypressed Callback
--
function public:keypressed(KEY, IS_REPEAT)
end

--
-- LOVE keyreleased Callback
--
function public:keyreleased(KEY)
end

--
-- LOVE mouspressed Callback
--
function public:mousepressed(X, Y, BUTTON)
end

--
-- LOVE mousereleased Callback
--
function public:mousereleased(X, Y, BUTTON)
end

--
-- LOVE textinput Callback
--
function public:textinput(STRING)
end

--
-- Add a progress listener to the browser which will monitor loaded documents.
--
function public:addProgressListener()
    error("Fuction Not Implimneted")
end

--
-- Go back one page in the history. 
--
function public:goBack()
    error("Fuction Not Implimneted")
end

--
-- Go forward one page in the history. 
---
function public:goForward()
    error("Function Not Implimented")
end

--
-- Load the user's home page into the browser. 
--
function public:goHome()
    error("Function Not Implimented")
end

--
-- Navigate to the page in the history with the given index. Use a positive number to go forward and a negative number to go back.
--
function public:gotoIndex(INDEX)
    error("Function Not Implimented")
end

--
-- Load a URL into the document, with the given referrer and character set.
--
function public:loadURI(URI, REFFERER, CHARSET)
    -- Insert the new window object into our list of windows
    table.insert(self.windows, lure.bom.Window())
    
    --Invoke windiow open() method to load document
    self.windows[#self.windows]:open(URI)
    
    -- Return our newly created Window
    return newwindow
end

--
-- Load a URL into the document, with the specified load flags, the given referrer, character set, and POST data. In addition to the flags allowed for the reloadWithFlags method, the following flags are also valid:
--
--    LOAD_FLAGS_IS_REFRESH: This flag is used when the URL is loaded because of a meta tag refresh or redirect.
--    LOAD_FLAGS_IS_LINK: This flag is used when the URL is loaded because a user clicked on a link. The HTTP Referer header is set accordingly.
--    LOAD_FLAGS_BYPASS_HISTORY: Do not add the URL to the session history.
--    LOAD_FLAGS_REPLACE_HISTORY: Replace the current URL in the session history with a new one. This flag might be used for a redirect.
--
function public:loadURIWithFlags()
    error("Function Not Implimented")
end

--
-- Reloads the document in the browser element on which you call this method.
--
function public:reload()
    error("Function Not Implimented")
end

--
--Reloads the document in the browser with the given load flags. The flags listed below may be used, which are all constants of the webNavigation property (or the nsIWebNavigation interface). You may combine flags using a or symbol ( | ).
--
--    LOAD_FLAGS_NONE: No special flags. The document is loaded normally.
--    LOAD_FLAGS_BYPASS_CACHE: Reload the page, ignoring if it is already in the cache. This is the flag used when the reload button is pressed while the Shift key is held down.
--    LOAD_FLAGS_BYPASS_PROXY: Reload the page, ignoring the proxy server.
--    LOAD_FLAGS_CHARSET_CHANGE: This flag is used if the document needs to be reloaded because the character set changed.
--
function public:reloadWithFlags()
    error("Function Not Implimented")
end

--
-- Remove a nsIWebProgressListener from the browser.
--
function public:removeProgressListener()
    error("Function Not Implimented")
end

--
-- Equivalent to pressing the Stop button, this method stops the currently loading document.
--
function public:stop()
    error("Function Not Implimented")
end

--
-- Swaps the content, history and current state of this browser with another browser. During the swap, pagehide and pageshow events are fired on both browsers. This method can be used to move browser between windows or tear off a browser into a new window.
--
function public:swapDocShells()
    error("Function Not Implimented")
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(Browser)