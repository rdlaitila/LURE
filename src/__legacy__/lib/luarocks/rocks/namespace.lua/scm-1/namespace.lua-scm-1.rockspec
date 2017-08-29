package = "namespace.lua"
version = "scm-1"
source = {
   url = "git+https://github.com/rdlaitila/namespace.lua.git"
}
description = {
   homepage = "https://github.com/rdlaitila/namespace.lua",
   license = "MIT"
}
dependencies = {}
build = {
   type = "builtin",
   modules = {
      example = "example/init.lua",
      ["example.pkga.foo"] = "example/pkga/foo.lua",
      ["example.pkga.sub.fizz"] = "example/pkga/sub/fizz.lua",
      ["example.pkgb.bar"] = "example/pkgb/bar.lua",
      ["example.pkgb.sub.buzz"] = "example/pkgb/sub/buzz.lua",
      namespace = "namespace.lua",
      namespaces_tests = "namespaces_tests.lua"
   }
}
