require "penguingui/Util"
require "penguingui/Binding"
require "penguingui/BindingFunctions"

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
  Binding.bind(targetTable, "otherkey", b)
  printTables()
  sourceTable.somekey = "newvalue"
  b:unbind()
  -- a = nil
  -- b = nil
  sourceTable.somekey = "newervalue"
  collectgarbage()
  printTables()
end

function printTables()
  print("Tables:")
  print(dump(locals))
end
main()
