PlaceObj("XTemplate", {
  __is_kind_of = "XLayer",
  group = "Zulu",
  id = "FullscreenDlgLayer",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XLayer",
    "IdNode",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "background",
      "__class",
      "XFrame",
      "IdNode",
      false,
      "Image",
      "UI/Inventory/T_Backpack_PlaceholderFrame",
      "SqueezeX",
      false,
      "SqueezeY",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "Id",
          "idTabs",
          "IdNode",
          true,
          "Margins",
          box(0, 50, 0, 0),
          "HAlign",
          "center",
          "VAlign",
          "top",
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          20
        }, {
          PlaceObj("XTemplateTemplate", {
            "comment",
            "inventory",
            "__template",
            "TabButton",
            "Id",
            "idInventory",
            "Text",
            T(154841807909, "INVENTORY"),
            "Mode",
            "inventory"
          }),
          PlaceObj("XTemplateTemplate", {
            "comment",
            "perks",
            "__template",
            "TabButton",
            "Id",
            "idPerks",
            "Text",
            T(254901262328, "PERKS"),
            "Mode",
            "perks"
          }),
          PlaceObj("XTemplateTemplate", {
            "comment",
            "mods",
            "__template",
            "TabButton",
            "Id",
            "idMods",
            "Text",
            T(748327075656, "MODS"),
            "Mode",
            "mods"
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "layerButton"
      end,
      "__class",
      "XButton",
      "RolloverTemplate",
      "RolloverGeneric",
      "RolloverText",
      T(343279859873, "Open PDA"),
      "ZOrder",
      3,
      "Margins",
      box(20, 0, 0, 0),
      "HAlign",
      "left",
      "VAlign",
      "center",
      "MinHeight",
      50,
      "MaxHeight",
      50,
      "LayoutMethod",
      "HList",
      "DrawOnTop",
      true,
      "BorderColor",
      RGBA(255, 255, 255, 0),
      "Background",
      RGBA(255, 255, 255, 0),
      "RolloverDrawOnTop",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self:SetHandleMouse(not g_ZuluMessagePopup)
      end,
      "FXMouseIn",
      "OpenPDARollover",
      "FXPress",
      "OpenPDAPress",
      "FXPressDisabled",
      "OpenPDADisabled",
      "FocusedBorderColor",
      RGBA(255, 255, 255, 0),
      "FocusedBackground",
      RGBA(255, 255, 255, 0),
      "DisabledBorderColor",
      RGBA(255, 255, 255, 0),
      "OnPress",
      function(self, gamepad)
        local dlg = GetDialog("FullscreenGameDialogs")
        dlg:Close()
        if gv_SatelliteView then
          OpenDialog("PDADialog", GetInGameInterface(), {Mode = "satellite"})
        else
          SatelliteToggleActionRun()
        end
      end,
      "RolloverBackground",
      RGBA(255, 255, 255, 0),
      "PressedBackground",
      RGBA(255, 255, 255, 0)
    }, {
      PlaceObj("XTemplateWindow", nil, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idRollover",
          "Visible",
          false,
          "Image",
          "UI/Inventory/T_FooterArrow_Outline",
          "Angle",
          10800
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Image",
          "UI/Inventory/T_FooterArrow_Default",
          "Angle",
          10800
        })
      })
    })
  })
})
