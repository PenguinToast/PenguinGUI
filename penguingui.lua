-- This script contains all the scripts in this library, so you only need to
-- include this script for production purposes.

--------------------------------------------------------------------------------
-- Util.lua
--------------------------------------------------------------------------------

PtUtil = {}
PtUtil.charWidths = {8, 8, 8, 8, 8, 8, 8, 8, 0, 0, 8, 8, 0, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 8, 12, 10, 12, 12, 4, 6, 6, 8, 8, 6, 8, 4, 12, 10, 6, 10, 10, 10, 10, 10, 10, 10, 10, 4, 4, 8, 8, 8, 10, 12, 10, 10, 8, 10, 8, 8, 10, 10, 8, 10, 10, 8, 12, 10, 10, 10, 10, 10, 10, 8, 10, 10, 12, 10, 10, 8, 6, 12, 6, 8, 10, 6, 10, 10, 8, 10, 10, 8, 10, 10, 4, 6, 10, 4, 12, 10, 10, 10, 10, 8, 10, 8, 10, 10, 12, 8, 10, 10, 8, 4, 8, 10, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8}

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
    "/penguingui/TextRadioButton.lua",
    "/penguingui/List.lua",
    "/penguingui/Slider.lua",
    "/lib/profilerapi.lua",
    "/lib/inspect.lua"
  }
end

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

function PtUtil.getStringWidth(text, fontSize)
  local widths = PtUtil.charWidths
  local scale = PtUtil.getFontScale(fontSize)
  local out = 0
  for i=1,#text,1 do
    out = out + widths[string.byte(text, i)]
  end
  return out * scale
end

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

function PtUtil.fillRect(rect, color)
  console.canvasDrawRect(rect, color)
end

function PtUtil.fillPoly(poly, color)
  console.logInfo("fillPoly is not functional yet")
end

function PtUtil.drawLine(p1, p2, color, width)
  console.canvasDrawLine(p1, p2, color, width * 2)
end

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

