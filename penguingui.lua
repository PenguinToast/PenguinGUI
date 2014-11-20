-- This script contains all the scripts in this library, so you only need to
-- include this script for production purposes.

--------------------------------------------------------------------------------
-- Util.lua
--------------------------------------------------------------------------------

PtUtil = {}
-- Pixel widths of the first 255 characters. This was generated in Java.
PtUtil.charWidths = {8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 8, 8, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 8, 12, 10, 12, 12, 4, 6, 6, 8, 8, 6, 8, 4, 12, 10, 6, 10, 10, 10, 10, 10, 10, 10, 10, 4, 4, 8, 8, 8, 10, 12, 10, 10, 8, 10, 8, 8, 10, 10, 8, 10, 10, 8, 12, 10, 10, 10, 10, 10, 10, 8, 10, 10, 12, 10, 10, 8, 6, 12, 6, 8, 10, 6, 10, 10, 8, 10, 10, 8, 10, 10, 4, 6, 10, 4, 12, 10, 10, 10, 10, 8, 10, 8, 10, 10, 12, 8, 10, 10, 8, 4, 8, 10, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8}

-- Get a list of all lua scripts in the PenguinGUI library.
--
-- @return A list of strings containing the paths to the PenguinGUI scripts.
function PtUtil.library()
  return {
    "/penguingui/Util.lua",
    "/penguingui/Binding.lua",
    "/penguingui/BindingFunctions.lua",
    "/penguingui/GUI.lua",
    "/penguingui/Component.lua",
    "/penguingui/Panel.lua",
    "/penguingui/Frame.lua",
    "/penguingui/Button.lua",
    "/penguingui/Label.lua",
    "/penguingui/TextButton.lua",
    "/penguingui/TextField.lua",
    "/penguingui/Image.lua",
    "/penguingui/CheckBox.lua",
    "/penguingui/RadioButton.lua",
    "/lib/profilerapi.lua",
    "/lib/inspect.lua"
  }
end

-- Draw the text string, offsetting the string to account for leading whitespace.
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

-- TODO - There is no way to fill a polygon yet.
-- Fills a polygon.
function PtUtil.fillPoly(poly, color)
  console.logInfo("fillPoly is not functional yet")
  -- console.canvasDrawPoly(poly, color)
end

-- Draws a line.
function PtUtil.drawLine(p1, p2, color, width)
  console.canvasDrawLine(p1, p2, color, width * 2)
end

