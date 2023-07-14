local DebugCommand = (Platform.developer or Platform.asserts) and not Platform.console
local Trace_SetCommand = DebugCommand and "log"
local CommandImportance = const.CommandImportance or empty_table
local WeakImportanceThreshold = CommandImportance.WeakImportanceThreshold
DefineClass.CommandObject = {
  __parents = {"InitDone"},
  command = false,
  command_queue = false,
  dont_clear_queue = false,
  command_destructors = false,
  command_thread = false,
  thread_running_destructors = false,
  command_call_stack = false,
  forced_cmd_importance = false,
  trace_setcmd = Trace_SetCommand,
  last_error_time = false,
  uninterruptable_importance = false,
  CreateThread = CreateGameTimeThread,
  IsValid = IsValid
}
DefineClass.RealTimeCommandObject = {
  __parents = {
    "CommandObject"
  },
  CreateThread = CreateRealTimeThread,
  IsValid = function()
    return true
  end,
  NetUpdateHash = function()
  end
}
function RealTimeCommandObject:Done()
  self.IsValid = empty_func
end
function CommandObject:Done()
  if self.command and CurrentThread() ~= self.command_thread then
    self:SetCommand(false)
  end
  self.command_queue = nil
end
function CommandObject:Idle()
  self[false](self)
end
function CommandObject:CmdInterrupt()
end
CommandObject[false] = function(self)
  self.command = nil
  self.command_thread = nil
  self.command_destructors = nil
  self.thread_running_destructors = nil
  Halt()
end
AutoResolveMethods.OnCommandStart = true
CommandObject.OnCommandStart = empty_func
local SetCommandErrorChecks = empty_func
local SleepOnInfiniteLoop = empty_func
local GetNextDestructor = function(obj, destructors)
  local count = destructors[1]
  if count == 0 then
    return empty_func
  end
  local dstor = destructors[count + 1]
  destructors[count + 1] = false
  destructors[1] = count - 1
  if type(dstor) == "string" then
    dstor = obj[dstor] or empty_func
  elseif type(dstor) == "table" then
    return obj[dstor[1]] or empty_func, obj, table.unpack(dstor, 2)
  end
  return dstor, obj
end
local CommandThreadProc = function(self, command, ...)
  local destructors = self.command_destructors
  local thread_running_destructors = self.thread_running_destructors
  if thread_running_destructors then
    while IsValidThread(self.thread_running_destructors) and not WaitMsg(destructors, 100) do
    end
  end
  local thread = CurrentThread()
  if self.command_thread ~= thread then
    return
  end
  local command_func = type(command) == "function" and command or self[command]
  local packed_command
  while true do
    if destructors and destructors[1] > 0 then
      self.thread_running_destructors = thread
      while destructors[1] > 0 do
        sprocall(GetNextDestructor(self, destructors))
      end
      self.thread_running_destructors = false
      if self.command_thread ~= thread then
        Msg(destructors)
        return
      end
    end
    if not self:IsValid() then
      return
    end
    self:NetUpdateHash("Command", type(command) == "function" and "function" or command, ...)
    self:OnCommandStart()
    local success, err
    if packed_command == nil then
      success, err = sprocall(command_func, self, ...)
    else
      success, err = sprocall(command_func, self, unpack_params(packed_command, 3))
    end
    if not success and not IsBeingDestructed(self) then
      if self.last_error_time == now() then
        Sleep(1000)
      end
      self.last_error_time = now()
    end
    local forced_cmd_importance
    local queue = self.command_queue
    packed_command = queue and table.remove(queue, 1)
    if packed_command then
      if type(packed_command) == "table" then
        forced_cmd_importance = packed_command[1] or nil
        command = packed_command[2]
      else
        command = packed_command
      end
      command_func = type(command) == "function" and command or self[command]
    else
      command = "Idle"
      command_func = self.Idle
    end
    self.forced_cmd_importance = forced_cmd_importance
    self.command = command
    destructors = self.command_destructors
  end
  self.command_thread = nil
end
function CommandObject:SetCommand(command, ...)
  return self:DoSetCommand(nil, command, ...)
end
function CommandObject:DoSetCommand(importance, command, ...)
  self:NetUpdateHash("SetCommand", type(command) == "function" and "function" or command, ...)
  self.command = command or nil
  if not self.dont_clear_queue then
    self.command_queue = nil
  end
  self.dont_clear_queue = nil
  local old_thread = self.command_thread
  local new_thread = self.CreateThread(CommandThreadProc, self, command, ...)
  self.command_thread = new_thread
  self.forced_cmd_importance = importance or nil
  ThreadsSetThreadSource(new_thread, "Command", command)
  if old_thread == self.thread_running_destructors then
    local uninterruptable_importance = self.uninterruptable_importance
    if not uninterruptable_importance then
      return true
    end
    local test_importance = importance or CommandImportance[command or false] or 0
    if uninterruptable_importance >= test_importance then
      return true
    end
    self.uninterruptable_importance = false
    self.thread_running_destructors = false
  end
  DeleteThread(old_thread, true)
  if old_thread == CurrentThread() then
    DeleteThread(new_thread)
    self.command_thread = old_thread
    return false
  end
  return true
