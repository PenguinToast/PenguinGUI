--- A slider
-- @classmod Slider
-- @usage
-- -- Create a slider
-- local slider = Slider(0, 0, 100, 12)
-- slider:addListener(
--   "percentage",
--   function(t, k, old, new)
--     world.logInfo("Slider is now at %s percent", new)
--   end)
Slider = class(Component)
--- The color of the slider line.
Slider.lineColor = "#878787"
--- The thickness of the slider line.
Slider.lineSize = 2
--- The color of the slider handle border.
Slider.handleBorderColor = "#B1B1B1"
--- The thickness of the slider handle border.
Slider.handleBorderSize = 1
--- The color of the slider handle.
Slider.handleColor = Slider.lineColor
--- The size of the slider handle.
Slider.handleSize = 5

--- Constructor
-- @section

--- Constructs a new Slider.
-- New sliders are by default horizontal.
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width The width of the new component.
-- @param height The height of the new component.
-- @param[opt] vertical If true, the slider will be vertical.
function Slider:_init(x, y, width, height, vertical)
  Component._init(self)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.vertical = vertical
  self.percentage = 0
end

--- @section end

function Slider:update(dt)
  
end

function Slider:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height

  local percentage = self.percentage
  local handleBorderSize = self.handleBorderSize
  local handleSize = self.handleSize
  local handleBorderRect
  local handleRect
  if self.vertical then
    PtUtil.drawLine({startX + w / 2, startY},
      {startX + w / 2, startY + h}, self.lineColor, self.lineSize)
    local sliderY = startY + percentage * (h - handleSize)
    handleBorderRect = {startX, sliderY, startX + w, sliderY + handleSize}
    handleRect = {startX + handleBorderSize, sliderY + handleBorderSize
                  , startX + w - handleBorderSize
                  , sliderY + handleSize - handleBorderSize}
  else
    PtUtil.drawLine({startX, startY + h / 2},
      {startX + w, startY + h / 2}, self.lineColor, self.lineSize)
    local sliderX = startX + percentage * (w - handleSize)
    handleBorderRect = {sliderX, startY, sliderX + handleSize, startY + h}
    handleRect = {sliderX + handleBorderSize, startY + handleBorderSize
                  , sliderX + handleSize - handleBorderSize
                  , startY + h - handleBorderSize}
  end
  PtUtil.drawRect(handleBorderRect, self.handleBorderColor, handleBorderSize)
  PtUtil.fillRect(handleRect, self.handleColor)
end


