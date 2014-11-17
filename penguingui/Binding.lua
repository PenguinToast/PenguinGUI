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
          new = keyListener(instance, k, old, new) or new
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

Binding.valueTable = {}

Binding.valueTable.__index = Binding.valueTable

function Binding.valueTable:addValueListener(listener)
  self:addListener("value", listener)
end

function Binding.value(t, k)
  local out = Binding.proxy(setmetatable({}, Binding.valueTable))
  if type(k) == "string" then -- Single key
    out.value = t[k]
    t:addListener(
      k,
      function(t, k, old, new)
        out.value = new
      end
    )
    return out
  else -- Table of keys TODO - Untested
    local numKeys = #k
    local currTable = t
    local listenerTable = {}
    for i=1, numKeys - 1, 1 do
      local currKey = k[i]
      local index = i
      local currTableListener = function(t, k, old, new)
        -- Remove listeners from old tables, and add listeners to new tables.
        local oldTable = old
        local newTable = new
        local subKey
        for j=index + 1, numKeys, 1 do
          subKey = k[j]
          oldTable:removeListener(subKey, listenerTable[j])
          newTable:addListener(subKey, listenerTable[j])
          if j < numKeys then
            oldTable = oldTable[subKey]
            newTable = newTable[subKey]
          end
        end
      end
      listenerTable[index] = currTableListener
      currTable:addListener(currKey, currTableListener)
      currTable = t[currKey] 
    end
    local lastTableListener = function(t, k, old, new)
      out.value = new
    end
    currTable:addListener(k[numKeys], lastTableListener)
    listenerTable[numKeys] = lastTableListener
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
  for i=1, #keyListeners, 1 do
    if keyListeners[i] == listener then
      table.remove(keyListeners, i)
      return true
    end
  end
  return false
end

-- Binds the key in the specified table to the given value
--
-- @param table The table where the key to be bound is.
-- @param kkey The key to be bound.
-- @param value The value to bind to.
function Binding.bind(table, key, value)
  value:addListener(
    "value",
    function(t, k, old, new)
      table[key] = new
    end
  )
end

function Binding.proxy(instance)
  return setmetatable(
    {_instance = instance},
    Binding.proxyTable
  )
end
