require "penguingui/Util"
require "penguingui/Binding"
require "penguingui/BindingFunctions"
inspect = require "lib/inspect"

function main()
  locals = {}

  local sourceTable = Binding.proxy({
      somekey = "somevalue"
  })
  locals.sourceTable = sourceTable

  local targetTable = Binding.proxy({
      otherkey = "othervalue"
  })
  locals.targetTable = targetTable

  local a = Binding(sourceTable, "somekey")
  local b = a:concat("hi")
  targetTable:bind("otherkey", b)
  --Binding.bind(targetTable, "otherkey", b)
  printTables()
  sourceTable.somekey = "newvalue"
  Binding.unbind(targetTable, "otherkey")
  a = nil
  b = nil
  sourceTable.somekey = "newervalue"
  collectgarbage()
  printTables()
end

function printTables()
  print("Tables:")
  print(inspect(locals))
end
main()
