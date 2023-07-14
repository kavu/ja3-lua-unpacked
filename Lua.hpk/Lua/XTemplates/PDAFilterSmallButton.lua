PlaceObj("XTemplate", {
  __is_kind_of = "PDASmallButton",
  group = "Zulu Satellite UI",
  id = "PDAFilterSmallButton",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PDASmallButton",
    "RolloverTemplate",
    "RolloverGeneric",
    "RolloverAnchor",
    "left",
    "RolloverText",
    T(904623182115, "Main View"),
    "RolloverOffset",
    box(0, 0, 15, 5),
    "HAlign",
    "right",
    "VAlign",
    "bottom",
    "MinWidth",
    31,
    "MinHeight",
    31,
    "FXPress",
    "SatelliteFilterButton",
    "OnPressParam",
    "default",
    "OnPress",
    function(self, gamepad)
      if not g_SatelliteUI then
        return
      end
      g_SatelliteUI:ToggleFilterMode(self.OnPressParam)
    end,
    "CenterImage",
    "UI/PDA/SatelliteFilters/Default"
  }, {
    PlaceObj("XTemplateWindow", {
      "Id",
      "idDim",
      "Dock",
      "box",
      "Visible",
      false,
      "Background",
      RGBA(0, 0, 0, 255),
      "Transparency",
      180
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        self:SetColumnsUse(selected and "cccca" or "abcca")
        self.idDim:SetVisible(not selected)
      end
    })
  })
})
