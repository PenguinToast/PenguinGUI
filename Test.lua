#!/usr/bin/lua

inspect = require "lib/inspect"

for i=1,10,1 do
  if i % 2 == 0 then
    goto continue
  end
  local a = 2
  print(i + a)
  ::continue::
end
