PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu",
  id = "NewGameMultiplayerGameEntry",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "RolloverTemplate",
    "RolloverGeneric",
    "RolloverAnchor",
    "right",
    "RolloverOffset",
    box(25, 0, 0, 0),
    "UIEffectModifierId",
    "MainMenuMainBar",
    "MinHeight",
    90,
    "MaxHeight",
    90,
    "LayoutMethod",
    "HList",
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "RolloverOnFocus",
    false,
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
      "XFrame",
      "UIEffectModifierId",
      "MainMenuMainBar",
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
      "Margins",
      box(20, 8, 0, 8),
      "HAlign",
      "left",
      "VAlign",
      "center",
      "MinWidth",
      470,
      "MaxWidth",
      470,
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idGameName",
        "HandleKeyboard",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "MMMultiplayerGameName",
        "Text",
        "Game name",
        "WordWrap",
        false,
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idCampaignName",
        "Margins",
        box(0, -3, 0, 0),
        "HandleKeyboard",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "MMMultiplayerCampaignName",
        "Translate",
        true,
        "WordWrap",
        false,
        "TextVAlign",
        "center"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 8, 20, 8),
      "Dock",
      "right",
      "HAlign",
      "right",
      "VAlign",
      "center",
      "MinWidth",
      50,
      "MaxWidth",
      300,
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "VAlign",
        "center",
        "LayoutMethod",
        "HList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idModsTitle",
          "VAlign",
          "bottom",
          "HandleKeyboard",
          false,
          "HandleMouse",
          false,
          "TextStyle",
          "MMMultiplayerModsTitle",
          "Translate",
          true,
          "Text",
          T(672091379875, "Mods"),
          "WordWrap",
          false,
          "TextHAlign",
          "right",
          "TextVAlign",
          "bottom"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idMods",
          "VAlign",
          "center",
          "HandleKeyboard",
          false,
          "HandleMouse",
          false,
          "TextStyle",
          "MMMultiplayerModsCount",
          "WordWrap",
          false,
          "TextHAlign",
          "right",
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idDay",
        "Margins",
        box(0, -3, 0, 0),
        "HAlign",
        "right",
        "HandleKeyboard",
        false,
        "HandleMouse",
        false,
        "TextStyle",
        "MMMultiplayerCampaignName",
        "Translate",
        true,
        "WordWrap",
        false,
        "TextHAlign",
        "right",
        "TextVAlign",
        "bottom"
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self.idGameName:SetRollover(rollover)
        self.idCampaignName:SetRollover(rollover)
        self.idMods:SetRollover(rollover)
        self.idModsTitle:SetRollover(rollover)
        self.idDay:SetRollover(rollover)
        if rollover then
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
        XButton.OnMouseButtonDown(self, pos, button)
        PlayFX("MainMenuButtonClick", "start")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "ButtonX" then
          self:OnMouseButtonDown(nil, "L")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        self:SetFocus(selected)
        if GetUIStyleGamepad() then
          self:SetRollover(selected)
        end
        self.idImgBcgrSelected:SetVisible(selected)
        if selected then
          local parent = self.parent
          for i = 1, #parent do
            if parent[i] ~= self then
              parent[i]:SetSelected(false)
            end
          end
        end
        local mm = GetDialog("InGameMenu") or GetDialog("PreGameMenu")
        if mm then
          local actions = mm:ResolveId("idSubMenu"):ResolveId("idToolBar")
          local joinButton = actions and actions:ResolveId("idjoin")
          if joinButton then
            joinButton:SetEnabled(selected, true)
            ObjModified("action-button-mm")
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnKillFocus",
      "func",
      function(self, ...)
        self:SetSelected(false)
        XButton.OnKillFocus(self)
      end
    })
  })
})
