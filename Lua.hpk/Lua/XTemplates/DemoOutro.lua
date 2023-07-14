PlaceObj("XTemplate", {
  group = "Comic",
  id = "DemoOutro",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "ZOrder",
    10,
    "Background",
    RGBA(0, 0, 0, 255),
    "FadeOutTime",
    200,
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateLayer", {
      "layer",
      "XPauseLayer"
    }),
    PlaceObj("XTemplateLayer", {
      "layer",
      "XCameraLockLayer"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XAspectWindow",
      "Id",
      "idContent"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if RealTime() - self.openedAt < 500 then
          return "break"
        end
        if 500 > RealTime() - terminal.activate_time then
          return "break"
        end
        if not self.idSkipHint:GetVisible() then
          self.idSkipHint:SetVisible(true)
          return "break"
        end
        if shortcut ~= "Escape" and shortcut ~= "ButtonB" and shortcut ~= "MouseL" then
          return
        end
        IntroOnBtnClicked(self)
        return "break"
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown",
      "func",
      function(self, ...)
        if RealTime() - self.openedAt < 500 then
          return "break"
        end
        if 500 > RealTime() - terminal.activate_time then
          return "break"
        end
        if not self.idSkipHint:GetVisible() then
          self.idSkipHint:SetVisible(true)
          return "break"
        end
        IntroOnBtnClicked(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnXButtonDown",
      "func",
      function(self, ...)
        if RealTime() - self.openedAt < 500 then
          return "break"
        end
        if not self.idSkipHint:GetVisible() then
          self.idSkipHint:SetVisible(true)
          return "break"
        end
        return IntroOnBtnClicked(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDialog.Open(self, ...)
        IntroOnOpen(self)
        rawset(self, "openedAt", RealTime())
        if GetUIStyleGamepad(nil, self) then
          self.idSkipHint:SetText(T(576896503712, "<ButtonB> Skip"))
        else
          self.idSkipHint:SetText(T(696052205292, "<style SkipHint>Escape: Skip</style>"))
        end
        self:SetModal()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close(self, ...)",
      "func",
      function(self, ...)
        local playing_sounds = rawget(self, "playing_sounds")
        for voice, handle in pairs(playing_sounds) do
          StopSound(handle)
        end
        return XDialog.Close(self, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XVideo",
      "Id",
      "idVideoPlayer",
      "VideoDefId",
      "HotDiamondsDemoOutro",
      "Sound",
      "Sounds/movies/HotDiamondsDemoOutro",
      "AutoPlay",
      true
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "OnEnd(self)",
        "func",
        function(self)
          self.parent:Close()
        end
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "TEXT",
      "Margins",
      box(0, 0, 0, 100),
      "MarginPolicy",
      "FitInSafeArea",
      "HAlign",
      "center",
      "VAlign",
      "bottom",
      "MaxWidth",
      1200,
      "FadeInTime",
      300,
      "FadeOutTime",
      300,
      "TextStyle",
      "OutroComicSubtitles",
      "Translate",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idSkipHint",
      "Margins",
      box(0, 0, 50, 40),
      "HAlign",
      "right",
      "VAlign",
      "bottom",
      "Visible",
      false,
      "DrawOnTop",
      true,
      "HandleMouse",
      false,
      "TextStyle",
      "SkipHint",
      "Translate",
      true
    })
  })
})
