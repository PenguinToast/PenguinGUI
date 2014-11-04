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

function Button:update(dt)
  if self.pressed and not self.mouseOver then
    self:setPressed(false)
  end
end

function Button:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height
  
  local borderPoly = {
    {startX + 1, startY + 0.5},
    {startX + w - 1, startY + 0.5},
    {startX + w - 0.5, startY + 1},
    {startX + w - 0.5, startY + h - 1},
    {startX + w - 1, startY + h - 0.5},
    {startX + 1, startY + h - 0.5},
    {startX + 0.5, startY + h - 1},
    {startX + 0.5, startY + 1},
  }
  local innerBorderRect = {
    startX + 1, startY + 1, startX + w - 1, startY + h - 1
  }
  local rectOffset = 1.5
  local rect = {
    startX + rectOffset, startY + rectOffset, startX + w - rectOffset, startY + h - rectOffset
  }

  PtUtil.drawPoly(borderPoly, self.outerBorderColor, 1)
  if self.mouseOver then
    PtUtil.drawRect(innerBorderRect, self.innerBorderHoverColor, 0.5)
    PtUtil.fillRect(rect, self.hoverColor)
  else
    PtUtil.drawRect(innerBorderRect, self.innerBorderColor, 0.5)
    PtUtil.fillRect(rect, self.color)
  end
end

function Button:setPressed(pressed)
  if pressed and not self.pressed then
    self.x = self.x + 1
    self.y = self.y - 1
    self.layout = true
  end
  if not pressed and self.pressed then
    self.x = self.x - 1
    self.y = self.y + 1
    self.layout = true
  end
  self.pressed = pressed
end

function Button:clickEvent(position, button, pressed)
  if self.onClick and not pressed and self.pressed then
    self:onClick(button)
  end
  self:setPressed(pressed)
  return true
end
