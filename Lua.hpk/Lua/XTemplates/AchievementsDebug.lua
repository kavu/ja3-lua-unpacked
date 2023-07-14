PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu Dev",
  id = "AchievementsDebug",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Padding",
    box(64, 32, 64, 32),
    "LayoutMethod",
    "VList",
    "Background",
    RGBA(32, 35, 47, 233),
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateLayer", {
      "layer",
      "XPauseLayer",
      "togglePauseDialog",
      false
    }),
    PlaceObj("XTemplateLayer", {
      "layer",
      "XCameraLockLayer"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Dock",
      "top",
      "HAlign",
      "center",
      "TextStyle",
      "HUDHeaderBigLight",
      "Text",
      "Achievements"
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idMain",
      "Margins",
      box(2, 12, 2, 12),
      "BorderWidth",
      1,
      "Padding",
      box(32, 8, 32, 8),
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MaxWidth",
      1400,
      "LayoutMethod",
      "HList",
      "Background",
      RGBA(32, 35, 47, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XScrollBar",
        "Id",
        "idScrollbar",
        "Dock",
        "right",
        "MinWidth",
        20,
        "Target",
        "idList"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XList",
        "Id",
        "idList",
        "Margins",
        box(0, 0, 8, 0),
        "BorderWidth",
        0,
        "Padding",
        box(8, 8, 8, 8),
        "Dock",
        "box",
        "LayoutVSpacing",
        4,
        "Background",
        RGBA(255, 255, 255, 0),
        "FocusedBackground",
        RGBA(255, 255, 255, 0),
        "VScroll",
        "idScrollbar",
        "ShowPartialItems",
        false
      }, {
        PlaceObj("XTemplateForEach", {
          "comment",
          "Achievement Group",
          "array",
          function(parent, context)
            return PresetGroupNames("Achievement")
          end,
          "__context",
          function(parent, context, item, i, n)
            local startIdx = 0
            for j = 1, i - 1 do
              startIdx = startIdx + #Presets.Achievement[j]
            end
            return {group = item, startIdx = startIdx}
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "Group name",
            "__class",
            "XText",
            "Margins",
            box(0, 16, 0, 0),
            "TextStyle",
            "HUDHeaderBigger",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              self:SetText(context.group)
            end,
            "TextVAlign",
            "center"
          }),
          PlaceObj("XTemplateForEach", {
            "comment",
            "Achievement",
            "array",
            function(parent, context)
              return Presets.Achievement[context.group]
            end,
            "__context",
            function(parent, context, item, i, n)
              return SubContext(item, {
                idx = context.startIdx + i
              })
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextWindow",
              "IdNode",
              true,
              "BorderWidth",
              2,
              "Padding",
              box(2, 0, 0, 0),
              "LayoutMethod",
              "HList",
              "Background",
              RGBA(52, 55, 61, 255),
              "RolloverZoom",
              1010,
              "HandleMouse",
              true
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idName",
                "Margins",
                box(2, 0, 0, 0),
                "MinWidth",
                300,
                "MaxWidth",
                300,
                "TextStyle",
                "HUDHeader",
                "Translate",
                true,
                "Text",
                T(360726316855, "<idx>. <display_name>"),
                "TextVAlign",
                "center"
              }),
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return context.id
                end,
                "__class",
                "XText",
                "Id",
                "idUnlocked",
                "Margins",
                box(4, 0, 4, 0),
                "Padding",
                box(0, 0, 0, 0),
                "MinWidth",
                100,
                "MaxWidth",
                100,
                "Visible",
                false,
                "Background",
                RGBA(61, 122, 153, 255),
                "TextStyle",
                "HUDHeader",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  local unlocked = GetAchievementFlags(context)
                  self:SetVisible(unlocked)
                end,
                "Text",
                "Unlocked",
                "TextHAlign",
                "center",
                "TextVAlign",
                "center"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idDescription",
                "Margins",
                box(0, 0, 16, 0),
                "MinWidth",
                500,
                "MaxWidth",
                500,
                "TextStyle",
                "HUDHeader",
                "Translate",
                true,
                "Text",
                T(646769292817, "<description>"),
                "TextVAlign",
                "center"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XTextButton",
                "Id",
                "idReset",
                "Dock",
                "right",
                "MinWidth",
                100,
                "MaxWidth",
                100,
                "Background",
                RGBA(177, 22, 14, 255),
                "FXPress",
                "buttonPress",
                "FXPressDisabled",
                "IactDisabled",
                "OnPress",
                function(self, gamepad)
                  local context = self:GetContext()
                  ResetAchievement(context.id)
                  ObjModified(context.id)
                end,
                "TextStyle",
                "HUDHeader",
                "Text",
                "Reset"
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XToolBar",
      "Id",
      "idToolbar",
      "BorderWidth",
      1,
      "Padding",
      box(4, 0, 4, 0),
      "Dock",
      "bottom",
      "HAlign",
      "center",
      "VAlign",
      "bottom",
      "MinWidth",
      80,
      "MinHeight",
      40,
      "LayoutHSpacing",
      40,
      "BorderColor",
      RGBA(0, 0, 0, 0),
      "Background",
      RGBA(52, 55, 61, 0),
      "Toolbar",
      "Toolbar",
      "ButtonTemplate",
      "PDACommonButtonClass"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idClose",
      "ActionName",
      T(918170694445, "Close"),
      "ActionToolbar",
      "Toolbar",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnActionEffect",
      "close"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idResetAllAchievements",
      "ActionName",
      T(529182464517, "Reset all Achievements"),
      "ActionToolbar",
      "Toolbar",
      "ActionShortcut",
      "R",
      "ActionGamepad",
      "ButtonY",
      "OnAction",
      function(self, host, source, ...)
        ResetAchievements()
        for _, preset in ipairs(PresetArray("Achievement")) do
          ObjModified(preset.id)
        end
      end
    })
  })
})
