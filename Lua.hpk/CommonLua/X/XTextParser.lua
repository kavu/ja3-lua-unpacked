local FindNextLineBreakCandidate = utf8.FindNextLineBreakCandidate
local GetLineBreakInfo = utf8.GetLineBreakInfo
local SetFont = function(font, scale)
  local text_style = TextStyles[font]
  if not text_style then
    return 0, 0, 0
  end
  local font_id, height, baseline = text_style:GetFontIdHeightBaseline(scale:y())
  if not font_id or font_id < 0 then
    return 0, 0, 0
  end
  return font_id, height, baseline
end
DefineClass.XTextBlock = {
  __parents = {
    "PropertyObject"
  },
  exec = false,
  total_width = false,
  total_height = false,
  min_start_width = false,
  new_line_forbidden = false,
  end_line_forbidden = false,
  is_content = false
}
function tag_processors.newline(state, args)
  state:MakeFuncBlock(function(layout)
    layout.left_margin = (tonumber(args[1]) or 0) * state.scale:x() / 1000
    layout:NewLine(false)
  end)
end
function tag_processors.vspace(state, args)
  local vspace = tonumber(args[1])
  if not vspace then
    state:PrintErr("Vspace should be a number")
    return
  end
  state:MakeFuncBlock(function(layout)
    layout:SetVSpace(vspace)
    layout:NewLine(false)
  end)
end
function tag_processors.zwnbsp(state, args)
  state:MakeBlock({
    total_width = 0,
    total_height = 0,
    min_start_width = 0,
    new_line_forbidden = true,
    end_line_forbidden = true,
    text = ""
  })
end
function tag_processors.linespace(state, args)
  local linespace = tonumber(args[1])
  if not linespace then
    state:PrintErr("Linespace should be a number")
    return
  end
  state:MakeFuncBlock(function(layout)
    layout.font_linespace = linespace
  end)
end
function tag_processors.valign(state, args)
  local alignment = args[1]
  state.valign = args[1]
  state.y_offset = MulDivTrunc(args[2] or 0, state.scale:x(), 1000)
end
function tag_processors.hide(state, args, tok_idx_start)
  local tokens = state.tokens
  local hide_counter = 1
  local tok_idx = tok_idx_start + 1
  while tok_idx < #tokens do
    local token = tokens[tok_idx]
    tok_idx = tok_idx + 1
    if token.type == "hide" then
      hide_counter = hide_counter + 1
    elseif token.type == "/hide" then
      hide_counter = hide_counter - 1
      if hide_counter == 0 then
        break
      end
    end
  end
  return tok_idx - tok_idx_start
end
tag_processors["/hide"] = function(state, args)
end
function tag_processors.background(state, args)
  if args[1] == "none" then
    state:PushStackFrame("background").background = RGBA(0, 0, 0, 0)
    return
  end
  if #args == 1 then
    local color = tonumber(args[1])
    if not color then
      local style = TextStyles[GetTextStyleInMode(args[1], GetDarkModeSetting()) or args[1]]
      if not style then
        state:PrintErr("TextStyle could not be found (" .. args[1] .. ")")
        color = RGB(255, 255, 255)
      else
        color = style.TextColor
      end
    end
    state:PushStackFrame("background").background_color = color
  else
    local num1 = tonumber(args[1]) or 255
    local num2 = tonumber(args[2]) or 255
    local num3 = tonumber(args[3]) or 255
    local num4 = tonumber(args[4]) or 255
    state:PushStackFrame("background").background_color = RGBA(num1, num2, num3, num4)
  end
end
tag_processors["/background"] = function(state, args)
  state:PopStackFrame("background")
end
function tag_processors.hyperlink(state, args)
  if args[1] == "underline" then
    args[1], state.hl_underline = "", true
  elseif args[6] == "underline" then
    args[6], state.hl_underline = "", true
  elseif args[5] == "underline" then
    args[5], state.hl_underline = "", true
  elseif args[4] == "underline" then
    args[4], state.hl_underline = "", true
  elseif args[3] == "underline" then
    args[3], state.hl_underline = "", true
  end
  if args[5] and args[5] ~= "" then
    state.hl_argument = args[2]
    state.hl_hovercolor = RGB(tonumber(args[3]) or 255, tonumber(args[4]) or 255, tonumber(args[5]) or 255)
  elseif args[4] and args[4] ~= "" then
    state.hl_hovercolor = RGB(tonumber(args[2]) or 255, tonumber(args[3]) or 255, tonumber(args[4]) or 255)
  elseif args[3] and args[3] ~= "" then
    state.hl_argument = args[2]
    state.hl_hovercolor = const.HyperlinkColors[args[3]]
  else
    state.hl_hovercolor = const.HyperlinkColors[args[2]]
  end
  state.hl_internalid = state.hl_internalid + 1
  state.hl_function = args[1]
  if state.hl_argument == "true" then
    state.hl_argument = true
  elseif state.hl_argument == "false" then
    state.hl_argument = false
  elseif tonumber(state.hl_argument) then
    state.hl_argument = tonumber(state.hl_argument)
  end
