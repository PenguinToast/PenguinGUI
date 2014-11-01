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
  local interactionConfig = entity.configParameter("interactionConfig")
  
  local consoleScripts = PtUtil.library()
  --consoleScripts[#consoleScripts + 1] = "/penguingui/testobject/ptguitestconsole.lua"

    for _,script in ipairs(interactionConfig.scripts) do
    table.insert(consoleScripts, script)
  end
  interactionConfig.scripts = consoleScripts

  interactionConfig.scriptStorage = storage.consoleStorage
  
  return {"ScriptConsole", interactionConfig}
end
