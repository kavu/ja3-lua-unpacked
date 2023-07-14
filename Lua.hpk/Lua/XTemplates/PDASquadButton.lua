PlaceObj("XTemplate", {
  __is_kind_of = "XButton",
  group = "Zulu Satellite UI",
  id = "PDASquadButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XButton",
    "OnLayoutComplete",
    function(self)
      self:ApplySelection()
    end,
    "BorderColor",
    RGBA(255, 255, 255, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "OnContextUpdate",
    function(self, context, ...)
      self.idImage:SetImage(self.context.image)
    end,
    "FXMouseIn",
    "buttonRollover",
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
      local parent = self:ResolveId("node")
      parent:SelectSquad(self.context)
      return "break"
    end,
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "Id",
      "idSelectionFrame",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      42,
      "MinHeight",
      42,
      "MaxWidth",
      42,
      "MaxHeight",
      42,
      "UseClipBox",
      false,
      "Background",
      RGBA(65, 130, 158, 255)
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idImageFrame",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      36,
      "MinHeight",
      36,
      "MaxWidth",
      36,
      "MaxHeight",
      36,
      "UseClipBox",
      false,
      "Background",
      RGBA(65, 130, 158, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idImage",
        "IdNode",
        false,
        "HAlign",
        "center",
        "VAlign",
        "center",
        "MinWidth",
        20,
        "MinHeight",
        20,
        "MaxWidth",
        20,
        "MaxHeight",
        20,
        "UseClipBox",
        false,
        "ImageFit",
        "stretch",
        "ImageColor",
        RGBA(195, 189, 172, 255)
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if self:IsSelected() then
          local dlg = GetDialog(self)
          if IsKindOfClasses(dlg, "XSatelliteDialog", "SatelliteConflictClass") then
            local sector = self:GetContext().CurrentSector
            SatelliteSetCameraDest(sector)
          elseif IsKindOf(dlg, "IModeCommonUnitControl") then
            SnapCameraToObj(Selection[1])
          end
          return "break"
        end
        XButton.OnMouseButtonDown(self, pos, button)
        return "break"
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonUp(self, pos, button)",
      "func",
      function(self, pos, button)
        XButton.OnMouseButtonUp(self, pos, button)
        return "break"
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "ApplySelection(self)",
      "func",
      function(self)
        if self:IsSelected() then
          self.idSelectionFrame:SetVisible(true)
          self.idImageFrame:SetBackground(RGB(195, 189, 172))
          self.idImage:SetImageColor(RGB(65, 130, 158))
        else
          self.idSelectionFrame:SetVisible(false)
          self.idImageFrame:SetBackground(RGB(65, 130, 158))
          self.idImage:SetImageColor(RGB(195, 189, 172))
        end
      end
    })
  })
})
