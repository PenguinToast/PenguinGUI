-- Cell = class()
Cell = {}

local _ENV = Cell

function _init(self)
  self.minWidth = 0
  self.minHeight = 0
  self.prefWidth = 0
  self.prefHeight = 0
  self.maxWidth = 0
  self.maxHeight = 0
  self.spaceTop = 0
  self.spaceLeft = 0
  self.spaceBottom = 0
  self.spaceRight = 0
  self.padTop = 0
  self.padLeft = 0
  self.padBottom = 0
  self.padRight = 0

  self.fillX = 0
  self.fillY = 0
  self.align = 0
  self.expandX = 0
  self.expandY = 0
  self.ignore = false
  self.colspan = 0
  self.uniformX = false
  self.uniformY = false

  self.widget = nil
  self.widgetX = 0
  self.widgetY = 0
  self.widgetWidth = 0
  self.widgetHeighat = 0

  self.layout = nil
  self.endRow = false
  self.column = 0
  self.row = 0
  self.cellAboveIndex = -1
  self.computedPadTop = 0
  self.computedPadLeft = 0
  self.computedPadBottom = 0
  self.computedPadRight = 0
end

function set(self, defaults)
  self.minWidth = defaults.minWidth
  self.minHeight = defaults.minHeight
  self.prefWidth = defaults.prefWidth
  self.prefHeight = defaults.prefHeight
  self.maxWidth = defaults.maxWidth
  self.maxHeight = defaults.maxHeight
  self.spaceTop = defaults.spaceTop
  self.spaceLeft = defaults.spaceLeft
  self.spaceBottom = defaults.spaceBottom
  self.spaceRight = defaults.spaceRight
  self.padTop = defaults.padTop
  self.padLeft = defaults.padLeft
  self.padBottom = defaults.padBottom
  self.padRight = defaults.padRight
  self.fillX = defaults.fillX
  self.fillY = defaults.fillY
  self.algin = defaults.algin
  self.expandX = defaults.expandX
  self.expandY = defaults.expandY
  self.ignore = defaults.ignore
  self.colspan = defaults.colspan
  self.uniformX = defaults.uniformX
  self.uniformY = defaults.uniformY
end

function merge(self, cell)
  if not cell then
    return
  end
  self.minWidth = cell.minWidth or self.minWidth
  self.minHeight = cell.minHeight or self.minHeight
  self.prefWidth = cell.prefWidth or self.prefWidth
  self.prefHeight = cell.prefHeight or self.prefHeight
  self.maxWidth = cell.maxWidth or self.maxWidth
  self.maxHeight = cell.maxHeight or self.maxHeight
  self.spaceTop = cell.spaceTop or self.spaceTop
  self.spaceLeft = cell.spaceLeft or self.spaceLeft
  self.spaceBottom = cell.spaceBottom or self.spaceBottom
  self.spaceRight = cell.spaceRight or self.spaceRight
  self.padTop = cell.padTop or self.padTop
  self.padLeft = cell.padLeft or self.padLeft
  self.padBottom = cell.padBottom or self.padBottom
  self.padRight = cell.padRight or self.padRight
  self.fillX = cell.fillX or self.fillX
  self.fillY = cell.fillY or self.fillY
  self.align = cell.align or self.align
  self.expandX = cell.expandX or self.expandX
  self.expandY = cell.expandY or self.expandY
  if cell.ignore ~= nil then
    self.ignore = cell.ignore
  end
  self.colspan = cell.colspan or self.colspan
  if cell.uniformX ~= nil then
    self.uniformX = cell.uniformX
  end
  if cell.uniformY ~= nil then
    self.uniformY = cell.uniformY
  end
end

function setWidget(self, widget)
  self.layout.toolkit.setWidget(self.layout, self, widget)
  return self
end

function hasWidget(self)
  return self.widget ~= nil
end

function size(self, width, height)
  if height == nil then
    height = width
  end
  self.minWidth = width
  self.minHeight = height
  self.prefWidth = width
  self.prefHeight = height
  self.maxWidth = width
  self.maxHeight = height
  return self
end

function width(self, width)
  self.minWidth = width
  self.prefWidth = width
  self.maxWidth = width
  return self
end

function height(self, height)
  self.minHeight = height
  self.prefHeight = height
  self.maxHeight = height
  return self
end

function setMinSize(self, width, height)
  self.minWidth = width
  self.minHeight = height or width
  return self
end

function setMinWidth(self, width)
  self.minWidth = width
  return self
end

function setMinHeight(self, height)
  self.minHeight = height
  return self
end

function setPrefSize(self, width, height)
  self.prefWidth = width
  self.prefHeight = height or width
  return self
end

function setPrefWidth(self, width)
  self.prefWidth = width
  return self
end

function setPrefHeight(self, height)
  self.prefHeight = height
  return self
end

function setMaxSize(self, width, height)
  self.maxWidth = width
  self.maxHeight = width or height
  return self
end

function setMaxWidth(self, width)
  self.maxWidth = width
  return self
end

function setMaxHeight(self, height)
  self.maxHeight = height
  return self
end

function space(self, top, left, bottom, right)
  self.spaceTop = top
  self.spaceLeft = left or top
  self.spaceBottom = bottom or top
  self.spaceRight = right or top
  return self
end

function setSpaceTop(self, space)
  self.spaceTop = space
  return self
end

function setSpaceLeft(self, space)
  self.spaceLeft = space
  return self
end

function setSpaceBottom(self, space)
  self.spaceBottom = space
  return self
end

function setSpaceRight(self, space)
  self.spaceRight = space
  return self
end

function pad(self, top, left, bottom, right)
  self.padTop = top
  self.padLeft = left or top
  self.padBottom = bottom or top
  self.padRight = right or top
  return self
end

function setPadTop(self, pad)
  self.padTop = pad
  return self
end

function setPadLeft(self, pad)
  self.padLeft = pad
  return self
end

function setPadBottom(self, pad)
  self.padBottom = pad
  return self
end

function setPadRight(self, pad)
  self.padRight = pad
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
  self.fillX = x
  self.fillY = y
  return self
end


