DefineClass.TupleStorage = {
  __parents = {
    "InitDone",
    "EventLogger"
  },
  storage_dir = "Storage",
  sub_dir = "",
  file_name = "file",
  file_ext = "csv",
  event_source = "TupleStorage",
  single_file = false,
  max_file_size = 1048576,
  max_buffer_size = 65536,
  periodic_buffer_flush = 7717,
  min_file_index = 1,
  max_file_index = 1,
  buffer = false,
  buffer_offset = 0,
  flush_thread = false,
  flush_queue = false,
  done = false
}
function TupleStorage:Init()
  if not self.storage_dir then
    local empty = function()
    end
    self.DeleteFiles = empty
    self.DeleteFile = empty
    self.Flush = empty
    self.WriteTuple = empty
    self.ReadTuple = empty
    self.ReadAllTuples = empty
    return
  end
  self.storage_dir = self.storage_dir .. self.sub_dir
  local err = AsyncCreatePath(self.storage_dir)
  if err then
    self:ErrorLog(err)
  end
  self.file_name = string.gsub(self.file_name, "[/?<>\\:*|\"]", "_")
  if self.single_file then
    local file_name = string.format("%s/%s.%s", self.storage_dir, self.file_name, self.file_ext)
    function self:GetFileName(index)
      return file_name
    end
    self.max_file_size = 1073741824
    self.event_source = string.format("TupleFile %s/%s", self.sub_dir, self.file_name)
    err, self.buffer_offset = AsyncGetFileAttribute(file_name, "size")
  else
    local err, files = AsyncListFiles(self.storage_dir, string.format("%s.*.%s", self.file_name, self.file_ext), "relative")
    local pattern = "%.(%d+)%." .. self.file_ext .. "$"
    if err then
      self:ErrorLog(err)
      return
    end
    local min, max = max_int, -1
    for i = 1, #files do
      local index = string.match(files[i], pattern)
      if index then
        index = tonumber(index)
        min = Min(min, index)
        max = Max(max, index)
      end
    end
    if min <= max then
      self.min_file_index = min
      self.max_file_index = max + 1
    end
    self.event_source = string.format("TupleStorage %s/%s", self.sub_dir, self.file_name)
  end
  self.buffer = pstr("", self.max_buffer_size)
  self.flush_queue = {}
  if self.periodic_buffer_flush then
    CreateRealTimeThread(function(self)
      while self.buffer do
        self:Flush()
        Sleep(self.periodic_buffer_flush)
      end
    end, self)
  end
end
function TupleStorage:Done()
  self.done = true
  function self.RawWrite()
    return "done"
  end
  function self.DeleteFile()
    return "done"
  end
  function self.DeleteFiles()
    return "done"
  end
  self:Flush()
  if self.buffer then
    self.buffer:free()
  end
  self.buffer = false
end
function TupleStorage:GetFileName(index)
  return string.format("%s/%s.%08d.%s", self.storage_dir, self.file_name, index, self.file_ext)
end
function TupleStorage:DeleteFile(file_index)
  if self.min_file_index == file_index then
    self.min_file_index = file_index + 1
  end
  if self.max_file_index == file_index then
    self.buffer_offset = 0
    self.buffer = pstr("", self.max_buffer_size)
  end
  local err = AsyncFileDelete(self:GetFileName(file_index))
  if err then
    self:ErrorLog(err, self:GetFileName(file_index))
    return err
  end
end
function TupleStorage:DeleteFiles()
  local result
  self.min_file_index = nil
  self.max_file_index = nil
  self.buffer_offset = 0
  self.buffer = pstr("", self.max_buffer_size)
  for file_index = self.min_file_index, self.max_file_index - 1 do
    local err = AsyncFileDelete(self:GetFileName(file_index))
    if err then
      result = result or err
      self:ErrorLog(err, self:GetFileName(file_index))
    end
  end
  return result
end
local _load = function(loader, err, ...)
  if err then
    return err
  end
  return loader(...)
end
function TupleStorage:LoadTuple(loader, line, file_index)
  local err = _load(loader, LuaCodeToTupleFast(line))
  if err then
    self:ErrorLog(err, self:GetFileName(file_index), line)
    return err
  end
end
function TupleStorage:ReadAllTuplesRaw(loader, file_filter, mem_limit)
  local result, stop_enum, mem
  if mem_limit then
    collectgarbage("stop")
    mem = collectgarbage("count")
  end
  local process_thread
  for file_index = self.min_file_index, self.max_file_index do
    do
      local file_name = self:GetFileName(file_index)
      if self.done then
        result = "done"
        break
      end
      if not file_filter or file_filter(self, file_name, file_index) then
        local err, data = AsyncFileToString(file_name, nil, nil, "lines")
        if not err or err ~= "Path Not Found" and err ~= "File Not Found" then
          if not err then
            if IsValidThread(process_thread) then
              WaitMsg(process_thread)
            end
            process_thread = CreateRealTimeThread(function(data)
              for i = 1, #data do
                local err = loader(data[i], file_index)
                result = result or err
              end
              data = nil
              if mem_limit and collectgarbage("count") - mem > mem_limit then
                collectgarbage("collect")
                collectgarbage("stop")
                mem = collectgarbage("count")
              end
              Msg(CurrentThread())
            end, data)
          else
            self:ErrorLog("ReadAllTuplesRaw", err, file_name)
            result = result or err
          end
        end
      end
    end
  end
  if IsValidThread(process_thread) then
    WaitMsg(process_thread)
  end
  if mem_limit then
    collectgarbage("collect")
    collectgarbage("restart")
  end
  return result
