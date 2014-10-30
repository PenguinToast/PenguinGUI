-- A text label for displaying text.
Label = class(Component)

-- Constructs a new Label.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param text The text string to display on the button. The button's size will
--             be based on this string.
-- @param fontSize (optional) The font size of the text to display, default 10.
-- @param fontColor (optional) The color of the text to display, default white.
function Label:_init(x, y, text, fontSize, fontColor)
  Component._init(self)
  fontSize = fontSize or 10
  self.fontSize = fontSize
  self.fontColor = fontColor or "white"
  self.text = text
  self.x = x
  self.y = y
  self:recalculateBounds()
end

-- Set the text of the label, and recalculates its bounds
--
-- @param text The new text for the label to display.
function Label:setText(text)
  self.text = text
  self:recalculateBounds()
end

-- Recalculates the bounds of the label based on its text and font size.
function Label:recalculateBounds()
  self.width = self.getStringWidth(self.text, self.fontSize)
  self.height = self.fontSize
end

function Label:draw()
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  
  --[[
  console.canvasDrawRect(
    {startX, startY, startX + self.width, startY + self.height},
    "red")
  --]]
  
  console.canvasDrawText(self.text, {
                           position = {startX, startY},
                           verticalAnchor = "bottom"
                                    }, self.fontSize, self.fontColor)

  Component.draw(self)
end

-- Get the approximate pixel width of a string.
--
-- @param text The string to get the width of.
-- @param fontSize The size of the font to get the width from.
function Label.getStringWidth(text, fontSize)
  local widths = PtUtil.getCharWidth
  local scale = PtUtil.getFontScale(fontSize)
  local out = 0
  for i=1,#text,1 do
    out = out + widths(string.byte(text, i))
  end
  return out * scale
end
