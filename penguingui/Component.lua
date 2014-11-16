-- Superclass for all GUI components.
Component = class()
Component.x = 0
Component.y = 0
Component.width = 0
Component.height = 0

-- Constructs a component.
function Component:_init()
  self.children = {}
  self.offset = {0, 0}
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
function Component:addListener(key, listener)
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

-- Binds the target value to the source value.
--
-- @param sourceKey The name of the key to be bound by.
-- @param targetComponent The target table to bind.
-- @param targetKey The target key to bind.
function Component:bind(sourceKey, targetComponent, targetKey)
  local targetLen = #targetKey
  self:addListener(
    sourceKey,
    function(t, k, old, new)
      local targetTable = targetComponent
      for i=1,targetLen - 1,1 do
        targetTable = targetTable[targetKey[i]]
      end
      targetTable[targetKey[targetLen]] = new
    end
  )
end
