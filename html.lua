local sundown = require 'sundown.env'
local ffi = require 'ffi'
local C = sundown.C

require 'sundown.sdcdefs'
require 'sundown.htmlcdefs'

local function render(txt)
   local callbacks = ffi.new('struct sd_callbacks')
   local options = ffi.new('struct sdhtml_renderopt')
   C.sdhtml_renderer(callbacks, options, 0)

   local markdown = C.sd_markdown_new(0xfff, 16, callbacks, options)

   local outbuf = ffi.new('struct sd_buf')
   outbuf.data = nil
   outbuf.size = 0
   outbuf.asize = 0
   outbuf.unit = 64

   C.sd_markdown_render(outbuf, ffi.cast('const char*', txt), #txt, markdown)
   C.sd_markdown_free(markdown)

   return ffi.string(outbuf.data, outbuf.size)
end

return {render=render}
