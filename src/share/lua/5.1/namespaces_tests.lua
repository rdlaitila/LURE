local example = require('example')

assert(example.pkga.foo == "foo")
assert(example.pkga.sub.fizz == "fizz")
assert(example.pkgb.bar == "bar")
assert(example.pkgb.sub.buzz == "buzz") 