-- Draws a rectangle.
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
function PtUtil.drawPoly(poly, color, width)
  -- Draw lines
  for i=1,#poly - 1,1 do
    PtUtil.drawLine(poly[i], poly[i + 1], color, width)
  end
  PtUtil.drawLine(poly[#poly], poly[1], color, width)
end

-- Draws an image.
function PtUtil.drawImage(image, position, scale)
  console.canvasDrawImage(image, position, scale)
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

-- Removes the first occurence of an object from the given table.
--
-- @param t The table to remove from.
-- @param o The object to remove.
--
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

--------------------------------------------------------------------------------
-- Binding.lua
--------------------------------------------------------------------------------

-- Add listeners or bindings to objects
Binding = setmetatable(
  {},
  {
    __call = function(t, ...)
      return t.value(...)
    end
  }
)

-- Proxy metatable to add listeners to a table
Binding.proxyTable = {
  __index = function(t, k)
    local out = t._instance[k]
    if out ~= nil then
      return out
    else
      return Binding.proxyTable[k]
    end
  end,
  __newindex = function(t, k, v)
    local instance = t._instance
    local old = instance[k]
    local new = v
    instance[k] = new
    if old ~= v then
      local listeners = instance.listeners
      if listeners and listeners[k] then
        local keyListeners = listeners[k]
        for _,keyListener in ipairs(keyListeners) do
          new = keyListener(instance, k, old, new) or new
        end
      end
      local bindings = instance.bindings
      if bindings and bindings[k] then
        local keyBindings = bindings[k]
        for _,keyBinding in ipairs(keyBindings) do
          keyBinding:valueChanged(old, new)
        end
      end
    end
  end,
  __pairs = function(t)
    return pairs(t._instance)
  end,
  __ipairs = function(t)
    return ipairs(t._instance)
  end,
  __add = function(a, b)
    return a._instance + (type(b) == "table" and b._instance or b)
  end,
  __sub = function(a, b)
    return a._instance - (type(b) == "table" and b._instance or b)
  end,
  __mul = function(a, b)
    return a._instance * (type(b) == "table" and b._instance or b)
  end,
  __div = function(a, b)
    return a._instance / (type(b) == "table" and b._instance or b)
  end,
  __mod = function(a, b)
    return a._instance % (type(b) == "table" and b._instance or b)
  end,
  __pow = function(a, b)
    return a._instance ^ (type(b) == "table" and b._instance or b)
  end,
  __unm = function(a)
    return -a._instance
  end,
  __concat = function(a, b)
    return a._instance .. (type(b) == "table" and b._instance or b)
  end,
  __len = function(a)
    return #a._instance
  end,
  __eq = function(a, b)
    return a._instance == b._instance
  end,
  __lt = function(a, b)
    return a._instance < b._instance
  end,
  __le = function(a, b)
    return a._instance <= b._instance
  end,
  __call = function(t, ...)
    return t._instance(...)
  end
}

-- Whether the table is a Binding or not.
--
-- @param object The table to check.
-- @return True if the table is a binding, false if not.
function Binding.isValue(object)
  return type(object) == "table"
    and getmetatable(object._instance) == Binding.valueTable
end

Binding.weakMetaTable = {
  __mode = "v"
}

Binding.valueTable = {}

Binding.valueTable.__index = Binding.valueTable

-- Adds a listener to the value of this binding.
--
-- @param listener The listener to add.
function Binding.valueTable:addValueListener(listener)
  self:addListener("value", listener)
end

-- Removes a listener to the value of this binding.
--
-- @param listener The listener to remove.
function Binding.valueTable:removeValueListener(listener)
  self:removeListener("value", listener)
end

-- Convenience method for adding a binding to "value"
--
-- @param binding The binding to add.
function Binding.valueTable:addValueBinding(binding)
  self:addBinding("value", binding)
end

-- Convenience method for removing a binding from "value"
--
-- @param binding The binding to remove.
function Binding.valueTable:removeValueBinding(binding)
  self:removeBinding("value", binding)
end

-- Unbinds this binding, as well as anything bound to it.
function Binding.valueTable:unbind()
  local bindings = self.bindings
  if bindings and bindings.value then
    local valueBindings = bindings.value
    for _,binding in ipairs(valueBindings) do
      binding:unbind()
    end
  end
  local boundto = self.boundto
  for _,bound in ipairs(boundto) do
    for _,boundTable in pairs(bound.bindings) do
      PtUtil.removeObject(boundTable, self)
    end
  end
  self.boundto = nil
  local bindTargets = self.bindTargets
  if bindTargets then
    for bindTarget,_ in pairs(bindTargets) do
      local bindTargetBoundto = bindTarget.boundto
      for key,binding in pairs(bindTargetBoundto) do
        if binding == self then
          bindTargetBoundto[key] = nil
        end
      end
    end
  end
end

function Binding.unbindChain(binding)
  Binding.valueTable.unbind(binding)
  local bindingTable = binding.bindingTable
  for i=1, #bindingTable - 1, 1 do
    bindingTable[i]:unbind()
    bindingTable[i] = nil
  end
end

-- Creates a binding bound to the given key in the given table.
--
-- @param t The table the binding is bound to.
-- @param k The key the binding is bound to.
-- @return A binding to the key in the given table.
function Binding.value(t, k)
  local out = Binding.proxy(setmetatable({}, Binding.valueTable))
  if type(k) == "string" then -- Single key
    out.value = t[k]
    out.valueChanged = function(binding, old, new)
      binding.value = new
    end
    t:addBinding(k, out)
    out.boundto = {t}
    return out
  else -- Table of keys
    local numKeys = #k
    local currTable = t
    local bindingTable = {}
    for i=1, numKeys - 1, 1 do
      local currBinding = Binding.proxy(setmetatable({}, Binding.valueTable))
      local currKey = k[i]
      local index = i

      currBinding.valueChanged = function(binding, old, new)
        if old == new then return end
        -- Transplant bindings from old tables to new tables
        local oldTable = old
        local newTable = new
        local subKey
        local transplant
        for j=index + 1, numKeys, 1 do
          subKey = k[j]
          transplant = bindingTable[j]
          transplant.boundto[1] = newTable
          oldTable:removeBinding(subKey, transplant)
          newTable:addBinding(subKey, transplant)

          if j < numKeys then
            oldTable = oldTable[subKey]
            newTable = newTable[subKey]
          end
        end
      end
      currBinding.boundto = {currTable}
      currTable:addBinding(currKey, currBinding)
      bindingTable[index] = currBinding
      
      currTable = t[currKey] 
    end
    out.valueChanged = function(binding, old, new)
      binding.value = new
    end
    out.bindingTable = bindingTable
    out.boundto = {currTable}
    out.unbind = Binding.unbindChain
    currTable:addBinding(k[numKeys], out)
    bindingTable[numKeys] = out
    return out
  end
end

-- Adds a listener to the specified key that is called when the key's value
-- changes.
--
-- @param key The key to track changes to
-- @param listener The function to call upon the value of the key changing.
--      The function should have the arguments (t, k, old, new) where:
--           t is the table in which the change happened.
--           k is the key whose value changed.
--           old is the old value of the key.
--           new is the new value of the key.
--      If the function changes the key's value, it should return the new value.
function Binding.proxyTable:addListener(key, listener)
  local listeners = self.listeners
  if not listeners then
    listeners = {}
    self.listeners = listeners
  end
  local keyListeners = listeners[key]
  if not keyListeners then
    keyListeners = {}
    listeners[key] = keyListeners
  end
  table.insert(keyListeners, listener)
end

-- Removes the first instance of the given listener from the given key.
--
-- @param key The key the listener is attached to.
-- @param listener The listener to remove.
--
-- @return A boolean for whether a listener was removed.
function Binding.proxyTable:removeListener(key, listener)
  local keyListeners = self.listeners[key]
  return PtUtil.removeObject(keyListeners, listener) ~= -1
end

-- Adds a binding to the specified key in this table.
--
-- @param key The key to bind to.
-- @param binding The binding to attach.
function Binding.proxyTable:addBinding(key, binding)
  local bindings = self.bindings
  if not bindings then
    bindings = {}
    self.bindings = bindings
  end
  local keyBindings = bindings[key]
  if not keyBindings then
    keyBindings = setmetatable({}, Binding.weakMetaTable)
    bindings[key] = keyBindings
  end
  table.insert(keyBindings, binding)
  binding:valueChanged(self[key], self[key])
end

-- Removes a binding from a key in this table.
--
-- @param key The key to remove a binding from.
-- @param binding The binding to remove.
function Binding.proxyTable:removeBinding(key, binding)
  local keyBindings = self.bindings[key]
  return PtUtil.removeObject(keyBindings, binding) ~= -1
end

-- Binds the key in the specified table to the given value
--
-- @param target The table where the key to be bound is.
-- @param key The key to be bound.
-- @param value The value to bind to.
function Binding.bind(target, key, value)
  local listener = function(t, k, old, new)
    target[key] = new
  end
  value:addValueListener(listener)

  -- Put reference to this binding into the target table to keep this binding
  -- alive.
  local boundto = target.boundto
  if not boundto then
    boundto = {}
    target.boundto = boundto
  end
  local boundtoKey = boundto[key]
  assert(not boundtoKey, key .. " is already bound to another value")
  boundto[key] = value

  local bindTargets = value.bindTargets

  -- Keep references to the table this binding is bound to, so we can clean
  -- up if this binding is unbound.
  if not bindTargets then
    bindTargets = {}
    value.bindTargets = bindTargets
  end
  local bindKeyTargets = bindTargets[target]
  if not bindKeyTargets then
    bindKeyTargets = {}
    bindTargets[target] = bindKeyTargets
  end
  bindKeyTargets[key] = listener

  target[key] = value.value
end

Binding.proxyTable.bind = Binding.bind

-- Removes the binding on the given key in the given target.
--
-- @param target The table to remove the binding from.
-- @param key The key to unbind.
function Binding.unbind(target, key)
  local binding = target.boundto[key]
  if binding then
    binding:removeValueListener(binding.bindTargets[target][key])
    binding.bindTargets[target][key] = nil
    target.boundto[key] = nil
  end
end

Binding.proxyTable.unbind = Binding.unbind

-- Returns a proxy to a table that allows listeners and bindings to be attached.
--
-- @param instance The table to proxy.
-- @return A proxy table to the given instance.
function Binding.proxy(instance)
  return setmetatable(
    {_instance = instance},
    Binding.proxyTable
  )
end

--------------------------------------------------------------------------------
-- BindingFunctions.lua
--------------------------------------------------------------------------------

-- Creates a binding function (convenience function)
--
-- If one argument:
-- @param f1 A function that returns this value's new value after the value
--      that it is bound to changes.
--      
-- If two arguments:
-- @param f1 A function that returns this value's new value after the value
--      that it is bound to changes, if the next paramter is not a value.
-- @param f1 A function that returns this value's new value after the value
--      that it is bound to changes, if the next paramter is a value.
function Binding.valueTable.createFunction(f1, f2)
  if f2 then
    return function(self, other)
      local out = Binding.proxy(setmetatable({}, Binding.valueTable))
      if Binding.isValue(other) then
        out.valueChanged = function(binding, old, new)
          out.value = f2(self, other)
        end
        other:addValueBinding(out)
        out.boundto = {self, other}
      else
        out.valueChanged = function(binding, old, new)
          out.value = f1(self, other)
        end
        out.boundto = {self}
      end
      self:addValueBinding(out)
      return out
    end
  else
    return function(self)
      local out = Binding.proxy(setmetatable({}, Binding.valueTable))
      out.valueChanged = function(binding, old, new)
        out.value = f1(self)
      end
      self:addValueBinding(out)
      out.boundto = {self}
      return out
    end
  end
end

-- Calls tonumber on this value.
Binding.valueTable.tostring = Binding.valueTable.createFunction(
  function(self)
    return tostring(self.value)
  end
)

-- Calls tonumber on this value.
Binding.valueTable.tonumber = Binding.valueTable.createFunction(
  function(self)
    return tonumber(self.value)
  end
)

-- Creates a new value containing the sum of this value and another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.add = Binding.valueTable.createFunction(
  function(self, other)
    return self.value + other
  end,
  function(self, other)
    return self.value + other.value
  end
)

-- Creates a new value containing the difference of this value and another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.sub = Binding.valueTable.createFunction(
  function(self, other)
    return self.value - other
  end,
  function(self, other)
    return self.value - other.value
  end
)

-- Creates a new value containing the product of this value and another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.mul = Binding.valueTable.createFunction(
  function(self, other)
    return self.value * other
  end,
  function(self, other)
    return self.value * other.value
  end
)

-- Creates a new value containing the quotient of this value and another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.div = Binding.valueTable.createFunction(
  function(self, other)
    return self.value / other
  end,
  function(self, other)
    return self.value / other.value
  end
)

-- Creates a new value containing the difference of this value and another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.sub = Binding.valueTable.createFunction(
  function(self, other)
    return self.value - other
  end,
  function(self, other)
    return self.value - other.value
  end
)

-- Creates a new value containing the modulus of this value and another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.mod = Binding.valueTable.createFunction(
  function(self, other)
    return self.value % other
  end,
  function(self, other)
    return self.value % other.value
  end
)

-- Creates a new value containing the power of this value and another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.pow = Binding.valueTable.createFunction(
  function(self, other)
    return self.value ^ other
  end,
  function(self, other)
    return self.value ^ other.value
  end
)

-- Creates a new value containing the negation of this value.
Binding.valueTable.negate = Binding.valueTable.createFunction(
  function(self)
    return -(self.value)
  end
)

-- Creates a new value containing the concatenation of this value and another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.concat = Binding.valueTable.createFunction(
  function(self, other)
    return self.value .. other
  end,
  function(self, other)
    return self.value .. other.value
  end
)

-- Creates a new value containing the length of this value.
Binding.valueTable.len = Binding.valueTable.createFunction(
  function(self)
    return #(self.value)
  end
)

-- Creates a new value containing the equality of this value and another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.eq = Binding.valueTable.createFunction(
  function(self, other)
    return self.value == other
  end,
  function(self, other)
    return self.value == other.value
  end
)

-- Creates a new value containing the unequality of this value and another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.ne = Binding.valueTable.createFunction(
  function(self, other)
    return self.value ~= other
  end,
  function(self, other)
    return self.value ~= other.value
  end
)

-- Creates a new value containing whether this value is less than another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.lt = Binding.valueTable.createFunction(
  function(self, other)
    return self.value < other
  end,
  function(self, other)
    return self.value < other.value
  end
)

-- Creates a new value containing whether this value is greater than another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.gt = Binding.valueTable.createFunction(
  function(self, other)
    return self.value > other
  end,
  function(self, other)
    return self.value > other.value
  end
)

-- Creates a new value containing whether this value is less than or equal to
-- another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.le = Binding.valueTable.createFunction(
  function(self, other)
    return self.value <= other
  end,
  function(self, other)
    return self.value <= other.value
  end
)

-- Creates a new value containing whether this value is greater than or equal to
-- another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.ge = Binding.valueTable.createFunction(
  function(self, other)
    return self.value >= other
  end,
  function(self, other)
    return self.value >= other.value
  end
)

-- Creates a new value containing this value AND another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.AND = Binding.valueTable.createFunction(
  function(self, other)
    return self.value and other
  end,
  function(self, other)
    return self.value and other.value
  end
)

-- Creates a new value containing this value OR another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.OR = Binding.valueTable.createFunction(
  function(self, other)
    return self.value or other
  end,
  function(self, other)
    return self.value or other.value
  end
)

-- Creates a new value containing NOT this value
Binding.valueTable.NOT = Binding.valueTable.createFunction(
  function(self)
    return not self.value
  end
)

-- Creates a new value with the value of the first value if this value is true,
-- or the second value if this value is false.
--
-- @param ifTrue The value the new binding will be set to when this value is
--      true. Can either be another value, or a constant (number, etc.)
-- @param ifFalse The value the new binding will be set to when this value is
--      false. Can either be another value, or a constant (number, etc.)
Binding.valueTable.THEN = function(self, ifTrue, ifFalse)
  local out = Binding.proxy(setmetatable({}, Binding.valueTable))
  local trueFunction
  local falseFunction
  local boundto = {self}
  if Binding.isValue(ifTrue) then
    trueFunction = function()
      return ifTrue.value
    end
  else
    trueFunction = function()
      return ifTrue
    end
  end
  if Binding.isValue(ifFalse) then
    falseFunction = function()
      return ifFalse.value
    end
  else
    falseFunction = function()
      return ifFalse
    end
  end
  out.valueChanged = function(binding, old, new)
    if self.value then
      out.value = trueFunction()
    else
      out.value = falseFunction()
    end
  end
  self:addValueBinding(out)
  if Binding.isValue(ifTrue) then
    ifTrue:addValueBinding(out)
    table.insert(boundto, ifTrue)
  end
  if Binding.isValue(ifFalse) then
    ifFalse:addValueBinding(out)
    table.insert(boundto, ifFalse)
  end
  out.boundto = boudnto
  return out
end

--------------------------------------------------------------------------------
-- GUI.lua
--------------------------------------------------------------------------------

-- Base handler for all the GUI stuff
GUI = {
  components = {},
  mouseState = {},
  keyState = {},
  mousePosition = {0, 0}
}

-- Add a new top-level component to be handled by PenguinGUI.
function GUI.add(component)
  GUI.components[#GUI.components + 1] = component
  component:setParent(nil)
end

-- Removes a component to be handled.
--
-- @return Whether or not the component was removed
function GUI.remove(component)
  for index,comp in ripairs(GUI.components) do
    if (comp == component) then
      table.remove(GUI.components, index)
      return true
    end
  end
  return false
end

-- Sets the focus of the GUI to the component
function GUI.setFocusedComponent(component)
  local focusedComponent = GUI.focusedComponent
  if focusedComponent then
    focusedComponent.hasFocus = false
  end
  GUI.focusedComponent = component
  component.hasFocus = true
end

-- Must be called in canvasClickEvent to handle mouse events.
--
-- @param position The position of the click.
-- @param button The mouse button of the click.
-- @param pressed Whether the event is pressed or released.
function GUI.clickEvent(position, button, pressed)
  GUI.mouseState[button] = pressed
  local components = GUI.components
  local topFound = false
  for index,component in ripairs(components) do
    -- Focus top-level components
    if not topFound then
      if component:contains(position) then
        table.remove(components, index)
        components[#components + 1] = component
        topFound = true
      end
    end
    if GUI.clickEventHelper(component, position, button, pressed) then
      -- The click was consumed
      break
    end
  end
end

function GUI.clickEventHelper(component, position, button, pressed)
  local children = component.children
  for _,child in ripairs(children) do
    if GUI.clickEventHelper(child, position, button, pressed) then
      -- The click was consumed
      return true
    end
  end
  -- Only check bounds if the component has a clickEvent
  if component.clickEvent then
    if component:contains(position) then
      GUI.setFocusedComponent(component)
      if component:clickEvent(position, button, pressed) then
        -- The click was consumed
        return true
      end
    end
  end
end

-- Must be called in canvasKeyEvent to handle keyboard events.
--
-- @param key The keycode of the key that spawned the event.
-- @param pressed Whether the key was pressed or released.
function GUI.keyEvent(key, pressed)
  GUI.keyState[key] = pressed
  local component = GUI.focusedComponent
  if component then
    local keyEvent = component.keyEvent
    if keyEvent then
      keyEvent(component, key, pressed)
    end
  end
end

-- Draws and updates every component managed by this GUI.
--
-- @param dt The time elapsed since the last draw, in seconds.
function GUI.step(dt)
  GUI.mousePosition = console.canvasMousePosition()
  local hoverComponent
  for _,component in ipairs(GUI.components) do
    if component.visible ~= false then
      hoverComponent = component:step(dt) or hoverComponent
    end
  end
  if hoverComponent then
    hoverComponent.mouseOver = true
  end
end


--------------------------------------------------------------------------------
-- Component.lua
--------------------------------------------------------------------------------

-- Superclass for all GUI components.
Component = class()
Component.x = 0
Component.y = 0
Component.width = 0
Component.height = 0

-- Constructs a component.
function Component:_init()
  self.children = {}
  self.offset = Binding.proxy({0, 0})
end

-- Adds a child component to this component.
--
-- @param child The component to add.
function Component:add(child)
  local children = self.children
  children[#children + 1] = child
  child:setParent(self)
end

-- Removes a child component.
--
-- @param child The component to remove
-- @return Whether or not the child was removed
function Component:remove(child)
  local children = self.children
  for index,comp in ripairs(children) do
    if (comp == child) then
      table.remove(children, index)
      return true
    end
  end
  return false
end

-- Resizes this component around its children.
--
-- @param padding (Optional) Amount of padding to put between the component's
--                children and this component's borders.
function Component:pack(padding)
  local width = 0
  local height = 0
  for _,child in ipairs(self.children) do
    width = math.max(width, child.x + child.width)
    height = math.max(height, child.y + child.height)
  end
  padding = padding or 0
  self.width = width + padding
  self.height = height + padding
end

-- Draws and updates this component, and any children.
function Component:step(dt)
  local hoverComponent
  if self.mouseOver ~= nil then
    if self:contains(GUI.mousePosition) then
      hoverComponent = self
    else
      self.mouseOver = false
    end
  end
  
  self:update(dt)
  
  local layout = self.layout
  if layout then
    self:calculateOffset()
    self.layout = false
  end
  self:draw(dt)
  
  for _,child in ipairs(self.children) do
    if layout then
      child.layout = true
    end
    if child.visible ~= false then
      hoverComponent = child:step(dt) or hoverComponent
    end
  end
  return hoverComponent
end

-- Updates this component
function Component:update(dt)
end

-- Draws this component
function Component:draw(dt)
end

-- Sets the parent of this component, and updates the offset of this component.
--
-- @param parent The new parent of this component, or nil if this is to be a
--               top level component.
function Component:setParent(parent)
  self.parent = parent
  -- self:calculateOffset()
  if parent then
    parent.layout = true
  end
end

-- Calculates the offset from the origin that this component should use, based
-- on its parents.
--
-- @return The calculated offset.
function Component:calculateOffset(direction)
  local offset = self.offset
  
  local parent = self.parent
  if parent then
    -- parent:calculateOffset()
    offset[1] = parent.offset[1] + parent.x
    offset[2] = parent.offset[2] + parent.y
  else
    offset[1] = 0
    offset[2] = 0
  end
  
  return offset
end

-- Checks if the given position is within this component.
--
-- @param position The position to check.
--
-- @return Whether or not the position is within the bounds of this component.
function Component:contains(position)
  local pos = {position[1] - self.offset[1], position[2] - self.offset[2]}
  
  if pos[1] >= self.x and pos[1] <= self.x + self.width
    and pos[2] >= self.y and pos[2] <= self.y + self.height
  then
    return true
  end
  return false
end

--------------------------------------------------------------------------------
-- Panel.lua
--------------------------------------------------------------------------------

-- A group of components, will eventually manage layouts (TODO).
Panel = class(Component)

-- Constructs a Panel.
-- 
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
function Panel:_init(x, y)
  Component._init(self)
  self.x = x
  self.y = y
end

function Panel:add(child)
  Component.add(self, child)
  self:pack()
end

--------------------------------------------------------------------------------
-- Frame.lua
--------------------------------------------------------------------------------

-- A window
Frame = class(Panel)
Frame.borderColor = "black"
Frame.borderThickness = 1
Frame.backgroundColor = "#232323"

-- Constructs a Frame.
-- 
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
function Frame:_init(x, y)
  Panel._init(self, x, y)
end

function Frame:update(dt)
  if self.dragging then
    if self.hasFocus then
      local mousePos = GUI.mousePosition
      self.x = self.x + (mousePos[1] - self.dragOrigin[1])
      self.y = self.y + (mousePos[2] - self.dragOrigin[2])
      self.layout = true
      self.dragOrigin = mousePos
    else
      self.dragging = false
    end
  end
end

function Frame:draw(dt)
  local startX = self.x - self.offset[1]
  local startY = self.y - self.offset[2]
  local w = self.width
  local h = self.height
  local border = self.borderThickness
  
  local borderRect = {
    startX, startY,
    startX + w, startY + h
  }
  local backgroundRect = {
    startX + border, startY + border,
    startX + w - border, startY + h - border
  }
  
  PtUtil.drawRect(borderRect, self.borderColor, border)
  PtUtil.fillRect(backgroundRect, self.backgroundColor)
end

function Frame:clickEvent(position, button, pressed)
  if pressed then
    self.dragging = true
    self.dragOrigin = position
  else
    self.dragging = false
  end
  return true
end

--------------------------------------------------------------------------------
-- Button.lua
--------------------------------------------------------------------------------

-- A clickable button
Button = class(Component)
Button.outerBorderColor = "black"
Button.innerBorderColor = "#545454"
Button.innerBorderHoverColor = "#939393"
Button.color = "#262626"
Button.hoverColor = "#545454"

-- Constructs a new Button.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width The width of the new component.
-- @param height The height of the new component.
function Button:_init(x, y, width, height)
  Component._init(self)
  self.mouseOver = false

  self.x = x
  self.y = y
  self.width = width
  self.height = height
end

function Button:update(dt)
  if self.pressed and not self.mouseOver then
    self:setPressed(false)
  end
end

function Button:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height
  
  local borderPoly = {
    {startX + 1, startY + 0.5},
    {startX + w - 1, startY + 0.5},
    {startX + w - 0.5, startY + 1},
    {startX + w - 0.5, startY + h - 1},
    {startX + w - 1, startY + h - 0.5},
    {startX + 1, startY + h - 0.5},
    {startX + 0.5, startY + h - 1},
    {startX + 0.5, startY + 1},
  }
  local innerBorderRect = {
    startX + 1, startY + 1, startX + w - 1, startY + h - 1
  }
  local rectOffset = 1.5
  local rect = {
    startX + rectOffset, startY + rectOffset, startX + w - rectOffset, startY + h - rectOffset
  }

  PtUtil.drawPoly(borderPoly, self.outerBorderColor, 1)
  if self.mouseOver then
    PtUtil.drawRect(innerBorderRect, self.innerBorderHoverColor, 0.5)
    PtUtil.fillRect(rect, self.hoverColor)
  else
    PtUtil.drawRect(innerBorderRect, self.innerBorderColor, 0.5)
    PtUtil.fillRect(rect, self.color)
  end
end

function Button:setPressed(pressed)
  if pressed and not self.pressed then
    self.x = self.x + 1
    self.y = self.y - 1
    self.layout = true
  end
  if not pressed and self.pressed then
    self.x = self.x - 1
    self.y = self.y + 1
    self.layout = true
  end
  self.pressed = pressed
end

function Button:clickEvent(position, button, pressed)
  if self.onClick and not pressed and self.pressed then
    self:onClick(button)
  end
  self:setPressed(pressed)
  return true
end

--------------------------------------------------------------------------------
-- Label.lua
--------------------------------------------------------------------------------

-- A text label for displaying text.
Label = class(Component)
Label.listeners = {
  text = {
    function(t, k, old, new)
      t:recalculateBounds()
    end
  }
}

-- Constructs a new Label.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param text The text string to display on the button. The button's size will
--             be based on this string.
-- @param fontSize (optional) The font size of the text to display, default 10.
-- @param fontColor (optional) The color of the text to display, default white.
function Label:_init(x, y, text, fontSize, fontColor)
  Component._init(self)
  fontSize = fontSize or 10
  self.fontSize = fontSize
  self.fontColor = fontColor or "white"
  self.text = text
  self.x = x
  self.y = y
  self:recalculateBounds()
end

-- Recalculates the bounds of the label based on its text and font size.
function Label:recalculateBounds()
  self.width = PtUtil.getStringWidth(self.text, self.fontSize)
  self.height = self.fontSize
end

function Label:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  
  PtUtil.drawText(self.text, {
                    position = {startX, startY},
                    verticalAnchor = "bottom"
                             }, self.fontSize, self.fontColor)
end

--------------------------------------------------------------------------------
-- TextButton.lua
--------------------------------------------------------------------------------

-- A button that has a text label.
TextButton = class(Button)
TextButton.listeners = {
  text = {
    function(t, k, old, new)
      local label = t.label
      label.text = new
      t:repositionLabel()
    end
  }
}

-- Constructs a button with a text label.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width The width of the new component.
-- @param height The height of the new component.
-- @param text The text string to display on the button. The button's size will
--             be based on this string.
-- @param fontColor (optional) The color of the text to display, default white.
function TextButton:_init(x, y, width, height, text, fontColor)
  Button._init(self, x, y, width, height)
  local padding = 2
  local fontSize = height - padding * 2
  local label = Label(0, padding, text, fontSize, fontColor)
  
  self.padding = padding
  self.label = label
  self:add(label)

  self:repositionLabel()
end

-- Centers the text label
function TextButton:repositionLabel()
  local label = self.label
  label.x = (self.width - label.width) / 2
end

--------------------------------------------------------------------------------
-- TextField.lua
--------------------------------------------------------------------------------

-- Editable text field
TextField = class(Component)
TextField.vPadding = 3
TextField.hPadding = 4
TextField.borderColor = "#545454"
TextField.backgroundColor = "#000000"
TextField.textColor = "white"
TextField.textHoverColor = "#999999"
TextField.defaultTextColor = "#333333"
TextField.defaultTextHoverColor = "#777777"
TextField.cursorColor = "white"
TextField.cursorRate = 1

-- Constructs a new TextField.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width The width of the new component.
-- @param height The height of the new component.
-- @param defaultText The text to display when nothing has been entered.
function TextField:_init(x, y, width, height, defaultText)
  Component._init(self)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.fontSize = height - self.vPadding * 2
  self.cursorPosition = 0
  self.cursorX = 0
  self.cursorTimer = self.cursorRate
  self.text = ""
  self.defaultText = defaultText
  self.textOffset = 0
  self.textClip = nil
  self.mouseOver = false
end

function TextField:update(dt)
  if self.hasFocus then
    local timer = self.cursorTimer
    local rate = self.cursorRate
    timer = timer - dt
    if timer < 0 then
      timer = rate
    end
    self.cursorTimer = timer
  end
end

function TextField:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height

  -- Draw border and background
  local borderRect = {
    startX, startY, startX + w, startY + h
  }
  local backgroundRect = {
    startX + 1, startY + 1, startX + w - 1, startY + h - 1
  }
  PtUtil.fillRect(borderRect, self.borderColor)
  PtUtil.fillRect(backgroundRect, self.backgroundColor)

  local text = self.text
  -- Decide if the default text should be displayed
  local default = (text == "") and (self.defaultText ~= nil)
  
  local textColor
  -- Choose the color to draw the text with
  if self.mouseOver then
    textColor = default and self.defaultTextHoverColor or self.textHoverColor
  else
    textColor = default and self.defaultTextColor or self.textColor
  end

  local cursorPosition = self.cursorPosition
  text = default and self.defaultText
    or text:sub(self.textOffset + 1, self.textOffset
                  + (self.textClip or #text))

  -- Draw the text
  PtUtil.drawText(text, {
                    position = {
                      startX + self.hPadding,
                      startY + self.vPadding
                    },
                    verticalAnchor = "bottom"
                        }, self.fontSize, textColor)

  -- Text cursor
  if self.hasFocus then
    local timer = self.cursorTimer
    local rate = self.cursorRate

    if timer > rate / 2 then -- Draw cursor
      local cursorX = startX + self.cursorX + self.hPadding
      local cursorY = startY + self.vPadding
      PtUtil.drawLine({cursorX, cursorY},
        {cursorX, cursorY + h - self.vPadding * 2},
        self.cursorColor,
        1)
    end
  end
end

-- Set the character position of the text cursor.
--
-- @param pos The new position for the cursor, where 0 is the beginning of the
--            field.
function TextField:setCursorPosition(pos)
  self.cursorPosition = pos

  if pos < self.textOffset then
    self.textOffset = pos
  end
  self:calculateTextClip()
  local textClip = self.textClip
  while (textClip) and (pos > self.textOffset + textClip) do
    self.textOffset = self.textOffset + 1
    self:calculateTextClip()
    textClip = self.textClip
  end
  while self.textOffset > 0 and not textClip do
    self.textOffset = self.textOffset - 1
    self:calculateTextClip()
    textClip = self.textClip
    if textClip then
      self.textOffset = self.textOffset + 1
      self:calculateTextClip()
    end
  end
  -- world.logInfo("cursor: %s, textOffset: %s, textClip: %s", pos, self.textOffset, self.textClip)
  
  local text = self.text
  local cursorX = 0
  for i=self.textOffset + 1,pos,1 do
    local charWidth = PtUtil.getStringWidth(text:sub(i, i), self.fontSize)
    cursorX = cursorX + charWidth
  end
  self.cursorX = cursorX
  self.cursorTimer = self.cursorRate
end

-- Calculates the text clip, i.e. how many characters to display.
function TextField:calculateTextClip()
  local maxX = self.width - self.hPadding * 2
  local text = self.text
  local totalWidth = 0
  local startI = self.textOffset + 1
  for i=startI,#text,1 do
    totalWidth = totalWidth
      + PtUtil.getStringWidth(text:sub(i, i), self.fontSize)
    if totalWidth > maxX then
      self.textClip = i - startI
      return
    end
  end
  self.textClip = nil
end

function TextField:clickEvent(position, button, pressed)
  local xPos = position[1] - self.x - self.offset[1] - self.hPadding

  local text = self.text
  local totalWidth = 0
  for i=self.textOffset + 1,#text,1 do
    local charWidth = PtUtil.getStringWidth(text:sub(i, i), self.fontSize)
    if xPos < (totalWidth + charWidth * 0.6) then
      self:setCursorPosition(i - 1)
      return
    end
    totalWidth = totalWidth + charWidth
  end
  self:setCursorPosition(#text)

  return true
end

function TextField:keyEvent(keyCode, pressed)
  -- Ignore key releases and any keys pressed while ctrl or alt is held
  local keyState = GUI.keyState
  if not pressed
    or keyState[305] or keyState[306]
    or keyState[307] or keyState[308]
  then
    return
  end
  
  local shift = keyState[303] or keyState[304]
  local caps = keyState[301]
  local key = PtUtil.getKey(keyCode, shift, caps)

  local text = self.text
  local cursorPos = self.cursorPosition

  if #key == 1 then -- Type a character
    self.text = text:sub(1, cursorPos) .. key .. text:sub(cursorPos + 1)
    self:setCursorPosition(cursorPos + 1)
  else -- Special character
    if key == "backspace" then
      if cursorPos > 0 then
        self.text = text:sub(1, cursorPos - 1) .. text:sub(cursorPos + 1)
        self:setCursorPosition(cursorPos - 1)
      end
    elseif key == "enter" then
      if self.onEnter then
        self:onEnter()
      end
    elseif key == "delete" then
      if cursorPos < #text then
        self.text = text:sub(1, cursorPos) .. text:sub(cursorPos + 2)
      end
    elseif key == "right" then
      self:setCursorPosition(math.min(cursorPos + 1, #text))
    elseif key == "left" then
      self:setCursorPosition(math.max(0, cursorPos - 1))
    elseif key == "home" then
      self:setCursorPosition(0)
    elseif key == "end" then
      self:setCursorPosition(#text)
    end
  end
end

--------------------------------------------------------------------------------
-- Image.lua
--------------------------------------------------------------------------------

-- A image
Image = class(Component)

-- Constructs a new Image.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param image The path to the image.
-- @param scale (Optional) Factor to scale the image by.
function Image:_init(x, y, image, scale)
  Component._init(self)
  scale = scale or 1
  
  self.x = x
  self.y = y
  local imageSize = root.imageSize(image)
  self.width = imageSize[1] * scale
  self.height = imageSize[2] * scale
  self.image = image
  self.scale = scale
end

function Image:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local image = self.image
  local scale = self.scale
  
  PtUtil.drawImage(image, {startX, startY}, scale)
end

--------------------------------------------------------------------------------
-- CheckBox.lua
--------------------------------------------------------------------------------

-- A check box
CheckBox = class(Component)
CheckBox.borderColor = "#545454"
CheckBox.backgroundColor = "black"
CheckBox.hoverColor = "#1C1C1C"
CheckBox.checkColor = "#C51A0B"
CheckBox.pressedColor = "#343434"

-- Constructs a new CheckBox.
-- 
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param size The width and height of the new component.
function CheckBox:_init(x, y, size)
  Component._init(self)
  self.mouseOver = false

  self.x = x
  self.y = y
  self.width = size
  self.height = size

  self.selected = false
end

function CheckBox:update(dt)
  if self.pressed and not self.mouseOver then
    self.pressed = false
  end
end

function CheckBox:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height

  local borderRect = {startX, startY, startX + w, startY + h}
  local rect = {startX + 1, startY + 1, startX + w - 1, startY + h - 1}
  PtUtil.drawRect(borderRect, self.borderColor, 1)

  if self.pressed then
    PtUtil.fillRect(rect, self.pressedColor)
  elseif self.mouseOver then
    PtUtil.fillRect(rect, self.hoverColor)
  else
    PtUtil.fillRect(rect, self.backgroundColor)
  end

  -- Draw check, if needed
  if self.selected then
    self:drawCheck(dt)
  end
end

-- Draw the checkbox
function CheckBox:drawCheck(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height
  PtUtil.drawLine(
    {startX + w / 4, startY + w / 2},
    {startX + w / 3, startY + h / 4},
    self.checkColor, 1)
  PtUtil.drawLine(
    {startX + w / 3, startY + h / 4},
    {startX + 3 * w / 4, startY + 3 * h / 4},
    self.checkColor, 1)
end

function CheckBox:clickEvent(position, button, pressed)
  if not pressed and self.pressed then
    self.selected = not self.selected
    if self.onSelect then
      self:onSelect(self.selected)
    end
  end
  self.pressed = pressed
  return true
end

--------------------------------------------------------------------------------
-- RadioButton.lua
--------------------------------------------------------------------------------

-- A radio button
RadioButton = class(CheckBox)

function RadioButton:drawCheck(dt)
  -- Draw squares since no efficient way to fill circles yet.
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height
  local checkRect = {startX + w / 4, startY + h / 4,
                     startX + 3 * w / 4, startY + 3 * h / 4}
  PtUtil.fillRect(checkRect, self.checkColor)
end

-- Select this RadioButton
function RadioButton:select()
  local siblings
  if self.parent == nil then
    siblings = GUI.components
  else
    siblings = self.parent.children
  end

  local selectedButton
  for _,sibling in ipairs(siblings) do
    if sibling ~= self and sibling.is_a[RadioButton]
      and sibling.selected
    then
      selectedButton = sibling
    end
  end
  if selectedButton then
    selectedButton.selected = false
    if selectedButton.onSelect then
      selectedButton:onSelect(false)
    end
  end

  if not self.selected then
    self.selected = true
    if self.onSelect then
      self:onSelect(self.selected)
    end
  else
    self.selected = true
  end
end

function RadioButton:setParent(parent)
  Component.setParent(self, parent)
  self:select()
end

function RadioButton:clickEvent(position, button, pressed)
  if not pressed and self.pressed then
    self:select()
  end
  self.pressed = pressed
  return true
end

--------------------------------------------------------------------------------
-- profilerapi.lua
--------------------------------------------------------------------------------

-- Credit to XspeedPL for writing this (I think)
profilerApi = {
  hookedTables = {}
}

--- Initializes the Profiler and hooks all functions
function profilerApi.init()
  if profilerApi.isInit then return end
  profilerApi.hooks = {}
  profilerApi.start = profilerApi.getTime()
  profilerApi.hookAll("", _ENV)
  profilerApi.isInit = true
end

--- Prints all collected data into the log ordered by total time descending
function profilerApi.logData()
  local time = profilerApi.getTime() - profilerApi.start
  local arr = {}
  local len = 8
  local cnt = 5
  for k,v in pairs(profilerApi.hooks) do
    if v.t > 0 then
      table.insert(arr, k)
      local l = string.len(k)
      if l > len then len = l end
      l = profilerApi.get10pow(profilerApi.hooks[k].c)
      if l > cnt then cnt = l end
    end
  end
  table.sort(arr, profilerApi.sortHelp)
  world.logInfo("Profiler log for console (total profiling time: " .. string.format("%.2f", time) .. ")")
  world.logInfo(string.format("%" .. len .. "s |        total time | %" .. cnt .. "s |      average time |         last time", "function", "count"))
  for i,k in ipairs(arr) do
    local hook = profilerApi.hooks[k]
    world.logInfo(string.format("%" .. len .. "s | %.15f | %" .. cnt .. "i | %.15f | %.15f", k, hook.t, hook.c, hook.a, hook.e))
  end
end

function profilerApi.get10pow(n)
  local ret = 1
  while n >= 10 do
    ret = ret + 1
    n = n / 10
  end
  return ret
end

function profilerApi.sortHelp(e1, e2)
  return profilerApi.hooks[e1].t > profilerApi.hooks[e2].t
end

function profilerApi.canHook(fn)
  local un = { "pairs", "ipairs", "type", "next", "assert", "error", "print", "setmetatable", "select", "rawset", "rawlen", "pcall" }
  for i,v in ipairs(un) do
    if v == fn then return false end
  end
  return true
end

function profilerApi.hookAll(tn, to)
  if (tn == "profilerApi.") or (tn == "table.") or (tn == "coroutine.") or (tn == "os.") then return end
  local hookedTables = profilerApi.hookedTables
  for k,v in pairs(hookedTables) do
    if to == v then
      return
    end
  end
  table.insert(profilerApi.hookedTables, to)
  for k,v in pairs(to) do
    if type(v) == "function" then
      if (tn ~= "") or profilerApi.canHook(k) then
        profilerApi.hook(to, tn, v, k)
      end
    elseif type(v) == "table" then
      profilerApi.hookAll(tn .. k .. ".", v)
    end
  end
end

function profilerApi.getTime()
  return os.clock()
end

function profilerApi.hook(to, tn, fo, fn)
  local full = tn .. fn
  profilerApi.hooks[full] = { s = -1, f = fo, e = -1, t = 0, a = 0, c = 0 }
  to[fn] = function(...) return profilerApi.hooked(full, ...) end
end

function profilerApi.hooked(n, ...)
  local hook = profilerApi.hooks[n]
  hook.s = profilerApi.getTime()
  local ret = hook.f(...)
  hook.e = profilerApi.getTime() - hook.s
  hook.t = hook.t + hook.e
  hook.c = hook.c + 1
  hook.a = hook.t / hook.c
  return ret
end

--------------------------------------------------------------------------------
-- inspect.lua
--------------------------------------------------------------------------------

local inspect ={
  _VERSION = 'inspect.lua 3.0.0',
  _URL     = 'http://github.com/kikito/inspect.lua',
  _DESCRIPTION = 'human-readable representations of tables',
  _LICENSE = [[
    MIT LICENSE

    Copyright (c) 2013 Enrique García Cota

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  ]]
}

inspect.KEY       = setmetatable({}, {__tostring = function() return 'inspect.KEY' end})
inspect.METATABLE = setmetatable({}, {__tostring = function() return 'inspect.METATABLE' end})

-- Apostrophizes the string if it has quotes, but not aphostrophes
-- Otherwise, it returns a regular quoted string
local function smartQuote(str)
  if str:match('"') and not str:match("'") then
    return "'" .. str .. "'"
  end
  return '"' .. str:gsub('"', '\\"') .. '"'
end

local controlCharsTranslation = {
  ["\a"] = "\\a",  ["\b"] = "\\b", ["\f"] = "\\f",  ["\n"] = "\\n",
  ["\r"] = "\\r",  ["\t"] = "\\t", ["\v"] = "\\v"
}

local function escapeChar(c) return controlCharsTranslation[c] end

local function escape(str)
  local result = str:gsub("\\", "\\\\"):gsub("(%c)", escapeChar)
  return result
end

local function isIdentifier(str)
  return type(str) == 'string' and str:match( "^[_%a][_%a%d]*$" )
end

local function isSequenceKey(k, length)
  return type(k) == 'number'
     and 1 <= k
     and k <= length
     and math.floor(k) == k
end

local defaultTypeOrders = {
  ['number']   = 1, ['boolean']  = 2, ['string'] = 3, ['table'] = 4,
  ['function'] = 5, ['userdata'] = 6, ['thread'] = 7
}

local function sortKeys(a, b)
  local ta, tb = type(a), type(b)

  -- strings and numbers are sorted numerically/alphabetically
  if ta == tb and (ta == 'string' or ta == 'number') then return a < b end

  local dta, dtb = defaultTypeOrders[ta], defaultTypeOrders[tb]
  -- Two default types are compared according to the defaultTypeOrders table
  if dta and dtb then return defaultTypeOrders[ta] < defaultTypeOrders[tb]
  elseif dta     then return true  -- default types before custom ones
  elseif dtb     then return false -- custom types after default ones
  end

  -- custom types are sorted out alphabetically
  return ta < tb
end

local function getNonSequentialKeys(t)
  local keys, length = {}, #t
  for k,_ in pairs(t) do
    if not isSequenceKey(k, length) then table.insert(keys, k) end
  end
  table.sort(keys, sortKeys)
  return keys
end

local function getToStringResultSafely(t, mt)
  local __tostring = type(mt) == 'table' and rawget(mt, '__tostring')
  local str, ok
  if type(__tostring) == 'function' then
    ok, str = pcall(__tostring, t)
    str = ok and str or 'error: ' .. tostring(str)
  end
  if type(str) == 'string' and #str > 0 then return str end
end

local maxIdsMetaTable = {
  __index = function(self, typeName)
    rawset(self, typeName, 0)
    return 0
  end
}

local idsMetaTable = {
  __index = function (self, typeName)
    local col = setmetatable({}, {__mode = "kv"})
    rawset(self, typeName, col)
    return col
  end
}

local function countTableAppearances(t, tableAppearances)
  tableAppearances = tableAppearances or setmetatable({}, {__mode = "k"})

  if type(t) == 'table' then
    if not tableAppearances[t] then
      tableAppearances[t] = 1
      for k,v in pairs(t) do
        countTableAppearances(k, tableAppearances)
        countTableAppearances(v, tableAppearances)
      end
      countTableAppearances(getmetatable(t), tableAppearances)
    else
      tableAppearances[t] = tableAppearances[t] + 1
    end
  end

  return tableAppearances
end

local copySequence = function(s)
  local copy, len = {}, #s
  for i=1, len do copy[i] = s[i] end
  return copy, len
end

local function makePath(path, ...)
  local keys = {...}
  local newPath, len = copySequence(path)
  for i=1, #keys do
    newPath[len + i] = keys[i]
  end
  return newPath
end

local function processRecursive(process, item, path)
  if item == nil then return nil end

  local processed = process(item, path)
  if type(processed) == 'table' then
    local processedCopy = {}
    local processedKey

    for k,v in pairs(processed) do
      processedKey = processRecursive(process, k, makePath(path, k, inspect.KEY))
      if processedKey ~= nil then
        processedCopy[processedKey] = processRecursive(process, v, makePath(path, processedKey))
      end
    end

    local mt  = processRecursive(process, getmetatable(processed), makePath(path, inspect.METATABLE))
    setmetatable(processedCopy, mt)
    processed = processedCopy
  end
  return processed
end


-------------------------------------------------------------------

local Inspector = {}
local Inspector_mt = {__index = Inspector}

function Inspector:puts(...)
  local args   = {...}
  local buffer = self.buffer
  local len    = #buffer
  for i=1, #args do
    len = len + 1
    buffer[len] = tostring(args[i])
  end
end

function Inspector:down(f)
  self.level = self.level + 1
  f()
  self.level = self.level - 1
end

function Inspector:tabify()
  self:puts(self.newline, string.rep(self.indent, self.level))
end

function Inspector:alreadyVisited(v)
  return self.ids[type(v)][v] ~= nil
end

function Inspector:getId(v)
  local tv = type(v)
  local id = self.ids[tv][v]
  if not id then
    id              = self.maxIds[tv] + 1
    self.maxIds[tv] = id
    self.ids[tv][v] = id
  end
  return id
end

function Inspector:putKey(k)
  if isIdentifier(k) then return self:puts(k) end
  self:puts("[")
  self:putValue(k)
  self:puts("]")
end

function Inspector:putTable(t)
  if t == inspect.KEY or t == inspect.METATABLE then
    self:puts(tostring(t))
  elseif self:alreadyVisited(t) then
    self:puts('<table ', self:getId(t), '>')
  elseif self.level >= self.depth then
    self:puts('{...}')
  else
    if self.tableAppearances[t] > 1 then self:puts('<', self:getId(t), '>') end

    local nonSequentialKeys = getNonSequentialKeys(t)
    local length            = #t
    -- local mt                = getmetatable(t)
    local toStringResult    = getToStringResultSafely(t, mt)

    self:puts('{')
    self:down(function()
      if toStringResult then
        self:puts(' -- ', escape(toStringResult))
        if length >= 1 then self:tabify() end
      end

      local count = 0
      for i=1, length do
        if count > 0 then self:puts(',') end
        self:puts(' ')
        self:putValue(t[i])
        count = count + 1
      end

      for _,k in ipairs(nonSequentialKeys) do
        if count > 0 then self:puts(',') end
        self:tabify()
        self:putKey(k)
        self:puts(' = ')
        self:putValue(t[k])
        count = count + 1
      end

      if mt then
        if count > 0 then self:puts(',') end
        self:tabify()
        self:puts('<metatable> = ')
        self:putValue(mt)
      end
    end)

    if #nonSequentialKeys > 0 or mt then -- result is multi-lined. Justify closing }
      self:tabify()
    elseif length > 0 then -- array tables have one extra space before closing }
      self:puts(' ')
    end

    self:puts('}')
  end
end

function Inspector:putValue(v)
  local tv = type(v)

  if tv == 'string' then
    self:puts(smartQuote(escape(v)))
  elseif tv == 'number' or tv == 'boolean' or tv == 'nil' then
    self:puts(tostring(v))
  elseif tv == 'table' then
    self:putTable(v)
  else
    self:puts('<',tv,' ',self:getId(v),'>')
  end
end

-------------------------------------------------------------------

function inspect.inspect(root, options)
  options       = options or {}

  local depth   = options.depth   or math.huge
  local newline = options.newline or '\n'
  local indent  = options.indent  or '  '
  local process = options.process

  if process then
    root = processRecursive(process, root, {})
  end

  local inspector = setmetatable({
    depth            = depth,
    buffer           = {},
    level            = 0,
    ids              = setmetatable({}, idsMetaTable),
    maxIds           = setmetatable({}, maxIdsMetaTable),
    newline          = newline,
    indent           = indent,
    tableAppearances = countTableAppearances(root)
  }, Inspector_mt)

  inspector:putValue(root)

  return table.concat(inspector.buffer)
end

setmetatable(inspect, { __call = function(_, ...) return inspect.inspect(...) end })

return inspect

