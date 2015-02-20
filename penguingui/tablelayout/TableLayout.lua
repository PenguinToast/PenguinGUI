--- Lua port of the Java TableLayout library

-- TableLayout = class()
TableLayout = {}

local _ENV = TableLayout

local NULL = {}

CENTER = bit32.lshift(1, 0)
TOP = bit32.lshift(1, 1)
BOTTOM = bit32.lshift(1, 2)
LEFT = bit32.lshift(1, 3)
RIGHT = bit32.lshift(1, 4)

Debug = {
  NONE = 0,
  ALL = 1,
  TABLE = 2,
  CELL = 3,
  WIDGET = 4
}

local CENTER = CENTER
local TOP = TOP
local BOTTOM = BOTTOM
local LEFT = LEFT
local RIGHT = RIGHT
local Debug = Debug

function _init(self, toolkit)
  self.toolkit = nil
  self.tableWidget = nil
  self.columns = 0
  self.rows = 0
  
  self.cells = {}
  self.cellDefaults = nil
  self.columnDefaults = {}
  self.rowDefaults = nil

  self.sizeInvalid = true
  self.columnMinWidth = {}
  self.rowMinHeight = {}
  self.columnPrefWidth = {}
  self.rowPrefHeight = {}
  self.tableMinWidth = 0
  self.tableMinHeight = 0
  self.tablePrefWidth = 0
  self.tablePrefHeight = 0
  self.columnWidth = {}
  self.rowHeight = {}
  self.expandWidth = {}
  self.expandHeight = {}
  self.columnWeightedWidth = {}
  self.rowWeightedHeight = {}

  self._padTop = nil
  self._padLeft = nil
  self._padBottom = nil
  self._padRight = nil
  self._align = CENTER
  self._debug = Debug.NONE 
  
  self.toolkit = toolkit
  self.cellDefaults = toolkit.obtainCell(self)
  self.cellDefaults:defaults()
end

function invalidate(self)
  self.sizeInvalid = true
end

function invalidateHierarchy(self)
  -- TODO implementation
end

