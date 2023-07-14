PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "SaveEntry",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "MinHeight",
    64,
    "MaxHeight",
    64,
    "LayoutMethod",
    "HList",
    "Visible",
    false,
    "FoldWhenHidden",
    true,
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "RolloverOnFocus",
    false,
    "FocusedBorderColor",
    RGBA(215, 159, 80, 255),
    "FocusedBackground",
    RGBA(128, 128, 128, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return not GetDialog("PDADialog") and not g_SatelliteUI
      end,
      "__class",
      "XBlurRect",
      "Margins",
      box(0, 5, 0, 5),
      "Dock",
      "box",
      "BlurRadius",
      10,
      "Mask",
      "UI/Common/mm_panel",
      "FrameLeft",
      15,
      "FrameRight",
      10
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Id",
      "idEffect",
      "Margins",
      box(5, 5, 5, 5),
      "Dock",
      "box",
      "Transparency",
      179,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/screen_effect",
      "ImageScale",
      point(100000, 1000),
      "TileFrame",
      true,
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "UIEffectModifierId",
      "MainMenuMainBar",
      "Id",
      "idImg",
      "Dock",
      "box",
      "Transparency",
      64,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/mm_panel",
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "UIEffectModifierId",
      "MainMenuMainBar",
      "Id",
      "idImgBcgrSelected",
      "Dock",
      "box",
      "Visible",
      false,
      "Transparency",
      64,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/mm_panel_selected_2",
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "UIEffectModifierId",
      "MainMenuMainBar",
      "Id",
      "idImgAbove",
      "Margins",
      box(8, 8, 8, 8),
      "Dock",
      "box",
      "Visible",
      false,
      "Transparency",
      64,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/mm_option_entry_highlight",
      "ImageColor",
      RGBA(130, 128, 120, 191)
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "UIEffectModifierId",
      "MainMenuHighlight",
      "Id",
      "idImgBcgr",
      "Dock",
      "box",
      "Transparency",
      255,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/mm_panel_selected",
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idAutosave",
      "Margins",
      box(20, 0, 0, 0),
      "HAlign",
      "left",
      "VAlign",
      "center",
      "Visible",
      false,
      "FoldWhenHidden",
      true,
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "TextStyle",
      "MMAutoSave",
      "Translate",
      true,
      "Text",
      T(171355595875, "[AUTOSAVE]"),
      "WordWrap",
      false,
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idName",
      "Margins",
      box(20, 0, 0, 0),
      "HAlign",
      "left",
      "VAlign",
      "center",
      "MinWidth",
      290,
      "MaxWidth",
      290,
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "TextStyle",
      "MMOptionEntry",
      "WordWrap",
      false,
      "Shorten",
      true,
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idSaveState",
      "Margins",
      box(0, 0, 20, 0),
      "Dock",
      "right",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MaxWidth",
      140,
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "TextStyle",
      "MMOptionEntry",
      "Translate",
      true,
      "WordWrap",
      false,
      "Shorten",
      true,
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        local newSave = self.context.newSave and "MMOptionEntryValue" or "MMOptionEntry"
        self.idName:SetTextStyle(rollover and "MMOptionEntryHighlight" or newSave)
        self.idSaveState:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntry")
        self.idAutosave:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMAutoSave")
        if rollover then
          local editableField
          if self.parent:ResolveId("idNewSave") and self.parent:ResolveId("idNewSave").context.metadata.gameid == Game.id then
            editableField = true
          end
          PlayFX("MainMenuButtonRollover")
          self.idImgBcgr:SetTransparency(0, 150)
        else
          self.idImgBcgr:SetTransparency(255, 150)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        local editField = self.parent:ResolveId("idNewSave")
        if not self:IsFocused() or GetUIStyleGamepad() or editField and g_SelectedSave == self.context then
          PlayFX("MainMenuButtonClick", "start")
          local lastSelectedSave = g_SelectedSave and g_SelectedSave ~= self.context and g_SelectedSave.metadata.timestamp
          g_SelectedSave = self.context
          if editField then
            local posInList
            local list = self.parent.parent
            if not pos then
              posInList = list:GetSelection()[1]
            else
              posInList = list:GetItemAt(pos)
            end
            self.parent.parent.focused_item = posInList
            local canBeEdited = editField.context.metadata.gameid == Game.id
            if canBeEdited then
              editField:SetText(SavenameToName(editField.context.savename))
              editField:SetVisible(true)
              editField:SetFocus(true)
              editField:SelectAll()
              self:SetVisible(false)
              CreateRealTimeThread(function()
                Sleep(5)
                GetDialog(self).parent:SetHandleMouse(true)
              end)
              g_CurrentlyEditingName = true
              ObjModified("NewSelectedSave")
              ObjModified("action-button-mm")
              GetDialog(self):ResolveId("idSubSubContent"):SetMode("save", editField.context)
              ShowSavegameDescription(editField.context, GetDialog(self):ResolveId("idSubSubContent"))
            else
              g_CurrentlyEditingName = false
              ObjModified("NewSelectedSave")
              ObjModified("action-button-mm")
              self:SetSelected(true)
            end
            for _, entry in ipairs(list) do
              local button = entry:ResolveId("idSaveEntry")
              if button then
                button:SetSelected(false)
              end
              if button and entry:ResolveId("idNewSave").context.metadata.timestamp == lastSelectedSave then
                local oldSavename = SavenameToName(button.context.savename)
                entry:ResolveId("idNewSave").context.savename = oldSavename
              end
            end
            if canBeEdited and GetUIStyleGamepad() then
              editField:OpenControllerTextInput()
            elseif GetUIStyleGamepad() then
              self:SetFocus(true)
            end
            return "break"
          else
            g_CurrentlyEditingName = false
            ObjModified("NewSelectedSave")
            GetDialog(self):ResolveId("idSubSubContent"):SetMode("save", self.context)
            ShowSavegameDescription(self.context, GetDialog(self):ResolveId("idSubSubContent"))
            ObjModified("action-button-mm")
            for _, save in ipairs(self.parent) do
              local metadata = save.context.metadata
              if metadata and metadata.timestamp == lastSelectedSave then
                if GetUIStyleGamepad() then
                  save:ResolveId("idImgBcgrSelected"):SetVisible(false)
                  return "break"
                else
                  save:SetSelected(false)
                end
              end
            end
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDoubleClick(self, pos, button)",
      "func",
      function(self, pos, button)
        local editField = self.parent:ResolveId("idNewSave")
        if not editField and CanLoadSave(g_SelectedSave) then
          local dlg = GetDialog(self)
          local obj = GetDialogModeParam(dlg)
          obj:Load(dlg, g_SelectedSave, Platform.developer)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "ButtonA" then
          self:OnMouseButtonDown(nil, "L")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        if GetUIStyleGamepad() then
          self:SetFocus(selected)
          self.idImgBcgrSelected:SetVisible(g_SelectedSave == self.context)
        else
          self:SetFocus(selected or g_SelectedSave == self.context)
          self.idImgBcgrSelected:SetVisible(selected or g_SelectedSave == self.context)
          self.idImg:SetVisible(not selected and g_SelectedSave ~= self.context)
        end
        if selected and g_CurrentlyEditingName then
          g_CurrentlyEditingName = false
          ObjModified("NewSelectedSave")
        end
        if not selected and g_SelectedSave ~= self.context then
          local saveEntryEdit = self.parent and self.parent:ResolveId("idNewSave")
          if not saveEntryEdit then
            return
          end
          local oldSavename = self.context.newSave and _InternalTranslate(T(914064246115, "NEW SAVE")) or SavenameToName(self.context.savename)
          saveEntryEdit.context.savename = SavenameToName(self.context.savename)
          self.idName:SetText(oldSavename)
        end
      end
    })
  })
})
