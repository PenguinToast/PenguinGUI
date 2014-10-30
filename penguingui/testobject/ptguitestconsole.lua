function init()
  storage = console.configParameter("scriptStorage")
  local testbutton = Button(100, 100, 50, 20)
  testbutton.onClick = testButtonClick
  GUI.add(testbutton)

  local lastY = 10
  for i=5,20,1 do
    local testLabel = Label(10, lastY, "Hello there!", i)
    lastY = lastY + testLabel.height + 3
    GUI.add(testLabel)
  end

  for i=1,10,1 do
    local testTextButton = TextButton(170, i * 18, genString(i))
    GUI.add(testTextButton)
  end
end

function genString(len)
  local out = ""
  for i=1,len,1 do
    out = out .. i
  end
  return out
end

function testButtonClick(button, mouseButton)
  world.logInfo("clicked")
end

function syncStorage()
  world.callScriptedEntity(console.sourceEntity(), "onConsoleStorageRecieve", storage)
end

function update(dt)
  GUI.draw()
end

function canvasClickEvent(position, button, pressed)
  -- world.logInfo("ClickEvent detected at %s with button %s %s", position, button, pressed)
  GUI.clickEvent(position, button, pressed)
end

function canvasKeyEvent(key, isKeyDown)
  -- world.logInfo("Key %s was %s", key, isKeyDown and "pressed" or "released")
  GUI.keyEvent(key, isKeyDown)
end
