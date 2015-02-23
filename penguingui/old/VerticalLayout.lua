--- Lays out components vertically.
-- @classmod VerticalLayout
-- @usage
-- -- Create a vertical layout manager with padding of 2.
-- local layout = VerticalLayout(2)
VerticalLayout = class()

--- Padding between contained components.
VerticalLayout.padding = nil
--- Vertical alignment of contained components.
-- Default top.
VerticalLayout.vAlignment = Align.TOP
--- Horizontal alignment of contained components.
-- Default center.
VerticalLayout.hAlignment = Align.CENTER

--- Constructor
-- @section

--- Constructs a VerticalLayout.
--
-- @param[opt=0] padding The padding between components within this layout.
-- @param[opt=Align.TOP] vAlign The vertical alignment of the components.
-- @param[opt=Align.CENTER] hAlign The horizontal alignment of the components.
function VerticalLayout:_init(padding, vAlign, hAlign)
  self.padding = padding or 0
  if hAlign then
    self.hAlignment = hAlign
  end
  if vAlign then
    self.vAlignment = vAlign
  end
end

--- @section end

function VerticalLayout:layout()
  local vAlign = self.vAlignment
  local hAlign = self.hAlignment
  local padding = self.padding

  local container = self.container
  local components = container.children
  local totalHeight = 0
  for _,component in ipairs(components) do
    totalHeight = totalHeight + component.height
  end
  totalHeight = totalHeight + (#components - 1) * padding

  local startY
  if vAlign == Align.TOP then
    startY = container.height
  elseif vAlign == Align.CENTER then
    startY = container.height - (container.height - totalHeight) / 2
  else -- ALIGN_BOTTOM
    startY = totalHeight
  end

  for _,component in ipairs(components) do
    component.y = startY - component.height
    if hAlign == Align.LEFT then
      component.x = 0
    elseif hAlign == Align.CENTER then
      component.x = (container.width - component.width) / 2
    else -- ALIGN_RIGHT
      component.x = container.width - component.width
    end
    startY = startY - (component.height + padding)
  end
end
