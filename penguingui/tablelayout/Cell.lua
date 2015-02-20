-- Cell = class()
Cell = {}

local _ENV = Cell

CENTER = bit32.lshift(1, 0)
TOP = bit32.lshift(1, 1)
BOTTOM = bit32.lshift(1, 2)
LEFT = bit32.lshift(1, 3)
RIGHT = bit32.lshift(1, 4)

local CENTER = CENTER
local TOP = TOP
local BOTTOM = BOTTOM
local LEFT = LEFT
local RIGHT = RIGHT

local widgetValues = {
  "_minWidth", "_minHeight",
  "_prefWidth", "_prefHeight",
  "_maxWidth", "_maxHeight"
}

function _init(self)
  self._minWidth = 0
  self._minHeight = 0
  self._prefWidth = 0
  self._prefHeight = 0
  self._maxWidth = 0
  self._maxHeight = 0
  self._spaceTop = 0
  self._spaceLeft = 0
  self._spaceBottom = 0
  self._spaceRight = 0
  self._padTop = 0
  self._padLeft = 0
  self._padBottom = 0
  self._padRight = 0

  self._fillX = 0
  self._fillY = 0
  self._align = 0
  self._expandX = 0
  self._expandY = 0
  self._ignore = false
  self._colspan = 0
  self._uniformX = false
  self._uniformY = false

  self.widget = nil
  self.widgetX = 0
  self.widgetY = 0
  self.widgetWidth = 0
  self.widgetHeighat = 0

  self.layout = nil
  self.endRow = false
  self._column = 0
  self._row = 0
  self.cellAboveIndex = -1
  self.computedPadTop = 0
  self.computedPadLeft = 0
  self.computedPadBottom = 0
  self.computedPadRight = 0

  self = self._instance or self
  setmetatable(
    self,
    {
      __index = function(t, k)
        for _,value in ipairs(widgetValues) do
          if k == value then
            return t.widget[k]
          end
        end
      end
    }
  )
end

function set(self, defaults)
  self._minWidth = defaults._minWidth
  self._minHeight = defaults._minHeight
  self._prefWidth = defaults._prefWidth
  self._prefHeight = defaults._prefHeight
  self._maxWidth = defaults._maxWidth
  self._maxHeight = defaults._maxHeight
  self._spaceTop = defaults._spaceTop
  self._spaceLeft = defaults._spaceLeft
  self._spaceBottom = defaults._spaceBottom
  self._spaceRight = defaults._spaceRight
  self._padTop = defaults._padTop
  self._padLeft = defaults._padLeft
  self._padBottom = defaults._padBottom
  self._padRight = defaults._padRight
  self._fillX = defaults._fillX
  self._fillY = defaults._fillY
  self._align = defaults._align
  self._expandX = defaults._expandX
  self._expandY = defaults._expandY
  self._ignore = defaults._ignore
  self._colspan = defaults._colspan
  self._uniformX = defaults._uniformX
  self._uniformY = defaults._uniformY
end

function merge(self, cell)
  if not cell then
    return
  end
  self._minWidth = cell._minWidth or self._minWidth
  self._minHeight = cell._minHeight or self._minHeight
  self._prefWidth = cell._prefWidth or self._prefWidth
  self._prefHeight = cell._prefHeight or self._prefHeight
  self._maxWidth = cell._maxWidth or self._maxWidth
  self._maxHeight = cell._maxHeight or self._maxHeight
  self._spaceTop = cell._spaceTop or self._spaceTop
  self._spaceLeft = cell._spaceLeft or self._spaceLeft
  self._spaceBottom = cell._spaceBottom or self._spaceBottom
  self._spaceRight = cell._spaceRight or self._spaceRight
  self._padTop = cell._padTop or self._padTop
  self._padLeft = cell._padLeft or self._padLeft
  self._padBottom = cell._padBottom or self._padBottom
  self._padRight = cell._padRight or self._padRight
  self._fillX = cell._fillX or self._fillX
  self._fillY = cell._fillY or self._fillY
  self._align = cell._align or self._align
  self._expandX = cell._expandX or self._expandX
  self._expandY = cell._expandY or self._expandY
  if cell._ignore ~= nil then
    self._ignore = cell._ignore
  end
  self._colspan = cell._colspan or self._colspan
  if cell._uniformX ~= nil then
    self._uniformX = cell._uniformX
  end
  if cell._uniformY ~= nil then
    self._uniformY = cell._uniformY
  end
end

function setWidget(self, widget)
  self.layout.toolkit.setWidget(self.layout, self, widget)
  return self
