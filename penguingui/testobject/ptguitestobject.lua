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

  local development = true
  if development then
    local consoleScripts = PtUtil.library()
    for _,script in ipairs(interactionConfig.scripts) do
      table.insert(consoleScripts, script)
    end
    interactionConfig.scripts = consoleScripts
  else
    table.insert(interactionConfig.scripts, 1, "/penguingui.lua")
  end

  interactionConfig.scriptStorage = storage.consoleStorage
  
  return {"ScriptConsole", interactionConfig}
end
