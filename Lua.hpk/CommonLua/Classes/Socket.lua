if not rawget(_G, "sockProcess") then
  return
end
DefineClass.BaseSocket = {
  __parents = {
    "InitDone",
    "EventLogger"
  },
  [true] = false,
  owner = false,
  socket_type = "BaseSocket",
  stats_group = 0,
  host = false,
  port = false,
  msg_size_max = 1048576,
  timeout = 3600000,
  Send = sockSend,
  Listen = sockListen,
  Disconnect = sockDisconnect,
  IsConnected = sockIsConnected,
  SetOption = sockSetOption,
  GetOption = sockGetOption,
  SetAESEncryptionKey = sockEncryptionKey,
  GenRSAEncryptedKey = sockGenRSAEncryptedKey,
  SetRSAEncryptedKey = sockSetRSAEncryptedKey
}
function BaseSocket:Init()
  local socket = self[true] or sockNew()
  self[true] = socket
  SocketObjs[socket] = self
  self:SetOption("timeout", self.timeout)
  self:SetOption("maxbuffer", self.msg_size_max)
  sockSetGroup(self, self.stats_group)
end
function BaseSocket:Done()
  local owner = self.owner
  if owner then
    owner:OnConnectionDone(self)
  end
  local socket = self[true]
  if SocketObjs[socket] == self then
    if self:IsConnected() then
      self:OnDisconnect("delete")
    end
    sockDelete(socket)
    SocketObjs[socket] = nil
    self[true] = false
  end
end
function BaseSocket:UpdateEventSource()
  if self.host and self.port then
    self.event_source = string.format("%s:%d(%s)", self.host, self.port, sockStr(self))
  else
    self.event_source = string.format("-(%s)", sockStr(self))
  end
end
function BaseSocket:Connect(timeout, host, port)
  self.host = host
  self.port = port
  self:UpdateEventSource()
  return sockConnect(self, timeout, host, port)
end
function BaseSocket:WaitConnect(timeout, host, port)
  local err = self:Connect(timeout, host, port)
  if err then
    return err
  end
  return select(2, WaitMsg(self))
end
function BaseSocket:OnAccept(socket, host, port)
  local owner = self.owner
  local sock = g_Classes[self.socket_type]:new({
    [true] = socket,
    owner = owner
  })
  sock:OnConnect(nil, host, port)
  if owner then
    owner:OnConnectionInit(sock)
  end
  return sock
end
function BaseSocket:OnConnect(err, host, port)
  Msg(self, err)
  self.host = not err and host or nil
  self.port = not err and port or nil
  self:UpdateEventSource()
  return self
end
function BaseSocket:OnDisconnect(reason)
end
function BaseSocket:OnReceive(...)
end
DefineClass.MessageSocket = {
  __parents = {"BaseSocket"},
  socket_type = "MessageSocket",
  call_waiting_threads = false,
  call_timeout = 30000,
  msg_size_max = 16384,
  serialize_strings = {
    "rfnCall",
    "rfnResult",
    "rfnStrings"
  },
  serialize_strings_pack = false,
  [1] = false,
  [2] = false
}
local weak_values = {__mode = "v"}
function MessageSocket:Init()
  self.call_waiting_threads = {}
  setmetatable(self.call_waiting_threads, weak_values)
  self:SetOption("message", true)
end
function MessageSocket:OnDisconnect(reason)
  local call_waiting_threads = self.call_waiting_threads
  if next(call_waiting_threads) then
    for id, thread in pairs(call_waiting_threads) do
      Wakeup(thread, "disconnected")
      call_waiting_threads[id] = nil
    end
  end
  self.serialize_strings = nil
  self[1] = nil
  self[2] = nil
end
function MessageSocket:Serialize(...)
  return SerializeStr(self[2], ...)
end
function MessageSocket:Unserialize(...)
  return UnserializeStr(self[1], ...)
end
if Platform.developer then
  function MessageSocket:Send(...)
    local original_data = {
      ...
    }
    local unserialized_data = {
      UnserializeStr(self[1], SerializeStr(self[2], ...))
    }
    if not compare(original_data, unserialized_data, nil, true) then
      rawset(_G, "__a", original_data)
      rawset(_G, "__b", unserialized_data)
      rawset(_G, "__diff", {})
      GetDeepDiff(original_data, unserialized_data, __diff)
    end
    return sockSend(self, ...)
  end
end
function MessageSocket:rfnStrings(serialize_strings_pack)
  local loader = load("return " .. Decompress(serialize_strings_pack))
  local idx_to_string = loader and loader()
  if type(idx_to_string) ~= "table" then
    self:Disconnect()
    return
  end
  self.serialize_strings = idx_to_string
  self[1] = idx_to_string
  self[2] = table.invert(idx_to_string)
end
if FirstLoad then
  rcallID = 0
end
local passResults = function(ok, ...)
  if ok then
    return ...
  end
  return "timeout"
end
local hasRfnPrefix = hasRfnPrefix
local launchRealTimeThread = LaunchRealTimeThread
function MessageSocket:Call(func, ...)
  local id = rcallID
  rcallID = id + 1
  local err = self.Send(self, "rfnCall", id, func, ...)
  if err then
    return err
  end
  if not CanYield() then
    self:ErrorLog("Call cannot sleep", func, TupleToLuaCode(...), GetStack(2))
    return "not in thread"
  end
  self.call_waiting_threads[id] = CurrentThread()
  return passResults(WaitWakeup(self.call_timeout))
end
local __f = function(id, func, self, ...)
  local err = self.Send(self, "rfnResult", id, func(self, ...))
  if err and err ~= "disconnected" and err ~= "no socket" then
    self:ErrorLog("Result send failed", err)
  end
  return err
end
function MessageSocket:rfnCall(id, name, ...)
  if hasRfnPrefix(name) then
    local func = self[name]
    if func then
      return launchRealTimeThread(__f, id, func, self, ...)
    end
  end
  self:ErrorLog("Call name", name)
  self:Disconnect()
end
function MessageSocket:rfnResult(id, ...)
  local thread = self.call_waiting_threads[id]
  self.call_waiting_threads[id] = nil
  Wakeup(thread, ...)
end
function OnMsg.ClassesPreprocess(classdefs)
  for name, classdef in pairs(classdefs) do
    local serialize_strings = rawget(classdef, "serialize_strings")
    if serialize_strings then
      classdef.serialize_strings_pack = Compress(TableToLuaCode(serialize_strings))
      classdef[1] = serialize_strings
      classdef[2] = table.invert(serialize_strings)
    end
  end
end
