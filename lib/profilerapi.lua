-- Credit to XspeedPL for writing this (I think)
profilerApi = {
  hookedTables = {}
}

-- Initializes the Profiler and hooks all functions
function profilerApi.init()
  if profilerApi.isInit then return end
  profilerApi.hooks = {}
  profilerApi.start = profilerApi.getTime()
  profilerApi.hookAll("", _ENV)
  profilerApi.isInit = true
end

-- Prints all collected data into the log ordered by total time descending
function profilerApi.logData()
  local time = profilerApi.getTime() - profilerApi.start
  local arr = {}
  local len = 8
  local cnt = 5
  for k,v in pairs(profilerApi.hooks) do
    if type(v) == "table" then
      if v.t > 0 then
        table.insert(arr, k)
        local l = string.len(k)
        if l > len then len = l end
        l = profilerApi.get10pow(profilerApi.hooks[k].c)
        if l > cnt then cnt = l end
      end
    end
  end
  table.sort(arr, profilerApi.sortHelp)
  world.logInfo("Profiler log for console (total profiling time: " .. string.format("%.2f", time) .. ")")
  world.logInfo(string.format("%" .. len .. "s |        total time | %" .. cnt .. "s |      average time |         last time", "function", "count"))
  for i,k in ipairs(arr) do
    local hook = profilerApi.hooks[k]
    world.logInfo(string.format("%" .. len .. "s | %.15f | %" .. cnt .. "i | %.15f | %.15f", k, hook.t, hook.c, hook.a, hook.e))
  end
end

function profilerApi.get10pow(n)
  local ret = 1
  while n >= 10 do
    ret = ret + 1
    n = n / 10
  end
  return ret
end

function profilerApi.sortHelp(e1, e2)
  return profilerApi.hooks[e1].t > profilerApi.hooks[e2].t
end

function profilerApi.canHook(fn)
  local un = { "pairs", "ipairs", "ripairs", "type", "next", "assert", "error",
               "print", "setmetatable", "select", "rawset", "rawlen", "pcall",
               "unpack" }
  for i,v in ipairs(un) do
    if v == fn then return false end
  end
  return true
end

function profilerApi.hookAll(tn, to)
  if (tn == "profilerApi.") or (tn == "table.") or (tn == "coroutine.") or (tn == "os.") then return end
  local hookedTables = profilerApi.hookedTables
  for k,v in pairs(hookedTables) do
    if to == v then
      return
    end
  end
  table.insert(profilerApi.hookedTables, to)

  for k,v in pairs(to) do
    if type(v) == "function" then
      if (tn ~= "") or profilerApi.canHook(k) then
        profilerApi.hook(to, tn, v, k)
      end
    elseif type(v) == "table" then
      profilerApi.hookAll(tn .. k .. ".", v)
    end
  end
end

function profilerApi.getTime()
  return os.clock()
end

function profilerApi.hook(to, tn, fo, fn)
  local full = tn .. fn
  profilerApi.hooks[full] = { s = -1, f = fo, e = -1, t = 0, a = 0, c = 0 }
  to[fn] = function(...) return profilerApi.hooked(full, ...) end
end

function profilerApi.hooked(fn, ...)
  local hook = profilerApi.hooks[fn]
  hook.s = profilerApi.getTime()
  local ret = {hook.f(...)}
  hook.e = profilerApi.getTime() - hook.s
  hook.t = hook.t + hook.e
  hook.c = hook.c + 1
  hook.a = hook.t / hook.c
  return unpack(ret)
end
