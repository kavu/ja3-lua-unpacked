PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "LoadGamePlaythrough",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "MinHeight",
    64,
    "MaxHeight",
    64,
    "LayoutMethod",
    "HList",
    "FoldWhenHidden",
    true,
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
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
        return not GetDialog("PDADialog")
      end,
      "__class",
      "XBlurRect",
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
      "idImg1",
      "Dock",
      "box",
      "Transparency",
      38,
      "HandleKeyboard",
      false,
      "Image",
      "UI/Common/mm_title",
      "SqueezeX",
      false,
      "SqueezeY",
      false
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
      300,
      "MaxWidth",
      300,
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "TextStyle",
      "PDABrowserHeader",
      "Translate",
      true,
      "WordWrap",
      false,
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idExpand",
      "Margins",
      box(0, 0, 20, 0),
      "Dock",
      "right",
      "HandleKeyboard",
      false,
      "Image",
      "UI/PDA/Quest/expand_arrow",
      "FlipY",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idDate",
      "Margins",
      box(0, 0, 15, 0),
      "Dock",
      "right",
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "TextStyle",
      "PDABrowserNameSmall",
      "WordWrap",
      false,
      "TextHAlign",
      "center",
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        local list = self.parent
        local posInList
        if not pos then
          posInList = list:GetSelection()[1]
        else
          posInList = self.parent:GetItemAt(pos)
        end
        local nextPlayThroughIdx = table.findfirst(list, function(idx, entry)
          local context = entry.context or entry[1].context
          return context and idx ~= posInList and idx > posInList and context.playthrough
        end)
        local lastSaveIdx = nextPlayThroughIdx and nextPlayThroughIdx - 1 or #list
        for i = posInList + 1, lastSaveIdx do
          local editField = list[i]:ResolveId("idNewSave")
          if editField and g_SelectedSave == list[i].idSaveEntry.context or g_SelectedSave == list[i].context then
            g_SelectedSave = false
            GetDialog(self):ResolveId("idSubSubContent"):SetMode("empty")
            g_CurrentlyEditingName = false
            ObjModified("NewSelectedSave")
            if editField then
              list[i].idSaveEntry:SetSelected(false)
              local oldSavename = SavenameToName(list[i].idSaveEntry.context.savename)
              list[i].idSaveEntry.idName:SetText(oldSavename)
            else
              list[i]:SetSelected(false)
            end
          end
          list[i]:SetVisible(not list[i].visible)
        end
        ObjModified("action-button-mm")
        self.idExpand:SetFlipY(not self.idExpand.FlipY)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self.idName:SetTextStyle(rollover and "InventoryToolbarButtonCenter" or "PDABrowserHeader")
        self.idDate:SetTextStyle(rollover and "MMOptionEntryValue" or "PDABrowserNameSmall")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        if GetUIStyleGamepad() then
          self:SetFocus(selected)
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
    })
  })
})
