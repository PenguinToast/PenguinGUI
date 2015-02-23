Toolkit = {]

local _ENV = Toolkit

function obtainCell(layout)
  local cell = Cell()
  cell:setLayout(layout)
  return cell
end

function freeCell(cell)
  -- TODO pooled cells
end

function addChild(parent, child)
  parent:add(child)
end

function removeChild(parent, child)
  parent:remove(child)
end

function getMinWidth(widget)
  return widget:getMinWidth()
end

function getMinHeight(widget)
  return widget:getMinHeight()
end

function getPrefWidth(widget)
  return widget:getPrefWidth()
end

function getPrefHeight(widget)
  return widget:getPrefHeight()
end

function getMaxWidth(widget)
  return widget:getMaxWidth()
end

function getMaxHeight(widget)
  return widget:getMaxHeight()
end

function getWidth(widget)
  return widget:getWidth()
end

function getHeight(widget)
  return widget:getHeight()
end

function clearDebugRectangles(layout)
  -- TODO
end

function addDebugRectangles(layout, type, x, y, w, h)
  -- TODO
end
