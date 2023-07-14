PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Common",
  id = "InGameMenu",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {"__class", "XDialog"}, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XHideDialogs"
    }),
    PlaceObj("XTemplateLayer", {
      "layer",
      "XCameraLockLayer"
    }),
    PlaceObj("XTemplateLayer", {
      "layer",
      "XPauseLayer"
    }),
    PlaceObj("XTemplateLayer", {"layer", "ScreenBlur"}),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idClose",
      "ActionName",
      T(374427918878, "Close"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnActionEffect",
      "close"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete",
      "func",
      function(self, ...)
        Msg("InGameMenuClose")
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate"
    }, {
      PlaceObj("XTemplateMode", nil, {
        PlaceObj("XTemplateTemplate", {"__template", "IGMain"})
      }),
      PlaceObj("XTemplateMode", {"mode", "Options"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "OptionsDialog"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "Load"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "SaveLoadGameDialog"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "Save"}, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "SaveLoadGameDialog",
          "InitialMode",
          "save"
        })
      })
    })
  })
})
