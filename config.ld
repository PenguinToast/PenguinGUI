file = {"PenguinGUI/", exclude = {
  "PenguinGUI/penguingui.lua",
  "PenguinGUI/Test.lua",
  "PenguinGUI/lib",
  "PenguinGUI/penguingui/testobject"
}}
project = "PenguinGUI"
title = "PenguinGUI Reference"
merge = true
template = true
sort = true
description = "An object-oriented GUI library for Starbound"
full_description = "@{extern\\../index.html\\Project Page}\n\n"
.. "Examples for general usage are available in @{GUI} and @{Binding}.\n\n"
.. "If you want to create a custom component, details are available in @{Component}"

custom_see_handler("^extern\\(.*)\\(.*)$",function(url, name)
  return name, url
end)
