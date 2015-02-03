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
function Panel:_init(x, y)
  Component._init(self)
  self.x = x
  self.y = y
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
-- @param layout The new layout manager for this panel, or nil to clear the
--           layout manager.
function Panel:setLayoutManager(layout)
  self.layoutManager = layout
  self:updateLayoutManager()
end

--- Updates the components in this panel according to its layout manager.
function Panel:updateLayoutManager()
  local layout = self.layoutManager
  if layout then
    layout:layout(self)
  end
end