end

function getWidget(self)
  return self.widget)
end

function hasWidget(self)
  return self.widget ~= nil
end

function size(self, width, height)
  if height == nil then
    height = width
  end
  self._minWidth = width
  self._minHeight = height
  self._prefWidth = width
  self._prefHeight = height
  self._maxWidth = width
  self._maxHeight = height
  return self
end

function width(self, width)
  self._minWidth = width
  self._prefWidth = width
  self._maxWidth = width
  return self
end

function height(self, height)
  self._minHeight = height
  self._prefHeight = height
  self._maxHeight = height
  return self
end

function minSize(self, width, height)
  self._minWidth = width
  self._minHeight = height or width
  return self
end

function minWidth(self, width)
  self._minWidth = width
  return self
end

function minHeight(self, height)
  self._minHeight = height
  return self
end

function prefSize(self, width, height)
  self._prefWidth = width
  self._prefHeight = height or width
  return self
end

function prefWidth(self, width)
  self._prefWidth = width
  return self
end

function prefHeight(self, height)
  self._prefHeight = height
  return self
end

function maxSize(self, width, height)
  self._maxWidth = width
  self._maxHeight = width or height
  return self
end

function maxWidth(self, width)
  self._maxWidth = width
  return self
end

function maxHeight(self, height)
  self._maxHeight = height
  return self
end

function space(self, top, left, bottom, right)
  self._spaceTop = top
  self._spaceLeft = left or top
  self._spaceBottom = bottom or top
  self._spaceRight = right or top
  return self
end

function spaceTop(self, space)
  self._spaceTop = space
  return self
end

function spaceLeft(self, space)
  self._spaceLeft = space
  return self
end

function spaceBottom(self, space)
  self._spaceBottom = space
  return self
end

function spaceRight(self, space)
  self._spaceRight = space
  return self
end

function pad(self, top, left, bottom, right)
  self._padTop = top
  self._padLeft = left or top
  self._padBottom = bottom or top
  self._padRight = right or top
  return self
end

function padTop(self, pad)
  self._padTop = pad
  return self
end

function padLeft(self, pad)
  self._padLeft = pad
  return self
end

function padBottom(self, pad)
  self._padBottom = pad
  return self
end

function padRight(self, pad)
  self._padRight = pad
  return self
end

function fill(self, x, y)
  if type(x) == "boolean" then
    x = x and 1 or 0
  elseif x == nil then
    x = 1
  end -- Assume X is a number
  if type(y) == "boolean" then
    y = y and 1 or 0
  elseif y == nil then
    y = 1
  end -- Assume Y is a number
  self._fillX = x
  self._fillY = y
  return self
end

function fillX(self, x)
  if type(x) == "boolean" then
    x = x and 1 or 0
  elseif x == nil then
    x = 1
  end -- Assume X is a number
  self._fillX = x
  return self
end

function fillY(self, y)
  if type(y) == "boolean" then
    y = y and 1 or 0
  elseif y == nil then
    y = 1
  end -- Assume Y is a number
  self._fillY = y
  return self
end

function align(self, align)
  self._align = align
  return self
end

function top(self)
  if self._align == nil then
    self._align = TOP
  else
    self._align = bit32.bor(self._align, TOP)
    self._align = bit32.band(self._align, bit32.bnot(BOTTOM))
  end
  return self
end

function left(self)
  if self._align == nil then
    self._align = LEFT
  else
    self._align = bit32.bor(self._align, LEFT)
    self._align = bit32.band(self._align, bit32.bnot(RIGHT))
  end
  return self
end

function bottom(self)
  if self._align == nil then
    self._align = BOTTOM
  else
    self._align = bit32.bor(self._align, BOTTOM)
    self._align = bit32.band(self._align, bit32.bnot(TOP))
  end
  return self
end

function right(self)
  if self._align == nil then
    self._align = RIGHT
  else
    self._align = bit32.bor(self._align, RIGHT)
    self._align = bit32.band(self._align, bit32.bnot(LEFT))
  end
  return self
end

function expand(self, x, y)
  if type(x) == "boolean" then
    x = x and 1 or 0
  elseif x == nil then
    x = 1
  end -- Assume X is a number
  if type(y) == "boolean" then
    y = y and 1 or 0
  elseif y == nil then
    y = 1
  end -- Assume Y is a number
  self._expandX = x
  self._expandY = y
  return self
end

function expandX(self, x)
  if type(x) == "boolean" then
    x = x and 1 or 0
  elseif x == nil then
    x = 1
  end -- Assume X is a number
  self._expandX = x
  return self
