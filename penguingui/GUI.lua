-- Base handler for all the GUI stuff
GUI = {
  components = {},
  mouseState = {},
  keyState = {},
  mousePosition = {0, 0}
}

-- Add a new top-level component to be handled by PenguinGUI.
function GUI.add(component)
  GUI.components[#GUI.components + 1] = component
end

-- Must be called in canvasClickEvent to handle mouse events.
--
-- @param position The position of the click.
-- @param button The mouse button of the click.
-- @param pressed Whether the event is pressed or released.
function GUI.clickEvent(position, button, pressed)
  GUI.mouseState[button] = pressed
  for _,component in ipairs(GUI.components) do
    -- Only check bounds if the component has a clickEvent
    if component.clickEvent then
      if component:contains(position) then
        component:clickEvent(position, button, pressed)
      end
    end
  end
end

-- Must be called in canvasKeyEvent to handle keyboard events.
--
-- @param key The keycode of the key that spawned the event.
-- @param pressed Whether the key was pressed or released.
function GUI.keyEvent(key, pressed)
  GUI.keyState[key] = pressed
end

-- Must be called in update to draw and update the GUI.
function GUI.draw()
  GUI.mousePosition = console.canvasMousePosition()
  for _,component in ipairs(GUI.components) do
    -- Also check for hover functions
    if component.mouseOver ~= nil then
      if component:contains(GUI.mousePosition) then
        component.mouseOver = true
      else
        component.mouseOver = false
      end
    end

    if component.visible ~= false then
      component:draw()
    end
  end
end

