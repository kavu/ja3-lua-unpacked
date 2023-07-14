TFormat = {}
TFormatPstr = {}
local type = type
local tostring = tostring
local table = table
local string = string
local concat = string.concat
local Untranslated = Untranslated
local _InternalTranslate = _InternalTranslate
function TFormatPstr.u(_pstr, context_obj, _T)
  if IsT(_T) then
    return AppendTTranslate(_pstr, _T, context_obj)
  end
  _pstr:append(tostring(_T or ""))
end
function TFormat.u(context_obj, ...)
  return Untranslated(...)
end
function TFormat.TGender(context, T)
  return GetTGender(T)
end
function TFormat.ByGender(context, T, gender)
  return GetTByGender(T, gender or context.Gender)
end
function TFormat.literal(context_obj, value, tags_on)
  local prefix, suffix = "<tags off>", "<tags on>"
  if tags_on then
    prefix, suffix = "", ""
  end
  if IsT(value) then
    value = _InternalTranslate(value, nil, false, "tags_off")
  end
  return value and prefix .. value .. suffix or "", true
end
function TFormat.pr(context_obj, value)
  if IsValid(value) then
    local x, y = value:GetPosXYZ()
    value = string.format("%s(%d, %d)", value.class, x, y)
  elseif type(value) == "table" then
    if not IsPoint(value[1]) then
      value = string.format("{...} #%d", #value)
    else
      local x, y, z = value[1]:xyz()
      if z then
        value = string.format("(%d, %d, %d), ... #%d", x, y, z, #value)
      else
        value = string.format("(%d, %d), ... #%d", x, y, #value)
      end
    end
  end
  return Untranslated(tostring(value))
end
function TFormat.FormatIndex(context_obj, ...)
  return FormatIndex(...)
end
function TFormat.FormatAsFloat(context_obj, ...)
  return FormatAsFloat(...)
end
function TFormat.FormatInt(context_obj, ...)
  return FormatInt(...)
end
function TFormat.FormatSize(context_obj, ...)
  return FormatSize(...)
end
function TFormat.FormatSignInt(context_obj, ...)
  return FormatSignInt(...)
end
function TFormat.FormatScale(context_obj, ...)
  return FormatScale(...)
end
function TFormat.percent(...)
  return FormatPercent(...)
end
function TFormat.percentWithSign(...)
  return FormatPercentWithSign(...)
end
function TFormat.kg(context_obj, ...)
  return FormatKg(...)
end
function TFormat.roman(context_obj, number)
  return number and Untranslated(RomanNumeral(number)) or ""
end
function TFormat.abs(context_obj, number)
  local n = tonumber(number)
  return n and abs(n) or number
end
function TFormat.def(context_obj, value, default)
  return value ~= "" and value or default
end
function TFormat.count(context_obj, value)
  return type(value) == "table" and #value or 0
end
function TFormat.display_name(context_obj, presets_table, value, field)
  if type(value) ~= "string" then
    return ""
  end
  presets_table = Presets[presets_table] and Presets[presets_table].Default or rawget(_G, presets_table)
  local preset = presets_table[value]
  return preset and preset[field or "display_name"]
end
function TFormat.diff(context_obj, amount, zero_text)
  if type(amount) ~= "number" then
    return ""
  end
  if amount <= 0 then
    if amount == 0 and zero_text then
      return zero_text
    end
    return Untranslated(amount)
  else
    return Untranslated("+" .. amount)
  end
end
function TFormat.opt(context_obj, value, prefix, postfix)
  if value and value ~= "" then
    return T({
      337322950263,
      "<prefix><value><postfix>",
      prefix = prefix or "",
      value = value or "",
      postfix = postfix or ""
    })
  end
  return ""
end
function TFormat.opt_amount(context_obj, amount, prefix)
  if not amount or amount == 0 then
    return ""
  end
  if type(amount) == "number" and amount < 0 then
    return Untranslated((prefix or "") .. amount)
  else
    return Untranslated((prefix or "") .. "+" .. amount)
  end
end
function TFormat.opt_percent(context_obj, percent)
  if not percent or percent == 0 then
    return ""
  end
  local pattern = type(percent) == "number" and percent < 0 and "%s%%" or "+%s%%"
  return Untranslated(string.format(pattern, tostring(percent)))
end
function TFormat.sum(context_obj, sum, prop, obj)
  sum = tonumber(sum) or 0
  for _, item in ipairs(obj or context_obj or empty_table) do
    sum = sum + (GetProperty(item, prop) or 0)
  end
  return sum
end
function TFormat.get(context_obj, t, ...)
  return table.get(t, ...)
end
function TFormat.FormatResolution(context_obj, pt)
  return T({
    716420484706,
    "<arg1> x <arg2>",
    arg1 = pt:x(),
    arg2 = pt:y()
  })
end
function TFormat.RestartMapText(context_obj)
  return T(1136, "Restart Map")
end
function TFormat.cut_if_platform(context_obj, platform)
  if Platform[platform] then
    return false
  end
  return ""
end
function TFormat.cut_if_not_platform(context_obj, platform)
  if not Platform[platform] then
    return false
  end
  return ""
end
local is_true = function(cond)
  return cond and cond ~= ""
end
TFormat["not"] = function(context_obj, value)
  return not is_true(value)
end
function TFormat.eq(context_obj, value1, value2)
  return value1 == value2
end
function TFormat.not_eq(context_obj, value1, value2)
  return value1 ~= value2
end
function TFormat.less(context_obj, value1, value2)
  return value1 < value2
end
function TFormat.has_dlc(context_obj, dlc)
  return IsDlcAvailable(dlc)
end
function TFormat.platform(context_obj, platform)
  return Platform[platform] and true
end
function TFormat.select(context_obj, index, ...)
  if type(index) ~= "number" then
    index = is_true(index) and 2 or 1
  end
  return select(index, ...) or ""
end
const.TagLookupTable["/if"] = "</hide>"
TFormat["if"] = function(context_obj, cond)
  return is_true(cond) and "" or "<hide>"
end
function TFormat.if_all(context_obj, ...)
  for i = 1, select("#", ...) do
    local cond = select(i, ...)
    if not is_true(cond) then
      return "<hide>"
    end
  end
  return ""
end
function TFormat.if_any(context_obj, ...)
  for i = 1, select("#", ...) do
    local cond = select(i, ...)
    if is_true(cond) then
      return ""
    end
  end
  return "<hide>"
end
TFormat["or"] = function(context_obj, ...)
  local cond
  for i = 1, select("#", ...) do
    cond = select(i, ...)
    if is_true(cond) then
      return cond
    end
  end
  return cond
end
TFormat["and"] = function(context_obj, ...)
  local cond
  for i = 1, select("#", ...) do
    cond = select(i, ...)
    if not is_true(cond) then
      return cond
    end
  end
  return cond
end
function TFormat.os_date(context_obj, time, format)
  return os.date(format or "!%Y-%m-%d", time)
end
function TFormat.context(context_obj)
  return context_obj
end
function TFormat.map(context_obj, t, ...)
  if type(t) ~= "table" then
    return
  end
  return table.map(...)
end
function TFormat.keys(context_obj, t, ...)
  if type(t) ~= "table" then
    return
  end
  return table.keys(...)
end
function TFormat.list(context_obj, list, separator)
  if not list or not next(list) then
    return ""
  end
  return TList(list, separator)
end
function TFormat.set(context_obj, set, separator)
  if not set or not next(set) then
    return ""
  end
  return TList(table.keys(set, true), separator)
end
function FormatNone(value)
  return value
end
function FormatPercent(context_obj, value, max, min)
  if (max or 0) ~= 0 then
    value = MulDivRound(value, 100, max)
  end
  value = Max(value, min)
  return T({
    960784545354,
    "<number>%",
    number = value
  })
end
function FormatPercentWithSign(context_obj, value, max)
  if (max or 0) ~= 0 then
    value = MulDivRound(value, 100, max)
  end
  if 0 < value then
    return T({
      788023197741,
      "+<number>%",
      number = value
    })
  elseif value < 0 then
    return T({
      360627168972,
      "-<number>%",
      number = -value
    })
  else
    return T({
      960784545354,
      "<number>%",
      number = value
    })
  end
end
function FormatKg(value)
  if value <= 499 then
    return T({
      638292000495,
      "<weight>g",
      weight = value
    })
  elseif value < 1000 then
    local res = value / 100
    return T({
      695159900103,
      "0.<res>kg",
      res = res
    })
  else
    local weight = DivRound(value, const.Scale.kg)
    return T({
      781395902674,
      "<weight>kg",
      weight = weight
    })
  end
end
function FormatInt(value, precision, size)
  if type(value) ~= "number" then
    value = 0
  end
  if value < 1000 then
    if size then
      return T({
        634583763636,
        "<value>B",
        value = value
      })
    end
    return Untranslated(value)
  end
  if value < 1000000 then
    local dev = 1000
    if not precision or precision == 0 then
      if size then
        return T({
          916707577582,
          "<value>kB",
          value = value / dev
        })
      end
      return T({
        542057749659,
        "<value>k",
        value = value / dev
      })
    elseif precision == 1 then
      if size then
        return T({
          306874811840,
          "<value>.<rem>kB",
          value = value / dev,
          rem = value % dev / (dev / 10)
        })
      end
      return T({
        973255618325,
        "<value>.<rem>k",
        value = value / dev,
        rem = value % dev / (dev / 10)
      })
    else
      if precision == 2 then
        local rem = value % dev / (dev / 100)
        if size then
          return T({
            306874811840,
            "<value>.<rem>kB",
            value = value / dev,
            rem = 0 < rem and rem or Untranslated("00")
          })
        end
        return T({
          686447021725,
          "<value>.<rem>K",
          value = value / dev,
          rem = 0 < rem and rem or Untranslated("00")
        })
      else
      end
    end
  elseif value < 1000000000 then
    local dev = 1000000
    if not precision or precision == 0 then
      if size then
        return T({
          777603998749,
          "<value>MB",
          value = value / dev
        })
      end
      return T({
        295351893708,
        "<value>M",
        value = value / dev
      })
    elseif precision == 1 then
      if size then
        return T({
          358890854224,
          "<value>.<rem>MB",
          value = value / dev,
          rem = value % dev / (dev / 10)
        })
      end
      return T({
        372033962501,
        "<value>.<rem>M",
        value = value / dev,
        rem = value % dev / (dev / 10)
      })
    else
      if precision == 2 then
        local rem = value % dev / (dev / 100)
        if size then
          return T({
            358890854224,
            "<value>.<rem>MB",
            value = value / dev,
            rem = 0 < rem and rem or Untranslated("00")
          })
        end
        return T({
          372033962501,
          "<value>.<rem>M",
          value = value / dev,
          rem = 0 < rem and rem or Untranslated("00")
        })
      else
      end
    end
  else
    local dev = 1000000000
    if not precision or precision == 0 then
      if size then
        return T({
          976112224433,
          "<value>GB",
          value = value / dev
        })
      end
      return T({
        113449998910,
        "<value>G",
        value = value / dev
      })
    elseif precision == 1 then
      if size then
        return T({
          927901310991,
          "<value>.<rem>GB",
          value = value / dev,
          rem = value % dev / (dev / 10)
        })
      end
      return T({
        469760839385,
        "<value>.<rem>G",
        value = value / dev,
        rem = value % dev / (dev / 10)
      })
    else
      if precision == 2 then
        local rem = value % dev / (dev / 100)
        if size then
          return T({
            927901310991,
            "<value>.<rem>GB",
            value = value / dev,
            rem = 0 < rem and rem or Untranslated("00")
          })
        end
        return T({
          469760839385,
          "<value>.<rem>G",
          value = value / dev,
          rem = 0 < rem and rem or Untranslated("00")
        })
      else
      end
    end
  end
end
function FormatSize(value, precision)
  return FormatInt(value, precision, true)
end
function FormatSignInt(value, precision)
  if type(value) ~= "number" then
    value = 0
  end
  local txt = FormatInt(abs(value), precision)
  if txt and 0 < value then
    txt = Untranslated("+") .. txt
  end
  return txt
end
function FormatScale(value, scale, precision)
  if type(value) ~= "number" then
    value = 0
  end
  local scale_num = tonumber(scale)
  return FormatAsFloat(value, scale_num or const.Scale[scale] or 1, precision or 3, true, scale_num and "" or scale)
end
function FormatIndex(index, context_obj)
  return T({
    288776973737,
    "#<index>",
    index = index,
    context_obj
  })
end
function TruncateToPrecision(value, scale, precision)
  for i = 1, precision or 0 do
    if 10 <= scale then
      scale = scale / 10
    end
  end
  return (0 < value and value / scale or -(abs(value) / scale)) * scale
end
function FormatAsFloat(v, scale, precision, skip_nonsignificant, extra)
  local sep = _InternalTranslate(T(175637758479, "."))
  local sign = ""
  if v < 0 then
    if 0 > TruncateToPrecision(v, scale, precision) then
      sign = "-"
    end
    v = -v
  end
  scale = scale or 1
  precision = precision or 0
  if skip_nonsignificant then
    if precision == 3 and MulDivTrunc(v, 1000, scale) % 10 == 0 then
      precision = 2
    end
    if precision == 2 and MulDivTrunc(v, 100, scale) % 10 == 0 then
      precision = 1
    end
    if precision == 1 and MulDivTrunc(v, 10, scale) % 10 == 0 then
      precision = 0
    end
  end
  if precision == 0 then
    return Untranslated(concat("", sign, v / scale, extra or ""))
  elseif precision == 1 then
    return Untranslated(concat("", sign, v / scale, sep, MulDivTrunc(v, 10, scale) % 10, extra or ""))
  elseif precision == 2 then
    return Untranslated(concat("", sign, v / scale, sep, MulDivTrunc(v, 10, scale) % 10, MulDivTrunc(v, 100, scale) % 10, extra or ""))
  else
    return Untranslated(concat("", sign, v / scale, sep, MulDivTrunc(v, 10, scale) % 10, MulDivTrunc(v, 100, scale) % 10, MulDivTrunc(v, 1000, scale) % 10, extra or ""))
  end
end
function RomanNumeral(number)
  if number < 1 then
    return ""
  end
  if 1000 <= number then
    return "M" .. RomanNumeral(number - 1000)
  end
  if 900 <= number then
    return "CM" .. RomanNumeral(number - 900)
  end
  if 500 <= number then
    return "D" .. RomanNumeral(number - 500)
  end
  if 400 <= number then
    return "CD" .. RomanNumeral(number - 400)
  end
  if 100 <= number then
    return "C" .. RomanNumeral(number - 100)
  end
  if 90 <= number then
    return "XC" .. RomanNumeral(number - 90)
  end
  if 50 <= number then
    return "L" .. RomanNumeral(number - 50)
  end
  if 40 <= number then
    return "XL" .. RomanNumeral(number - 40)
  end
  if 10 <= number then
    return "X" .. RomanNumeral(number - 10)
  end
  if 9 <= number then
    return "IX" .. RomanNumeral(number - 9)
  end
  if 5 <= number then
    return "V" .. RomanNumeral(number - 5)
  end
  if 4 <= number then
    return "IV" .. RomanNumeral(number - 4)
  end
  if 1 <= number then
    return "I" .. RomanNumeral(number - 1)
  end
end
function TFormat.const(context_obj, ...)
  return table.get(const, ...)
end
