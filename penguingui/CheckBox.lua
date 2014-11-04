-- A check box
CheckBox = class(Component)
CheckBox.borderColor = "#545454"
CheckBox.backgroundColor = "black"
CheckBox.hoverColor = "#1C1C1C"
CheckBox.checkColor = "#C51A0B"
CheckBox.pressedColor = "#343434"

-- Constructs a new CheckBox.
-- 
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param size The width and height of the new component.
function CheckBox:_init(x, y, size)
  Component._init(self)
  self.mouseOver = false

  self.x = x
  self.y = y
  self.width = size
  self.height = size

  self.selected = false
end

function CheckBox:update(dt)
  if self.pressed and not self.mouseOver then
    self.pressed = false
  end
end

function CheckBox:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height

  local borderRect = {startX, startY, startX + w, startY + h}
  local rect = {startX + 1, startY + 1, startX + w - 1, startY + h - 1}
  PtUtil.drawRect(borderRect, self.borderColor, 1)

  if self.pressed then
    PtUtil.fillRect(rect, self.pressedColor)
  elseif self.mouseOver then
    PtUtil.fillRect(rect, self.hoverColor)
  else
    PtUtil.fillRect(rect, self.backgroundColor)
  end

  -- Draw check, if needed
  if self.selected then
    self:drawCheck(dt)
  end
end

-- Draw the checkbox
function CheckBox:drawCheck(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height
  PtUtil.drawLine(
    {startX + w / 4, startY + w / 2},
    {startX + w / 3, startY + h / 4},
    self.checkColor, 1)
  PtUtil.drawLine(
    {startX + w / 3, startY + h / 4},
    {startX + 3 * w / 4, startY + 3 * h / 4},
    self.checkColor, 1)
end

function CheckBox:clickEvent(position, button, pressed)
  if not pressed and self.pressed then
    self.selected = not self.selected
    if self.onSelect then
      self:onSelect(self.selected)
    end
  end
  self.pressed = pressed
  return true
end
