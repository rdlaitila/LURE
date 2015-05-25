local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define Class
--
local CSSStyleSheet = lure.lib.upperclass:define('CSSStyleSheet', lure.cssom.StyleSheet)

--
-- Returns a CSSRuleList of the CSS rules in the style sheet.
--
property : cssRules {
    nil;
    get='public';
    set='protected';
    type='any';
}

--
-- If this style sheet is imported into the document using an @import rule, the 
-- ownerRule property will return that CSSImportRule, otherwise it returns null.
--
property : ownerRule {
    nil;
    get='public';
    set='protected';
    type='any';
}

--
-- Class Constructor
--
function private:__construct()
    self.cssRules = lure.cssom.CSSRuleList()
end

--
-- Deletes a rule from the style sheet.
--
function public:deleteRule()
    error("function not implimented")
end

--
-- Inserts a new style rule into the current style sheet.
--
function public:insertRule()
    error("function not implimented")
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(CSSStyleSheet)