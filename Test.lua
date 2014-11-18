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

  Binding.bind(targetTable, "otherkey", Binding(sourceTable, "somekey"):concat("hi"))
  printTables()
  sourceTable.somekey = "newvalue"
  targetTable.boundto = nil
  collectgarbage()
  printTables()
end

function printTables()
  print("Tables:")
  print(dump(locals))
end
main()
