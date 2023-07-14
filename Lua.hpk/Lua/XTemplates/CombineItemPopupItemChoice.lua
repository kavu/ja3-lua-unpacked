PlaceObj("XTemplate", {
  __is_kind_of = "WeaponModChoicePopupClass",
  group = "Zulu",
  id = "CombineItemPopupItemChoice",
  PlaceObj("XTemplateWindow", {
    "__class",
    "WeaponModChoicePopupClass",
    "Id",
    "idChoicePopup",
    "Margins",
    box(0, 0, 0, 10),
    "BorderWidth",
    0,
    "Background",
    RGBA(0, 0, 0, 0),
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "AnchorType",
    "center-top"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "Id",
      "idComponentChoice",
      "BorderWidth",
      1,
      "Padding",
      box(8, 8, 8, 8),
      "BorderColor",
      RGBA(32, 35, 47, 255),
      "Background",
      RGBA(52, 55, 61, 255),
      "BackgroundRectGlowSize",
      2,
      "BackgroundRectGlowColor",
      RGBA(32, 35, 47, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextWindow",
        "Id",
        "idList",
        "HAlign",
        "center",
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        10
      }, {
        PlaceObj("XTemplateForEach", {
          "__context",
          function(parent, context, item, i, n)
            return item
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XButton",
            "Background",
            RGBA(0, 0, 0, 0),
            "ChildrenHandleMouse",
            true,
            "FXMouseIn",
            "buttonRollover",
            "FXPress",
            "buttonPress",
            "FXPressDisabled",
            "IactDisabled",
            "FocusedBackground",
            RGBA(0, 0, 0, 0),
            "RolloverBackground",
            RGBA(0, 0, 0, 0),
            "PressedBackground",
            RGBA(0, 0, 0, 0)
          }, {
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return context.container_data.item
              end,
              "__class",
              "XInventoryItemEmbed",
              "LayoutMethod",
              "HList",
              "Background",
              RGBA(32, 35, 47, 255),
              "square_size",
              90,
              "ShowOwner",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idRollover",
              "Visible",
              false,
              "Image",
              "UI/Inventory/T_Backpack_Slot_Small_Hover",
              "ImageFit",
              "stretch",
              "ImageColor",
              RGBA(249, 249, 219, 255)
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnMouseButtonDown(self, pos, button)",
              "func",
              function(self, pos, button)
                if button ~= "L" then
                  return
                end
                PlayFX(self.FXPress)
                local dlg = self:ResolveId("node")
                dlg.result = self.context
                dlg:Close()
              end
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnCaptureLost(self)",
      "func",
      function(self)
        if self.window_state ~= "open" then
          return
        end
        self:Close()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if self:MouseInWindow(pos) then
          return
        end
        if self.window_state ~= "open" then
          return
        end
        self:Close()
      end
    })
  })
})
