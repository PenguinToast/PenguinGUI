-- A group of components
Panel = class(Component)

-- Constructs a Panel.
-- 
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
function Panel:_init(x, y)
  Component._init(self)
  self.x = x
  self.y = y
end

function Panel:add(child)
  Component.add(self, child)
  self:pack()
end