end
function CommandObject:TestInfiniteLoop()
  self:SetCommand("TestInfiniteLoop2")
end
function CommandObject:TestInfiniteLoop2()
  self:SetCommand("TestInfiniteLoop")
end
function CommandObject:GetCommandText()
  return tostring(self.command)
end
local IsCommandThread = function(self, thread)
  thread = thread or CurrentThread()
  return thread and (thread == self.command_thread or thread == self.thread_running_destructors)
end
CommandObject.IsCommandThread = IsCommandThread
function CommandObject:PushDestructor(dtor)
  local destructors = self.command_destructors
  if destructors then
    destructors[1] = destructors[1] + 1
    destructors[destructors[1] + 1] = dtor
    return destructors[1]
  else
    self.command_destructors = {1, dtor}
    return 1
  end
end
function CommandObject:PopAndCallDestructor(check_count)
  local destructors = self.command_destructors
  local old_thread_running_destructors = self.thread_running_destructors
  if not IsValidThread(old_thread_running_destructors) then
    self.thread_running_destructors = CurrentThread()
    old_thread_running_destructors = false
  end
  sprocall(GetNextDestructor(self, destructors))
  if not old_thread_running_destructors then
    self.thread_running_destructors = false
    if self.command_thread ~= CurrentThread() then
      Msg(destructors)
      Halt()
    end
  end
end
function CommandObject:PopDestructor(check_count)
  local destructors = self.command_destructors
  destructors[destructors[1] + 1] = false
  destructors[1] = destructors[1] - 1
end
function CommandObject:GetDestructorsCount()
  local destructors = self.command_destructors
  return destructors and destructors[1] or 0
end
function CommandObject:ExecuteUninterruptableImportance(importance, func, ...)
  local thread = CurrentThread()
  local func_to_execute = type(func) == "function" and func or self[func]
  if self.command_thread ~= thread or self.thread_running_destructors then
    sprocall(func_to_execute, self, ...)
    return
  end
  local destructors = self.command_destructors
  if not destructors then
    destructors = {0}
    self.command_destructors = destructors
  end
  self.uninterruptable_importance = importance
  self.thread_running_destructors = thread
  sprocall(func_to_execute, self, ...)
  self.uninterruptable_importance = false
  self.thread_running_destructors = false
  if self.command_thread == thread then
    return
  end
  Msg(destructors)
  Halt()
end
function CommandObject:ExecuteUninterruptable(func, ...)
  return self:ExecuteUninterruptableImportance(nil, func, ...)
end
function CommandObject:ExecuteWeakUninterruptable(func, ...)
  return self:ExecuteUninterruptableImportance(WeakImportanceThreshold, func, ...)
end
function CommandObject:IsIdleCommand()
  return (self.command or "Idle") == "Idle"
