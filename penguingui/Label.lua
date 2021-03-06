--- A text label for displaying text.
-- @classmod Label
-- @usage
-- -- Create a label with the text "Hello"
-- local label = Label(0, 0, "Hello")
Label = class(Component)
--- The text of the label.
Label.text = nil

--- Constructor
-- @section

--- Constructs a new Label.
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
  self.fontColor = fontColor or {255, 255, 255}
  self.text = text
  self.x = x
  self.y = y
  self:addListener("text", self.recalculateBounds)
  self:recalculateBounds()
end

--- @section end

-- Recalculates the bounds of the label based on its text and font size.
function Label:recalculateBounds()
  self.width = PtUtil.getStringWidth(self.text, self.fontSize)
  self.height = self.fontSize
end

function Label:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  
  --PtUtil.fillRect({startX, startY, startX + self.width, startY + self.height},
  -- "red")
  PtUtil.drawText(self.text, {
                    position = {startX, startY},
                    verticalAnchor = "bottom"
                             }, self.fontSize, self.fontColor)
end
