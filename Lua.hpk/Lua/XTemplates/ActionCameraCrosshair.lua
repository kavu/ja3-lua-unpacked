PlaceObj("XTemplate", {
  group = "Zulu",
  id = "ActionCameraCrosshair",
  PlaceObj("XTemplateWindow", {
    "__class",
    "CrosshairUI",
    "Id",
    "idAttackCrosshair",
    "IdNode",
    true,
    "HAlign",
    "left",
    "VAlign",
    "top",
    "UseClipBox",
    false,
    "Visible",
    false,
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "crosshair"
      end,
      "__class",
      "XContextWindow",
      "Id",
      "idContainer",
      "LayoutMethod",
      "VList",
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "combat badge for the crosshair",
        "__context",
        function(parent, context)
          return parent.parent.context.target
        end,
        "__class",
        "XContextWindow",
        "IdNode",
        true,
        "Margins",
        box(5, 0, 0, -60),
        "HAlign",
        "center",
        "VAlign",
        "top",
        "LayoutMethod",
        "VList",
        "UseClipBox",
        false,
        "FoldWhenHidden",
        true,
        "DrawOnTop",
        true,
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local iconPath = GetEnemyIcon(IsKindOf(context, "Unit") and context.role or "Default")
          self.idMercIcon:SetImage(iconPath)
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idName",
          "Margins",
          box(0, 0, 0, -2),
          "HAlign",
          "left",
          "Clip",
          false,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "ChildrenHandleMouse",
          false,
          "TextStyle",
          "CrosshairBadgeName",
          "ContextUpdateOnOpen",
          true,
          "Translate",
          true,
          "Text",
          T(972332466585, "<DisplayName>")
        }),
        PlaceObj("XTemplateWindow", {
          "LayoutMethod",
          "HList",
          "LayoutHSpacing",
          3,
          "UseClipBox",
          false
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idMercIcon",
            "HAlign",
            "left",
            "UseClipBox",
            false,
            "FoldWhenHidden",
            true,
            "DrawOnTop",
            true,
            "ChildrenHandleMouse",
            false
          }),
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "VList",
            "UseClipBox",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "target health bar",
              "__class",
              "HealthBar",
              "Id",
              "idBar",
              "BorderWidth",
              1,
              "HAlign",
              "left",
              "VAlign",
              "top",
              "MinWidth",
              100,
              "MinHeight",
              18,
              "MaxHeight",
              18,
              "UseClipBox",
              false,
              "FoldWhenHidden",
              true,
              "BorderColor",
              RGBA(70, 10, 10, 255),
              "Background",
              RGBA(70, 10, 10, 255),
              "Progress",
              {0, 0},
              "DisplayTempHp",
              true,
              "ShowIcons",
              true
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "Open(self)",
                "func",
                function(self)
                  HealthBar.Open(self)
                  self:SetColorPreset("enemy")
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return context.StatusEffects
              end,
              "__condition",
              function(parent, context)
                return IsKindOf(parent:ResolveId("node").context, "StatusEffectObject")
              end,
              "__class",
              "XContentTemplate",
              "Id",
              "idStatusEffectsContainer",
              "IdNode",
              false,
              "Margins",
              box(0, 0, 0, 5),
              "MinHeight",
              40,
              "MaxHeight",
              40,
              "ScaleModifier",
              point(600, 600),
              "UseClipBox",
              false
            }, {
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return parent:ResolveId("node").context
                end,
                "__class",
                "XContextWindow",
                "RolloverTemplate",
                "StatusEffectsRollover",
                "RolloverText",
                T(190650275316, "STATUS EFFECTS"),
                "UseClipBox",
                false
              }, {
                PlaceObj("XTemplateWindow", {
                  "__context",
                  function(parent, context)
                    return context:GetUIVisibleStatusEffects()
                  end,
                  "__class",
                  "XContextWindow",
                  "Id",
                  "idStatusEffects",
                  "HAlign",
                  "left",
                  "LayoutMethod",
                  "HList",
                  "UseClipBox",
                  false
                }, {
                  PlaceObj("XTemplateForEach", {
                    "comment",
                    "status effect",
                    "__context",
                    function(parent, context, item, i, n)
                      return item
                    end
                  }, {
                    PlaceObj("XTemplateTemplate", {
                      "__template",
                      "StatusEffectIcon",
                      "RolloverTemplate",
                      "",
                      "RolloverText",
                      "",
                      "RolloverTitle",
                      "",
                      "ImageScale",
                      point(850, 850)
                    })
                  })
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "__condition",
          function(parent, context)
            return IsKindOf(context, "UnitProperties")
          end,
          "__template",
          "CoOpOtherPlayerMark",
          "Id",
          "idPartner",
          "Dock",
          "ignore",
          "HAlign",
          "left",
          "VAlign",
          "top",
          "Image",
          "UI/Hud/coop_partner_attack",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local aimingAt = IsOtherPlayerActingOnUnit(context, "aim")
            self:SetVisible(aimingAt)
          end
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "UpdateLayout(self)",
            "func",
            function(self)
              local badge = self:ResolveId("node")
              local b = badge.box
              local mercIcon = badge.idMercIcon
              local y = 0
              if mercIcon.visible then
                y = mercIcon.box:miny()
              else
                y = b:miny() - self.measure_width / 2
              end
              self:SetBox(b:minx() - self.measure_width, y, self.measure_width, self.measure_width)
              XImage.UpdateLayout(self)
            end
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idContent",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "UseClipBox",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "outer circle (cosmetic)",
          "__class",
          "XImage",
          "Id",
          "idTarget",
          "IdNode",
          false,
          "HAlign",
          "left",
          "VAlign",
          "top",
          "UseClipBox",
          false,
          "Transparency",
          120,
          "Image",
          "UI/Hud/target_background"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              XImage.Open(self)
              local crosshair = self:ResolveId("node")
              local hasFiringModes = crosshair.context.firingModes
              if hasFiringModes then
                self:SetImage("UI/Hud/target_background_with_firing_modes")
              end
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "aim level display",
          "__class",
          "XContextWindow",
          "IdNode",
          true,
          "HAlign",
          "center",
          "VAlign",
          "center",
          "UseClipBox",
          false,
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local node = self:ResolveId("node")
            local aim = node.aim or 0
            local maxAimTotal = node.maxAimTotal
            local nextAimLevel = node:GetNextAimLevel()
            local aimMaxScale = 560
            local aimMinScale = 200
            local aimScaleDif = aimMaxScale - aimMinScale
            local perLevel = maxAimTotal == 0 and 0 or MulDivRound(aimScaleDif, 1, maxAimTotal)
            if maxAimTotal == 0 or aim == 0 then
            else
            end
            if nextAimLevel == (node.minAimPossible or 0) then
              self.idAimTarget:SetImageColor(RGB(237, 184, 24))
            else
              self.idAimTarget:SetImageColor(RGB(191, 67, 77))
            end
            if aim == maxAimTotal and maxAimTotal == 0 then
              self.idAimTarget:SetImage("UI/Hud/T_HUD_TargetingCircle_Inner")
              self.idAimTarget:SetScaleModifier(point(aimMaxScale, aimMaxScale))
              return
            elseif aim == maxAimTotal then
              self.idAimTarget:SetImage("UI/Hud/target_aim_small")
              self.idAimTarget:SetScaleModifier(point(aimMinScale + perLevel, aimMinScale + perLevel))
              return
            end
            local aimScale = aimMaxScale - aim * perLevel
            if 2 <= aim then
              self.idAimTarget:SetImage("UI/Hud/T_HUD_TargetingCircle_Inner_2")
            else
              self.idAimTarget:SetImage("UI/Hud/T_HUD_TargetingCircle_Inner")
            end
            self.idAimTarget:SetScaleModifier(point(aimScale, aimScale))
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idAimTarget",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "UseClipBox",
            false,
            "Image",
            "UI/Hud/target_aim",
            "ImageColor",
            RGBA(191, 67, 77, 255)
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "body parts",
          "Dock",
          "box",
          "UseClipBox",
          false
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "CrosshairButtonParent",
            "Id",
            "idButtonsContainer",
            "Margins",
            box(0, 0, 15, 0),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "MinWidth",
            260,
            "MinHeight",
            260,
            "MaxWidth",
            260,
            "MaxHeight",
            260,
            "UseClipBox",
            false
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "body part",
              "array",
              function(parent, context)
                return parent:ResolveId("node").context.body_parts
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end,
              "run_after",
              function(child, context, item, i, n, last)
                local crosshair = child:ResolveId("node")
                local crosshairCtx = crosshair.context
                local unitParts = crosshairCtx.body_parts
                local x, y = CalculateCrosshairButtonOffset(n, #unitParts)
                child.circle_offset_x = x
                child.circle_offset_y = y
                local bodyPartId = context.id
                child:SetId("idButton" .. bodyPartId)
              end
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "CrosshairCustomBodyPart",
                "OnContextUpdate",
                function(self, context, ...)
                  local crosshair = self:ResolveId("node")
                  local crosshairCtx = crosshair.context
                  local attacker = crosshairCtx.attacker
                  local action = crosshairCtx.action
                  local weapon = action:GetAttackWeapons(attacker)
                  local bodyPartId = self.context.id
                  self.idBodyImage:SetImage(self.context.Icon)
                  local icon = false
                  local attackResultTable = crosshairCtx.attackResultTable
                  attackResultTable = attackResultTable and attackResultTable[bodyPartId]
                  local errors = GetCrosshairAttackStatusEffects(crosshairCtx, weapon, bodyPartId, action, attackResultTable)
                  if 0 < #errors then
                    local firstError = errors[1]
                    icon = firstError.Icon
                  end
                  if icon then
                    self.idHitIcon:SetImage(icon)
                    self.idHitIcon:SetVisible(true)
                  else
                    self.idHitIcon:SetVisible(false)
                  end
                  local bodyPartHidden = false
                  if not crosshairCtx.canTarget and bodyPartId ~= crosshair.defaultTargetPart.id then
                    bodyPartHidden = true
                  end
                  local cachedResults = crosshair.cached_results
                  cachedResults = cachedResults and cachedResults[crosshairCtx.action.id]
                  cachedResults = cachedResults and cachedResults.attackResultCalc
                  if cachedResults and (cachedResults.BlindFire or cachedResults.InCover) then
                    bodyPartHidden = true
                  end
                  local cursor = crosshair.attack_cursor or "UI/Cursors/Hand.tga"
                  if action.id == "PinDown" and cachedResults and cachedResults[bodyPartId] and not cachedResults[bodyPartId].target_hit then
                    bodyPartHidden = true
                  else
                    self:SetEnabled(true)
                  end
                  self:SetVisible(not bodyPartHidden)
                  self:SetMouseCursor(cursor)
                  self.idLabel:SetVisible(true or GetUIStyleGamepad())
                  self.idLabel:SetText(self.context.display_name)
                end
              })
            }),
            PlaceObj("XTemplateTemplate", {
              "__context",
              function(parent, context)
                return Presets.TargetBodyPart.Default.BlindFire
              end,
              "__template",
              "CrosshairCustomBodyPart",
              "Id",
              "idButtonBlindFire"
            }),
            PlaceObj("XTemplateTemplate", {
              "__context",
              function(parent, context)
                return Presets.TargetBodyPart.Default.InCover
              end,
              "__template",
              "CrosshairCustomBodyPart",
              "Id",
              "idButtonInCover"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "firing modes",
            "__condition",
            function(parent, context)
              return parent:ResolveId("node").context.firingModes
            end,
            "__class",
            "CrosshairButtonParent",
            "Id",
            "idFireModeContainer",
            "Margins",
            box(15, 0, 0, 0),
            "HAlign",
            "center",
            "VAlign",
            "center",
            "MinWidth",
            260,
            "MinHeight",
            260,
            "MaxWidth",
            260,
            "MaxHeight",
            260,
            "UseClipBox",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "firing mode update observer",
              "__context",
              function(parent, context)
                return "firing_mode"
              end,
              "__class",
              "XContextWindow",
              "Margins",
              box(0, 0, 0, -8),
              "HAlign",
              "center",
              "VAlign",
              "bottom",
              "LayoutMethod",
              "HList",
              "UseClipBox",
              false,
              "OnContextUpdate",
              function(self, context, ...)
                for i, m in ipairs(self.parent) do
                  if m ~= self then
                    m:OnContextUpdate(m.context)
                  end
                end
              end
            }),
            PlaceObj("XTemplateTemplate", {
              "__context",
              function(parent, context)
                return {
                  action = parent:ResolveId("node").context.firingModes[1]
                }
              end,
              "__template",
              "CrosshairFiringModeButton"
            }),
            PlaceObj("XTemplateTemplate", {
              "__context",
              function(parent, context)
                return {
                  action = parent:ResolveId("node").context.firingModes[2]
                }
              end,
              "__template",
              "CrosshairFiringModeButton"
            }),
            PlaceObj("XTemplateTemplate", {
              "__context",
              function(parent, context)
                return {
                  action = parent:ResolveId("node").context.firingModes[3]
                }
              end,
              "__template",
              "CrosshairFiringModeButton"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "controller list style hint",
            "__context",
            function(parent, context)
              return "GamepadUIStyleChanged"
            end,
            "__class",
            "XContextWindow",
            "UseClipBox",
            false,
            "Visible",
            false,
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local gamepad = GetUIStyleGamepad()
              local transparencyUnselected = 120
              local crosshair = self:ResolveId("node")
              local list = crosshair.crosshair_gamepad_list
              local fireModeList = crosshair.idFireModeContainer
              local bodyPartList = crosshair.idButtonsContainer
              if list == "firing_modes" then
                if fireModeList then
                  fireModeList:SetTransparency(0)
                end
                bodyPartList:SetTransparency(gamepad and transparencyUnselected or 0)
              elseif list == "body_parts" then
                if fireModeList then
                  fireModeList:SetTransparency(gamepad and transparencyUnselected or 0)
                end
                bodyPartList:SetTransparency(0)
              end
            end
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "bottom ui - ap indicator, range, hints",
          "Margins",
          box(0, 0, 0, -12),
          "HAlign",
          "center",
          "VAlign",
          "bottom",
          "LayoutMethod",
          "VList",
          "LayoutVSpacing",
          5
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "ap indicator",
            "HAlign",
            "center",
            "VAlign",
            "bottom",
            "MinWidth",
            86,
            "UseClipBox",
            false,
            "Background",
            RGBA(32, 35, 47, 180)
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idAPCostText",
              "Margins",
              box(10, 0, 10, 0),
              "Padding",
              box(2, 0, 2, 0),
              "HAlign",
              "center",
              "VAlign",
              "center",
              "Clip",
              false,
              "UseClipBox",
              false,
              "TextStyle",
              "CrosshairAPCost",
              "Translate",
              true,
              "TextVAlign",
              "center"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "range indicator",
            "__context",
            function(parent, context)
              return parent:ResolveId("node").context
            end,
            "__condition",
            function(parent, context)
              return context.action.ActionType == "Ranged Attack"
            end,
            "__class",
            "XContextWindow",
            "Id",
            "idRange",
            "IdNode",
            true,
            "HAlign",
            "center",
            "VAlign",
            "bottom",
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            10,
            "UseClipBox",
            false,
            "FoldWhenHidden",
            true,
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local maxRange = context.weapon_range
              local range = context.attack_distance
              self.idRangeNumber:SetText(tostring(maxRange))
              if range <= maxRange / 2 then
                self.idRangeTriangle:SetImage("UI/Hud/range_0")
                self.idRedBar:SetVisible(false)
                self.idRangeText:SetTextStyle("Crosshair_Range")
                self.idRangeNumber:SetTextStyle("Crosshair_Range")
              elseif maxRange > range then
                self.idRangeTriangle:SetImage("UI/Hud/range_50")
                self.idRedBar:SetVisible(false)
                self.idRangeText:SetTextStyle("Crosshair_Range")
                self.idRangeNumber:SetTextStyle("Crosshair_Range")
              else
                self.idRangeTriangle:SetImage("UI/Hud/range_100")
                self.idRedBar:SetVisible(true)
              end
              self.idRangeBar:InvalidateLayout()
            end
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idRangeText",
              "MinWidth",
              40,
              "Clip",
              false,
              "UseClipBox",
              false,
              "TextStyle",
              "Crosshair_Range",
              "Translate",
              true,
              "Text",
              T(575734781283, "RANGE"),
              "TextHAlign",
              "right"
            }),
            PlaceObj("XTemplateWindow", {
              "Id",
              "idRangeBar",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "MinWidth",
              116,
              "MinHeight",
              6,
              "MaxWidth",
              116,
              "MaxHeight",
              6,
              "UseClipBox",
              false,
              "Background",
              RGBA(32, 35, 47, 255)
            }, {
              PlaceObj("XTemplateWindow", {
                "Id",
                "idYellowBar",
                "Dock",
                "ignore",
                "HAlign",
                "left",
                "VAlign",
                "top",
                "UseClipBox",
                false,
                "Background",
                RGBA(191, 105, 67, 255)
              }),
              PlaceObj("XTemplateWindow", {
                "Id",
                "idRedBar",
                "Dock",
                "box",
                "UseClipBox",
                false,
                "Background",
                RGBA(191, 67, 77, 255)
              }),
              PlaceObj("XTemplateWindow", {
                "HAlign",
                "center",
                "MinWidth",
                2,
                "MinHeight",
                6,
                "MaxWidth",
                2,
                "MaxHeight",
                6,
                "UseClipBox",
                false,
                "Background",
                RGBA(215, 159, 80, 255)
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idRangeTriangle",
                "ZOrder",
                2,
                "Dock",
                "ignore",
                "MinWidth",
                17,
                "MinHeight",
                15,
                "MaxWidth",
                17,
                "MaxHeight",
                15,
                "UseClipBox",
                false,
                "Image",
                "UI/Hud/range_0"
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnLayoutComplete(self)",
                "func",
                function(self)
                  local node = self:ResolveId("node")
                  local b = node.idRangeBar.box
                  local distance = node.context.attack_distance
                  local maxDistance = node.context.weapon_range
                  local dist = Clamp(distance, 0, maxDistance)
                  local triangle = node.idRangeTriangle
                  local bar = node.idRedBar
                  local triagWidth = triangle.measure_width
                  local triagHeight = triangle.measure_height
                  local xPos = Lerp(b:minx(), b:maxx(), dist, maxDistance)
                  node.idRangeTriangle:SetBox(xPos - triagWidth / 2, b:miny() + b:sizey() / 2 - triagHeight / 2, triagWidth, triagHeight)
                  local halfWayPoint = b:minx() + b:sizex() / 2
                  local yellowBarWidth = xPos - b:minx() - triagWidth / 2
                  if distance >= maxDistance or distance <= maxDistance / 2 or yellowBarWidth < 0 then
                    yellowBarWidth = 0
                  end
                  if distance >= maxDistance then
                    triangle:AddInterpolation({
                      id = "pulse",
                      type = const.intRect,
                      duration = 1000,
                      originalRect = sizebox(0, 0, 1000, 1000),
                      targetRect = sizebox(0, 0, 1100, 1100),
                      flags = const.intfPingPong + const.intfLooping,
                      OnLayoutComplete = IntRectCenterRelative,
                      OnWindowMove = IntRectCenterRelative,
                      start = 0
                    })
                    bar:AddInterpolation({
                      id = "pulse",
                      type = const.intAlpha,
                      startValue = 0,
                      endValue = 255,
                      duration = 1000,
                      flags = const.intfPingPong + const.intfLooping,
                      start = 0
                    })
                  else
                    triangle:RemoveModifier("pulse")
                    bar:RemoveModifier("pulse")
                  end
                  if yellowBarWidth ~= 0 then
                    node.idYellowBar:AddInterpolation({
                      id = "pulse",
                      type = const.intAlpha,
                      startValue = 0,
                      endValue = 255,
                      duration = 1000,
                      flags = const.intfPingPong + const.intfLooping,
                      start = 0
                    })
                  else
                    node.idYellowBar:RemoveModifier("pulse")
                  end
                  node.idYellowBar:SetBox(b:minx(), b:miny(), yellowBarWidth, b:sizey())
                end
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idRangeNumber",
              "MinWidth",
              40,
              "Clip",
              false,
              "UseClipBox",
              false,
              "TextStyle",
              "Crosshair_Range",
              "Text",
              "20"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "hints below crosshair",
            "__context",
            function(parent, context)
              return "firing_mode"
            end,
            "__class",
            "XContentTemplate",
            "IdNode",
            false,
            "HAlign",
            "center",
            "VAlign",
            "bottom",
            "UseClipBox",
            false,
            "ChildrenHandleMouse",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return "crosshair"
              end,
              "__class",
              "XContextWindow",
              "UseClipBox",
              false,
              "Visible",
              false,
              "FoldWhenHidden",
              true,
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local textCancel = self:ResolveId("idCancel")
                local textAttack = self:ResolveId("idAttack")
                local crosshair = self:ResolveId("node")
                local mouseIn = crosshair.mouseIn
                local showingAction = crosshair.show_data_for_action
                mouseIn = mouseIn or not not showingAction
                textCancel:SetVisible(not mouseIn)
                textAttack:SetVisible(mouseIn)
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idAttack",
                "VAlign",
                "center",
                "Clip",
                false,
                "UseClipBox",
                false,
                "FoldWhenHidden",
                true,
                "HandleMouse",
                false,
                "TextStyle",
                "Crosshair_Hotkey",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  local text = T(862543748542, " Fire")
                  local crosshair = self:ResolveId("node")
                  if crosshair.show_data_for_action then
                    text = T({
                      504309376214,
                      "<DisplayName> ",
                      crosshair.show_data_for_action
                    })
                  end
                  if GetUIStyleGamepad() then
                    local tag = GetPlatformSpecificImageTag("ButtonA", 650)
                    text = tag .. text
                  else
                    text = T(121258076012, "<image UI/Icons/left_click 1700>") .. text
                  end
                  self:SetText(text)
                  XContextControl.OnContextUpdate(self, context)
                end,
                "Translate",
                true
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idCancel",
                "VAlign",
                "center",
                "Clip",
                false,
                "UseClipBox",
                false,
                "FoldWhenHidden",
                true,
                "HandleMouse",
                false,
                "TextStyle",
                "Crosshair_Hotkey",
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  local text = T(940289117862, " Cancel")
                  if GetUIStyleGamepad() then
                    local tag = GetPlatformSpecificImageTag("ButtonB", 650)
                    text = tag .. text
                  else
                    text = T(121258076012, "<image UI/Icons/left_click 1700>") .. text
                  end
                  self:SetText(text)
                  XContextControl.OnContextUpdate(self, context)
                end,
                "Translate",
                true
              })
            }),
            PlaceObj("XTemplateWindow", {
              "Id",
              "idAimModifierContainer",
              "IdNode",
              true,
              "HAlign",
              "center",
              "UseClipBox",
              false
            }, {
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return "crosshair"
                end,
                "__class",
                "XText",
                "Id",
                "idAimModifierText",
                "VAlign",
                "center",
                "Clip",
                false,
                "UseClipBox",
                false,
                "TextStyle",
                "Crosshair_AimModifier",
                "ContextUpdateOnOpen",
                true,
                "Translate",
                true
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "Open(self)",
                "func",
                function(self)
                  XWindow.Open(self)
                  local node = self:ResolveId("node")
                  local nextAimLevel = node:GetNextAimLevel()
                  local aim = node.aim or 0
                  local maxAimPossible = node.maxAimPossible or -1
                  if not GetUIStyleGamepad() then
                    self:SetVisible(aim ~= maxAimPossible)
                  end
                  local firstRespawn = not rawget(node, "first_respawn_mark")
                  if firstRespawn then
                    rawset(node, "first_respawn_mark", true)
                  end
                  if nextAimLevel == 0 and aim == 0 then
                    local text = self.idAimModifierText
                    if firstRespawn then
                      text:SetTransparency(255)
                      return
                    end
                    text:SetTransparency(0)
                    text:CreateThread("animch", function()
                      Sleep(1000)
                      text:SetTransparency(255, 300)
                    end)
                  end
                  local gamepad = GetUIStyleGamepad()
                  self.idAimModifierText:SetMargins(gamepad and box(0, 0, 0, -11) or empty_box)
                  if gamepad then
                    self.idAimModifierText:SetText(T(527036008338, "<ShortcutButton('', 'LeftTrigger')> AIM <AimAPCost()> AP <ShortcutButton('', 'RightTrigger')>"))
                  elseif GameState.RainHeavy then
                    self.idAimModifierText:SetText(T(401170590142, "<right_click> AIM (<AimAPCost()> AP)"))
                  else
                    self.idAimModifierText:SetText(T(955029858656, "<right_click> AIM"))
                  end
                end
              })
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "attacker observer",
      "__context",
      function(parent, context)
        return context.attacker
      end,
      "__class",
      "XContextWindow",
      "OnContextUpdate",
      function(self, context, ...)
        local dialog = self:ResolveId("node")
        if dialog.window_state == "destroying" then
          return
        end
        dialog.cached_results = false
        dialog:UpdateAim()
      end
    }),
    PlaceObj("XTemplateForEach", {
      "comment",
      "body part: create a fake action triggered by gamepad",
      "array",
      function(parent, context)
        return parent.context.body_parts
      end,
      "run_after",
      function(child, context, item, i, n, last)
        function child:OnAction(host, source)
          local slot = item.id
          local preset = item
          local crosshair = host.crosshair
          if not crosshair then
            return
          end
          local button = crosshair:ResolveId("idButton" .. slot)
          if button and button.visible and crosshair.targetPart ~= preset then
            crosshair:SetSelectedPart(preset)
          end
        end
        child:SetActionGamepad(CrosshairBodyPartDirections[i])
      end
    }, {
      PlaceObj("XTemplateAction", nil)
    }),
    PlaceObj("XTemplateForEach", {
      "comment",
      "firing mode: create a fake action triggered by gamepad",
      "array",
      function(parent, context)
        return parent.context.firingModes or empty_table
      end,
      "run_after",
      function(child, context, item, i, n, last)
        function child:OnAction(host, source)
          local slot = item.id
          local preset = item
          local crosshair = host.crosshair
          if not crosshair then
            return
          end
          local button = false
          local firingModeButtons = crosshair.idFireModeContainer
          for i, b in ipairs(firingModeButtons) do
            if b.context.action == preset then
              button = b
            end
          end
          if button and button.visible and crosshair.targetPart ~= preset then
            crosshair:ChangeAction(button.context.action)
          end
        end
        child:SetActionGamepad(CrosshairFiringModeDirection[i])
      end
    }, {
      PlaceObj("XTemplateAction", nil)
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionListUp",
      "ActionGamepad",
      "DPadUp",
      "OnAction",
      function(self, host, source, ...)
        local crosshair = host.crosshair
        if not crosshair then
          return "break"
        end
        return crosshair:MoveInCurrentGamepadList(-1)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "actionListDown",
      "ActionGamepad",
      "DPadDown",
      "OnAction",
      function(self, host, source, ...)
        local crosshair = host.crosshair
        if not crosshair then
          return "break"
        end
        return crosshair:MoveInCurrentGamepadList(1)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadCrosshairToggleListFiringMode",
      "ActionGamepad",
      "DPadLeft",
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
      end,
      "OnAction",
      function(self, host, source, ...)
        local crosshair = host.crosshair
        if not crosshair then
          return
        end
        local list = crosshair.crosshair_gamepad_list
        if list == "body_parts" then
          if not crosshair.idFireModeContainer then
            return
          end
          list = "firing_modes"
        else
          return
        end
        crosshair.crosshair_gamepad_list = list
        ObjModified("GamepadUIStyleChanged")
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "GamepadCrosshairToggleListBodyParts",
      "ActionGamepad",
      "DPadRight",
      "BindingsMenuCategory",
      "CombatActions",
      "ActionState",
      function(self, host)
      end,
      "OnAction",
      function(self, host, source, ...)
        local crosshair = host.crosshair
        if not crosshair then
          return
        end
        local list = crosshair.crosshair_gamepad_list
        if list == "body_parts" then
          return
        else
          list = "body_parts"
        end
        crosshair.crosshair_gamepad_list = list
        ObjModified("GamepadUIStyleChanged")
      end,
      "IgnoreRepeated",
      true
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "MoveInCurrentGamepadList(self, direction)",
      "func",
      function(self, direction)
        local crosshair = self
        local list = crosshair.crosshair_gamepad_list
        if list == "body_parts" then
          local selectedPart = crosshair.targetPart
          local slot = selectedPart and selectedPart.id
          local buttonIdx = crosshair.idButtonsContainer
          buttonIdx = table.find(buttonIdx, "context", selectedPart)
          if not buttonIdx then
            return "break"
          end
          buttonIdx = buttonIdx + direction
          local buttonNext = crosshair.idButtonsContainer[buttonIdx]
          if not buttonNext or not buttonNext.visible then
            return "break"
          end
          crosshair:SetSelectedPart(buttonNext.context)
        elseif list == "firing_modes" and crosshair.idFireModeContainer then
          local selectedFiringMode = crosshair.context.action
          local buttonIdx = false
          for i, b in ipairs(crosshair.idFireModeContainer) do
            if b.context.action == selectedFiringMode then
              buttonIdx = i
            end
          end
          if not buttonIdx then
            return "break"
          end
          buttonIdx = buttonIdx + direction
          local buttonNext = crosshair.idFireModeContainer[buttonIdx]
          if not buttonNext or not buttonNext.visible then
            return "break"
          end
          if not buttonNext.context.action then
            return "break"
          end
          crosshair:ChangeAction(buttonNext.context.action)
        end
      end
    })
  })
})
