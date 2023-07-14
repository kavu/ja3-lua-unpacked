PlaceObj("XTemplate", {
  __is_kind_of = "XContextControl",
  group = "Zulu",
  id = "RolloverInventoryWeaponBase",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextControl",
    "Id",
    "idContent",
    "Padding",
    box(6, 6, 6, 6),
    "VAlign",
    "top",
    "MinWidth",
    350,
    "MaxWidth",
    370,
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
      local title = context.RolloverTitle ~= "" and context.RolloverTitle or control:GetRolloverTitle()
      self.idTitle:SetText(title)
      if rawget(self, "idText") then
        local description = context.Description ~= "" and context.Description or ""
        self.idText:SetText(description)
      end
      local item = ResolvePropObj(context)
      local hint = item:GetRolloverHint()
      local ctrl_hint = control:GetRolloverHint()
      self.idItemHint:SetText(hint or "")
      self.idItemHint.parent:SetVisible(hint and hint ~= "")
      local embed = GetParentOfKind(context.control, "XInventoryItemEmbed")
      if embed and embed.ShowOwner then
        local itemOwner = item.owner
        local ud = gv_UnitData[itemOwner]
        if ud then
          self.idTitle:SetText(T({
            185880247892,
            "<name> (<owner>)",
            name = title,
            owner = ud.Nick
          }))
        end
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
    PlaceObj("XTemplateWindow", {
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
        "comment",
        "ap indicator",
        "__condition",
        function(parent, context)
          local cnt = ResolvePropObj(context)
          return cnt:IsWeapon() or IsKindOfClasses(cnt, "Grenade")
        end,
        "__class",
        "XText",
        "RolloverTemplate",
        "PDAPerkRollover",
        "Dock",
        "right",
        "HAlign",
        "right",
        "VAlign",
        "top",
        "Clip",
        false,
        "UseClipBox",
        false,
        "TextStyle",
        "PDARolloverHeaderBeige",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local cnt = ResolvePropObj(self.context)
          local list_APs = {"AttackAP", "ShootAP"}
          local val = false
          for _, item_ap in ipairs(list_APs) do
            local item = Presets.WeaponPropertyDef.Default[item_ap]
            if item:DisplayForContext(cnt) then
              val = item:GetProp(cnt)
            end
          end
          self:SetText(T({
            519320974014,
            "<apn(ap)> <style PDARolloverHeaderDark>AP</style>",
            ap = val
          }))
          XContextControl.OnContextUpdate(self, context)
        end,
        "Translate",
        true,
        "TextHAlign",
        "right",
        "TextVAlign",
        "bottom"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idTitle",
        "Margins",
        box(10, 0, 0, 0),
        "Dock",
        "left",
        "HAlign",
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
      })
    }),
    PlaceObj("XTemplateWindow", {
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "dmg, crit,range",
        "__context",
        function(parent, context)
          return ResolvePropObj(context)
        end,
        "Padding",
        box(12, 0, 12, 0),
        "MinHeight",
        34,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return Presets.WeaponPropertyDef.Default
          end,
          "condition",
          function(parent, context, item, i)
            return item.show_in_inventory and item:DisplayForContext(context)
          end,
          "run_after",
          function(child, context, item, i, n, last)
            local align = n == 1 and "left" or n == 3 and "right"
            if IsKindOf(context, "Armor") and n == 2 then
              align = "right"
            end
            child:SetDock(align)
            child[1]:SetHAlign(align or "left")
            if n == 3 then
              child.parent[2][1]:SetHAlign("center")
            end
            child:SetBindTo(item.bind_to, item.id)
            child.idText:SetTextStyle("PDAActivitiesButtonSmall")
            child.idText:SetMargins(box(0, 0, 0, 1))
            if item.bind_to == "CritChance" or item.bind_to == "SumDamageReduction" or item.bind_to == "DamageReduction" or item.bind_to == "AdditionalReduction" then
              child:SetPercentValue(true)
            end
            if (item.bind_to == "Damage" or item.bind_to == "CritChance") and IsKindOf(context, "HeavyWeapon") then
              child:SetPercentValue(false)
              function child:CreatePropValText(value, scale)
                return Untranslated("-")
              end
            end
            if item.bind_to == "Damage" and IsKindOf(context, "Firearm") then
              local action = CombatActions[context.AvailableAttacks[1]]
              action = action or CombatActions[context:GetBaseAttack()]
              local shot_count = context:GetAutofireShots(action)
              if shot_count and 0 < shot_count then
                function child:CreatePropValText(value, scale)
                  local totalDmg, dmg = 0, 0
                  local unit
                  if context.owner then
                    unit = g_Units[context.owner] or gv_UnitData[context.owner]
                  else
                    unit = SelectedObj
                  end
                  if unit then
                    totalDmg, dmg = action:GetActionDamage(unit, false, {weapon = context})
                    dmg = dmg or totalDmg
                  end
                  return Untranslated(totalDmg / Max(1, dmg) .. "<valign bottom -3><style InventoryRolloverPropSmall>x</style><valign center>" .. dmg)
                end
              end
            end
            if item.bind_to == "BaseRange" and IsKindOf(context, "Ordnance") then
              function child:CreatePropValText(value, scale)
                return Untranslated("-")
              end
            end
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "RolloverPropText",
            "HAlign",
            "left",
            "VAlign",
            "top",
            "MinWidth",
            100
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextWindow",
        "Margins",
        box(0, 6, 0, 0),
        "Padding",
        box(12, 3, 12, 3),
        "MinHeight",
        34,
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        -3,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "stat",
          "__condition",
          function(parent, context)
            return context.UnitStat and context.owner
          end,
          "__template",
          "RolloverPropTextRight"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self,...)",
            "func",
            function(self, ...)
              XPropControl.Open(self, ...)
              local unit_id = self:GetContext().owner
              local unit = g_Units[unit_id]
              local unit_data = gv_UnitData[unit_id]
              unit = (gv_SatelliteView or not unit) and unit_data or unit
              if not unit then
                return
              end
              local context = self:GetContext()
              local cnt = ResolvePropObj(context)
              local stat = table.find_value(UnitPropertiesStats:GetProperties(), "id", cnt.UnitStat)
              self.idPropVal:SetNameText(stat.name)
              self.idPropVal:SetValueText(T({
                525167855692,
                "<style PDABrowserFlavorMedium>(<unit>)</style> <value>",
                unit = unit.Nick,
                value = unit[stat.id]
              }))
            end
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "penetration",
          "__template",
          "RolloverPropTextRight",
          "OnLayoutComplete",
          function(self)
            self.idPropVal:SetTextStyle("PDABrowserFlavorMedium")
            self.idPropVal:SetTextStyleRight("PDAActivityDescriptionWounds")
          end,
          "BindTo",
          "PenetrationClass"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "CreatePropValText(self, value, scale)",
            "func",
            function(self, value, scale)
              return GetPenetrationClassUIText(value)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self,...)",
            "func",
            function(self, ...)
              self.idPropVal:SetTextStyle("PDABrowserFlavorMedium")
              self.idPropVal:SetTextStyleRight("PDAActivityDescriptionWounds")
              XPropControl.Open(self, ...)
              local cnt = ResolvePropObj(self.context)
              if IsKindOf(cnt, "Armor") then
                self.idPropVal:SetNameText(T(562386972389, "Penetration Protection"))
              end
            end
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "DR penetration",
          "__condition",
          function(parent, context)
            local cnt = ResolvePropObj(context)
            return IsKindOf(cnt, "Armor")
          end,
          "__template",
          "RolloverPropTextRight",
          "OnLayoutComplete",
          function(self)
            self.idPropVal:SetTextStyle("PDABrowserFlavorMedium")
            self.idPropVal:SetTextStyleRight("PDAActivityDescriptionWounds")
          end,
          "BindTo",
          "DamageReduction",
          "PercentValue",
          true
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self,...)",
            "func",
            function(self, ...)
              self.idPropVal:SetTextStyle("PDABrowserFlavorMedium")
              self.idPropVal:SetTextStyleRight("PDAActivityDescriptionWounds")
              XPropControl.Open(self, ...)
            end
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "condition",
          "__condition",
          function(parent, context)
            return context[1] and context[1]:HasCondition()
          end,
          "__template",
          "RolloverPropTextRight",
          "BindTo",
          "Condition",
          "PercentValue",
          true
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self,...)",
            "func",
            function(self, ...)
              XPropControl.Open(self, ...)
              local context = self:GetContext()
              local cnt = ResolvePropObj(context)
              self.idPropVal:SetNameText(T(818236076302, "Condition"))
              local condition_percent = cnt:GetConditionPercent()
              local text = cnt:GetConditionKeywordNoPrefix()
              self.idPropVal:SetValueText(T({
                541139041647,
                "<keyword> (<percent(condPercent)>)",
                keyword = text,
                condPercent = condition_percent
              }))
            end
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "broken,jummed",
        "__condition",
        function(parent, context)
          local weapon = ResolvePropObj(context)
          return not IsKindOf(weapon, "Firearm") or weapon.jammed or weapon:IsCondition("Broken")
        end,
        "__class",
        "XContextWindow",
        "IdNode",
        true,
        "Margins",
        box(0, 6, 0, 0),
        "Padding",
        box(8, 8, 8, 8),
        "LayoutMethod",
        "VList",
        "Background",
        RGBA(32, 35, 47, 255),
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local weapon = ResolvePropObj(context)
          local term
          if weapon:IsCondition("Broken") then
            term = "Broken"
          elseif weapon.jammed then
            term = "Jammed"
          end
          if term then
            local preset = Presets.GameTerm.Default[term]
            self.idStatus:SetText(preset.Name)
            self.idStatusDescription:SetText(preset.Description)
          end
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idStatus",
          "TextStyle",
          "ConflictPowerDiff",
          "Translate",
          true
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idStatusDescription",
          "TextStyle",
          "RolloverTextItalic",
          "Translate",
          true
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 6, 0, 0),
        "Padding",
        box(6, 4, 6, 4),
        "MinHeight",
        34,
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        -2,
        "FoldWhenHidden",
        true,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idItemHint",
          "Margins",
          box(10, 0, 0, 0),
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "TextStyle",
          "InventoryRolloverHint",
          "Translate",
          true,
          "HideOnEmpty",
          true
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "ammo",
        "__condition",
        function(parent, context)
          local cnt = ResolvePropObj(context)
          return cnt and IsKindOf(cnt, "Firearm")
        end,
        "Margins",
        box(0, 6, 0, 0),
        "Padding",
        box(6, 4, 10, 4),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        -2,
        "FoldWhenHidden",
        true,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "ammo",
          "__class",
          "XContextWindow",
          "IdNode",
          true,
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local cnt = ResolvePropObj(context)
            local caliber = Presets.Caliber.Default[cnt.Caliber]
            if cnt.ammo then
              self.idAmmoIcon:SetImage(cnt.ammo.Icon)
            else
              self.idAmmoIcon:SetImage("UI/Icons/Items/" .. caliber.id .. "_empty")
            end
            if cnt.ammo then
              self.idWeaponTypeCaliber:SetText(T({
                571030717647,
                "<name>",
                name = cnt.ammo.DisplayName
              }))
            else
              self.idWeaponTypeCaliber:SetText(T({
                106798463585,
                "Empty <name>",
                name = Presets.Caliber.Default[cnt.Caliber].Name
              }))
            end
            self.idAmount:SetContext(cnt)
            self.idAmount:SetText(cnt:GetItemSlotUI())
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextImage",
            "Id",
            "idAmmoIcon",
            "Dock",
            "left",
            "HAlign",
            "left",
            "ImageScale",
            point(300, 300)
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idWeaponTypeCaliber",
            "Margins",
            box(3, 0, 0, 0),
            "VAlign",
            "center",
            "HandleMouse",
            false,
            "ChildrenHandleMouse",
            false,
            "TextStyle",
            "PDABrowserFlavorMedium",
            "Translate",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idAmount",
            "Dock",
            "right",
            "HAlign",
            "right",
            "VAlign",
            "center",
            "HandleMouse",
            false,
            "ChildrenHandleMouse",
            false,
            "TextStyle",
            "InventoryItemsCountRollvoer",
            "Translate",
            true,
            "TextHAlign",
            "right"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "ammo",
          "__condition",
          function(parent, context)
            local weapon = ResolvePropObj(context)
            return IsKindOf(weapon, "FirearmBase") and weapon:GetSubweapon("Firearm")
          end,
          "__class",
          "XContextWindow",
          "IdNode",
          true,
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local weapon = ResolvePropObj(context)
            local cnt = IsKindOf(weapon, "FirearmBase") and weapon:GetSubweapon("Firearm")
            local caliber = Presets.Caliber.Default[cnt.Caliber]
            if cnt.ammo then
              self.idAmmoIcon:SetImage(cnt.ammo.Icon)
            else
              self.idAmmoIcon:SetImage("UI/Icons/Items/" .. caliber.id .. "_empty")
            end
            if cnt.ammo then
              self.idWeaponTypeCaliber:SetText(T({
                571030717647,
                "<name>",
                name = cnt.ammo.DisplayName
              }))
            else
              self.idWeaponTypeCaliber:SetText(T({
                106798463585,
                "Empty <name>",
                name = Presets.Caliber.Default[cnt.Caliber].Name
              }))
            end
            self.idAmount:SetContext(cnt)
            self.idAmount:SetText(cnt:GetItemSlotUI())
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextImage",
            "Id",
            "idAmmoIcon",
            "Dock",
            "left",
            "HAlign",
            "left",
            "ImageScale",
            point(300, 300)
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idWeaponTypeCaliber",
            "Margins",
            box(3, 0, 0, 0),
            "VAlign",
            "center",
            "HandleMouse",
            false,
            "ChildrenHandleMouse",
            false,
            "TextStyle",
            "PDABrowserFlavorMedium",
            "Translate",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idAmount",
            "Dock",
            "right",
            "HAlign",
            "right",
            "VAlign",
            "center",
            "HandleMouse",
            false,
            "ChildrenHandleMouse",
            false,
            "TextStyle",
            "InventoryItemsCountRollvoer",
            "Translate",
            true,
            "TextHAlign",
            "right"
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "modifications",
        "__condition",
        function(parent, context)
          return #(GetWeaponUpgrades(context) or empty_table) > 0
        end,
        "LayoutMethod",
        "VList",
        "FoldWhenHidden",
        true
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idModifications",
          "Margins",
          box(10, 0, 0, 0),
          "VAlign",
          "center",
          "MinHeight",
          34,
          "TextStyle",
          "PDABrowserNameSmall",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local count, max = CountWeaponUpgrades(context)
            self:SetText(T({
              778177921915,
              "MODIFICATIONS <right><style PDABrowserSubtitleLight><count></style><style PDABrowserSubtitle>/<max></style>",
              count = count,
              max = max
            }))
          end,
          "Translate",
          true,
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "modifications",
          "LayoutMethod",
          "HWrap",
          "LayoutHSpacing",
          8,
          "LayoutVSpacing",
          8,
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateForEach", {
            "array",
            function(parent, context)
              return GetWeaponUpgrades(context)
            end,
            "run_after",
            function(child, context, item, i, n, last)
              local obj = ResolvePropObj(context)
              local component = WeaponComponents[item.component]
              if component then
                local icon = GetWeaponComponentIcon(component, obj)
                child.idIcon:SetImage(icon)
              else
                local defaultImg = "UI/Icons/Upgrades/default_" .. string.lower(item.slot)
                child.idIcon:SetImage(defaultImg)
              end
              local positive, negative, neutral
              local modifications = component and component.Modifications
              for _, mod in ipairs(modifications) do
                local prop_id = mod.target_prop
                local preset = Presets.WeaponPropertyDef.Default[prop_id]
                if preset then
                  local val_base = preset and preset:Getbase_Prop(obj, obj.owner) or obj["base_" .. prop_id] or 0
                  local value = preset and preset:GetProp(obj, obj.owner) or obj[prop_id] or 0
                  if IsKindOf(obj, "HeavyWeapon") and prop_id == "Damage" then
                    value = obj:GetBaseDamage()
                    val_base = obj:GetBaseDamage()
                  end
                  if preset and preset.reverse_bar then
                    value = preset.max_progress - value
                    val_base = preset.max_progress - val_base
                  end
                  if value == val_base then
                  elseif value > val_base then
                    if negative then
                      neutral = true
                      break
                    else
                      positive = true
                    end
                  elseif value < val_base then
                    if positive then
                      neutral = true
                      break
                    else
                      negative = true
                    end
                  end
                end
              end
              child.idModArrow:SetVisible(not neutral and (positive or negative))
              if not neutral then
                if positive then
                  child.idModArrow:SetImage("UI/Inventory/mod_positive")
                  child.idModArrow:SetFlipY(true)
                end
                if negative then
                  child.idModArrow:SetImage("UI/Inventory/mod_negative")
                end
              end
            end
          }, {
            PlaceObj("XTemplateWindow", {"IdNode", true}, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "MinWidth",
                80,
                "MinHeight",
                80,
                "MaxWidth",
                80,
                "MaxHeight",
                80,
                "FoldWhenHidden",
                true,
                "Image",
                "UI/Inventory/T_Backpack_Slot_Small"
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idIcon",
                "IdNode",
                false,
                "MinWidth",
                80,
                "MinHeight",
                80,
                "MaxWidth",
                80,
                "MaxHeight",
                80,
                "FoldWhenHidden",
                true,
                "ImageScale",
                point(700, 700)
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XImage",
                  "Id",
                  "idModArrow",
                  "Margins",
                  box(4, 4, 4, 4),
                  "HAlign",
                  "right",
                  "VAlign",
                  "top",
                  "MinWidth",
                  20,
                  "MinHeight",
                  12,
                  "MaxWidth",
                  20,
                  "MaxHeight",
                  12,
                  "Image",
                  "UI/Inventory/mod_negative"
                })
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "locked",
        "__condition",
        function(parent, context)
          local cnt = ResolvePropObj(context)
          return cnt.locked
        end,
        "Margins",
        box(0, 6, 0, 0),
        "Padding",
        box(6, 4, 10, 4),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        -2,
        "FoldWhenHidden",
        true,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextWindow",
          "IdNode",
          true,
          "Margins",
          box(5, 5, 5, 5),
          "ContextUpdateOnOpen",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idLockedIcon",
            "Dock",
            "left",
            "HAlign",
            "left",
            "ScaleModifier",
            point(700, 700),
            "Image",
            "UI/Inventory/padlock",
            "ImageColor",
            RGBA(191, 67, 77, 255)
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idLockedText",
            "Margins",
            box(10, 0, 0, 0),
            "HandleMouse",
            false,
            "ChildrenHandleMouse",
            false,
            "TextStyle",
            "RolloverTextItalicRed",
            "Translate",
            true,
            "Text",
            T(617713229226, "You can't move this item")
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "__condition",
        function(parent, context)
          return not InventoryIsCompareMode()
        end,
        "__template",
        "MoreInfo"
      })
    })
  })
})
