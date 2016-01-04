--- A rectangle.
-- @classmod Rectangle
-- @usage
-- -- Create a filled square
-- local rect = Rectangle(0, 0, 10, 10)
Rectangle = class(Component)
--- The color of the rectangle.
Rectangle.color = {0, 0, 0}
--- The width of the line, if not filled.
Rectangle.lineSize = nil

--- Constructor
-- @section

--- Constructs a new Rectangle.
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width The width of the new component.
-- @param height The height of the new component.
-- @param[opt="black"] color The color of the new component.
-- @param[opt=nil] lineSize The width of the line, if nil, the rectangle will
--      be filled.
function Rectangle:_init(x, y, width, height, color, lineSize)
  Component._init(self)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.color = color
  self.lineSize = lineSize
end

-- @section end

function Rectangle:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height

  local rect = {startX, startY, startX + w, startY + h}
  local lineSize = self.lineSize
  local color = self.color
  if lineSize then
    PtUtil.drawRect(rect, color, lineSize)
  else
    PtUtil.fillRect(rect, color)
  end
end
