DefineClass.XSpellcheckPlugin = {
  __parents = {
    "XTextEditorPlugin"
  },
  UnderlineColor = RGB(255, 20, 20)
}
local word_chars = "[_%w\127-\255']"
local nonword_chars = "[^_%w\127-\255']"
local word_pattern = "(" .. word_chars .. "*)" .. "(" .. nonword_chars .. "*)"
local whitespace = "[\t ]"
local multiple_whitespace = "[\t ][\t ]+"
local MeasureToCharStart = UIL.MeasureToCharStart
local StretchText = UIL.StretchText
function XSpellcheckPlugin:Init()
  LoadDictionary()
end
function XSpellcheckPlugin:OnDrawText(edit, line_idx, text, target_box, font, text_color)
  local y = target_box:maxy() - 4
  local position_in_text = 0
  local substitutions = {
    {"\226\128\152", "'"},
    {"\226\128\153", "'"},
    {"\226\128\156", "\""},
    {"\226\128\157", "\""},
    {"\226\128\147", "-"},
    {"\226\128\148", "-"},
    {"\226\128\166", "."},
    {"\226\136\146", "-"}
  }
  for i = 1, #substitutions do
    text = text:gsub(substitutions[i][1], substitutions[i][2])
  end
  if 1 <= #text and text:sub(1, 1):find(whitespace) then
    self:Underline(text, target_box:minx(), y, 1, 2, font)
  end
  if 1 <= #text and text:sub(#text - 1, #text - 1):find(whitespace) then
    self:Underline(text, target_box:minx(), y, #text - 1, #text, font)
  end
  local untagged, tag, first, last = string.nexttag(text, 1)
  local unmatched_closing_tag = false
  local close_tag_idx
  if not tag then
    local open_tag_idx = string.find(untagged, "<")
    close_tag_idx = string.find(untagged, ">")
    while open_tag_idx and close_tag_idx do
      local next_close_tag = string.find(untagged, ">", close_tag_idx + 1)
      if next_close_tag and open_tag_idx > next_close_tag then
        close_tag_idx = next_close_tag
      else
        break
      end
    end
    unmatched_closing_tag = close_tag_idx and not open_tag_idx or close_tag_idx and open_tag_idx and open_tag_idx > close_tag_idx
  end
  for word, non_word in text:gmatch(word_pattern) do
    if not (string.sub(text, position_in_text, position_in_text) ~= "<" or string.find(text, ">", position_in_text + 1)) then
      break
    end
    local current_word_end_pos = position_in_text + utf8.len(word)
    local new_position_in_text = current_word_end_pos + utf8.len(non_word)
    if tag and position_in_text >= first and last >= current_word_end_pos then
      if position_in_text < last and last <= new_position_in_text then
        untagged, tag, first, last = string.nexttag(text, new_position_in_text)
      end
    elseif not unmatched_closing_tag or not (position_in_text <= close_tag_idx) then
      word = word:gsub("^'", ""):gsub("'$", "")
      local lowercase_word = word:lower()
      if not WordInDictionary(word, lowercase_word) then
        self:Underline(text, target_box:minx(), y, position_in_text + 1, current_word_end_pos + 1, font)
      end
      local comma_pos = non_word:find("[,;].*")
      local comma, other_chars = non_word:match("([,;])(.*)")
      if comma and (not other_chars or not other_chars:starts_with("<")) and (not other_chars or other_chars:sub(1, 1) ~= " " or other_chars:sub(1, 1) == " " and current_word_end_pos + comma_pos == text:len()) then
        local underline_start = current_word_end_pos + comma_pos
        self:Underline(text, target_box:minx(), y, underline_start, underline_start + 1, font)
      end
      local dot_pos = non_word:find("[%.:][^%s]*$")
      local dot_idx = dot_pos and current_word_end_pos + dot_pos
      if dot_idx and dot_idx ~= text:len() then
        local next_char = text:sub(dot_idx + 1, dot_idx + 1)
        if next_char ~= "\"" and next_char ~= "'" and next_char ~= "." and next_char ~= "<" then
          self:Underline(text, target_box:minx(), y, dot_idx, dot_idx + 1, font)
        end
      end
      local whitespace_start, whitespace_end = non_word:find(multiple_whitespace)
      if whitespace_start then
        self:Underline(text, target_box:minx(), y, current_word_end_pos + whitespace_start, current_word_end_pos + whitespace_end + 1, font)
      end
    end
    position_in_text = new_position_in_text
  end
end
function XSpellcheckPlugin:Underline(text, x, y, underline_start, underline_end, font)
  local x_start = MeasureToCharStart(text, font, underline_start)
  local x_end = MeasureToCharStart(text, font, underline_end)
  UIL.DrawSolidRect(box(x + x_start, y, x + x_end, y + 2), self.UnderlineColor)
end
function XSpellcheckPlugin:OnRightButtonDown(edit, pt)
  local word = edit:GetWordUnderCursor(pt) or ""
  local lowercase_word = word:lower()
  if not WordInDictionary(word, lowercase_word) then
    CreateRealTimeThread(function()
      local title = "Add to dictionary"
      local text = "Do you want to save '" .. word .. "' to the dictionary?"
      local dialog = StdMessageDialog:new({}, edit.desktop, {
        question = true,
        title = title,
        text = text
      })
      dialog:Open()
      dialog:SetZOrder(BaseLoadingScreen.ZOrder + 2)
      local result, win = dialog:Wait()
      if result == "ok" then
        local new_entry = word:match("%l") and lowercase_word or word
        SpellcheckDict[new_entry] = true
        WriteToDictionary(SpellcheckDict)
      end
    end)
    return "break"
  end
end
if FirstLoad then
  g_ExternalTextEditorActiveCtrl = false
end
DefineClass.XExternalTextEditorPlugin = {
  __parents = {
    "XTextEditorPlugin"
  }
}
function XExternalTextEditorPlugin:Init()
  g_ExternalTextEditorActiveCtrl = false
end
function XExternalTextEditorPlugin:Done()
  if g_ExternalTextEditorActiveCtrl then
    g_ExternalTextEditorActiveCtrl = false
  end
end
function XExternalTextEditorPlugin:OpenEditor(edit)
  g_ExternalTextEditorActiveCtrl = edit
  AsyncCreatePath("AppData/editorplugin/")
  local file_path = "AppData/editorplugin/" .. config.DefaultExternalTextEditorTempFile
  AsyncStringToFile(file_path, edit:GetText())
  local cmd = config.DefaultExternelTextEditorCmd and string.format(config.DefaultExternelTextEditorCmd, ConvertToOSPath(file_path)) or string.format("\"%s\" %s", config.DefaultExternelTextEditorPath, ConvertToOSPath(file_path))
  os.execute(cmd)
end
function XExternalTextEditorPlugin:OnShortcut(edit, shortcut, source, ...)
  if shortcut == "Ctrl-E" then
    self:OpenEditor(edit)
    return true
  end
end
function XExternalTextEditorPlugin:OnTextChanged(edit)
  if g_ExternalTextEditorActiveCtrl == edit then
    local file_path = "AppData/editorplugin/" .. config.DefaultExternalTextEditorTempFile
    AsyncStringToFile(file_path, edit:GetText())
  end
end
function XExternalTextEditorPlugin.ApplyEdit(file, change)
  if change == "Modified" then
    local err, content = AsyncFileToString(file)
    if not err and g_ExternalTextEditorActiveCtrl then
      g_ExternalTextEditorActiveCtrl:SetText(content)
    end
  end
end
DefineClass.XHighlightTextPlugin = {
  __parents = {
    "XTextEditorPlugin"
  },
  HighlightColor = RGB(188, 168, 70),
  SingleInstance = false,
  highlighted_text = false,
  ignore_case = true
}
local find_next = function(str_lower, str, substr, start_pos)
  local idx = string.find(str_lower, substr, start_pos, true)
  if idx then
    return str:sub(start_pos, idx - 1), str:sub(idx, idx + #substr - 1)
  else
    return str:sub(start_pos)
  end
end
function XHighlightTextPlugin:OnAfterDrawText(edit, line_idx, text, target_box, font, text_color)
  if not self.highlighted_text or self.highlighted_text == "" then
    return
  end
  local pos = 1
  local text_start = target_box:minx()
  local lower_text = self.ignore_case and text:lower() or text
  local other, word
  repeat
    other, word = find_next(lower_text, text, self.highlighted_text, pos)
    if word then
      local len_word = utf8.len(word)
      local len_other = utf8.len(other)
      local x1 = MeasureToCharStart(text, font, pos + len_other)
      local x2 = MeasureToCharStart(text, font, pos + len_word + len_other)
      local word_box = box(text_start + x1, target_box:miny(), text_start + x2, target_box:maxy())
      StretchText(word, word_box, font, self.HighlightColor)
      pos = pos + len_word + len_other
    end
  until not word
  return true
end
