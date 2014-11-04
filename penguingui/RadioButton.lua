-- A radio button
RadioButton = class(CheckBox)

function RadioButton:drawCheck(dt)
  -- Draw squares since no efficient way to fill circles yet.
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height
  local checkRect = {startX + w / 4, startY + h / 4,
                     startX + 3 * w / 4, startY + 3 * h / 4}
  PtUtil.fillRect(checkRect, self.checkColor)
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
