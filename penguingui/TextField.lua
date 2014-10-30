-- Editable text field
TextField = class(Component)
TextField.vPadding = 3
TextField.hPadding = 4
TextField.borderColor = "#333333"
TextField.backgroundColor = "black"
TextField.textColor = "white"
TextField.textHoverColor = "#dddddd"
TextField.defaultTextColor = "#333333"
TextField.defaultTextHoverColor = "#777777"

-- Constructs a new TextField.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width The width of the new component.
-- @param height The height of the new component.
-- @param defaultText The text to display when nothing has been entered.
function TextField:_init(x, y, width, height, defaultText)
  Component._init(self)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.fontSize = height - self.vPadding * 2
  self.cursorPosition = 0
  self.text = ""
  self.defaultText = defaultText
  self.mouseOver = false
end

function TextField:draw()
  local startX = self.x
  local startY = self.y
  local w = self.width
  local h = self.height
  local borderRect = {
    startX, startY, startX + w, startY + h
  }
  local backgroundRect = {
    startX + 1, startY + 1, startX + w - 1, startY + h - 1
  }
  console.canvasDrawRect(borderRect, self.borderColor)
  console.canvasDrawRect(backgroundRect, self.backgroundColor)

  local default = (text == "") and (self.defaultText ~= nil)
  
  local textColor
  if self.mouseOver then
    textColor = default and self.defaultTextHoverColor or self.textHoverColor
  else
    textColor = default and self.defaultTextColor or self.textColor
  end
  local text = self.text

  local cursorPosition = self.cursorPosition
  if cursorPosition > #text then
    cursorPosition = #text
    self.cursorPosition = cursorPosition
  end
  text = default and self.defaultText or text

  
  
  Component.draw(self)
end

function TextField:clickEvent(position, button, pressed)
  local xPos = position[1] - self.offset[1] - self.hPadding
  
  
end

function TextField:keyEvent(key, pressed)
  
end
