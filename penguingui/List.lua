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
-- @param[opt=false] horizontal If true, this list will be horizontal.
function List:_init(x, y, width, height, itemSize, itemFactory, horizontal)
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

  -- Create scrollbar
  local borderSize = self.borderSize
  local barSize = self.scrollBarSize
  local slider
  if horizontal then
    slider = Slider(borderSize + 0.5, borderSize + 0.5
                    , width - borderSize * 2 - 1, barSize, 0, 1, false)
  else
    slider = Slider(width - borderSize - barSize - 0.5
                    , borderSize + 0.5, barSize
                    , height - borderSize * 2 - 1, 0, 1, true)
  end
  slider.lineSize = 0
  slider.handleBorderSize = 0
  slider:addListener(
    "value",
    function(t, k, old, new)
      local list = t.parent
      if list.horizontal then
        list.topIndex = new + 1
      else
        list.topIndex = t.maxValue - t.value + 1
      end
      list:positionItems()
    end
  )
  self.slider = slider
  self:add(slider)
end

--- @section end

function List:update(dt)
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

  -- Draw scroll bar border
  local scrollBarSize = self.scrollBarSize
  if self.horizontal then
    local lineY = startY + borderSize + scrollBarSize + 1.5
    PtUtil.drawLine({startX, lineY}, {startX + w, lineY}, borderColor, 1)
  else
    local lineX = startX + w - borderSize - scrollBarSize - 1.5
    PtUtil.drawLine({lineX, startY}, {lineX, startY + h}, borderColor, 1)
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
  local slider = self.slider
  local offset
  if self.horizontal then
    maxLength = slider.width
  else
    maxLength = slider.height
  end
  local topIndex = self.topIndex
  local bottomIndex = self.bottomIndex
  if bottomIndex == nil and topIndex == 1 then
    slider.handleSize = maxLength
    slider.maxValue = 0
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
    slider.handleSize = barLength
    slider.maxValue = #items - numItems
    if self.horizontal then
      slider.value = topIndex - 1
    else
      slider.value = slider.maxValue - (topIndex - 1)
    end
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
  end
end
