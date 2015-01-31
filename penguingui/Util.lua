--- Utility functions.
-- @module PtUtil
PtUtil = {}
-- Pixel widths of the first 255 characters. This was generated in Java.
PtUtil.charWidths = {6, 6, 6, 6, 6, 6, 6, 6, 0, 0, 6, 6, 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 4, 8, 12, 10, 12, 12, 4, 6, 6, 8, 8, 6, 8, 4, 12, 10, 6, 10, 10, 10, 10, 10, 10, 10, 10, 4, 4, 8, 8, 8, 10, 12, 10, 10, 8, 10, 8, 8, 10, 10, 8, 10, 10, 8, 12, 10, 10, 10, 10, 10, 10, 8, 10, 10, 12, 10, 10, 8, 6, 12, 6, 8, 10, 6, 10, 10, 9, 10, 10, 8, 10, 10, 4, 6, 9, 4, 12, 10, 10, 10, 10, 8, 10, 8, 10, 10, 12, 8, 10, 10, 8, 4, 8, 10, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 6, 10, 10, 15, 10, 5, 13, 7, 14, 15, 15, 10, 6, 14, 12, 16, 14, 7, 7, 6, 11, 12, 8, 7, 6, 16, 16, 15, 15, 15, 10, 10, 10, 10, 10, 10, 10, 14, 10, 8, 8, 8, 8, 8, 8, 8, 8, 13, 10, 10, 10, 10, 10, 10, 10, 13, 10, 10, 10, 10, 10, 14, 11, 10, 10, 10, 10, 10, 10, 15, 9, 10, 10, 10, 10, 8, 8, 8, 8, 12, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 15, 10}

--- Get a list of all lua scripts in the PenguinGUI library.
--
-- @return A list of strings containing the paths to the PenguinGUI scripts.
function PtUtil.library()
  return {
    "/penguingui/Util.lua",
    "/penguingui/Binding.lua",
    "/penguingui/BindingFunctions.lua",
    "/penguingui/GUI.lua",
    "/penguingui/Component.lua",
    "/penguingui/Line.lua",
    "/penguingui/Rectangle.lua",
    "/penguingui/Panel.lua",
    "/penguingui/Frame.lua",
    "/penguingui/Button.lua",
    "/penguingui/Label.lua",
    "/penguingui/TextButton.lua",
    "/penguingui/TextField.lua",
    "/penguingui/Image.lua",
    "/penguingui/CheckBox.lua",
    "/penguingui/RadioButton.lua",
    "/penguingui/TextRadioButton.lua",
    "/penguingui/Slider.lua",
    "/penguingui/List.lua",
    "/lib/profilerapi.lua",
    "/lib/inspect.lua"
  }
end

--- Draw the text string, offsetting the string to account for leading whitespace.
--
-- All parameters are identical to those of console.canvasDrawText
function PtUtil.drawText(text, options, fontSize, color)
  if text:byte() == 32 then -- If it starts with a space, offset the string
    fontSize = fontSize or 16
    local xOffset = PtUtil.getStringWidth(" ", fontSize)
    local oldX = options.position[1]
    options.position[1] = oldX + xOffset
    console.canvasDrawText(text, options, fontSize, color)
    options.position[1] = oldX
  else
    console.canvasDrawText(text, options, fontSize, color)
  end
end

--- Get the approximate pixel width of a string.
--
-- @param text The string to get the width of.
-- @param fontSize The size of the font to get the width from.
function PtUtil.getStringWidth(text, fontSize)
  local widths = PtUtil.charWidths
  local scale = PtUtil.getFontScale(fontSize)
  local out = 0
  for i=1,#text,1 do
    out = out + widths[string.byte(text, i)]
  end
  return out * scale
end

--- Gets the scale of the specified font size.
--
-- @param size The font size to get the scale for
function PtUtil.getFontScale(size)
  return (size - 16) * 0.0625 + 1
end

PtUtil.specialKeyMap = {
  [8] = "backspace",
  [13] = "enter",
  [127] = "delete",
  [275] = "right",
  [276] = "left",
  [278] = "home",
  [279] = "end",
  [301] = "capslock",
  [303] = "shift",
  [304] = "shift"
}

PtUtil.shiftKeyMap = {
  [39] = "\"",
  [44] = "<",
  [45] = "_",
  [46] = ">",
  [47] = "?",
  [48] = ")",
  [49] = "!",
  [50] = "@",
  [51] = "#",
  [52] = "$",
  [53] = "%",
  [54] = "^",
  [55] = "&",
  [56] = "*",
  [57] = "(",
  [59] = ":",
  [61] = "+",
  [91] = "{",
  [92] = "|",
  [93] = "}",
  [96] = "~"
}

--- Gets a string representation of the keycode.
--
-- @param key The keycode of the key.
-- @param shift Boolean representing whether or not shift is pressed.
-- @param capslock Boolean representing whether or not capslock is on.
function PtUtil.getKey(key, shift, capslock)
  if (capslock and not shift) or (shift and not capslock) then
    if key >= 97 and key <= 122 then
      return string.upper(string.char(key))
    end
  end
  if shift and PtUtil.shiftKeyMap[key] then
    return PtUtil.shiftKeyMap[key]
  else
    if key >= 32 and key <= 122 then
      return string.char(key)
    elseif PtUtil.specialKeyMap[key] then
      return PtUtil.specialKeyMap[key]
    else
      return "unknown"
    end
  end
