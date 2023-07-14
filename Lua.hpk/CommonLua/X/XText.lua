DefineClass.XText = {
  __parents = {
    "XTranslateText"
  },
  properties = {
    {
      category = "General",
      id = "Text",
      editor = "text",
      default = "",
      translate = function(obj)
        return obj:GetProperty("Translate")
      end,
      lines = 1
    },
    {
      category = "General",
      id = "WordWrap",
      editor = "bool",
      default = true,
      invalidate = "measure"
    },
    {
      category = "General",
      id = "Shorten",
      editor = "bool",
      default = false,
      invalidate = "measure"
    },
    {
      category = "General",
      id = "HideOnEmpty",
      editor = "bool",
      default = false,
      invalidate = "measure"
    },
    {
      category = "Layout",
      id = "TextHAlign",
      editor = "choice",
      default = "left",
      items = {
        "left",
        "center",
        "right"
      },
      invalidate = "measure"
    },
    {
      category = "Layout",
      id = "TextVAlign",
      editor = "choice",
      default = "top",
      items = {
        "top",
        "center",
        "bottom"
      },
      invalidate = true
    },
    {
      category = "Visual",
      id = "Angle",
      editor = "number",
      default = 0,
      invalidate = "measure",
      min = 0,
      max = 21599,
      scale = "deg"
    },
    {
      category = "Visual",
      id = "ImageScale",
      editor = "number",
      default = 500,
      invalidate = "measure"
    },
    {
      category = "Visual",
      id = "UnderlineOffset",
      editor = "number",
      default = 0
    },
    {
      category = "Debug",
      id = "draw_cache_text_width",
      read_only = true,
      editor = "number"
    },
    {
      category = "Debug",
      id = "draw_cache_text_height",
      read_only = true,
      editor = "number"
    },
    {
      category = "Debug",
      id = "text_width",
      read_only = true,
      editor = "number"
    },
    {
      category = "Debug",
      id = "text_height",
      read_only = true,
      editor = "number"
    },
    {
      category = "Debug",
      id = "DebugText",
      read_only = true,
      editor = "text",
      default = "",
      lines = 1,
      max_lines = 10
    },
    {
      category = "Debug",
      id = "DebugButtons",
      editor = "buttons",
      buttons = {
        {
          name = "Copy XText cloning code to clipboard",
          func = "CopyDebugText"
        }
      }
    }
  },
  Clip = "parent & self",
  Padding = box(2, 2, 2, 2),
  draw_cache = {},
  draw_cache_text_width = 0,
  draw_cache_text_height = 0,
  draw_cache_text_wrapped = false,
  force_update_draw_cache = false,
  invert_colors = false,
  scaled_underline_offset = 0,
  text_width = 0,
  text_height = 0,
  hovered_hyperlink = false,
  touch = false
}
function XText:GetDebugText()
  return self.text or ""
end
function XText:CopyDebugText()
  local width, height = self.box:sizexyz()
  local args = {
    MulDivRound(width, 1000, self.scale:x()),
    MulDivRound(height, 1000, self.scale:y()),
    self:GetDebugText()
  }
  local props = {
    "WordWrap",
    "Shorten",
    "TextHAlign",
    "TextVAlign",
    "ImageScale",
    "TextStyle",
    "TextFont",
    "TextColor",
    "ShadowType",
    "ShadowSize",
    "ShadowColor",
    "RolloverTextColor",
    "DisabledTextColor"
  }
  for _, id in ipairs(props) do
    table.insert(args, id)
    table.insert(args, self:GetProperty(id))
  end
  args = table.map(args, function(v)
    return ValueToLuaCode(v)
  end)
  local func = "XTextDebug(" .. table.concat(args, ", ") .. ")"
  CopyToClipboard(func)