end
function TupleStorage:RawRead(file_index, file_offset, data_size)
  local queue = self.flush_queue
  for i = 1, #queue do
    local qfile_index, qbuffer, qoffset = unpack_params(queue[i])
    if file_index == qfile_index and file_offset >= qoffset and file_offset < qoffset + #qbuffer then
      local offset = file_offset - qoffset
      return qbuffer:sub(offset, offset + data_size)
    end
  end
  if self.buffer and file_index == self.max_file_index and file_offset >= self.buffer_offset then
    local offset = file_offset - self.buffer_offset
    return qbuffer:sub(offset, offset + data_size)
  end
  local err, data = AsyncFileToString(self:GetFileName(file_index), data_size, file_offset)
  if err then
    self:ErrorLog("RawRead", err, self:GetFileName(file_index), file_offset, data_size)
    return err
  end
  return nil, data
end
function TupleStorage:ReadAllTuples(loader, file_filter, mem_limit)
  local result, mem
  if mem_limit then
    collectgarbage("stop")
    mem = collectgarbage("count")
  end
  local process_thread
  for file_index = self.min_file_index, self.max_file_index do
    local file_name = self:GetFileName(file_index)
    if self.done then
      result = "done"
      break
    end
    if not file_filter or file_filter(self, file_name, file_index) then
      local err, data = AsyncFileToString(file_name, nil, nil, "pstr")
      if not err or err ~= "Path Not Found" and err ~= "File Not Found" then
        if not err then
          if IsValidThread(process_thread) then
            WaitMsg(process_thread)
          end
          process_thread = CreateRealTimeThread(function(data, file_name)
            local err_table = data:parseTuples(loader)
            data:free()
            for i, err in ipairs(err_table) do
              if err then
                self:ErrorLog("ReadAllTuples", err, file_name, i)
              end
              result = result or err
            end
            if mem_limit and collectgarbage("count") - mem > mem_limit then
              collectgarbage("collect")
              collectgarbage("stop")
              mem = collectgarbage("count")
            end
            Msg(CurrentThread())
          end, data, file_name)
        else
          self:ErrorLog("ReadAllTuples", err, file_name)
          result = result or err
        end
      end
    end
  end
  if IsValidThread(process_thread) then
    WaitMsg(process_thread)
  end
  if mem_limit then
    collectgarbage("collect")
    collectgarbage("restart")
  end
  return result
end
function TupleStorage:ReadTuple(loader, file_index, file_offset, data_size)
  local err, line = self:RawRead(file_index, file_offset, data_size)
  if err then
    return err
  end
  return self:LoadTuple(loader, line, file_index)
end
function TupleStorage:PreFlush(filename, data, offset)
end
function TupleStorage:Flush(wait)
  local buffer = self.buffer
  if not buffer or #buffer == 0 then
    return
  end
  local flush_request = {
    self.max_file_index,
    buffer,
    self.buffer_offset
  }
  self.flush_queue[#self.flush_queue + 1] = flush_request
  self.buffer_offset = self.buffer_offset + #buffer
  if self.buffer_offset > self.max_file_size then
    self.buffer_offset = 0
    self.max_file_index = self.max_file_index + 1
  end
  self.buffer = pstr("", self.max_buffer_size)
  if not IsValidThread(self.flush_thread) then
    self.flush_thread = CreateRealTimeThread(function()
      while self.flush_queue[1] do
        local data = self.flush_queue[1]
        local file_index, buffer, offset = data[1], data[2], data[3]
        local file_name = self:GetFileName(file_index)
        self:PreFlush(file_index, buffer, offset)
        local err = AsyncStringToFile(file_name, buffer, offset ~= 0 and offset)
        table.remove(self.flush_queue, 1)
        Msg(data)
        if err then
          self:ErrorLog(err, file_name, offset, #buffer)
        end
        buffer:free()
      end
      self.flush_thread = false
    end)
  end
  if wait then
    WaitMsg(flush_request)
  end
end
function TupleStorage:WriteTuple(...)
  return self:RawWrite(TupleToLuaCodePStr(...), true)
end
function TupleStorage:WriteTupleChecksum(...)
  return self:RawWrite(TupleToLuaCodeChecksumPStr(...), true)
end
function TupleStorage:RawWrite(data, free)
  local data_size = #data
  local size = #self.buffer + data_size + 1
  if self.buffer_offset + size > self.max_file_size or size > self.max_buffer_size then
    self:Flush()
  end
  local buffer = self.buffer
  local tuple_offset = self.buffer_offset + #buffer
  buffer:append(data, "\n")
  if free then
    data:free()
  end
  return nil, self.max_file_index, tuple_offset, data_size
end
function TableLoader(t)
  return function(...)
    t[#t + 1] = {
      ...
    }
  end
end
