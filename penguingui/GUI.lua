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

-- Sets the focus of the GUI to the component
function GUI.setFocusedComponent(component)
  local focusedComponent = GUI.focusedComponent
  if focusedComponent then
    focusedComponent.hasFocus = false
  end
  GUI.focusedComponent = component
  component.hasFocus = true
end

-- Must be called in canvasClickEvent to handle mouse events.
--
-- @param position The position of the click.
-- @param button The mouse button of the click.
-- @param pressed Whether the event is pressed or released.
function GUI.clickEvent(position, button, pressed)
  GUI.mouseState[button] = pressed
  local components = GUI.components
  for _,component in ipairs(components) do
    GUI.clickEventHelper(component, position, button, pressed)
  end
end

function GUI.clickEventHelper(component, position, button, pressed)
  -- Only check bounds if the component has a clickEvent
  if component.clickEvent then
    if component:contains(position) then
      GUI.setFocusedComponent(component)
      component:clickEvent(position, button, pressed)
    end
  end
  local children = component.children
  for _,child in ipairs(children) do
    GUI.clickEventHelper(child, position, button, pressed)
  end
end

-- Must be called in canvasKeyEvent to handle keyboard events.
--
-- @param key The keycode of the key that spawned the event.
-- @param pressed Whether the key was pressed or released.
function GUI.keyEvent(key, pressed)
  GUI.keyState[key] = pressed
  local component = GUI.focusedComponent
  if component then
    local keyEvent = component.keyEvent
    if keyEvent then
      keyEvent(component, key, pressed)
    end
  end
end

-- Must be called in update to draw and update the GUI.
--
-- @param dt The time elapsed since the last draw, in seconds.
function GUI.draw(dt)
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
      component:draw(dt)
    end
  end
end

