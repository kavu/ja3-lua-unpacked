local LuaKeywords = {
  ["and"] = true,
  ["break"] = true,
  ["do"] = true,
  ["else"] = true,
  ["elseif"] = true,
  ["end"] = true,
  ["false"] = true,
  ["for"] = true,
  ["function"] = true,
  ["goto"] = true,
  ["if"] = true,
  ["in"] = true,
  ["local"] = true,
  ["nil"] = true,
  ["not"] = true,
  ["or"] = true,
  ["repeat"] = true,
  ["return"] = true,
  ["then"] = true,
  ["true"] = true,
  ["until"] = true,
  ["while"] = true
}
function FormatKey(k, pstr)
  local type = type(k)
  if type == "number" then
    if not pstr then
      return string.format("[%d] = ", k)
    else
      return pstr:appendf("[%d] = ", k)
    end
  elseif type == "boolean" then
    local fkey = k and "[true] = " or "[false] = "
    if not pstr then
      return fkey
    else
      return pstr:append(fkey)
    end
  elseif string.match(k, "^[_%a][_%w]+$") and not LuaKeywords[k] then
    if not pstr then
      return k .. " = "
    else
      return pstr:append(k, " = ")
    end
  elseif not pstr then
    return string.format("[%s] = ", StringToLuaCode(k))
  else
    pstr:append("[")
    pstr:appends(k)
    return pstr:append("] = ")
  end
end
function prop_eval(value, obj, prop_meta, def)
  while type(value) == "function" do
    local ok
    ok, value = procall(value, obj, prop_meta)
    if not ok then
      return def
    end
  end
  return value
end
local eval = prop_eval
function ValueToLuaCode(value, indent, pstr, injected_props)
  if pstr then
    return pstr:appendv(value, indent, injected_props)
  end
  local vtype = type(value)
  if vtype == "nil" then
    return "nil"
  end
  if vtype == "boolean" then
    return value and "true" or "false"
  end
  if vtype == "number" then
    return tostring(value)
  end
  if vtype == "string" then
    return StringToLuaCode(value)
  end
  if vtype == "function" then
    return GetFuncSourceString(value, "")
  end
  if vtype == "userdata" or vtype == "table" then
    local meta = getmetatable(value)
    local __toluacode = meta and meta.__toluacode
    if __toluacode then
      return __toluacode(value, indent, injected_props)
    end
    if vtype == "table" then
      return TableToLuaCode(value, indent, nil, injected_props)
    end
    if IsPStr(value) then
      return StringToLuaCode(value)
    end
    if Request_IsTask(value) then
      return value:GetResource()
    end
    return "nil"
  end
