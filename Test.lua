require "penguingui/Util"
require "penguingui/Binding"
require "penguingui/BindingFunctions"
inspect = require "lib/inspect"

function main()
  local a = Binding.proxy({
      a_1 = "a_1",
      a_2 = "a_2"
  })
  local b = Binding.proxy({
      b_1 = "b_1",
      b_2 = "b_2"
  })

  local binding = Binding(a, "a_1")
  b:bind("b_1", binding)
  b:bind("b_2", binding)
  
  locals = {a = a, b = b}
  printTables()

  a.a_1 = "a_1new"
  binding:unbind()
  a.a_1 = "a_1newer"
  binding = nil
  collectgarbage()
  printTables()
end

function printTables()
  print("Tables:")
  print(inspect(locals))
end
main()
