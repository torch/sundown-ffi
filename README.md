sundown-ffi
===========

A LuaJIT interface to the Sundown library (a Markdown implementation)

# Installation #

torch-rocks install https://raw.github.com/andresy/sundown-ffi/master/rocks/sundown-scm-1.rockspec

# Usage #

```lua
local sundown = require 'sundown'

local html = sundow.render[[
sundown-ffi
===========

A LuaJIT interface to the Sundown library (a Markdown implementation)

# Installation #

torch-rocks install https://raw.github.com/andresy/sundown-ffi/master/rocks/sundown-scm-1.rockspec
]]
```

# Advanced usage #

All functions from the library `sundown` and `houdini` are accessible through `sundown.C.func` where `func`
is the function of interest.

See the [Sundown library page](https://github.com/vmg/sundown) for more details.

Note that Houdini C function and structure names are prefixed here with `sdhtml_` (e.g. `sdhtml_renderer`).
Sundown C function and structure names are prefixed with `sd_` (e.g. `sd_markdown_render`).

See sdcdefs.lua and htmlcdefs.lua for what is actually available.
