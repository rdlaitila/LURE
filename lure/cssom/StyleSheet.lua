local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define Class
--
local Stylesheet = lure.lib.upperclass:define('Stylesheet')

--
-- Is a Boolean representing whether the current stylesheet has been applied or not.
--
property : disabled {
    false;
    get='public';
    set='public';
    type='boolean';
}

--
-- Returns a DOMString representing the location of the stylesheet.
--
property : href {
    "";
    get='public';
    set='protected';
    type='string';
}

--
-- Returns a MediaList representing the intended destination medium for style information.
--
property : media {
    nil;
    get='public';
    set='protected';
    type='any';
}

--
-- Returns a Node associating this style sheet with the current document
--
property : ownerNode {
    nil;
    get='public';
    set='protected';
    type='any';
}

--
-- Returns a StyleSheet including this one, if any; returns null if there aren't any.
--
property : parentStyleSheet {
    nil;
    get='public';
    set='protected';
    type='any';
}

--
-- Returns a DOMString representing the advisory title of the current style sheet.
--
property : title {
    "";
    get='public';
    set='protected';
    type='string';
}

--
-- Returns a DOMString representing the style sheet language for this style sheet. 
--
property : type {
    "text/css";
    get='public';
    set='nobody';
    type='string';
}

--
-- Compile Class
--
return lure.lib.upperclass:compile(Stylesheet)