PlaceObj("XTemplate", {
  __is_kind_of = "HUDMercClass",
  group = "Zulu",
  id = "HUDMerc",
  PlaceObj("XTemplateWindow", {
    "__class",
    "HUDMercClass",
    "RolloverTemplate",
    "PDAMercRollover",
    "RolloverAnchor",
    "right",
    "RolloverAnchorId",
    "idContent",
    "RolloverText",
    T(952760179338, "<placeholder>"),
    "Margins",
    box(-8, 7, 0, 0),
    "HAlign",
    "left",
    "VAlign",
    "top",
    "LayoutMethod",
    "HList",
    "UseClipBox",
    false,
    "BorderColor",
    RGBA(255, 255, 255, 0),
    "Background",
    RGBA(255, 255, 255, 0),
    "ChildrenHandleMouse",
    true,
    "FocusedBorderColor",
    RGBA(255, 255, 255, 0),
    "FocusedBackground",
    RGBA(255, 255, 255, 0),
    "DisabledBorderColor",
    RGBA(255, 255, 255, 0),
    "RolloverBackground",
    RGBA(255, 255, 255, 0),
    "PressedBackground",
    RGBA(255, 255, 255, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextFrame",
      "Id",
      "idContent",
      "IdNode",
      false,
      "MinHeight",
      103,
      "Background",
      RGBA(230, 222, 203, 255),
      "BackgroundRectGlowSize",
      1,
      "BackgroundRectGlowColor",
      RGBA(230, 222, 203, 255),
      "FrameBox",
      box(5, 5, 5, 5)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idPortraitBG",
        "IdNode",
        false,
        "Margins",
        box(5, 5, 5, 0),
        "Dock",
        "top",
        "VAlign",
        "top",
        "Image",
        "UI/Hud/portrait_background",
        "ImageFit",
        "stretch"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "UIEffectModifierId",
          "Default",
          "Id",
          "idPortrait",
          "IdNode",
          false,
          "ZOrder",
          2,
          "Margins",
          box(0, -10, 0, 0),
          "MaxHeight",
          85,
          "ImageFit",
          "height",
          "ImageRect",
          box(36, 0, 264, 246)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idSkull",
            "Margins",
            box(0, 0, 2, 8),
            "HAlign",
            "right",
            "VAlign",
            "bottom",
            "Visible",
            false,
            "Image",
            "UI/Hud/dead_merc",
            "ImageScale",
            point(600, 600)
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "HealthBar",
          "Id",
          "idBar",
          "BorderWidth",
          1,
          "HAlign",
          "left",
          "VAlign",
          "bottom",
          "MinWidth",
          80,
          "MinHeight",
          9,
          "MaxWidth",
          80,
          "MaxHeight",
          9,
          "FoldWhenHidden",
          true,
          "DrawOnTop",
          true,
          "Background",
          RGBA(42, 43, 47, 255),
          "DisabledBackground",
          RGBA(42, 43, 47, 255),
          "Image",
          "UI/Hud/ap_bar_pad",
          "Progress",
          {0, 0},
          "DisplayTempHp",
          true,
          "FitSegments",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idClass",
          "Margins",
          box(0, 0, 0, 9),
          "VAlign",
          "bottom",
          "Visible",
          false,
          "DrawOnTop",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "Padding",
            box(2, 2, 2, 2),
            "HAlign",
            "left",
            "VAlign",
            "bottom",
            "MinWidth",
            24,
            "MinHeight",
            24,
            "MaxWidth",
            24,
            "MaxHeight",
            24,
            "Background",
            RGBA(32, 35, 47, 255),
            "BackgroundRectGlowColor",
            RGBA(32, 35, 47, 255)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Id",
              "idClassIcon",
              "Image",
              "UI/Icons/st_marksmanship",
              "ImageFit",
              "stretch",
              "ImageColor",
              RGBA(130, 128, 120, 255)
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return context.session_id
          end,
          "__class",
          "XContextWindow",
          "Id",
          "idStatGain",
          "IdNode",
          true,
          "Margins",
          box(0, 0, 0, 9),
          "VAlign",
          "bottom",
          "DrawOnTop",
          true,
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            UpdateStatGainVisualization(self, context)
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "HAlign",
            "left",
            "VAlign",
            "bottom",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "Padding",
              box(2, 2, 2, 2),
              "HAlign",
              "right",
              "VAlign",
              "bottom",
              "MinWidth",
              24,
              "MinHeight",
              24,
              "MaxWidth",
              24,
              "MaxHeight",
              24,
              "Background",
              RGBA(230, 222, 202, 255),
              "BackgroundRectGlowColor",
              RGBA(230, 222, 202, 255)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idStatIcon",
                "Image",
                "UI/Icons/st_marksmanship",
                "ImageFit",
                "stretch",
                "ImageColor",
                RGBA(32, 35, 47, 255)
              })
            }),
            PlaceObj("XTemplateWindow", {
              "HAlign",
              "right",
              "VAlign",
              "bottom",
              "MinWidth",
              24,
              "MinHeight",
              24,
              "MaxHeight",
              24,
              "Background",
              RGBA(230, 222, 202, 255),
              "BackgroundRectGlowColor",
              RGBA(230, 222, 202, 255)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idStatCount",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "FoldWhenHidden",
                true,
                "TextStyle",
                "HUDHeaderDarkSmall",
                "ContextUpdateOnOpen",
                true,
                "Text",
                "+3"
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "level up indicator",
          "__class",
          "XContextWindow",
          "RolloverTemplate",
          "RolloverGeneric",
          "RolloverAnchor",
          "right",
          "RolloverAnchorId",
          "idContent",
          "RolloverText",
          T(742027784972, "Choose a level-up perk"),
          "RolloverOffset",
          box(30, 0, 0, 0),
          "RolloverTitle",
          T(846149633796, "Level up"),
          "Id",
          "idLevelUp",
          "IdNode",
          true,
          "Margins",
          box(0, 0, 3, 0),
          "HAlign",
          "right",
          "VAlign",
          "top",
          "FoldWhenHidden",
          true,
          "DrawOnTop",
          true,
          "MouseCursor",
          "UI/Cursors/Pda_Hand.tga",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local haveLevelUp = context.perkPoints and context.perkPoints > 0
            local enabled = self:ResolveId("node").LevelUpIndicator
            if not enabled then
              haveLevelUp = false
            end
            if IsKindOfClasses(context, "Unit", "UnitData") and context:IsDead() then
              haveLevelUp = false
            end
            local animationId = haveLevelUp and context.session_id .. "levelup"
            local levelUpAnimationWasShown = WasAnimationShown(animationId)
            if animationId and haveLevelUp ~= levelUpAnimationWasShown then
              if haveLevelUp and not levelUpAnimationWasShown then
                local time = 500
                AnimationWasShown(animationId)
                local interpData = {
                  id = "shrink",
                  type = const.intRect,
                  duration = time,
                  originalRect = sizebox(0, 0, 1000, 1000),
                  targetRect = sizebox(0, 0, 1300, 1300),
                  on_complete = function()
                    self:OnContextUpdate(context)
                  end,
                  flags = const.intfInverse,
                  OnLayoutComplete = IntRectCenterRelative
                }
                self:AddInterpolation(interpData)
                self:SetVisible(true)
                self:SetTransparency(180)
                self:SetTransparency(0, time)
                return
              else
                AnimationShownReset(animationId)
              end
            end
            self:SetVisible(haveLevelUp)
            local havePulseAnim = not not self:GetThread("pulse-anim")
            if haveLevelUp ~= havePulseAnim then
              if haveLevelUp and not havePulseAnim then
                local stateChangeTime = 500
                local interpData = {
                  id = "pulse",
                  type = const.intRect,
                  duration = stateChangeTime * 2,
                  originalRect = sizebox(0, 0, 1100, 1100),
                  targetRect = sizebox(0, 0, 1000, 1000),
                  flags = const.intfInverse + const.intfPingPong + const.intfLooping,
                  start = 0,
                  OnLayoutComplete = IntRectCenterRelative
                }
                self:AddInterpolation(interpData)
                self:CreateThread("pulse-anim", function()
                  while self.window_state ~= "destroying" do
                    local column = GetPreciseTicks() / stateChangeTime % 2
                    self.idImage:SetColumn(column == 0 and 1 or 2)
                    Sleep(stateChangeTime)
                  end
                end)
              else
                self:RemoveModifier("pulse")
                self:DeleteThread("pulse-anim")
              end
            end
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idImage",
            "IdNode",
            false,
            "HandleMouse",
            true,
            "Image",
            "UI/Hud/hud_level_up",
            "Columns",
            2
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "OnMouseButtonDown(self, pos, button)",
              "func",
              function(self, pos, button)
                local node = self:ResolveId("node")
                OpenCharacterScreen(node.context, "perks")
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetRollover(self, rollover)",
              "func",
              function(self, rollover)
                XImage.OnSetRollover(self, rollover)
                self:SetMouseCursor(gv_SatelliteView and "UI/Cursors/Pda_Hand.tga" or "UI/Cursors/Hand.tga")
              end
            })
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "__condition",
        function(parent, context)
          return IsKindOf(context, "UnitProperties") and context.team and context.team.control == "UI" or gv_Squads[context.Squad] and gv_Squads[context.Squad].Side == "player1"
        end,
        "__template",
        "CoOpOtherPlayerMark",
        "Dock",
        "ignore",
        "HAlign",
        "left",
        "VAlign",
        "top",
        "Background",
        RGBA(32, 35, 47, 255),
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          self:SetVisible(IsCoOpGame() and context.ControlledBy ~= netUniqueId)
        end
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "SetEnabled(self, enabled)",
          "func",
          function(self, enabled)
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "UpdateLayout(self)",
          "func",
          function(self)
            local node = self:ResolveId("node")
            local portraitBg = node.idPortraitBG
            local b = portraitBg.box
            self:SetBox(b:minx(), b:miny(), self.measure_width, self.measure_width)
            XImage.UpdateLayout(self)
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idBottomBar",
        "Margins",
        box(0, -10, 0, 0),
        "Dock",
        "bottom",
        "VAlign",
        "bottom",
        "MinHeight",
        10,
        "MaxHeight",
        10,
        "Visible",
        false,
        "FoldWhenHidden",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "Margins",
          box(0, 0, 0, -5),
          "Image",
          "UI/PDA/os_portrait_selection_bottom",
          "FrameBox",
          box(5, 1, 5, 5),
          "SqueezeX",
          false,
          "SqueezeY",
          false
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idBottomPart",
        "Margins",
        box(5, 0, 5, 0),
        "Dock",
        "top",
        "VAlign",
        "bottom",
        "MinHeight",
        21,
        "LayoutMethod",
        "VList",
        "BackgroundRectGlowSize",
        1,
        "BackgroundRectGlowColor",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(2, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "MinWidth",
          78,
          "MaxWidth",
          78
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idName",
            "Margins",
            box(2, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "center",
            "MinWidth",
            78,
            "MaxWidth",
            78,
            "Clip",
            false,
            "UseClipBox",
            false,
            "HandleMouse",
            false,
            "ChildrenHandleMouse",
            false,
            "TextStyle",
            "PDAMercNameCard_Light",
            "Translate",
            true,
            "Text",
            T(512369062263, "<DisplayName>"),
            "WordWrap",
            false,
            "TextVAlign",
            "bottom"
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return "attached_talking_head"
            end,
            "__class",
            "XContextImage",
            "Id",
            "idRadioAnim",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Visible",
            false,
            "Image",
            "UI/Hud/radio_call_small",
            "Rows",
            3,
            "Columns",
            6,
            "Animate",
            true,
            "FPS",
            15,
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local node = self:ResolveId("node")
              local merc = node.context
              merc = merc and merc.session_id
              local haveTh = false
              local playingNow = g_TalkingHeadQueue and g_TalkingHeadQueue[1]
              local haveTh = playingNow and type(playingNow.CustomLogic) == "table" and rawget(playingNow.CustomLogic, "merc_id") == merc
              haveTh = haveTh and (#g_ActiveBanters == 0 or not playingNow.SuppressAll)
              self:SetVisible(haveTh)
              node.idName:SetVisible(not haveTh)
            end
          })
        })
      })
    })
  })
})
