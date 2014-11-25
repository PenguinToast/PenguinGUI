--- A radio button with text.
-- Extends @{RadioButton}, so all fields of @{RadioButton} are inherited.
-- @classmod TextRadioButton
-- @usage
-- -- Create a group of buttons that print when they are selected.
-- local group = Panel(0, 0)
-- local numButtons = 10
-- for i = 1, numButtons, 1 do
--   local button = TextRadioButton(0, i * 20, 60, 16, "Button " .. i)
--   button:addListener("selected", function(t, k, old, new)
--     if new then
--       print(t.text .. " was selected")
--     end
--   end)
--   group:add(button)
-- end
TextRadioButton = class(RadioButton)
TextRadioButton.hoverColor = "#1F1F1F"
TextRadioButton.pressedColor = "#454545"
TextRadioButton.checkColor = "#343434"
--- The text of the button.
TextButton.text = nil
--- The padding between the text and the button edge.
TextRadioButton.textPadding = 2

--- Constructor
-- @section

--- Constructs a new TextRadioButton.
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width The width of the new component.
-- @param height The height of the new component.
-- @param text The text of this radio button.
function TextRadioButton:_init(x, y, width, height, text)
  RadioButton._init(self, x, y, 0)
  self.width = width
  self.height = height
  
  local padding = self.textPadding
  local fontSize = height - padding * 2
  local label = Label(0, padding, text, fontSize, fontColor)
  
  self.label = label
  self:add(label)

  self.text = text
  self:addListener(
    "text",
    function(t, k, old, new)
      t.label.text = new
      t:repositionLabel()
    end
  )
  self:repositionLabel()
end

--- @section end

function TextRadioButton:drawCheck(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height
  local checkRect = {startX + 1, startY + 1,
                     startX + w - 1, startY + h - 1}
  PtUtil.fillRect(checkRect, self.checkColor)
end

TextRadioButton.repositionLabel = TextButton.repositionLabel
