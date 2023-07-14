PlaceObj("XTemplate", {
  __is_kind_of = "XPopup",
  group = "Zulu ContextMenu",
  id = "InventoryContextMenu",
  PlaceObj("XTemplateWindow", {
    "__condition",
    function(parent, context)
      return context
    end,
    "__class",
    "ZuluContextMenu",
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MinWidth",
    220,
    "LayoutMethod",
    "Box",
    "AnchorType",
    "custom"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplateList",
      "Id",
      "idPopupWindow",
      "BorderWidth",
      0,
      "Padding",
      box(0, 4, 0, 4),
      "VAlign",
      "top",
      "LayoutVSpacing",
      2,
      "UseClipBox",
      false,
      "Background",
      RGBA(255, 255, 255, 0),
      "BackgroundRectGlowColor",
      RGBA(0, 0, 0, 0),
      "HandleMouse",
      false,
      "FocusedBackground",
      RGBA(255, 255, 255, 0),
      "KeepSelectionOnRespawn",
      true
    }, {
      PlaceObj("XTemplateTemplate", {
        "comment",
        "use",
        "__condition",
        function(parent, context)
          return context and context.item.effect_moment == "on_use" and (gv_SatelliteView and not InventoryIsCombatMode() or InventoryIsValidGiveDistance(context.unit, context.slot_wnd:GetContext()))
        end,
        "__template",
        "ContextMenuButton",
        "Id",
        "use",
        "FocusOrder",
        point(1, 1),
        "RelativeFocusOrder",
        "new-line",
        "OnContextUpdate",
        function(self, context, ...)
          self:SetText(T({
            836711100688,
            "<action_name> (<merc_name>)",
            action_name = context.item.action_name or T(539507517622, "USE"),
            merc_name = context.unit.Nick
          }))
          self:SetEnabled(self.enabled and (not context.item.UnitStat or context.unit[context.item.UnitStat] < 100))
          XContextControl.OnContextUpdate(self, context)
        end,
        "OnPress",
        function(self, gamepad)
          local context = self.context
          local item = context.item
          local unit = context.unit
          if not g_Combat or unit:UIHasAP(item.APCost * const.Scale.AP) then
            CreateRealTimeThread(function()
              local res = WaitQuestion(self.desktop, T(684118311188, "Use Item"), T({
                766869245085,
                "Do you want <merc_name> to use the <item_name>?",
                merc_name = context.unit.Nick,
                item_name = item.DisplayName
              }))
              if res == "ok" then
                InventoryUseItem(unit, item, context.context, context.slot_wnd.slot_name)
              end
              context.slot_wnd:ClosePopup()
            end)
          else
            PlayFX("IactDisabled", "start", item)
          end
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return InventoryIsCombatMode()
          end,
          "__class",
          "XText",
          "Id",
          "text",
          "Margins",
          box(0, 0, 10, 0),
          "Dock",
          "right",
          "HandleMouse",
          false,
          "TextStyle",
          "SatelliteContextMenuText",
          "Translate",
          true,
          "TextHAlign",
          "right"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              self:OnSetRollover(false)
              XText.Open(self)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnSetRollover(self, rollover)",
            "func",
            function(self, rollover)
              local context = self.context
              if not InventoryIsCombatMode() then
                return
              end
              local unit = context.unit
              if IsKindOf(context.unit, "UnitData") then
                unit = g_Units[context.unit.session_id]
              end
              local item = context.item
              local cost_ap = item.APCost * const.Scale.AP
              self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
              if context.item.UnitStat and context.unit[context.item.UnitStat] >= 100 then
                self:SetText(T(200747740446, "<color InventoryActionsTextRed>Max stat</color>"))
              elseif 0 < cost_ap then
                local text = "<ap(cost_ap)>"
                if not context.unit:UIHasAP(cost_ap) then
                  text = "<color InventoryActionsTextRed>" .. text .. "</color>"
                end
                self:SetText(T({text, cost_ap = cost_ap}))
              end
            end
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "comment",
        "give",
        "__condition",
        function(parent, context)
          return context and #InventoryGetTargetsForGiveAction(context) > 0
        end,
        "__template",
        "ContextMenuButton",
        "Id",
        "give",
        "FocusOrder",
        point(1, 2),
        "RelativeFocusOrder",
        "new-line",
        "OnContextUpdate",
        function(self, context, ...)
          self:SetEnabled(not context.item.locked)
        end,
        "OnPress",
        function(self, gamepad)
          SpawnInventoryActionsSecondaryPopup(self, "give")
        end,
        "Text",
        T(886263727249, "GIVE")
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnShortcut(self, shortcut, source, ...)",
          "func",
          function(self, shortcut, source, ...)
            local node = self:ResolveId("node")
            local context = node.context
            node = node.parent
            if shortcut == "+ButtonA" then
              self:OnPress()
              return "break"
            end
            return XButton.OnShortcut(self, shortcut, source, ...)
          end
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "comment",
        "give to squad",
        "__condition",
        function(parent, context)
          return #GetCurrentSectorPlayerSquads() > 1 and not IsKindOf(context.context, "SquadBag") and not InventoryIsCombatMode()
        end,
        "__template",
        "ContextMenuButton",
        "Id",
        "giveToSquad",
        "FocusOrder",
        point(1, 2),
        "RelativeFocusOrder",
        "new-line",
        "OnContextUpdate",
        function(self, context, ...)
          self:SetEnabled(not context.item.locked)
        end,
        "OnPress",
        function(self, gamepad)
          SpawnInventoryActionsSecondaryPopup(self, "giveToSquad")
        end,
        "Text",
        T(333299723785, "GIVE TO SQUAD")
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnShortcut(self, shortcut, source, ...)",
          "func",
          function(self, shortcut, source, ...)
            local node = self:ResolveId("node")
            local context = node.context
            node = node.parent
            if shortcut == "+ButtonA" then
              self:OnPress()
              return "break"
            end
            return XButton.OnShortcut(self, shortcut, source, ...)
          end
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "comment",
        "split and give to squad",
        "__condition",
        function(parent, context)
          return #GetCurrentSectorPlayerSquads() > 1 and IsKindOf(context.item, "InventoryStack") and IsKindOf(context.context, "SquadBag") and not InventoryIsCombatMode()
        end,
        "__template",
        "ContextMenuButton",
        "Id",
        "splitgiveToSquad",
        "FocusOrder",
        point(1, 2),
        "RelativeFocusOrder",
        "new-line",
        "OnContextUpdate",
        function(self, context, ...)
          self:SetEnabled(not context.item.locked)
        end,
        "OnPress",
        function(self, gamepad)
          SpawnInventoryActionsSecondaryPopup(self, "splitgiveToSquad")
        end,
        "Text",
        T(920024662816, "SPLIT & GIVE")
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnShortcut(self, shortcut, source, ...)",
          "func",
          function(self, shortcut, source, ...)
            local node = self:ResolveId("node")
            local context = node.context
            node = node.parent
            if shortcut == "+ButtonA" then
              self:OnPress()
              return "break"
            end
            return XButton.OnShortcut(self, shortcut, source, ...)
          end
        })
      }),
      PlaceObj("XTemplateGroup", {
        "comment",
        "weapon",
        "__condition",
        function(parent, context)
          return context and context.item:IsWeapon() and IsKindOf(context.item, "Firearm")
        end
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "modify weapon",
          "__template",
          "ContextMenuButton",
          "Id",
          "modify",
          "FocusOrder",
          point(1, 3),
          "RelativeFocusOrder",
          "new-line",
          "OnContextUpdate",
          function(self, context, ...)
            local enabled = not IsInMultiplayerGame() or not g_Combat
            local obj = context.item
            local modifiable = IsKindOf(obj, "FirearmBase") and obj:CanBeModified()
            self:SetText(modifiable and T(843921709930, "MODIFY") or T(830295633677, "INSPECT"))
            self:SetEnabled(enabled)
          end,
          "OnPress",
          function(self, gamepad)
            local context = self:ResolveId("node").context
            context.slot_wnd:ClosePopup()
            local item = context.item
            local owner = context.context
            OpenDialog("ModifyWeaponDlg", false, {
              weapon = item,
              slot = owner:GetItemPackedPos(item),
              owner = owner
            })
          end,
          "Text",
          T(588090355770, "MODIFY")
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "reload",
          "__template",
          "ContextMenuButton",
          "Id",
          "reload",
          "FocusOrder",
          point(1, 4),
          "RelativeFocusOrder",
          "new-line",
          "OnContextUpdate",
          function(self, context, ...)
            local unit = context.unit
            local enabled = false
            local args = {
              weapon = context.item.class,
              pos = context.context:GetItemPackedPos(context.item)
            }
            local action = CombatActions.Reload
            local ap = action:GetAPCost(unit, args)
            if context.context:IsKindOf("UnitInventory") then
              if IsKindOf(unit, "Unit") then
                enabled = action:GetUIState({unit}, args) == "enabled"
              elseif ap < 0 then
                enabled = false
              elseif not unit:UIHasAP(ap) then
                enabled = false
              else
                local weapon = context.item
                local ammoForWeapon = unit:GetAvailableAmmos(weapon, nil, "unique")
                if not ammoForWeapon then
                  local bag = unit.Squad and GetSquadBagInventory(unit.Squad)
                  if bag then
                    ammoForWeapon = bag:GetAvailableAmmos(weapon, nil, "unique")
                  end
                end
                if IsWeaponAvailableForReload(weapon, ammoForWeapon) then
                  enabled = true
                else
                  enabled = false
                end
              end
            end
            self:SetEnabled(enabled)
          end,
          "OnPress",
          function(self, gamepad)
            SpawnInventoryActionsSecondaryPopup(self, "reload")
          end,
          "Text",
          T(202847622393, "RELOAD")
        }, {
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return InventoryIsCombatMode()
            end,
            "__class",
            "XText",
            "Id",
            "text",
            "Margins",
            box(0, 0, 10, 0),
            "Dock",
            "right",
            "HandleMouse",
            false,
            "TextStyle",
            "SatelliteContextMenuText",
            "Translate",
            true,
            "TextHAlign",
            "right"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "Open(self)",
              "func",
              function(self)
                self:OnSetRollover(false)
                XText.Open(self)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetRollover(self, rollover)",
              "func",
              function(self, rollover)
                local context = self.context
                if not InventoryIsCombatMode() then
                  return
                end
                local unit = context.unit
                if IsKindOf(context.unit, "UnitData") then
                  unit = g_Units[context.unit.session_id]
                end
                local args = {
                  weapon = context.item.class,
                  pos = context.unit:GetItemPackedPos(context.item)
                }
                local action = CombatActions.Reload
                local cost_ap = action:GetAPCost(unit, args)
                self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
                if 0 < cost_ap then
                  local text = "<ap(cost_ap)>"
                  if not context.unit:UIHasAP(cost_ap) then
                    text = "<color InventoryActionsTextRed>" .. text .. "</color>"
                  end
                  self:SetText(T({text, cost_ap = cost_ap}))
                end
              end
            })
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "unload",
          "__template",
          "ContextMenuButton",
          "Id",
          "unload",
          "FocusOrder",
          point(1, 5),
          "OnContextUpdate",
          function(self, context, ...)
            local item = context.item
            local unit = context.unit
            local ap = item.ReloadAP
            if not item.ammo or item.ammo.Amount == 0 or not unit:UIHasAP(ap) then
              self:SetEnabled(false)
            else
              self:SetEnabled(true)
            end
          end,
          "OnPress",
          function(self, gamepad)
            local context = self:ResolveId("node").context
            if not context then
              return
            end
            local item = context.item
            local unit = context.unit
            local container = context.context
            local slot_name = context.slot_wnd.slot_name
            if not item.ammo then
              return
            end
            local cost_ap = InventoryIsCombatMode() and item.ReloadAP or 0
            if InventoryIsCombatMode() and not unit:UIHasAP(cost_ap) then
              PlayFX("ReloadFail", "start", item)
              return
            end
            NetSquadBagAction(unit, container, slot_name, item, gv_SquadBag, "unload", cost_ap)
            PlayFX("WeaponUnload", "start", item.object_class, item.class)
            context.slot_wnd:ClosePopup()
          end,
          "Text",
          T(642602107801, "UNLOAD")
        }, {
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return InventoryIsCombatMode()
            end,
            "__class",
            "XText",
            "Margins",
            box(0, 0, 10, 0),
            "Dock",
            "right",
            "HandleMouse",
            false,
            "TextStyle",
            "SatelliteContextMenuText",
            "Translate",
            true,
            "TextHAlign",
            "right"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "Open(self)",
              "func",
              function(self)
                self:OnSetRollover(false)
                XText.Open(self)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetRollover(self, rollover)",
              "func",
              function(self, rollover)
                local context = self.context
                local cost_ap = context.item.ReloadAP or 0
                self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
                if 0 < cost_ap then
                  local text = "<ap(cost_ap)>"
                  if not context.unit:UIHasAP(cost_ap) then
                    text = "<color InventoryActionsTextRed>" .. text .. "</color>"
                  end
                  self:SetText(T({text, cost_ap = cost_ap}))
                end
              end
            })
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "unload underslung",
          "__template",
          "ContextMenuButton",
          "Id",
          "unloadUnderslung",
          "FocusOrder",
          point(1, 5),
          "OnContextUpdate",
          function(self, context, ...)
            local weapon = context.item
            local subweapon = IsKindOf(weapon, "FirearmBase") and weapon:GetSubweapon("Firearm")
            if not subweapon then
              self:SetVisible(false)
              self:SetEnabled(false)
            elseif not subweapon.ammo or subweapon.Amount == 0 then
              self:SetVisible(true)
              self:SetEnabled(false)
            else
              self:SetVisible(true)
              self:SetEnabled(true)
            end
          end,
          "OnPress",
          function(self, gamepad)
            local context = self:ResolveId("node").context
            if not context then
              return
            end
            local item = context.item
            local unit = context.unit
            local container = context.context
            local slot_name = context.slot_wnd.slot_name
            local sub = item:GetSubweapon("Firearm")
            if not sub or not sub.ammo then
              return
            end
            local cost_ap = item.ReloadAP or 0
            if InventoryIsCombatMode() and not unit:UIHasAP(cost_ap) then
              PlayFX("ReloadFail", "start", item)
              return
            end
            NetSquadBagAction(unit, container, slot_name, item, gv_SquadBag, "unload underslung", cost_ap)
            PlayFX("WeaponUnload", "start", sub.object_class, sub.class)
            context.slot_wnd:ClosePopup()
          end,
          "Text",
          T(260165467032, "UNLOAD MOD")
        }, {
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return InventoryIsCombatMode()
            end,
            "__class",
            "XText",
            "Margins",
            box(0, 0, 10, 0),
            "Dock",
            "right",
            "HandleMouse",
            false,
            "TextStyle",
            "SatelliteContextMenuText",
            "Translate",
            true,
            "TextHAlign",
            "right"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "Open(self)",
              "func",
              function(self)
                self:OnSetRollover(false)
                XText.Open(self)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetRollover(self, rollover)",
              "func",
              function(self, rollover)
                local context = self.context
                local cost_ap = context.item.ReloadAP or 0
                self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
                if 0 < cost_ap then
                  local text = "<ap(cost_ap)>"
                  if not context.unit:UIHasAP(cost_ap) then
                    text = "<color InventoryActionsTextRed>" .. text .. "</color>"
                  end
                  self:SetText(T({text, cost_ap = cost_ap}))
                end
              end
            })
          })
        }),
        PlaceObj("XTemplateTemplate", {
          "comment",
          "unjam",
          "__condition",
          function(parent, context)
            return context and context.item:IsKindOfClasses("Firearm") and not context.item:IsCondition("Broken") and context.item.jammed
          end,
          "__template",
          "ContextMenuButton",
          "Id",
          "unjam",
          "FocusOrder",
          point(1, 6),
          "OnContextUpdate",
          function(self, context, ...)
            if context and context.item:IsKindOfClasses("Firearm") and not context.item:IsCondition("Broken") and context.item.jammed then
              self:SetEnabled(true)
            else
              self:SetEnabled(false)
            end
          end,
          "OnPress",
          function(self, gamepad)
            local context = self:ResolveId("node").context
            local action = CombatActions.Unjam
            local unit = context.unit
            local item = context.item
            local args = {
              weapon = item.class,
              item_id = item.id,
              pos = context.context:GetItemPackedPos(context.item)
            }
            if action:GetUIState({unit}, args) ~= "enabled" then
              PlayFX("UnjamFail", "start", context.item)
              return
            end
            local cost_ap = action:GetAPCost(context.unit, false, context.item)
            cost_ap = InventoryIsCombatMode(unit) and cost_ap or 0
            if IsKindOf(unit, "Unit") then
              NetStartCombatAction("Unjam", unit, cost_ap, args)
            else
              NetSyncEvent("InvetoryAction_UnjamWeapon", unit.session_id, cost_ap, args)
            end
            context.slot_wnd:ClosePopup()
          end,
          "Text",
          T(461075645427, "UNJAM")
        }, {
          PlaceObj("XTemplateWindow", {
            "__condition",
            function(parent, context)
              return InventoryIsCombatMode()
            end,
            "__class",
            "XText",
            "Margins",
            box(0, 0, 10, 0),
            "Dock",
            "right",
            "HandleMouse",
            false,
            "TextStyle",
            "SatelliteContextMenuText",
            "Translate",
            true,
            "TextHAlign",
            "right"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "Open(self)",
              "func",
              function(self)
                self:OnSetRollover(false)
                XText.Open(self)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetRollover(self, rollover)",
              "func",
              function(self, rollover)
                local context = self.context
                local action = CombatActions.Unjam
                local cost_ap = action:GetAPCost(context.unit, false, context.item)
                self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
                if 0 < cost_ap then
                  local text = "<ap(cost_ap)>"
                  if not context.unit:UIHasAP(cost_ap) then
                    text = "<color InventoryActionsTextRed>" .. text .. "</color>"
                  end
                  self:SetText(T({text, cost_ap = cost_ap}))
                end
              end
            })
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "comment",
        "unequip",
        "__condition",
        function(parent, context)
          return context and context.slot_wnd and IsEquipSlot(context.slot_wnd.slot_name)
        end,
        "__template",
        "ContextMenuButton",
        "Id",
        "unequip",
        "FocusOrder",
        point(1, 2),
        "RelativeFocusOrder",
        "new-line",
        "OnContextUpdate",
        function(self, context, ...)
          self:SetEnabled(not context.item.locked)
        end,
        "OnPress",
        function(self, gamepad)
          local context = self.context
          context.slot_wnd:UnEquipItem(context.item)
        end,
        "Text",
        T(737533224447, "UNEQUIP")
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnShortcut(self, shortcut, source, ...)",
          "func",
          function(self, shortcut, source, ...)
            local node = self:ResolveId("node")
            local context = node.context
            node = node.parent
            if shortcut == "+ButtonA" then
              self:OnPress()
              return "break"
            end
            return XButton.OnShortcut(self, shortcut, source, ...)
          end
        })
      }),
      PlaceObj("XTemplateGroup", {
        "comment",
        "stack",
        "__condition",
        function(parent, context)
          return context and context.item:IsKindOf("InventoryStack")
        end
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "split",
          "__condition",
          function(parent, context)
            return context.item.Amount > 1 and not IsKindOfClasses(context.context, "SquadBag", "SectorStash", "ItemDropContainer")
          end,
          "__template",
          "ContextMenuButton",
          "Id",
          "split",
          "FocusOrder",
          point(1, 7),
          "OnContextUpdate",
          function(self, context, ...)
            local container = context.context
            local item = context.item
            local hasSpace = container:FindEmptyPosition(GetContainerInventorySlotName(container), item)
            if hasSpace then
              self:SetText(T(614440672207, "SPLIT"))
              self:SetEnabled(true)
            else
              self:SetText(T(899088597690, "SPLIT (NO SPACE)"))
              self:SetEnabled(false)
            end
          end,
          "OnPress",
          function(self, gamepad)
            local context = self:ResolveId("node").context
            OpenDialog("SplitStackItem", false, context)
            context.slot_wnd:ClosePopup()
          end,
          "Text",
          T(614440672207, "SPLIT")
        })
      }),
      PlaceObj("XTemplateGroup", {
        "comment",
        "medicine",
        "__condition",
        function(parent, context)
          return context and context.item:IsKindOf("Medicine")
        end
      }, {
        PlaceObj("XTemplateGroup", {
          "__condition",
          function(parent, context)
            return context and context.item and context and context.item:IsKindOfClasses("Medkit", "FirstAidKit")
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "comment",
            "salvage",
            "__condition",
            function(parent, context)
              return context and context.item and context.item.Condition >= 1
            end,
            "__template",
            "ContextMenuButton",
            "Id",
            "salvage",
            "FocusOrder",
            point(1, 11),
            "OnContextUpdate",
            function(self, context, ...)
              self:SetEnabled(not context.item.locked)
            end,
            "OnPress",
            function(self, gamepad)
              local context = self:ResolveId("node").context
              if not context then
                return
              end
              CreateRealTimeThread(function()
                local popupHost = GetInGameInterface()
                local scrapPrompt = CreateQuestionBox(popupHost, T(129713192838, "Salvage"), T(193228332373, "This action will destroy the item. Are you sure?"), T(689884995409, "Yes"), T(782927325160, "No"))
                local resp = scrapPrompt:Wait()
                if resp ~= "ok" then
                  return
                else
                  local unit = context.unit
                  local container = context.context
                  local item = context.item
                  local slot_name = context.slot_wnd.slot_name
                  NetSquadBagAction(unit, container, slot_name, item, gv_SquadBag, "salvage", 0)
                  PlayFX("Scrap", "start", item)
                end
              end)
              context.slot_wnd:ClosePopup()
            end,
            "Text",
            T(575220930819, "SALVAGE")
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Margins",
              box(0, 0, 10, 0),
              "Dock",
              "right",
              "HandleMouse",
              false,
              "TextStyle",
              "SatelliteContextMenuText",
              "Translate",
              true,
              "TextHAlign",
              "right"
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "Open(self)",
                "func",
                function(self)
                  self:OnSetRollover(false)
                  XText.Open(self)
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnSetRollover(self, rollover)",
                "func",
                function(self, rollover)
                  local context = self.context
                  self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
                  local item = context.item
                  local parts = AmountOfSalvagedMeds(item)
                  self:SetText(T({
                    149255321468,
                    "<parts> MEDS",
                    parts = parts
                  }))
                end
              })
            })
          }),
          PlaceObj("XTemplateTemplate", {
            "comment",
            "refill",
            "__condition",
            function(parent, context)
              return context and context.item and context.item.Condition < context.item:GetMaxCondition()
            end,
            "__template",
            "ContextMenuButton",
            "Id",
            "refill",
            "FocusOrder",
            point(1, 12),
            "OnPress",
            function(self, gamepad)
              local context = self:ResolveId("node").context
              if not context then
                return
              end
              local unit = context.unit
              local container = context.context
              local item = context.item
              local slot_name = context.slot_wnd.slot_name
              NetSquadBagAction(unit, container, slot_name, item, gv_SquadBag, "refill", 0)
              PlayFX("RefillMeds", "start", item)
              context.slot_wnd:ClosePopup()
            end,
            "Text",
            T(826934867343, "REFILL")
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Margins",
              box(0, 0, 10, 0),
              "Dock",
              "right",
              "HandleMouse",
              false,
              "TextStyle",
              "SatelliteContextMenuText",
              "Translate",
              true,
              "TextHAlign",
              "right"
            }, {
              PlaceObj("XTemplateFunc", {
                "name",
                "Open(self)",
                "func",
                function(self)
                  self:OnSetRollover(false)
                  XText.Open(self)
                end
              }),
              PlaceObj("XTemplateFunc", {
                "name",
                "OnSetRollover(self, rollover)",
                "func",
                function(self, rollover)
                  local context = self.context
                  self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
                  local item = context.item
                  local parts = AmountOfMedsToFill(item)
                  self:SetText(T({
                    149255321468,
                    "<parts> MEDS",
                    parts = parts
                  }))
                end
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "comment",
        "equip",
        "__condition",
        function(parent, context)
          if not InventoryIsContainerOnSameSector(context) then
            return false
          end
          if context and not context.item.locked and (context.item:IsKindOfClasses("Grenade", "QuickSlotItem", "Armor") or not context.item:IsKindOfClasses("InventoryStack", "ToolItem", "Medicine", "Valuables", "QuestItem", "ConditionAndRepair", "MiscItem")) then
            local slot_name = context.slot_wnd.slot_name
            if slot_name == "Inventory" or slot_name == "InventoryDead" then
              return true
            end
          end
          return false
        end,
        "__template",
        "ContextMenuButton",
        "Id",
        "equip",
        "FocusOrder",
        point(1, 9),
        "OnPress",
        function(self, gamepad)
          local context = self:ResolveId("node").context
          context.slot_wnd:EquipItem(context.item)
        end,
        "Text",
        T(919083865056, "EQUIP")
      }, {
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return InventoryIsCombatMode()
          end,
          "__class",
          "XText",
          "Margins",
          box(0, 0, 10, 0),
          "Dock",
          "right",
          "HandleMouse",
          false,
          "TextStyle",
          "SatelliteContextMenuText",
          "Translate",
          true,
          "TextHAlign",
          "right"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              self:OnSetRollover(false)
              XText.Open(self)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnSetRollover(self, rollover)",
            "func",
            function(self, rollover)
              local context = self.context
              local ap = 0
              if InventoryIsCombatMode() then
                local costs = const["Action Point Costs"]
                ap = ap + context.item:GetEquipCost()
                local unit = GetInventoryUnit()
                if unit ~= context.context then
                  if IsKindOf(context.context, "Unit") and not context.context:IsDead() then
                    ap = ap + costs.GiveItem
                  end
                  if not IsKindOf(context.context, "Unit") or context.context:IsDead() then
                    ap = ap + costs.PickItem
                  end
                end
              end
              local unit = GetInventoryUnit()
              local cost_ap = ap
              self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
              if 0 < cost_ap then
                local text = "<ap(cost_ap)>"
                if not context.unit:UIHasAP(cost_ap) then
                  text = "<color InventoryActionsTextRed>" .. text .. "</color>"
                end
                self:SetText(T({text, cost_ap = cost_ap}))
              end
            end
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "comment",
        "combine",
        "__condition",
        function(parent, context)
          if not context then
            return
          end
          local obj = context.slot_wnd and context.slot_wnd:GetContext()
          if obj and (IsKindOf(obj, "Unit") and obj:IsDead() or IsKindOf(obj, "ItemContainer")) then
            return
          end
          return #InventoryGetTargetsRecipe(context.item, context.unit) > 0
        end,
        "__template",
        "ContextMenuButton",
        "Id",
        "Combine",
        "FocusOrder",
        point(1, 2),
        "OnContextUpdate",
        function(self, context, ...)
          self:SetEnabled(not g_Combat)
        end,
        "OnPress",
        function(self, gamepad)
          local combinePopup = XTemplateSpawn("CombineItemPopup", terminal.desktop, self.context)
          combinePopup:Open()
          local node = self:ResolveId("node")
          local context = node and node.context
          if context then
            context.slot_wnd:ClosePopup()
          end
        end,
        "Text",
        T(980665628283, "COMBINE")
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnShortcut(self, shortcut, source, ...)",
          "func",
          function(self, shortcut, source, ...)
            local node = self:ResolveId("node")
            local context = node.context
            node = node.parent
            if shortcut == "+ButtonA" then
              self:OnPress()
              return "break"
            end
            return XButton.OnShortcut(self, shortcut, source, ...)
          end
        }),
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return InventoryIsCombatMode()
          end,
          "__class",
          "XText",
          "Margins",
          box(0, 0, 10, 0),
          "Dock",
          "right",
          "HandleMouse",
          false,
          "TextStyle",
          "SatelliteContextMenuText",
          "Translate",
          true,
          "Text",
          T(667056736749, "Combat"),
          "TextHAlign",
          "right"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              self:OnSetRollover(false)
              XText.Open(self)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnSetRollover(self, rollover)",
            "func",
            function(self, rollover)
              self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
            end
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "comment",
        "scrap",
        "__condition",
        function(parent, context)
          return context and context.item and context.item.ScrapParts and context.item.ScrapParts > 0 and context.item.object_class ~= "Medicine"
        end,
        "__template",
        "ContextMenuButton",
        "Id",
        "scrap",
        "FocusOrder",
        point(1, 10),
        "OnContextUpdate",
        function(self, context, ...)
          self:SetEnabled(not context.item.locked)
        end,
        "OnPress",
        function(self, gamepad)
          local context = self:ResolveId("node").context
          if not context then
            return
          end
          CreateRealTimeThread(function()
            local popupHost = GetInGameInterface()
            local scrapPrompt = CreateQuestionBox(popupHost, T(271835460421, "Scrap"), T(193228332373, "This action will destroy the item. Are you sure?"), T(689884995409, "Yes"), T(782927325160, "No"))
            local resp = scrapPrompt:Wait()
            if resp ~= "ok" then
              return
            else
              local unit = context.unit
              local container = context.context
              local item = context.item
              local slot_name = context.slot_wnd.slot_name
              NetSquadBagAction(unit, container, slot_name, item, gv_SquadBag, "scrap", 0)
              PlayFX("Scrap", "start", item)
            end
          end)
          context.slot_wnd:ClosePopup()
        end,
        "Text",
        T(486269126756, "SCRAP")
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(0, 0, 10, 0),
          "Dock",
          "right",
          "HandleMouse",
          false,
          "TextStyle",
          "SatelliteContextMenuText",
          "Translate",
          true,
          "TextHAlign",
          "right"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              self:OnSetRollover(false)
              XText.Open(self)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnSetRollover(self, rollover)",
            "func",
            function(self, rollover)
              local context = self.context
              local action = CombatActions.Bandage
              local cost_ap = action:GetAPCost(context.unit, false, context.item)
              self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
              local item = context.item
              local parts = item:AmountOfScrapPartsFromItem()
              self:SetText(T({
                399084673498,
                "<parts> PARTS",
                parts = parts
              }))
            end
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "comment",
        "drop",
        "__condition",
        function(parent, context)
          if not context then
            return
          end
          local obj = context.slot_wnd and context.slot_wnd:GetContext()
          if context.unit.Operation == "Arriving" then
            return false
          end
          return obj and (not IsKindOf(obj, "Unit") or not obj:IsDead()) and not IsKindOfClasses(obj, "ItemContainer", "SectorStash")
        end,
        "__template",
        "ContextMenuButton",
        "Id",
        "drop",
        "FocusOrder",
        point(1, 11),
        "OnContextUpdate",
        function(self, context, ...)
          self:SetEnabled(not context.item.locked)
        end,
        "OnPress",
        function(self, gamepad)
          local context = self:ResolveId("node").context
          context.slot_wnd:DropItem(context.item)
        end,
        "Text",
        T(692159353735, "DROP")
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "compare",
        "__condition",
        function(parent, context)
          return false
        end
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "compare",
          "__condition",
          function(parent, context)
            return next(GetSlotsToEquipItem(context.item)) and not IsKindOfClasses(context.context, "SectorStash", "ItemDropContainer")
          end,
          "__template",
          "ContextMenuButton",
          "Id",
          "compare",
          "FocusOrder",
          point(1, 10),
          "OnPress",
          function(self, gamepad)
            local context = self:ResolveId("node").context
            local item = context.item
            local dlg = GetMercInventoryDlg()
            if InventoryIsCompareMode(dlg) then
              dlg:CloseCompare()
              dlg.compare_mode = false
            elseif item then
              local slot_name = context.slot_wnd.slot_name
              local is_eq_slot = IsEquipSlot(slot_name)
              dlg.compare_mode = true
              if not is_eq_slot then
                dlg:OpenCompare(context.wnd, item)
              end
            end
            dlg:CompareWeaponSetUI()
            context.slot_wnd:ClosePopup()
          end,
          "Text",
          T(647488663144, "COMPARE")
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "comment",
        "cashin",
        "__condition",
        function(parent, context)
          if context and context.item:IsKindOfClasses("Valuables") then
            local slot_name = context.slot_wnd.slot_name
            if slot_name == "Inventory" or slot_name == "InventoryDead" then
              return context.item.Cost > 0
            end
          end
          return false
        end,
        "__template",
        "ContextMenuButton",
        "Id",
        "cashin",
        "FocusOrder",
        point(1, 11),
        "OnPress",
        function(self, gamepad)
          local context = self:ResolveId("node").context
          if not context then
            return
          end
          CreateRealTimeThread(function()
            local prompt = CreateQuestionBox(terminal.desktop, T(727797864120, "Cash In"), T(193228332373, "This action will destroy the item. Are you sure?"), T(689884995409, "Yes"), T(782927325160, "No"))
            local resp = prompt:Wait()
            if resp ~= "ok" then
              return
            end
            local unit = context.unit
            local container = context.context
            local item = context.item
            local slot_name = context.slot_wnd.slot_name
            NetSquadBagAction(unit, container, slot_name, item, false, "cashin", 0)
            PlayFX("Cashin", "start", item)
          end)
          context.slot_wnd:ClosePopup()
        end,
        "Text",
        T(251539285860, "CASH IN")
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(0, 0, 10, 0),
          "Dock",
          "right",
          "HandleMouse",
          false,
          "TextStyle",
          "SatelliteContextMenuText",
          "Translate",
          true,
          "TextHAlign",
          "right"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              self:OnSetRollover(false)
              XText.Open(self)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnSetRollover(self, rollover)",
            "func",
            function(self, rollover)
              local context = self.context
              self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
              local item = context.item
              local cost = item.Cost
              self:SetText(T({
                397081877551,
                "<money(cost)>",
                cost = cost
              }))
            end
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "comment",
        "cashstack",
        "__condition",
        function(parent, context)
          if context and context.item:IsKindOfClasses("Valuables") then
            local slot_name = context.slot_wnd.slot_name
            if slot_name == "Inventory" or slot_name == "InventoryDead" then
              return context.item.Cost > 0 and context.item.Amount > 1
            end
          end
          return false
        end,
        "__template",
        "ContextMenuButton",
        "Id",
        "cashstack",
        "FocusOrder",
        point(1, 12),
        "OnPress",
        function(self, gamepad)
          local context = self:ResolveId("node").context
          if not context then
            return
          end
          CreateRealTimeThread(function()
            local prompt = CreateQuestionBox(terminal.desktop, T(727797864120, "Cash In"), T(131046045582, "This action will destroy the whole stack. Are you sure?"), T(689884995409, "Yes"), T(782927325160, "No"))
            local resp = prompt:Wait()
            if resp ~= "ok" then
              return
            end
            local unit = context.unit
            local container = context.context
            local item = context.item
            local slot_name = context.slot_wnd.slot_name
            NetSquadBagAction(unit, container, slot_name, item, false, "cashstack", 0)
            PlayFX("Cashin", "start", item)
          end)
          context.slot_wnd:ClosePopup()
        end,
        "Text",
        T(102695071847, "CASH STACK")
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Margins",
          box(0, 0, 10, 0),
          "Dock",
          "right",
          "HandleMouse",
          false,
          "TextStyle",
          "SatelliteContextMenuText",
          "Translate",
          true,
          "TextHAlign",
          "right"
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "Open(self)",
            "func",
            function(self)
              self:OnSetRollover(false)
              XText.Open(self)
            end
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnSetRollover(self, rollover)",
            "func",
            function(self, rollover)
              local context = self.context
              self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
              local item = context.item
              local cost = item.Cost
              if IsKindOf(item, "InventoryStack") then
                cost = cost * item.Amount
              end
              self:SetText(T({
                397081877551,
                "<money(cost)>",
                cost = cost
              }))
            end
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "title",
      "Dock",
      "top",
      "UseClipBox",
      false,
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
        box(10, 2, 0, 0),
        "HAlign",
        "left",
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
        "PDASectorInfo_Green",
        "Translate",
        true,
        "Text",
        T(927307546934, "Item Menu"),
        "TextVAlign",
        "center"
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        self.spawned_subpopup = false
        ZuluContextMenu.Open(self)
        self:SetFocus()
        local buttons = self.idPopupWindow
        if #buttons <= 0 then
          self:Close()
        end
        SetDisableMouseViaGamepad(true, "context-menu")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        if self.spawned_subpopup and self.spawned_subpopup.window_state ~= "destroying" then
          self.spawned_subpopup:Close()
        end
        SetDisableMouseViaGamepad(false, "context-menu")
        return ZuluContextMenu.Close(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "Escape" or shortcut == "ButtonB" then
          if self.spawned_subpopup then
            self.spawned_subpopup:Close()
            self.spawned_subpopup = false
            return "break"
          end
          self:Close()
          return "break"
        end
        return ZuluContextMenu.OnShortcut(self, shortcut, source, ...)
      end
    })
  })
})