end

--- Fills a rectangle.
--
-- All parameters are identical to those of console.canvasDrawRect
function PtUtil.fillRect(rect, color)
  console.canvasDrawRect(rect, color)
end

-- TODO - There is no way to fill a polygon yet.
-- Fills a polygon.
function PtUtil.fillPoly(poly, color)
  console.logInfo("fillPoly is not functional yet")
  -- console.canvasDrawPoly(poly, color)
end

--- Draws a line.
--
-- All parameters are identical to those of console.canvasDrawLine
function PtUtil.drawLine(p1, p2, color, width)
  console.canvasDrawLine(p1, p2, color, width * 2)
end

--- Draws a rectangle.
--
-- All parameters are identical to those of console.canvasDrawRect
function PtUtil.drawRect(rect, color, width)
  local minX = rect[1] + width / 2
  local minY = math.floor((rect[2] + width / 2) * 2) / 2
  local maxX = rect[3] - width / 2
  local maxY = math.floor((rect[4] - width / 2) * 2) / 2
  PtUtil.drawLine(
    {minX - width / 2, minY},
    {maxX + width / 2, minY},
    color, width
  )
  PtUtil.drawLine(
    {maxX, minY},
    {maxX, maxY},
    color, width
  )
  PtUtil.drawLine(
    {minX - width / 2, maxY},
    {maxX + width / 2, maxY},
    color, width
  )
  PtUtil.drawLine(
    {minX, minY},
    {minX, maxY},
    color, width
  )
end

-- Draws a polygon.
--
-- All parameters are identical to those of console.canvasDrawPoly
function PtUtil.drawPoly(poly, color, width)
  -- Draw lines
  for i=1,#poly - 1,1 do
    PtUtil.drawLine(poly[i], poly[i + 1], color, width)
  end
  PtUtil.drawLine(poly[#poly], poly[1], color, width)
end

-- Draws an image.
--
-- All parameters are identical to those of console.canvasDrawImage
function PtUtil.drawImage(image, position, scale)
  console.canvasDrawImage(image, position, scale)
end

--- Does the same thing as ipairs, except backwards
--
-- @param t The table to iterate backwards over
function ripairs(t)
  local function ripairs_it(t,i)
    i=i-1
    local v=t[i]
    if v==nil then return v end
    return i,v
  end
  return ripairs_it, t, #t+1
end

--- Removes the first occurence of an object from the given table.
--
-- @param t The table to remove from.
-- @param o The object to remove.
-- @return The index of the removed object, or -1 if the object was not found.
function PtUtil.removeObject(t, o)
  for i,obj in ipairs(t) do
    if obj == o then
      table.remove(t, i)
      return i
    end
  end
  return -1
end

--- Creates a new class with the specified superclass(es).
-- @param ... The new class's superclass(es).
function class(...)
  -- "cls" is the new class
  local cls, bases = {}, {...}
  
  -- copy base class contents into the new class
  for i, base in ipairs(bases) do
    for k, v in pairs(base) do
      cls[k] = v
    end
  end
  
  -- set the class's __index, and start filling an "is_a" table that contains this class and all of its bases
  -- so you can do an "instance of" check using my_instance.is_a[MyClass]
  cls.__index, cls.is_a = cls, {[cls] = true}
  for i, base in ipairs(bases) do
    for c in pairs(base.is_a) do
      cls.is_a[c] = true
    end
    cls.is_a[base] = true
  end
  -- the class's __call metamethod
  setmetatable(
    cls,
    {
      __call = function (c, ...)
        local instance = setmetatable({}, c)
        instance = Binding.proxy(instance)
        
        -- run the init method if it's there
        local init = instance._init
        if init then init(instance, ...) end
        return instance
      end
    }
  )
  -- return the new class table, that's ready to fill with methods
  return cls
end

-- Dumps value as a string closely resemling Lua code that could be used to
-- recreate it (with the exception of functions, threads and recursive tables).
-- Credit to MrMagical.
--
-- Basic usage: dump(value)
--
-- @param value The value to be dumped.
-- @param indent (optional) String used for indenting the dumped value.
-- @param seen (optional) Table of already processed tables which will be
--                        dumped as "{...}" to prevent infinite recursion.
function dump(value, indent, seen)
  if type(value) ~= "table" then
    if type(value) == "string" then
      return string.format('%q', value)
    else
      return tostring(value)
    end
  else
    if type(seen) ~= "table" then
      seen = {}
    elseif seen[value] then
      return "{...}"
    end
    seen[value] = true
    indent = indent or ""
    if next(value) == nil then
      return "{}"
    end
    local str = "{"
    local first = true
    for k,v in pairs(value) do
      if first then
        first = false
      else
        str = str..","
      end
      str = str.."\n"..indent.."  ".."["..dump(k, "", seen)
        .."] = "..dump(v, indent.."  ", seen)
    end
    str = str.."\n"..indent.."}"
    return str
  end
end
