-- Obtain our base require path
local BASE_PATH = select('1', ...):match(".-lure%.")

-- Require our lure table
local lure = {}

-- Set lure version
lure.version = "0.1.0"

-- Require some core dependencies
lure.lib                = require(BASE_PATH..'lib.dynamicrequire')()
lure.lib.upperclass     = (BASE_PATH..'lib.upperclass')
lure.lib.loveframes     = (BASE_PATH..'lib.loveframes')
lure.lib.lovebird       = (BASE_PATH..'lib.lovebird')
lure.lib.DynamicRequire = (BASE_PATH..'lib.dynamicrequire')
lure.lib.url            = (BASE_PATH..'lib.url')
lure.lib.utils          = (BASE_PATH..'lib.utils')

-- Begin BOM DynamicRequire's
lure.bom                        = lure.lib.DynamicRequire()
lure.bom.Browser                = (BASE_PATH..'bom.Browser')
lure.bom.Window                 = (BASE_PATH..'bom.Window')
lure.bom.WindowUpdateEvent      = (BASE_PATH..'bom.WindowUpdateEvent')
lure.bom.Navigator              = (BASE_PATH..'bom.Navigator')
lure.bom.History                = (BASE_PATH..'bom.History')
lure.bom.Location               = (BASE_PATH..'bom.Location')
lure.bom.ResourceLoader         = (BASE_PATH..'bom.ResourceLoader')
lure.bom.ResourceLoaderResponse = (BASE_PATH..'bom.ResourceLoaderResponse')

-- Begin DOM DynamicRequire's
lure.dom                        = lure.lib.DynamicRequire()
lure.dom.Attribute              = (BASE_PATH..'dom.Attribute')
lure.dom.CDATA                  = (BASE_PATH..'dom.Cdata')
lure.dom.Comment                = (BASE_PATH..'dom.Comment')
lure.dom.Document               = (BASE_PATH..'dom.Document')
lure.dom.DocumentImplimentation = (BASE_PATH..'dom.DocumentImplimentation')
lure.dom.DocumentType           = (BASE_PATH..'dom.DocumentType')
lure.dom.DOMParser              = (BASE_PATH..'dom.DOMParser')
lure.dom.Element                = (BASE_PATH..'dom.Element')
lure.dom.Event                  = (BASE_PATH..'dom.Event')
lure.dom.EventListener          = (BASE_PATH..'dom.EventListener')
lure.dom.NamedNodeMap           = (BASE_PATH..'dom.NamedNodeMap')
lure.dom.Node                   = (BASE_PATH..'dom.Node')
lure.dom.NodeList               = (BASE_PATH..'dom.NodeList')
lure.dom.ProcessingInstruction  = (BASE_PATH..'dom.ProcessingInstruction')
lure.dom.Text                   = (BASE_PATH..'dom.Text')

-- Return lure to the masses
return lure