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
Slider.lineColor = "black"
--- The thickness of the slider line.
Slider.lineSize = 2
--- The color of the slider handle border.
Slider.handleBorderColor = "#B1B1B1"
--- The thickness of the slider handle border.
Slider.handleBorderSize = 1
--- The color of the slider handle.
Slider.handleColor = Slider.lineColor
--- The color of the slider handle when the mouse is over it.
Slider.handleHoverColor = "#323232"
--- The color of the slider handle when it is being dragged.
Slider.handlePressedColor = "#545454"
--- The size of the slider handle.
Slider.handleSize = 5
--- The current value of the slider.
Slider.value = nil
--- The maximum value of the slider.
Slider.maxValue = nil
--- The minimum value of the slider.
Slider.minValue = nil

--- Constructor
-- @section

--- Constructs a new Slider.
-- New sliders are by default horizontal.
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width The width of the new component.
-- @param height The height of the new component.
-- @param[opt=0.0] min The maximum value of this slider. The slider will slide from
--      min to max.
-- @param[opt=1.0] max The maximum value of this slider. The slider will slide from
--      min to max.
-- @param[opt=nil] step The step size to snap the slider to. If nil, the slider will
--      slide smoothly.
-- @param[opt=false] vertical If true, the slider will be vertical.
function Slider:_init(x, y, width, height, min, max, step, vertical)
  Component._init(self)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.mouseOver = false
  self.minValue = min or 0
  self.maxValue = max or 1
  self.valueStep = step
  self.vertical = vertical
  self.value = self.minValue
  self:addListener(
    "maxValue",
    function(t, k, old, new)
      if t.value > new then
        t.value = new
      end
    end
  )
end

--- @section end

function Slider:update(dt)
  if self.dragging then
    if not GUI.mouseState[1] then
      self.dragging = false
    else
      local mousePos = GUI.mousePosition
      local lineSize = self.lineSize
      local min = self.minValue
      local max = self.maxValue
      local len = max - min
      local step = self.valueStep
      local sliderValue
      if self.vertical then
        sliderValue = (mousePos[2] - self.dragOffset
                         - (self.y + self.offset[2] + lineSize)
                      ) / (self.height - lineSize * 2 - self.handleSize) * len
      else
        sliderValue = (mousePos[1] - self.dragOffset
                         - (self.x + self.offset[1] + lineSize)
                      ) / (self.width - lineSize * 2 - self.handleSize) * len
      end
      if sliderValue ~= sliderValue then -- sliderValue is NaN
        sliderValue = 0
      end
      sliderValue = math.max(sliderValue, 0)
      sliderValue = math.min(sliderValue, len)
      if step then
        local stepFreq = 1 / step
        sliderValue = math.floor(sliderValue * stepFreq + 0.5) / stepFreq
      end
      sliderValue = sliderValue + min
      self.value = sliderValue
    end
  end
  if self.moving ~= nil then
    if not GUI.mouseState[1] then
      self.moving = nil
    else
      local step = self.valueStep
      local direction = self.moving
      local max = self.maxValue
      local min = self.minValue
      local len = max - min
      if not step then
        step = len / 100
      end
      local value = self.value
      if direction then
        self.value = math.min(value + step, max)
      else
        self.value = math.max(value - step, min)
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
  local percentage = self:getPercentage()
  local handleBorderSize = self.handleBorderSize
  local handleSize = self.handleSize
  local slidableLength
  local handleBorderRect
  local handleRect
  if self.vertical then
    PtUtil.drawLine({startX + w / 2, startY},
      {startX + w / 2, startY + h}, lineColor, lineSize)
    PtUtil.drawLine({startX, startY + lineSize / 2}
      , {startX + w, startY + lineSize / 2}, lineColor, lineSize)
    PtUtil.drawLine({startX, startY + h - lineSize / 2}
      , {startX + w, startY + h - lineSize / 2}, lineColor, lineSize)
      
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

--- Get the percentage of max that this slider's value is at.
-- @return A percentage, from 0 to 1 inclusive.
function Slider:getPercentage()
  local min = self.minValue
  local max = self.maxValue
  local len = max - min
  if len == 0 then
    return 0
  else
    return (self.value - min) / len
  end
end

function Slider:clickEvent(position, button, pressed)
  if button == 1 then -- Only react to LMB
    if pressed then
      local startX = self.x + self.offset[1]
      local startY = self.y + self.offset[2]
      local w = self.width
      local h = self.height

      local lineSize = self.lineSize
      local handleSize = self.handleSize
      local percentage = self:getPercentage()
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
        handleY = startY
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
          if position[2] < handleY then
            self.moving = false
          else
            self.moving = true
          end
        else
          if position[1] < handleX then
            self.moving = false
          else
            self.moving = true
          end
        end
      end
    end
    return true
  end
end
