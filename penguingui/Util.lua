-- Get a list of all lua scripts in the PenguinGUI library.
--
-- @return A list of strings containing the paths to the PenguinGUI scripts.
function penguinGuiLibrary()
  return {
    "/penguingui/Util.lua",
    "/penguingui/GUI.lua",
    "/penguingui/Component.lua",
    "/penguingui/Button.lua",
    "/penguingui/Label.lua",
    "/penguingui/TextButton.lua",
    "/penguingui/TextField.lua"
  }
end

PtUtil = {}
-- Pixel widths of the first 255 characters. This was generated in Java.
PtUtil.charWidths = {8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 8, 8, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 8, 12, 10, 12, 12, 4, 6, 6, 8, 8, 6, 8, 4, 12, 10, 6, 10, 10, 10, 10, 10, 10, 10, 10, 4, 4, 8, 8, 8, 10, 12, 10, 10, 8, 10, 8, 8, 10, 10, 8, 10, 10, 8, 12, 10, 10, 10, 10, 10, 10, 8, 10, 10, 12, 10, 10, 8, 6, 12, 6, 8, 10, 6, 10, 10, 8, 10, 10, 8, 10, 10, 4, 6, 10, 4, 12, 10, 10, 10, 10, 8, 10, 8, 10, 10, 12, 8, 10, 10, 8, 4, 8, 10, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8}

-- Draw the text string, offsetting the string to account for leading whitespace.
--
-- All parameters are identical to those of console.canvasDrawText
function PtUtil.drawText(text, options, fontSize, color)
  if text:sub(1, 1) == " " then
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

-- Get the approximate pixel width of a string.
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

-- Gets the scale of the specified font size.
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

-- Gets a string representation of the keycode.
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

-- Fills a rectangle.
function PtUtil.fillRect(rect, color)
  console.canvasDrawRect(rect, color)
end

-- Fills a polygon.
function PtUtil.fillPoly(poly, color)
  console.canvasDrawPoly(poly, color)
end

-- Draws a line.
function PtUtil.drawLine(p1, p2, color, width)
  console.canvasDrawLine(p1, p2, color, width)
end

-- Draws a rectangle.
function PtUtil.drawRect(rect, color, width)

end

-- Draws a polygon.
function PtUtil.drawPoly(poly, color, width)

end

-- Does the same thing as ipairs, except backwards
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

-- Creates a new class with the specified superclass(es)
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
      str = str.."\n"..indent.."  ".."["..dump(k).."] = "..dump(v, indent.."  ")
    end
    str = str.."\n"..indent.."}"
    return str
  end
end
