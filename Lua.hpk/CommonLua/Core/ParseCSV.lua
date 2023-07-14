require("lpeg")
local Q = lpeg.P("\"")
local quoted_value = Q * lpeg.Cs((1 - Q + Q * Q / "\"") ^ 0) * Q
local raw_value = lpeg.C((1 - lpeg.S(",\t\r\n\"")) ^ 0)
local field = (lpeg.P(" ") ^ 0 * quoted_value * lpeg.P(" ") ^ 0 + raw_value) * lpeg.Cp()
local cr, lf = string.byte("\r\n", 1, 2)
local space = string.byte(" ", 1)
function LoadCSV(filename, data, fields_remap, skip_rows)
  local err, str = AsyncFileToString(filename)
  if err or not str then
    return
  end
  skip_rows = type(skip_rows) == "number" and skip_rows or skip_rows and 1 or 0
  data = data or {}
  local pos, col, row = 1, 1, {}
  local value
  while true do
    value, pos = field:match(str, pos)
    local n = #value
    while 0 < n and value:byte(n) == space do
      n = n - 1
    end
    if 1 < #value - n then
      value = value:sub(1, n + 1)
    end
    if not fields_remap then
      row[col] = value
    elseif fields_remap[col] then
      row[fields_remap[col]] = value
    end
    local ch = str:byte(pos)
    if ch == lf or ch == cr or pos >= #str then
      if 0 < skip_rows then
        skip_rows = skip_rows - 1
      else
        data[#data + 1] = row
      end
      ch = (ch or 0) + (str:byte(pos + 1) or 0)
      pos = pos + (ch == cr + lf and 2 or 1)
      if pos >= #str then
        break
      end
      col = 1
      row = {}
    else
      col = col + 1
      pos = pos + 1
    end
  end
  return data
end
function SaveCSV(filename, data, fields_remap, captions, separator)
  local pstr_f = pstr("", 1048576)
  if separator then
    pstr_f:append("sep=", separator, "\n")
  else
    separator = ","
  end
  local append_row_values = function(row, fields)
    for i = 1, fields and #fields or #row do
      local value = row[not fields and i or fields[i]]
      if IsT(value) then
        value = TDevModeGetEnglishText(value, false, true)
      end
      value = not value and "" or tostring(value)
      if value:find("[,\t\r\n\"]") then
        value = "\"" .. value:gsub("\"", "\"\"") .. "\""
      end
      if 1 < i then
        pstr_f:append(separator)
      end
      pstr_f:append(value)
    end
    pstr_f:append("\n")
  end
  if captions then
    append_row_values(captions)
  end
  for _, row in ipairs(data) do
    append_row_values(row, fields_remap)
  end
  return AsyncStringToFile(filename, pstr_f)
end
function SaveIDDiffFile(filename, data, fields_incl, captions)
  local f = io.open(filename, "w+")
  for i = captions and 0 or 1, #data do
    local row = i == 0 and captions or data[i]
    local values, n = {}, fields_incl and #fields_incl
    for j = 1, n do
      local value = fields_incl and i ~= 0 and row[fields_incl[j]] or row[j]
      value = value == nil and "" or tostring(value)
      table.insert(values, value)
    end
    f:write(table.concat(values, "\t"))
    f:write("\n")
  end
  f:close()
end
