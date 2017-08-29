local Namespace = require('..namespace')

--
-- Extract base package path from ... in this example
-- we should have the resulting path 'example.' as our
-- base require path
--
local base = Namespace.base(...)

--
-- Setup our namespace root
--
local example = Namespace(base)

--
-- Lets add pkga to our namespace
--
example.pkga = Namespace(base)
example.pkga.foo = 'pkga.foo'
example.pkga.sub = Namespace(base)
example.pkga.sub.fizz = 'pkga.sub.fizz'

--
-- Lets add pkgb to our namespace
--
example.pkgb = Namespace(base)
example.pkgb.bar = 'pkgb.bar'
example.pkgb.sub = Namespace(base)
example.pkgb.sub.buzz = 'pkgb.sub.buzz'

--
-- Return our namespace for our users
--
return example