-- A image
Image = class(Component)

-- Constructs a new Image.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width The width of the new component.
-- @param height The height of the new component.
-- @param image The path to the image.
-- @param scale (Optional) Factor to scale the image by.
function Image:_init(x, y, width, height, image, scale)
  Component._init(self)

  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.image = image
  self.scale = scale
end

function Image:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local image = self.image
  local scale = self.scale or 1
  
  PtUtil.drawImage(image, {startX, startY}, scale)
  
  return Component.draw(self, dt)
end
