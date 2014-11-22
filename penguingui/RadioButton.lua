--- A radio button
--
-- Extends @{CheckBox}, so the fields RadioButton uses for drawing are the same
-- as those of @{CheckBox}.
-- @classmod RadioButton
-- @usage
-- -- Create a group of buttons that print when they are selected.
-- local group = Panel(0, 0)
-- local numButtons = 10
-- for i = 1, numButtons, 1 do
--   local button = RadioButton(i * 20, 0, 16)
--   button:addListener("selected", function(t, k, old, new)
--     if new then
--       print("Button " .. i .. " was selected")
--     end
--   end)
--   group:add(button)
-- end
RadioButton = class(CheckBox)

--- Constructor
-- @section

--- Constructs a new RadioButton.
-- @function _init
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param size The width and height of the new component.

--- @section end

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
  end

  self.selected = not self.selected
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
