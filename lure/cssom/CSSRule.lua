local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define Class
--
local CSSRule = lure.lib.upperclass:define('CSSRule')

--
-- const STYLE_RULE
--
property : STYLE_RULE {
    1;
    get='public';
    set='nobody';
    type='number';
}

--
-- const CHARSET_RULE
--
property : CHARSET_RULE {
    2;
    get='public';
    set='nobody';
    type='number';
}

--
-- const IMPORT_RULE
--
property : IMPORT_RULE {
    3;
    get='public';
    set='nobody';
    type='number';
}

--
-- const MEDIA_RULE
--
property : MEDIA_RULE {
    4;
    get='public';
    set='nobody';
    type='number';
}

--
-- const FONT_FACE_RULE
--
property : FONT_FACE_RULE {
    5;
    get='public';
    set='nobody';
    type='number';
}

--
-- const PAGE_RULE
--
property : PAGE_RULE {
    6;
    get='public';
    set='nobody';
    type='number';
}

--
-- const MARGIN_RULE
--
property : MARGIN_RULE {
    7;
    get='public';
    set='nobody';
    type='number';
}

--
-- const NAMESPACE_RULE
--
property : NAMESPACE_RULE {
    10;
    get='public';
    set='nobody';
    type='number';
}

--
-- One of the Type constants indicating the type of CSS rule.
--
property : type {
    1;
    get='public';
    set='protected';
    type='number';
}

--
-- Represents the textual representation of the rule, e.g. "h1,h2 { font-size: 16pt }"
--
property : cssText {
    "";
    get='public';
    set='protected';
    type='string';
}

--
-- Returns the containing rule, otherwise null. E.g. if this rule is a style rule inside 
-- an @media block, the parent rule would be that CSSMediaRule.
--
property : parentRule {
    nil;
    get='public';
    set='protected';
    type='any';
}

--
-- Returns the CSSStyleSheet object for the style sheet that contains this rule
--
property : parentStyleSheet {
    nil;
    get='public';
    set='protected';
    type='any';
}

--
-- Class Constructor
--
function private:__construct(CSS_TEXT, PARENT_RULE, PARENT_STYLESHEET, TYPE)
    self.type = TYPE
    self.cssText = CSS_TEXT
    self.parentStyleSheet = PARENT_STYLESHEET
    self.parentRule = PARENT_RULE
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(CSSRule)