end

function expandY(self, y)
  if type(y) == "boolean" then
    y = y and 1 or 0
  elseif y == nil then
    y = 1
  end -- Assume Y is a number
  self._expandY = y
  return self
end

function ignore(self, ignore)
  if ignore == nil then
    self._ignore = true
  else
    self._ignore = ignore
  end
  return self
end

function getIgnore(self)
  return self._ignore ~= nil and self._ignore == true
end

function colspan(self, colspan)
  self._colspan = colspan
  return self
end

function uniform(self, x, y)
  if x == nil then
    self._uniformX = true
  else
    self._uniformX = x
  end
  if y == nil then
    self._uniformY = true
  else
    self._uniformY = y
  end
  return self
end

function uniformX(self, x)
  if x == nil then
    self._uniformX = true
  else
    self._uniformX = x
  end
  return self
end

function uniformY(self, y)
  if y == nil then
    self._uniformY = true
  else
    self._uniformY = y
  end
  return self
end

function getWidgetX(self)
  return self.widgetX
end

function setWidgetX(self, x)
  self.widgetX = x
end

function getWidgetY(self)
  return self.widgetY
end

function setWidgetY(self, y)
  self.widgetY = y
end

function getWidgetWidth(self)
  return self.widgetWidth
end

function setWidgetWidth(self, width)
  self.widgetWidth = width
end

function getWidgetHeight(self)
  return self.widgetHeight
end

function setWidgetHeight(self, height)
  self.widgetHeight = height
end

function getColumn(self)
  return self._column
end

function getRow(self)
  return self._row
end

function getMinWidth(self)
  return self._minWidth == nil and 0 or self._minWidth
end

function getMinHeight(self)
  return self._minHeight == nil and 0 or self._minHeight
end

function getPrefWidth(self)
  return self._prefWidth == nil and 0 or self._prefWidth
end

function getPrefHeight(self)
  return self._prefHeight == nil and 0 or self._prefHeight
end

function getMaxWidth(self)
  return self._maxWidth == nil and 0 or self._maxWidth
end

function getMaxHeight(self)
  return self._maxHeight == nil and 0 or self._maxHeight
end

function getSpaceTop(self)
  return self._spaceTop == nil and 0 or self._spaceTop
end

function getSpaceLeft(self)
  return self._spaceLeft == nil and 0 or self._spaceLeft
end

function getSpaceBottom(self)
  return self._spaceBottom == nil and 0 or self._spaceBottom
end

function getSpaceRight(self)
  return self._spaceRight == nil and 0 or self._spaceRight
end

function getPadTop(self)
  return self._padTop == nil and 0 or self._padTop
end

function getPadLeft(self)
  return self._padLeft == nil and 0 or self._padLeft
end

function getPadBottom(self)
  return self._padBottom == nil and 0 or self._padBottom
end

function getPadRight(self)
  return self._padRight == nil and 0 or self._padRight
end

function getFillX(self)
  return self._fillX
end

function getFillY(self)
  return self._fillY
end

function getAlign(self)
  return self._align
end

function getExpandX(self)
  return self._expandX
end

function getExpandY(self)
  return self._expandY
end

function getColspan(self)
  return self._colspan
end

function getUniformX(self)
  return self._uniformX
end

function getUniformY(self)
  return self._uniformY
end

function isEndRow(self)
  return self.endRow
end

function getComputedPadTop(self)
  return self.computedPadTop
end

function getComputedPadLeft(self)
  return self.computedPadLeft
end

function getComputedPadBottom(self)
  return self.computedPadBottom
end

function getComputedPadRight(self)
  return self.computedPadRight
end

function row(self)
  return self.layout:row()
end

function getLayout(self)
  return self.layout
end

function clear(self)
  self._minWidth = nil
  self._minHeight = nil
  self._prefWidth = nil
  self._prefHeight = nil
  self._maxWidth = nil
  self._maxHeight = nil
  self._spaceTop = nil
  self._spaceLeft = nil
  self._spaceBottom = nil
  self._spaceRight = nil
  self._padTop = nil
  self._padLeft = nil
  self._padBottom = nil
  self._padRight = nil
  self._fillX = nil
  self._fillY = nil
  self._align = nil
  self._expandX = nil
  self._expandY = nil
  self._ignore = nil
  self._colspan = nil
  self._uniformX = nil
  self._uniformY = nil
end

function free(self)
  self.widget = nil
  self.layout = nil
  self.endRow = false
  self.cellAboveIndex = -1
end

function defaults(self)

end
