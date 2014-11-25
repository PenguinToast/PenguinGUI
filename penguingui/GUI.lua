--- Base handler for all the GUI stuff.
-- @module GUI
-- @usage -- A simple script that creates a button that closes the console.
-- function init()
--   local button = TextButton(0, 0, 100, 16, "Close")
--   button.onClick = function(mouseButton)
--     console.dismiss()
--   end
--   GUI.add(button)
-- end
--
-- function update(dt)
--   GUI.step(dt)
-- end
--
-- function canvasClickEvent(position, button, pressed)
--   GUI.clickEvent(position, button, pressed)
-- end
--
-- function canvasKeyEvent(key, isKeyDown)
--   GUI.keyEvent(key, isKeyDown)
-- end

--- GUI Table
-- @field components Top-level components to be managed.
-- @field mouseState The state of each of the mouse buttons.
-- @field keyState The state of each keyboard key.
-- @field mousePosition The current position of the mouse.
-- @table GUI
GUI = {
  components = {},
  mouseState = {},
  keyState = {},
  mousePosition = {0, 0}
}

--- Add a new top-level component to be handled by PenguinGUI.
-- @param component The top-level component to be added.
function GUI.add(component)
  GUI.components[#GUI.components + 1] = component
  component:setParent(nil)
end

--- Removes a component to be handled.
--
-- @param component The component to be removed.
-- @return Whether the component was removed.
function GUI.remove(component)
  for index,comp in ripairs(GUI.components) do
    if (comp == component) then
      table.remove(GUI.components, index)
      return true
    end
  end
  return false
end

--- Sets the keyboard focus of the GUI to the specified component.
-- @param component The component to receive keyboard focus.
function GUI.setFocusedComponent(component)
  local focusedComponent = GUI.focusedComponent
  if focusedComponent then
    focusedComponent.hasFocus = false
  end
  GUI.focusedComponent = component
  component.hasFocus = true
end

--- Must be called in canvasClickEvent to handle mouse events.
--
-- @param position The position of the click.
-- @param button The mouse button of the click.
-- @param pressed Whether the event is pressed or released.
function GUI.clickEvent(position, button, pressed)
  GUI.mouseState[button] = pressed
  local components = GUI.components
  local topFound = false
  for index,component in ripairs(components) do
    if component.visible ~= false then
      -- Focus top-level components
      if not topFound then
        if component:contains(position) then
          table.remove(components, index)
          components[#components + 1] = component
          topFound = true
        end
      end
      if GUI.clickEventHelper(component, position, button, pressed) then
        -- The click was consumed
        break
      end
    end
  end
end

function GUI.clickEventHelper(component, position, button, pressed)
  local children = component.children
  for _,child in ripairs(children) do
    if child.visible ~= false then
      if GUI.clickEventHelper(child, position, button, pressed) then
        -- The click was consumed
        return true
      end
    end
  end
  -- Only check bounds if the component has a clickEvent
  if component.clickEvent then
    if component:contains(position) then
      GUI.setFocusedComponent(component)
      if component:clickEvent(position, button, pressed) then
        -- The click was consumed
        return true
      end
    end
  end
end

--- Must be called in canvasKeyEvent to handle keyboard events.
--
-- @param key The keycode of the key that spawned the event.
-- @param pressed Whether the key was pressed or released.
function GUI.keyEvent(key, pressed)
  GUI.keyState[key] = pressed
  local component = GUI.focusedComponent
  while component do
    if component.visible ~= false then
      local keyEvent = component.keyEvent
      if keyEvent then
        if keyEvent(component, key, pressed) then
          -- Key was consumed
          return
        end
      end
    end
    component = component.parent
  end
end

--- Draws and updates every component managed by this GUI.
--
-- Must be called in update() for the GUI to update and render.
-- @param dt The time elapsed since the last draw, in seconds.
function GUI.step(dt)
  GUI.mousePosition = console.canvasMousePosition()
  local hoverComponent
  for _,component in ipairs(GUI.components) do
    if component.visible ~= false then
      hoverComponent = component:step(dt) or hoverComponent
    end
  end
  if hoverComponent then
    hoverComponent.mouseOver = true
  end
end

