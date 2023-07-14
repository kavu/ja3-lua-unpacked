PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDADialogSatelliteEditor",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "PDADialogSatellite"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        local oldSatView = g_SatelliteUI or false
        rawset(self, "oldSatView", oldSatView)
        Pause("pda-editor", "keepSounds")
        XDialog.Open(self)
        if oldSatView then
          self:CreateThread("sat-ready", function()
            WaitMsg("InitSatelliteView", 5000)
            g_SatelliteUI.OnDelete = empty_func
          end)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close(self)",
      "func",
      function(self)
        Resume("pda-editor")
        XDialog.Close(self)
        local oldSatView = rawget(self, "oldSatView")
        g_SatelliteUI = oldSatView
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "PDACampaignPausingDlg"
    })
  })
})
