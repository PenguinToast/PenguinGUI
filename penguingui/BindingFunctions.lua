-- Creates a binding function (convenience function)
--
-- @param f A function that returns this value's new value after the value
--      that it is bound to changes.
-- @param numArgs The number of arguments to the function to create.
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

-- Calls tonumber on this value.
Binding.valueTable.tostring = createFunction(
  function(value)
    return tostring(value())
  end
)
Binding.tostring = Binding.valueTable.tostring

-- Calls tonumber on this value.
Binding.valueTable.tonumber = createFunction(
  function(value)
    return tonumber(value())
  end
)
Binding.tonumber = Binding.valueTable.tonumber

-- Creates a new value containing the sum of this value and others.
--
-- @param others Can be values, or constants (number, etc.)
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

-- Creates a new value containing the difference of this value and others.
--
-- @param others Can be values, or constants (number, etc.)
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

-- Creates a new value containing the product of this value and others.
--
-- @param others Can be values, or constants (number, etc.)
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

-- Creates a new value containing the quotient of this value and others.
--
-- @param others Can be values, or constants (number, etc.)
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

-- Creates a new value containing the modulus of this value and others.
--
-- @param others Can be values, or constants (number, etc.)
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

-- Creates a new value containing the power of this value and others.
--
-- @param others Can be values, or constants (number, etc.)
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

-- Creates a new value containing the negation of this value.
Binding.valueTable.negate = createFunction(
  function(value)
    return -value()
  end
)
Binding.negate = Binding.valueTable.negate

-- Creates a new value containing the concatenation of this value and other.
--
-- @param others Can be values, or constants (number, etc.)
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

-- Creates a new value containing the length of this value.
Binding.valueTable.len = createFunction(
  function(value)
    return #value()
  end
)
Binding.len = Binding.valueTable.len

-- Creates a new value containing the equality of this value and another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.eq = createFunction(
  function(a, b)
    return a() == b()
  end
)
Binding.eq = Binding.valueTable.eq

-- Creates a new value containing the unequality of this value and another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.ne = createFunction(
  function(a, b)
    return a() ~= b()
  end
)
Binding.ne = Binding.valueTable.ne

-- Creates a new value containing whether this value is less than another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.lt = createFunction(
  function(a, b)
    return a() < b()
  end
)
Binding.lt = Binding.valueTable.lt

-- Creates a new value containing whether this value is greater than another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.gt = createFunction(
  function(a, b)
    return a() > b()
  end
)
Binding.gt = Binding.valueTable.gt

-- Creates a new value containing whether this value is less than or equal to
-- another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.le = createFunction(
  function(a, b)
    return a() <= b()
  end
)
Binding.le = Binding.valueTable.le

-- Creates a new value containing whether this value is greater than or equal to
-- another.
--
-- @param other Can either be another value, or a constant (number, etc.)
Binding.valueTable.ge = createFunction(
  function(a, b)
    return a() >= b()
  end
)
Binding.ge = Binding.valueTable.ge

-- Creates a new value containing this value AND others.
--
-- @param others Can be values, or constants (number, etc.)
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

-- Creates a new value containing this value OR others.
--
-- @param others Can be values, or constants (number, etc.)
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

-- Creates a new value containing NOT this value
Binding.valueTable.NOT = createFunction(
  function(value)
    return not value()
  end
)
Binding.NOT = Binding.valueTable.NOT

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
  out.boundto = boundto
  return out
end
Binding.THEN = Binding.valueTable.THEN
