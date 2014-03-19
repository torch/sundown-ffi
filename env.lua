local ffi = require 'ffi'

local sundown = {}

sundown.C = ffi.load(package.searchpath('libsundown', package.cpath))

return sundown
