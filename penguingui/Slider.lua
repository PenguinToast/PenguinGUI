--- A slider
-- @classmod Slider
-- @usage
-- -- Create a slider
-- local slider = Slider(0, 0, 100, 12)
-- slider:addListener(
--   "value",
--   function(t, k, old, new)
--     world.logInfo("Slider is now at %s", new)
--   end)
Slider = class(Component)
--- The color of the slider line.
Slider.lineColor = "#676767"
--- The thickness of the slider line.
Slider.lineSize = 2
--- The color of the slider handle border.
Slider.handleBorderColor = "#B1B1B1"
--- The thickness of the slider handle border.
Slider.handleBorderSize = 1
--- The color of the slider handle.
Slider.handleColor = Slider.lineColor
--- The color of the slider handle when the mouse is over it.
Slider.handleHoverColor = "#A0A0A0"
--- The color of the slider handle when it is being dragged.
Slider.handlePressedColor = "#C0C0C0"
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
-- @param[opt=1] max The maximum value of this slider. The slider will slide from
--      0 to max.
-- @param[opt=nil] step The step size to snap the slider to. If nil, the slider will
--      slide smoothly.
-- @param[opt=false] vertical If true, the slider will be vertical.
function Slider:_init(x, y, width, height, max, step, vertical)
  Component._init(self)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.mouseOver = false
  self.max = max or 1
  self.step = step
  self.vertical = vertical
  self.value = 0
end

--- @section end

function Slider:update(dt)
  if self.dragging then
    if not GUI.mouseState[1] then
      self.dragging = false
    else
      local mousePos = GUI.mousePosition
      local slidableLength
      if self.vertical then
        
      else

      end
    end
  end
  if self.moving ~= nil then
    if not GUI.mouseState[1] then
      self.moving = nil
    else
      local step = self.step
      local direction = self.moving
      local max = self.max
      if not step then
        step = max / 100
      end
      local value = self.value
      if direction then
        self.value = math.min(value + step, max)
      else
        self.value = math.max(value - step, 0)
      end
    end
  end
end

function Slider:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height

  local lineSize = self.lineSize
  local lineColor = self.lineColor
  local percentage = self.value / self.max
  local handleBorderSize = self.handleBorderSize
  local handleSize = self.handleSize
  local slidableLength
  local handleBorderRect
  local handleRect
  if self.vertical then
    PtUtil.drawLine({startX + w / 2, startY},
      {startX + w / 2, startY + h}, lineColor, lineSize)
    PtUtil.drawLine({startX, startY + handleSize / 2}
      , {startX + w, startY + handleSize / 2}, lineColor, lineSize)
    PtUtil.drawLine({startX, startY + h - handleSize / 2}
      , {startX + w, startY + h - handleSize / 2}, lineColor, lineSize)
      
    slidableLength = h - lineSize * 2 - handleSize
    local sliderY = startY + lineSize + percentage * slidableLength
    handleBorderRect = {startX, sliderY, startX + w, sliderY + handleSize}
    handleRect = {startX + handleBorderSize, sliderY + handleBorderSize
                  , startX + w - handleBorderSize
                  , sliderY + handleSize - handleBorderSize}
  else
    PtUtil.drawLine({startX, startY + h / 2},
      {startX + w, startY + h / 2}, self.lineColor, self.lineSize)
    PtUtil.drawLine({startX + lineSize / 2, startY},
      {startX + lineSize / 2, startY + h}, lineColor, lineSize)
    PtUtil.drawLine({startX + w - lineSize / 2, startY},
      {startX + w - lineSize / 2, startY + h}, lineColor, lineSize)
    
    slidableLength = w - lineSize * 2 - handleSize
    local sliderX = startX + lineSize + percentage * slidableLength
    handleBorderRect = {sliderX, startY, sliderX + handleSize, startY + h}
    handleRect = {sliderX + handleBorderSize, startY + handleBorderSize
                  , sliderX + handleSize - handleBorderSize
                  , startY + h - handleBorderSize}
  end
  PtUtil.drawRect(handleBorderRect, self.handleBorderColor, handleBorderSize)
  local handleColor
  if self.dragging then
    handleColor = self.handlePressedColor
  elseif self.mouseOver then
    handleColor = self.handleHoverColor
  else
    handleColor = self.handleColor
  end
  PtUtil.fillRect(handleRect, handleColor)
end

function Slider:clickEvent(position, button, pressed)
  if button == 1 then -- Only react to LMB
    local startX = self.x + self.offset[1]
    local startY = self.y + self.offset[2]
    local w = self.width
    local h = self.height

    local lineSize = self.lineSize
    local handleSize = self.handleSize
    local percentage = self.value / self.max
    local handleX
    local handleY
    local handleWidth
    local handleHeight
    if self.vertical then
      local slidableLength = h - lineSize * 2 - handleSize
      handleX = startX
      handleY = startY + lineSize + percentage * slidableLength
      handleWidth = w
      handleHeight = handleSize
    else
      local slidableLength = w - lineSize * 2 - handleSize
      handleX = startX + lineSize + percentage * slidableLength
      handleWidth = handleSize
      handleHeight = h
    end
    if position[1] >= handleX and position[1] <= handleX + handleWidth
      and position[2] >= handleY and position[2] <= handleY + handleHeight
    then
      -- Drag handle
      local dragOffset
      if self.vertical then
        dragOffset = position[2] - handleY
      else
        dragOffset = position[1] - handleX
      end
      self.dragOffset = dragOffset
      self.dragging = true
    else
      -- Move handle
      if self.vertical then
        if position[2] < barY then
          self.moving = false
        else
          self.moving = true
        end
      else
        if position[1] < barX then
          self.moving = false
        else
          self.moving = true
        end
      end
    end
  end
end