function PtUtil.drawPoly(poly, color, width)
  for i=1,#poly - 1,1 do
    PtUtil.drawLine(poly[i], poly[i + 1], color, width)
  end
  PtUtil.drawLine(poly[#poly], poly[1], color, width)
end

function PtUtil.drawImage(image, position, scale)
  console.canvasDrawImage(image, position, scale)
end

function ripairs(t)
  local function ripairs_it(t,i)
    i=i-1
    local v=t[i]
    if v==nil then return v end
    return i,v
  end
  return ripairs_it, t, #t+1
end

function PtUtil.removeObject(t, o)
  for i,obj in ipairs(t) do
    if obj == o then
      table.remove(t, i)
      return i
    end
  end
  return -1
end

function class(...)
  local cls, bases = {}, {...}
  
  for i, base in ipairs(bases) do
    for k, v in pairs(base) do
      cls[k] = v
    end
  end
  
  cls.__index, cls.is_a = cls, {[cls] = true}
  for i, base in ipairs(bases) do
    for c in pairs(base.is_a) do
      cls.is_a[c] = true
    end
    cls.is_a[base] = true
  end
  setmetatable(
    cls,
    {
      __call = function (c, ...)
        local instance = setmetatable({}, c)
        instance = Binding.proxy(instance)
        
        local init = instance._init
        if init then init(instance, ...) end
        return instance
      end
    }
  )
  return cls
end

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

Binding = setmetatable(
  {},
  {
    __call = function(t, ...)
      return t.value(...)
    end
  }
)

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
          new = keyListener(t, k, old, new) or new
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

function Binding.isValue(object)
  return type(object) == "table"
    and getmetatable(object._instance) == Binding.valueTable
end

Binding.weakMetaTable = {
  __mode = "v"
}

Binding.valueTable = {}

Binding.valueTable.__index = Binding.valueTable


function Binding.valueTable:addValueListener(listener)
  return self:addListener("value", listener)
end

function Binding.valueTable:removeValueListener(listener)
  return self:removeListener("value", listener)
end

function Binding.valueTable:addValueBinding(binding)
  return self:addBinding("value", binding)
end

function Binding.valueTable:removeValueBinding(binding)
  return self:removeBinding("value", binding)
end

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
  return listener
end

function Binding.proxyTable:removeListener(key, listener)
  local keyListeners = self.listeners[key]
  return PtUtil.removeObject(keyListeners, listener) ~= -1
end

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
  return binding
end

function Binding.proxyTable:removeBinding(key, binding)
  local keyBindings = self.bindings[key]
  return PtUtil.removeObject(keyBindings, binding) ~= -1
end


function Binding.bind(target, key, value)
  local listener = function(t, k, old, new)
    target[key] = new
  end
  value:addValueListener(listener)

  local boundto = target.boundto
  if not boundto then
    boundto = {}
    target.boundto = boundto
  end
  local boundtoKey = boundto[key]
  assert(not boundtoKey, key .. " is already bound to another value")
  boundto[key] = value

  local bindTargets = value.bindTargets

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

function Binding.bindBidirectional(t1, k1, t2, k2)
  t1:bind(k1, Binding(t2, k2))
  t2:bind(k2, Binding(t1, k1))
end

Binding.proxyTable.bindBidirectional = Binding.bindBidirectional

function Binding.unbind(target, key)
  local binding = target.boundto[key]
  if binding then
    binding:removeValueListener(binding.bindTargets[target][key])
    binding.bindTargets[target][key] = nil
    target.boundto[key] = nil
  end
end

Binding.proxyTable.unbind = Binding.unbind

function Binding.proxy(instance)
  return setmetatable(
    {_instance = instance},
    Binding.proxyTable
  )
end

--------------------------------------------------------------------------------
-- BindingFunctions.lua
--------------------------------------------------------------------------------


local createFunction = function(f)
  return function(...)
    local out = Binding.proxy(setmetatable({}, Binding.valueTable))
    local getters = {}
    local boundto = {self}
    local args = table.pack(...)
    local numArgs = args.n
    for i = 1, numArgs, 1 do
      local value = args[i]
      local getter
      if Binding.isValue(value) then
        getter = function()
          return value.value
        end
      else
        getter = function()
          return value
        end
      end
      getters[i] = getter
    end
    out.valueChanged = function(binding, old, new)
      out.value = f(unpack(getters))
    end
    for i = 1, numArgs, 1 do
      local value = args[i]
      if Binding.isValue(value) then
        value:addValueBinding(out)
      end
      table.insert(boundto, value)
    end
    out.boundto = boundto
    return out
  end
end


Binding.valueTable.tostring = createFunction(
  function(value)
    return tostring(value())
  end
)
Binding.tostring = Binding.valueTable.tostring

Binding.valueTable.tonumber = createFunction(
  function(value)
    return tonumber(value())
  end
)
Binding.tonumber = Binding.valueTable.tonumber

Binding.valueTable.add = createFunction(
  function(first, ...)
    local out = first()
    local args = table.pack(...)
    for _,value in ipairs(args) do
      out = out + value()
    end
    return out
  end
)
Binding.add = Binding.valueTable.add

Binding.valueTable.sub = createFunction(
  function(first, ...)
    local out = first()
    local args = table.pack(...)
    for _,value in ipairs(args) do
      out = out - value()
    end
    return out
  end
)
Binding.sub = Binding.valueTable.sub

Binding.valueTable.mul = createFunction(
  function(first, ...)
    local out = first()
    local args = table.pack(...)
    for _,value in ipairs(args) do
      out = out * value()
    end
    return out
  end
)
Binding.mul = Binding.valueTable.mul

Binding.valueTable.div = createFunction(
  function(first, ...)
    local out = first()
    local args = table.pack(...)
    for _,value in ipairs(args) do
      out = out / value()
    end
    return out
  end
)
Binding.div = Binding.valueTable.div

Binding.valueTable.mod = createFunction(
  function(first, ...)
    local out = first()
    local args = table.pack(...)
    for _,value in ipairs(args) do
      out = out % value()
    end
    return out
  end
)
Binding.mod = Binding.valueTable.mod

Binding.valueTable.pow = createFunction(
  function(first, ...)
    local out = first()
    local args = table.pack(...)
    for _,value in ipairs(args) do
      out = out ^ value()
    end
    return out
  end
)
Binding.pow = Binding.valueTable.pow

Binding.valueTable.negate = createFunction(
  function(value)
    return -value()
  end
)
Binding.negate = Binding.valueTable.negate

Binding.valueTable.concat = createFunction(
  function(first, ...)
    local out = first()
    local args = table.pack(...)
    for _,value in ipairs(args) do
      out = out .. value()
    end
    return out
  end
)
Binding.concat = Binding.valueTable.concat

Binding.valueTable.len = createFunction(
  function(value)
    return #value()
  end
)
Binding.len = Binding.valueTable.len

Binding.valueTable.eq = createFunction(
  function(a, b)
    return a() == b()
  end
)
Binding.eq = Binding.valueTable.eq

Binding.valueTable.ne = createFunction(
  function(a, b)
    return a() ~= b()
  end
)
Binding.ne = Binding.valueTable.ne

Binding.valueTable.lt = createFunction(
  function(a, b)
    return a() < b()
  end
)
Binding.lt = Binding.valueTable.lt

Binding.valueTable.gt = createFunction(
  function(a, b)
    return a() > b()
  end
)
Binding.gt = Binding.valueTable.gt

Binding.valueTable.le = createFunction(
  function(a, b)
    return a() <= b()
  end
)
Binding.le = Binding.valueTable.le

Binding.valueTable.ge = createFunction(
  function(a, b)
    return a() >= b()
  end
)
Binding.ge = Binding.valueTable.ge

Binding.valueTable.AND = createFunction(
  function(first, ...)
    local out = first()
    local args = table.pack(...)
    for _,value in ipairs(args) do
      out = out and value()
    end
    return out
  end
)
Binding.AND = Binding.valueTable.AND

Binding.valueTable.OR = createFunction(
  function(first, ...)
    local out = first()
    local args = table.pack(...)
    for _,value in ipairs(args) do
      out = out or value()
    end
    return out
  end
)
Binding.OR = Binding.valueTable.OR

Binding.valueTable.NOT = createFunction(
  function(value)
    return not value()
  end
)
Binding.NOT = Binding.valueTable.NOT

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
  out.boundto = boundto
  return out
end
Binding.THEN = Binding.valueTable.THEN


--------------------------------------------------------------------------------
-- GUI.lua
--------------------------------------------------------------------------------


GUI = {
  components = {},
  mouseState = {},
  keyState = {},
  mousePosition = {0, 0}
}

function GUI.add(component)
  GUI.components[#GUI.components + 1] = component
  component:setParent(nil)
end

function GUI.remove(component)
  for index,comp in ripairs(GUI.components) do
    if (comp == component) then
      table.remove(GUI.components, index)
      return true
    end
  end
  return false
end

function GUI.setFocusedComponent(component)
  local focusedComponent = GUI.focusedComponent
  if focusedComponent then
    focusedComponent.hasFocus = false
  end
  GUI.focusedComponent = component
  component.hasFocus = true
end

function GUI.clickEvent(position, button, pressed)
  GUI.mouseState[button] = pressed
  local components = GUI.components
  local topFound = false
  for index,component in ripairs(components) do
    if not topFound then
      if component:contains(position) then
        table.remove(components, index)
        components[#components + 1] = component
        topFound = true
      end
    end
    if GUI.clickEventHelper(component, position, button, pressed) then
      break
    end
  end
end

function GUI.clickEventHelper(component, position, button, pressed)
  local children = component.children
  for _,child in ripairs(children) do
    if GUI.clickEventHelper(child, position, button, pressed) then
      return true
    end
  end
  if component.clickEvent then
    if component:contains(position) then
      GUI.setFocusedComponent(component)
      if component:clickEvent(position, button, pressed) then
        return true
      end
    end
  end
end

function GUI.keyEvent(key, pressed)
  GUI.keyState[key] = pressed
  local component = GUI.focusedComponent
  while component do
    local keyEvent = component.keyEvent
    if keyEvent then
      if keyEvent(component, key, pressed) then
        return
      end
    end
    component = component.parent
  end
end

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

Component = class()
Component.x = 0
Component.y = 0
Component.width = 0
Component.height = 0

Component.mouseOver = nil

Component.hasFocus = nil


function Component:_init()
  self.children = {}
  self.offset = Binding.proxy({0, 0})
end


function Component:add(child)
  local children = self.children
  children[#children + 1] = child
  child:setParent(self)
end

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

function Component:update(dt)
end

function Component:draw(dt)
end

function Component:setParent(parent)
  self.parent = parent
  if parent then
    parent.layout = true
  end
end

function Component:calculateOffset()
  local offset = self.offset
  
  local parent = self.parent
  if parent then
    offset[1] = parent.offset[1] + parent.x
    offset[2] = parent.offset[2] + parent.y
  else
    offset[1] = 0
    offset[2] = 0
  end
  
  return offset
end

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

Panel = class(Component)


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

Frame = class(Panel)
Frame.borderColor = "black"
Frame.borderThickness = 1
Frame.backgroundColor = "#232323"


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

Button = class(Component)
Button.outerBorderColor = "black"
Button.innerBorderColor = "#545454"
Button.innerBorderHoverColor = "#939393"
Button.color = "#262626"
Button.hoverColor = "#545454"


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
  if button <= 3 then
    if self.onClick and not pressed and self.pressed then
      self:onClick(button)
    end
    self:setPressed(pressed)
    return true
  end 
end


--------------------------------------------------------------------------------
-- Label.lua
--------------------------------------------------------------------------------

Label = class(Component)


function Label:_init(x, y, text, fontSize, fontColor)
  Component._init(self)
  fontSize = fontSize or 10
  self.fontSize = fontSize
  self.fontColor = fontColor or "white"
  self.text = text
  self.x = x
  self.y = y
  self:addListener("text", self.recalculateBounds)
  self:recalculateBounds()
end


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

TextButton = class(Button)


function TextButton:_init(x, y, width, height, text, fontColor)
  Button._init(self, x, y, width, height)
  local padding = 2
  local fontSize = height - padding * 2
  local label = Label(0, padding, text, fontSize, fontColor)
  self.text = text
  
  self.padding = padding
  self.label = label
  self:add(label)

  self:addListener(
    "text",
    function(t, k, old, new)
      t.label.text = new
      t:repositionLabel()
    end
  )

  self:repositionLabel()
end


function TextButton:repositionLabel()
  local label = self.label
  label.x = (self.width - label.width) / 2
end


--------------------------------------------------------------------------------
-- TextField.lua
--------------------------------------------------------------------------------

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

  local borderRect = {
    startX, startY, startX + w, startY + h
  }
  local backgroundRect = {
    startX + 1, startY + 1, startX + w - 1, startY + h - 1
  }
  PtUtil.fillRect(borderRect, self.borderColor)
  PtUtil.fillRect(backgroundRect, self.backgroundColor)

  local text = self.text
  local default = (text == "") and (self.defaultText ~= nil)
  
  local textColor
  if self.mouseOver then
    textColor = default and self.defaultTextHoverColor or self.textHoverColor
  else
    textColor = default and self.defaultTextColor or self.textColor
  end

  local cursorPosition = self.cursorPosition
  text = default and self.defaultText
    or text:sub(self.textOffset + 1, self.textOffset
                  + (self.textClip or #text))

  PtUtil.drawText(text, {
                    position = {
                      startX + self.hPadding,
                      startY + self.vPadding
                    },
                    verticalAnchor = "bottom"
                        }, self.fontSize, textColor)

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
  
  local text = self.text
  local cursorX = 0
  for i=self.textOffset + 1,pos,1 do
    local charWidth = PtUtil.getStringWidth(text:sub(i, i), self.fontSize)
    cursorX = cursorX + charWidth
  end
  self.cursorX = cursorX
  self.cursorTimer = self.cursorRate
end

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
  if button <= 3 then
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
end

function TextField:keyEvent(keyCode, pressed)
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
  return true
end


--------------------------------------------------------------------------------
-- Image.lua
--------------------------------------------------------------------------------

Image = class(Component)


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

CheckBox = class(Component)
CheckBox.borderColor = "#545454"
CheckBox.backgroundColor = "black"
CheckBox.hoverColor = "#1C1C1C"
CheckBox.checkColor = "#C51A0B"
CheckBox.pressedColor = "#343434"


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

  if self.selected then
    self:drawCheck(dt)
  end
end

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
  if button <= 3 then
    if not pressed and self.pressed then
      self.selected = not self.selected
    end
    self.pressed = pressed
    return true
  end
end

--------------------------------------------------------------------------------
-- RadioButton.lua
--------------------------------------------------------------------------------

RadioButton = class(CheckBox)




function RadioButton:drawCheck(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height
  local checkRect = {startX + w / 4, startY + h / 4,
                     startX + 3 * w / 4, startY + 3 * h / 4}
  PtUtil.fillRect(checkRect, self.checkColor)
end

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
  end

  if not self.selected then
    self.selected = true
  end
end

function RadioButton:setParent(parent)
  Component.setParent(self, parent)
  local siblings
  if self.parent == nil then
    siblings = GUI.components
  else
    siblings = self.parent.children
  end

  for _,sibling in ipairs(siblings) do
    if sibling ~= self and sibling.is_a[RadioButton] and sibling.selected then
      return
    end
  end
  self.selected = true
end

function RadioButton:clickEvent(position, button, pressed)
  if button <= 3 then
    if not pressed and self.pressed then
      self:select()
    end
    self.pressed = pressed
    return true
  end
end

--------------------------------------------------------------------------------
-- TextRadioButton.lua
--------------------------------------------------------------------------------

TextRadioButton = class(RadioButton)
TextRadioButton.hoverColor = "#1F1F1F"
TextRadioButton.pressedColor = "#454545"
TextRadioButton.checkColor = "#343434"
TextRadioButton.listeners = {
  text = {
    function(t, k, old, new)
      local label = t.label
      label.text = new
      t:repositionLabel()
    end
  }
}


function TextRadioButton:_init(x, y, width, height, text)
  RadioButton._init(self, x, y, 0)
  self.width = width
  self.height = height
  
  local padding = 2
  local fontSize = height - padding * 2
  local label = Label(0, padding, text, fontSize, fontColor)
  
  self.padding = padding
  self.label = label
  self:add(label)

  self.text = text
  self:repositionLabel()
end


function TextRadioButton:drawCheck(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height
  local checkRect = {startX + 1, startY + 1,
                     startX + w - 1, startY + h - 1}
  PtUtil.fillRect(checkRect, self.checkColor)
end

function TextRadioButton:repositionLabel()
  local label = self.label
  label.x = (self.width - label.width) / 2
end

--------------------------------------------------------------------------------
-- List.lua
--------------------------------------------------------------------------------

List = class(Component)
List.borderColor = "#545454"
List.borderSize = 1
List.backgroundColor = "black"
List.itemPadding = 2
List.scrollBarSize = 3


function List:_init(x, y, width, height, itemSize, itemFactory)
  Component._init(self)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.itemSize = itemSize
  self.itemFactory = itemFactory or
    function(size, text)
      return TextRadioButton(0, 0, width
                               - (self.borderSize * 2
                                    + self.itemPadding * 2
                                    + self.scrollBarSize + 2),
                             size, text)
    end
  self.items = {}
  self.topIndex = 1
  self.bottomIndex = nil
  self.mouseOver = false
end


function List:update(dt)
  if self.barDragging then
    if not GUI.mouseState[1] or self.scrollBarTickCount == 0 then
      self.barDragging = false
    else
      local mousePos = GUI.mousePosition
      local dragPos
      local dragOffset = self.barDragOffset
      if self.horizontal then
        dragPos = (mousePos[1] - dragOffset) - self.x + self.offset[1]
          + self.borderSize + 0.5
      else
        dragPos = self.y + self.offset[2] + self.height - self.borderSize
          - 0.5 - (dragOffset + mousePos[2])
      end
      local tickSize = self.scrollBarTick
      local newTop = math.floor(dragPos / tickSize + 0.5)
      newTop = math.max(newTop, 0)
      newTop = math.min(newTop, self.scrollBarTickCount)
      self.topIndex = newTop + 1
      self:positionItems()
    end
  end
  if self.barMoving ~= nil then
    if not GUI.mouseState[1] then
      self.barMoving = nil
    else
      self:scroll(self.barMoving)
    end
  end
end

function List:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height

  local borderSize = self.borderSize
  local borderColor = self.borderColor
  local borderRect = {startX, startY, startX + w, startY + h}
  local rect = {startX + 1, startY + 1, startX + w - 1, startY + h - 1}
  PtUtil.drawRect(borderRect, borderColor, borderSize)
  PtUtil.fillRect(rect, self.backgroundColor)

  local scrollBarSize = self.scrollBarSize
  if self.horizontal then
    local lineY = startY + borderSize + scrollBarSize + 1.5
    PtUtil.drawLine({startX, lineY}, {startX + w, lineY}, borderColor, 1)
    local scrollLeft = startX + borderSize + 0.5
    local scrollY = startY + borderSize + 0.5
    local scrollBarLength = self.scrollBarLength
    local scrollX = scrollTop + self.scrollBarOffset
    PtUtil.fillRect({scrollX, scrollY,
                     scrollX + scrollBarLength, scrollY + self.scrollBarSize},
      borderColor)
  else
    local lineX = startX + w - borderSize - scrollBarSize - 1.5
    PtUtil.drawLine({lineX, startY}, {lineX, startY + h}, borderColor, 1)
    local scrollTop = startY + h - borderSize - 0.5
    local scrollX = lineX + 1
    local scrollBarLength = self.scrollBarLength
    local scrollY = scrollTop - self.scrollBarOffset - scrollBarLength
    PtUtil.fillRect({scrollX, scrollY,
                     scrollX + self.scrollBarSize, scrollY + scrollBarLength},
      borderColor)
  end
end

function List:emplaceItem(...)
  return self:addItem(self.itemFactory(self.itemSize, ...))
end

function List:addItem(item)
  self:add(item)
  local items = self.items
  local index = #items + 1
  items[index] = item
  self:positionItems()
  return item, index
end

function List:removeItem(item)
  if type(item) == "number" then -- Remove by index
    local removed = table.remove(self.items, item)
    if not removed then
      return nil, -1
    end
    self:remove(removed)
    self:positionItems()
    if self.bottomIndex == nil then
      self:scroll(true)
    end
    return removed, item
  else -- Remove by item
    local index = PtUtil.removeObject(self.items, item)
    if index == -1 then
      return nil, -1
    end
    self:remove(item)
    self:positionItems()
    if self.bottomIndex == nil then
      self:scroll(true)
    end
    return item, index
  end
end

function List:clearItems()
  for index,item in ripairs(self.items) do
    self:removeItem(index)
  end
end

function List:getItem(index)
  return self.items[index]
end

function List:indexOfItem(item)
  for index,obj in ipairs(self.items) do
    if item == obj then
      return index
    end
  end
  return -1
end

function List:positionItems()
  local items = self.items
  local padding = self.itemPadding
  local border = self.borderSize
  local topIndex = self.topIndex
  local itemSize = self.itemSize
  local current
  local min
  if self.horizontal then
    current = border
    min = border + padding
  else
    current = self.height - border
    min = border + padding
  end
  local past = false
  for i,item in ipairs(items) do
    if i < topIndex or past then
      item.visible = false
    else
      item.visible = nil
      if self.horizontal then
        item.y = min
        current = current + (padding + itemSize)
        item.x = current
        if current + itemSize > self.width - borderSize then
          item.visible = false
          self.bottomIndex = i
          past = true
        end
      else
        item.x = min
        current = current - (padding + itemSize)
        item.y = current
        if current < border then
          item.visible = false
          self.bottomIndex = i
          past = true
        end
      end
    end
    item.layout = true
  end
  if not past then
    self.bottomIndex = nil
  end
  self:updateScrollBar()
end

function List:updateScrollBar()
  local maxLength
  local offset
  if self.horizontal then
    maxLength = self.width - (self.borderSize * 2 + 1)
  else
    maxLength = self.height - (self.borderSize * 2 + 1)
  end
  local topIndex = self.topIndex
  local bottomIndex = self.bottomIndex
  if bottomIndex == nil and topIndex == 1 then
    self.scrollBarLength = maxLength
    self.scrollBarOffset = 0
    self.scrollBarTick = 0
    self.scrollBarTickCount = 0
  else
    local items = self.items
    local numItems -- Number of displayed items
    if bottomIndex == nil then
      numItems = #items + 1 - topIndex
    else
      numItems = bottomIndex - topIndex
    end
    local barLength = math.max(
      numItems * maxLength / #items,
      self.scrollBarSize)
    local barTick = (maxLength - barLength) / math.max((#items - numItems), 1)
    self.scrollBarLength = barLength
    self.scrollBarOffset = (topIndex - 1) * barTick
    self.scrollBarTick = barTick
    self.scrollBarTickCount = #items - numItems
  end
end

function List:scroll(up)
  if up then
    self.topIndex = math.max(self.topIndex - 1, 1)
  else
    if self.bottomIndex then
      self.topIndex = self.topIndex + 1
    end
  end
  self:positionItems()
end

function List:clickEvent(position, button, pressed)
  if button >= 4 then -- scroll
    if pressed then
      if button == 4 then -- Scroll up
        self:scroll(true)
      else -- Scroll down
        self:scroll(false)
      end
    end
    return true
  elseif button == 1 then -- scrollbar
    local startX = self.x + self.offset[1]
    local startY = self.y + self.offset[2]
    local w = self.width
    local h = self.height
    local borderSize = self.borderSize
    local scrollBarSize = self.scrollBarSize
    local scrollBarLength = self.scrollBarLength
    
    local scrollX
    local scrollY
    local scrollWidth
    local scrollHeight
    if self.horizontal then
      scrollX = startX + borderSize
      scrollY = startY + borderSize
      scrollWidth = w - (borderSize * 2)
      scrollHeight = scrollBarSize + 1
    else
      scrollX = startX + w - borderSize - scrollBarSize - 1
      scrollY = startY + borderSize
      scrollWidth = scrollBarSize + 1
      scrollHeight = h - (borderSize * 2)
    end
    if position[1] >= scrollX and position[1] <= scrollX + scrollWidth
      and position[2] >= scrollY and position[2] <= scrollY + scrollHeight
    then -- In scroll bar area
      local barX
      local barY
      local barWidth
      local barHeight
      if self.horizontal then
        barX = scrollX + self.scrollBarOffset
        barY = scrollY
        barWidth = scrollBarLength + 1
        barHeight = scrollHeight
      else
        barX = scrollX
        barY = scrollY + scrollHeight - self.scrollBarOffset - (scrollBarLength + 1)
        barWidth = scrollWidth
        barHeight = scrollBarLength + 1
      end
      if position[1] >= barX and position[1] <= barX + barWidth
        and position[2] >= barY and position[2] <= barY + barHeight
      then -- In scroll bar
        local dragOffset
        if self.horizontal then
          dragOffset = position[1] - (barX + 0.5)
        else
          dragOffset = (barY + barHeight - 0.5) - position[2]
        end
        self.barDragOffset = dragOffset
        self.barDragging = true
      else -- In empty space
        if self.horizontal then
          if position[1] < barX then
            self.barMoving = true
          else
            self.barMoving = false
          end
        else
          if position[2] > barY + barHeight then
            self.barMoving = true
          else
            self.barMoving = false
          end
        end
      end
    end
  end
end

--------------------------------------------------------------------------------
-- Slider.lua
--------------------------------------------------------------------------------

Slider = class(Component)
Slider.lineColor = "#676767"
Slider.lineSize = 2
Slider.handleBorderColor = "#B1B1B1"
Slider.handleBorderSize = 1
Slider.handleColor = Slider.lineColor
Slider.handleHoverColor = "#A0A0A0"
Slider.handlePressedColor = "#C0C0C0"
Slider.handleSize = 5


function Slider:_init(x, y, width, height, max, step, vertical)
  Component._init(self)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.mouseOver = false
  self.max = max or 1
  self.step = step
  self.vertical = vertical
  self.value = 0
end


function Slider:update(dt)
  if self.dragging then
    if not GUI.mouseState[1] then
      self.dragging = false
    else
      local mousePos = GUI.mousePosition
      local slidableLength
      if self.vertical then
        
      else

      end
    end
  end
  if self.moving ~= nil then
    if not GUI.mouseState[1] then
      self.moving = nil
    else
      local step = self.step
      local direction = self.moving
      local max = self.max
      if not step then
        step = max / 100
      end
      local value = self.value
      if direction then
        self.value = math.min(value + step, max)
      else
        self.value = math.max(value - step, 0)
      end
    end
  end
end

function Slider:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height

  local lineSize = self.lineSize
  local lineColor = self.lineColor
  local percentage = self.value / self.max
  local handleBorderSize = self.handleBorderSize
  local handleSize = self.handleSize
  local slidableLength
  local handleBorderRect
  local handleRect
  if self.vertical then
    PtUtil.drawLine({startX + w / 2, startY},
      {startX + w / 2, startY + h}, lineColor, lineSize)
    PtUtil.drawLine({startX, startY + handleSize / 2}
      , {startX + w, startY + handleSize / 2}, lineColor, lineSize)
    PtUtil.drawLine({startX, startY + h - handleSize / 2}
      , {startX + w, startY + h - handleSize / 2}, lineColor, lineSize)
      
    slidableLength = h - lineSize * 2 - handleSize
    local sliderY = startY + lineSize + percentage * slidableLength
    handleBorderRect = {startX, sliderY, startX + w, sliderY + handleSize}
    handleRect = {startX + handleBorderSize, sliderY + handleBorderSize
                  , startX + w - handleBorderSize
                  , sliderY + handleSize - handleBorderSize}
  else
    PtUtil.drawLine({startX, startY + h / 2},
      {startX + w, startY + h / 2}, self.lineColor, self.lineSize)
    PtUtil.drawLine({startX + lineSize / 2, startY},
      {startX + lineSize / 2, startY + h}, lineColor, lineSize)
    PtUtil.drawLine({startX + w - lineSize / 2, startY},
      {startX + w - lineSize / 2, startY + h}, lineColor, lineSize)
    
    slidableLength = w - lineSize * 2 - handleSize
    local sliderX = startX + lineSize + percentage * slidableLength
    handleBorderRect = {sliderX, startY, sliderX + handleSize, startY + h}
    handleRect = {sliderX + handleBorderSize, startY + handleBorderSize
                  , sliderX + handleSize - handleBorderSize
                  , startY + h - handleBorderSize}
  end
  PtUtil.drawRect(handleBorderRect, self.handleBorderColor, handleBorderSize)
  local handleColor
  if self.dragging then
    handleColor = self.handlePressedColor
  elseif self.mouseOver then
    handleColor = self.handleHoverColor
  else
    handleColor = self.handleColor
  end
  PtUtil.fillRect(handleRect, handleColor)
end

function Slider:clickEvent(position, button, pressed)
  if button == 1 then -- Only react to LMB
    local startX = self.x + self.offset[1]
    local startY = self.y + self.offset[2]
    local w = self.width
    local h = self.height

    local lineSize = self.lineSize
    local handleSize = self.handleSize
    local percentage = self.value / self.max
    local handleX
    local handleY
    local handleWidth
    local handleHeight
    if self.vertical then
      local slidableLength = h - lineSize * 2 - handleSize
      handleX = startX
      handleY = startY + lineSize + percentage * slidableLength
      handleWidth = w
      handleHeight = handleSize
    else
      local slidableLength = w - lineSize * 2 - handleSize
      handleX = startX + lineSize + percentage * slidableLength
      handleWidth = handleSize
      handleHeight = h
    end
    if position[1] >= handleX and position[1] <= handleX + handleWidth
      and position[2] >= handleY and position[2] <= handleY + handleHeight
    then
      local dragOffset
      if self.vertical then
        dragOffset = position[2] - handleY
      else
        dragOffset = position[1] - handleX
      end
      self.dragOffset = dragOffset
      self.dragging = true
    else
      if self.vertical then
        if position[2] < barY then
          self.moving = false
        else
          self.moving = true
        end
      else
        if position[1] < barX then
          self.moving = false
        else
          self.moving = true
        end
      end
    end
  end
end