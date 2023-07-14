PlaceObj("XTemplate", {
  __is_kind_of = "XPropControl",
  group = "Zulu",
  id = "PropBool",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPropControl",
    "RolloverTemplate",
    "RolloverGenericNoTitle",
    "RolloverAnchor",
    "right",
    "RolloverOffset",
    box(20, -5, 0, 0),
    "OnLayoutComplete",
    function(self)
      if GetUIStyleGamepad() then
        self.RolloverOnFocus = true
      end
      self:SetRolloverText(self.context.prop_meta.help)
    end,
    "LayoutMethod",
    "HList",
    "MouseCursor",
    "CommonAssets/UI/HandCursor.tga",
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0)
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
      "XText",
      "Id",
      "idOn",
      "Margins",
      box(0, 0, 10, 0),
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      200,
      "MaxWidth",
      200,
      "FoldWhenHidden",
      true,
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "TextStyle",
      "MMOptionEntryValue",
      "Translate",
      true,
      "Text",
      T(124979663072, "On"),
      "TextHAlign",
      "center",
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idOff",
      "Margins",
      box(0, 0, 10, 0),
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      200,
      "MaxWidth",
      200,
      "FoldWhenHidden",
      true,
      "HandleKeyboard",
      false,
      "HandleMouse",
      false,
      "TextStyle",
      "MMOptionEntryValue",
      "Translate",
      true,
      "Text",
      T(388319833630, "Off"),
      "TextHAlign",
      "center",
      "TextVAlign",
      "center"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnPropUpdate(self, context, prop_meta, value)",
      "func",
      function(self, context, prop_meta, value)
        if prop_meta.on_value ~= nil then
          self.idOn:SetVisible(value == prop_meta.on_value)
        else
          self.idOn:SetVisible(not not value)
        end
        if prop_meta.off_value ~= nil then
          self.idOff:SetVisible(value == prop_meta.off_value)
        else
          self.idOff:SetVisible(not value)
        end
        local read_only = prop_meta.read_only
        if type(read_only) == "function" then
          read_only = read_only(prop_meta)
        end
        if read_only then
          self.idOn:SetEnabled(false)
          self.idOff:SetEnabled(false)
          function self.OnMouseButtonDown()
            PlayFX("activityAssignSelectDisabled", "start")
          end
        else
          self:SetEnabled(true)
        end
        self:SetHandleMouse(self.enabled)
        self:SetChildrenHandleMouse(self.enabled)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self.idName:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntry")
        self.idOn:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntryValue")
        self.idOff:SetTextStyle(rollover and "MMOptionEntryHighlight" or "MMOptionEntryValue")
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
        XPropControl.OnMouseButtonDown(self, pos, button)
        if button == "L" then
          CloseOptionsChoiceSubmenu(self)
          local id = self.prop_meta.id
          local value = ResolveValue(self.context, id)
          local on_value, off_value = self.prop_meta.on_value, self.prop_meta.off_value
          if on_value ~= nil and value == on_value and off_value ~= nil then
            value = off_value
          elseif off_value ~= nil and value == off_value and on_value ~= nil then
            value = on_value
          else
            value = not value
          end
          local obj = ResolvePropObj(self.context)
          SetProperty(obj, id, value)
          self.value = value
          self:OnPropUpdate(self.context, self.prop_meta, value)
          Msg("OptionsChanged")
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
        self:SetFocus(selected)
      end
    })
  })
})
