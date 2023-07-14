PlaceObj("XTemplate", {
  group = "Zulu",
  id = "SatelliteSectorSelection",
  PlaceObj("XTemplateWindow", {
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if not IsEditorActive() then
          local sector = g_SatelliteUI:GetMouseTarget(pos)
          if IsKindOf(sector, "SectorWindow") then
            sector = sector.context
          else
            return
          end
          local shift = terminal.IsKeyPressed(const.vkShift)
          if shift then
            table.insert_unique(g_SelectedSatelliteSectors, sector)
          end
          SelectEditorSatelliteSector(shift and g_SelectedSatelliteSectors or {sector})
          UpdateGedSatelliteSectorEditorSel()
        end
      end
    })
  })
})
