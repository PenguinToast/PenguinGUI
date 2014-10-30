-- A button that has a text label.
TextButton = class(Button)

-- Constructs a button with a text label.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param text The text string to display on the button. The button's size will
--             be based on this string.
-- @param fontSize (optional) The font size of the text to display, default 10.
-- @param fontColor (optional) The color of the text to display, default white.
function TextButton:_init(x, y, text, fontSize, fontColor)
  Button._init(self, x, y, width, height)
  local padding = 2
  local label = Label(padding + 1, padding, text, fontSize, fontColor)
  self.padding = padding
  self.label = label
  self:add(label)

  self:recalculateBounds()
end

-- Overrides recalculateBounds in Label to add padding between the button edge
-- and the text.
function TextButton:recalculateBounds()
  local label = self.label
  local padding = self.padding
  self.width = label.width + (padding + 1) * 2
  self.height = label.height + padding * 2
end

-- Set the text of the textButton, and recalculates its bounds
--
-- @param text The new text for the button to display.
function TextButton:setText(text)
  Label.setText(self, text)
end
