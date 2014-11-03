-- A group of components
Panel = class(Component)

function Panel:_init()
  Component._init(self)
  self.mouseOver = false
end

function Panel:add(child)
  Component.add(self, child)
  self:pack()
end

function Panel:clickEvent(position, button, pressed)
  -- Consume all clicks
  return true
end