end
local ObjectHandlesHelperNoPstr = function(value, ret)
  for i = 1, #value do
    if not (type(value[i]) ~= "boolean" and IsValid(value[i])) or value[i]:GetGameFlags(const.gofPermanent) == 0 then
      ret[#ret + 1] = "false,"
    elseif not value[i].handle then
    else
      ret[#ret + 1] = string.format("o(%d),", value[i].handle)
    end
  end
end
local ObjectHandlesHelperPstr = function(value, pstr)
  for i = 1, #value do
    if not (type(value[i]) ~= "boolean" and IsValid(value[i])) or value[i]:GetGameFlags(const.gofPermanent) == 0 then
      pstr:append("false,")
    elseif not value[i].handle then
    else
      pstr:appendf("o(%d),", value[i].handle)
    end
  end
end
local ProcessIndentPlusOneHelper = function(indent)
  local ret = ""
  if type(indent) == "string" then
    ret = string.format("%s%s", indent, "    ")
  else
    for i = 1, indent + 1 do
      ret = string.format("%s%s", ret, "    ")
    end
  end
  return ret
end
function PropToLuaCode(value, vtype, indent, pstr, prop_meta, obj, injected_props)
  if vtype == "bool" or vtype == "boolean" then
    return ValueToLuaCode(not not value, indent, pstr)
  end
  if (vtype == "string" or vtype == "text") and type(value) ~= "string" and type(value) ~= "number" and type(value) ~= "boolean" then
    return TToLuaCode(value, ContextCache[value], pstr)
  end
  if vtype == "rgbrm" then
    local r, g, b, ro, m = GetRGBRM(value)
    local a = GetAlpha(value)
    if ro == 0 and m == 0 then
      local fmt = "RGBA(%d, %d, %d, %d)"
      if not pstr then
        return string.format(fmt, r, g, b, a)
      else
        return pstr:appendf(fmt, r, g, b, a)
      end
    end
    local fmt = "RGBRM(%d, %d, %d, %d, %d)"
    if not pstr then
      return string.format(fmt, r, g, b, ro, m)
    else
      return pstr:appendf(fmt, r, g, b, ro, m)
    end
  end
  if vtype == "packedcurve" then
    local pt1, pt2, pt3, pt4, max_y = UnpackCurveParams(value)
    local fmt = "PackCurveParams(%d, %d, %d, %d, %d, %d, %d, %d, %d)"
    if not pstr then
      return string.format(fmt, pt1:x(), pt1:y(), pt2:x(), pt2:y(), pt3:x(), pt3:y(), pt4:x(), pt4:y(), max_y)
    else
      return pstr:appendf(fmt, pt1:x(), pt1:y(), pt2:x(), pt2:y(), pt3:x(), pt3:y(), pt4:x(), pt4:y(), max_y)
    end
  end
  if vtype == "color" then
    local r, g, b, a = GetRGBA(value)
    local fmt = "RGBA(%d, %d, %d, %d)"
    if not pstr then
      return string.format(fmt, r, g, b, a)
    else
      return pstr:appendf(fmt, r, g, b, a)
    end
  end
  if vtype == "set" then
    value = IsSet(value) and value or setmetatable(value, __set_meta)
    return ValueToLuaCode(value, indent, pstr)
  end
  if vtype == "combo" or vtype == "dropdownlist" or vtype == "radiobuttons" then
    local combo_types = {
      ["nil"] = true,
      number = true,
      boolean = true,
      string = true,
      object = true,
      table = true
    }
    local value_type = type(value)
    if value_type == "table" and IsValid(value) then
      value_type = "object"
    end
    if combo_types[value_type] then
      return PropToLuaCode(value, value_type, indent, pstr, prop_meta, obj)
    end
    return
  end
  if vtype == "object" then
    if not value.handle then
      return
    end
    if not pstr then
      return string.format("o(%d)", value.handle)
    else
      return pstr:appendf("o(%d)", value.handle)
    end
  end
  if vtype == "objects" then
    if not pstr then
      local ret = {"{"}
      if #value == 0 and next(value) then
        local indentStr = ProcessIndentPlusOneHelper(indent)
        for k, v in sorted_pairs(value) do
          if not v then
            ret[#ret + 1] = string.format([[

%s%s = false,]], indentStr, k)
          elseif IsKindOf(v, "Object") then
            ret[#ret + 1] = string.format([[

%s%s = o(%d),]], indentStr, k, v.handle)
          else
            ret[#ret + 1] = string.format([[

%s%s = {]], indentStr, k)
            ObjectHandlesHelperNoPstr(v, ret)
            ret[#ret + 1] = "},"
          end
        end
      else
        ObjectHandlesHelperNoPstr(value, ret)
      end
      ret[#ret + 1] = "}"
      return table.concat(ret)
    else
      pstr:append("{")
      if #value == 0 and next(value) then
        local indentStr = ProcessIndentPlusOneHelper(indent)
        for k, v in sorted_pairs(value) do
          if not v then
            pstr:append(string.format([[

%s%s = false,]], indentStr, k))
          elseif IsKindOf(v, "Object") then
            pstr:append(string.format([[

%s%s = o(%d),]], indentStr, k, v.handle))
          else
            pstr:append(string.format([[

%s%s = {]], indentStr, k))
            ObjectHandlesHelperPstr(v, pstr)
            pstr:append("},")
          end
        end
      else
        ObjectHandlesHelperPstr(value, pstr)
      end
      return pstr:append("}")
    end
  end
  if vtype == "range" then
    value = IsRange(value) and value or setmetatable(value, __range_meta)
    return ValueToLuaCode(value, indent, pstr)
  end
  if vtype == "browse" then
    if not pstr then
      return string.format("%q", value)
    else
      return pstr:appendf("%q", value)
    end
  end
  if vtype == "func" or vtype == "expression" then
    local src = GetFuncSourceStringIndent(indent, value, "", eval(prop_meta.params, obj, prop_meta) or "self")
    if not pstr then
      return src
    else
      Msg("OnFunctionSerialized", pstr, value)
      return pstr:append(src)
    end
  end
  return ValueToLuaCode(value, indent, pstr, injected_props)
end
function TupleToLuaCode(...)
  local values = pack_params(...)
  if not values then
    return ""
  end
  for i = 1, values.n or #values do
    values[i] = ValueToLuaCode(values[i], " ") or "nil"
  end
  return table.concat(values, ",")
end
local _load = function(ok, ...)
  if ok then
    return nil, ...
  else
    return ...
  end
end
local procall_helper2 = function(ok, ...)
  if not ok then
    return (...) or "error"
  end
  return nil, ...
end
local default_env
function FileToLuaValue(filename, env)
  default_env = default_env or LuaValueEnv({})
  local err, data
  err, data = AsyncFileToString(filename)
  if err then
    return err
  end
  local func, err
  if not string.starts_with(data, "return") then
    data = "return " .. data
  end
  func, err = load(data, nil, nil, env or default_env)
  if not func then
    return err
  end
  return procall_helper2(procall(func))
end
function LuaCodeToTuple(code, env)
  local err, code = ChecksumRemove(code)
  if err then
    return err
  end
  local func, err = load("return " .. (code or ""), nil, nil, env or _ENV)
  if func then
    return _load(pcall(func))
  end
  return err
end
function TableToLuaCode(tbl, indent, pstr, injected_props)
  if pstr then
    return pstr:appendt(tbl, indent, false, injected_props)
  end
  if type(indent) == "number" then
    indent = string.rep("\t", indent)
  end
  if next(tbl) == nil or indent and 100 < #indent then
    return "{}"
  end
  indent = indent or ""
  local new_indent = indent == " " and indent or indent .. "\t"
  local lines = {}
  local keys = {}
  for key in pairs(tbl) do
    if type(key) ~= "number" or key < 1 or key > #tbl then
      keys[#keys + 1] = key
    end
  end
  table.sort(keys, lessthan)
  for i, key in ipairs(keys) do
    if key ~= "__index" then
      local value = ValueToLuaCode(tbl[key], new_indent, nil, injected_props)
      if value then
        lines[#lines + 1] = FormatKey(key) .. value
      end
    end
  end
  local only_numbers = #lines == 0
  for i = 1, #tbl do
    local value = tbl[i]
    only_numbers = only_numbers and type(value) == "number"
    lines[#lines + 1] = ValueToLuaCode(value, new_indent, nil, injected_props) or "nil"
  end
  if indent == " " or #lines == 0 or only_numbers then
    return string.format("{%s}", table.concat(lines, ","))
  end
  local code = table.concat(lines, [[
,
	]] .. indent)
  return string.format([[
{
	%s%s,
%s}]], indent, code, indent)
end
function ObjPropertyListToLuaCode(obj, indent, GetPropFunc, pstr, additional, injected_props)
  indent = indent or ""
  local new_indent
  if not pstr then
    new_indent = indent == " " and indent or indent ~= "" and indent .. "\t" or "\t"
  else
    indent = type(indent) == "number" and indent or 0
    new_indent = 0 <= indent and indent + 1 or indent
  end
  local code
  local props = obj:GetProperties()
  local prop_count = #props
  for i = 1, prop_count + #(injected_props or empty_table) do
    local prop = i > prop_count and injected_props[i - prop_count] or props[i]
    local id = prop.id
    if injected_props and i <= prop_count and eval(prop.inject_in_subobjects, obj, prop) then
      injected_props[#injected_props + 1] = prop
    end
    local editor = eval(prop.editor, obj, prop)
    if not eval(prop.dont_save, obj, prop) and editor then
      local value
      if GetPropFunc then
        value = GetPropFunc(obj, id, prop)
      else
        value = obj:GetProperty(id)
      end
      if not obj:IsDefaultPropertyValue(id, prop, value) then
        if not pstr then
          value = PropToLuaCode(value, editor, new_indent, nil, prop, obj, injected_props)
          if value then
            code = code or {"{"}
            code[#code + 1] = string.format("\t'%s', %s,", id, value)
          else
          end
        else
          if not code then
            code = true
            if indent < 0 then
              pstr:append("{ ")
            else
              pstr:append("{\n")
              pstr:appendr("\t", indent)
            end
          end
          local len = #pstr
          pstr:appendf("\t'%s', ", id)
          if PropToLuaCode(value, editor, new_indent, pstr, prop, obj, injected_props) then
            if indent < 0 then
              pstr:append(", ")
            else
              pstr:append(",\n")
              pstr:appendr("\t", indent)
            end
          else
            pstr:resize(len)
          end
        end
      end
    end
  end
  if code then
    if not pstr then
      if additional then
        code[#code + 1] = additional
      end
      code[#code + 1] = "}"
      return table.concat(code, indent == " " and " " or "\n" .. indent)
    else
      if additional then
        pstr:append(additional)
      end
      return pstr:append("}")
    end
  end
end
function ArrayToLuaCode(array, indent, pstr, injected_props)
  if not array or #array == 0 then
    return
  end
  indent = indent or ""
  local new_indent
  if not pstr then
    new_indent = indent ~= "" and indent .. "\t" or "\t"
    local code = {}
    for i = 1, #array do
      local value = rawget(array, i)
      value = ValueToLuaCode(value, new_indent, nil, injected_props)
      code[#code + 1] = value
    end
    code[#code + 1] = "}"
    code[1] = "{\n" .. new_indent .. code[1]
    return table.concat(code, [[
,
	]] .. indent)
  else
    indent = type(indent) == "number" and indent or 0
    new_indent = 0 <= indent and indent + 1 or indent
    pstr:append("{\n")
    pstr:appendr("\t", new_indent)
    for i = 1, #array do
      local value = rawget(array, i)
      pstr:appendv(value, new_indent, injected_props)
      pstr:append([[
,
	]])
      pstr:appendr("\t", indent)
    end
    return pstr:append("}")
  end
end
function CopyValue(value)
  local vtype = type(value)
  if vtype == "number" or vtype == "string" or vtype == "boolean" or vtype == "nil" then
    return nil, value
  end
  local success, code = procall(ValueToLuaCode, value)
  if not success then
    return code
  end
  local success, err, copy = procall(LuaCodeToTuple, code)
  if not success then
    return err
  end
  if err then
    return err
  end
  return nil, copy
end
if FirstLoad then
  FuncSource = setmetatable({}, weak_keys_meta)
  LuaSource = {}
end
function FetchLuaSource(file_name)
  local source = LuaSource[file_name]
  if source then
    return source
  end
  local err, content = AsyncFileToString(file_name, nil, nil, "lines")
  if err then
    return
  end
  LuaSource[file_name] = content
  return content
end
function CacheLuaSourceFile(file_name, source)
  LuaSource[file_name] = string.split(tostring(source), "\n")
end
local srcLastFilename, srcLastFileContent
function InvalidateGetFuncSourceCache()
  srcLastFilename = false
  srcLastFileContent = false
  LuaSource = {}
end
function GetFuncSource(f, no_cache)
  if not f or type(f) ~= "function" then
    return
  end
  if not no_cache then
    local name, params, body = unpack_params(FuncSource[f or false])
    if body then
      return name, params, body
    end
  end
  local info = debug.getinfo(f, "S")
  local first, last = info.linedefined, info.lastlinedefined
  local source = info.source
  if not (info and source and first) or not last then
    return
  end
  if source:sub(1, 1) == "@" then
    source = source:match("@?(.*)")
    if no_cache or srcLastFilename ~= source then
      local content = FetchLuaSource(source, nil, nil, "lines")
      if not content then
        return
      end
      srcLastFilename = source
      srcLastFileContent = content
    end
  else
    srcLastFilename = nil
    srcLastFileContent = string.split(info.source, "\n")
  end
  local first_line = srcLastFileContent[first] or ""
  local name, params, body_start = first_line:match("%f[%w]function%f[%W]%s*([%w:._]*)%s*%(([%w%s,._]-)%)%s*()")
  if not body_start then
    return
  end
  if first == last then
    local body = first_line:match("^(.*)%f[%w]end%f[^%w_]", body_start)
    body = body and body:match("(.-)%s*$")
    FuncSource[f] = {
      name,
      params,
      body
    }
    return name, params, body, first, last, srcLastFileContent
  else
    local b = first_line:sub(body_start, -1)
    if b == "" then
      b = nil
    end
    local body = {b}
    local tabs
    for i = first + 1, last do
      local current_line = srcLastFileContent[i]
      if i == last then
        current_line = (current_line or ""):match("(.-)%s*%f[%w]end%f[^%w_]")
        if not current_line then
          return
        end
        if current_line == "" then
          break
        end
      end
      tabs = tabs or string.match(current_line, "^[\n\r ]*(\t*)")
      if tabs then
        local current_tabs = string.match(current_line, "^(\t*)") or ""
        current_line = current_line:sub(Min(#tabs, #current_tabs) + 1)
      end
      body[#body + 1] = current_line
    end
    FuncSource[f] = {
      name,
      params,
      body
    }
    return name, params, body, first, last, srcLastFileContent
  end
end
if FirstLoad then
  function missing_source_func()
  end
end
function GetMissingSourceFallback()
  return missing_source_func
end
function GetFuncSourceString(f, new_name, new_params)
  if f ~= missing_source_func then
    local name, params, body = GetFuncSource(f)
    if not body then
      print("WARNING: Unable to retrieve a function's source code while saving!\n", rawget(_G, "FindFunctionByAddress") and TableToLuaCode(FindFunctionByAddress(f)) or "(unknown)")
    else
      name = new_name or name
      params = new_params or params
      if type(body) == "string" then
        return string.format("function %s(%s) %s end", name, params, body)
      else
        return string.format([[
function %s(%s)
%s
end]], name, params, table.concat(body, "\n"))
      end
    end
  end
  return "GetMissingSourceFallback()"
end
function CompileFunc(name, params, body, chunkname)
  local src = string.format([[
return function (%s) %s
end]], params or "", body)
  local f, err = load(src, chunkname or string.format("%s(%s)", name or "func", params or ""))
  f = f and f() or function()
    printf("bad function %s(%s): %s", name, params, err)
  end
  body = string.split(body, "\n")
  FuncSource[f] = {
    name,
    params or "",
    body,
    err
  }
  return f, err
end
function CompileExpression(name, params, body, chunkname)
  body = body:match("^%s*(.-)%s*$")
  if not body:find("return ", 1, true) then
    body = "return " .. body
  end
  local src = string.format([[
local function %s(%s) %s end
return %s]], name, params or "", body, name)
  local f, err = load(src, chunkname or "expression " .. (params or ""))
  f = f and f() or function()
    printf("bad expression %s(%s): %s", name, params, err)
  end
  FuncSource[f] = {
    name,
    params or "",
    body
  }
  return f, err
end
function GetFuncSourceStringIndent(indent, ...)
  local src = GetFuncSourceString(...)
  if src:find("%send%W") and src:ends_with(" end") then
    local first, last = src:find("function%s*%b() ")
    if first == 1 then
      src = src:sub(1, last - 1) .. "\n" .. src:sub(last + 1)
    end
    src = src:sub(1, -5) .. [[

end]]
  end
  local internal_indent
  if type(indent) == "number" then
    if indent <= 0 then
      return src
    end
    internal_indent = string.rep("\t", indent + 1)
    indent = string.rep("\t", indent)
  elseif indent == " " then
    return src
  else
    internal_indent = indent .. "\t"
  end
  local lines = string.split(src, "\n")
  for i = 2, #lines - 1 do
    lines[i] = internal_indent .. lines[i]
  end
  if 2 < #lines then
    lines[#lines] = indent .. lines[#lines]
  end
  return table.concat(lines, "\n")
end
function GetFuncBody(func, indent, default)
  local name, params, body = GetFuncSource(func)
  if type(body) == "table" then
    indent = indent or ""
    return indent .. table.concat(body, "\n" .. indent)
  elseif type(body) == "string" then
    return (indent or "") .. body
  end
  return default or ""
end
function GetExpressionBody(func)
  local body = GetFuncBody(func)
  return 8 <= #body and body:sub(8) or "nil"
end
