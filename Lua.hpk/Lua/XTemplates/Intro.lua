PlaceObj("XTemplate", {
  group = "Comic",
  id = "Intro",
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
      "VirtualCursorManager",
      "Reason",
      "IntroScene",
      "ActionType",
      false
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
      "HotDiamondsIntro",
      "Sound",
      "Sounds/movies/HotDiamondsIntro",
      "AutoPlay",
      true
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "OnEnd(self)",
        "func",
        function(self)
          self.parent:Close()
          Msg("IntroClosed")
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
    }),
    PlaceObj("XTemplateThread", {
      "comment",
      "subtitles thread",
      "thread_name",
      "subtitles"
    }, {
      PlaceObj("XTemplateVoice", {
        "TimeBefore",
        10800,
        "TimeAfter",
        300,
        "Actor",
        "narrator",
        "Text",
        T(657833848133, "This is <em>Emma LaFontaine</em>. Thank you for agreeing to help me find my father. I don't have much time to talk. I've been told it's no longer safe for me here, so I'm preparing to leave.")
      }),
      PlaceObj("XTemplateVoice", {
        "TimeAfter",
        500,
        "Actor",
        "narrator",
        "Text",
        T(843574394357, "I can't believe a city that only a few months ago was filled with joy and hope is now a place of fear and suspicion, but perhaps that tells you just how important <em>my father</em> is to this country.")
      }),
      PlaceObj("XTemplateVoice", {
        "TimeAfter",
        500,
        "Actor",
        "narrator",
        "Text",
        T(273524094323, "You see, <em>Alphonse LaFontaine</em> is much more than just the <em>president</em> - he is the symbol of my people's faith in a brighter future for Grand Chien. Since his abduction, that faith has been shaken. ")
      }),
      PlaceObj("XTemplateVoice", {
        "TimeAfter",
        500,
        "Actor",
        "narrator",
        "Text",
        T(882784467984, "Things like law and justice are fragile concepts here and the political enemies my father made are already calling for emergency powers to be invoked. I don't know if they are behind the kidnapping, but I am sure they are planning to take advantage of it. ")
      }),
      PlaceObj("XTemplateVoice", {
        "TimeAfter",
        500,
        "Actor",
        "narrator",
        "Text",
        T(980617204308, "The person who took my father calls himself <em>the Major</em>. I haven't been able to find out who he really is, but everyone knows what he wants. He has demanded the entire Adjani River Valley be given to him.")
      }),
      PlaceObj("XTemplateVoice", {
        "TimeAfter",
        500,
        "Actor",
        "narrator",
        "Text",
        T(170466064841, "His followers, who call themselves the <em>Legion</em>, have already seized most of it, but he has vowed to execute my father should the government attempt to intervene.")
      }),
      PlaceObj("XTemplateVoice", {
        "TimeAfter",
        500,
        "Actor",
        "narrator",
        "Text",
        T(243290865030, "I've wired the money you requested. Please, assemble your team and come meet me on <em>Ernie Island</em> at <em>Corazon Santiago's</em> villa. She is the <em>Adonis</em> representative I told you about in my email - her diamond mining operations can help with additional funding should you need it.")
      }),
      PlaceObj("XTemplateVoice", {
        "TimeAfter",
        1000,
        "Actor",
        "narrator",
        "Text",
        T(707093581147, [[
My car is here. I have to go.
I'll have more details for you when we meet.]])
      })
    })
  })
})
