--- Lays out components horizontally.
-- @classmod HorizontalLayout
-- @usage
-- -- Create a horizontal layout manager with padding of 2.
-- local layout = HorizontalLayout(2)
HorizontalLayout = class()

--- Padding between contained components.
HorizontalLayout.padding = nil
--- Vertical alignment of contained components.
-- Default center.
HorizontalLayout.vAlignment = Align.CENTER
--- Horizontal alignment of contained components.
-- Default left.
HorizontalLayout.hAlignment = Align.LEFT

--- Constructor
-- @section

--- Constructs a HorizontalLayout.
--
-- @param[opt=0] padding The padding between components within this layout.
-- @param[opt=Align.LEFT] hAlign The horizontal alignment of the components.
-- @param[opt=Align.CENTER] vAlign The vertical alignment of the components.
function HorizontalLayout:_init(padding, hAlign, vAlign)
  self.padding = padding or 0
  if hAlign then
    self.hAlignment = hAlign
  end
  if vAlign then
    self.vAlignment = vAlign
  end
end

--- @section end

function HorizontalLayout:layout(container)
  local vAlign = self.vAlignment
  local hAlign = self.hAlignment
  local padding = self.padding

  local components = container.children
  local totalWidth = 0
  for _,component in ipairs(components) do
    totalWidth = totalWidth + component.width
  end
  totalWidth = totalWidth + (#components - 1) * padding

  local startX
  if hAlign == Align.LEFT then
    startX = 0
  elseif hAlign == Align.CENTER then
    startX = (container.width - totalWidth) / 2
  else -- ALIGN_RIGHT
    startX = container.width - totalWidth
  end

  for _,component in ipairs(components) do
    component.x = startX
    if vAlign == Align.TOP then
      component.y = container.height - component.height
    elseif vAlign == Align.CENTER then
      component.y = (container.height - component.height) / 2
    else -- ALIGN_BOTTOM
      component.y = 0
    end
    startX = startX + component.width + padding
  end
end
