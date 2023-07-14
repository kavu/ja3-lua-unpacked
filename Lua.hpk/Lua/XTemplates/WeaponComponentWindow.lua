PlaceObj("XTemplate", {
  group = "Zulu Weapon Mod",
  id = "WeaponComponentWindow",
  PlaceObj("XTemplateWindow", {
    "__class",
    "WeaponComponentWindowClass",
    "IdNode",
    true,
    "HAlign",
    "left",
    "VAlign",
    "bottom",
    "UseClipBox",
    false,
    "ContextUpdateOnOpen",
    true
  }, {
    PlaceObj("XTemplateWindow", {"UseClipBox", false}, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XButton",
        "RolloverTemplate",
        "RolloverGeneric",
        "RolloverAnchor",
        "top",
        "RolloverOffset",
        box(0, 0, 0, 10),
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
          local slot = self.context.slot
          local errText = ""
          local modifyDlg = GetDialog("ModifyWeaponDlg").idModifyDialog
          local noErr, err, errParam = modifyDlg:CanModifySlot(slot)
          if not noErr and err == "blocked" then
            errText = T({
              637344314280,
              "<newline><newline><BlockedByError(param)>",
              param = errParam
            })
          end
          local weapon = ResolvePropObj(self.context)
          local equipped = weapon.components[slot.SlotType]
          if #(equipped or "") == 0 then
            local slotPreset = Presets.WeaponUpgradeSlot.Default[slot.SlotType]
            self:SetRolloverText(T(640610731922, "No attachment.") .. errText)
            self:SetRolloverTitle(slotPreset.DisplayName)
            local lowerCaseSlotType = string.lower(slot.SlotType)
            self.idIcon:SetImage("UI/Icons/Upgrades/default_" .. lowerCaseSlotType)
            return
          end
          local item = WeaponComponents[equipped]
          if item then
            self.idIcon:SetImage(GetWeaponComponentIcon(item, weapon))
            self:SetRolloverTitle(item.DisplayName)
            self:SetRolloverText(GetWeaponComponentDescription(item) .. errText)
          end
        end,
        "FXMouseIn",
        "buttonRollover",
        "FXPress",
        "WeaponModificationCategoryClick",
        "FXPressDisabled",
        "IactDisabled",
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
          "MinWidth",
          90,
          "MinHeight",
          90,
          "MaxWidth",
          90,
          "MaxHeight",
          90,
          "UseClipBox",
          false,
          "Image",
          "UI/Inventory/T_Backpack_Slot_Small",
          "ImageFit",
          "stretch"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idRollover",
          "MinWidth",
          90,
          "MinHeight",
          90,
          "MaxWidth",
          90,
          "MaxHeight",
          90,
          "UseClipBox",
          false,
          "Visible",
          false,
          "Image",
          "UI/Inventory/T_Backpack_Slot_Small_Hover",
          "ImageFit",
          "stretch"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idIcon",
          "MinWidth",
          90,
          "MinHeight",
          90,
          "MaxWidth",
          90,
          "MaxHeight",
          90,
          "UseClipBox",
          false,
          "ImageFit",
          "stretch"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idStateIcon",
          "Margins",
          box(0, 5, 5, 0),
          "HAlign",
          "right",
          "VAlign",
          "top",
          "UseClipBox",
          false,
          "Image",
          "UI/Icons/mod_blocked"
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idOverlay",
          "Background",
          RGBA(237, 31, 36, 25)
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "CreateRolloverWindow(self, gamepad, context, pos)",
          "func",
          function(self, gamepad, context, pos)
            local componentWnd = self:ResolveId("node")
            local modifyWeaponDlg = componentWnd and componentWnd:ResolveId("node")
            if modifyWeaponDlg and modifyWeaponDlg.idChoicePopup and not gamepad and GetUIStyleGamepad() then
              return
            end
            return XButton.CreateRolloverWindow(self, gamepad, context, pos)
          end
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "ApplyStyle(self, style)",
      "func",
      function(self, style)
        local desaturation = 0
        local transparency = 0
        if style == "deselected" then
          desaturation = 255
          transparency = 75
        end
        self:SetTransparency(transparency)
        self.idCurrent.idImage:SetDesaturation(desaturation)
        self.idCurrent.idIcon:SetDesaturation(desaturation)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        self.idCurrent:SetFocus(selected)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "IsSelectable(self)",
      "func",
      function(self)
        return self:GetEnabled()
      end
    })
  })
})
