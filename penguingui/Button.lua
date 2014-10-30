-- A clickable button
Button = class(Component)
Button.outerBorderColor = "black"
Button.innerBorderColor = "#545454"
Button.innerBorderHoverColor = "#939393"
Button.color = "#262626"
Button.hoverColor = "#545454"

-- Constructs a new Button.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width The width of the new component.
-- @param height The height of the new component.
function Button:_init(x, y, width, height)
  Component._init(self)
  self.mouseOver = false

  self.x = x
  self.y = y
  self.width = width
  self.height = height
end

function Button:draw()
  if self.pressed then
    if self.mouseOver then
      self.x = self.x + 1
      self.y = self.y - 1
      self.layout = true
    else
      self.pressed = false
    end
  end
  
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height
  
  local borderPoly = {
    {startX + 1, startY},
    {startX + w - 1, startY},
    {startX + w, startY + 1},
    {startX + w, startY + h - 1},
    {startX + w - 1, startY + h},
    {startX + 1, startY + h},
    {startX, startY + h - 1},
    {startX, startY + 1},
  }
  local innerBorderRect = {
    startX + 1, startY + 1, startX + w - 1, startY + h - 1
  }
  local rect = {
    startX + 2, startY + 2, startX + w - 2, startY + h - 2
  }

  console.canvasDrawPoly(borderPoly, self.outerBorderColor)
  if self.mouseOver then
    console.canvasDrawRect(innerBorderRect, self.innerBorderHoverColor)
    console.canvasDrawRect(rect, self.hoverColor)
  else
    console.canvasDrawRect(innerBorderRect, self.innerBorderColor)
    console.canvasDrawRect(rect, self.color)
  end
  
  Component.draw(self)
  
  if self.pressed then
    self.x = self.x - 1
    self.y = self.y + 1
    self.layout = true
  end
end

function Button:clickEvent(position, button, pressed)
  if self.onClick and not pressed and self.pressed then
    self.onClick(self, button)
  end
  self.pressed = pressed
end