end
if Platform.developer then
  if FirstLoad then
    DebugXTextContainer = false
  end
  function XTextDebug(width, height, text, ...)
    if DebugXTextContainer then
      DebugXTextContainer:delete()
    end
    DebugXTextContainer = XWindow:new({
      Id = "XTextDebugContainer",
      Background = RGBA(0, 0, 0, 128)
    }, terminal.desktop)
    local ctrl = XText:new({HAlign = "center", VAlign = "center"}, DebugXTextContainer)
    local props = table.pack(...)
    for i = 1, #props, 2 do
      ctrl:SetProperty(props[i], props[i + 1])
    end
    ctrl:SetMinWidth(width)
    ctrl:SetMaxWidth(width)
    ctrl:SetMinHeight(height)
    ctrl:SetMaxHeight(height)
    ctrl:SetText(text)
    ctrl:SetRollover(false)
  end
  function OnMsg.DbgClear()
    if DebugXTextContainer then
      DebugXTextContainer:delete()
      DebugXTextContainer = false
    end
  end
end
function XText:InvalidateMeasure(...)
  self.force_update_draw_cache = true
  return XWindow.InvalidateMeasure(self, ...)
end
function XText:Measure(max_width, max_height)
  self.content_measure_width = max_width
  self.content_measure_height = max_height
  self:UpdateDrawCache(max_width, max_height, self.force_update_draw_cache)
  self.force_update_draw_cache = false
  return self.text_width, Clamp(self.text_height, self.font_height, max_height)
end
function XText:UpdateMeasure(max_width, max_height)
  if self.HideOnEmpty and self.text == "" then
    self:UpdateDrawCache(max_width, max_height, true)
    self.force_update_draw_cache = false
    if 0 ~= self.measure_width or 0 ~= self.measure_height then
      self.measure_width = 0
      self.measure_height = 0
      if self.parent then
        self.parent:InvalidateLayout()
      end
    end
    self.measure_update = false
    return
  end
  return XTranslateText.UpdateMeasure(self, max_width, max_height)
end
function XText:Layout(x, y, width, height)
  if 0 < width and 0 < height and self:UpdateDrawCache(width, height) then
    self:InvalidateMeasure()
    self.force_update_draw_cache = false
  end
  return XTranslateText.Layout(self, x, y, width, height)
end
function XText:UpdateDrawCache(width, height, force)
  local old_text_width, old_text_height = self.text_width, self.text_height
  if force or self.draw_cache_text_width ~= width and (self.draw_cache_text_wrapped or width < self.text_width) or self.draw_cache_text_height ~= height and self.Shorten then
    self.draw_cache_text_width = width
    self.draw_cache_text_height = height
    if self.text == "" or width <= 0 then
      self.draw_cache, self.draw_cache_text_wrapped, self.text_width, self.text_height = empty_table, false, 0, 0
    else
      self.draw_cache, self.draw_cache_text_wrapped, self.text_width, self.text_height = XTextMakeDrawCache(self.text, {
        IsEnabled = self:GetEnabled(),
        EffectColor = self.ShadowColor,
        DisabledEffectColor = self.DisabledShadowColor,
        start_font_name = self.TextFont and self.TextFont ~= "" and self.TextFont or self:GetTextStyle(),
        start_color = self.TextColor,
        invert_colors = self.invert_colors,
        max_width = width,
        scale = self.scale,
        default_image_scale = self.ImageScale,
        effect_type = self.ShadowType,
        effect_size = self.ShadowSize,
        effect_dir = self.ShadowDir,
        alignment = self.TextHAlign,
        word_wrap = self.WordWrap,
        shorten = self.Shorten
      })
    end
    self:GetFontId()
  end
  local _, h = ScaleXY(self.scale, 0, self.UnderlineOffset)
  self.scaled_underline_offset = h
  return old_text_width < self.text_width or old_text_height < self.text_height
end
local tab_resolve_x = function(draw_info, sizex)
  local x = draw_info.x
  if draw_info.control_wide_center then
    return x + sizex / 2
  end
  return 0 <= x and x or sizex + x + 1
