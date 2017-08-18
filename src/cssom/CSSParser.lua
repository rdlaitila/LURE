local lure = require(select('1', ...):match(".-lure%.")..'init')

--
-- Define Class
--
local CSSParser = lure.lib.upperclass:define('CSSParser')

--
-- Retrieves a character from CSSParser.styleText at the specified index
--
function private:char(INDEX)
    self.styleText:sub(INDEX,INDEX)
end

--
-- Returns a CSSRule from input css text. This function expects the source CSS_TEXT 
-- only contains one rule definition
--
function public:ruleFromText(CSS_TEXT)
end

--
-- Returns a CSSStyleSheet from input css text. The source CSS_TEXT can contain one or 
-- more css rule definitions
--
function public:styleSheetFromText(CSS_TEXT)
    -- The CSSStyleSheet to return
    local stylesheet = lure.cssom.CSSStyleSheet()
    
    -- Holds our current position within CSS_TEXT
    local index = 1
	
    -- Holds the text for the current rule
    local ruleTextBuffer = ""
		
	--remove all comment text
	CSS_TEXT = string.gsub(CSS_TEXT, "/%*(.-)%*/", "")		
		
	while index <= CSS_TEXT:len() do
		if CSS_TEXT:sub(index,index) ~= "{" and CSS_TEXT:sub(index,index) ~= "}" then
			if parseSelector == true then
				selectorBuffer = selectorBuffer .. CSS_TEXT:sub(index,index)
			end
			if parseDeclaration ==  true then
				declarationBuffer = declarationBuffer .. CSS_TEXT:sub(index,index)
			end
		end
			
		if CSS_TEXT:sub(index,index) == "{" then
			parseSelector = false
			parseDeclaration = true			
		elseif CSS_TEXT:sub(index,index) == "}" then
			parseSelector = true
			parseDeclaration = false
			
			--remove tabs && newlines
			selectorBuffer = string.gsub(selectorBuffer, "[\t]", "")
			selectorBuffer = string.gsub(selectorBuffer, "[\r\n]", "")
			selectorBuffer = lure.lib.utils:trim(selectorBuffer)
			
			declarationBuffer = string.gsub(declarationBuffer, "[\t]", "")
			declarationBuffer = string.gsub(declarationBuffer, "[\r\n]", "")
			declarationBuffer = lure.lib.utils:trim(declarationBuffer)
			
			-- calculate it's specificity
			local specificity = lure.dom.css.computeCssRuleSpecificity( selectorBuffer )
						
			-- add thew new css rule
			local rule = stylesheet.addRule(selectorBuffer, declarationBuffer, pIndex, specificity)
			
			selectorBuffer = ""
			declarationBuffer = ""
		end
		index = index + 1
	end
    
    return stylesheet
end

--
-- Compile Class
--
return lure.lib.upperclass:compile(CSSParser)