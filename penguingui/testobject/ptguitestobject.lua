function init(virtual)
  if not virtual then
    storage.consoleStorage = storage.consoleStorage or {}
    entity.setInteractive(true)
  end
end

function onConsoleStorageRecieve(consoleStorage)
  storage.consoleStorage = consoleStorage
end

function onInteraction(args)
  local consoleScripts = penguinGuiLibrary()
  consoleScripts[#consoleScripts + 1] = "/penguingui/testobject/ptguitestconsole.lua"
  
  local interactionConfig = {
    gui = {
      background = {
        zlevel = 0,
        type = "background",
        fileHeader = "/testconsole/consoleheader.png",
        fileBody = "/testconsole/consolebody.png"
      },
      scriptCanvas = {
        zlevel = 1,
        type = "canvas",
        rect = {40, 45, 434, 254},
        captureMouseEvents = true,
        captureKeyboardEvents = true
      },
      close = {
        zlevel = 2,
        type = "button",
        base = "/interface/cockpit/xup.png",
        hover = "/interface/cockpit/xdown.png",
        pressed = "/interface/cockpit/xdown.png",
        callback = "close",
        position = {419, 263},
        pressedOffset = {0, -1}
      }
    },
    
    scripts = consoleScripts,
    scriptDelta = 5,
    scriptCanvas = "scriptCanvas"
  }
  
  interactionConfig.scriptStorage = storage.consoleStorage
  
  return {"ScriptConsole", interactionConfig}
end
