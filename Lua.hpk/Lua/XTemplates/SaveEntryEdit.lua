PlaceObj("XTemplate", {
  __is_kind_of = "XTextEditor",
  group = "Zulu",
  id = "SaveEntryEdit",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XTextEditor",
    "Id",
    "idNewSave",
    "IdNode",
    true,
    "Margins",
    box(5, 0, 5, 0),
    "BorderWidth",
    3,
    "Padding",
    box(14, 9, 2, 1),
    "HAlign",
    "center",
    "VAlign",
    "center",
    "MinWidth",
    600,
    "MinHeight",
    56,
    "MaxWidth",
    600,
    "MaxHeight",
    56,
    "Visible",
    false,
    "FoldWhenHidden",
    true,
    "DrawOnTop",
    true,
    "BorderColor",
    RGBA(215, 159, 80, 255),
    "Background",
    RGBA(88, 92, 68, 255),
    "BackgroundRectGlowSize",
    2,
    "BackgroundRectGlowColor",
    RGBA(0, 0, 0, 127),
    "FocusedBorderColor",
    RGBA(215, 159, 80, 255),
    "FocusedBackground",
    RGBA(88, 92, 68, 255),
    "DisabledBorderColor",
    RGBA(128, 128, 128, 0),
    "DisabledBackground",
    RGBA(0, 0, 0, 255),
    "TextStyle",
    "MMNewGameName",
    "OnTextChanged",
    function(self)
      local subSubMenuParam = GetDialogModeParam(GetDialog(self):ResolveId("idSubSubContent"))
      if subSubMenuParam and g_SelectedSave.metadata.timestamp ~= subSubMenuParam.metadata.timestamp then
        GetDialog(self):ResolveId("idSubSubContent").mode_param = g_SelectedSave
        ObjModified("mercs_imgs")
        ShowSavegameDescription(self.context, GetDialog(self):ResolveId("idSubSubContent"))
      end
      local newText = self:GetText() ~= "" and self:GetText() or SavenameToName(g_SelectedSave.savename)
      newText = newText:lower()
      g_SelectedSave.newSaveName = newText
      self.parent:ResolveId("idNewSave").context.savename = newText
      local saveTitleText = GetDialog(self):ResolveId("idSubSubContent"):ResolveId("idSavegameTitle")
      if saveTitleText and self.context.id == GetDialogModeParam(saveTitleText).id then
        saveTitleText:SetText(newText)
      end
      if GetUIStyleGamepad() then
        self:OnKillFocus()
      end
      PlayFX("Typing", "start")
    end,
    "ConsoleKeyboardDescription",
    T(886360378099, "Enter Save Name"),
    "WordWrap",
    false,
    "AllowPaste",
    false,
    "AllowEscape",
    false,
    "MaxVisibleLines",
    1,
    "MaxLines",
    1,
    "MaxLen",
    20,
    "HintColor",
    RGBA(0, 0, 0, 0),
    "SelectionBackground",
    RGBA(124, 130, 96, 255)
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "OnKillFocus",
      "func",
      function(self, ...)
        CreateRealTimeThread(function()
          Sleep(0)
          while g_ZuluMessagePopup and #g_ZuluMessagePopup > 1 do
            WaitMsg("ZuluMessagePopup", 100)
          end
          local saveEntry = self.parent and self.parent:ResolveId("idSaveEntry")
          if not saveEntry then
            return "break"
          end
          saveEntry:SetVisible(true)
          if not g_SelectedSave or g_SelectedSave.metadata.timestamp ~= self.context.metadata.timestamp then
            local oldSaveName = SavenameToName(saveEntry.context.savename)
            saveEntry.idName:SetText(oldSaveName)
            self.context.savename = oldSaveName
            saveEntry:SetSelected(false)
          else
            saveEntry.idName:SetText(self:GetText())
            saveEntry:SetSelected(true)
          end
          GetDialog(self).parent:SetHandleMouse(false)
          self:SetVisible(false)
          self:LockScrollWhileEdit(false)
          XTextEditor.OnKillFocus(self)
        end)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        local saveEntry = self.parent:ResolveId("idSaveEntry")
        if shortcut == "Escape" or GetUIStyleGamepad() then
          saveEntry:SetVisible(true)
          self:SetVisible(false)
          GetDialog(self):ResolveId("idSubSubContent").mode_param = g_SelectedSave
          ShowSavegameDescription(self.context, GetDialog(self):ResolveId("idSubSubContent"))
          XTextEditor.OnKillFocus(self)
          return "break"
        elseif shortcut == "Enter" then
          local dlg = GetDialog(self)
          local obj = GetDialogModeParam(dlg)
          self:ClearSelection()
          CreateRealTimeThread(function(obj)
            self:OnKillFocus()
            Sleep(10)
            OverwriteSaveQuestion(obj)
          end, obj)
          return "break"
        else
          XTextEditor.OnShortcut(self, shortcut, source, ...)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDoubleClick(self, pos, button)",
      "func",
      function(self, pos, button)
        local dlg = GetDialog(self)
        local obj = GetDialogModeParam(dlg)
        CreateRealTimeThread(function(obj)
          OverwriteSaveQuestion(obj)
        end, obj)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetFocus(self)",
      "func",
      function(self)
        XTextEditor.OnSetFocus(self)
        self:LockScrollWhileEdit(true)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "LockScrollWhileEdit(self, lock)",
      "func",
      function(self, lock)
        local contentTemplate = GetDialog(self)[1]
        contentTemplate:ResolveValue("idScrollArea"):SetMouseScroll(not lock)
        contentTemplate:ResolveValue("idScroll"):SetHandleMouse(not lock)
        contentTemplate:ResolveValue("idScroll"):SetHandleKeyboard(not lock)
      end
    })
  })
})