end
local one = point(1, 1)
local target_box = box()
function XText:DrawContent(clip_box)
  local content_box = self.content_box
  local destx, desty = content_box:minxyz()
  local sizex, sizey = content_box:sizexyz()
  local effect_size = self.ShadowSize
  if self.TextVAlign == "center" then
    desty = desty + (sizey - self.text_height - effect_size) / 2
  elseif self.TextVAlign == "bottom" then
    desty = content_box:maxy() - self.text_height
  end
  local clip_y1, clip_y2 = clip_box:miny(), clip_box:maxy()
  local underline_start_x, underline_color
  local angle = self.Angle
  local hovered_hyperlink_id = self.hovered_hyperlink and self.hovered_hyperlink.hl_internalid or -1
  local StretchTextShadow = UIL.StretchTextShadow
  local StretchTextOutline = UIL.StretchTextOutline
  local StretchText = UIL.StretchText
  local DrawImage = UIL.DrawImage
  local PushModifier = UIL.PushModifier
  local ModifiersGetTop = UIL.ModifiersGetTop
  local ModifiersSetTop = UIL.ModifiersSetTop
  local DrawSolidRect = UIL.DrawSolidRect
  local UseClipBox = self.UseClipBox
  local irOutside = const.irOutside
  local default_color = self:CalcTextColor()
  for y, draw_list in pairs(self.draw_cache) do
    local list_n = #draw_list
    for n, draw_info in ipairs(draw_list) do
      local x = tab_resolve_x(draw_info, sizex)
      local h = draw_info.height
      local vdest = desty + y + draw_info.y_offset
      if not UseClipBox or clip_y1 <= vdest + h and clip_y2 >= vdest then
        if draw_info.text then
          target_box:InplaceSetSize(destx + x, vdest, draw_info.width, h)
          local hl_hovered = hovered_hyperlink_id == draw_info.hl_internalid
          local color = hl_hovered and draw_info.hl_hovercolor or draw_info.color or default_color
          local underline = draw_info.underline or hl_hovered and draw_info.hl_underline
          if not underline_start_x and underline then
            underline_start_x = target_box:minx()
            underline_color = draw_info.underline_color or color
          end
          local background_color = draw_info.background_color
          if background_color and GetAlpha(background_color) > 0 then
            local bg_box = box(target_box:minx() - 2, target_box:miny(), target_box:maxx(), target_box:maxy())
            DrawSolidRect(bg_box, background_color)
          end
          if not UseClipBox or target_box:Intersect2D(clip_box) ~= irOutside then
            local effect_size = draw_info.effect_size or effect_size
            local effect_type = draw_info.effect_type
            local effect_color = draw_info.effect_color or self.ShadowColor
            local effect_dir = draw_info.effect_dir or one
            local _, _, _, effect_alpha = GetRGBA(effect_color)
            if effect_alpha ~= 0 and 0 < effect_size then
              local off = effect_size
              if effect_type == "shadow" then
                StretchTextShadow(draw_info.text, target_box, draw_info.font, color, effect_color, off, effect_dir, angle)
              elseif effect_type == "extrude" then
                StretchTextShadow(draw_info.text, target_box, draw_info.font, color, effect_color, off, effect_dir, angle, true)
              elseif effect_type == "outline" then
                StretchTextOutline(draw_info.text, target_box, draw_info.font, color, effect_color, off, angle)
              elseif effect_type == "glow" then
                local glow_size = MulDivRound(off * 1000, self.scale:x(), 1000)
                UIL.StretchTextSDF(draw_info.text, target_box, draw_info.font, "base_color", color, "glow_color", effect_color, "glow_size", glow_size)
              else
                StretchText(draw_info.text, target_box, draw_info.font, color, angle)
              end
            else
              StretchText(draw_info.text, target_box, draw_info.font, color, angle)
            end
          end
          local underline_to_end = underline and n == list_n
          if underline_start_x and (not underline or underline_to_end) then
            local baseline = vdest + self.font_baseline + self.scaled_underline_offset
            local end_x = underline_to_end and target_box:maxx() or target_box:minx()
            DrawSolidRect(box(underline_start_x, baseline, end_x, baseline + 1), underline_color)
            underline_start_x = nil
          end
        else
          local mtop
          if draw_info.base_color_map then
            mtop = ModifiersGetTop()
            PushModifier({
              modifier_type = const.modShader,
              shader_flags = const.modIgnoreAlpha
            })
          end
          target_box:InplaceSetSize(destx + x, vdest, draw_info.width, h)
          DrawImage(draw_info.image, target_box, draw_info.image_size_org, draw_info.image_color)
          if mtop then
            ModifiersSetTop(mtop)
          end
        end
      end
    end
  end
