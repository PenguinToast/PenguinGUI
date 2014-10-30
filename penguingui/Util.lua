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
-- Pixel widths of the first 255 characters. This was generated in Java, so the
-- numbers are slightly offset.
PtUtil.charWidths = {6, 6, 6, 6, 6, 6, 6, 6, 0, 0, 6, 6, 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 3, 6, 9, 8, 9, 9, 3, 5, 5, 6, 6, 5, 6, 3, 9, 8, 5, 8, 8, 8, 8, 8, 8, 8, 8, 3, 3, 6, 6, 6, 8, 9, 8, 8, 6, 8, 6, 6, 8, 8, 6, 8, 8, 6, 9, 8, 8, 8, 8, 8, 8, 6, 8, 8, 9, 8, 8, 6, 5, 9, 5, 6, 8, 5, 8, 8, 6, 8, 8, 6, 8, 8, 3, 5, 8, 3, 9, 8, 8, 8, 8, 6, 8, 6, 8, 8, 9, 6, 8, 8, 6, 3, 6, 8, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6}

-- Gets the pixel width of the char of size 12.
--
-- @param char The character to get the width of.
function PtUtil.getCharWidth(char)
  return PtUtil.charWidths[char] + 2
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
