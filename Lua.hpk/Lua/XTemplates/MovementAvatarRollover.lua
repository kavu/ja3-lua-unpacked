PlaceObj("XTemplate", {
  group = "Zulu Rollover",
  id = "MovementAvatarRollover",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPopup",
    "Margins",
    box(0, 0, 0, 4),
    "HAlign",
    "left",
    "VAlign",
    "top",
    "OnLayoutComplete",
    function(self)
      if CheatEnabled("CombatUIHidden") then
        self:SetVisible(false)
      end
    end,
    "UseClipBox",
    false,
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(0, 0, 0, 0),
    "HandleKeyboard",
    false,
    "HandleMouse",
    false,
    "ChildrenHandleMouse",
    false,
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "AnchorType",
    "center-top"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "IdMovementRollover",
      "Padding",
      box(6, 6, 6, 6),
      "MinWidth",
      356,
      "LayoutMethod",
      "VList",
      "UseClipBox",
      false,
      "Background",
      RGBA(52, 55, 61, 255),
      "BackgroundRectGlowSize",
      2,
      "BackgroundRectGlowColor",
      RGBA(32, 35, 47, 255),
      "OnContextUpdate",
      function(self, context, ...)
        local diag = GetDialog(self)
        local attacker = diag.attacker
        local upArrow = self:ResolveId("idShortcutTextUp")
        local downArrow = self:ResolveId("idShortcutTextDown")
        local lIsStanceArrowEnabled = function(stance, stanceFrom)
          stanceFrom = stanceFrom or diag.targeting_blackboard.fxToDoStance or attacker.stance
          return attacker:CanSwitchStance(stance, {
            goto_pos = diag.targeting_blackboard.movement_avatar:GetPos(),
            stance_override = stanceFrom
          })
        end
        if not diag.targeting_blackboard or not diag.targeting_blackboard.movement_avatar then
          return
        end
        local upEnabled = false
        local downEnabled = false
        if diag.targeting_blackboard.fxToDoStance == "Crouch" then
          upEnabled = lIsStanceArrowEnabled("Standing")
          downEnabled = lIsStanceArrowEnabled("Prone")
        elseif diag.targeting_blackboard.fxToDoStance == "Prone" then
          upEnabled = lIsStanceArrowEnabled("Crouch")
        elseif diag.targeting_blackboard.fxToDoStance == "Standing" then
          downEnabled = lIsStanceArrowEnabled("Crouch")
        end
        local stanceSwitchTo = diag.targeting_blackboard.playerToDoStanceAtEnd
        if stanceSwitchTo and not lIsStanceArrowEnabled(stanceSwitchTo, attacker.stance) then
          diag.targeting_blackboard.playerToDoStanceAtEnd = false
        end
        upArrow:SetEnabled(upEnabled)
        if upEnabled then
          upArrow:SetText(T(690412711903, "<style PDARolloverText>[<ShortcutButton('MovementEndStanceUp')>]</style> Stance Up"))
        else
          upArrow:SetText(T(818856739630, "[<ShortcutButton('MovementEndStanceUp')>] Stance Up"))
        end
        diag.targeting_blackboard.idUpArrow = upEnabled
        downArrow:SetEnabled(downEnabled)
        if downEnabled then
          downArrow:SetText(T(166589553846, "<style PDARolloverText>[<ShortcutButton('MovementEndStanceDown')>]</style> Stance Down"))
        else
          downArrow:SetText(T(999723382293, "[<ShortcutButton('MovementEndStanceDown')>] Stance Down"))
        end
        diag.targeting_blackboard.idDownArrow = downEnabled
        local keepStanceText = self:ResolveId("idShortcutKeepStance")
        local keepStanceState = GetKeepStanceOption(attacker)
        if GetKeepStanceOption(attacker) then
          local currentStance = CombatActions["Stance" .. attacker.stance]
          local stanceName = currentStance and currentStance.DisplayNameShort
          keepStanceText:SetText(T({
            595461566177,
            "<style PDARolloverText>[<ShortcutButton('MovementKeepStance')>]</style> Locked: Moving <stanceName>",
            stanceName = stanceName
          }))
        else
          keepStanceText:SetText(T(168497089793, "<style PDARolloverText>[<ShortcutButton('MovementKeepStance')>]</style> Lock Movement Stance"))
        end
        local hasCover = false
        local coverData = diag.targeting_blackboard.movement_avatar_cover
        if coverData then
          local highestCover = false
          for angle, level in pairs(coverData) do
            highestCover = Max(highestCover, level)
          end
          local icon = highestCover == 2 and "UI/Hud/iw_cover_full" or "UI/Hud/iw_cover_half"
          local text = highestCover == 2 and T(583683921072, "HIGH COVER") or T(514053697312, "LOW COVER")
          self.idCover.idIcon:SetImage(icon)
          self.idCover.idRightLabel:SetText(text)
          hasCover = true
        end
        hasCover = false
        self.idCover:SetVisible(hasCover and g_RolloverShowMoreInfo)
        local currentStance = attacker.stance
        local targetStance = diag.targeting_blackboard.fxToDoStance or ""
        local targetStanceAction = CombatActions["Stance" .. targetStance]
        local showStanceInfo = false
        if currentStance ~= targetStance and targetStanceAction then
          local attackerTable = {attacker}
          self.idStanceChange.idIcon:SetImage(targetStanceAction:GetActionIcon(attackerTable))
          self.idStanceChange.idRightLabel:SetText(targetStanceAction.DisplayNameShort)
          self.idStanceChange.idText:SetText(targetStanceAction:GetActionDescription(attackerTable))
          showStanceInfo = true
        end
        showStanceInfo = false
        self.idStanceChange:SetVisible(showStanceInfo and g_RolloverShowMoreInfo)
        local moreInfoShown = hasCover or showStanceInfo
        if moreInfoShown and diag.targeting_blackboard.movement_mode then
          g_RolloverShowMoreInfoFakeRollover = true
        else
          g_RolloverShowMoreInfoFakeRollover = false
        end
        self.idMoreInfo:SetVisible(moreInfoShown, "hasInfo")
        self:SetVisible(not RolloverWin)
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "rollover observer",
        "__context",
        function(parent, context)
          return "RolloverWin"
        end,
        "__class",
        "XContextWindow",
        "OnContextUpdate",
        function(self, context, ...)
          self.parent:OnContextUpdate(self.parent.context)
        end
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "more info observer",
        "__context",
        function(parent, context)
          return "g_RolloverShowMoreInfo"
        end,
        "__class",
        "XContextWindow",
        "OnContextUpdate",
        function(self, context, ...)
          self.parent:OnContextUpdate(self.parent.context)
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "Open(self)",
        "func",
        function(self)
          XContextControl.Open(self)
          local control = self.context.control
          local offset = control and control:GetRolloverOffset()
          if offset and offset ~= box(0, 0, 0, 0) then
            self.parent:SetMargins(self.parent.Margins + offset)
          end
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "OnDelete(self)",
        "func",
        function(self)
          g_RolloverShowMoreInfoFakeRollover = false
        end
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "container that enforces size",
        "Margins",
        box(0, -6, 0, 0),
        "MinWidth",
        330,
        "MaxWidth",
        330,
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "Id",
          "idStanceChange",
          "IdNode",
          true,
          "Margins",
          box(0, 6, 0, 0),
          "FoldWhenHidden",
          true,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 5, 0, 0),
            "Padding",
            box(6, 4, 6, 6),
            "LayoutMethod",
            "VList",
            "UseClipBox",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 0, 0, 3),
              "LayoutMethod",
              "HList",
              "UseClipBox",
              false
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextImage",
                "Id",
                "idIcon",
                "HAlign",
                "left",
                "VAlign",
                "top",
                "MinWidth",
                30,
                "MinHeight",
                30,
                "MaxWidth",
                30,
                "MaxHeight",
                30,
                "ImageFit",
                "stretch"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idLabel",
                "Margins",
                box(10, 0, 0, 0),
                "HAlign",
                "left",
                "VAlign",
                "center",
                "Clip",
                false,
                "UseClipBox",
                false,
                "TextStyle",
                "UIDlgTitle",
                "Translate",
                true,
                "Text",
                T(672642461625, "STANCE")
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idRightLabel",
                "Dock",
                "right",
                "HAlign",
                "right",
                "VAlign",
                "center",
                "Clip",
                false,
                "UseClipBox",
                false,
                "TextStyle",
                "PDABrowserSubtitleLight",
                "Translate",
                true
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idText",
              "HAlign",
              "left",
              "VAlign",
              "top",
              "MinWidth",
              330,
              "UseClipBox",
              false,
              "TextStyle",
              "PDARolloverText",
              "Translate",
              true,
              "Text",
              T(406455992177, "Take less damage from attacks from the side of the cover.")
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idCover",
          "IdNode",
          true,
          "Margins",
          box(0, 6, 0, 0),
          "FoldWhenHidden",
          true,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "Margins",
            box(0, 5, 0, 0),
            "Padding",
            box(6, 4, 6, 6),
            "LayoutMethod",
            "VList",
            "UseClipBox",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(0, 0, 0, 3),
              "LayoutMethod",
              "HList",
              "UseClipBox",
              false
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextImage",
                "Id",
                "idIcon",
                "HAlign",
                "left",
                "VAlign",
                "top",
                "MinWidth",
                30,
                "MinHeight",
                30,
                "MaxWidth",
                30,
                "MaxHeight",
                30,
                "UseClipBox",
                false,
                "ImageFit",
                "stretch"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idLabel",
                "Margins",
                box(10, 0, 0, 0),
                "HAlign",
                "left",
                "VAlign",
                "center",
                "Clip",
                false,
                "UseClipBox",
                false,
                "TextStyle",
                "UIDlgTitle",
                "Translate",
                true,
                "Text",
                T(445719955623, "COVER")
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idRightLabel",
                "Dock",
                "right",
                "HAlign",
                "right",
                "VAlign",
                "center",
                "Clip",
                false,
                "UseClipBox",
                false,
                "TextStyle",
                "PDABrowserSubtitleLight",
                "Translate",
                true
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idText",
              "HAlign",
              "left",
              "VAlign",
              "top",
              "MinWidth",
              330,
              "UseClipBox",
              false,
              "TextStyle",
              "PDARolloverText",
              "Translate",
              true,
              "Text",
              T(406455992177, "Take less damage from attacks from the side of the cover.")
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idParent",
          "Margins",
          box(0, 6, 0, 0),
          "MinWidth",
          330,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "Padding",
            box(6, 4, 6, 6),
            "LayoutMethod",
            "VList",
            "UseClipBox",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idShortcutTextUp",
              "HAlign",
              "left",
              "UseClipBox",
              false,
              "TextStyle",
              "SatelliteContextMenuKeybind",
              "Translate",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idShortcutTextDown",
              "HAlign",
              "left",
              "UseClipBox",
              false,
              "TextStyle",
              "SatelliteContextMenuKeybind",
              "Translate",
              true
            }),
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return "keep_stance_changed"
              end,
              "__class",
              "XText",
              "Id",
              "idShortcutKeepStance",
              "HAlign",
              "left",
              "UseClipBox",
              false,
              "TextStyle",
              "SatelliteContextMenuKeybind",
              "Translate",
              true
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(5, 3, 0, -2),
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateTemplate", {"__template", "MoreInfo"}),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "gamePadInputHints",
            "Padding",
            box(2, 5, 2, 4),
            "FoldWhenHidden",
            true,
            "TextStyle",
            "SatelliteContextMenuKeybind",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              self:SetVisible(GetUIStyleGamepad())
              local a = GetPlatformSpecificImageTag("ButtonA", 650)
              local b = GetPlatformSpecificImageTag("ButtonB", 650)
              self:SetText(T({
                567391043458,
                "<a> Move <b> Exit Movement Mode",
                a = a,
                b = b
              }))
            end,
            "Translate",
            true,
            "WordWrap",
            false
          })
        })
      })
    })
  })
})
