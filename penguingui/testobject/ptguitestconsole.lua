function init()
  storage = console.configParameter("scriptStorage")
  local tests = {
    "textTest",
    "windowTest",
    "listTest",
    "labelTest"
  }
  local y = 190
  local pad = 10
  local x = 10
  for _,test in ipairs(tests) do
    local button = TextRadioButton(x, y, 70, 12, test)
    x = x + button.width + pad
    GUI.add(button)
    local panel = Panel(0, 0)
    GUI.add(panel)
    panel:bind("visible", Binding(button, "selected"))
    _ENV[test](panel)
  end
end

function labelTest(panel)
  local x = 10
  local y = 10
  local text = "ABCDEabcdegjp^|"
  for i=5,25,1 do
    local label = Label(x, y, text, i)
    local rect = Rectangle(x, y, label.width, label.height, "red")
    panel:add(rect)
    panel:add(label)
    y = y + label.height + 1
  end
end

function textTest(panel)
  local y = 10
  local x = 10
  local button = TextButton(x, y, 70, 12, "text")
  local field = TextField(x, y + button.height + 10, 150, 12, "Set text")
  field.onEnter = function()
    button.text = field.text
  end
  panel:add(button)
  panel:add(field)
end

function windowTest(panel)
  local testbutton = TextButton(10, 10, 100, 16, "Make window")
  testbutton.onClick = testButtonClick
  panel:add(testbutton)

  local slider = Slider(10, 40, 100, 10, 50, 100, 1)
  local label = Label(120, 40, "", 10)
  label:bind("text", Binding.concat(
               "Sample Slider: ", Binding(slider, "value")))
  panel:add(slider)
  panel:add(label)
end

function listTest(panel)
  -- List test
  local list = List(30, 30, 100, 100, 12)
  local selected = Binding.proxy({item = nil})
  panel:add(list)
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

  local filter = TextField(list.x, list.y + list.height + 5, list.width, 15, "Filter")
  panel:add(filter)
  filter:addListener(
    "text",
    function(t, k, old, new)
      list:filter(
        function(item)
          if item.text:find(new) then
            return true
          end
        end
      )
    end
  )

  local removeButton = TextButton(150, 60, 100, 12, "Remove")
  removeButton:bind("text", Binding.concat("Remove ",
                                           Binding(selected, {"item", "text"})))
  removeButton.onClick = function()
    list:removeItem(selected.item)
  end
  panel:add(removeButton)
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
