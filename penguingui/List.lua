--- A scrollable list
-- @classmod List
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
      if self.horizontal then
        return TextRadioButton(0, 0, size, height
                                 - (self.borderSize * 2
                                      + self.itemPadding * 2), text)
      else
        return TextRadioButton(0, 0, width
                                 - (self.borderSize * 2
                                      + self.itemPadding * 2
                                      + self.scrollBarSize + 2),
                               size, text)
      end
    end
  self.items = {}
  self.topIndex = 1
  self.bottomIndex = nil
  self.mouseOver = false
end

--- @section end

function List:update(dt)
  -- Handle scroll bar dragging
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
  else
    local items = self.items
    local numItems
    if bottomIndex == nil then
      numItems = #items + 1 - topIndex
    else
      numItems = bottomIndex - topIndex
    end
    self.scrollBarLength = maxLength * (numItems / #items)
    self.scrollBarOffset = (topIndex - 1) * (maxLength / #items)
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
  if button >= 4 then
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
