local XPopupWindowWithSearch = function(anchor, title, create_children_func)
  local popup = OpenDialog("GedNestedElementsList", terminal.desktop)
  function popup:OnShortcut(shortcut)
    if shortcut == "Escape" then
      popup:Close()
      return "break"
    elseif shortcut == "Down" then
      popup.idLeftList.idWin.idList:SetFocus()
    end
  end
  local list = popup.idLeftList.idWin.idList
  popup.idTitle:SetText(title)
  local edit = popup.idLeftList.idSearch
  local container = popup.idRightList
  function edit.OnTextChanged(edit)
    create_children_func(popup, list, container, edit:GetText())
  end
  function edit.OnShortcut(edit, shortcut, source, ...)
    if shortcut == "Escape" then
      return
    elseif shortcut == "Enter" and edit:GetText() then
      local list = edit.parent.idWin.idList
      if list[1] and list[1]:IsKindOf("XTextButton") then
        list[1]:OnPress()
        return
      end
    end
    return XEdit.OnShortcut(edit, shortcut, source, ...)
  end
  function list.OnShortcut(list, shortcut, source, ...)
    local relation = XShortcutToRelation[shortcut]
    if shortcut == "Down" or shortcut == "Up" or relation == "down" or relation == "up" then
      local focus = list.desktop.keyboard_focus
      local order = focus and focus:GetFocusOrder()
      if shortcut == "Down" or relation == "down" then
        focus = list:GetRelativeFocus(order or point(0, 0), "next")
      else
        focus = list:GetRelativeFocus(order or point(1000000000, 1000000000), "prev")
      end
      if focus then
        list:ScrollIntoView(focus)
        focus:SetFocus()
      end
      return "break"
    end
  end
  create_children_func(popup, list, container, "", "create")
  popup:SetModal(true)
  edit:SetFocus()
end
local XPopupListWithSearch = function(anchor, create_children_func)
  local popup = XPopup:new({}, terminal.desktop)
  function popup:OnKillFocus()
    if self.window_state == "open" then
      popup:Close()
    end
  end
  function popup:OnShortcut(shortcut)
    if shortcut == "Escape" then
      popup:Close()
      return "break"
    elseif shortcut == "Down" then
      popup.idPopupList:SetFocus()
    end
  end
  local list = XPopupList:new({
    Id = "idPopupList",
    AutoFocus = false,
    Dock = "bottom",
    MaxItems = 10,
    BorderWidth = 0,
    min_width = false,
    OnShortcut = function(list, shortcut, source, ...)
      if shortcut == "Escape" then
        return
      end
      return XPopupList.OnShortcut(list, shortcut, source, ...)
    end,
    Measure = function(self, max_width, max_height)
      local _, height
      if not self.min_width then
        self.min_width, height = XPopupList.Measure(self, max_width, max_height)
      else
        _, height = XPopupList.Measure(self, max_width, max_height)
      end
      return self.min_width, height
    end,
    OnKillFocus = function(self, new_focus)
    end
  }, popup)
  local edit = XEdit:new({
    Dock = "top",
    Id = "idSearch",
    Margins = box(2, 2, 2, 2),
    OnTextChanged = function(edit)
      create_children_func(popup, list.idContainer, edit:GetText())
    end,
    OnShortcut = function(list, shortcut, source, ...)
      if shortcut == "Escape" then
        return
      end
      return XEdit.OnShortcut(list, shortcut, source, ...)
    end
  }, popup)
  popup:SetAnchor(anchor.box)
  popup:SetAnchorType("drop-right")
  popup:SetScaleModifier(anchor.scale)
  popup:SetOutsideScale(point(1000, 1000))
  popup:Open()
  create_children_func(popup, list.idContainer, "")
  edit:SetFocus()
end
function FillUsageSegments(list, segments)
  local sum = 0
  for _, item in ipairs(list) do
    item.use_count = item.use_count or 0
    sum = sum + item.use_count
  end
  local sorted = table.copy(list)
  table.sortby_field(sorted, "use_count")
  local tally, target, segment = 0, 0, 0
  for _, item in ipairs(sorted) do
    tally = tally + item.use_count
    if target < tally then
      segment = segment + 1
      target = MulDivRound(sum, segment, segments)
    end
    item.usage_segment = segment
  end
  return sum
