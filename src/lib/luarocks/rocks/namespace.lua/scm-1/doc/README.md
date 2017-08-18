# Requiring packages is as easy as accessing a table key

namespace.lua provides a way to deffer require of packages until accessing a table key.

# Install

```bash
luarocks install --server=http://luarocks.org/dev namespace.lua
```

or include namespace.lua into our projects from this repository.

# Usage

First require namespace.lua

```lua
local Namespace = require('namespace')
```

Then create a new namespace

```lua
local mynamespace = Namespace()
```

Assign strings to the keys you wish to defer requires on

```lua
mynamespace.foo = 'foo'
mynamespace.bar = 'bar'
```

When you access 'foo' and 'bar' namespace.lua will require and cache them on the namespace

```lua
print(mynamespace.foo) --> calls require('foo') and returns value
print(mynamespace.bar) --> calls require('bar') and returns value
```

