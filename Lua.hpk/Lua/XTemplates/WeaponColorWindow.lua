PlaceObj("XTemplate", {
  group = "Zulu Weapon Mod",
  id = "WeaponColorWindow",
  PlaceObj("XTemplateWindow", {
    "__class",
    "WeaponComponentWindowClass",
    "IdNode",
    true,
    "HAlign",
    "left",
    "VAlign",
    "bottom",
    "LayoutMethod",
    "VList",
    "UseClipBox",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "LayoutMethod",
      "VList",
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return false
        end,
        "__class",
        "XText",
        "Id",
        "idSlotName",
        "Margins",
        box(0, 0, 0, 5),
        "HAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "TextStyle",
        "PDAQuestTitle",
        "Translate",
        true,
        "Text",
        T(488566108533, "<DisplayName>")
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XButton",
        "RolloverTemplate",
        "RolloverGeneric",
        "RolloverAnchor",
        "top",
        "RolloverOffset",
        box(0, 0, 0, 50),
        "Id",
        "idCurrent",
        "HAlign",
        "center",
        "UseClipBox",
        false,
        "BorderColor",
        RGBA(255, 255, 255, 0),
        "Background",
        RGBA(255, 255, 255, 0),
        "OnContextUpdate",
        function(self, context, ...)
          XContextControl.OnContextUpdate(self, context)
          local weapon = ResolvePropObj(self.context)
          local slot = self.context.slot
          local equipped = weapon.Color
          local colorItem = Presets.WeaponColor.Default[equipped]
          if not colorItem then
            return
          end
          self:SetRolloverText(colorItem.Description)
          self:SetRolloverTitle(colorItem.name)
          self.idIcon:SetBackground(colorItem.color)
        end,
        "FocusedBorderColor",
        RGBA(255, 255, 255, 0),
        "FocusedBackground",
        RGBA(255, 255, 255, 0),
        "DisabledBorderColor",
        RGBA(255, 255, 255, 0),
        "OnPress",
        function(self, gamepad)
          self:ResolveId("node"):ToggleOptions()
        end,
        "RolloverBackground",
        RGBA(255, 255, 255, 0),
        "PressedBackground",
        RGBA(255, 255, 255, 0)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idImage",
          "UseClipBox",
          false,
          "Image",
          "UI/Inventory/T_Backpack_Slot_Small"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idIcon",
          "UseClipBox",
          false,
          "ImageFit",
          "stretch"
        })
      })
    })
  })
})
