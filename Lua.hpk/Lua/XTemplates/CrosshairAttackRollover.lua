PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu Rollover",
  id = "CrosshairAttackRollover",
  PlaceObj("XTemplateWindow", {
    "__condition",
    function(parent, context)
      return not gv_Cheats.OptionalUIHidden
    end,
    "__class",
    "XRolloverWindow",
    "BorderWidth",
    0,
    "MinHeight",
    500,
    "MaxWidth",
    40000,
    "Background",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        XRolloverWindow.Open(self)
        local crosshair = self.idContent.context.control:ResolveId("node")
        local unit = crosshair.context.target
        local effectsWithCrosshairEffects = GetUnitVisibleStatusEffectsAndCrosshairEffects(unit)
        local hasAnyEffects = effectsWithCrosshairEffects and 0 < #effectsWithCrosshairEffects
        self.idContent.idStatus:SetVisible(hasAnyEffects)
        self.idMercStatusMoreInfo.idEffectList:SetContext(effectsWithCrosshairEffects)
        self.idMercStatusMoreInfoContainer:SetVisible(hasAnyEffects)
        self.idContent.idMoreInfo:SetVisible(hasAnyEffects)
        if not crosshair.darkness_tutorial then
          return
        end
        local popup = OpenTutorialPopup(self, false, TutorialHints.EnemyInDarkness)
        if not popup then
          return
        end
        popup:SetHandleMouse(false)
        popup:SetChildrenHandleMouse(false)
        popup:SetVisible(false, true)
        popup:DeleteThread("rollover-observer")
        popup.idCloseBut:SetVisible(false)
        popup:CreateThread("observer", function()
          if self.window_state == "destroying" then
            return
          end
          while self.window_state ~= "destroying" and self.idContent and self.idContent.layout_update do
            Sleep(1)
          end
          if self.window_state == "destroying" then
            return
          end
          popup:InvalidateLayout()
          popup:SetVisible(true)
          while popup.window_state ~= "destroying" do
            if self.window_state ~= "open" then
              CloseCurrentTutorialPopup("skipDelay")
            else
              local wholeRollover = self.idContent.box
              local topBar = self.idContent.idTopBar.box
              local lightIndicator = self.idContent.idLightIndicator.box
              local extraInfo = self.idMercStatusMoreInfo
              local leftX = wholeRollover:minx()
              local rightX = wholeRollover:maxx()
              if extraInfo.visible then
                local extraInfoBox = extraInfo.box
                if leftX > extraInfoBox:minx() then
                  leftX = extraInfoBox:minx()
                elseif rightX < extraInfoBox:maxx() then
                  rightX = extraInfoBox:maxx()
                end
              end
              popup:InvalidateLayout()
              popup:SetAnchor(box(leftX, lightIndicator:miny(), rightX, wholeRollover:maxy()))
            end
            Sleep(20)
          end
          CloseCurrentTutorialPopup("skipDelay")
        end)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnLayoutComplete(self, ...)",
      "func",
      function(self, ...)
        if rawget(self, "split-rollover") then
          CrosshairRolloverCustomLayoutSplit(self)
          return
        end
        local onTheLeft = rawget(self, "smart-anchor") == "left"
        local mercStatusInfo = self.idMercStatusMoreInfoContainer
        if not mercStatusInfo then
          return
        end
        mercStatusInfo:SetZOrder(onTheLeft and -10 or 10)
        local anchor = self:GetAnchor()
        local x = self.box:minx()
        local xMax = self.box:maxx()
        local insideAnchor = x < anchor:maxx() and anchor:minx() < self.box:maxx() and self.box:miny() < anchor:maxy() and anchor:miny() < self.box:maxy()
        if insideAnchor then
          CrosshairRolloverCustomLayoutSplit(self)
          rawset(self, "split-rollover", true)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "UpdateLayout(self)",
      "func",
      function(self)
        local margins_x1, margins_y1, margins_x2, margins_y2 = ScaleXY(self.scale, self.Margins:xyxy())
        local anchor = self:GetAnchor()
        local safe_area_x1, safe_area_y1, safe_area_x2, safe_area_y2 = self:GetSafeAreaBox()
        local x, y = self.box:minxyz()
        local width, height = self.measure_width - margins_x1 - margins_x2, self.measure_height - margins_y1 - margins_y2
        local a_type = self.AnchorType
        if a_type == "smart" then
          local space = anchor:minx() - safe_area_x1 - width - margins_x2
          a_type = "left"
          if space < safe_area_x2 - anchor:maxx() - width - margins_x1 then
            space = safe_area_x2 - anchor:maxx() - width - margins_x1
            a_type = "right"
          end
        end
        rawset(self, "smart-anchor", a_type)
        if a_type == "left" then
          x = anchor:minx() - width - margins_x2
          y = anchor:miny() - margins_y1
        elseif a_type == "right" then
          x = anchor:maxx() + margins_x1
          y = anchor:miny() - margins_y1
        end
        if safe_area_x2 < x + width + margins_x2 then
          x = safe_area_x2 - width - margins_x2
        elseif safe_area_x1 > x then
          x = safe_area_x1
        end
        if safe_area_y2 < y + height + margins_y2 then
          y = safe_area_y2 - height - margins_y2
        elseif safe_area_y1 > y then
          y = safe_area_y1
        end
        self:SetBox(x, y, width, height)
        return XControl.UpdateLayout(self)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idMercStatusMoreInfoContainer",
      "Dock",
      "left"
    }, {
      PlaceObj("XTemplateTemplate", {
        "__context",
        function(parent, context)
          return context.control:ResolveId("node").context.target
        end,
        "__template",
        "MercStatusEffectsMoreInfo",
        "Id",
        "idMercStatusMoreInfo",
        "Margins",
        box(6, 0, 6, 0),
        "Dock",
        false
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Padding",
      box(6, 6, 6, 6),
      "Dock",
      "left",
      "VAlign",
      "top",
      "MinWidth",
      356,
      "LayoutMethod",
      "VList",
      "Background",
      RGBA(52, 55, 61, 255),
      "BackgroundRectGlowSize",
      2,
      "BackgroundRectGlowColor",
      RGBA(32, 35, 47, 255),
      "OnContextUpdate",
      function(self, context, ...)
        local control = context.control
        local crosshair = control:ResolveId("node")
        local crosshairCtx = crosshair.context
        local unit = crosshairCtx.attacker
        local units = {unit}
        local target = crosshairCtx.target
        local action = crosshairCtx.action
        local weapon = action:GetAttackWeapons(unit)
        local targetHasBodyParts = IsKindOf(target, "Unit")
        local bodyPartId = crosshair.targetPart.id
        local attackResult = crosshairCtx.attackResultTable[bodyPartId]
        if not attackResult then
          self.idAttackInfoSection:SetVisible(false)
          self.idTextAndHint:SetVisible(false)
          return
        end
        self.idAttackInfoSection:SetVisible(true)
        local title
        if targetHasBodyParts then
          title = T({
            643486248504,
            "<actionName> <style PDARolloverHeaderDark>(<bodyPart>)</style>",
            actionName = action:GetActionDisplayName(units),
            bodyPart = attackResult.bodyPartDisplayName or crosshair.targetPart.display_name
          })
        else
          title = T({
            485104522601,
            "<actionName>",
            actionName = action:GetActionDisplayName(units)
          })
        end
        self.idTitle:SetText(title)
        local args = {
          target = target,
          target_spot_group = bodyPartId,
          aim = crosshair.aim
        }
        local apCost = action:GetAPCost(unit, args)
        local unitAp = unit:GetUIActionPoints()
        local desc = ""
        local errors = {}
        local damageTitle = false
        local damageModifiers = false
        if targetHasBodyParts then
          if bodyPartId ~= "Torso" then
            desc = desc .. crosshair.targetPart.description
            desc = bodyPartId == "Neck" and IsKindOf(weapon, "MeleeWeapon") and desc .. weapon:GetCustomNeckAttackDescription() or desc
            if HasPerk(unit, "TrickShot") then
              if bodyPartId == "Arms" then
                desc = desc .. T(544883750200, "<newline>Trick shot - prevent special attacks")
              elseif bodyPartId == "Groin" then
                desc = desc .. T(670919673153, "<newline>Trick shot - the enemy will be Exposed")
              elseif bodyPartId == "Legs" then
                desc = desc .. T(850182723500, "<newline>Trick shot - the enemy will be knocked down")
              end
            end
          end
          local modifiers = {}
          if attackResult.dmg_breakdown then
            for i, mod in ipairs(attackResult.dmg_breakdown) do
              if not mod.value or mod.value ~= 0 then
                modifiers[#modifiers + 1] = {
                  mod.name,
                  mod.value
                }
              end
            end
          end
          damageTitle = T(120392607036, "DAMAGE MODIFIER")
          damageModifiers = 0 < #modifiers and {}
          for i, mod in ipairs(modifiers) do
            local modValue = mod[2]
            if modValue then
              local sign = ""
              if 0 < modValue then
                sign = "<color PDASectorInfo_Green>+</color>"
              elseif modValue < 0 then
                sign = "<color DescriptionTextRed>-</color>"
              end
              if CthVisible() then
                sign = T({
                  537019866139,
                  "<style PDABrowserTextLightBold><percentWithSign(value)></style>",
                  value = modValue
                })
              end
              damageModifiers[#damageModifiers + 1] = T({
                684195083254,
                "<modName> <right><sign><left>",
                modName = mod[1],
                sign = sign
              })
            else
              damageModifiers[#damageModifiers + 1] = mod[1]
            end
          end
          damageModifiers = damageModifiers and table.concat(damageModifiers, "<newline>")
        end
        if #desc == 0 then
          self.idTextAndHint:SetVisible(false)
        end
        self.idText:SetText(desc)
        self.idDamageModifiers:SetText(damageModifiers)
        self.idDamageHeader:SetText(damageTitle)
        if not damageModifiers then
          self.idDamageBreakdown:SetVisible(false)
        end
        local wep, wep2 = action:GetAttackWeapons(unit)
        if wep and wep2 and attackResult.attacks then
          local attack1 = attackResult.attacks[1]
          local attack2 = attackResult.attacks[2]
          local dmgWep1 = attack1.total_damage
          local dmgWep2 = attack2.total_damage
          local w1Shots = attack1.shots and #attack1.shots or 1
          local w2Shots = attack2.shots and #attack2.shots or 1
          dmgWep1 = dmgWep1 / w1Shots
          dmgWep2 = dmgWep2 / w2Shots
          if 1 < w1Shots and 0 < dmgWep1 then
            self.idDamage:SetText(T({
              190166169569,
              "<style PDARolloverHeaderBeige><shots>x<damage></style> <valign bottom -1>DMG",
              shots = w1Shots,
              damage = dmgWep1
            }))
            self.idDamage2:SetText(T({
              190166169569,
              "<style PDARolloverHeaderBeige><shots>x<damage></style> <valign bottom -1>DMG",
              shots = w2Shots,
              damage = dmgWep2
            }))
          else
            local dmgText = T(443022842732, "<style PDARolloverHeaderBeige><damage></style> <valign bottom -1>DMG")
            self.idDamage:SetText(T({dmgText, damage = dmgWep1}))
            self.idDamage2:SetText(T({dmgText, damage = dmgWep2}))
          end
          local critText = T(301737864898, "<style PDARolloverHeaderBeige><percent(crit)></style> <valign bottom -1>CRIT")
          local critWep1 = attackResult.attacks[1].crit_chance
          local critWep2 = attackResult.attacks[2].crit_chance
          self.idCrit:SetText(T({critText, crit = critWep1}))
          self.idCrit2:SetText(T({critText, crit = critWep2}))
        else
          local shots = 1
          local damage, perShot, _, params = action:GetActionDamage(unit, target)
          if perShot and perShot ~= 0 then
            shots = damage / perShot
          end
          local aoeDamage = params and params.aoe_damage or 0
          if attackResult and IsKindOf(target, "Unit") then
            damage = attackResult.calculated_target_damage or 0
            aoeDamage = attackResult.calculated_target_aoeDamage or 0
            local attacks = attackResult.attacks and #attackResult.attacks or 1
            local attackShots = attackResult.shots and #attackResult.shots or 1
            shots = Max(attacks, attackShots)
            perShot = shots == 0 and 0 or damage / shots
          end
          if 1 < shots and 0 < damage then
            self.idDamage:SetText(T({
              190166169569,
              "<style PDARolloverHeaderBeige><shots>x<damage></style> <valign bottom -1>DMG",
              shots = shots,
              damage = perShot
            }))
          elseif 0 < aoeDamage then
            self.idDamage:SetText(T({
              599365440266,
              "<style PDARolloverHeaderBeige><damage>+<aoeDamage></style> <valign bottom -1>DMG",
              aoeDamage = aoeDamage,
              damage = damage
            }))
          else
            self.idDamage:SetText(T({
              443022842732,
              "<style PDARolloverHeaderBeige><damage></style> <valign bottom -1>DMG",
              damage = damage
            }))
          end
          self.idCrit:SetText(T({
            301737864898,
            "<style PDARolloverHeaderBeige><percent(crit)></style> <valign bottom -1>CRIT",
            crit = attackResult.crit_chance
          }))
        end
        local attackArgs = attackResult.crosshair_attack_args
        local stealthKillChance = attackArgs and attackArgs.stealth_kill_chance
        local stealthCritChance = attackArgs and attackArgs.stealth_bonus_crit_chance
        local isStealthKill = stealthKillChance and 0 < stealthKillChance
        local isStealthCrit = stealthCritChance and 0 < stealthCritChance
        if isStealthKill then
          local text = false
          if not unit:HasStatusEffect("Hidden") then
            text = T(950280505689, "LETHAL ATTACK")
          elseif isStealthKill then
            if target:IsAware() then
              text = T(939087838390, "STEALTH KILL (Aware)")
            else
              text = T(510790126935, "STEALTH KILL")
            end
          end
          self.idInstakill:SetLethalKillChance(stealthKillChance, text)
          self.idInstakill.idMeter:SetVisible(true)
          self.idInstakill:SetVisible(true)
        elseif isStealthCrit then
          self.idInstakill:SetVisible(true)
          self.idInstakill.idMeter:SetVisible(false)
          self.idInstakill.idText:SetText(T({
            840713891222,
            "STEALTH CRIT <percent(crit)>",
            crit = attackResult.crit_chance
          }))
        else
          self.idInstakill:SetVisible(false)
        end
        if isStealthKill or isStealthCrit then
          self.idCrit:SetVisible(false)
          self.idCrit2:SetVisible(false)
        end
        PopulateCrosshairUICth(self.idHitInfo, unit, action, attackResult)
      end
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open",
        "func",
        function(self, ...)
          XContextControl.Open(self, ...)
          local control = self.context.control
          local offset = control and control:GetRolloverOffset()
          if offset and offset ~= box(0, 0, 0, 0) then
            self.parent:SetMargins(self.parent.Margins + offset)
          end
        end
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "crosshair change observer",
        "__context",
        function(parent, context)
          return "crosshair"
        end,
        "__class",
        "XContextWindow",
        "Dock",
        "ignore",
        "OnContextUpdate",
        function(self, context, ...)
          self.parent:OnContextUpdate(self.parent.context)
        end
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idTopBar",
        "Margins",
        box(0, 0, 0, 3),
        "Dock",
        "top",
        "DrawOnTop",
        true,
        "Background",
        RGBA(52, 55, 61, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(8, 0, 0, 0),
          "Dock",
          "left",
          "Clip",
          false,
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDACombatActionHeader",
          "Translate",
          true,
          "TextVAlign",
          "bottom"
        }),
        PlaceObj("XTemplateTemplate", {
          "__context",
          function(parent, context)
            return context.control:ResolveId("node").context.target
          end,
          "__template",
          "CombatBadgeLightIndicator",
          "Id",
          "idLightIndicator",
          "Margins",
          box(0, 0, 5, 0),
          "VAlign",
          "center",
          "MinWidth",
          24,
          "MinHeight",
          24,
          "MaxWidth",
          24,
          "MaxHeight",
          24
        })
      }),
      PlaceObj("XTemplateWindow", {
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "Id",
          "idAttackInfoSection",
          "Padding",
          box(14, 0, 14, 2),
          "LayoutMethod",
          "VList",
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "LayoutHSpacing",
            5
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idDamage",
              "HAlign",
              "left",
              "VAlign",
              "center",
              "FoldWhenHidden",
              true,
              "TextStyle",
              "PDAActivitiesButtonSmall",
              "Translate",
              true,
              "HideOnEmpty",
              true,
              "TextVAlign",
              "bottom"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idCrit",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "TextStyle",
              "PDAActivitiesButtonSmall",
              "Translate",
              true,
              "TextVAlign",
              "bottom"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idInstakillOld",
              "HAlign",
              "right",
              "VAlign",
              "center",
              "FoldWhenHidden",
              true,
              "TextStyle",
              "PDAActivitiesButtonSmall",
              "Translate",
              true,
              "TextVAlign",
              "bottom"
            }),
            PlaceObj("XTemplateTemplate", {
              "__template",
              "CrosshairLethalKill",
              "Id",
              "idInstakill",
              "HAlign",
              "right",
              "VAlign",
              "center"
            })
          }),
          PlaceObj("XTemplateWindow", {
            "LayoutHSpacing",
            5
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idDamage2",
              "HAlign",
              "left",
              "VAlign",
              "center",
              "FoldWhenHidden",
              true,
              "TextStyle",
              "PDAActivitiesButtonSmall",
              "Translate",
              true,
              "HideOnEmpty",
              true,
              "TextVAlign",
              "bottom"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idCrit2",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "TextStyle",
              "PDAActivitiesButtonSmall",
              "Translate",
              true,
              "HideOnEmpty",
              true,
              "TextVAlign",
              "bottom"
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idTextAndHint",
          "Margins",
          box(0, 6, 0, 0),
          "Padding",
          box(14, 3, 14, 3),
          "MinHeight",
          34,
          "LayoutMethod",
          "VList",
          "FoldWhenHidden",
          true,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idText",
            "HAlign",
            "left",
            "MaxWidth",
            300,
            "Clip",
            false,
            "UseClipBox",
            false,
            "TextStyle",
            "SatelliteContextMenuKeybind",
            "Translate",
            true
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return "g_RolloverShowMoreInfo"
          end,
          "__class",
          "XContextWindow",
          "FoldWhenHidden",
          true,
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local node = self:ResolveId("node")
            node:OnContextUpdate(node.context)
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idHitInfo",
            "IdNode",
            true,
            "VAlign",
            "top",
            "LayoutMethod",
            "VList",
            "UseClipBox",
            false,
            "FoldWhenHidden",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(8, 0, 0, 0),
              "MinHeight",
              34,
              "UseClipBox",
              false
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idChanceToHit",
                "Padding",
                box(0, 0, 6, 0),
                "VAlign",
                "center",
                "Clip",
                false,
                "UseClipBox",
                false,
                "TextStyle",
                "PDABrowserNameSmall",
                "Translate",
                true,
                "TextVAlign",
                "center"
              })
            }),
            PlaceObj("XTemplateWindow", {
              "Padding",
              box(14, 5, 14, 5),
              "UseClipBox",
              false,
              "Background",
              RGBA(32, 35, 47, 255)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idModifiers",
                "Clip",
                false,
                "UseClipBox",
                false,
                "TextStyle",
                "SatelliteContextMenuKeybind",
                "Translate",
                true,
                "TextVAlign",
                "center"
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__context",
          function(parent, context)
            return "g_RolloverShowMoreInfo"
          end,
          "__class",
          "XContextWindow",
          "Id",
          "idDamageBreakdown",
          "FoldWhenHidden",
          true,
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            self:SetVisible(g_RolloverShowMoreInfo)
            local node = self:ResolveId("node")
            node:OnContextUpdate(node.context)
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "VAlign",
            "top",
            "LayoutMethod",
            "VList",
            "UseClipBox",
            false,
            "FoldWhenHidden",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "Margins",
              box(8, 0, 0, 0),
              "MinHeight",
              34,
              "UseClipBox",
              false
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idDamageHeader",
                "Padding",
                box(2, 0, 2, 0),
                "VAlign",
                "center",
                "Clip",
                false,
                "UseClipBox",
                false,
                "FoldWhenHidden",
                true,
                "TextStyle",
                "PDABrowserNameSmall",
                "Translate",
                true,
                "HideOnEmpty",
                true,
                "TextVAlign",
                "center"
              })
            }),
            PlaceObj("XTemplateWindow", {
              "Padding",
              box(8, 5, 8, 5),
              "UseClipBox",
              false,
              "Background",
              RGBA(32, 35, 47, 255)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idDamageModifiers",
                "Clip",
                false,
                "UseClipBox",
                false,
                "FoldWhenHidden",
                true,
                "TextStyle",
                "SatelliteContextMenuKeybind",
                "Translate",
                true,
                "HideOnEmpty",
                true,
                "TextVAlign",
                "center"
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "status effects",
          "__context",
          function(parent, context)
            return context.control:ResolveId("node").context.target
          end,
          "Id",
          "idStatus",
          "LayoutMethod",
          "VList",
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "conditions label",
            "__class",
            "XText",
            "Margins",
            box(8, 0, 0, 0),
            "MinHeight",
            34,
            "Clip",
            false,
            "UseClipBox",
            false,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDABrowserNameSmall",
            "Translate",
            true,
            "Text",
            T(392264332209, "STATUS"),
            "TextVAlign",
            "center"
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return GetUnitVisibleStatusEffectsAndCrosshairEffects(context)
            end,
            "__class",
            "XContextWindow",
            "Padding",
            box(14, 10, 14, 10),
            "LayoutMethod",
            "Grid",
            "LayoutVSpacing",
            2,
            "UniformRowHeight",
            true,
            "Background",
            RGBA(32, 35, 47, 255)
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "status effects",
              "run_after",
              function(child, context, item, i, n, last)
                local columnSize = MulDivRound(#context, 1, 2)
                local column = (i - 1) / columnSize + 1
                local row = (i - 1) % columnSize + 1
                child:SetGridY(row)
                child:SetGridX(column)
                child:SetContext(item)
                child.idIcon:SetImage(item.Icon)
                child.idLabel:SetText(item.DisplayName)
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "IdNode",
                true,
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                10,
                "UseClipBox",
                false,
                "ChildrenHandleMouse",
                false
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "StatusEffectIcon",
                  "Id",
                  "idIcon",
                  "HandleMouse",
                  false
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idLabel",
                  "HAlign",
                  "left",
                  "VAlign",
                  "center",
                  "Clip",
                  false,
                  "UseClipBox",
                  false,
                  "TextStyle",
                  "MercStatName",
                  "Translate",
                  true
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateTemplate", {"__template", "MoreInfo"})
      })
    })
  })
})
