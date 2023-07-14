function DateDiffMonthYear(older, newer)
  local yeardiff = newer[1] - older[1]
  local monthdiff = 12 * yeardiff + newer[2] - older[2]
  local diff = {yeardiff, monthdiff}
  if 0 < yeardiff then
    return diff, 1
  end
  if 0 < monthdiff then
    return diff, 2
  end
  return diff
end
DefineClass.Stats = {
  __parents = {"InitDone"},
  levels = 1,
  limits = false,
  DateDiff = function(older, newer)
  end,
  current_date = false,
  data = false,
  oldest = false,
  DateFormatCheck = function(date)
    return true
  end
}
function Stats:Init()
  self:Clear()
end
function Stats:Clear()
  self.oldest = {}
  self.data = {}
  self.current_date = {}
  for i = 1, self.levels do
    self.current_date[i] = 0
    self.oldest[i] = 0
    self.limits[i] = self.limits[i] or 0
    self.data[i] = {}
    for j = 1, self.limits[i] do
      self.data[i][j] = 0
    end
  end
end
function Stats:_CheckDate(date)
  if #date ~= self.levels then
    return false
  end
  for i = 1, self.levels do
    if not date[i] then
      return false
    end
    if date[i] < self.current_date[i] then
      return false
    end
    if date[i] > self.current_date[i] then
      break
    end
  end
  return self:DateFormatCheck(date)
end
function Stats:_ArchiveLevel(level, shift)
  if self.limits[level] == 0 then
    return
  end
  local archive = self.data[level]
  local count = #archive
  if shift >= count then
    local sum = self.oldest[level]
    for i = 1, count do
      sum = sum + archive[i]
      archive[i] = 0
    end
    self.oldest[level] = sum
    return
  end
  local sum = self.oldest[level]
  for i = 1, shift do
    sum = sum + archive[i]
  end
  self.oldest[level] = sum
  for i = 1, count - shift do
    archive[i] = archive[i + shift]
  end
  for i = count - shift + 1, count do
    archive[i] = 0
  end
end
function Stats:_UpdateArchive(date)
  local date_diff, start_level = self.DateDiff(self.current_date, date)
  if not start_level then
    return
  end
  for i = start_level, self.levels do
    self:_ArchiveLevel(i, date_diff[i])
  end
  self.current_date = date
end
function Stats:Add(date, value)
  self:_UpdateArchive(date)
  for i = 1, self.levels do
    local archive = self.data[i]
    local index = self.limits[i]
    archive[index] = archive[index] + value
  end
end
function Stats:GetArchive(level, today)
  self:_UpdateArchive(today)
  return self.data[level], self.oldest[level]
end
