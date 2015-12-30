--- A window.
-- @classmod Frame
-- @usage
-- -- Create a window
-- local frame = Frame(0, 0)
-- frame.width = 100
-- frame.height = 100
Frame = class(Panel)
--- The color of this frame's border.
Frame.borderColor = {0, 0, 0}
--- The thickness of this frame's border.
Frame.borderThickness = 1
--- The color of this frame.
Frame.backgroundColor = {35, 35, 35}

--- Constructor
-- @section

--- Constructs a Frame.
-- 
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
function Frame:_init(x, y)
  Panel._init(self, x, y)
end

--- @section end

function Frame:update(dt)
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
end

function Frame:draw(dt)
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
    startX + border, startY + border,
    startX + w - border, startY + h - border
  }
  
  PtUtil.drawRect(borderRect, self.borderColor, border)
  PtUtil.fillRect(backgroundRect, self.backgroundColor)
end

function Frame:clickEvent(position, button, pressed)
  if pressed then
    self.dragging = true
    self.dragOrigin = position
  else
    self.dragging = false
  end
  return true
end
