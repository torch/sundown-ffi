local ffi = require 'ffi'

local sundown = {}

sundown.C = ffi.load(package.searchpath('libhoedown', package.cpath))

return sundown
