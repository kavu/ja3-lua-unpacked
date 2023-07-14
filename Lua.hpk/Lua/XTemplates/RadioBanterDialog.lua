PlaceObj("XTemplate", {
  group = "Zulu",
  id = "RadioBanterDialog",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "ZOrder",
    5,
    "Background",
    RGBA(30, 30, 35, 115),
    "Transparency",
    255
  }, {
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return not GetDialog("PDADialogSatellite")
      end,
      "__class",
      "XBlurRect",
      "BlurRadius",
      10,
      "Desaturation",
      150
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "tint",
      "Background",
      RGBA(52, 55, 61, 44)
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return not GetDialog("PDADialogSatellite")
      end,
      "__class",
      "XMovieBlackBars",
      "Dock",
      "box",
      "HandleKeyboard",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "grid",
        "__class",
        "XImage",
        "Dock",
        "box",
        "Image",
        "UI/Hud/sc_grid",
        "ImageFit",
        "stretch"
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "frame",
        "__class",
        "XImage",
        "UIEffectModifierId",
        "RadioBanter",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "Image",
        "UI/Hud/sc_frame",
        "ImageScale",
        point(750, 750)
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(10, 10, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "top",
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          5
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Image",
            "UI/Hud/T_HUD_ApPoints_Background",
            "ImageColor",
            RGBA(110, 162, 90, 255)
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "Open(self)",
              "func",
              function(self)
                XImage.Open(self)
                self:CreateThread("flash", function()
                  while self.window_state ~= "destroying" do
                    Sleep(500)
                    self:SetVisible(not self.visible)
                  end
                end)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idSatRec",
            "HandleMouse",
            false,
            "ChildrenHandleMouse",
            false,
            "TextStyle",
            "RadioBanterTimer",
            "Translate",
            true,
            "Text",
            T(896666701489, "Sat-Com")
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTimer",
          "Margins",
          box(10, 0, 0, 10),
          "HAlign",
          "left",
          "VAlign",
          "bottom",
          "HandleMouse",
          false,
          "ChildrenHandleMouse",
          false,
          "TextStyle",
          "RadioBanterTimer"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              XText.Open(self)
              local startCampaignTime = Game.CampaignTime or 0
              local startMs = RealTime()
              self:CreateThread("update-timer", function()
                while self.window_state ~= "destroying" do
                  local timePassed = (RealTime() - startMs) / 1000
                  local timerValue = startCampaignTime + timePassed
                  local h = timerValue % 86400 / 3600
                  if h < 10 then
                    h = "0" .. tostring(h)
                  end
                  local m = timerValue % 3600 / 60
                  if m < 10 then
                    m = "0" .. tostring(m)
                  end
                  local s = timerValue % 60
                  if s < 10 then
                    s = "0" .. tostring(s)
                  end
                  self:SetText(tostring(h) .. ":" .. tostring(m) .. ":" .. tostring(s))
                  Sleep(1000)
                end
              end)
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "arrow lower",
          "__class",
          "XImage",
          "Margins",
          box(0, 0, 0, 35),
          "HAlign",
          "center",
          "VAlign",
          "bottom",
          "Image",
          "UI/Hud/sc_tringle"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              XImage.Open(self)
              RadioBanterTriangleAnimation(self)
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "arrow right",
          "__class",
          "XImage",
          "Margins",
          box(0, 0, 135, 0),
          "HAlign",
          "right",
          "VAlign",
          "center",
          "Image",
          "UI/Hud/sc_tringle",
          "Angle",
          16200
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              XImage.Open(self)
              RadioBanterTriangleAnimation(self, true)
            end
          })
        })
      })
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
      "PopupDescriptionTextWhite",
      "Translate",
      true
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XHideDialogs",
      "LeaveDialogIds",
      {
        "PDADialog",
        "TalkingHeadUI",
        "PDADialogSatellite"
      }
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XPauseLayer"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "PDACampaignPausingDlg"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        ZuluModalDialog.Open(self)
        if GetUIStyleGamepad(nil, self) then
          self.idSkipHint:SetText(T(576896503712, "<ButtonB> Skip"))
        else
          self.idSkipHint:SetText(T(696052205292, "<style SkipHint>Escape: Skip</style>"))
        end
        self.openedAt = GameTime()
        self.skipDelay = 250
        cameraTac.SetForceOverview(true)
        self:SetTransparency(0, 700, GetEasingIndex("Quintic out"))
        self:CreateThread(function()
          Sleep(750)
          cameraTac.Rotate(5400, 70000)
        end)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "AnimatedClose(self)",
      "func",
      function(self)
        self:SetTransparency(255, 700, GetEasingIndex("Quintic in"))
        Sleep(700)
        if self.window_state == "destroying" then
          return
        end
        self:Close()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete(self)",
      "func",
      function(self)
        cameraTac.SetForceOverview(false)
        cameraTac.Rotate(0, 0)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if RealTime() - self.openedAt < self.skipDelay then
          return "break"
        end
        if RealTime() - terminal.activate_time < self.skipDelay then
          return "break"
        end
        if shortcut ~= "Escape" and shortcut ~= "ButtonB" and shortcut ~= "MouseL" then
          return
        end
        if not self.idSkipHint:GetVisible() then
          self.idSkipHint:SetVisible(true)
          return "break"
        end
        if not IsRecording() or shortcut == "Escape" then
          if IsValid(self.context) and not self.context:IsFinished() then
            DoneBanter(self.context, "skip")
            self.context = false
          end
          return "break"
        end
      end
    })
  })
})
