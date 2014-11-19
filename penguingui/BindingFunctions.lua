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
