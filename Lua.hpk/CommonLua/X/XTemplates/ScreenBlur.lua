PlaceObj("XTemplate", {
  __is_kind_of = "XLayer",
  group = "Layers",
  id = "ScreenBlur",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XLayer",
    "ZOrder",
    0
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XLayer.Open(self, ...)
        table.change(hr, "BackgroundBlur", {EnablePostProcScreenBlur = 50, MotionVectorJitterPhaseCountBase = 0})
        table.discard_restore(hr, "Savegame_BackgroundBlur")
        hr.EnablePostProcVignette = 1
        SetSceneParamColor(1, "VignetteTintColor", RGBA(0, 0, 0, 0), 0, 0)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        XLayer.Close(self, ...)
        table.restore(hr, "BackgroundBlur")
        table.discard_restore(hr, "Savegame_BackgroundBlur")
        hr.EnablePostProcVignette = EngineOptions.Vignette == "On" and 1 or 0
        local lightmodel = CurrentLightmodel and CurrentLightmodel[1]
        if lightmodel then
          SetSceneParamColor(1, "VignetteTintColor", lightmodel.vignette_tint_color, 0, 0)
        end
      end
    })
  })
})
