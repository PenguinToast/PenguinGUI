-- A group of components
Panel = class(Component)

function Panel:_init()
  Component._init(self)
  self.mouseOver = false
end

function Panel:add(child)
  Component.add(self, child)
  local width = 0
  local height = 0
  for _,child in ipairs(self.children) do
    width = math.max(width, child.x + child.width)
    height = math.max(height, child.y + child.height)
  end
  if width > self.width then
    self.width = width
  end
  if height > self.height then
    self.height = height
  end
end

function Panel:clickEvent(position, button, pressed)
  -- Consume all clicks
  return true
end
