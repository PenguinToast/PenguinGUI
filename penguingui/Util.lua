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
    "/penguingui/TextButton.lua"
  }
end

PtUtil = {}
-- Pixel widths of the first 255 characters. This was generated in Java.
PtUtil.charWidths = {8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 8, 8, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 8, 12, 10, 12, 12, 4, 6, 6, 8, 8, 6, 8, 4, 12, 10, 6, 10, 10, 10, 10, 10, 10, 10, 10, 4, 4, 8, 8, 8, 10, 12, 10, 10, 8, 10, 8, 8, 10, 10, 8, 10, 10, 8, 12, 10, 10, 10, 10, 10, 10, 8, 10, 10, 12, 10, 10, 8, 6, 12, 6, 8, 10, 6, 10, 10, 8, 10, 10, 8, 10, 10, 4, 6, 10, 4, 12, 10, 10, 10, 10, 8, 10, 8, 10, 10, 12, 8, 10, 10, 8, 4, 8, 10, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8}

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