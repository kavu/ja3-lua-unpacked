PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu",
  id = "FloorHudButton",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "GenericHUDButtonFrame",
    "RolloverTemplate",
    "RolloverGeneric",
    "RolloverAnchor",
    "center-top",
    "RolloverText",
    T(805420999315, "Change the currently visualized floor for all buildings on the map"),
    "RolloverOffset",
    box(0, 0, 0, 15),
    "RolloverTitle",
    T(353230887159, "Change Floor"),
    "Id",
    "idFloorButton",
    "FoldWhenHidden",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "FloorHUDButtonClass",
        "Padding",
        box(0, 0, 0, 1),
        "Transparency",
        70,
        "HandleMouse",
        false,
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local text = false
          if not GetUIStyleGamepad() then
            text = T(270694379826, "[<ShortcutButton('actionCamFloorUp')>-<ShortcutButton('actionCamFloorDown')>]")
          end
          self:SetText(text)
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XWindowReverseDraw",
          "Id",
          "idFloorDisplay",
          "Margins",
          box(0, -20, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "center",
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          -4
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Margins",
          box(0, -20, 0, 0),
          "Dock",
          "box",
          "Image",
          "UI/Hud/T_HUD_LevelIcon_Background"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 0, -2, -2),
        "MinHeight",
        72,
        "MaxHeight",
        72,
        "LayoutMethod",
        "Grid",
        "UniformRowHeight",
        true,
        "Background",
        RGBA(52, 55, 60, 255),
        "BackgroundRectGlowSize",
        1,
        "BackgroundRectGlowColor",
        RGBA(52, 55, 60, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XButton",
          "RolloverAnchor",
          "center-top",
          "RolloverAnchorId",
          "node",
          "RolloverText",
          T(599064562710, "[<ShortcutButton('actionCamFloorUp')>] Floor Up"),
          "RolloverOffset",
          box(0, 0, 0, -5),
          "Id",
          "idFloorUp",
          "Margins",
          box(0, -2, 0, 0),
          "BorderWidth",
          2,
          "MinWidth",
          25,
          "MaxWidth",
          25,
          "BorderColor",
          RGBA(52, 55, 60, 255),
          "Background",
          RGBA(34, 35, 39, 255),
          "FXMouseIn",
          "FloorButtonRollover",
          "FXPress",
          "FloorButtonPress",
          "FXPressDisabled",
          "FloorButtonDisabled",
          "FocusedBorderColor",
          RGBA(0, 0, 0, 0),
          "FocusedBackground",
          RGBA(0, 0, 0, 0),
          "DisabledBorderColor",
          RGBA(0, 0, 0, 0),
          "OnPress",
          function(self, gamepad)
            local newFloor = cameraTac.GetFloor() + 1
            cameraTac.SetFloor(newFloor, hr.CameraTacInterpolatedMovementTime * 10, hr.CameraTacInterpolatedVerticalMovementTime * 10)
          end,
          "RolloverBackground",
          RGBA(0, 0, 0, 0),
          "PressedBackground",
          RGBA(0, 0, 0, 0)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idIcon",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Image",
            "UI/Hud/T_HUD_LevelButton_Arrow",
            "ImageColor",
            RGBA(195, 186, 172, 255)
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XButton",
          "RolloverAnchor",
          "center-top",
          "RolloverAnchorId",
          "node",
          "RolloverText",
          T(865086839874, "[<ShortcutButton('actionCamFloorDown')>] Floor Down"),
          "RolloverOffset",
          box(0, 0, 0, -5),
          "Id",
          "idFloorDown",
          "Margins",
          box(0, -2, 0, 0),
          "BorderWidth",
          2,
          "MinWidth",
          25,
          "MaxWidth",
          25,
          "GridY",
          2,
          "BorderColor",
          RGBA(52, 55, 60, 255),
          "Background",
          RGBA(34, 35, 39, 255),
          "FXMouseIn",
          "FloorButtonRollover",
          "FXPress",
          "FloorButtonPress",
          "FXPressDisabled",
          "FloorButtonDisabled",
          "FocusedBorderColor",
          RGBA(0, 0, 0, 0),
          "FocusedBackground",
          RGBA(0, 0, 0, 0),
          "DisabledBorderColor",
          RGBA(0, 0, 0, 0),
          "OnPress",
          function(self, gamepad)
            local newFloor = cameraTac.GetFloor() - 1
            cameraTac.SetFloor(newFloor, hr.CameraTacInterpolatedMovementTime * 10, hr.CameraTacInterpolatedVerticalMovementTime * 10)
          end,
          "RolloverBackground",
          RGBA(0, 0, 0, 0),
          "PressedBackground",
          RGBA(0, 0, 0, 0)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idIcon",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Image",
            "UI/Hud/T_HUD_LevelButton_Arrow",
            "ImageColor",
            RGBA(195, 186, 172, 255),
            "FlipY",
            true
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "controller observer",
      "__context",
      function(parent, context)
        return "GamepadUIStyleChanged"
      end,
      "__class",
      "XContextWindow",
      "IdNode",
      true,
      "UseClipBox",
      false,
      "Visible",
      false,
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self:ResolveId("node"):SetVisible(not GetUIStyleGamepad())
      end
    })
  })
})
