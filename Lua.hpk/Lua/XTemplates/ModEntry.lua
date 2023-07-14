PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "ModEntry",
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
    "RolloverOnFocus",
    false,
    "ChildrenHandleMouse",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      if g_SelectedMod == self.context then
        self:SetSelected(true)
      end
    end,
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
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 8, 0, 0),
        "LayoutMethod",
        "HList"
      }, {
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
          "idVersion",
          "Margins",
          box(5, 2, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "MaxWidth",
          140,
          "HandleKeyboard",
          false,
          "HandleMouse",
          false,
          "TextStyle",
          "PDASM_NewSquadLabel",
          "Text",
          "(v. 1.00-027)",
          "WordWrap",
          false,
          "Shorten",
          true,
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idAuthor",
        "Margins",
        box(20, -9, 0, 0),
        "Padding",
        box(2, 0, 2, 0),
        "HAlign",
        "left",
        "VAlign",
        "center",
        "MaxWidth",
        290,
        "HandleKeyboard",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "PDABrowserLevel",
        "Text",
        "Author",
        "WordWrap",
        false,
        "Shorten",
        true,
        "TextVAlign",
        "center"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idEnabledCheck",
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
      true,
      "Image",
      "UI/Hud/checkmark",
      "Columns",
      2
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "OnMouseButtonDown(self, pos, button)",
        "func",
        function(self, pos, button)
          local context = self.parent.context
          local dlg = GetPreGameMainMenu()
          ModsUIToggleEnabled(context, self, nil, nil, "dont modify")
          UpdateModsCount(dlg)
          PopulateModEntry(self.parent, context, "rollover")
          GetDialog(self):ResolveId("idSubSubContent"):SetMode("mod", context)
          if g_SelectedMod ~= context then
            self.parent:OnMouseButtonDown(pos, button)
          end
          if not GetUIStyleGamepad() then
            CreateRealTimeThread(function(dlg)
              if IsValidThread(g_EnableModThread) then
                WaitMsg("EnableModThreadEnd")
              end
              self.parent:OnSetRollover(false)
            end)
          end
          return "break"
        end
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idEnabledText",
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
      "SaveMapEntryTitle",
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
        self.idName:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntry")
        local isEnabled = not not table.find(AccountStorage.LoadMods, self.context.ModID)
        if isEnabled then
          self.idEnabledText:SetTextStyle(rollover and "InventoryRolloverAP" or "EnabledMod")
        else
          self.idEnabledText:SetTextStyle(rollover and "InventoryRolloverAP" or "SaveMapEntryTitle")
        end
        self.idAuthor:SetTextStyle(rollover and "PDABrowserLevelRollover" or "PDABrowserLevel")
        self.idVersion:SetTextStyle(rollover and "PDASM_NewSquadLabel_Rollover" or "PDASM_NewSquadLabel")
        if rollover then
          PlayFX("MainMenuButtonRollover")
          self.idImgBcgr:SetTransparency(0, 150)
          self.idEnabledCheck:SetImage("UI/Hud/checkmark_rollover")
        else
          self.idImgBcgr:SetTransparency(255, 150)
          self.idEnabledCheck:SetImage("UI/Hud/checkmark")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if not self:IsFocused() or GetUIStyleGamepad() then
          PlayFX("MainMenuButtonClick", "start")
          g_SelectedMod = self.context
          GetDialog(self):ResolveId("idSubSubContent"):SetMode("mod", self.context)
          if not GetUIStyleGamepad() then
            self:SetSelected(true)
          end
          local list = self.parent
          for _, entry in ipairs(list) do
            if entry.context ~= g_SelectedMod then
              entry:SetSelected(false)
            end
          end
          return "break"
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "ButtonA" then
          self.idEnabledCheck:OnMouseButtonDown(nil, "L")
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
          self.idImgBcgrSelected:SetVisible(g_SelectedMod == self.context)
          if selected then
            self:OnMouseButtonDown()
          end
        else
          self:SetFocus(selected)
          self.idImgBcgrSelected:SetVisible(selected)
          self.idImg:SetVisible(not selected)
        end
      end
    })
  })
})
