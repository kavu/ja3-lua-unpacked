PlaceObj("XTemplate", {
  __is_kind_of = "PDAQuestsTabButtonClass",
  group = "Zulu PDA",
  id = "PDAQuestsTabButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDAQuestsTabButtonClass",
    "HAlign",
    "left",
    "MinWidth",
    130,
    "MaxWidth",
    130,
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(0, 0, 0, 0),
    "BackgroundRectGlowColor",
    RGBA(0, 0, 0, 0),
    "FXPress",
    "EmailUI buttons click sounds",
    "FXPressDisabled",
    "IactDisabled",
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "OnPress",
    function(self, gamepad)
      local subContentDlg = self:ResolveId("node").idSubContent
      local modes = subContentDlg:GetModes()
      local buttonIndex = 1
      for i, but in ipairs(self.parent) do
        if but == self then
          break
        end
        if but.SetSelected then
          buttonIndex = buttonIndex + 1
        end
      end
      subContentDlg:SetMode(modes[buttonIndex])
    end,
    "RolloverBackground",
    RGBA(0, 0, 0, 0),
    "PressedBackground",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Id",
      "idLeftSep",
      "Margins",
      box(0, 10, 0, 10),
      "HAlign",
      "left",
      "Image",
      "UI/PDA/separate_line",
      "FrameBox",
      box(3, 3, 3, 3),
      "SqueezeX",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Id",
      "idRightSep",
      "Margins",
      box(0, 10, 0, 10),
      "HAlign",
      "right",
      "Image",
      "UI/PDA/separate_line",
      "FrameBox",
      box(3, 3, 3, 3),
      "SqueezeX",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Id",
      "idBackground",
      "Dock",
      "box",
      "Image",
      "UI/PDA/Quest/tab_selected",
      "FrameBox",
      box(5, 5, 5, 5)
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 5, 0, 0),
      "HAlign",
      "center",
      "VAlign",
      "center",
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idImage",
        "Image",
        "UI/PDA/Quest/tab_tasks",
        "Columns",
        2
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idText",
        "TextStyle",
        "PDAQuests_TabSelected",
        "Translate",
        true,
        "Text",
        T(437005377168, "Notes")
      })
    })
  })
})
