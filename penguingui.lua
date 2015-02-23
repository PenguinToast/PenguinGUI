-- "version": "Beta v. Upbeat Giraffe",
-- "author": "PenguinToast",
-- "version": "0.4",
-- "support_url": "http://penguintoast.github.io/PenguinGUI"
-- This script contains all the scripts in this library, so you only need to
-- include this script for production purposes.

--------------------------------------------------------------------------------
-- Util.lua
--------------------------------------------------------------------------------

PtUtil = {}
PtUtil.charWidths = {6, 6, 6, 6, 6, 6, 6, 6, 0, 0, 6, 6, 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 4, 8, 12, 10, 12, 12, 4, 6, 6, 8, 8, 6, 8, 4, 12, 10, 6, 10, 10, 10, 10, 10, 10, 10, 10, 4, 4, 8, 8, 8, 10, 12, 10, 10, 8, 10, 8, 8, 10, 10, 8, 10, 10, 8, 12, 10, 10, 10, 10, 10, 10, 8, 10, 10, 12, 10, 10, 8, 6, 12, 6, 8, 10, 6, 10, 10, 9, 10, 10, 8, 10, 10, 4, 6, 9, 4, 12, 10, 10, 10, 10, 8, 10, 8, 10, 10, 12, 8, 10, 10, 8, 4, 8, 10, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 5, 6, 10, 10, 15, 10, 5, 13, 7, 14, 15, 15, 10, 6, 14, 12, 16, 14, 7, 7, 6, 11, 12, 8, 7, 6, 16, 16, 15, 15, 15, 10, 10, 10, 10, 10, 10, 10, 14, 10, 8, 8, 8, 8, 8, 8, 8, 8, 13, 10, 10, 10, 10, 10, 10, 10, 13, 10, 10, 10, 10, 10, 14, 11, 10, 10, 10, 10, 10, 10, 15, 9, 10, 10, 10, 10, 8, 8, 8, 8, 12, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 15, 10}

function PtUtil.library()
  return {
    "/penguingui/Util.lua",
    "/penguingui/Binding.lua",
    "/penguingui/BindingFunctions.lua",
    "/penguingui/GUI.lua",
    "/penguingui/Toolkit.lua",
    "/penguingui/tablelayout/TableLayout.lua",
    "/penguingui/tablelayout/Cell.lua",
    "/lib/profilerapi.lua",
    "/lib/inspect.lua"
  }
end

function PtUtil.drawText(text, options, fontSize, color)
  fontSize = fontSize or 16
  if text:byte() == 32 then -- If it starts with a space, offset the string
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
  local len = #text
  for i=1,len,1 do
    out = out + widths[string.byte(text, i)]
  end
  return out * scale
end

function PtUtil.getFontScale(size)
  return size / 16
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
    local instance = t._instance
    if instance._getters then
      local getter = instance._getters[k]
      if getter then
        return getter(instance, k, instance[k])
      end
    end
    local out = instance[k]
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
      component:removeSelf()
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
    if component.visible ~= false then
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
end

function GUI.clickEventHelper(component, position, button, pressed)
  local children = component.children
  for _,child in ripairs(children) do
    if child.visible ~= false then
      if GUI.clickEventHelper(child, position, button, pressed) then
        return true
      end
    end
  end
  if component.clickEvent then
    if component:contains(position) then
      if component:clickEvent(position, button, pressed) then
        GUI.setFocusedComponent(component)
        return true
      end
    end
  end
end

function GUI.keyEvent(key, pressed)
  GUI.keyState[key] = pressed
  local component = GUI.focusedComponent
  while component do
    if component.visible ~= false then
      local keyEvent = component.keyEvent
      if keyEvent then
        if keyEvent(component, key, pressed) then
          return
        end
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
-- Toolkit.lua
--------------------------------------------------------------------------------

Toolkit = {]

local _ENV = Toolkit

function obtainCell(layout)
  local cell = Cell()
  cell:setLayout(layout)
  return cell
end

function freeCell(cell)
end

function addChild(parent, child)
  parent:add(child)
end

function removeChild(parent, child)
  parent:remove(child)
end

function getMinWidth(widget)
  return widget:getMinWidth()
end

function getMinHeight(widget)
  return widget:getMinHeight()
end

function getPrefWidth(widget)
  return widget:getPrefWidth()
end

function getPrefHeight(widget)
  return widget:getPrefHeight()
end

function getMaxWidth(widget)
  return widget:getMaxWidth()
end

function getMaxHeight(widget)
  return widget:getMaxHeight()
end

function getWidth(widget)
  return widget:getWidth()
end

function getHeight(widget)
  return widget:getHeight()
end

function clearDebugRectangles(layout)
end

function addDebugRectangles(layout, type, x, y, w, h)
end

--------------------------------------------------------------------------------
-- TableLayout.lua
--------------------------------------------------------------------------------


TableLayout = class()

local bit32 = bit32
local _ENV = TableLayout

local NULL = {}

CENTER = bit32.lshift(1, 0)
TOP = bit32.lshift(1, 1)
BOTTOM = bit32.lshift(1, 2)
LEFT = bit32.lshift(1, 3)
RIGHT = bit32.lshift(1, 4)

Debug = {
  NONE = 0,
  ALL = 1,
  TABLE = 2,
  CELL = 3,
  WIDGET = 4
}

local CENTER = CENTER
local TOP = TOP
local BOTTOM = BOTTOM
local LEFT = LEFT
local RIGHT = RIGHT
local Debug = Debug

