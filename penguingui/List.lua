--- A scrollable list
-- @classmod List
-- @usage
-- -- Create a list of 20 items
-- local list = List(0, 0, 100, 100, 12)
-- for i=1,20,1 do
--   local item = list:emplaceItem("Item " .. i)
--   item:addListener("selected", function() world.logInfo(item.text) end)
-- end
List = class(Component)
--- The border color of this list.
List.borderColor = "#545454"
--- The thickness of this list's border.
List.borderSize = 1
--- The background color of this list.
List.backgroundColor = "black"
--- Padding in between items.
List.itemPadding = 2
--- Thickness of the scroll bar
List.scrollBarSize = 3

--- Constructor
-- @section

--- Constructs a new List.
-- New lists are by default vertical.
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width The width of the new component.
-- @param height The height of the new component.
-- @param itemSize The height(if vertical) or width (if horizontal) of each
--      list item.
-- @param[opt] itemFactory A function to return a new item. The first argument
--      should be item size. Defaults to creating TextRadioButtons.
function List:_init(x, y, width, height, itemSize, itemFactory)
  Component._init(self)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.itemSize = itemSize
  self.itemFactory = itemFactory or
    function(size, text)
      return TextRadioButton(0, 0, width
                               - (self.borderSize * 2
                                    + self.itemPadding * 2
                                    + self.scrollBarSize + 2),
                             size, text)
    end
  self.items = {}
  self.topIndex = 1
  self.bottomIndex = nil
  self.mouseOver = false
end

--- @section end

function List:update(dt)
  -- Handle scroll bar dragging
  if self.barDragging then
    if not GUI.mouseState[1] or self.scrollBarTickCount == 0 then
      -- Stop dragging
      self.barDragging = false
    else
      local mousePos = GUI.mousePosition
      local dragPos
      local dragOffset = self.barDragOffset
      if self.horizontal then
        dragPos = (mousePos[1] - dragOffset) - self.x + self.offset[1]
          + self.borderSize + 0.5
      else
        dragPos = self.y + self.offset[2] + self.height - self.borderSize
          - 0.5 - (dragOffset + mousePos[2])
      end
      local tickSize = self.scrollBarTick
      local newTop = math.floor(dragPos / tickSize + 0.5)
      newTop = math.max(newTop, 0)
      newTop = math.min(newTop, self.scrollBarTickCount)
      self.topIndex = newTop + 1
      self:positionItems()
    end
  end
  if self.barMoving ~= nil then
    if not GUI.mouseState[1] then
      self.barMoving = nil
    else
      self:scroll(self.barMoving)
    end
  end
end

function List:draw(dt)
  local startX = self.x + self.offset[1]
  local startY = self.y + self.offset[2]
  local w = self.width
  local h = self.height

  local borderSize = self.borderSize
  local borderColor = self.borderColor
  local borderRect = {startX, startY, startX + w, startY + h}
  local rect = {startX + 1, startY + 1, startX + w - 1, startY + h - 1}
  PtUtil.drawRect(borderRect, borderColor, borderSize)
  PtUtil.fillRect(rect, self.backgroundColor)

  -- Draw scroll bar
  local scrollBarSize = self.scrollBarSize
  if self.horizontal then
    -- Start with border
    local lineY = startY + borderSize + scrollBarSize + 1.5
    PtUtil.drawLine({startX, lineY}, {startX + w, lineY}, borderColor, 1)
    -- Now the bar
    local scrollLeft = startX + borderSize + 0.5
    local scrollY = startY + borderSize + 0.5
    local scrollBarLength = self.scrollBarLength
    local scrollX = scrollTop + self.scrollBarOffset
    PtUtil.fillRect({scrollX, scrollY,
                     scrollX + scrollBarLength, scrollY + self.scrollBarSize},
      borderColor)
  else
    -- Start with border
    local lineX = startX + w - borderSize - scrollBarSize - 1.5
    PtUtil.drawLine({lineX, startY}, {lineX, startY + h}, borderColor, 1)
    -- Now the bar
    local scrollTop = startY + h - borderSize - 0.5
    local scrollX = lineX + 1
    local scrollBarLength = self.scrollBarLength
    local scrollY = scrollTop - self.scrollBarOffset - scrollBarLength
    PtUtil.fillRect({scrollX, scrollY,
                     scrollX + self.scrollBarSize, scrollY + scrollBarLength},
      borderColor)
  end
end

--- Constructs and adds an item to this list.
-- @param ... Arguments to pass to the item constructor.
-- @return The newly created list item.
-- @return The list index of the new list item.
function List:emplaceItem(...)
  return self:addItem(self.itemFactory(self.itemSize, ...))
end

--- Adds an item to this list.
-- @param item The item to add to this list.
-- @return The item added to this list.
-- @return The list index of the added item.
function List:addItem(item)
  self:add(item)
  local items = self.items
  local index = #items + 1
  items[index] = item
  self:positionItems()
  return item, index
end

--- Removes an item from this list.
-- @param item Either the item to remove, or the index of the item to remove.
-- @return The removed item, or nil if the item was not removed.
-- @return The index of the removed item, or -1 if the item was not removed.
function List:removeItem(item)
  if type(item) == "number" then -- Remove by index
    local removed = table.remove(self.items, item)
    if not removed then
      return nil, -1
    end
    self:remove(removed)
    self:positionItems()
    if self.bottomIndex == nil then
      self:scroll(true)
    end
    return removed, item
  else -- Remove by item
    local index = PtUtil.removeObject(self.items, item)
    if index == -1 then
      return nil, -1
    end
    self:remove(item)
    self:positionItems()
    if self.bottomIndex == nil then
      self:scroll(true)
    end
    return item, index
  end