end
tag_processors.h = tag_processors.hyperlink
tag_processors["/hyperlink"] = function(state, args)
  state.hl_function = nil
  state.hl_argument = nil
  state.hl_hovercolor = nil
  state.hl_underline = nil
end
tag_processors["/h"] = tag_processors["/hyperlink"]
function tag_processors.shadowcolor(state, args)
  local effect_color
  if args[1] == "none" then
    effect_color = RGBA(0, 0, 0, 0)
  else
    if args[1] == "" or args[2] == "" or args[3] == "" then
      state:PrintErr("found tag 'shadowcolor' without 3 value for RGB :", text, n)
    end
    effect_color = RGB(tonumber(args[1]) or 255, tonumber(args[2]) or 255, tonumber(args[3]) or 255)
  end
  local frame = state:PushStackFrame("effect")
  frame.effect_color = effect_color
end
tag_processors["/shadowcolor"] = function(state, args)
  state:PopStackFrame("effect")
end
local effect_types = {
  shadow = "shadow",
  glow = "glow",
  outline = "outline",
  extrude = "extrude",
  ["false"] = false,
  none = false
}
function tag_processors.effect(state, args)
  local effect_type = "shadow"
  local effect_color = RGB(64, 64, 64)
  local effect_size = 2
  local effect_dir = point(1, 1)
  local effect_type = effect_types[args[1]]
  if effect_type == nil then
    state:PrintErr("tag effect with invalid type", args[1])
    effect_type = false
  end
  effect_size = tonumber(args[2]) or 2
  effect_color = RGB(tonumber(args[3]) or 255, tonumber(args[4]) or 255, tonumber(args[5]) or 255)
  effect_dir = point(tonumber(args[6]) or 1, tonumber(args[7]) or 1)
  local frame = state:PushStackFrame("effect")
  frame.effect_color = effect_color
  frame.effect_size = effect_size
  frame.effect_type = effect_type
  frame.effect_dir = effect_dir
end
tag_processors["/effect"] = function(state, args)
  state:PopStackFrame("effect")