function _init(self, toolkit)
  self.tableWidget = nil
  self.columns = 0
  self.rows = 0
  
  self.cells = {}
  self.cellDefaults = nil
  self.columnDefaults = {}
  self.rowDefaults = nil

  self.sizeInvalid = true
  self.columnMinWidth = {}
  self.rowMinHeight = {}
  self.columnPrefWidth = {}
  self.rowPrefHeight = {}
  self.tableMinWidth = 0
  self.tableMinHeight = 0
  self.tablePrefWidth = 0
  self.tablePrefHeight = 0
  self.columnWidth = {}
  self.rowHeight = {}
  self.expandWidth = {}
  self.expandHeight = {}
  self.columnWeightedWidth = {}
  self.rowWeightedHeight = {}

  self._padTop = nil
  self._padLeft = nil
  self._padBottom = nil
  self._padRight = nil
  self._align = CENTER
  self._debug = Debug.NONE 
  
  self.toolkit = toolkit or Toolkit
  self.cellDefaults = toolkit.obtainCell(self)
  self.cellDefaults:defaults()
end

function invalidate(self)
  self.sizeInvalid = true
end

function invalidateHierarchy(self)
end

function add(self, widget)
  local cells = self.cells
  local cell = self.toolkit.obtainCell(self)
  cell.widget = widget

  if #cells > 0 then
    local lastCell = cells[#cells]
    if not lastCell.endRow then
      cell._column = lastCell._column + lastCell._colspan
      cell._row = lastCell._row
    else
      cell._column = 1
      cell._row = lastCell._row + 1
    end
    if cell._row > 1 then
      for i=#cells,1,-1 do
        local other = cells[i]
        local column = other._column
        local nn = column + other._colspan
        while column < nn do
          if column == cell._column then
            cell.cellAboveIndex = i
            goto outer
          end
          column = column + 1
        end
      end
      ::outer::
    end
  else
    cell._column = 1
    cell._row = 1
  end
  table.insert(cells, cell)

  cell:set(self.cellDefaults)
  if cell._column <= #self.columnDefaults then
    local columnCell = self.columnDefaults[cell._column]
    if columnCell ~= NULL and columnCell ~= nil then
      cell:merge(columnCell)
    end
  end
  cell:merge(self.rowDefaults)

  if widget ~= nil then
    self.toolkit.addChild(self.tableWidget, widget)
  end

  return cell
end

function row(self)
  if #cells > 0 then
    self:endRow()
  end
  if self.rowDefaults ~= nil then
    self.toolkit.freeCell(self.rowDefaults)
  end
  self.rowDefaults = toolkit.obtainCell(self)
  self.rowDefaults:clear()
  return self.rowDefaults
end

function endRow(self)
  local cells = self.cells
  local rowColumns = 0
  for i=#cells,1,-1 do
    local cell = cells[i]
    if cell.endRow then
      break
    end
    rowColumns = rowColumns + cell._colspan
  end
  self.columns = math.max(self.columns, rowColumns)
  self.rows = self.rows + 1
  cells[#cells].endRow = true
  self:invalidate()
end

function columnDefaults(self, column)
  local cell = #self.columnDefaults >= column and
    self.columnDefaults[column] or nil
  if cell == nil or cell == NULL then
    cell = self.toolkit.obtainCell(self)
    cell:clear()
    if column > #self.columnDefaults then
      for i=#self.columnDefaults,column-2,1 do
        table.insert(self.columnDefaults, NULL)
      end
      table.insert(self.columnDefaults, cell)
    else
      self.columnDefaults[column] = cell
    end
  end
  return cell
end

function reset(self)
  self:clear()
  self._padTop = nil
  self._padLeft = nil
  self._padBottom = nil
  self._padRight = nil
  self._align = CENTER
  if self._debug ~= Debug.NONE then
    self.toolkit.clearDebugRectangles(self)
  end
  self._debug = Debug.NONE
  self.cellDefaults:defaults()
  local i = 1
  local n = #self.columnDefaults
  while i <= n do
    local columnCell = self.columnDefaults[i]
    if columnCell ~= NULL and columnCell ~= nil then
      self.toolkit.freeCell(columnCell)
    end
    i = i + 1
  end
  self.columnDefaults = {}
end

function clear(self)
  for i=#self.cells,1,-1 do
    local cell = self.cells[i]
    local widget = cell.widget
    if widget ~= nil then
      self.toolkit.removeChild(self.tableWidget, widget)
    end
    self.toolkit.freeCell(cell)
  end
  self.cells = {}
  self.rows = 0
  self.columns = 0
  if self.rowDefaults ~= nil then
    self.toolkit.freeCell(self.rowDefaults)
  end
  self.rowDefaults = nil
  self:invalidate()
end

function getCell(self, widget)
  local n = #self.cells
  for i=1,n,1 do
    local c = self.cells[i]
    if c.widget == widget then
      return c
    end
  end
  return nil
end

function getCells(self)
  return self.cells
end

function setToolkit(self, toolkit)
  self.toolkit = toolkit
end

function getTable(self)
  return self.tableWidget
end

function setTable(self, table)
  self.tableWidget = table
end

function getMinWidth(self)
  if self.sizeInvalid then
    self:computeSize()
  end
  return self.tableMinWidth
end

function getMinHeight(self)
  if self.sizeInvalid then
    self:computeSize()
  end
  return self.tableMinHeight
end

function getPrefWidth(self)
  if self.sizeInvalid then
    self:computeSize()
  end
  return self.tablePrefWidth
end

function getPrefHeight(self)
  if self.sizeInvalid then
    self:computeSize()
  end
  return self.tablePrefHeight
end

function defaults(self)
  return self.cellDefaults
end

function pad(self, pad)
  self._padTop = pad
  self._padLeft = pad
  self._padBottom = pad
  self._padRight = pad
  self.sizeInvalid = true
  return self
end

function pad(self, top, left, bottom, right)
  self._padTop = top
  self._padLeft = left
  self._padBottom = bottom
  self._padRight = right
  self.sizeInvalid = true
  return self
end

function padTop(self, padTop)
  self._padTop = padTop
  self.sizeInvalid = true
  return self
end

function padLeft(self, padLeft)
  self._padLeft = padLeft
  self.sizeInvalid = true
  return self
end

function padBottom(self, padBottom)
  self._padBottom = padBottom
  self.sizeInvalid = true
  return self
end

function padRight(self, padRight)
  self._padRight = padRight
  self.sizeInvalid = true
  return self
end

function align(self, align)
  self._align = align
  return self
end

function center(self)
  self._align = CENTER
  return self
end

function top(self)
  self._align = bit32.bor(self._align, TOP)
  self._align = bit32.band(self._align, bit32.bnot(BOTTOM))
  return self
end

function left(self)
  self._align = bit32.bor(self._align, LEFT)
  self._align = bit32.band(self._align, bit32.bnot(RIGHT))
  return self
end

function bottom(self)
  self._align = bit32.bor(self._align, BOTTOM)
  self._align = bit32.band(self._align, bit32.bnot(TOP))
  return self
end

function right(self)
  self._align = bit32.bor(self._align, RIGHT)
  self._align = bit32.band(self._align, bit32.bnot(LEFT))
  return self
end

function debugTable(self)
  self._debug = Debug.TABLE
  self:invalidate()
  return self
end

function debugCell(self)
  self._debug = Debug.CELL
  self:invalidate()
  return self
end

function debugWidget(self)
  self._debug = Debug.WIDGET
  self:invalidate()
  return self
end

function debug(self, debug)
  if debug == nil then
    self._debug = Debug.ALL
    self:invalidate()
  else
    self._debug = debug
    if debug == Debug.NONE then
      self.toolkit.clearDebugRectangles(self)
    else
      self:invalidate()
    end
  end
  return self
end

function getDebug(self)
  return self._debug
end

function getPadTop(self)
  return self._padTop
end

function getPadLeft(self)
  return self._padLeft
end

function getPadBottom(self)
  return self._padBottom
end

function getPadRight(self)
  return self._padRight
end

function getAlign()
  return self._align
end

function getRow(self, y)
  local row = 0
  y = y + self._padTop
  local i = 1
  local n = #self.cells
  if n == 0 then
    return -1
  end
  if n == 1 then
    return 1
  end
  while i <= n do
    local c = self.cells[i]
    i = i + 1
    if c:getIgnore() then
    else
      if c.widgetY + c.computedPadTop < y then
        break
      end
      if c.endRow then
        row = row + 1
      end
    end
  end
  return row
end

function ensureSize(array, size)
  if array == nil or #array < size then
    local out = {}
    for i=1,size,1 do
      out[i] = 0
    end
    return out
  end
  local n = #array
  for i=1,n,1 do
    array[i] = 0
  end
  return array
end

function computeSize(self)
  self.sizeInvalid = false

  local toolkit = self.toolkit
  local cells = self.cells

  if #cells > 0 and not cells[#cells].endRow then
    self:endRow()
  end

  local columnMinWidth = ensureSize(self.columnMinWidth, columns)
  self.columnMinWidth = columnMinWidth
  local rowMinHeight = ensureSize(self.rowMinHeight, rows)
  self.rowMinHeight = rowMinHeight
  local columnPrefWidth = ensureSize(self.columnPrefWidth, columns)
  self.columnPrefWidth = columnPrefWidth
  local rowPrefHeight = ensureSize(self.rowPrefHeight, rows)
  self.rowPrefHeight = rowPrefHeight
  local columnWidth = ensureSize(self.columnWidth, columns)
  self.columnWidth = columnWidth
  local rowHeight = ensureSize(self.rowHeight, rows)
  self.rowHeight = rowHeight
  local expandWidth = ensureSize(self.expandWidth, columns)
  self.expandWidth = expandWidth
  local expandHeight = ensureSize(self.expandHeight, rows)
  self.expandHeight = expandHeight

  local spaceRightLast = 0
  local n = #cells
  for i=1,n,1 do
    local c = cells[i]
    if not c._ignore then

      if c._expandY ~= 0 and expandHeight[c._row] == 0 then
        expandHeight[c._row] = c.expandY
      end
      if c._colspan == 1 and c._expandX ~= 0 and expandWidth[c._column] == 0 then
        expandWidth[c._column] = c.expandX
      end

      c.computedPadLeft = c._padLeft +
        (c._column == 1 and 0 or math.max(0, c._spaceLeft - spaceRightLast))
      c.computedPadTop = c._padTop
      if c.cellAboveIndex ~= -1 then
        local above = cells[c.cellAboveIndex]
        c.computedPadTop = c.computedPadTop +
          math.max(0, c._spaceTop - above.spaceBottom)
      end
      local spaceRight = c.spaceRight
      c.computedPadRight = c._padRight +
        ((c._column + c._colspan) == columns + 1 and 0 or spaceRight)
      c.computedPadBottom = c._padBottom + (c._row == rows and 0 or c.spaceBottom)
      spaceRightLast = spaceRight

      local prefWidth = c.prefWidth
      local prefHeight = c.prefHeight
      local minWidth = c.minWidth
      local minHeight = c.minHeight
      local maxWidth = c.maxWidth
      local maxHeight = c.maxHeight
      if prefWidth < minWidth then
        prefWidth = minWidth
      end
      if prefHeight < minHeight then
        prefHeight = minHeight
      end
      if maxWidth > 0 and prefWidth > maxWidth then
        prefWidth = maxWidth
      end
      if maxHeight > 0 and prefHeight > maxHeight then
        prefHeight = maxHeight
      end

      if c._colspan == 1 then
        local hpadding = c.computedPadLeft + c.computedPadRight
        columnPrefWidth[c._column] = math.max(columnPrefWidth[c.column],
                                             prefWidth + hpadding)
        columnMinWidth[c._column] = math.max(columnMinWidth[c.column],
                                            minWidth + hpadding)
      end
      local vpadding = c.computedPadTop + c.computedPadBottom
      rowPrefHeight[c._row] = math.max(rowPrefHeight[c.row],
                                      prefHeight + vpadding)
      rowMinHeight[c._row] = math.max(rowMinHeight[c.row],
                                     minHeight + vpadding)
    end
  end

  for i=1,n,1 do
    local c = cells[i]
    if not (c._ignore or c._expandX == 0) then
      local nn = c._column + c.colspan
      for column=c._column,nn,1 do
        if expandWidth[column] ~= 0 then
          goto continue2
        end
      end
      nn = column + c.colspan
      for column=c._column,nn,1 do
        expandWidth[column] = c.expandX
      end
    end
  end

  for i=1,n,1 do
    local c = cells[i]
    if not (c._ignore or c._colspan == 1) then
      local minWidth = c.minWidth
      local prefWidth = c.prefWidth
      local maxWidth = c.maxWidth
      if prefWidth < minWidth then
        prefWidth = minWidth
      end
      if maxWidth > 0 and prefWidth > maxWidth then
        prefWidth = maxWidth
      end

      local spannedMinWidth = -(c.computedPadLeft + c.computedPadRight)
      local spannedPrefWidth = spannedMinWidth
      local nn = c._column + c.colspan
      for column=c._column,nn,1 do
        spannedMinWidth = spannedMinWidth + columnMinWidth[column]
        spannedPrefWidth = spannedPrefWidth + columnPrefWidth[column]
      end

      local totalExpandWidth = 0
      nn = column + c.colspan
      for column=c._column,nn,1 do
        totalExpandWidth = totalExpandWidth + column
      end

      local extraMinWidth = math.max(0, minWidth - spannedMinWidth)
      local extraPrefWidth = math.max(0, prefWidth - spannedPrefWidth)
      nn = column + c.colspan
      for column=c._column,nn,1 do
        local ratio = totalExpandWidth == 0 and 1 / c._colspan or
          expandWidth[column] / totalExpandWidth
        columnMinWidth[column] = columnMinWidth[column] + extraMinWidth * ratio
        columnPrefWidth[column] = columnPrefWidth[column] + extraPrefWidth
          * ratio
      end
    end
  end

  local uniformMinWidth = 0
  local uniformMinHeight = 0
  local uniformPrefWidth = 0
  local uniformPrefHeight = 0
  for i=1,n,1 do
    local c = cells[i]
    if not c._ignore then
      if c._uniformX == true and c._colspan == 1 then
        local hpadding = c.computedPadLeft + c.computedPadRight
        uniformMinWidth = math.max(uniformMinWidth, columnMinWidth[c._column] -
                                     hpadding)
        uniformPrefWidth = math.max(uniformPrefWidth, columnPrefWidth[c._column] -
                                      hpadding)
      end
      if c._uniformY == true then
        local vpadding = c.computedPadTop + c.computedPadBottom
        uniformMinHeight = math.max(uniformMinHeight, columnMinHeight[c._column] -
                                      vpadding)
        uniformPrefHeight = math.max(uniformPrefHeight,
                                     columnPrefHeight[c._column] - vpadding)
      end
    end
  end

  if uniformPrefWidth > 0 or uniformPrefHeight > 0 then
    for i=1,n,1 do
      local c = cells[i]
      if not c._ignore then
        if uniformPrefWidth > 0 and c._uniformX == true and c._colspan == 1 then
          local hpadding = c.computedPadLeft + c.computedPadRight
          columnMinWidth[c._column] = uniformMinWidth + hpadding
          columnPrefWidth[c._column] = uniformPrefWidth + hpadding
        end
        if uniformPrefHeight > 0 and c._uniformY == true then
          local vpadding = c.computedPadTop + c.computedPadBottom
          rowMinHeight[c._column] = uniformMinHeight + vpadding
          rowPrefHeight[c._column] = uniformPrefHeight + vpadding
        end
      end
    end
  end

  self.tableMinWidth = 0
  self.tableMinHeight = 0
  self.tablePrefWidth = 0
  self.tablePrefHeight = 0
  for i=1,columns,1 do
    self.tableMinWidth = self.tableMinWidth + columnMinWidth[i]
    self.tablePrefWidth = self.tablePrefWidth + columnPrefWidth[i]
  end
  for i=1,rows,1 do
    self.tableMinHeight = self.tableMinHeight + rowMinHeight[i]
    self.tablePrefHeight = self.tablePrefHeight + math.max(
      rowPrefHeight[i], rowMinHeight[i])
  end
  local hpadding = self._padLeft + self._padRight
  local vpadding = self._padTop + self._padBottom
  self.tableMinWidth = self.tableMinWidth + hpadding
  self.tableMinHeight = self.tableMinHeight + vpadding
  self.tablePrefWidth = math.max(self.tablePrefWidth + hpadding,
                                 self.tableMinWidth)
  self.tablePrefHeight = math.max(self.tablePrefHeight + vpadding,
                                  self.tableMinHeight)
end

function layout(self, layoutX, layoutY, layoutWidth, layoutHeight)
  local toolkit = self.toolkit
  local cells = self.cells

  if layoutX == nil then
    layoutX = 
  end

  if self.sizeInvalid then
    self:computeSize()
  end

  local hpadding = self._padLeft + self._padRight
  local vpadding = self._padTop + self._padBottom

  local totalExpandWidth = 0
  local totalExpandHeight = 0
  for i=1,self.columns,1 do
    totalExpandWidth = totalExpandWidth + self.expandWidth[i]
  end
  for i=1,self.rows,1 do
    totalExpandHeight = totalExpandHeight + self.expandHeight[i]
  end

  local columnWeightedWidth
  local totalGrowWidth = self.tablePrefWidth - self.tableMinWidth
  if totalGrowWidth == 0 then
    self.columnWeightedWidth = self.columnMinWidth
  else
    local extraWidth = math.min(totalGrowWidth,
                                math.max(0,
                                         layoutWidth - self.tableMinWidth))
    columnWeightedWidth = ensureSize(self.columnWeightedWidth, columns)
    self.columnWeightedWidth = columnWeightedWidth
    for i=1,columns,1 do
      local growWidth = self.columnPrefWidth[i] - self.columnMinWidth[i]
      local growRatio = growWidth / totalGrowWidth
      self.columnWeightedWidth[i] = self.columnMinWidth[i] +
        extraWidth * growRatio
    end
  end

  local rowWeightedHeight
  local totalGrowHeight = self.tablePrefHeight - self.tableMinHeight
  if totalGrowHeight == 0 then
    self.rowWeightedHeight = self.rowMinHeight
  else
    local extraHeight = math.min(totalGrowHeight,
                                 math.max(0,
                                          layoutHeight - self.tableMinHeight))
    rowWeightedHeight = ensureSize(self.rowWeightedHeight, rows)
    self.rowWeightedHeight = rowWeightedHeight
    for i=1,rows,1 do
      local growHeight = self.rowPrefHeight[i] - self.rowMinHeight[i]
      local growRatio = growHeight / totalGrowHeight
      self.rowWeightedHeight[i] = self.rowMinHeight[i] +
        extraHeight * growRatio
    end
  end

  local n = #cells
  for i=1,n,1 do
    local c = cells[i]
    if not c._ignore then
      local spannedWeightedWidth = 0
      local nn = c._column + c.colspan
      for column=c._column,nn,1 do
        spannedWeightedWidth = spannedWeightedWidth +
          self.columnWeightedWidth[column]
      end
      local weightedHeight = self.rowWeightedHeight[c.row]

      local prefWidth = c.prefWidth
      local prefHeight = c.prefHeight
      local minWidth = c.minWidth
      local minHeight = c.minHeight
      local maxWidth = c.maxWidth
      local maxHeight = c.maxHeight
      if prefWidth < minWidth then
        prefWidth = minWidth
      end
      if prefHeight < minHeight then
        prefHeight = minHeight
      end
      if maxWidth > 0 and prefWidth > maxWidth then
        prefWidth = maxWidth
      end
      if maxHeight > 0 and prefHeight > maxHeight then
        prefHeight = maxHeight
      end

      c.widgetWidth = math.min(spannedWeightedWidth - c.computedPadLeft -
                                 c.computedPadRight, prefWidth)
      c.widgetHeight = math.min(spannedWeightedHeight - c.computedPadTop -
                                  c.computedPadBottom, prefHeight)

      if c._colspan == 1 then
        self.columnWidth[c._column] = math.max(self.columnWidth[c.column],
                                              spannedWeightedWidth)
      end
      self.rowHeight[c._row] = math.max(self.rowHeight[c._row], weightedHeight)
    end
  end

  if totalExpandWidth > 0 then
    local extra = layoutWidth - hpadding
    for i=1,self.columns,1 do
      extra = extra - self.columnWidth[i]
    end
    local used = 0
    local lastIndex = 0
    for i=1,self.columns,i do
      if self.expandWidth[i] ~= 0 then
        local amount = extra * self.expandWidth[i] / totalExpandWidth
        self.columnWidth[i] = self.columnWidth[i] + amount
        used = used + amount
        lastIndex = i
      end
    end
    self.columnWidth[lastIndex] = self.columnWidth[lastIndex] + extra - used
  end
  if totalExpandHeight > 0 then
    local extra = layoutHeight - vpadding
    for i=1,self.rows,1 do
      extra = extra - self.rowHeight[i]
    end
    local used = 0
    local lastIndex = 0
    for i=1,self.rows,i do
      if self.expandHeight[i] ~= 0 then
        local amount = extra * self.expandHeight[i] / totalExpandHeight
        self.rowHeight[i] = self.rowHeight[i] + amount
        used = used + amount
        lastIndex = i
      end
    end
    self.rowHeight[lastIndex] = self.rowHeight[lastIndex] + extra - used
  end

  for i=1,n,1 do
    local c = cells[i]
    if not c._ignore and c._colspan ~= 1 then
      local extraWidth = 0
      local nn = c._column + c.colspan
      for column=c._column,nn,1 do
        extraWidth = extraWidth + self.columnWeightedWidth[column] -
          self.columnWidth[column]
      end
      extraWidth = extraWidth - math.max(0, c.computedPadLeft +
                                           c.computedPadRight)

      extraWidth = extraWidth / c.colspan
      if extraWidth > 0 then
        for column=c._column,nn,1 do
          self.columnWidth[column] = self.columnWidth[column] + extraWidth
        end
      end
    end
  end

  local tableWidth = hpadding
  local tableHeight = vpadding
  for i=1,self.columns,1 do
    tableWidth = tableWidth + self.columnWidth[i]
  end
  for i=1,self.rows,1 do
    tableHeight = tableHeight + self.rowHeight[i]
  end

  local x = layoutX + self._padLeft
  if bit32.band(self._align, RIGHT) ~= 0 then
    x = x + layoutWidth - tableWidth
  elseif bit32.band(self._align, LEFT) == 0 then -- Center
    x = x + (layoutWidth - tableWidth) / 2
  end

  local y = layoutY + self._padLeft
  if bit32.band(self._align, BOTTOM) ~= 0 then
    y = y + layoutHeight - tableHeight
  elseif bit32.band(self._align, TOP) == 0 then -- Center
    y = y + (layoutHeight - tableHeight) / 2
  end

  local currentX = x
  local currentY = y
  for i=1,n,1 do
    local c = cells[i]
    if not c._ignore then
      local spannedCellWidth = 0
      local nn = c._column + c.colspan
      for column=c._column,nn,1 do
        spannedCellWidth = spannedCellWidth + self.columnWidth[column]
      end
      spannedCellWidth = spannedCellWidth -
        (c.computedPadLeft + c.computedPadRight)

      currentX = currentX + c.computedPadLeft

      if c._fillX > 0 then
        c.widgetWidth = spannedCellWidth * c.fillX
        local maxWidth = c.maxWidth
        if maxWidth > 0 then
          c.widgetWidth = math.min(c.widgetWidth, maxWidth)
        end
      end
      if c._fillY > 0 then
        c.widgetHeight = self.rowHeight[c._row] * c._fillY - c.computedPadTop -
          c.computedPadBottom
        local maxHeight = c.maxHeight
        if maxHeight > 0 then
          c.widgetHeight = math.min(c.widgetHeight, maxHeight)
        end
      end

      if bit32.band(c._align, LEFT) ~= 0 then
        c.widgetX = currentX
      elseif bit32.band(c._align, RIGHT) ~= 0 then
        c.widgetX = currentX + spannedCellWidth - c.widgetWidth
      else
        c.widgetX = currentX + (spannedCellWidth - c.widgetWidth) / 2
      end

      if bit32.band(c._align, TOP) ~= 0 then
        c.widgetY = currentY + c.computedPadTop
      elseif bit32.band(c._align, BOTTOM) ~= 0 then
        c.widgetY = currentY + self.rowHeight[c._row] - c.widgetHeight -
          c.computedPadBottom
      else
        c.widgetY = currentY + (self.rowHeight[c._row] - c.widgetHeight +
                                  c.computedPadTop - c.computedPadBottom) / 2
      end

      if c.endRow then
        currentX = x
        currentY = currentY + self.rowHeight[c.row]
      else
        currentX = currentX + spannedCellWidth + c.computedPadRight
      end
    end
  end

  if self._debug == Debug.NONE then
    return
  end
  toolkit.clearDebugRectangles(self)
  currentX = x
  currentY = y
  if self._debug == Debug.TABLE or self._debug == Debug.ALL then
    toolkit.addDebugRectangle(self, Debug.TABLE, layoutX, layoutY, layoutWidth,
                              layoutHeight)
    toolkit.addDebugRectangle(self, Debug.TABLE, x, y, tableWidth - hpadding,
                              tableHeight - vpadding)
  end
  for i=1,n,1 do
    local c = cells[i]
    if not c._ignore then
      if self._debug == Debug.WIDGET or self._debug == Debug.ALL then
        toolkit.addDebugRectangle(self, Debug.WIDGET, c.widgetX, c.widgetY,
                                  c.widgetWidth, c.widgetHeight)
      end

      local spannedCellWidth = 0
      local nn = c._column + c.colspan
      for column=c._column,nn,1 do
        spannedCellWdith = spannedCellWidth + self.columnWidth[column]
      end
      spannedCellWidth = spannedCellWidth - (c.computedPadLeft +
                                               c.computedPadRight)
      currentX = currentX + c.computedPadLeft
      if self._debug == Debug.CELL or self._debug == Debug.ALL then
        toolkit.addDebugRectangle(self, Debug.CELL, currentX, currentY +
                                    c.computedPadTop, spannedCellWidth,
                                  self.rowHeight[c._row] - c.computedPadTop -
                                    c.computedPadBottom)
      end

      if c.endRow then
        currentX = x
        currentY = currentY + self.rowHeight[c._row]
      else
        currentX = currentX + spannedCellWidth + c.computedPadRight
      end
    end
  end

  
end

--------------------------------------------------------------------------------
-- Cell.lua
--------------------------------------------------------------------------------

Cell = class()

local bit32 = bit32
local _ENV = Cell

CENTER = bit32.lshift(1, 0)
TOP = bit32.lshift(1, 1)
BOTTOM = bit32.lshift(1, 2)
LEFT = bit32.lshift(1, 3)
RIGHT = bit32.lshift(1, 4)

local CENTER = CENTER
local TOP = TOP
local BOTTOM = BOTTOM
local LEFT = LEFT
local RIGHT = RIGHT

function getFunctionValue(self, k, v)
  if type(v) == "function" then
    return v(self, k, v)
  else
    return v
  end
end

_getters = {
  _minWidth = getFunctionValue,
  _minHeight = getFunctionValue,
  _prefWidth = getFunctionValue,
  _prefHeight = getFunctionValue,
  _maxWidth = getFunctionValue,
  _maxHeight = getFunctionValue
}

function _init(self)
  self._minWidth = 0
  self._minHeight = 0
  self._prefWidth = 0
  self._prefHeight = 0
  self._maxWidth = 0
  self._maxHeight = 0
  self._spaceTop = 0
  self._spaceLeft = 0
  self._spaceBottom = 0
  self._spaceRight = 0
  self._padTop = 0
  self._padLeft = 0
  self._padBottom = 0
  self._padRight = 0

  self._fillX = 0
  self._fillY = 0
  self._align = 0
  self._expandX = 0
  self._expandY = 0
  self._ignore = false
  self._colspan = 0
  self._uniformX = false
  self._uniformY = false

  self.widget = nil
  self.widgetX = 0
  self.widgetY = 0
  self.widgetWidth = 0
  self.widgetHeighat = 0

  self.layout = nil
  self.endRow = false
  self._column = 0
  self._row = 0
  self.cellAboveIndex = -1
  self.computedPadTop = 0
  self.computedPadLeft = 0
  self.computedPadBottom = 0
  self.computedPadRight = 0
end

function set(self, defaults)
  self._minWidth = defaults._minWidth
  self._minHeight = defaults._minHeight
  self._prefWidth = defaults._prefWidth
  self._prefHeight = defaults._prefHeight
  self._maxWidth = defaults._maxWidth
  self._maxHeight = defaults._maxHeight
  self._spaceTop = defaults._spaceTop
  self._spaceLeft = defaults._spaceLeft
  self._spaceBottom = defaults._spaceBottom
  self._spaceRight = defaults._spaceRight
  self._padTop = defaults._padTop
  self._padLeft = defaults._padLeft
  self._padBottom = defaults._padBottom
  self._padRight = defaults._padRight
  self._fillX = defaults._fillX
  self._fillY = defaults._fillY
  self._align = defaults._align
  self._expandX = defaults._expandX
  self._expandY = defaults._expandY
  self._ignore = defaults._ignore
  self._colspan = defaults._colspan
  self._uniformX = defaults._uniformX
  self._uniformY = defaults._uniformY
end

function merge(self, cell)
  if not cell then
    return
  end
  self._minWidth = cell._minWidth or self._minWidth
  self._minHeight = cell._minHeight or self._minHeight
  self._prefWidth = cell._prefWidth or self._prefWidth
  self._prefHeight = cell._prefHeight or self._prefHeight
  self._maxWidth = cell._maxWidth or self._maxWidth
  self._maxHeight = cell._maxHeight or self._maxHeight
  self._spaceTop = cell._spaceTop or self._spaceTop
  self._spaceLeft = cell._spaceLeft or self._spaceLeft
  self._spaceBottom = cell._spaceBottom or self._spaceBottom
  self._spaceRight = cell._spaceRight or self._spaceRight
  self._padTop = cell._padTop or self._padTop
  self._padLeft = cell._padLeft or self._padLeft
  self._padBottom = cell._padBottom or self._padBottom
  self._padRight = cell._padRight or self._padRight
  self._fillX = cell._fillX or self._fillX
  self._fillY = cell._fillY or self._fillY
  self._align = cell._align or self._align
  self._expandX = cell._expandX or self._expandX
  self._expandY = cell._expandY or self._expandY
  if cell._ignore ~= nil then
    self._ignore = cell._ignore
  end
  self._colspan = cell._colspan or self._colspan
  if cell._uniformX ~= nil then
    self._uniformX = cell._uniformX
  end
  if cell._uniformY ~= nil then
    self._uniformY = cell._uniformY
  end
end

function setWidget(self, widget)
  self.layout.toolkit.setWidget(self.layout, self, widget)
  return self
end

function getWidget(self)
  return self.widget
end

function hasWidget(self)
  return self.widget ~= nil
end

function size(self, width, height)
  if height == nil then
    height = width
  end
  self._minWidth = width
  self._minHeight = height
  self._prefWidth = width
  self._prefHeight = height
  self._maxWidth = width
  self._maxHeight = height
  return self
end

function width(self, width)
  self._minWidth = width
  self._prefWidth = width
  self._maxWidth = width
  return self
end

function height(self, height)
  self._minHeight = height
  self._prefHeight = height
  self._maxHeight = height
  return self
end

function minSize(self, width, height)
  self._minWidth = width
  self._minHeight = height or width
  return self
end

function minWidth(self, width)
  self._minWidth = width
  return self
end

function minHeight(self, height)
  self._minHeight = height
  return self
end

function prefSize(self, width, height)
  self._prefWidth = width
  self._prefHeight = height or width
  return self
end

function prefWidth(self, width)
  self._prefWidth = width
  return self
end

function prefHeight(self, height)
  self._prefHeight = height
  return self
end

function maxSize(self, width, height)
  self._maxWidth = width
  self._maxHeight = width or height
  return self
end

function maxWidth(self, width)
  self._maxWidth = width
  return self
end

function maxHeight(self, height)
  self._maxHeight = height
  return self
end

function space(self, top, left, bottom, right)
  self._spaceTop = top
  self._spaceLeft = left or top
  self._spaceBottom = bottom or top
  self._spaceRight = right or top
  return self
end

function spaceTop(self, space)
  self._spaceTop = space
  return self
end

function spaceLeft(self, space)
  self._spaceLeft = space
  return self
end

function spaceBottom(self, space)
  self._spaceBottom = space
  return self
end

function spaceRight(self, space)
  self._spaceRight = space
  return self
end

function pad(self, top, left, bottom, right)
  self._padTop = top
  self._padLeft = left or top
  self._padBottom = bottom or top
  self._padRight = right or top
  return self
end

function padTop(self, pad)
  self._padTop = pad
  return self
end

function padLeft(self, pad)
  self._padLeft = pad
  return self
end

function padBottom(self, pad)
  self._padBottom = pad
  return self
end

function padRight(self, pad)
  self._padRight = pad
  return self
end

function fill(self, x, y)
  if type(xn) == "boolean" then
    x = x and 1 or 0
  elseif x == nil then
    x = 1
  end -- Assume X is a number
  if type(y) == "boolean" then
    y = y and 1 or 0
  elseif y == nil then
    y = 1
  end -- Assume Y is a number
  self._fillX = x
  self._fillY = y
  return self
end

function fillX(self, x)
  if type(x) == "boolean" then
    x = x and 1 or 0
  elseif x == nil then
    x = 1
  end -- Assume X is a number
  self._fillX = x
  return self
end

function fillY(self, y)
  if type(y) == "boolean" then
    y = y and 1 or 0
  elseif y == nil then
    y = 1
  end -- Assume Y is a number
  self._fillY = y
  return self
end

function align(self, align)
  self._align = align
  return self
end

function top(self)
  if self._align == nil then
    self._align = TOP
  else
    self._align = bit32.bor(self._align, TOP)
    self._align = bit32.band(self._align, bit32.bnot(BOTTOM))
  end
  return self
end

function left(self)
  if self._align == nil then
    self._align = LEFT
  else
    self._align = bit32.bor(self._align, LEFT)
    self._align = bit32.band(self._align, bit32.bnot(RIGHT))
  end
  return self
end

function bottom(self)
  if self._align == nil then
    self._align = BOTTOM
  else
    self._align = bit32.bor(self._align, BOTTOM)
    self._align = bit32.band(self._align, bit32.bnot(TOP))
  end
  return self
end

function right(self)
  if self._align == nil then
    self._align = RIGHT
  else
    self._align = bit32.bor(self._align, RIGHT)
    self._align = bit32.band(self._align, bit32.bnot(LEFT))
  end
  return self
end

function expand(self, x, y)
  if type(x) == "boolean" then
    x = x and 1 or 0
  elseif x == nil then
    x = 1
  end -- Assume X is a number
  if type(y) == "boolean" then
    y = y and 1 or 0
  elseif y == nil then
    y = 1
  end -- Assume Y is a number
  self._expandX = x
  self._expandY = y
  return self
end

function expandX(self, x)
  if type(x) == "boolean" then
    x = x and 1 or 0
  elseif x == nil then
    x = 1
  end -- Assume X is a number
  self._expandX = x
  return self
end

function expandY(self, y)
  if type(y) == "boolean" then
    y = y and 1 or 0
  elseif y == nil then
    y = 1
  end -- Assume Y is a number
  self._expandY = y
  return self
end

function ignore(self, ignore)
  if ignore == nil then
    self._ignore = true
  else
    self._ignore = ignore
  end
  return self
end

function getIgnore(self)
  return self._ignore ~= nil and self._ignore == true
end

function colspan(self, colspan)
  self._colspan = colspan
  return self
end

function uniform(self, x, y)
  if x == nil then
    self._uniformX = true
  else
    self._uniformX = x
  end
  if y == nil then
    self._uniformY = true
  else
    self._uniformY = y
  end
  return self
end

function uniformX(self, x)
  if x == nil then
    self._uniformX = true
  else
    self._uniformX = x
  end
  return self
end

function uniformY(self, y)
  if y == nil then
    self._uniformY = true
  else
    self._uniformY = y
  end
  return self
end

function getWidgetX(self)
  return self.widgetX
end

function setWidgetX(self, x)
  self.widgetX = x
end

function getWidgetY(self)
  return self.widgetY
end

function setWidgetY(self, y)
  self.widgetY = y
end

function getWidgetWidth(self)
  return self.widgetWidth
end

function setWidgetWidth(self, width)
  self.widgetWidth = width
end

function getWidgetHeight(self)
  return self.widgetHeight
end

function setWidgetHeight(self, height)
  self.widgetHeight = height
end

function getColumn(self)
  return self._column
end

function getRow(self)
  return self._row
end

function getMinWidth(self)
  return self._minWidth == nil and 0 or self._minWidth
end

function getMinHeight(self)
  return self._minHeight == nil and 0 or self._minHeight
end

function getPrefWidth(self)
  return self._prefWidth == nil and 0 or self._prefWidth
end

function getPrefHeight(self)
  return self._prefHeight == nil and 0 or self._prefHeight
end

function getMaxWidth(self)
  return self._maxWidth == nil and 0 or self._maxWidth
end

function getMaxHeight(self)
  return self._maxHeight == nil and 0 or self._maxHeight
end

function getSpaceTop(self)
  return self._spaceTop == nil and 0 or self._spaceTop
end

function getSpaceLeft(self)
  return self._spaceLeft == nil and 0 or self._spaceLeft
end

function getSpaceBottom(self)
  return self._spaceBottom == nil and 0 or self._spaceBottom
end

function getSpaceRight(self)
  return self._spaceRight == nil and 0 or self._spaceRight
end

function getPadTop(self)
  return self._padTop == nil and 0 or self._padTop
end

function getPadLeft(self)
  return self._padLeft == nil and 0 or self._padLeft
end

function getPadBottom(self)
  return self._padBottom == nil and 0 or self._padBottom
end

function getPadRight(self)
  return self._padRight == nil and 0 or self._padRight
end

function getFillX(self)
  return self._fillX
end

function getFillY(self)
  return self._fillY
end

function getAlign(self)
  return self._align
end

function getExpandX(self)
  return self._expandX
end

function getExpandY(self)
  return self._expandY
end

function getColspan(self)
  return self._colspan
end

function getUniformX(self)
  return self._uniformX
end

function getUniformY(self)
  return self._uniformY
end

function isEndRow(self)
  return self.endRow
end

function getComputedPadTop(self)
  return self.computedPadTop
end

function getComputedPadLeft(self)
  return self.computedPadLeft
end

function getComputedPadBottom(self)
  return self.computedPadBottom
end

function getComputedPadRight(self)
  return self.computedPadRight
end

function row(self)
  return self.layout:row()
end

function getLayout(self)
  return self.layout
end

function clear(self)
  self._minWidth = nil
  self._minHeight = nil
  self._prefWidth = nil
  self._prefHeight = nil
  self._maxWidth = nil
  self._maxHeight = nil
  self._spaceTop = nil
  self._spaceLeft = nil
  self._spaceBottom = nil
  self._spaceRight = nil
  self._padTop = nil
  self._padLeft = nil
  self._padBottom = nil
  self._padRight = nil
  self._fillX = nil
  self._fillY = nil
  self._align = nil
  self._expandX = nil
  self._expandY = nil
  self._ignore = nil
  self._colspan = nil
  self._uniformX = nil
  self._uniformY = nil
end

function free(self)
  self.widget = nil
  self.layout = nil
  self.endRow = false
  self.cellAboveIndex = -1
end

function defaults(self)
  self._minWidth = function(t, k, v)
    return t.layout.toolkit.getMinWidth(t:getWidget())
  end
  self._minHeight = function(t, k, v)
    return t.layout.toolkit.getMinHeight(t:getWidget())
  end 
  self._prefWidth = function(t, k, v)
    return t.layout.toolkit.getPrefWidth(t:getWidget())
  end
  self._prefHeight = function(t, k, v)
    return t.layout.toolkit.getPrefHeight(t:getWidget())
  end
  self._maxWidth = function(t, k, v)
    return t.layout.toolkit.getMaxWidth(t:getWidget())
  end
  self._maxHeight = function(t, k, v)
    return t.layout.toolkit.getMaxHeight(t:getWidget())
  end
  self._spaceTop = 0
  self._spaceLeft = 0
  self._spaceBottom = 0
  self._spaceRight = 0
  self._padTop = 0
  self._padLeft = 0
  self._padBottom = 0
  self._padRight = 0
  self._fillX = 0
  self._fillY = 0
  self._align = CENTER
  self._expandX = 0
  self._expandY = 0
  self._ignore = false
  self._colspan = 1
  self._uniformX = nil
  self._uniformY = nil
end