end

--- Removes all items from this list.
function List:clearItems()
  for index,item in ripairs(self.items) do
    self:removeItem(index)
  end
end

--- Retrieve the item at a given index.
-- @param index The index to retrieve the item from.
-- @return The item at the given index, or nil if there is none.
function List:getItem(index)
  return self.items[index]
end

--- Get the index of the given item.
-- @param item The item to find the index of.
-- @return The index of the item, or -1 if the item was not found.
function List:indexOfItem(item)
  for index,obj in ipairs(self.items) do
    if item == obj then
      return index
    end
  end
  return -1
end

-- Positions and clips items
function List:positionItems()
  local items = self.items
  local padding = self.itemPadding
  local border = self.borderSize
  local topIndex = self.topIndex
  local itemSize = self.itemSize
  local current
  local min
  if self.horizontal then
    current = border
    min = border + padding
  else
    current = self.height - border
    min = border + padding
  end
  local past = false
  for i,item in ipairs(items) do
    if i < topIndex or past then
      item.visible = false
    else
      item.visible = nil
      if self.horizontal then
        item.y = min
        current = current + (padding + itemSize)
        item.x = current
        if current + itemSize > self.width - borderSize then
          item.visible = false
          self.bottomIndex = i
          past = true
        end
      else
        item.x = min
        current = current - (padding + itemSize)
        item.y = current
        if current < border then
          item.visible = false
          self.bottomIndex = i
          past = true
        end
      end
    end
    item.layout = true
  end
  if not past then
    self.bottomIndex = nil
  end
  self:updateScrollBar()
end

-- Calculate scroll bar stuff
function List:updateScrollBar()
  local maxLength
  local offset
  if self.horizontal then
    maxLength = self.width - (self.borderSize * 2 + 1)
  else
    maxLength = self.height - (self.borderSize * 2 + 1)
  end
  local topIndex = self.topIndex
  local bottomIndex = self.bottomIndex
  if bottomIndex == nil and topIndex == 1 then
    self.scrollBarLength = maxLength
    self.scrollBarOffset = 0
    self.scrollBarTick = 0
    self.scrollBarTickCount = 0
  else
    local items = self.items
    local numItems -- Number of displayed items
    if bottomIndex == nil then
      numItems = #items + 1 - topIndex
    else
      numItems = bottomIndex - topIndex
    end
    local barLength = math.max(
      numItems * maxLength / #items,
      self.scrollBarSize)
    local barTick = (maxLength - barLength) / math.max((#items - numItems), 1)
    self.scrollBarLength = barLength
    self.scrollBarOffset = (topIndex - 1) * barTick
    self.scrollBarTick = barTick
    self.scrollBarTickCount = #items - numItems
  end
end

--- Scroll the list one item.
--
-- @param up Up or down.
function List:scroll(up)
  if up then
    self.topIndex = math.max(self.topIndex - 1, 1)
  else
    if self.bottomIndex then
      self.topIndex = self.topIndex + 1
    end
  end
  self:positionItems()
end

function List:clickEvent(position, button, pressed)
  if button >= 4 then -- scroll
    if pressed then
      if button == 4 then -- Scroll up
        self:scroll(true)
      else -- Scroll down
        self:scroll(false)
      end
    end
    return true
  elseif button == 1 then -- scrollbar
    local startX = self.x + self.offset[1]
    local startY = self.y + self.offset[2]
    local w = self.width
    local h = self.height
    local borderSize = self.borderSize
    local scrollBarSize = self.scrollBarSize
    local scrollBarLength = self.scrollBarLength
    
    local scrollX
    local scrollY
    local scrollWidth
    local scrollHeight
    if self.horizontal then
      scrollX = startX + borderSize
      scrollY = startY + borderSize
      scrollWidth = w - (borderSize * 2)
      scrollHeight = scrollBarSize + 1
    else
      scrollX = startX + w - borderSize - scrollBarSize - 1
      scrollY = startY + borderSize
      scrollWidth = scrollBarSize + 1
      scrollHeight = h - (borderSize * 2)
    end
    if position[1] >= scrollX and position[1] <= scrollX + scrollWidth
      and position[2] >= scrollY and position[2] <= scrollY + scrollHeight
    then -- In scroll bar area
      local barX
      local barY
      local barWidth
      local barHeight
      if self.horizontal then
        barX = scrollX + self.scrollBarOffset
        barY = scrollY
        barWidth = scrollBarLength + 1
        barHeight = scrollHeight
      else
        barX = scrollX
        barY = scrollY + scrollHeight - self.scrollBarOffset - (scrollBarLength + 1)
        barWidth = scrollWidth
        barHeight = scrollBarLength + 1
      end
      if position[1] >= barX and position[1] <= barX + barWidth
        and position[2] >= barY and position[2] <= barY + barHeight
      then -- In scroll bar
        local dragOffset
        if self.horizontal then
          dragOffset = position[1] - (barX + 0.5)
        else
          dragOffset = (barY + barHeight - 0.5) - position[2]
        end
        self.barDragOffset = dragOffset
        self.barDragging = true
      else -- In empty space
        if self.horizontal then
          if position[1] < barX then
            self.barMoving = true
          else
            self.barMoving = false
          end
        else
          if position[2] > barY + barHeight then
            self.barMoving = true
          else
            self.barMoving = false
          end
        end
      end
    end
  end
end
