local ffi = require 'ffi'

require 'sundown.sdcdefs'
require 'sundown.htmlcdefs'

local sundown = ffi.load(package.searchpath('libsundown', package.cpath))

return sundown
