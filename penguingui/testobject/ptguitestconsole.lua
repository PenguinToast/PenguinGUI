function init()
  storage = console.configParameter("scriptStorage")
  
  local testbutton = TextButton(10, 10, 100, 16, "Make window")
  testbutton.onClick = testButtonClick
  GUI.add(testbutton)

  -- Slider test
  local slider = Slider(30, 100, 150, 10)
  GUI.add(slider)
  local sliderLabel = Label(40 + slider.width, slider.y, "0", 12)
  sliderLabel:bind("text", Binding(slider, "percentage"):tostring())
  GUI.add(sliderLabel)
  
  -- List test
  local list = List(30, 30, 100, 100, 12)
  local selected = Binding.proxy({item = nil})
  GUI.add(list)
  for i=1,20,1 do
    local item = list:emplaceItem("Item " .. i)
    if i == 1 then
      selected.item = item
    end
    local listener = 
      function(t, k, old, new)
        if new then
          selected.item = t
        end
      end
    item:addListener("selected", listener)
  end

  local removeButton = TextButton(150, 60, 100, 12, "Remove")
  removeButton:bind("text", Binding.concat("Remove ",
                                           Binding(selected, {"item", "text"})))
  removeButton.onClick = function()
    list:removeItem(selected.item)
    local item = list:getItem(1)
    if item then
      item:select()
    end
  end
  GUI.add(removeButton)
end

function testButtonClick(button, mouseButton)
  local padding = 20
  
  local frame = Frame(100, 50)
  GUI.add(frame)

  local closeButton = TextButton(100 + 10 + padding,
                                    padding, 100, 16, "close")
  closeButton.onClick = function(button)
    GUI.remove(frame)
  end
  frame:add(closeButton)

  local xLabel = Label(padding, padding, "")
  xLabel:bind("text", Binding.concat("x: ", Binding(frame, "x"):tostring()))
  frame:add(xLabel)
  
  local yLabel = Label(padding, padding + xLabel.height + 10, "")
  yLabel:bind("text", Binding.concat("y: ", Binding(frame, "y"):tostring()))
  frame:add(yLabel)

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
