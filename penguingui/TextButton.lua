--- A button that has a text label.
-- @classmod TextButton
-- @usage
-- -- Create a text button with the text "Hello"
-- local button = TextButton(0, 0, 100, 16, "Hello")
TextButton = class(Button)

--- Constructor
-- @section

--- Constructs a button with a text label.
--
-- @param x The x coordinate of the new component, relative to its parent.
-- @param y The y coordinate of the new component, relative to its parent.
-- @param width The width of the new component.
-- @param height The height of the new component.
-- @param text The text string to display on the button. The button's size will
--             be based on this string.
-- @param fontColor (optional) The color of the text to display, default white.
function TextButton:_init(x, y, width, height, text, fontColor)
  Button._init(self, x, y, width, height)
  local padding = 2
  local fontSize = height - padding * 2
  local label = Label(0, padding, text, fontSize, fontColor)
  self.text = text
  
  self.padding = padding
  self.label = label
  self:add(label)

  self:addListener(
    "text",
    function(t, k, old, new)
      t.label.text = new
      t:repositionLabel()
    end
  )

  self:repositionLabel()
end

--- @section end

-- Centers the text label
function TextButton:repositionLabel()
  local label = self.label
  label.x = (self.width - label.width) / 2
end

--- Called when this button is clicked.
-- @function onClick
--
-- @param button The mouse button that was used.