end
function XText:GetHyperLink(ptCheck)
  local content_box = self.content_box
  local basex, basey = content_box:minxyz()
  local sizex = content_box:sizex()
  for cache_y, draw_list in pairs(self.draw_cache) do
    for _, draw_info in ipairs(draw_list) do
      if draw_info.hl_function then
        local x = basex + tab_resolve_x(draw_info, sizex)
        local y = basey + cache_y
        if not ptCheck then
          return draw_info, box(x, y, x + draw_info.width, y + draw_info.height)
        end
        local checkx = ptCheck:x() - x
        local checky = ptCheck:y() - y
        if 0 <= checkx and checkx <= draw_info.width and 0 <= checky and checky <= draw_info.height then
          return draw_info, box(x, y, x + draw_info.width, y + draw_info.height)
        end
      end
    end
  end
  return false
end
function XText:HasHyperLinks()
  for y, draw_list in pairs(self.draw_cache) do
    for _, draw_info in ipairs(draw_list) do
      if draw_info.hl_function then
        return true
      end
    end
  end
  return false
end
function XText:OnHyperLink(hyperlink, argument, hyperlink_box, pos, button)
  local f, obj = ResolveFunc(self.context, hyperlink)
  if f then
    f(obj, argument)
  end
end
function XText:OnHyperLinkDoubleClick(hyperlink, argument, hyperlink_box, pos, button)
end
function XText:OnHyperLinkRollover(hyperlink, hyperlink_box, pos)
end
function XText:OnTouchBegan(id, pt, touch)
  self.touch = self:GetHyperLink(pt)
  if self.touch then
    return "break"
  end
end
function XText:OnTouchMoved(id, pt, touch)
  self:OnMousePos(pt)
  return "break"
end
function XText:OnTouchEnded(id, pt, touch)
  local h, link_box = self:GetHyperLink(pt)
  if h and h == self.touch then
    self:OnHyperLink(h.hl_function, h.hl_argument, link_box, pt, "L")
  end
  self.touch = false
  return "break"
end
function XText:OnTouchCancelled(id, pos, touch)
  self.touch = false
  return "break"
end
function XText:OnMouseButtonDown(pos, button)
  local h, link_box = self:GetHyperLink(pos)
  if h then
    self:OnHyperLink(h.hl_function, h.hl_argument, link_box, pos, button)
    return "break"
  end
end
function XText:OnMouseButtonDoubleClick(pos, button)
  local h, link_box = self:GetHyperLink(pos)
  if h then
    self:OnHyperLinkDoubleClick(h.hl_function, h.hl_argument, link_box, pos, button)
    return "break"
  end
end
function XText:OnMousePos(pos)
  if not pos then
    return
  end
  local h, link_box = self:GetHyperLink(pos)
  if self.hovered_hyperlink == h then
    return
  end
  self.hovered_hyperlink = h
  if h then
    self:OnHyperLinkRollover(h.hl_function, link_box, pos)
  else
    self:OnHyperLinkRollover(false, false, pos)
  end
  self:Invalidate()
end
function XText:OnMouseLeft(pt, ...)
  self:OnMousePos(pt)
  return XTranslateText.OnMouseLeft(self, pt, ...)
end
function XText:SetText(text)
  XTranslateText.SetText(self, text)
  self:OnMousePos(self.desktop and self.desktop.last_mouse_pos)
end
function Literal(text)
  if text == "" or IsT(text) then
    return text
  end
  return string.format("<literal %s>%s", #text, text)
end
function GetProjectConvertedFont(fontName)
  return fontName
end
