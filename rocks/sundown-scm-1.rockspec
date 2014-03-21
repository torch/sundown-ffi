package = "sundown"
version = "scm-1"

source = {
   url = "git://github.com/torch/sundown-ffi.git"
}

description = {
   summary = "A FFI interface to the Markdown implementation of the Sundown library",
   detailed = [[
   ]],
   homepage = "https://github.com/torch/sundown-ffi",
   license = "BSD"
}

dependencies = {
   "lua >= 5.1",
}

build = {
   type = "builtin",
   install = {
      bin = {
         mdcat = "mdcat.lua"
      }
   },
   modules = {
      ["sundown.env"] = "env.lua",
      ["sundown.init"] = "init.lua",
      ["sundown.cdefs"] = "cdefs.lua",
      ["sundown.htmlcdefs"] = "htmlcdefs.lua",
      ["sundown.html"] = "html.lua",
      ["sundown.ascii"] = "ascii.lua",
      libhoedown = {
         sources = {
            "hoedown/src/autolink.c",
            "hoedown/src/buffer.c",
            "hoedown/src/document.c",
            "hoedown/src/escape.c",
            "hoedown/src/html.c",
            "hoedown/src/html_blocks.c",
            "hoedown/src/html_smartypants.c",
            "hoedown/src/stack.c",
            "hoedown/src/version.c"
         },
         incdirs = {
            "hoedown/src/"
         }
      }
   }
}
