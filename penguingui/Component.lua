--- Superclass for all GUI components.
-- @usage
-- -- Creating a custom component:
-- CustomComponent = class(Component) -- Your new component needs to extend Component
-- -- Set any variables that have a default value
-- CustomComponent.somefield = "somedefault"
--
-- -- Constructor for your component
-- function CustomComponent:_init(args)
--   Component._init(self) -- This line must be the first line of your constructor
--   -- Do other initialization stuff
--   self.someotherfield = "somevalue"
--   -- If you want your component to block the mouse (i.e. know when the mouse
--   -- is over it, you must set mouseOver to not nil
--   self.mouseOver = false
-- end
--
-- -- Put all your component logic in update
-- function CustomComponent:update(dt)
--   -- Do some logic
-- end
--
-- -- Put all your component rendering in draw
-- function CustomComponent:draw(dt)
--   -- Do some drawing
-- end
--
-- -- If you want your component to be notified of click events, create a
-- -- clickEvent method.
-- function CustomComponent:clickEvent(position, button, pressed)
--   -- Process click
-- end
--
-- -- If you want your component to be notified of key events, create a keyEvent
-- -- method.
-- function CustomComponent:keyEvent(keyCode, pressed)
--   -- Process key
-- end
-- @classmod Component
Component = class()
--- The x location of this component, relative to its parent.
Component.x = 0
--- The y location of this component, relative to its parent.
Component.y = 0
--- The width of this component.
Component.width = 0
--- The height of this component.
Component.height = 0

--- Whether the mouse is hovering over this component.
-- Set this to not nil to allow this to be set.
Component.mouseOver = nil

--- Whether this component has keyboard focus.
-- @{mouseOver} needs to be not nil for this to be set.
Component.hasFocus = nil

--- Constructor
-- @section

--- Constructs a component.
function Component:_init()
  self.children = {}
  self.offset = Binding.proxy({0, 0})
end

--- @section end

--- Adds a child component to this component.
--
-- @param child The component to add.
function Component:add(child)
  local children = self.children
  children[#children + 1] = child
  child:setParent(self)
end

--- Removes a child component.
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

--- Resizes this component around its children.
--
-- @param[opt] padding Amount of padding to put between the component's
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

--- Updates this component.
--
-- Components should override this to implement their own update functions.
-- @param dt The time elapsed since the last update, in seconds.
function Component:update(dt)
end

--- Draws this component
--
-- Components should override this to implement their own draw functions.
-- @param dt The time elapsed since the last update, in seconds.
function Component:draw(dt)
end

--- Sets the parent of this component, and updates the offset of this component.
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

--- Calculates the offset from the origin that this component should use, based
-- on its parents.
--
-- @return The calculated offset.
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

--- Checks if the given position is within this component.
--
-- @param position The position to check.
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

--- Called when the mouse is pressed or released over this component.
-- @function clickEvent
-- @param position The position of the mouse where the click happened.
-- @param button The mouse button used.
-- @param pressed Whether the mouse was pressed or released.

--- Called when the user presses or releases a key when this component has focus.
-- @function keyEvent
-- @param keyCode The key code that was pressed or released.
-- @param pressed Whether the key was pressed or released.
