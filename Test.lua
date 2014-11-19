require "penguingui/Util"
require "penguingui/Binding"
require "penguingui/BindingFunctions"
inspect = require "lib/inspect"

function main()
  local a = Binding.proxy({
    a_1 = Binding.proxy({
      sourceValue = "a_1"
    }),
    a_2 = Binding.proxy({
      sourceValue = "a_2"
    })
  })
  local b = Binding.proxy({
    targetValue = "unknown"
  })

  local binding = Binding(a, {"a_1", "sourceValue"})
  b:bind("targetValue", binding)
  
  locals = {a = a, b = b}
  printTables()

  local tmp = a.a_1
  a.a_1 = a.a_2
  a.a_2 = tmp
  tmp = nil
  binding = nil
  collectgarbage()
  printTables()
end

function printTables()
  print("Tables:")
  print(inspect(locals))
end
main()