function add(self, widget)
  local cells = self.cells
  local cell = self.toolkit.obtainCell(self)
  cell.widget = widget

  if #cells > 0 then
    -- Set cell column and row
    local lastCell = cells[#cells]
    if not lastCell.endRow then
      cell._column = lastCell._column + lastCell._colspan
      cell._row = lastCell._row
    else
      cell._column = 1
      cell._row = lastCell._row + 1
    end
    -- Set index of cell above
    if cell._row > 1 then
      for i=#cells,1,-1 do
        local other = cells[i]
        local column = other._column
        local nn = column + other._colspan
        while column < nn do
          if column == cell._column then
            cell.cellAboveIndex = i
            goto outer
          end
          column = column + 1
        end
      end
      ::outer::
    end
  else
    cell._column = 1
    cell._row = 1
  end
  table.insert(cells, cell)

  cell:set(self.cellDefaults)
  if cell._column <= #self.columnDefaults then
    local columnCell = self.columnDefaults[cell._column]
    if columnCell ~= NULL then
      cell:merge(columnCell)
    end
  end
  cell:merge(self.rowDefaults)

  if widget ~= nil then
    self.toolkit.addChild(self.tableWidget, widget)
  end

  return cell
end

--- Indicates that subsequent cells should be added to a new row and returns the
-- cell values that will be used as the defaults for all cells in the new row.
function row(self)
  if #cells > 0 then
    self:endRow()
  end
  if self.rowDefaults ~= nil then
    self.toolkit.freeCell(self.rowDefaults)
  end
  self.rowDefaults = toolkit.obtainCell(self)
  self.rowDefaults:clear()
  return self.rowDefaults
end

function endRow(self)
  local cells = self.cells
  local rowColumns = 0
  for i=#cells,1,-1 do
    local cell = cells[i]
    if cell.endRow then
      break
    end
    rowColumns = rowColumns + cell._colspan
  end
  self.columns = math.max(self.columns, rowColumns)
  self.rows = self.rows + 1
  cells[#cells].endRow = true
  self:invalidate()
end

function columnDefaults(self, column)
  local cell = #self.columnDefaults >= column and
    self.columnDefaults[column] or nil
  if cell == nil then
    cell = self.toolkit.obtainCell(self)
    cell:clear()
    if column > #self.columnDefaults then
      for i=#self.columnDefaults,column-2,1 do
        table.insert(self.columnDefaults, NULL)
      end
      table.insert(self.columnDefaults, cell)
    else
      self.columnDefaults[column] = cell
    end
  end
  return cell
end

function reset(self)
  self:clear()
  self._padTop = nil
  self._padLeft = nil
  self._padBottom = nil
  self._padRight = nil
  self._align = CENTER
  if self._debug ~= Debug.NONE then
    self.toolkit.clearDebugRectangles(self)
  end
  self._debug = Debug.NONE
  self.cellDefaults:defaults()
  local i = 1
  local n = #self.columnDefaults
  while i <= n do
    local columnCell = self.columnDefaults[i]
    if columnCell ~= NULL then
      self.toolkit.freeCell(columnCell)
    end
    i = i + 1
  end
  self.columnDefaults = {}
end

function clear(self)
  for i=#self.cells,1,-1 do
    local cell = self.cells[i]
    local widget = cell.widget
    if widget ~= nil then
      self.toolkit.removeChild(self.tableWidget, widget)
    end
    self.toolkit.freeCell(cell)
  end
  self.cells = {}
  self.rows = 0
  self.columns = 0
  if self.rowDefaults ~= nil then
    self.toolkit.freeCell(self.rowDefaults)
  end
  self.rowDefaults = nil
  self:invalidate()
end

function getCell(self, widget)
  local n = #self.cells
  for i=1,n,1 do
    local c = self.cells[i]
    if c.widget == widget then
      return c
    end
  end
  return nil
end

function getCells(self)
  return self.cells
end

function setToolkit(self, toolkit)
  self.toolkit = toolkit
end

function getTable(self)
  return self.tableWidget
end

function setTable(self, table)
  self.tableWidget = table
end

function getMinWidth(self)
  if self.sizeInvalid then
    self:computeSize()
  end
  return self.tableMinWidth
end

function getMinHeight(self)
  if self.sizeInvalid then
    self:computeSize()
  end
  return self.tableMinHeight
end

function getPrefWidth(self)
  if self.sizeInvalid then
    self:computeSize()
  end
  return self.tablePrefWidth
end

function getPrefHeight(self)
  if self.sizeInvalid then
    self:computeSize()
  end
  return self.tablePrefHeight
end

function defaults(self)
  return self.cellDefaults
end

function pad(self, pad)
  self._padTop = pad
  self._padLeft = pad
  self._padBottom = pad
  self._padRight = pad
  self.sizeInvalid = true
  return self
end

function pad(self, top, left, bottom, right)
  self._padTop = top
  self._padLeft = left
  self._padBottom = bottom
  self._padRight = right
  self.sizeInvalid = true
  return self
end

function padTop(self, padTop)
  self._padTop = padTop
  self.sizeInvalid = true
  return self
end

function padLeft(self, padLeft)
  self._padLeft = padLeft
  self.sizeInvalid = true
  return self
end

function padBottom(self, padBottom)
  self._padBottom = padBottom
  self.sizeInvalid = true
  return self
end

function padRight(self, padRight)
  self._padRight = padRight
  self.sizeInvalid = true
  return self
end

function align(self, align)
  self._align = align
  return self
end

function center(self)
  self._align = CENTER
  return self
end

function top(self)
  self._align = bit32.bor(self._align, TOP)
  self._align = bit32.band(self._align, bit32.bnot(BOTTOM))
  return self
end

function left(self)
  self._align = bit32.bor(self._align, LEFT)
  self._align = bit32.band(self._align, bit32.bnot(RIGHT))
  return self
end

function bottom(self)
  self._align = bit32.bor(self._align, BOTTOM)
  self._align = bit32.band(self._align, bit32.bnot(TOP))
  return self
end

function right(self)
  self._align = bit32.bor(self._align, RIGHT)
  self._align = bit32.band(self._align, bit32.bnot(LEFT))
  return self
end

function debugTable(self)
  self._debug = Debug.TABLE
  self:invalidate()
  return self
end

function debugCell(self)
  self._debug = Debug.CELL
  self:invalidate()
  return self
end

function debugWidget(self)
  self._debug = Debug.WIDGET
  self:invalidate()
  return self
end

function debug(self, debug)
  if debug == nil then
    self._debug = Debug.ALL
    self:invalidate()
  else
    self._debug = debug
    if debug == Debug.NONE then
      self.toolkit.clearDebugRectangles(self)
    else
      self:invalidate()
    end
  end
  return self
end

function getDebug(self)
  return self._debug
end

function getPadTop(self)
  return self._padTop
end

function getPadLeft(self)
  return self._padLeft
end

function getPadBottom(self)
  return self._padBottom
end

function getPadRight(self)
  return self._padRight
end

function getAlign()
  return self._align
end

function getRow(self, y)
  local row = 0
  y = y + self._padTop
  local i = 1
  local n = #self.cells
  if n == 0 then
    return -1
  end
  if n == 1 then
    return 1
  end
  -- Using y-up coordinate system
  while i <= n do
    local c = self.cells[i]
    i = i + 1
    if c:getIgnore() then
      -- continue
    else
      if c.widgetY + c.computedPadTop < y then
        break
      end
      if c.endRow then
        row = row + 1
      end
    end
  end
  return row
end

function ensureSize(array, size)
  if array == nil or #array < size then
    local out = {}
    for i=1,size,1 do
      out[i] = 0
    end
    return out
  end
  local n = #array
  for i=1,n,1 do
    array[i] = 0
  end
  return array
end

function computeSize(self)
  self.sizeInvalid = false

  local toolkit = self.toolkit
  local cells = self.cells

  if #cells > 0 and not cells[#cells].endRow then
    self:endRow()
  end

  local columnMinWidth = ensureSize(self.columnMinWidth, columns)
  self.columnMinWidth = columnMinWidth
  local rowMinHeight = ensureSize(self.rowMinHeight, rows)
  self.rowMinHeight = rowMinHeight
  local columnPrefWidth = ensureSize(self.columnPrefWidth, columns)
  self.columnPrefWidth = columnPrefWidth
  local rowPrefHeight = ensureSize(self.rowPrefHeight, rows)
  self.rowPrefHeight = rowPrefHeight
  local columnWidth = ensureSize(self.columnWidth, columns)
  self.columnWidth = columnWidth
  local rowHeight = ensureSize(self.rowHeight, rows)
  self.rowHeight = rowHeight
  local expandWidth = ensureSize(self.expandWidth, columns)
  self.expandWidth = expandWidth
  local expandHeight = ensureSize(self.expandHeight, rows)
  self.expandHeight = expandHeight

  local spaceRightLast = 0
  local n = #cells
  for i=1,n,1 do
    local c = cells[i]
    if not c._ignore then

      -- Collect columns/rows that expand.
      if c._expandY ~= 0 and expandHeight[c._row] == 0 then
        expandHeight[c._row] = c.expandY
      end
      if c._colspan == 1 and c._expandX ~= 0 and expandWidth[c._column] == 0 then
        expandWidth[c._column] = c.expandX
      end

      -- Compute combined padding/spacing for cells
      -- Spacing between widgets isn't additive, the larger is used.
      -- ALso, no spacing around edges.
      c.computedPadLeft = c._padLeft +
        (c._column == 1 and 0 or math.max(0, c._spaceLeft - spaceRightLast))
      c.computedPadTop = c._padTop
      if c.cellAboveIndex ~= -1 then
        local above = cells[c.cellAboveIndex]
        c.computedPadTop = c.computedPadTop +
          math.max(0, c._spaceTop - above.spaceBottom)
      end
      local spaceRight = c.spaceRight
      c.computedPadRight = c._padRight +
        ((c._column + c._colspan) == columns + 1 and 0 or spaceRight)
      c.computedPadBottom = c._padBottom + (c._row == rows and 0 or c.spaceBottom)
      spaceRightLast = spaceRight

      -- Determine minimum and preferred cell sizes.
      local prefWidth = c.prefWidth
      local prefHeight = c.prefHeight
      local minWidth = c.minWidth
      local minHeight = c.minHeight
      local maxWidth = c.maxWidth
      local maxHeight = c.maxHeight
      if prefWidth < minWidth then
        prefWidth = minWidth
      end
      if prefHeight < minHeight then
        prefHeight = minHeight
      end
      if maxWidth > 0 and prefWidth > maxWidth then
        prefWidth = maxWidth
      end
      if maxHeight > 0 and prefHeight > maxHeight then
        prefHeight = maxHeight
      end

      if c._colspan == 1 then
        local hpadding = c.computedPadLeft + c.computedPadRight
        columnPrefWidth[c._column] = math.max(columnPrefWidth[c.column],
                                             prefWidth + hpadding)
        columnMinWidth[c._column] = math.max(columnMinWidth[c.column],
                                            minWidth + hpadding)
      end
      local vpadding = c.computedPadTop + c.computedPadBottom
      rowPrefHeight[c._row] = math.max(rowPrefHeight[c.row],
                                      prefHeight + vpadding)
      rowMinHeight[c._row] = math.max(rowMinHeight[c.row],
                                     minHeight + vpadding)
    end
  end

  for i=1,n,1 do
    local c = cells[i]
    if not (c._ignore or c._expandX == 0) then
      local nn = c._column + c.colspan
      for column=c._column,nn,1 do
        if expandWidth[column] ~= 0 then
          goto continue2
        end
      end
      nn = column + c.colspan
      for column=c._column,nn,1 do
        expandWidth[column] = c.expandX
      end
    end
  end

  for i=1,n,1 do
    local c = cells[i]
    if not (c._ignore or c._colspan == 1) then
      local minWidth = c.minWidth
      local prefWidth = c.prefWidth
      local maxWidth = c.maxWidth
      if prefWidth < minWidth then
        prefWidth = minWidth
      end
      if maxWidth > 0 and prefWidth > maxWidth then
        prefWidth = maxWidth
      end

      local spannedMinWidth = -(c.computedPadLeft + c.computedPadRight)
      local spannedPrefWidth = spannedMinWidth
      local nn = c._column + c.colspan
      for column=c._column,nn,1 do
        spannedMinWidth = spannedMinWidth + columnMinWidth[column]
        spannedPrefWidth = spannedPrefWidth + columnPrefWidth[column]
      end

      local totalExpandWidth = 0
      nn = column + c.colspan
      for column=c._column,nn,1 do
        totalExpandWidth = totalExpandWidth + column
      end

      local extraMinWidth = math.max(0, minWidth - spannedMinWidth)
      local extraPrefWidth = math.max(0, prefWidth - spannedPrefWidth)
      nn = column + c.colspan
      for column=c._column,nn,1 do
        local ratio = totalExpandWidth == 0 and 1 / c._colspan or
          expandWidth[column] / totalExpandWidth
        columnMinWidth[column] = columnMinWidth[column] + extraMinWidth * ratio
        columnPrefWidth[column] = columnPrefWidth[column] + extraPrefWidth
          * ratio
      end
    end
  end

  -- Collect uniform size
  local uniformMinWidth = 0
  local uniformMinHeight = 0
  local uniformPrefWidth = 0
  local uniformPrefHeight = 0
  for i=1,n,1 do
    local c = cells[i]
    if not c._ignore then
      -- Collect uniform sizes.
      if c._uniformX == true and c._colspan == 1 then
        local hpadding = c.computedPadLeft + c.computedPadRight
        uniformMinWidth = math.max(uniformMinWidth, columnMinWidth[c._column] -
                                     hpadding)
        uniformPrefWidth = math.max(uniformPrefWidth, columnPrefWidth[c._column] -
                                      hpadding)
      end
      if c._uniformY == true then
        local vpadding = c.computedPadTop + c.computedPadBottom
        uniformMinHeight = math.max(uniformMinHeight, columnMinHeight[c._column] -
                                      vpadding)
        uniformPrefHeight = math.max(uniformPrefHeight,
                                     columnPrefHeight[c._column] - vpadding)
      end
    end
  end

  -- Size uniform cells to the same width/height
  if uniformPrefWidth > 0 or uniformPrefHeight > 0 then
    for i=1,n,1 do
      local c = cells[i]
      if not c._ignore then
        if uniformPrefWidth > 0 and c._uniformX == true and c._colspan == 1 then
          local hpadding = c.computedPadLeft + c.computedPadRight
          columnMinWidth[c._column] = uniformMinWidth + hpadding
          columnPrefWidth[c._column] = uniformPrefWidth + hpadding
        end
        if uniformPrefHeight > 0 and c._uniformY == true then
          local vpadding = c.computedPadTop + c.computedPadBottom
          rowMinHeight[c._column] = uniformMinHeight + vpadding
          rowPrefHeight[c._column] = uniformPrefHeight + vpadding
        end
      end
    end
  end

  -- Determine table min and pref size.
  self.tableMinWidth = 0
  self.tableMinHeight = 0
  self.tablePrefWidth = 0
  self.tablePrefHeight = 0
  for i=1,columns,1 do
    self.tableMinWidth = self.tableMinWidth + columnMinWidth[i]
    self.tablePrefWidth = self.tablePrefWidth + columnPrefWidth[i]
  end
  for i=1,rows,1 do
    self.tableMinHeight = self.tableMinHeight + rowMinHeight[i]
    self.tablePrefHeight = self.tablePrefHeight + math.max(
      rowPrefHeight[i], rowMinHeight[i])
  end
  local hpadding = self._padLeft + self._padRight
  local vpadding = self._padTop + self._padBottom
  self.tableMinWidth = self.tableMinWidth + hpadding
  self.tableMinHeight = self.tableMinHeight + vpadding
  self.tablePrefWidth = math.max(self.tablePrefWidth + hpadding,
                                 self.tableMinWidth)
  self.tablePrefHeight = math.max(self.tablePrefHeight + vpadding,
                                  self.tableMinHeight)
end

function layout(self, layoutX, layoutY, layoutWidth, layoutHeight)
  local toolkit = self.toolkit
  local cells = self.cells

  if self.sizeInvalid then
    self:computeSize()
  end

  local hpadding = self._padLeft + self._padRight
  local vpadding = self._padTop + self._padBottom

  local totalExpandWidth = 0
  local totalExpandHeight = 0
  for i=1,self.columns,1 do
    totalExpandWidth = totalExpandWidth + self.expandWidth[i]
  end
  for i=1,self.rows,1 do
    totalExpandHeight = totalExpandHeight + self.expandHeight[i]
  end

  -- Size columns and rows between min and pref size using (preferred - min)
  -- size to weight distributions of extra space.
  local columnWeightedWidth
  local totalGrowWidth = self.tablePrefWidth - self.tableMinWidth
  if totalGrowWidth == 0 then
    self.columnWeightedWidth = self.columnMinWidth
  else
    local extraWidth = math.min(totalGrowWidth,
                                math.max(0,
                                         layoutWidth - self.tableMinWidth))
    columnWeightedWidth = ensureSize(self.columnWeightedWidth, columns)
    self.columnWeightedWidth = columnWeightedWidth
    for i=1,columns,1 do
      local growWidth = self.columnPrefWidth[i] - self.columnMinWidth[i]
      local growRatio = growWidth / totalGrowWidth
      self.columnWeightedWidth[i] = self.columnMinWidth[i] +
        extraWidth * growRatio
    end
  end

  local rowWeightedHeight
  local totalGrowHeight = self.tablePrefHeight - self.tableMinHeight
  if totalGrowHeight == 0 then
    self.rowWeightedHeight = self.rowMinHeight
  else
    local extraHeight = math.min(totalGrowHeight,
                                 math.max(0,
                                          layoutHeight - self.tableMinHeight))
    rowWeightedHeight = ensureSize(self.rowWeightedHeight, rows)
    self.rowWeightedHeight = rowWeightedHeight
    for i=1,rows,1 do
      local growHeight = self.rowPrefHeight[i] - self.rowMinHeight[i]
      local growRatio = growHeight / totalGrowHeight
      self.rowWeightedHeight[i] = self.rowMinHeight[i] +
        extraHeight * growRatio
    end
  end

  -- Determine widget and cell sizes (before expand or fill)
  local n = #cells
  for i=1,n,1 do
    local c = cells[i]
    if not c._ignore then
      local spannedWeightedWidth = 0
      local nn = c._column + c.colspan
      for column=c._column,nn,1 do
        spannedWeightedWidth = spannedWeightedWidth +
          self.columnWeightedWidth[column]
      end
      local weightedHeight = self.rowWeightedHeight[c.row]

      local prefWidth = c.prefWidth
      local prefHeight = c.prefHeight
      local minWidth = c.minWidth
      local minHeight = c.minHeight
      local maxWidth = c.maxWidth
      local maxHeight = c.maxHeight
      if prefWidth < minWidth then
        prefWidth = minWidth
      end
      if prefHeight < minHeight then
        prefHeight = minHeight
      end
      if maxWidth > 0 and prefWidth > maxWidth then
        prefWidth = maxWidth
      end
      if maxHeight > 0 and prefHeight > maxHeight then
        prefHeight = maxHeight
      end

      c.widgetWidth = math.min(spannedWeightedWidth - c.computedPadLeft -
                                 c.computedPadRight, prefWidth)
      c.widgetHeight = math.min(spannedWeightedHeight - c.computedPadTop -
                                  c.computedPadBottom, prefHeight)

      if c._colspan == 1 then
        self.columnWidth[c._column] = math.max(self.columnWidth[c.column],
                                              spannedWeightedWidth)
      end
      self.rowHeight[c._row] = math.max(self.rowHeight[c._row], weightedHeight)
    end
  end

  -- Distribute remaining space to any expanding columns/rows.
  if totalExpandWidth > 0 then
    local extra = layoutWidth - hpadding
    for i=1,self.columns,1 do
      extra = extra - self.columnWidth[i]
    end
    local used = 0
    local lastIndex = 0
    for i=1,self.columns,i do
      if self.expandWidth[i] ~= 0 then
        local amount = extra * self.expandWidth[i] / totalExpandWidth
        self.columnWidth[i] = self.columnWidth[i] + amount
        used = used + amount
        lastIndex = i
      end
    end
    self.columnWidth[lastIndex] = self.columnWidth[lastIndex] + extra - used
  end
  if totalExpandHeight > 0 then
    local extra = layoutHeight - vpadding
    for i=1,self.rows,1 do
      extra = extra - self.rowHeight[i]
    end
    local used = 0
    local lastIndex = 0
    for i=1,self.rows,i do
      if self.expandHeight[i] ~= 0 then
        local amount = extra * self.expandHeight[i] / totalExpandHeight
        self.rowHeight[i] = self.rowHeight[i] + amount
        used = used + amount
        lastIndex = i
      end
    end
    self.rowHeight[lastIndex] = self.rowHeight[lastIndex] + extra - used
  end

  -- Distribute any additional width added by colspanned cells to the columns
  -- spanned.
  for i=1,n,1 do
    local c = cells[i]
    if not c._ignore and c._colspan ~= 1 then
      local extraWidth = 0
      local nn = c._column + c.colspan
      for column=c._column,nn,1 do
        extraWidth = extraWidth + self.columnWeightedWidth[column] -
          self.columnWidth[column]
      end
      extraWidth = extraWidth - math.max(0, c.computedPadLeft +
                                           c.computedPadRight)

      extraWidth = extraWidth / c.colspan
      if extraWidth > 0 then
        for column=c._column,nn,1 do
          self.columnWidth[column] = self.columnWidth[column] + extraWidth
        end
      end
    end
  end

  -- Determine table size.
  local tableWidth = hpadding
  local tableHeight = vpadding
  for i=1,self.columns,1 do
    tableWidth = tableWidth + self.columnWidth[i]
  end
  for i=1,self.rows,1 do
    tableHeight = tableHeight + self.rowHeight[i]
  end

  -- Position table within the container.
  local x = layoutX + self._padLeft
  if bit32.band(self._align, RIGHT) ~= 0 then
    x = x + layoutWidth - tableWidth
  elseif bit32.band(self._align, LEFT) == 0 then -- Center
    x = x + (layoutWidth - tableWidth) / 2
  end

  local y = layoutY + self._padLeft
  if bit32.band(self._align, BOTTOM) ~= 0 then
    y = y + layoutHeight - tableHeight
  elseif bit32.band(self._align, TOP) == 0 then -- Center
    y = y + (layoutHeight - tableHeight) / 2
  end

  -- Position widgets within cells.
  local currentX = x
  local currentY = y
  for i=1,n,1 do
    local c = cells[i]
    if not c._ignore then
      local spannedCellWidth = 0
      local nn = c._column + c.colspan
      for column=c._column,nn,1 do
        spannedCellWidth = spannedCellWidth + self.columnWidth[column]
      end
      spannedCellWidth = spannedCellWidth -
        (c.computedPadLeft + c.computedPadRight)

      currentX = currentX + c.computedPadLeft

      if c._fillX > 0 then
        c.widgetWidth = spannedCellWidth * c.fillX
        local maxWidth = c.maxWidth
        if maxWidth > 0 then
          c.widgetWidth = math.min(c.widgetWidth, maxWidth)
        end
      end
      if c._fillY > 0 then
        c.widgetHeight = self.rowHeight[c._row] * c._fillY - c.computedPadTop -
          c.computedPadBottom
        local maxHeight = c.maxHeight
        if maxHeight > 0 then
          c.widgetHeight = math.min(c.widgetHeight, maxHeight)
        end
      end

      if bit32.band(c._align, LEFT) ~= 0 then
        c.widgetX = currentX
      elseif bit32.band(c._align, RIGHT) ~= 0 then
        c.widgetX = currentX + spannedCellWidth - c.widgetWidth
      else
        c.widgetX = currentX + (spannedCellWidth - c.widgetWidth) / 2
      end

      if bit32.band(c._align, TOP) ~= 0 then
        c.widgetY = currentY + c.computedPadTop
      elseif bit32.band(c._align, BOTTOM) ~= 0 then
        c.widgetY = currentY + self.rowHeight[c._row] - c.widgetHeight -
          c.computedPadBottom
      else
        c.widgetY = currentY + (self.rowHeight[c._row] - c.widgetHeight +
                                  c.computedPadTop - c.computedPadBottom) / 2
      end

      if c.endRow then
        currentX = x
        currentY = currentY + self.rowHeight[c.row]
      else
        currentX = currentX + spannedCellWidth + c.computedPadRight
      end
    end
  end

  -- Draw debug widgets and bounds.
  if self._debug == Debug.NONE then
    return
  end
  toolkit.clearDebugRectangles(self)
  currentX = x
  currentY = y
  if self._debug == Debug.TABLE or self._debug == Debug.ALL then
    toolkit.addDebugRectangle(self, Debug.TABLE, layoutX, layoutY, layoutWidth,
                              layoutHeight)
    toolkit.addDebugRectangle(self, Debug.TABLE, x, y, tableWidth - hpadding,
                              tableHeight - vpadding)
  end
  for i=1,n,1 do
    local c = cells[i]
    if not c._ignore then
      -- Widget bounds.
      if self._debug == Debug.WIDGET or self._debug == Debug.ALL then
        toolkit.addDebugRectangle(self, Debug.WIDGET, c.widgetX, c.widgetY,
                                  c.widgetWidth, c.widgetHeight)
      end

      -- Cell bounds.
      local spannedCellWidth = 0
      local nn = c._column + c.colspan
      for column=c._column,nn,1 do
        spannedCellWdith = spannedCellWidth + self.columnWidth[column]
      end
      spannedCellWidth = spannedCellWidth - (c.computedPadLeft +
                                               c.computedPadRight)
      currentX = currentX + c.computedPadLeft
      if self._debug == Debug.CELL or self._debug == Debug.ALL then
        toolkit.addDebugRectangle(self, Debug.CELL, currentX, currentY +
                                    c.computedPadTop, spannedCellWidth,
                                  self.rowHeight[c._row] - c.computedPadTop -
                                    c.computedPadBottom)
      end

      if c.endRow then
        currentX = x
        currentY = currentY + self.rowHeight[c._row]
      else
        currentX = currentX + spannedCellWidth + c.computedPadRight
      end
    end
  end
end
