--- An editable text field.
-- @classmod TextField
-- @usage
-- -- Create a text field that prints whatever is in it when enter is pressed.
-- local textfield = TextField(0, 0, 100, 16, "default text")
-- textfield.onEnter = function(textfield)
--   print(textfield.text)
-- end
TextField = class(Component)
TextField.vPadding = 3
TextField.hPadding = 4
--- The color of this text field's border.
TextField.borderColor = "#545454"
--- The background color of this text field.
TextField.backgroundColor = "#000000"
--- The color of this text field's text.
TextField.textColor = "white"
--- The color of this text field's text when the mouse is over it.
TextField.textHoverColor = "#999999"
--- The color of this text field's default text.
TextField.defaultTextColor = "#333333"
--- The color of this text field's default text when the mouse is over it.
TextField.defaultTextHoverColor = "#777777"
--- The color of the text cursor.
TextField.cursorColor = "white"
--- The period of the cursor's blinking.
TextField.cursorRate = 1

--- Constructor
-- @section

--- Constructs a new TextField.
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
  self.cursorX = 0
  self.cursorTimer = self.cursorRate
  self.text = ""
  self.defaultText = defaultText
  self.textOffset = 0
  self.textClip = nil
  self.mouseOver = false
end

--- @section end

function TextField:update(dt)
  if self.hasFocus then
    local timer = self.cursorTimer
    local rate = self.cursorRate
    timer = timer - dt
    if timer < 0 then
      timer = rate
    end
    self.cursorTimer = timer
  end
end

function TextField:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height

  -- Draw border and background
  local borderRect = {
    startX, startY, startX + w, startY + h
  }
  local backgroundRect = {
    startX + 1, startY + 1, startX + w - 1, startY + h - 1
  }
  PtUtil.fillRect(borderRect, self.borderColor)
  PtUtil.fillRect(backgroundRect, self.backgroundColor)

  local text = self.text
  -- Decide if the default text should be displayed
  local default = (text == "") and (self.defaultText ~= nil)
  
  local textColor
  -- Choose the color to draw the text with
  if self.mouseOver then
    textColor = default and self.defaultTextHoverColor or self.textHoverColor
  else
    textColor = default and self.defaultTextColor or self.textColor
  end

  local cursorPosition = self.cursorPosition
  text = default and self.defaultText
    or text:sub(self.textOffset + 1, self.textOffset
                  + (self.textClip or #text))

  -- Draw the text
  PtUtil.drawText(text, {
                    position = {
                      startX + self.hPadding,
                      startY + self.vPadding
                    },
                    verticalAnchor = "bottom"
                        }, self.fontSize, textColor)

  -- Text cursor
  if self.hasFocus then
    local timer = self.cursorTimer
    local rate = self.cursorRate

    if timer > rate / 2 then -- Draw cursor
      local cursorX = startX + self.cursorX + self.hPadding
      local cursorY = startY + self.vPadding
      PtUtil.drawLine({cursorX, cursorY},
        {cursorX, cursorY + h - self.vPadding * 2},
        self.cursorColor,
        1)
    end
  end
end

--- Set the character position of the text cursor.
--
-- @param pos The new position for the cursor, where 0 is the beginning of the
--            field.
function TextField:setCursorPosition(pos)
  self.cursorPosition = pos

  if pos < self.textOffset then
    self.textOffset = pos
  end
  self:calculateTextClip()
  local textClip = self.textClip
  while (textClip) and (pos > self.textOffset + textClip) do
    self.textOffset = self.textOffset + 1
    self:calculateTextClip()
    textClip = self.textClip
  end
  while self.textOffset > 0 and not textClip do
    self.textOffset = self.textOffset - 1
    self:calculateTextClip()
    textClip = self.textClip
    if textClip then
      self.textOffset = self.textOffset + 1
      self:calculateTextClip()
    end
  end
  -- world.logInfo("cursor: %s, textOffset: %s, textClip: %s", pos, self.textOffset, self.textClip)
  
  local text = self.text
  local cursorX = 0
  for i=self.textOffset + 1,pos,1 do
    local charWidth = PtUtil.getStringWidth(text:sub(i, i), self.fontSize)
    cursorX = cursorX + charWidth
  end
  self.cursorX = cursorX
  self.cursorTimer = self.cursorRate
end

-- Calculates the text clip, i.e. how many characters to display.
function TextField:calculateTextClip()
  local maxX = self.width - self.hPadding * 2
  local text = self.text
  local totalWidth = 0
  local startI = self.textOffset + 1
  for i=startI,#text,1 do
    totalWidth = totalWidth
      + PtUtil.getStringWidth(text:sub(i, i), self.fontSize)
    if totalWidth > maxX then
      self.textClip = i - startI
      return
    end
  end
  self.textClip = nil
end

function TextField:clickEvent(position, button, pressed)
  if button <= 3 then
    local xPos = position[1] - self.x - self.offset[1] - self.hPadding

    local text = self.text
    local totalWidth = 0
    for i=self.textOffset + 1,#text,1 do
      local charWidth = PtUtil.getStringWidth(text:sub(i, i), self.fontSize)
      if xPos < (totalWidth + charWidth * 0.6) then
        self:setCursorPosition(i - 1)
        return
      end
      totalWidth = totalWidth + charWidth
    end
    self:setCursorPosition(#text)

    return true
  end
end

function TextField:keyEvent(keyCode, pressed)
  -- Ignore key releases and any keys pressed while ctrl or alt is held
  local keyState = GUI.keyState
  if not pressed
    or keyState[305] or keyState[306]
    or keyState[307] or keyState[308]
  then
    return
  end
  
  local shift = keyState[303] or keyState[304]
  local caps = keyState[301]
  local key = PtUtil.getKey(keyCode, shift, caps)

  local text = self.text
  local cursorPos = self.cursorPosition

  if #key == 1 then -- Type a character
    self.text = text:sub(1, cursorPos) .. key .. text:sub(cursorPos + 1)
    self:setCursorPosition(cursorPos + 1)
  else -- Special character
    if key == "backspace" then
      if cursorPos > 0 then
        self.text = text:sub(1, cursorPos - 1) .. text:sub(cursorPos + 1)
        self:setCursorPosition(cursorPos - 1)
      end
    elseif key == "enter" then
      if self.onEnter then
        self:onEnter()
      end
    elseif key == "delete" then
      if cursorPos < #text then
        self.text = text:sub(1, cursorPos) .. text:sub(cursorPos + 2)
      end
    elseif key == "right" then
      self:setCursorPosition(math.min(cursorPos + 1, #text))
    elseif key == "left" then
      self:setCursorPosition(math.max(0, cursorPos - 1))
    elseif key == "home" then
      self:setCursorPosition(0)
    elseif key == "end" then
      self:setCursorPosition(#text)
    end
  end
  return true
end

--- Called when the user presses enter in this text field.
-- @function onEnter
