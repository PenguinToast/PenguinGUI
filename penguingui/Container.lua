-- Superclass for most GUI components

Container = class()

function Container:_init()
  self.children = {}
end

