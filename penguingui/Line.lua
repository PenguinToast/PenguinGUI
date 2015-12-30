--- A line.
-- @classmod Line
-- @usage
-- -- Create a horizontal line
-- local line = Line(0, 10, 20, 10)
Line = class(Component)
--- The color of the line.
Line.color = {0, 0, 0}
--- The width of the line.
Line.size = 1

--- Constructor
-- @section

--- Constructs a new Line.
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param endX The ending x coordinate of the line.
-- @param endY The ending y coordinate of the line.
-- @param[opt="black"] color The color of the new component.
-- @param[opt=1] lineSize The width of the line.
function Line:_init(x, y, endX, endY, color, lineSize)
  Component._init(self)
  self.x = x
  self.y = y
  self.endX = x
  self.endY = y
  self.width = endX - x
  self.height = endY - y
  self.color = color
  self.size = size
end

-- @section end

function Line:draw(dt)
  local offset = self.offset
  local startX = self.x + offset[1]
  local startY = self.y + offset[2]
  local endX = self.endX + offset[1]
  local endY = self.endY + offset[2]

  local size = self.size
  local color = self.color
  PtUtil.drawLine({startX, startY}, {endX, endY}, color, width)
end

