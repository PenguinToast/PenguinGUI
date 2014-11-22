--- A group of components, will hopefully eventually manage layouts (TODO).
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
  self:pack()
end
