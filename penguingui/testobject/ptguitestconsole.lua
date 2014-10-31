function init()
  storage = console.configParameter("scriptStorage")

  local panel = Panel()
  -- GUI.add(panel)
  
  local testbutton = Button(100, 100, 50, 20)
  testbutton.onClick = testButtonClick
  GUI.add(testbutton)

  local frame = Frame()
  frame.x = 100
  frame.y = 50
  GUI.add(frame)
  testTextButton = TextButton(80, 20, "text", 100, 16)
  frame:add(testTextButton)
  
  local testField = TextField(20, 20, 50, 16, "text")
  testField.onEnter = testFieldEnter
  frame:add(testField)

  frame.width = frame.width + 20
  frame.height = frame.height + 20

  local lastY = 10
  for i=5,20,1 do
    local testLabel = Label(10, lastY, "Hello there!", i)
    lastY = lastY + testLabel.height + 3
    GUI.add(testLabel)
  end
end

function testFieldEnter(field)
  testTextButton:setText(field.text)
end

function testButtonClick(button, mouseButton)
  world.logInfo("clicked")
end

function syncStorage()
  world.callScriptedEntity(console.sourceEntity(), "onConsoleStorageRecieve", storage)
end

function update(dt)
  GUI.draw(dt)
end

function canvasClickEvent(position, button, pressed)
  -- world.logInfo("ClickEvent detected at %s with button %s %s", position, button, pressed)
  GUI.clickEvent(position, button, pressed)
end

function canvasKeyEvent(key, isKeyDown)
  -- world.logInfo("Key %s was %s", key, isKeyDown and "pressed" or "released")
  GUI.keyEvent(key, isKeyDown)
end