end
local InsertCommand = function(self, index, forced_importance, command, ...)
  if self:IsIdleCommand() then
    return self:SetCommand(command, ...)
  end
  local packed_command = not forced_importance and count_params(...) == 0 and command or pack_params(forced_importance or false, command or false, ...)
  local queue = self.command_queue
  if not queue then
    self.command_queue = {packed_command}
  elseif index then
    table.insert(queue, index, packed_command)
  else
    queue[#queue + 1] = packed_command
  end
end
function CommandObject:QueueCommand(command, ...)
  return InsertCommand(self, false, false, command, ...)
end
function CommandObject:QueueCommandImportance(forced_importance, command, ...)
  return InsertCommand(self, false, forced_importance, command, ...)
end
function CommandObject:InsertCommand(index, forced_importance, command, ...)
  return InsertCommand(self, index, forced_importance, command, ...)
end
function CommandObject:SetCommandKeepQueue(command, ...)
  self.dont_clear_queue = true
  self:SetCommand(command, ...)
end
function CommandObject:HasCommandsInQueue()
  return #(self.command_queue or "") > 0
end
function CommandObject:ClearCommandQueue()
  self.command_queue = nil
end
function CommandObject:GetCommandImportance(command)
  if not command then
    return self.forced_cmd_importance or CommandImportance[self.command]
  else
    return CommandImportance[command or false]
  end
end
function CommandObject:CanSetCommand(command, importance)
  local current_importance = self.forced_cmd_importance or CommandImportance[self.command] or 0
  importance = importance or CommandImportance[command or false] or 0
  return current_importance <= importance
end
function CommandObject:TrySetCommand(cmd, ...)
  if not self:CanSetCommand(cmd) then
    return
  end
  return self:SetCommand(cmd, ...)
end
function CommandObject:SetCommandImportance(importance, cmd, ...)
  return self:DoSetCommand(importance or nil, cmd, ...)
end
function CommandObject:TrySetCommandImportance(importance, cmd, ...)
  if not self:CanSetCommand(cmd, importance) then
    return
  end
  return self:SetCommandImportance(importance, cmd, ...)
end
function CommandObject:ExecuteInCommand(method_name, ...)
  if CanYield() and IsCommandThread(self) then
    self[method_name](self, ...)
    return true
  end
  return self:TrySetCommand(method_name, ...)
end
if DebugCommand then
  CommandObject.command_change_prev = false
  CommandObject.command_change_count = 0
  CommandObject.command_change_gtime = 0
  CommandObject.command_change_rtime = 0
  CommandObject.command_change_loops = 0
  local infinite_command_changes = 10
  function SleepOnInfiniteLoop(self)
    local rtime, gtime = RealTime(), GameTime()
    if self.command_change_rtime ~= rtime or self.command_change_gtime ~= gtime then
      self.command_change_rtime = rtime
      self.command_change_gtime = gtime
      self.command_change_count = nil
      return
    end
    local command_change_count = self.command_change_count
    if command_change_count <= infinite_command_changes then
      self.command_change_count = command_change_count + 1
      return
    end
    self.command_change_loops = self.command_change_loops + 1
    Sleep(50 * self.command_change_loops)
    self.command_change_count = nil
  end
  function SetCommandErrorChecks(self, command, ...)
    local destructors = self.command_destructors
    local prev_command = self.command
    if command == "->Idle" and destructors and destructors[1] > 0 then
      print("Command", self.class .. "." .. tostring(prev_command), "remaining destructors:")
      for i = 1, destructors[1] do
        local destructor = destructors[i + 1]
        if type(destructor) == "string" then
          printf("\t%d. %s.%s", i, self.class, destructor)
        elseif type(destructor) == "table" then
          printf("\t%d. %s.%s", i, self.class, destructor[1])
        else
          local info = debug.getinfo(destructor, "S") or empty_table
          local source = info.source or "Unknown"
          local line = info.linedefined or -1
          printf("\t%d. %s(%d)", i, source, line)
        end
      end
      error(string.format("Command %s.%s did not pop its destructors.", self.class, tostring(self.command)), 2)
      while destructors[1] > 0 do
        self:PopDestructor()
      end
    end
    if command and command ~= "->Idle" then
      if type(command) ~= "function" and not self:HasMember(command) then
        error(string.format("Invalid command %s:%s", self.class, tostring(command)), 3)
      end
      if IsBeingDestructed(self) then
        error(string.format("%s:SetCommand('%s') called from Done() or delete()", self.class, tostring(command)), 3)
      end
    end
    if command ~= "->Idle" or prev_command ~= "Idle" then
      self.command_call_stack = GetStack(3)
      if self.trace_setcmd then
        if self.trace_setcmd == "log" then
          self:Trace("SetCommand {1}", tostring(command), self.command_call_stack, ...)
        else
          error(string.format("%s:SetCommand(%s) time %d, old command %s", self.class, concat_params(", ", tostring(command), ...), GameTime(), tostring(self.command)), 3)
        end
      end
    end
    if self.command_change_count == infinite_command_changes then
    end
    self.command_change_prev = prev_command
  end
  local function __DbgForEachMethod(passed, obj, callback, ...)
    if not obj then
      return
    end
    for name, value in pairs(obj) do
      if type(value) == "function" and not passed[name] then
        passed[name] = true
        callback(name, value, ...)
      end
    end
    return __DbgForEachMethod(passed, getmetatable(obj), callback, ...)
  end
  function DbgForEachMethod(obj, callback, ...)
    return __DbgForEachMethod({}, obj, callback, ...)
  end
  function DbgBreakRemove(obj)
    DbgForEachMethod(obj, function(name, value, obj)
      obj[name] = nil
    end, obj)
  end
  function DbgBreakSchedule(obj, methods)
    DbgBreakRemove(obj)
    if methods == "string" then
      methods = {methods}
    end
    DbgForEachMethod(obj, function(name, value, obj)
      if not methods or table.find(methods, name) then
        local new_value = function(...)
          if IsCommandThread(obj) then
            DbgBreakRemove(obj)
            print("Break removed")
            bp(true, 1)
          end
          return value(...)
        end
        obj[name] = new_value
      end
    end, obj)
    print("Break schedule")
  end
  function CommandObject:AsyncCheatDebugger()
    DbgBreakSchedule(self)
  end
end
