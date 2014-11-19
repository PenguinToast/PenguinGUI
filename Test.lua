require "penguingui/Util"
require "penguingui/Binding"
require "penguingui/BindingFunctions"
inspect = require "lib/inspect"

function main()
  local a = Binding.proxy({
      a_1 = 0
  })
  local b = Binding.proxy({
      b_1 = ""
  })

  local binding = Binding(a, "a_1")
  b:bind("b_1", binding:lt(10):THEN(binding, binding:mul(binding)):tostring())
  binding = nil
  
  locals = {a = a, b = b}
  printTables()

  for i=0,20,1 do
    a.a_1 = i
    print("a_1: " .. a.a_1 .. ", b_1: " .. b.b_1)
  end
  b:unbind("b_1")
  collectgarbage()
  printTables()
end

function printTables()
  print("Tables:")
  print(inspect(locals))
end
main()
