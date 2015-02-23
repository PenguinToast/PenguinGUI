--- A check box.
-- @classmod CheckBox
-- @usage -- Create a checkbox that prints when it is checked
-- local checkbox = CheckBox(0, 0, 16)
-- checkbox:addListener("selected", function(t, k, old, new)
--   print("The checkbox was " .. (new and "checked" or "unchecked"))
-- end
CheckBox = class(Component)
--- The color of the border of this checkbox.
CheckBox.borderColor = "#545454"
--- The color of the checkbox.
CheckBox.backgroundColor = "black"
--- The color of this checkbox when the mouse is over it.
CheckBox.hoverColor = "#1C1C1C"
--- The color of the check.
CheckBox.checkColor = "#C51A0B"
--- The color of this checkbox when it is pressed.
CheckBox.pressedColor = "#343434"

--- Constructor
-- @section

--- Constructs a new CheckBox.
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

--- @section end

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

--- Draw the checkbox
-- @param dt The time elapsed since the last draw.
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
  if button <= 3 then
    if not pressed and self.pressed then
      self.selected = not self.selected
    end
    self.pressed = pressed
    return true
  end
end
