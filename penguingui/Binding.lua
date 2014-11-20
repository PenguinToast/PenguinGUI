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

-- Binds the key in the specified table to the 10 given value
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
