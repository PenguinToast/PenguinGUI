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

-- Draws and updates the component, and any children.
function Component:draw(dt)
  local hoverComponent
  local layout = self.layout
  for _,child in ipairs(self.children) do
    if layout then
      child:calculateOffset()
      child.layout = true
    end
    if child.visible ~= false then
      -- Also check for hover functions
      if child.mouseOver ~= nil then
        if child:contains(GUI.mousePosition) then
          hoverComponent = child
        else
          child.mouseOver = false
        end
      end
      
      local result = child:draw(dt)
      if result then
        hoverComponent = result
      end
    end
  end
  if self.layout then
    self.layout = nil
  end
  return hoverComponent
end

-- Sets the parent of this component, and updates the offset of this component.
--
-- @param parent The new parent of this component, or nil if this is to be a
--               top level component.
function Component:setParent(parent)
  self.parent = parent
  -- self:calculateOffset()
  parent.layout = true
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

