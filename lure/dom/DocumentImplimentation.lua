local upperclass    = require(LIBXML_REQUIRE_PATH..'lib.upperclass')
local utils         = require(LIBXML_REQUIRE_PATH..'lib.utils')

-- 
-- Define class
--
local DocumentImplimentation = upperclass:define("DOMDocumentImplimentation")

--
-- Creates a new DOM Document object of the specified doctype 
--
function public:createDocument(NSURI, NAME, DOCTYPE)
    error("Method Not Yet Implimented")
end

--
-- Creates an empty DocumentType node
--
function public:createDocumentType(NAME, PUBID, SYSTEMID)
    error("Method Not Yet Implimented")
end

--
-- Returns an object which implements the APIs of the specified feature and version, if the is any
--
function public:getFeature(FEATURE, VERSION)
    error("Method Not Yet Implimented")
end

--
-- Checks whether the DOM implementation implements a specific feature and version
--
function public:hasFeature(FEATURE, VERSION)
    error("Method Not Yet Implimented")
end

--
-- Compile class
--
return upperclass:compile(DocumentImplimentation)