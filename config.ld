file = {"PenguinGUI/", exclude = {"PenguinGUI/penguingui.lua"}}
project = "PenguinGUI"
title = "PenguinGUI Reference"
merge = true
template = true
description = "An object-oriented GUI library for Starbound"
full_description = "@{extern\\../index.html\\Project Page}\n\n"
.. "Examples for general usage are available in @{GUI} and @{Binding}"

custom_see_handler("^extern\\(.*)\\(.*)$",function(url, name)
  return name, url
end)
