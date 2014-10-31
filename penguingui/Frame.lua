-- A window
Frame = class(Panel)
Frame.borderColor = "black"
Frame.borderThickness = 1
Frame.backgroundColor = "#232323"

function Frame:_init()
  Panel._init(self)
end

function Frame:draw(dt)
  if self.dragging then
    if self.hasFocus then
      local mousePos = GUI.mousePosition
      self.x = self.x + (mousePos[1] - self.dragOrigin[1])
      self.y = self.y + (mousePos[2] - self.dragOrigin[2])
      self.layout = true
      self.dragOrigin = mousePos
    else
      self.dragging = false
    end
  end
  
  local startX = self.x - self.offset[1]
  local startY = self.y - self.offset[2]
  local w = self.width
  local h = self.height
  local border = self.borderThickness
  
  local borderRect = {
    startX, startY,
    startX + w, startY + h
  }
  local backgroundRect = {
    startX + border / 2, startY + border / 2,
    startX + w - border / 2, startY + h - border / 2
  }
  
  PtUtil.drawRect(borderRect, self.borderColor, border)
  PtUtil.fillRect(backgroundRect, self.backgroundColor)

  return Panel.draw(self, dt)
end

function Frame:clickEvent(position, button, pressed)
  if pressed then
    self.dragging = true
    self.dragOrigin = position
  else
    self.dragging = false
  end
end
