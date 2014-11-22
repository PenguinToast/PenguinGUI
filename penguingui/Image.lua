--- An image.
-- @classmod Image
-- @usage
-- -- Create a image
-- local image = Image(0, 0, "/path/to/image.png")
Image = class(Component)

--- Constructor
-- @section

--- Constructs a new Image.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param image The path to the image.
-- @param scale (Optional) Factor to scale the image by.
function Image:_init(x, y, image, scale)
  Component._init(self)
  scale = scale or 1
  
  self.x = x
  self.y = y
  local imageSize = root.imageSize(image)
  self.width = imageSize[1] * scale
  self.height = imageSize[2] * scale
  self.image = image
  self.scale = scale
end

--- @section end

function Image:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local image = self.image
  local scale = self.scale
  
  PtUtil.drawImage(image, {startX, startY}, scale)
end