end
local remove_after = function(tbl, idx)
  while tbl[idx] do
    table.remove(tbl, #tbl)
  end
end
function tag_processors.reset(state, args)
  remove_after(state.stackable_state, 2)
end
function tag_processors.text(state, text)
  local lines = {}
  local pos_bytes = 1
  local text_bytes = #text
  while pos_bytes <= text_bytes do
    local new_line_start_idx, new_line_end_idx = string.find(text, "\r?\n", pos_bytes)
    if not new_line_start_idx then
      new_line_start_idx = text_bytes + 1
      new_line_end_idx = text_bytes + 1
    end
    local line = string.sub(text, pos_bytes, new_line_start_idx - 1)
    table.insert(lines, line)
    pos_bytes = new_line_end_idx + 1
  end
  if string.sub(text, text_bytes) == "\n" then
    table.insert(lines, "")
  end
  for idx, line in ipairs(lines) do
    if 1 < idx then
      state:MakeFuncBlock(function(layout)
        layout:NewLine(false)
      end)
    end
    local line_byte_idx = 1
    while true do
      local istart, iend = string.find(line, "\t", line_byte_idx, true)
      local part = string.sub(line, line_byte_idx, (istart or 0) - 1)
      state:MakeTextBlock(part)
      if istart then
        local width, height = UIL.MeasureText("    ", state:fontId())
        state:MakeBlock({
          total_width = width,
          total_height = height,
          min_start_width = width,
          new_line_forbidden = false,
          end_line_forbidden = false,
          text = false
        })
      else
        break
      end
      line_byte_idx = iend + 1
    end
  end
end
function tag_processors.image(state, args)
  local image = args[1]
  local image_size_org_x, image_size_org_y = UIL.MeasureImage(image)
  local current_image_scale_x, current_image_scale_y
  local arg2_scale = tonumber(args[2])
  if arg2_scale then
    current_image_scale_x = MulDivTrunc(arg2_scale * state.default_image_scale, state.scale:x(), 1000000)
    current_image_scale_y = MulDivTrunc(arg2_scale * state.default_image_scale, state.scale:y(), 1000000)
  else
    current_image_scale_x, current_image_scale_y = state.image_scale:xy()
  end
  local num1 = tonumber(args[3]) or 255
  local num2 = tonumber(args[4]) or 255
  local num3 = tonumber(args[5]) or 255
  local image_color = RGB(num1, num2, num3)
  if image_size_org_x == 0 and image_size_org_y == 0 then
    state:PrintErr("image not found in tag :", image)
  else
    local image_size_x = MulDivTrunc(image_size_org_x, current_image_scale_x, 1000)
    local image_size_y = MulDivTrunc(image_size_org_y, current_image_scale_y, 1000)
    local base_color_map = args[3] == "rgb" or args[6] == "rgb"
    state:MakeBlock({
      total_width = image_size_x,
      total_height = image_size_y,
      min_start_width = image_size_x,
      image_size_org_x = image_size_org_x,
      image_size_org_y = image_size_org_y,
      image = image,
      base_color_map = base_color_map,
      image_color = image_color,
      new_line_forbidden = true
    })
  end
end
function tag_processors.color(state, args)
  local color
  if #args == 1 then
    color = tonumber(args[1])
    if not color then
      local style = TextStyles[GetTextStyleInMode(args[1], GetDarkModeSetting()) or args[1]]
      if not style then
        state:PrintErr("TextStyle could not be found (" .. args[1] .. ")")
        color = RGB(255, 255, 255)
      else
        color = style.TextColor
      end
    end
  else
    local num1 = tonumber(args[1]) or 255
    local num2 = tonumber(args[2]) or 255
    local num3 = tonumber(args[3]) or 255
    local num4 = tonumber(args[4]) or 255
    color = RGBA(num1, num2, num3, num4)
  end
  if state.invert_colors then
    local r, g, b, a = GetRGBA(color)
    if r == g and g == b then
      local v = Max(240 - r, 0)
      color = RGBA(v, v, v, a)
    end
  end
  state:PushStackFrame("color").color = color
end
function tag_processors.alpha(state, args)
  local alpha = tonumber(args[1])
  local top = state:GetStackTop()
  local r, g, b = GetRGB(top.color or top.start_color)
  state:PushStackFrame("color").color = RGBA(r, g, b, alpha)
end
tag_processors["/color"] = function(state, args)
  state:PopStackFrame("color")
end
tag_processors["/alpha"] = tag_processors["/color"]
function tag_processors.scale(state, args)
  local scale_num = tonumber(args[1] or 1000)
  if not scale_num then
    state:PrintErr("Bad scale ", args[1])
    return
  end
  state.scale = state.original_scale * Max(1, scale_num) / 1000
  state.imagescale = state.scale
  local top = state:GetStackTop()
  local next_id, height = SetFont(top.font_name, state.scale)
  local frame = state:PushStackFrame("scale")
  frame.font_id = next_id
  frame.font_height = height
end
function tag_processors.imagescale(state, args)
  local scale_num = tonumber(args[1] or state.default_image_scale)
  if not scale_num then
    state:PrintErr("Bad scale ", args[1])
    return
  end
  state.image_scale = state.original_scale * Max(1, scale_num) / 1000
end
function tag_processors.style(state, args)
  local style = TextStyles[GetTextStyleInMode(args[1], GetDarkModeSetting()) or args[1]]
  if style then
    local next_id, height = SetFont(args[1], state.scale)
    local frame = state:PushStackFrame("style")
    frame.font_id = next_id
    frame.font_height = height
    frame.font_name = args[1]
    frame.color = style.TextColor
    frame.effect_color = style.ShadowColor
    frame.effect_size = style.ShadowSize
    frame.effect_type = style.ShadowType
    frame.effect_dir = style.ShadowDir
  else
    state:PrintErr("Invalid style", args[1])
  end
end
tag_processors["/style"] = function(state, args)
  state:PopStackFrame("style")
end
function tag_processors.wordwrap(state, args)
  local word_wrap = args[1]
  if word_wrap == "on" or word_wrap == "off" then
    state:PrintErr("WordWrap should be on or off")
    return
  end
  state:MakeFuncBlock(function(layout)
    layout.word_wrap = word_wrap == "on"
  end)
end
function tag_processors.right(state, args)
  state:MakeFuncBlock(function(layout)
    layout:SetAlignment("right")
  end)
end
function tag_processors.left(state, args)
  state:MakeFuncBlock(function(layout)
    layout:SetAlignment("left")
  end)
end
function tag_processors.center(state, args)
  state:MakeFuncBlock(function(layout)
    layout:SetAlignment("center")
  end)
end
function tag_processors.tab(state, args)
  state:MakeFuncBlock(function(layout)
    local tab_pos = tonumber(args[1]) * state.scale:x() / 1000
    if not tab_pos then
      layout:PrintErr("Bad tab pos", args[1])
      return
    end
    layout:SetTab(tab_pos, args[2])
  end)
end
function tag_processors.underline(state, args)
  if args[1] and (args[2] and args[3] or TextStyles[args[1]] or tonumber(args[1])) then
    if args[2] and args[3] then
      state.underline_color = RGB(tonumber(args[1]) or 255, tonumber(args[2]) or 255, tonumber(args[3]) or 255)
    else
      state.underline_color = TextStyles[args[1]] and TextStyles[args[1]].TextColor or tonumber(args[1])
    end
  else
    state.underline_color = false
  end
  state.underline = true
end
tag_processors["/underline"] = function(state, args)
  state.underline = false
  state.underline_color = false
end
DefineClass.BlockBuilder = {
  __parents = {"InitDone"},
  IsEnabled = false,
  first_error = false,
  line_height = 0,
  valign = "center",
  y_offset = 0,
  stackable_state = false,
  underline = false,
  underline_color = RGBA(0, 0, 0, 0),
  scale = point(1000, 1000),
  default_image_scale = 1000,
  image_scale = point(1000, 1000),
  hl_internalid = 0,
  hl_function = false,
  hl_argument = false,
  hl_hovercolor = false,
  hl_underline = false,
  blocks = false
}
function BlockBuilder:Init()
  self.stackable_state = {
    {
      font_id = 0,
      font_name = "",
      color = false,
      font_height = 32,
      effect_color = 0,
      effect_size = 0,
      effect_type = false,
      effect_dir = point(1, 1),
      start_color = 0
    }
  }
  self.blocks = {}
end
function BlockBuilder:ProcessTokens(tokens, src_text)
  self.tokens = tokens
  self.src_text = src_text
  local token_idx = 1
  while token_idx <= #tokens do
    self.token_idx = token_idx
    local token = tokens[token_idx]
    local handler = tag_processors[token.type]
    local offset
    if handler then
      offset = handler(self, token.args or token.text, token_idx) or 1
    else
      self:PrintErr("Encountered invalid token", token.type)
      offset = 1
    end
    token_idx = token_idx + offset
  end
end
function BlockBuilder:GetStackTop()
  return self.stackable_state[#self.stackable_state]
end
function BlockBuilder:PushStackFrame(tag)
  local stack = self.stackable_state
  local new_frame = table.copy(stack[#stack])
  new_frame.tag = tag
  stack[#stack + 1] = new_frame
  return new_frame
end
function BlockBuilder:PopStackFrame(tag)
  local stack = self.stackable_state
  local top = stack[#stack]
  if #stack == 1 then
    self:PrintErr("Tag", tag, "has no more frames to pop.")
    return top
  end
  if top.tag ~= tag then
    self:PrintErr("Tag \"" .. top.tag .. "\" was closed with tag \"" .. tag .. "\"")
  end
  table.remove(stack)
  return top
end
DefineClass.XTextParserError = {
  __parents = {
    "PropertyObject"
  },
  src_text = "",
  __eq = function(self, other)
    if not IsKindOf(self, "XTextParserError") or not IsKindOf(other, "XTextParserError") then
      return false
    end
    return self.src_text == other.src_text
  end
}
function BlockBuilder:PrintErr(...)
  local err = self:FormatErr(...)
  local token_list = {}
  for i = 1, #self.tokens do
    local token = self.tokens[i]
    local str = ""
    if token.type == "text" then
      str = token.text
    else
      str = "<color 40 160 40><literal " .. #token.text + 2 .. "><" .. token.text .. "></color>"
    end
    table.insert(token_list, str)
    if self.token_idx == i then
      table.insert(token_list, "<color 160 40 40><literal 8><<<ERROR</color>")
    end
  end
  if not self.first_error then
    err = string.format([[
<color 160 40 40>XText Parse Error: </color><literal %s>%s
%s]], #err, err, table.concat(token_list, "<color 40 40 140> || </color>"))
    self.first_error = err
    StoreErrorSource(XTextParserError:new({
      src_text = self.src_text
    }), err)
  end
end
function BlockBuilder:FormatErr(...)
  local err = ""
  for _, arg in ipairs(table.pack(...)) do
    err = err .. tostring(arg) .. " "
  end
  return err
end
function BlockBuilder:fontId()
  return self:GetStackTop().font_id
end
function BlockBuilder:MakeBlock(cmd)
  local top = self:GetStackTop()
  cmd.height = top.font_height
  cmd.font = cmd.font or top.font_id
  cmd.color = top.color
  cmd.effect_color = top.effect_color
  cmd.effect_type = top.effect_type
  cmd.effect_size = top.effect_size
  cmd.effect_dir = top.effect_dir
  cmd.line_height = Max(self.line_height, top.font_height)
  cmd.y_offset = self.y_offset
  cmd.background_color = top.background_color
  cmd.underline = self.underline
  cmd.underline_color = self.underline and self.underline_color or false
  cmd.hl_function = self.hl_function
  cmd.hl_argument = self.hl_argument
  cmd.hl_underline = self.hl_underline
  cmd.hl_hovercolor = self.hl_hovercolor
  cmd.hl_internalid = self.hl_internalid
  if not IsKindOf(cmd, "XTextBlock") then
    cmd = XTextBlock:new(cmd)
  end
  table.insert(self.blocks, cmd)
end
function BlockBuilder:MakeTextBlock(text)
  local width, height = UIL.MeasureText(text, self:fontId())
  local break_candidate = FindNextLineBreakCandidate(text, 1)
  local min_width = width
  if break_candidate and break_candidate < #text then
    min_width = UIL.MeasureText(text, self:fontId(), 1, break_candidate - 1)
  end
  local cannot_start_line, cannot_end_line = GetLineBreakInfo(text)
  self:MakeBlock({
    text = text,
    valign = self.valign,
    total_width = width,
    total_height = height,
    min_start_width = min_width,
    new_line_forbidden = cannot_start_line,
    end_line_forbidden = cannot_end_line
  })
end
function BlockBuilder:MakeFuncBlock(func)
  table.insert(self.blocks, XTextBlock:new({exec = func}))
end
DefineClass.BlockLayouter = {
  __parents = {
    "PropertyObject"
  },
  tokens = false,
  blocks = false,
  draw_cache = false,
  pos_x = 0,
  left_margin = 0,
  line_position_y = 0,
  last_font_height = 0,
  line_height = 0,
  font_linespace = 0,
  word_wrap = true,
  shorten = true,
  max_width = 1000000,
  alignment = "left",
  tab_x = 0,
  draw_cache_start_idx_current_line = 1,
  line_content_width = 0,
  line_was_word_wrapped = false,
  measure_width = 0,
  suppress_drawing_until = false,
  contains_wordwrapped_content = false
}
local MeasureText = UIL.MeasureText
local Advance = utf8.Advance
local FindTextThatFitsIn = function(line, start_idx, font_id, max_width, required_leftover_space, line_max_width)
  local pixels_reached = 0
  local byte_idx = start_idx
  local line_bytes = #line
  while byte_idx <= line_bytes do
    local next_break_idx = FindNextLineBreakCandidate(line, byte_idx)
    if not next_break_idx then
      break
    end
    local chunk_size = MeasureText(line, font_id, byte_idx, next_break_idx - 1)
    if line_bytes <= next_break_idx then
      chunk_size = chunk_size + required_leftover_space
    end
    if max_width < chunk_size + pixels_reached then
      local split_text = max_width == line_max_width and pixels_reached == 0
      if not split_text then
        local idx = byte_idx
        if string.byte(line, idx) == 32 then
          idx = idx + 1
        end
        if line_max_width < MeasureText(line, font_id, idx, next_break_idx - 1) then
          split_text = true
        end
      end
      if not split_text then
        break
      end
      do
        local curr_break_idx = byte_idx
        while next_break_idx > curr_break_idx do
          local next_idx = Advance(line, curr_break_idx, 1)
          chunk_size = MeasureText(line, font_id, byte_idx, next_idx - 1)
          if chunk_size > max_width - pixels_reached then
            break
          end
          curr_break_idx = next_idx
        end
        byte_idx = curr_break_idx
        return string.sub(line, start_idx, byte_idx - 1), byte_idx - start_idx
      end
      break
    end
    pixels_reached = pixels_reached + chunk_size
    byte_idx = next_break_idx
  end
  if pixels_reached == 0 then
    return "", 0, 0
  end
  return string.sub(line, start_idx, byte_idx - 1), byte_idx - start_idx
end
function BlockLayouter:FinalizeLine()
  self:FinishTab()
  if not self.draw_cache then
    self.draw_cache = {}
  end
  local draw_cache_line = self.draw_cache[self.line_position_y]
  if draw_cache_line then
    self.measure_width = Max(self.measure_width, self.line_content_width)
    for _, item in ipairs(draw_cache_line) do
      item.line_height = self.line_height
      if item.valign == "top" then
        item.y_offset = item.y_offset + 0
      elseif item.valign == "center" then
        item.y_offset = item.y_offset + (item.line_height - item.height) / 2
      else
        if item.valign == "bottom" then
          item.y_offset = item.y_offset + item.line_height - item.height
        else
        end
      end
    end
  end
  self.line_content_width = 0
  self.line_was_word_wrapped = false
end
function BlockLayouter:NewLine(word_wrapped)
  self:FinalizeLine()
  self.line_position_y = self.line_position_y + Max(self.last_font_height / 2, self.line_height + self.font_linespace)
  self.line_height = 0
  self.pos_x = self.left_margin
  self.line_was_word_wrapped = word_wrapped
  self.draw_cache_start_idx_current_line = 1
  if self.suppress_drawing_until == "new_line" then
    self.suppress_drawing_until = false
  end
end
function BlockLayouter:SetAlignment(align)
  if self.alignment ~= align then
    self:FinishTab()
    self.alignment = align
    if self.alignment ~= "left" then
      self.tab_x = 0
    end
  end
end
function BlockLayouter:SetTab(tab, alignment)
  if self.alignment ~= (alignment or "left") then
    self:SetAlignment(alignment or "left")
  else
    self:FinishTab()
  end
  self.tab_x = tab
end
function BlockLayouter:FinishTab()
  if not self.draw_cache then
    self.draw_cache = {}
  end
  local draw_cache_line = self.draw_cache[self.line_position_y]
  if not draw_cache_line then
    return
  end
  local draw_cache_start_idx = self.draw_cache_start_idx_current_line
  local used_width = 0
  for idx = draw_cache_start_idx, #draw_cache_line do
    local item = draw_cache_line[idx]
    used_width = Max(used_width, item.x + item.width)
  end
  local shift, alignment = 0, self.alignment
  if alignment == "center" then
    shift = -used_width / 2
  elseif alignment == "right" then
    shift = -used_width
  end
  shift = shift + self.tab_x
  for idx = draw_cache_start_idx, #draw_cache_line do
    local item = draw_cache_line[idx]
    item.x = item.x + shift
    if alignment == "center" then
      item.control_wide_center = true
    end
  end
  self.line_content_width = Max(self.line_content_width + used_width, used_width + self.tab_x)
  self.tab_x = 0
  self.draw_cache_start_idx_current_line = #draw_cache_line + 1
  self.pos_x = self.left_margin
end
function BlockLayouter:AvailableWidth()
  return Max(0, self.max_width - self.pos_x)
end
function BlockLayouter:PrintErr(...)
  print("DrawCache err", ...)
end
function BlockLayouter:SetVSpace(space)
  self.line_height = Max(self.line_height, space)
end
local CalcRequiredLeftoverSpace = function(blocks, idx)
  local pixels = 0
  while idx <= #blocks do
    local block = blocks[idx]
    if block.exec then
      break
    end
    local prev_block = blocks[idx - 1]
    if not (prev_block and prev_block.end_line_forbidden or block.new_line_forbidden) then
      break
    end
    pixels = pixels + block.min_start_width
    if not (block.min_start_width < block.total_width) then
    else
      break
    end
    idx = idx + 1
  end
  return pixels
end
function BlockLayouter:LayoutWordWrappedText(block, required_leftover_space)
  local line = block.text
  local byte_idx = 1
  local line_bytes = #line
  while byte_idx <= line_bytes do
    local has_just_word_wrapped = self.pos_x == self.left_margin and self.line_was_word_wrapped
    if has_just_word_wrapped then
      self.contains_wordwrapped_content = true
      if string.byte(line, byte_idx) == 32 then
        byte_idx = byte_idx + 1
        if line_bytes < byte_idx then
          break
        end
      end
    end
    local wrapped_text, advance_bytes = FindTextThatFitsIn(line, byte_idx, block.font, self:AvailableWidth(), required_leftover_space, self.max_width - self.left_margin)
    if #wrapped_text == 0 then
      if self.pos_x ~= self.left_margin then
        self:TryCreateNewLine()
      else
        wrapped_text = string.sub(line, byte_idx)
        advance_bytes = #wrapped_text
      end
    end
    self:DrawTextOnLine(block, wrapped_text)
    byte_idx = byte_idx + advance_bytes
  end
end
function BlockLayouter:DrawTextOnLine(block, text)
  text = text or block.text
  if text == "" then
    return
  end
  local text_width, text_height = UIL.MeasureText(text, block.font)
  if self.shorten and not self.word_wrap then
    local available = self:AvailableWidth()
    if text_width > available then
      text = UIL.TrimText(text, block.font, available, 0)
      text_width, text_height = UIL.MeasureText(text, block.font)
      self.suppress_drawing_until = "new_line"
      self.has_word_wrapped = true
    end
  end
  self:DrawOnLine({
    text = text,
    width = text_width,
    height = block.height,
    font = block.font,
    effect_color = block.effect_color or false,
    effect_type = block.effect_type or false,
    effect_size = block.effect_size or false,
    effect_dir = block.effect_dir or false,
    color = block.color,
    line_height = block.line_height,
    valign = block.valign,
    y_offset = block.y_offset,
    background_color = block.background_color,
    underline = block.underline,
    underline_color = block.underline_color,
    hl_function = block.hl_function,
    hl_argument = block.hl_argument,
    hl_underline = block.hl_underline,
    hl_hovercolor = block.hl_hovercolor or block.color,
    hl_internalid = block.hl_function and block.hl_internalid
  })
end
function BlockLayouter:LayoutBlock(block, required_leftover_space)
  if rawget(block, "text") then
    if block.text == "" then
      return
    end
    if self.word_wrap then
      self:LayoutWordWrappedText(block, required_leftover_space)
    else
      self:DrawTextOnLine(block)
    end
  elseif rawget(block, "image") then
    self:DrawOnLine({
      image = block.image,
      base_color_map = block.base_color_map,
      width = block.total_width,
      height = block.total_height,
      line_height = block.total_height,
      image_size_org = box(0, 0, block.image_size_org_x, block.image_size_org_y),
      valign = "center",
      y_offset = block.y_offset,
      image_color = block.image_color
    })
  else
    self:DrawOnLine({
      width = block.total_width,
      height = block.total_height,
      line_height = block.total_height
    })
  end
end
function BlockLayouter:TryCreateNewLine()
  if self.word_wrap then
    self:NewLine(true)
    return true
  end
  return false
end
function BlockLayouter:LayoutBlocks()
  local blocks = self.blocks
  local draw_cache = {}
  self.draw_cache = draw_cache
  local block_idx = 1
  local last_block_with_content = false
  while block_idx <= #blocks do
    local block = blocks[block_idx]
    if block.exec then
      block.exec(self)
    elseif not self.suppress_drawing_until then
      local required_leftover_space = 0
      if self.word_wrap then
        local new_line_allowed = not last_block_with_content or not last_block_with_content.end_line_forbidden and not block.new_line_forbidden
        if new_line_allowed and block.min_start_width > self:AvailableWidth() then
          self:TryCreateNewLine()
        end
        required_leftover_space = CalcRequiredLeftoverSpace(blocks, block_idx + 1)
      end
      self:LayoutBlock(block, required_leftover_space)
      last_block_with_content = block
    end
    block_idx = block_idx + 1
  end
  self:FinalizeLine()
  return draw_cache, self.measure_width, self.line_position_y + self.line_height
end
function BlockLayouter:DrawOnLine(cmd)
  cmd.x = self.pos_x
  self.pos_x = self.pos_x + cmd.width
  self.line_height = Max(Max(self.line_height, cmd.line_height), cmd.total_height)
  self.last_font_height = self.line_height
  if cmd.image or cmd.text then
    if not self.draw_cache then
      self.draw_cache = {}
    end
    if not self.draw_cache[self.line_position_y] then
      self.draw_cache[self.line_position_y] = {}
    end
    table.insert(self.draw_cache[self.line_position_y], cmd)
  end
end
function XTextCompileText(text)
  local tokens = XTextTokenize(text)
  if #tokens == 0 then
    return false
  end
  local draw_state = BlockBuilder:new({
    first_error = false,
    PrintErr = function(self, ...)
      if not self.first_error then
        local err = self:FormatErr(...)
        self.first_error = err
      end
    end
  })
  draw_state:ProcessTokens(tokens, text)
  return draw_state.first_error
end
function XTextMakeDrawCache(text, properties)
  local tokens = XTextTokenize(text)
  if #tokens == 0 then
    return {}
  end
  local start_font_id, start_font_height = SetFont(properties.start_font_name, properties.scale)
  local draw_state = BlockBuilder:new({
    IsEnabled = properties.IsEnabled,
    scale = properties.scale or point(1000, 1000),
    original_scale = properties.scale or point(1000, 1000),
    default_image_scale = properties.default_image_scale or 500,
    image_scale = MulDivTrunc(properties.scale, properties.default_image_scale, 1000),
    invert_colors = properties.invert_colors
  })
  local top = draw_state.stackable_state[1]
  top.font_id = start_font_id or top.font_id
  top.font_name = properties.start_font_name or top.font_name
  top.color = false
  top.font_height = start_font_height or top.font_height
  top.effect_color = properties.IsEnabled and properties.EffectColor or properties.DisabledEffectColor
  top.effect_size = properties.effect_size
  top.effect_type = properties.effect_type
  top.effect_dir = properties.effect_dir
  top.start_color = properties.start_color
  top.background_color = 0
  draw_state:ProcessTokens(tokens, text)
  local block_layouter = BlockLayouter:new({
    blocks = draw_state.blocks,
    max_width = properties.max_width,
    word_wrap = properties.word_wrap,
    shorten = properties.shorten
  })
  block_layouter:SetAlignment(properties.alignment or "left")
  local draw_cache, width, height = block_layouter:LayoutBlocks()
  return draw_cache or {}, block_layouter.contains_wordwrapped_content, Clamp(width, 0, properties.max_width), height
end
if Platform.developer then
  local test_string = "<underline> Underlined text. </underline>\n<color 120 20 120>Color is 120 20 120</color>.\n<color GedError>Color from TextStyle GedError</color>\nTags off: <tags off><color 255 0 0>Should not be red.</color><tags on>\n<left>Left aligned text\n<right>Right aligned text\n<center>Center aligned text\n<left>Left...<right>.. and right on the same line.\n<left>Image: <image CommonAssets/UI/Ged/left>\nTab commands set the current \"X\" position to a certain value. Use carefully as elements may overlap. Tab is <tags off><left><tags on> with offset.\n<tab 40>Tab to 40<tab 240>Tab to 240<newline>\nForced newline:<newline><tags off><newline><tags on> tag is always guaranteed to work(newlines might be trimmed by UI)\n<style GedError>A new TextStyle by id GedError.</style>\n<style GedDefault>GedDefault style in dark mode</style>\nVSpace 80 following...<newline>\n<vspace 80>...to here.\nWord wrapping that works even when mixing with CJK languages. Note that the font might not have glyphs: \228\189\160\231\159\165\233\129\147\230\136\145\230\152\175\232\176\129\229\144\151\239\188\159\230\136\145\229\143\175\230\152\175\231\142\137\231\154\135\229\164\167\227\128\130\n<effect glow 15 255 0 255>Shadows support...\n<shadowcolor 0 255 0>With another color& legacy tag</shadowcolor>no stack, so default color</effect>\n<scale 1800>Scaling support.<scale 1000>\n<imagescale 3000><image CommonAssets/UI/HandCursor>\n<hyperlink abc 255 0 0 underline>This is a hyperlink with ID abc and color 255 0 0</hyperlink>\n<style TestStyle>The quick brown fox jumps over the lazy dog</style>\n"
  function RunXTextParserTest(test)
    local game_question = StdMessageDialog:new({}, terminal.desktop, {
      question = true,
      title = "ABC",
      text = ""
    })
    game_question.MaxWidth = 10000
    game_question.idContainer.MaxWidth = 100000
    game_question.idContainer.Background = RGB(95, 83, 222)
    local effect_size = 2
    local text_ctrl = XText:new({
      MaxWidth = 410,
      ShadowSize = effect_size,
      WordWrap = true
    }, game_question.idContainer)
    text_ctrl:SetText(test_string)
    text_ctrl:SetOutsideScale(point(1000, 1000))
    game_question:Open()
    local test_case = "AB C EF\229\156\168\232\140\130\227\128\130\229\175\134"
  end
end
local default_forbidden_sof = ".-\n!%), .:; ? ]}\194\162\194\176\194\183\226\128\153\226\128\160\226\128\161\226\128\186\226\132\131\226\136\182\227\128\129\227\128\130\227\128\131\227\128\134\227\128\149\227\128\151\227\128\158\239\185\154\239\185\156\239\188\129\239\188\130\239\188\133\239\188\135\239\188\137\239\188\140\239\188\142\239\188\154\239\188\155\239\188\159\239\188\129\239\188\189\239\189\157\239\189\158\n)]\239\189\157\227\128\149\227\128\137\227\128\139\227\128\141\227\128\143\227\128\145\227\128\153\227\128\151\227\128\159\226\128\153\239\189\160\194\187\n\227\131\189\227\131\190\227\131\188\227\130\161\227\130\163\227\130\165\227\130\167\227\130\169\227\131\131\227\131\163\227\131\165\227\131\167\227\131\174\227\131\181\227\131\182\227\129\129\227\129\131\227\129\133\227\129\135\227\129\137\227\129\163\227\130\131\227\130\133\227\130\135\227\130\142\227\130\149\227\130\150\227\135\176\227\135\177\227\135\178\227\135\179\227\135\180\227\135\181\227\135\182\227\135\183\227\135\184\227\135\185\227\135\186\227\135\187\227\135\188\227\135\189\227\135\190\227\135\191\227\128\133\227\128\187\n\226\128\144\227\130\160\226\128\147\227\128\156\n? !\226\128\188\226\129\135\226\129\136\226\129\137\n\227\131\187\227\128\129 : ; ,\n\227\128\130.\n!%), .:; ? ]}\194\162\194\176\226\128\153\226\128\160\226\128\161\226\132\131\227\128\134\227\128\136\227\128\138\227\128\140\227\128\142\227\128\149\239\188\129\239\188\133\239\188\137\239\188\140\239\188\142\239\188\154\239\188\155\239\188\159\239\188\189"
local default_forbidden_eol = "$(\194\163\194\165\194\183\226\128\152\227\128\136\227\128\138\227\128\140\227\128\142\227\128\144\227\128\148\227\128\150\227\128\157\239\185\153\239\185\155\239\188\132\239\188\136\239\188\142\239\188\187\239\189\155\239\191\161\239\191\165\n([\239\189\155\227\128\148\227\128\136\227\128\138\227\128\140\227\128\142\227\128\144\227\128\152\227\128\150\227\128\157\226\128\152\239\189\159\194\171\n$([\\\\{\194\163\194\165\226\128\152\227\128\133\227\128\135\227\128\137\227\128\139\227\128\141\227\128\148\239\188\132\239\188\136\239\188\187\239\189\155\239\189\160\239\191\165\239\191\166#\n"
DefineClass.BreakCandidateRange = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      id = "Begin",
      editor = "number",
      default = 0
    },
    {
      id = "End",
      editor = "number",
      default = 0
    },
    {
      id = "Comment",
      editor = "text",
      default = ""
    },
    {
      id = "Enabled",
      editor = "bool",
      default = true
    }
  }
}
function BreakCandidateRange:OnEditorSetProperty(prop_id, old_value, ged)
  local parent = GetParentTableOfKind(self, "XTextParserVars")
  parent:Apply()
end
function BreakCandidateRange:GetEditorView()
  return string.format("%x-%x %s", self.Begin, self.End, self.Comment)
end
DefineClass.XTextParserVars = {
  __parents = {
    "PersistedRenderVars"
  },
  properties = {
    {
      text_style = "Console",
      id = "ForbiddenSOL",
      help = "Characters that should not start lines",
      lines = 5,
      max_lines = 25,
      word_wrap = true,
      editor = "text",
      default = default_forbidden_sof
    },
    {
      text_style = "Console",
      id = "ForbiddenEOL",
      help = "Characters that should not end lines",
      lines = 5,
      max_lines = 25,
      word_wrap = true,
      editor = "text",
      default = default_forbidden_eol
    },
    {
      id = "BreakCandidates",
      help = "UTF8 Ranges that allow breaking before them. Space character is always included even if not in the list.",
      editor = "nested_list",
      default = false,
      base_class = "BreakCandidateRange",
      inclusive = true
    }
  }
}
function XTextParserVars:Apply()
  const.LineBreak_ForbiddenSOL = string.gsub(self.ForbiddenSOL, " ", "")
  const.LineBreak_ForbiddenEOL = string.gsub(self.ForbiddenEOL, " ", "")
  local tbl = {}
  for idx, pair in ipairs(self.BreakCandidates or empty_table) do
    if pair.Enabled then
      tbl[#tbl + 1] = pair.Begin
      tbl[#tbl + 1] = pair.End
    end
  end
  utf8.SetLineBreakCandidates(tbl)
end
