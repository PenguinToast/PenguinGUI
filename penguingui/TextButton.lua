-- A button that has a text label.
TextButton = class(Button)

-- Constructs a button with a text label.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param text The text string to display on the button. The button's size will
--             be based on this string.
-- @param width The width of the new component.
-- @param height The height of the new component.
-- @param fontColor (optional) The color of the text to display, default white.
function TextButton:_init(x, y, text, width, height, fontColor)
  Button._init(self, x, y, width, height)
  local padding = 2
  local fontSize = height - padding * 2
  local label = Label(0, padding, text, fontSize, fontColor)
  
  self.padding = padding
  self.label = label
  self:add(label)

  self:repositionLabel()
end

-- Centers the text label
function TextButton:repositionLabel()
  local label = self.label
  label.x = (self.width - label.width) / 2
end

-- Set the text of the textButton, and recalculates its bounds
--
-- @param text The new text for the button to display.
function TextButton:setText(text)
  local label = self.label
  label:setText(text)
  self:repositionLabel()
end
