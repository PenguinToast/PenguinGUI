-- A radio button
RadioButton = class(Component)
RadioButton.borderColor = "#545454"
RadioButton.backgroundColor = "black"
RadioButton.hoverColor = "#1C1C1C"
RadioButton.pressedColor = "#343434"
RadioButton.checkColor = "#C51A0B"

-- Constructs a new RadioButton.
-- 
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param size The width and height of the new component.
function RadioButton:_init(x, y, size)
  Component._init(self)
  self.mouseOver = false

  self.x = x
  self.y = y
  self.width = size
  self.height = size
end

function RadioButton:draw(dt)
  if self.pressed and not self.mouseOver then
    self.pressed = false
  end

  -- Draw squares since no efficient way to fill circles yet.
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
    local checkRect = {startX + w / 4, startY + h / 4,
                       startX + 3 * w / 4, startY + 3 * h / 4}
    PtUtil.fillRect(checkRect, self.checkColor)
  end
  
  return Component.draw(self, dt)
end

-- Select this RadioButton
function RadioButton:select()
  local siblings
  if self.parent == nil then
    siblings = GUI.components
  else
    siblings = self.parent.children
  end

  local selectedButton
  for _,sibling in ipairs(siblings) do
    if sibling ~= self and sibling.is_a[RadioButton]
      and sibling.selected
    then
      selectedButton = sibling
    end
  end
  if selectedButton then
    selectedButton.selected = false
    if selectedButton.onSelect then
      selectedButton:onSelect(false)
    end
  end

  if not self.selected then
    self.selected = true
    if self.onSelect then
      self:onSelect(self.selected)
    end
  else
    self.selected = true
  end
end

function RadioButton:setParent(parent)
  Component.setParent(self, parent)
  self:select()
end

function RadioButton:clickEvent(position, button, pressed)
  if not pressed and self.pressed then
    self:select()
  end
  self.pressed = pressed
  return true
end
