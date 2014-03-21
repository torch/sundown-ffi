local sundown = require 'sundown.env'
local ffi = require 'ffi'
local C = sundown.C

require 'sundown.cdefs'
require 'sundown.htmlcdefs'

local function render(txt)

   local ob = C.hoedown_buffer_new(64);

   local renderer = C.hoedown_html_renderer_new(0, 0)
   local document = C.hoedown_document_new(renderer, 0xfff, 16)
   C.hoedown_document_render(document, ob, ffi.cast('const char*', txt), #txt);
   C.hoedown_document_free(document);
   C.hoedown_html_renderer_free(renderer);

   txt = ffi.string(ob.data, ob.size)
   C.hoedown_buffer_free(ob);

   return txt
end

return {render=render}
