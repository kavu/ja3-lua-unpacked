PlaceObj("XTemplate", {
  group = "Zulu",
  id = "SplashScreenLoading",
  PlaceObj("XTemplateWindow", {"__class", "XDialog"}, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self, ...)",
      "func",
      function(self, ...)
        local context = self.context
        local fadeInTime, fadeOutTime, time = context.FadeInTime, context.FadeOutTime, context.Time
        local texts = self.idTexts
        texts.FadeInTime = fadeInTime
        texts.FadeOutTime = fadeOutTime
        XDialog.Open(self, ...)
        self:CreateThread("wait", function()
          if 0 < fadeInTime then
            Sleep(fadeInTime)
          end
          if 0 < time then
            Sleep(time)
          end
          texts:Close()
          if 0 < fadeOutTime then
            Sleep(fadeOutTime)
          end
          self:Close()
        end)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XAspectWindow",
      "MarginPolicy",
      "FitInSafeArea"
    }, {
      PlaceObj("XTemplateWindow", {"Id", "idTexts"}, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Dock",
          "box",
          "Image",
          "UI/LoadingScreens/LoadingScreen",
          "ImageFit",
          "stretch"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(0, 0, 0, 25),
          "MarginPolicy",
          "FitInSafeArea",
          "Dock",
          "bottom",
          "HAlign",
          "center",
          "HandleKeyboard",
          false,
          "HandleMouse",
          false,
          "TextStyle",
          "SplashScreenTexts",
          "Translate",
          true,
          "Text",
          T(100808972372, "<text>"),
          "TextHAlign",
          "center"
        })
      })
    })
  })
})
