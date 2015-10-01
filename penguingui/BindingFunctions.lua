--- @module Binding

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
      out.value = f(table.unpack(getters))
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

--- @type Binding

--- Creates a binding containing the string representation of this binding.
-- @function tostring
-- @return A new binding.
Binding.valueTable.tostring = createFunction(
  function(value)
    return tostring(value())
  end
)
Binding.tostring = Binding.valueTable.tostring

--- Creates a binding containing the number value of this binding.
-- @function tonumber
-- @return A new binding.
Binding.valueTable.tonumber = createFunction(
  function(value)
    return tonumber(value())
  end
)
Binding.tonumber = Binding.valueTable.tonumber

--- Creates a new binding containing the sum of this binding and others.
-- @function add
-- @param ... Can be bindings, or constants (number, etc.)
-- @return A new binding.
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

--- Creates a new binding containing the difference of this binding and others.
-- @function sub
-- @param ... Can be bindings, or constants (number, etc.)
-- @return A new binding.
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

--- Creates a new binding containing the product of this binding and others.
-- @function mul
-- @param ... Can be bindings, or constants (number, etc.)
-- @return A new binding.
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

--- Creates a new binding containing the quotient of this binding and others.
-- @function div
-- @param ... Can be bindings, or constants (number, etc.)
-- @return A new binding.
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

--- Creates a new binding containing the modulus of this binding and others.
-- @function mod
-- @param ... Can be bindings, or constants (number, etc.)
-- @return A new binding.
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

--- Creates a new binding containing the exponentiation of this binding and
-- others.
-- @function pow
-- @param ... Can be bindings, or constants (number, etc.)
-- @return A new binding.
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

--- Creates a new binding containing the negation of this binding.
-- @function negate
-- @return A new binding.
Binding.valueTable.negate = createFunction(
  function(value)
    return -value()
  end
)
Binding.negate = Binding.valueTable.negate

--- Creates a new binding containing the concatenation of this binding and
-- others.
-- @function concat
-- @param ... Can be bindings, or constants (number, etc.)
-- @return A new binding.
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

--- Creates a new binding containing the length of this binding.
-- @function len
-- @return A new binding.
Binding.valueTable.len = createFunction(
  function(value)
    return #value()
  end
)
Binding.len = Binding.valueTable.len

--- Creates a new binding representing if this value is equal to another.
-- @function eq
-- @param other Can be another binding or a constant (number, etc.)
-- @return A new binding.
Binding.valueTable.eq = createFunction(
  function(a, b)
    return a() == b()
  end
)
Binding.eq = Binding.valueTable.eq

--- Creates a new binding representing if this value is not equal to another.
-- @function ne
-- @param other Can be another binding or a constant (number, etc.)
-- @return A new binding.
Binding.valueTable.ne = createFunction(
  function(a, b)
    return a() ~= b()
  end
)
Binding.ne = Binding.valueTable.ne

--- Creates a new binding representing if this value is less than to another.
-- @function lt
-- @param other Can be another binding or a constant (number, etc.)
-- @return A new binding.
Binding.valueTable.lt = createFunction(
  function(a, b)
    return a() < b()
  end
)
Binding.lt = Binding.valueTable.lt

--- Creates a new binding representing if this value is greater than to another.
-- @function gt
-- @param other Can be another binding or a constant (number, etc.)
-- @return A new binding.
Binding.valueTable.gt = createFunction(
  function(a, b)
    return a() > b()
  end
)
Binding.gt = Binding.valueTable.gt

--- Creates a new binding representing if this value is less than or equal
-- to another.
-- @function le
-- @param other Can be another binding or a constant (number, etc.)
-- @return A new binding.
Binding.valueTable.le = createFunction(
  function(a, b)
    return a() <= b()
  end
)
Binding.le = Binding.valueTable.le

--- Creates a new binding representing if this value is greater than or equal
-- to another.
-- @function ge
-- @param other Can be another binding or a constant (number, etc.)
-- @return A new binding.
Binding.valueTable.ge = createFunction(
  function(a, b)
    return a() >= b()
  end
)
Binding.ge = Binding.valueTable.ge

--- Creates a new binding containing this binding AND others.
-- @function AND
-- @param ... Can be bindings, or constants (number, etc.)
-- @return A new binding.
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

--- Creates a new binding containing this binding OR others.
-- @function OR
-- @param ... Can be bindings, or constants (number, etc.)
-- @return A new binding.
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

--- Creates a new binding containing NOT this binding.
-- @function NOT
-- @return A new binding.
Binding.valueTable.NOT = createFunction(
  function(value)
    return not value()
  end
)
Binding.NOT = Binding.valueTable.NOT

--- Creates a new binding with the value of the first value if this binding is
-- true, or the second value if this binding is false.
-- @function THEN
--
-- @param ifTrue The value the new binding will be set to when this value is
--      true. Can either be another value, or a constant (number, etc.)
-- @param ifFalse The value the new binding will be set to when this value is
--      false. Can either be another value, or a constant (number, etc.)
-- @return A new binding.
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

--- @type end
