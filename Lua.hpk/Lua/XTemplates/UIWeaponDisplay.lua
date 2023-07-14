PlaceObj("XTemplate", {
  __is_kind_of = "XContentTemplate",
  group = "Zulu",
  id = "UIWeaponDisplay",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return "hud weapon context"
    end,
    "__class",
    "XContentTemplate",
    "Id",
    "idWeaponUI",
    "HAlign",
    "left"
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "selection observer",
      "__context",
      function(parent, context)
        return "hud_squads"
      end,
      "__class",
      "XContextWindow",
      "ZOrder",
      99,
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:OnContextUpdate(self.parent.context)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "inventory observer",
      "__context",
      function(parent, context)
        return Selection and Selection[1] and Selection[1].Inventory
      end,
      "__class",
      "XContextWindow",
      "ZOrder",
      98,
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:OnContextUpdate(self.parent.context)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "unit observer",
      "__context",
      function(parent, context)
        return Selection and Selection[1] and Selection[1]
      end,
      "__class",
      "XContextWindow",
      "ZOrder",
      98,
      "OnContextUpdate",
      function(self, context, ...)
        self.parent:OnContextUpdate(self.parent.context)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return Selection and #Selection > 0 and IsKindOf(Selection[1], "Unit") and Selection[1]
      end,
      "__condition",
      function(parent, context)
        return context
      end,
      "__class",
      "XContextWindow",
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return GetUnitWeapons(context, "otherSet")
        end,
        "__class",
        "XContextWindow",
        "Id",
        "idOtherSets",
        "BorderWidth",
        2,
        "HAlign",
        "left",
        "LayoutMethod",
        "HList",
        "Visible",
        false,
        "BorderColor",
        RGBA(52, 55, 61, 180),
        "Background",
        RGBA(32, 35, 47, 180)
      }, {
        PlaceObj("XTemplateForEach", {
          "comment",
          "weapon",
          "array",
          function(parent, context)
            return #context == 0 and {
              Selection[1]:GetActiveWeapons("UnarmedWeapon")
            } or context
          end,
          "condition",
          function(parent, context, item, i)
            return item
          end,
          "__context",
          function(parent, context, item, i, n)
            return item
          end,
          "run_after",
          function(child, context, item, i, n, last)
            local itemIcon = child.idIcon
            itemIcon:SetImage(item.Icon)
            itemIcon:SetMinHeight(HUDButtonHeight)
            itemIcon:SetMaxHeight(HUDButtonHeight)
            local warningText = child.idWarningText
            local button = child.idFrame
            if item.LargeItem then
              itemIcon:SetMaxWidth(155)
            else
              itemIcon:SetMaxWidth(77)
            end
            warningText:SetMaxWidth(itemIcon.MaxWidth)
            local reloadables = GetReloadOptionsForWeapon(item, false, "skipSubWeapon")
            local count = GetBulletCount(item)
            local is_firearm = IsKindOf(item, "Firearm")
            if is_firearm and item.jammed and not item:IsCondition("Broken") then
              warningText:SetText(T(276505585210, "JAMMED"))
              itemIcon:SetDesaturation(255)
              itemIcon:SetTransparency(50)
              warningText:SetVisible(true)
            elseif is_firearm and item:IsCondition("Broken") then
              warningText:SetText(T(623193685060, "BROKEN"))
              itemIcon:SetDesaturation(255)
              itemIcon:SetTransparency(50)
              warningText:SetVisible(true)
            elseif count and count == 0 then
              if not reloadables or #reloadables == 0 then
                warningText:SetText(T(669866061827, "No Ammo"))
                itemIcon:SetDesaturation(255)
                itemIcon:SetTransparency(50)
              else
                warningText:SetText(T(402669531723, "RELOAD"))
                itemIcon:SetDesaturation(255)
                itemIcon:SetTransparency(50)
              end
              warningText:SetVisible(true)
            elseif is_firearm and item:GetSubweapon("GrenadeLauncher") and GetBulletCount(item:GetSubweapon("GrenadeLauncher")) == 0 then
              warningText:SetText(T(693636719988, "NO GRENADE"))
              itemIcon:SetDesaturation(255)
              itemIcon:SetTransparency(50)
              warningText:SetVisible(true)
            end
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "IdNode",
            true
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "RolloverTemplate",
              "RolloverInventory",
              "RolloverAnchor",
              "custom",
              "RolloverText",
              T(840234458060, "placeholder"),
              "RolloverOffset",
              box(0, 0, 0, 20),
              "Id",
              "idIcon",
              "Padding",
              box(5, 0, 5, 0),
              "HandleMouse",
              true,
              "ImageFit",
              "width"
            }, {
              PlaceObj("XTemplateWindow", {
                "__condition",
                function(parent, context)
                  return context:IsWeapon() and context.ComponentSlots and #context.ComponentSlots > 0 and 0 < CountWeaponUpgrades(context)
                end,
                "__class",
                "XImage",
                "RolloverText",
                T(370682405601, "placeholder"),
                "Id",
                "idModIcon",
                "Margins",
                box(5, 8, 0, 0),
                "HAlign",
                "left",
                "VAlign",
                "top",
                "ScaleModifier",
                point(600, 600),
                "Image",
                "UI/Inventory/w_mod"
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextWindow",
              "Margins",
              box(0, 0, 3, 0),
              "HAlign",
              "right",
              "VAlign",
              "bottom",
              "LayoutMethod",
              "VList",
              "LayoutVSpacing",
              -5
            }, {
              PlaceObj("XTemplateForEach", {
                "comment",
                "subweapons",
                "array",
                function(parent, context)
                  return IsKindOf(context, "FirearmBase") and table.values(context.subweapons)
                end,
                "condition",
                function(parent, context, item, i)
                  return context
                end,
                "__context",
                function(parent, context, item, i, n)
                  return item
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XContextWindow",
                  "IdNode",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Padding",
                    box(2, 2, 2, 0),
                    "HAlign",
                    "right",
                    "TextStyle",
                    "HUDHeader",
                    "Translate",
                    true,
                    "Text",
                    T(151637075934, "<bullets()>")
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idAmmo",
                "Padding",
                box(2, 2, 2, 0),
                "TextStyle",
                "HUDHeader",
                "Translate",
                true,
                "Text",
                T(151637075934, "<bullets()>")
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XTextWithStyleBasedOnSize",
              "Id",
              "idWarningText",
              "HAlign",
              "center",
              "VAlign",
              "center",
              "MaxWidth",
              200,
              "Visible",
              false,
              "DrawOnTop",
              true,
              "HandleMouse",
              false,
              "TextStyle",
              "DescriptionTextRedGlow16",
              "Translate",
              true,
              "TextHAlign",
              "center",
              "TextVAlign",
              "bottom",
              "TextStyleSmall",
              "DescriptionTextRedGlow_Small"
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextWindow",
        "Id",
        "idEquippedSet",
        "IdNode",
        true,
        "VAlign",
        "bottom",
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        10
      }, {
        PlaceObj("XTemplateTemplate", {
          "__template",
          "GenericHUDButtonFrame",
          "Id",
          "idFrame",
          "IdNode",
          false,
          "VAlign",
          "stretch"
        }, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idButtons",
            "Margins",
            box(0, 0, -2, -2),
            "Dock",
            "right",
            "LayoutMethod",
            "Grid",
            "UniformRowHeight",
            true,
            "Background",
            RGBA(52, 55, 60, 255),
            "BackgroundRectGlowSize",
            1,
            "BackgroundRectGlowColor",
            RGBA(52, 55, 60, 255)
          }, {
            PlaceObj("XTemplateWindow", {
              "__context",
              function(parent, context)
                return {
                  action = CombatActions.ChangeWeapon
                }
              end,
              "__class",
              "XButton",
              "RolloverTemplate",
              "CombatActionRollover",
              "RolloverAnchor",
              "bottom-right",
              "RolloverAnchorId",
              "idWeaponUI",
              "RolloverOffset",
              box(20, 0, 0, 0),
              "Id",
              "idSwitch",
              "Margins",
              box(0, -2, 0, 0),
              "BorderWidth",
              2,
              "Padding",
              box(3, 0, 3, 0),
              "MinWidth",
              25,
              "BorderColor",
              RGBA(52, 55, 61, 255),
              "Background",
              RGBA(32, 35, 47, 255),
              "OnContextUpdate",
              function(self, context, ...)
                local combat_action = self.context.action
                local rolloverText = combat_action:GetActionDescription(Selection)
                self:SetRolloverText(rolloverText)
                local actionName = combat_action:GetActionDisplayName(Selection)
                self:SetRolloverTitle(actionName)
                self:SetEnabled(combat_action:GetUIState(Selection) == "enabled")
                do return end
                local unit = Selection and Selection[1]
                local firstSet = unit and unit.current_weapon == "Handheld A"
                if firstSet then
                  self.idIcon:SetImage("UI/Hud/weapon_loadout_2")
                else
                  self.idIcon:SetImage("UI/Hud/weapon_loadout_1")
                end
              end,
              "FXMouseIn",
              "buttonRollover",
              "FXPress",
              "ChangeWeapon",
              "FXPressDisabled",
              "IactDisabled",
              "FocusedBackground",
              RGBA(0, 0, 0, 0),
              "DisabledBorderColor",
              RGBA(52, 55, 61, 255),
              "DisabledBackground",
              RGBA(32, 35, 47, 125),
              "OnPress",
              function(self, gamepad)
                if #(Selection or "") > 0 then
                  self.context.action:UIBegin({
                    Selection[1]
                  })
                end
              end,
              "RolloverBackground",
              RGBA(0, 0, 0, 0),
              "PressedBackground",
              RGBA(0, 0, 0, 0)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XImage",
                "Id",
                "idIcon",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "Image",
                "UI/Hud/weapon_switch",
                "ImageColor",
                RGBA(195, 189, 172, 255)
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnSetRollover(self, rollover)",
                "func",
                function(self, rollover)
                  local node = self:ResolveId("node"):ResolveId("node")
                  if node.idOtherSets then
                    node.idOtherSets:SetVisible(rollover)
                  end
                  XButton.OnSetRollover(self, rollover)
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "SetEnabled(self, enabled)",
                "func",
                function(self, enabled)
                  XButton.SetEnabled(self, enabled)
                  self.idIcon:SetTransparency(enabled and 0 or 160)
                end
              })
            }),
            PlaceObj("XTemplateForEach", {
              "comment",
              "weapon, for reload buttons",
              "array",
              function(parent, context)
                return GetUnitWeapons(context)
              end,
              "condition",
              function(parent, context, item, i)
                return item and not not GetBulletCount(item) and item:IsWeapon() and not item.parent_weapon and item.ReloadAP
              end,
              "__context",
              function(parent, context, item, i, n)
                return item
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child:SetGridY(#child.parent)
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContextWindow",
                "IdNode",
                true,
                "LayoutMethod",
                "Grid"
              }, {
                PlaceObj("XTemplateForEach", {
                  "comment",
                  "subweapons",
                  "array",
                  function(parent, context)
                    return IsKindOf(context, "FirearmBase") and table.values(context.subweapons)
                  end,
                  "condition",
                  function(parent, context, item, i)
                    return context
                  end,
                  "__context",
                  function(parent, context, item, i, n)
                    return item
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    child:SetGridY(1 + i)
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XContextWindow",
                    "IdNode",
                    true
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__context",
                      function(parent, context)
                        return {
                          action = CombatActions.Reload,
                          item_id = parent.context and parent.context.id
                        }
                      end,
                      "__class",
                      "XButton",
                      "RolloverTemplate",
                      "CombatActionRollover",
                      "RolloverAnchor",
                      "bottom-right",
                      "RolloverAnchorId",
                      "idWeaponUI",
                      "RolloverOffset",
                      box(20, 0, 0, 0),
                      "RolloverTitle",
                      T(338106303761, "Reload"),
                      "Id",
                      "idSubReloadButton",
                      "Margins",
                      box(0, -2, 0, 0),
                      "BorderWidth",
                      2,
                      "Padding",
                      box(3, 0, 3, 0),
                      "MinWidth",
                      25,
                      "BorderColor",
                      RGBA(52, 55, 61, 255),
                      "Background",
                      RGBA(32, 35, 47, 255),
                      "OnContextUpdate",
                      function(self, context, ...)
                        local weapon = self:ResolveId("node").context
                        local wepIdx, ammo = GetQuickReloadWeaponAndAmmo(self, weapon)
                        local bullets = GetBulletCount(weapon)
                        local item = weapon
                        while item.parent_weapon do
                          item = item.parent_weapon
                        end
                        local units = Selection
                        if item and item.owner then
                          local owner = g_Units[item.owner]
                          if owner then
                            units = {owner}
                          end
                        end
                        local full = bullets == weapon.MagazineSize
                        local canReload = not full and wepIdx
                        local enabled = canReload and CombatActions.Reload:GetVisibility(units) == "enabled"
                        self:SetEnabled(enabled)
                      end,
                      "FXMouseIn",
                      "buttonRollover",
                      "FXPress",
                      "buttonPressGeneric",
                      "FXPressDisabled",
                      "IactDisabled",
                      "FocusedBorderColor",
                      RGBA(0, 0, 0, 0),
                      "FocusedBackground",
                      RGBA(0, 0, 0, 0),
                      "DisabledBorderColor",
                      RGBA(52, 55, 61, 255),
                      "DisabledBackground",
                      RGBA(32, 35, 47, 125),
                      "OnPress",
                      function(self, gamepad)
                        local weapon = self:ResolveId("node").context
                        QuickReloadButton(self, weapon)
                      end,
                      "RolloverBackground",
                      RGBA(0, 0, 0, 0),
                      "PressedBackground",
                      RGBA(0, 0, 0, 0)
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XImage",
                        "Id",
                        "idIcon",
                        "HAlign",
                        "center",
                        "VAlign",
                        "center",
                        "Image",
                        "UI/Hud/weapon_reload",
                        "ImageColor",
                        RGBA(195, 189, 172, 255)
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "SetEnabled(self, enabled)",
                        "func",
                        function(self, enabled)
                          XButton.SetEnabled(self, enabled)
                          self.idIcon:SetTransparency(enabled and 0 or 160)
                        end
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "GetRolloverText(self)",
                        "func",
                        function(self)
                          local weapon = self:ResolveId("node").context
                          local wepIdx, ammo = GetQuickReloadWeaponAndAmmo(self, weapon)
                          if not wepIdx then
                            return "placeholder"
                          end
                          return T({
                            432670943615,
                            "Reload with <DisplayName>",
                            ammo
                          })
                        end
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "GetRolloverTitle(self)",
                        "func",
                        function(self)
                          local weapon = self:ResolveId("node").context
                          return T({
                            470526619797,
                            "Reload <DisplayName>",
                            weapon
                          })
                        end
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "GetRolloverHint(self)",
                        "func",
                        function(self)
                          local weapon = self:ResolveId("node").context
                          local wepIdx, err = GetQuickReloadWeaponAndAmmo(self, weapon)
                          if not wepIdx and err then
                            return err
                          end
                          local state, err = CombatActions.Reload:GetVisibility({
                            SelectedObj
                          })
                          return state ~= "enabled" and err
                        end
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__context",
                  function(parent, context)
                    return {
                      action = CombatActions.Reload
                    }
                  end,
                  "__class",
                  "XButton",
                  "RolloverTemplate",
                  "CombatActionRollover",
                  "RolloverAnchor",
                  "bottom-right",
                  "RolloverAnchorId",
                  "idWeaponUI",
                  "RolloverOffset",
                  box(20, 0, 0, 0),
                  "Id",
                  "idReloadButton",
                  "Margins",
                  box(0, -2, 0, 0),
                  "BorderWidth",
                  2,
                  "Padding",
                  box(3, 0, 3, 0),
                  "MinWidth",
                  25,
                  "FoldWhenHidden",
                  true,
                  "BorderColor",
                  RGBA(52, 55, 61, 255),
                  "Background",
                  RGBA(32, 35, 47, 255),
                  "OnContextUpdate",
                  function(self, context, ...)
                    local weaponContainer = self:ResolveId("node")
                    local unitContainer = weaponContainer:ResolveId("node")
                    local unit = unitContainer.context
                    local weapon = weaponContainer.context
                    local wepIdx, ammo = GetQuickReloadWeaponAndAmmo(self, weapon)
                    local bullets = GetBulletCount(weapon)
                    local full = bullets == weapon.MagazineSize
                    local canReload = not full and wepIdx
                    local enabled = canReload and CombatActions.Reload:GetVisibility({unit}) == "enabled"
                    self:SetEnabled(enabled)
                    self:SetGridY(#self.parent + 1)
                  end,
                  "FXMouseIn",
                  "buttonRollover",
                  "FXPress",
                  "buttonPressGeneric",
                  "FXPressDisabled",
                  "IactDisabled",
                  "FocusedBorderColor",
                  RGBA(0, 0, 0, 0),
                  "FocusedBackground",
                  RGBA(0, 0, 0, 0),
                  "DisabledBorderColor",
                  RGBA(52, 55, 61, 255),
                  "DisabledBackground",
                  RGBA(32, 35, 47, 125),
                  "OnPress",
                  function(self, gamepad)
                    local weapon = self:ResolveId("node").context
                    QuickReloadButton(self, weapon)
                  end,
                  "RolloverBackground",
                  RGBA(0, 0, 0, 0),
                  "PressedBackground",
                  RGBA(0, 0, 0, 0)
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XImage",
                    "Id",
                    "idIcon",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "Image",
                    "UI/Hud/weapon_reload",
                    "ImageColor",
                    RGBA(195, 189, 172, 255)
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "SetEnabled(self, enabled)",
                    "func",
                    function(self, enabled)
                      XButton.SetEnabled(self, enabled)
                      self.idIcon:SetTransparency(enabled and 0 or 160)
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "GetRolloverText(self)",
                    "func",
                    function(self)
                      local weapon = self:ResolveId("node").context
                      local wepIdx, ammo = GetQuickReloadWeaponAndAmmo(self, weapon)
                      if not wepIdx then
                        return "placeholder"
                      end
                      return T({
                        432670943615,
                        "Reload with <DisplayName>",
                        ammo
                      })
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "GetRolloverTitle(self)",
                    "func",
                    function(self)
                      local weapon = self:ResolveId("node").context
                      return T({
                        470526619797,
                        "Reload <DisplayName>",
                        weapon
                      })
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "GetRolloverHint(self)",
                    "func",
                    function(self)
                      local weapon = self:ResolveId("node").context
                      local wepIdx, err = GetQuickReloadWeaponAndAmmo(self, weapon)
                      if not wepIdx and err then
                        return err
                      end
                      local state, err = CombatActions.Reload:GetVisibility({
                        SelectedObj
                      })
                      return state ~= "enabled" and err
                    end
                  })
                }),
                PlaceObj("XTemplateCode", {
                  "run",
                  function(self, parent, context)
                    parent:SetGridHeight(#parent)
                  end
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__condition",
              function(parent, context)
                return #parent == 1
              end,
              "__class",
              "XContextWindow",
              "IdNode",
              true,
              "GridY",
              2
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XButton",
                "RolloverTemplate",
                "CombatActionRollover",
                "RolloverAnchor",
                "right",
                "RolloverAnchorId",
                "idWeapon",
                "RolloverOffset",
                box(20, 0, 0, 0),
                "Margins",
                box(0, -2, 0, 0),
                "BorderWidth",
                2,
                "Padding",
                box(3, 0, 3, 0),
                "MinWidth",
                25,
                "Visible",
                false,
                "BorderColor",
                RGBA(52, 55, 61, 255),
                "Background",
                RGBA(32, 35, 47, 255),
                "Enabled",
                false,
                "FocusedBorderColor",
                RGBA(0, 0, 0, 0),
                "FocusedBackground",
                RGBA(0, 0, 0, 0),
                "DisabledBorderColor",
                RGBA(52, 55, 61, 255),
                "DisabledBackground",
                RGBA(32, 35, 47, 125),
                "RolloverBackground",
                RGBA(0, 0, 0, 0),
                "PressedBackground",
                RGBA(0, 0, 0, 0)
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__context",
            function(parent, context)
              return GetUnitWeapons(context)
            end,
            "__class",
            "XContextWindow",
            "Dock",
            "box"
          }, {
            PlaceObj("XTemplateWindow", {
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateForEach", {
                "comment",
                "weapon",
                "array",
                function(parent, context)
                  return #context == 0 and {
                    Selection[1]:GetActiveWeapons("UnarmedWeapon")
                  } or context
                end,
                "condition",
                function(parent, context, item, i)
                  return not item.parent_weapon
                end,
                "__context",
                function(parent, context, item, i, n)
                  return item
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  local itemIcon = child.idIcon
                  itemIcon:SetImage(item.Icon)
                  itemIcon:SetMinHeight(HUDButtonHeight)
                  itemIcon:SetMaxHeight(HUDButtonHeight)
                  local warningText = child.idWarningText
                  local button = child.idFrame
                  local sideButtonsSize = 0
                  if item.LargeItem then
                    itemIcon:SetMaxWidth(154 + sideButtonsSize)
                  else
                    itemIcon:SetMaxWidth(77 + sideButtonsSize)
                  end
                  warningText:SetMaxWidth(itemIcon.MaxWidth)
                  local reloadables = GetReloadOptionsForWeapon(item, false, "skipSubWeapon")
                  local count = GetBulletCount(item)
                  local is_firearm = IsKindOf(item, "Firearm")
                  if is_firearm and item.jammed and not item:IsCondition("Broken") then
                    warningText:SetText(T(276505585210, "JAMMED"))
                    itemIcon:SetDesaturation(255)
                    itemIcon:SetTransparency(50)
                    warningText:SetVisible(true)
                  elseif is_firearm and item:IsCondition("Broken") then
                    warningText:SetText(T(623193685060, "BROKEN"))
                    itemIcon:SetDesaturation(255)
                    itemIcon:SetTransparency(50)
                    warningText:SetVisible(true)
                  elseif count and count == 0 then
                    if not reloadables or #reloadables == 0 then
                      warningText:SetText(T(669866061827, "No Ammo"))
                      itemIcon:SetDesaturation(255)
                      itemIcon:SetTransparency(50)
                    else
                      warningText:SetText(T(402669531723, "RELOAD"))
                      itemIcon:SetDesaturation(255)
                      itemIcon:SetTransparency(50)
                      rawset(child, "weapon-click", "reload")
                    end
                    warningText:SetVisible(true)
                  elseif is_firearm and item:GetSubweapon("GrenadeLauncher") and GetBulletCount(item:GetSubweapon("GrenadeLauncher")) == 0 then
                    warningText:SetText(T(693636719988, "NO GRENADE"))
                    itemIcon:SetDesaturation(255)
                    itemIcon:SetTransparency(50)
                    warningText:SetVisible(true)
                  end
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XContextWindow",
                  "RolloverTemplate",
                  "RolloverInventory",
                  "RolloverAnchor",
                  "custom",
                  "RolloverText",
                  T(370682405601, "placeholder"),
                  "RolloverOffset",
                  box(0, 0, 0, 10),
                  "IdNode",
                  true
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XButton",
                    "IdNode",
                    false,
                    "Background",
                    RGBA(0, 0, 0, 0),
                    "FocusedBorderColor",
                    RGBA(255, 255, 255, 255),
                    "FocusedBackground",
                    RGBA(0, 0, 0, 0),
                    "DisabledBorderColor",
                    RGBA(0, 0, 0, 0),
                    "OnPress",
                    function(self, gamepad)
                      local node = self:ResolveId("node")
                      local weaponClick = rawget(node, "weapon-click")
                      local weapon = node.context
                      if weaponClick == "reload" then
                        QuickReloadButton(self, weapon)
                      else
                        local unit = Selection[1]
                        local action
                        for _, action_id in ipairs(unit.ui_actions) do
                          local ca = CombatActions[action_id]
                          if unit.ui_actions[action_id] == "enabled" then
                            local w1, w2, wl = ca:GetAttackWeapons(unit)
                            if w1 == weapon or w2 == weapon then
                              action = ca
                              break
                            end
                            for _, wpn in ipairs(wl) do
                              if wpn == weapon then
                                action = ca
                              end
                            end
                          end
                          if action then
                            break
                          end
                        end
                        local action = action or unit:GetDefaultAttackAction("ranged")
                        CombatActionAttackStart(action, Selection, {free_aim = true}, "IModeCombatFreeAim")
                      end
                    end,
                    "AltPress",
                    true,
                    "OnAltPress",
                    function(self, gamepad)
                      if not GetDialog("PDADialogSatellite") and not Selection[1]:CanBeControlled() then
                        return
                      end
                      OpenInventory(Selection[1])
                    end,
                    "RolloverBackground",
                    RGBA(0, 0, 0, 0),
                    "PressedBackground",
                    RGBA(0, 0, 0, 0)
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XImage",
                      "RolloverTemplate",
                      "RolloverInventory",
                      "RolloverAnchor",
                      "center-top",
                      "RolloverText",
                      T(840234458060, "placeholder"),
                      "RolloverOffset",
                      box(0, 0, 0, 20),
                      "Id",
                      "idIcon",
                      "Padding",
                      box(5, 0, 5, 0),
                      "HandleMouse",
                      true,
                      "ImageFit",
                      "width"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__condition",
                        function(parent, context)
                          return context:IsWeapon() and context.ComponentSlots and #context.ComponentSlots > 0 and 0 < CountWeaponUpgrades(context)
                        end,
                        "__class",
                        "XImage",
                        "RolloverText",
                        T(370682405601, "placeholder"),
                        "Id",
                        "idModIcon",
                        "Margins",
                        box(5, 8, 0, 0),
                        "HAlign",
                        "left",
                        "VAlign",
                        "top",
                        "ScaleModifier",
                        point(600, 600),
                        "Image",
                        "UI/Inventory/w_mod"
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XContextWindow",
                    "Margins",
                    box(0, 0, 3, 0),
                    "HAlign",
                    "right",
                    "VAlign",
                    "bottom",
                    "LayoutMethod",
                    "VList",
                    "LayoutVSpacing",
                    -5
                  }, {
                    PlaceObj("XTemplateForEach", {
                      "comment",
                      "subweapons",
                      "array",
                      function(parent, context)
                        return IsKindOf(context, "FirearmBase") and table.values(context.subweapons)
                      end,
                      "condition",
                      function(parent, context, item, i)
                        return context
                      end,
                      "__context",
                      function(parent, context, item, i, n)
                        return item
                      end
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XContextWindow",
                        "IdNode",
                        true
                      }, {
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XText",
                          "Padding",
                          box(2, 2, 2, 0),
                          "HAlign",
                          "right",
                          "TextStyle",
                          "HUDHeader",
                          "Translate",
                          true,
                          "Text",
                          T(151637075934, "<bullets()>")
                        })
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idAmmo",
                      "Padding",
                      box(2, 2, 2, 0),
                      "TextStyle",
                      "HUDHeader",
                      "Translate",
                      true,
                      "Text",
                      T(151637075934, "<bullets()>"),
                      "TextVAlign",
                      "center"
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XTextWithStyleBasedOnSize",
                    "Id",
                    "idWarningText",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "MaxWidth",
                    200,
                    "Visible",
                    false,
                    "DrawOnTop",
                    true,
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "DescriptionTextRedGlow16",
                    "Translate",
                    true,
                    "TextHAlign",
                    "center",
                    "TextVAlign",
                    "bottom",
                    "TextStyleSmall",
                    "DescriptionTextRedGlow_Small"
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__condition",
                    function(parent, context)
                      return context.Repairable
                    end,
                    "__class",
                    "XText",
                    "Id",
                    "idCondText",
                    "Padding",
                    box(0, 2, 2, 0),
                    "HAlign",
                    "right",
                    "VAlign",
                    "top",
                    "ScaleModifier",
                    point(800, 800),
                    "DrawOnTop",
                    true,
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "InventoryItemsCount",
                    "Translate",
                    true,
                    "Text",
                    T(383846607575, "<percent(Condition)>"),
                    "TextHAlign",
                    "right"
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__condition",
              function(parent, context)
                return #parent[1] == 2
              end,
              "Margins",
              box(0, 5, -4, 5),
              "HAlign",
              "center",
              "MinWidth",
              2,
              "MaxWidth",
              2,
              "Background",
              RGBA(52, 55, 61, 255)
            })
          })
        })
      })
    })
  })
})
