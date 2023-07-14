PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu Rollover",
  id = "CombatActionRollover",
  PlaceObj("XTemplateWindow", {
    "__class",
    "TermClarifyingRollover",
    "BorderWidth",
    0,
    "MaxWidth",
    40000,
    "LayoutMethod",
    "HList",
    "Background",
    RGBA(0, 0, 0, 0),
    "OnContextUpdate",
    function(self, context, ...)
      local terms = TermClarifyingRollover.OnContextUpdate(self, context, ...)
      self.idContent.idMoreInfo:SetVisible(terms and 0 < #terms, "terms")
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Padding",
      box(6, 4, 6, 6),
      "VAlign",
      "bottom",
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
        local enabled = control:GetEnabled()
        local title = not enabled and context.RolloverDisabledTitle ~= "" and context.RolloverDisabledTitle or context.RolloverTitle ~= "" and context.RolloverTitle or control:GetRolloverTitle()
        self.idTitle:SetText(title)
        local show = self.idTitle.text ~= ""
        self.idTitle:SetVisible(show)
        if not context.action then
          return
        end
        local unit = ResolvePropObj(context) or Selection[1]
        local action = context.action:ResolveAction(unit)
        if not unit or not action then
          return
        end
        local units = Selection
        local target = action:GetAnyTarget(units)
        local apCost, displayCost, apCostAimMax, displayCostMax = 0, 0, 0, 0
        local apCostMin, apCostMax = unit:CalcAttackCostRange(action, target, context.item_id)
        apCostMin = apCostMin or -1
        apCostMax = apCostMax or -1
        local unitAp = unit:GetUIActionPoints()
        local apCostText = ""
        if action.UseFreeMove and unit:UIHasAP(apCostMax, action.id) then
          local ui_adjusted_cost, ap_now, free = unit:GetUIAdjustedActionCost(apCostMax, true, true)
          if ui_adjusted_cost == 0 and free and unit:HasAP(apCostMax, action.id) then
            apCostText = T(693867104758, "Free Move")
            self.idAPCostText:SetText(apCostText)
          else
            apCostMax = Min(apCostMax, ui_adjusted_cost * const.Scale.AP)
            apCostMin = Min(apCostMin, apCostMax)
          end
        end
        if apCostText == "" then
          if apCostMin ~= apCostMax then
            apCostText = "<apn(ap)>-<apn(apm)>" .. apCostText
          else
            apCostText = "<apn(ap)>" .. apCostText
          end
          apCostText = T({
            apCostText,
            ap = apCostMin,
            apm = apCostMax
          })
          self.idAPCostText:SetText(T({
            569524074495,
            "<apCostText><valign bottom><style CombatActionRolloverAP>/<apn(unitAp)> AP</style>",
            apCostText = apCostText,
            unitAp = unitAp
          }))
        end
        if apCostMin <= 0 or not g_Combat then
          self.idAPCostText:SetVisible(false)
        end
        local text = not enabled and context.RolloverDisabledText ~= "" and context.RolloverDisabledText or context.RolloverText ~= "" and context.RolloverText or control:GetRolloverText()
        if text ~= "placeholder" then
          self.idText:SetText(text)
        end
        local hint = context.gamepad and control:GetRolloverHintGamepad() or ""
        if hint == "" then
          hint = control:GetRolloverHint() or ""
        end
        local hintText = context.gamepad and context.RolloverHintGamepad ~= "" and context.RolloverHintGamepad or context.RolloverHint ~= "" and context.RolloverHint or hint
        if action and (not hintText or hintText == "") then
          local _, err = action:GetVisibility(units)
          if err then
            hintText = err
          elseif action.AimType == "melee" then
            local use_action = GetMeleeAttackAction(action, SelectedObj)
            if not use_action:GetAnyTarget(Selection) and use_action == action then
              hintText = T(477584135912, "<error>No enemies in melee range</error>")
            else
            end
          end
        end
        self.idHint:SetText(hintText)
        show = self.idHint.text ~= ""
        self.idHint:SetVisible(show)
        if not SelectedObj then
          return
        end
        local action = context.action
        action = action:ResolveAction(SelectedObj)
        if action and action.AimType == "melee" and not context.rollover_melee_area then
          context.rollover_melee_area = CombatActionCreateMeleeRangeArea(SelectedObj)
        end
        if action and (action.group == "WeaponAttacks" or action.group == "FiringModeMetaAction") then
          self.idAttackInfoSection:SetVisible(true)
          local shots = 1
          local damage, perShot, bonus, params = action:GetActionDamage(SelectedObj, target)
          if perShot and perShot ~= 0 then
            shots = damage / perShot
          end
          local aoeDamage = params and params.aoe_damage or 0
          local dlg = GetInGameInterfaceModeDlg()
          local crosshair = dlg.crosshair
          local aim = crosshair and crosshair.aim or 0
          local attackResult
          if crosshair and crosshair.cached_results then
            local actionResults = crosshair.cached_results[action.id]
            attackResult = actionResults and actionResults.attackResultCalc[g_DefaultShotBodyPart]
            if attackResult then
              damage = attackResult.calculated_target_damage or 0
              aoeDamage = attackResult.calculated_target_aoeDamage or 0
              local attacks = attackResult.attacks and #attackResult.attacks or 1
              local attackShots = attackResult.shots and #attackResult.shots or 1
              shots = Max(attacks, attackShots)
              perShot = shots == 0 and 0 or damage / shots
            end
          end
          local wep, wep2 = action:GetAttackWeapons(SelectedObj)
          if (action.id == "LeftHandShot" or action.id == "RightHandShot") and not self.idWeaponShow then
            local weaponShow = XTemplateSpawn("XInventoryItemEmbed", self.idTextAndHint, wep)
            weaponShow:SetId("idWeaponShow")
            weaponShow:SetZOrder(0)
            weaponShow:SetHAlign("left")
            local ammoText = XTemplateSpawn("XText", weaponShow, wep)
            ammoText:SetTranslate(true)
            ammoText:SetTextStyle("HUDHeader")
            ammoText:SetText(T({
              414344497801,
              "<bullets()>",
              wep
            }))
            ammoText:SetVAlign("bottom")
            ammoText:SetHAlign("right")
            if self.window_state == "open" then
              weaponShow:Open()
            end
          end
          local crit = params and params.critChance or SelectedObj:CalcCritChance(wep, GetCurrentUITarget(), aim)
          self.idCrit:SetText(T({
            938096896940,
            "<style PDARolloverHeaderBeige><percent(crit)></style> <valign bottom -2>CRIT",
            crit = crit
          }))
          if wep2 then
            local crit2 = SelectedObj:CalcCritChance(wep2, GetCurrentUITarget(), crosshair and crosshair.aim)
            self.idCrit2:SetText(T({
              938096896940,
              "<style PDARolloverHeaderBeige><percent(crit)></style> <valign bottom -2>CRIT",
              crit = crit2
            }))
            local w1Damage = params and params.wep1_damage or perShot
            local w2Damage = params and params.wep2_damage or perShot
            if attackResult then
              w1Damage = attackResult[1] and attackResult[1].damage or w1Damage
              w2Damage = attackResult[2] and attackResult[2].damage or w2Damage
            end
            local w1Shots = 1
            local w2Shots = 1
            if params and params.wep1_base then
              w1Shots = w1Damage / params.wep1_base
              w2Shots = w2Damage / params.wep2_base
            end
            if 1 < w1Shots then
              self.idDamage:SetText(T({
                707333089408,
                "<style PDARolloverHeaderBeige><shots>x<damage></style> <valign bottom -2>DMG",
                shots = w1Shots,
                damage = params.wep1_base
              }))
              self.idDamage2:SetText(T({
                707333089408,
                "<style PDARolloverHeaderBeige><shots>x<damage></style> <valign bottom -2>DMG",
                shots = w2Shots,
                damage = params.wep2_base
              }))
            else
              self.idDamage:SetText(T({
                370219953309,
                "<style PDARolloverHeaderBeige><damage></style> <valign bottom -2>DMG",
                damage = w1Damage
              }))
              self.idDamage2:SetText(T({
                370219953309,
                "<style PDARolloverHeaderBeige><damage></style> <valign bottom -2>DMG",
                damage = w2Damage
              }))
            end
            return
          end
          if 1 < shots then
            self.idDamage:SetText(T({
              615590050799,
              "<style PDARolloverHeaderBeige><shots>x<damage></style> <valign bottom -2>DMG",
              shots = shots,
              damage = perShot
            }))
          elseif 0 < aoeDamage then
            self.idDamage:SetText(T({
              921704709268,
              "<style PDARolloverHeaderBeige><damage>+<aoeDamage></style> <valign bottom -2>DMG",
              damage = damage,
              aoeDamage = aoeDamage
            }))
          else
            self.idDamage:SetText(T({
              370219953309,
              "<style PDARolloverHeaderBeige><damage></style> <valign bottom -2>DMG",
              damage = damage
            }))
          end
        elseif action and action.ActionType == "Ranged Attack" then
          local wep, wep2 = action:GetAttackWeapons(SelectedObj)
          if IsKindOf(wep, "Grenade") then
            self.idAttackInfoSection:SetVisible(true)
            local lSetTextFromProperty = function(textWnd, propertyPreset)
              local presetShortName = propertyPreset.short_display_name
              local value = propertyPreset:GetProp(wep, SelectedObj.session_id)
              textWnd:SetText(T({
                943797174493,
                "<style PDARolloverHeaderBeige><value></style> <valign bottom -2><shortName>",
                value = value,
                shortName = presetShortName
              }))
            end
            lSetTextFromProperty(self.idDamage, Presets.WeaponPropertyDef.Default.BaseDamage)
            lSetTextFromProperty(self.idCrit, Presets.WeaponPropertyDef.Default.BaseRange)
            lSetTextFromProperty(self.idExtraProperty, Presets.WeaponPropertyDef.Default.AreaOfEffect)
          else
            self.idAttackInfoSection:SetVisible(false)
          end
        else
          self.idAttackInfoSection:SetVisible(false)
        end
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
      PlaceObj("XTemplateFunc", {
        "name",
        "OnDelete",
        "func",
        function(self, ...)
          local context = self.context
          if context and context.rollover_melee_area then
            DoneObject(context.rollover_melee_area)
            context.rollover_melee_area = nil
          end
          XContextControl.OnDelete(self, ...)
        end
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idTop",
        "Dock",
        "top",
        "MinWidth",
        350,
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
          "Padding",
          box(0, 0, 0, 0),
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
          "WordWrap",
          false,
          "Shorten",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idAPCostText",
          "Margins",
          box(10, 0, 0, 0),
          "Padding",
          box(0, 0, 0, 0),
          "Dock",
          "right",
          "FoldWhenHidden",
          true,
          "TextStyle",
          "PDARolloverHeaderBeige",
          "Translate",
          true
        })
      }),
      PlaceObj("XTemplateWindow", {
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "Measure(self, max_width, max_height)",
          "func",
          function(self, max_width, max_height)
            local parent = self:ResolveId("node")
            local topUI = parent:ResolveId("idTop")
            max_width = topUI.measure_width
            return XWindow.Measure(self, max_width, max_height)
          end
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idAttackInfoSection",
          "Margins",
          box(0, 5, 0, 0),
          "Padding",
          box(14, 1, 14, 2),
          "LayoutMethod",
          "VList",
          "Visible",
          false,
          "FoldWhenHidden",
          true,
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", nil, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idDamage",
              "HAlign",
              "left",
              "VAlign",
              "bottom",
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
              "bottom",
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
              "idExtraProperty",
              "HAlign",
              "right",
              "VAlign",
              "bottom",
              "TextStyle",
              "PDAActivitiesButtonSmall",
              "Translate",
              true,
              "TextVAlign",
              "bottom"
            })
          }),
          PlaceObj("XTemplateWindow", nil, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idDamage2",
              "HAlign",
              "left",
              "VAlign",
              "bottom",
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
              "bottom",
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
          box(14, 5, 14, 5),
          "VAlign",
          "top",
          "MinWidth",
          350,
          "LayoutMethod",
          "VList",
          "Background",
          RGBA(32, 35, 47, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idText",
            "Clip",
            false,
            "UseClipBox",
            false,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverText",
            "Translate",
            true,
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idHint",
            "Margins",
            box(2, 0, 0, 0),
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverTextHint",
            "Translate",
            true,
            "HideOnEmpty",
            true
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {"__template", "MoreInfo"})
    })
  })
})
