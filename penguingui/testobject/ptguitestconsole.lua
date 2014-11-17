function init()
  storage = console.configParameter("scriptStorage")
  
  local testbutton = TextButton(10, 10, 100, 16, "Make window")
  testbutton.onClick = testButtonClick
  GUI.add(testbutton)

  for i=1,5,1 do
    local testCheck = RadioButton(10, 30 + 15 * i, 10)
    GUI.add(testCheck)
  end
  local checkPanel = Panel(30, 30)
  GUI.add(checkPanel)
  for i=1,5,1 do
    local testCheck = RadioButton(0, 15 * i, 10)
    checkPanel:add(testCheck)
  end
end

function testButtonClick(button, mouseButton)
  local padding = 20
  
  local frame = Frame(100, 50)
  GUI.add(frame)

  local testTextButton
  local testField = TextField(padding, padding, 50, 16, "text")
  frame:add(testField)
  
  testTextButton = TextButton(testField.width + 10 + padding,
                                    padding, 100, 16, "text")
  testTextButton.onClick = function(button)
    GUI.remove(frame)
  end
  frame:add(testTextButton)

  Binding.bind(testTextButton, "text", Binding(testField, "text"))
  Binding.bind(testField, "defaultText", Binding(frame, "x"):le(Binding(frame, "y")):tostring())
  -- testField:bind("text", testTextButton, {"text"})

  frame:pack(padding)
end

function syncStorage()
  world.callScriptedEntity(console.sourceEntity(), "onConsoleStorageRecieve", storage)
end

function update(dt)
  GUI.step(dt)
end

function canvasClickEvent(position, button, pressed)
  -- world.logInfo("ClickEvent detected at %s with button %s %s", position, button, pressed)
  GUI.clickEvent(position, button, pressed)
end

function canvasKeyEvent(key, isKeyDown)
  -- world.logInfo("Key %s was %s", key, isKeyDown and "pressed" or "released")
  GUI.keyEvent(key, isKeyDown)
end
