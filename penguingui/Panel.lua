--- A group of components.
-- @classmod Panel
-- @usage
-- -- Create an empty panel.
-- local panel = Panel(0, 0)
Panel = class(Component)

--- Constructor
-- @section

--- Constructs a Panel.
-- 
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width[opt] The width of the new component.
-- @param height[opt] The height of the new component.
function Panel:_init(x, y, width, height)
  Component._init(self)
  self.x = x
  self.y = y
  if width then
    self.width = width
  end
  if height then
    self.height = height
  end
end

--- @section end

function Panel:add(child)
  Component.add(self, child)
  self:updateLayoutManager()
  if not self.layoutManager then
    self:pack()
  end
end

--- Sets the layout manager for this Panel.
-- THIS IS WIP. THE API IS LIKELY TO CHANGE.
-- @param layout The new layout manager for this panel, or nil to clear the
--           layout manager.
function Panel:setLayoutManager(layout)
  self.layoutManager = layout
  layout.container = self
  self:updateLayoutManager()
end

--- Updates the components in this panel according to its layout manager.
function Panel:updateLayoutManager()
  local layout = self.layoutManager
  if layout then
    layout:layout()
  end
end
