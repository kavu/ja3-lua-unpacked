PlaceObj("XTemplate", {
  __is_kind_of = "XPropControl",
  group = "Zulu",
  id = "PropChoice",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPropControl",
    "RolloverTemplate",
    "RolloverGenericNoTitle",
    "RolloverAnchor",
    "right",
    "RolloverOffset",
    box(20, -5, 0, 0),
    "LayoutMethod",
    "HList",
    "RolloverOnFocus",
    true
  }, {
    PlaceObj("XTemplateProperty", {"id", "isExpanded"}),
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
      "AutoFitText",
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
      "MMOptionEntry",
      "Translate",
      true,
      "TextVAlign",
      "center",
      "SafeSpace",
      10
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "AutoFitText",
      "Id",
      "idValue",
      "HAlign",
      "left",
      "VAlign",
      "center",
      "MinWidth",
      200,
      "MaxWidth",
      200,
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "TextStyle",
      "MMOptionEntryValue",
      "Translate",
      true,
      "TextHAlign",
      "center",
      "TextVAlign",
      "center",
      "SafeSpace",
      10
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idExpandBackground",
      "Margins",
      box(0, 12, 15, 12),
      "Dock",
      "right",
      "MinWidth",
      40,
      "MaxWidth",
      40,
      "Background",
      RGBA(124, 130, 96, 64)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idExpandArrow",
        "Image",
        "UI/PDA/Quest/expand_arrow",
        "FlipY",
        true
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnPropUpdate(self, context, prop_meta, value)",
      "func",
      function(self, context, prop_meta, value)
        local items = prop_meta.items
        if type(items) == "function" then
          items = items(context, prop_meta.id)
        end
        local text
        if type(value) == "table" then
          local count = 0
          for k, v in pairs(value) do
            if v ~= "none" then
              count = count + 1
            end
          end
          if count == 0 then
            text = T(732036341296, "None selected")
          elseif count == 1 and value.random then
            text = T(141246507157, "Random")
          else
            text = Untranslated("x" .. count)
          end
        elseif prop_meta.id == "Resolution" then
          text = T({
            664014484626,
            "<FormatResolution(pt)>",
            pt = value
          })
        else
          local entry = items and table.find_value(items, "value", value)
          text = entry and entry.text or ""
        end
        local read_only = prop_meta.read_only
        if type(read_only) == "function" then
          read_only = read_only(prop_meta)
        end
        if read_only then
          self.idValue:SetEnabled(false)
          function self.OnMouseButtonDown()
            PlayFX("activityAssignSelectDisabled", "start")
          end
        else
          self:SetEnabled(true)
        end
        self.idValue:SetText(text)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        XPropControl.OnMouseButtonDown(self, pos, button)
        if button == "L" then
          self:SetRolloverText("")
          local dialog = GetDialog(self):ResolveId("idSubSubContent")
          if dialog and GetDialogModeParam(dialog) and GetDialogModeParam(dialog).prop_meta.id == self.context.prop_meta.id and not GetUIStyleGamepad() then
            CloseOptionsChoiceSubmenu(self)
            self:SetFocus(false)
            return "break"
          else
            CloseOptionsChoiceSubmenu(self)
            self.idImgBcgrSelected:SetVisible(true)
            dialog:SetMode("items", self)
            GetDialog(self):ResolveId("idSubMenu"):ResolveId("idScrollArea"):SetMouseScroll(false)
          end
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
        if self.idValue.enabled and GetUIStyleGamepad() then
          self:SetFocus(selected)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self.idName:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntry")
        self.idValue:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntryValue")
        self.idExpandBackground.idExpandArrow:SetImageColor(rollover and RGB(52, 55, 61) or RGB(255, 255, 255))
        self.idExpandBackground:SetBackground(rollover and RGBA(124, 130, 96, 153) or RGBA(124, 130, 96, 64))
        if rollover then
          if not self.isExpanded then
            self:SetRolloverText(self.context.prop_meta.help)
          end
          PlayFX("MainMenuButtonRollover")
          self.idImgBcgr:SetTransparency(0, 150)
        else
          self.idImgBcgr:SetTransparency(255, 150)
        end
      end
    })
  })
})