end
function GedOpenCreateItemPopup(panel, title, items, button, create_callback)
  if items and #items == 1 then
    create_callback(items[1].value)
    return
  end
  local defined = 0
  for i = 1, #items do
    local cat = items[i].category
    if cat and cat ~= "" and cat ~= "General" then
      defined = defined + 1
    end
  end
  if 2 <= defined then
    XPopupWindowWithSearch(button, title, function(popup, list, container, search_text, create)
      local least_dim = GetDarkModeSetting() and 255 or 32
      local most_dim = GetDarkModeSetting() and 128 or 140
      local modifiable_zone = most_dim - least_dim
      local suffixes = {
        "",
        "<right>\226\128\162",
        "<right>\226\128\162\226\128\162",
        "<right>\226\128\162\226\128\162\226\128\162"
      }
      local uses_total = FillUsageSegments(items, 3)
      local create_button = function(idx, item, container, popup, right)
        local entry = XTextButton:new({UseXTextControl = true}, container)
        entry:SetFocusOrder(point(1, idx))
        entry:SetLayoutMethod("Box")
        entry.idLabel:SetHAlign("stretch")
        if right and search_text == "" and uses_total ~= 0 then
          local gamma = most_dim - MulDivRound(modifiable_zone, item.usage_segment, 3)
          entry:SetText(string.format("<color %d %d %d>%s%s", gamma, gamma, gamma, item.text, suffixes[item.usage_segment + 1]))
        elseif right then
          entry:SetText(item.text .. suffixes[item.usage_segment + 1])
        else
          entry:SetText(item.text)
        end
        function entry.OnPress(entry)
          button:SetFocus()
          create_callback(item.value)
          button:SetFocus(false)
          if popup.window_state ~= "destroying" then
            popup:Close()
          end
        end
        if item.documentation then
          local uses_text = string.format([[


<style GedSmall>Used %d times in %s.]], item.use_count, g_GedApp.PresetClass or g_GedApp.ScriptPresetClass or "?")
          entry:SetRolloverText(item.documentation .. uses_text)
          entry:SetRolloverTemplate("GedToolbarRollover")
          entry:SetRolloverAnchor("bottom")
        end
        return entry
      end
      local categories_list = {}
      local currently_searching = false
      list:DeleteChildren()
      local to_find = string.lower(search_text)
      for i, item in ipairs(items) do
        if string.lower(item.text):find(to_find, 1, true) then
          create_button(i, item, list, popup)
        end
        local category = item.category ~= "" and item.category or "General"
        local list = categories_list[category] or {}
        list[#list + 1] = item
        categories_list[category] = list
      end
      if #list == 0 then
        XText:new({}, list):SetText("No items to choose from.")
      end
      local categories_list_indexed = {}
      for name, list in sorted_pairs(categories_list) do
        categories_list_indexed[#categories_list_indexed + 1] = {category = name, elements = list}
      end
      for idx, info in ipairs(categories_list_indexed) do
        local win
        if not create then
          for _, pane in ipairs(container) do
            local title = pane:ResolveId("idCategoryTitle")
            if title and title:GetText() == info.category then
              win = pane
              break
            end
          end
        end
        if not win then
          win = XTemplateSpawn("GedNestedElementsCategory", container)
          win:ResolveId("idCategoryTitle"):SetText(info.category)
        end
        local sublist = win:ResolveId("idCategoryElements")
        if sublist then
          sublist:DeleteChildren()
          local items = info.elements
          for i, item in ipairs(items) do
            local entry = create_button(i, item, sublist, popup, "right")
            entry:SetEnabled(not not string.lower(item.text):find(to_find, 1, true))
          end
        end
      end
      panel.app:UpdateChildrenDarkMode(popup)
    end)
  else
    XPopupListWithSearch(button, function(popup, container, search_text)
      container:DeleteChildren()
      local to_find = string.lower(search_text)
      for i, item in ipairs(items) do
        if string.lower(item.text):find(to_find, 1, true) then
          local entry = XTemplateSpawn("XComboListItem", container, false)
          entry:SetFocusOrder(point(1, i))
          entry:SetFontProps(XCombo)
          entry:SetText(item.text)
          entry:SetMinHeight(entry:GetFontHeight())
          function entry.OnPress(entry)
            button:SetFocus()
            create_callback(item.value)
            button:SetFocus(false)
            if popup.window_state ~= "destroying" then
              popup:Close()
            end
          end
        end
      end
      if #container == 0 then
        XText:new({}, container):SetText("No items to choose from.")
      end
      panel.app:UpdateChildrenDarkMode(popup)
    end)
  end
end
