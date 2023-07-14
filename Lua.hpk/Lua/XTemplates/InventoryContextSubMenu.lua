PlaceObj("XTemplate", {
  __is_kind_of = "XPopup",
  group = "Zulu ContextMenu",
  id = "InventoryContextSubMenu",
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
    "right"
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
      PlaceObj("XTemplateForEach", {
        "comment",
        "give",
        "array",
        function(parent, context)
          return context.action == "give" and InventoryGetTargetsForGiveAction(context) or {}
        end,
        "condition",
        function(parent, context, item, i)
          return context.action == "give"
        end,
        "run_after",
        function(child, context, item, i, n, last)
          if type(item) == "number" then
            child:SetText(g_Classes.SquadBag.DisplayNameShort)
            child.unit = GetSquadBagInventory(item)
            child:SetFocusOrder(point(2, i))
            return
          end
          local unit
          if gv_SatelliteView then
            unit = gv_UnitData[item]
          else
            unit = g_Units[item] or gv_UnitData[item] or item
          end
          child:SetText(unit:GetDisplayName())
          child.unit = unit
          child:SetFocusOrder(point(2, i))
        end
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "give",
          "__template",
          "ContextMenuButton",
          "OnPress",
          function(self, gamepad)
            PopupMenuGiveItem(self)
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
            "box",
            "HAlign",
            "right",
            "MinWidth",
            100,
            "MaxWidth",
            100,
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
                local ui_slot = context.slot_wnd
                local dest_container = self:ResolveId("node").unit
                local cost_ap, unit = GetAPCostAndUnit(context.item, context.context, ui_slot.slot_name, dest_container, GetContainerInventorySlotName(dest_container))
                self:SetTextStyle(rollover and self.enabled and "SatelliteContextMenuTextRollover" or "SatelliteContextMenuText")
                if 0 < cost_ap then
                  local text = "<ap(cost_ap)>"
                  if not unit:UIHasAP(cost_ap) then
                    text = "<color InventoryActionsTextRed>" .. text .. "</color>"
                  end
                  self:SetText(T({text, cost_ap = cost_ap}))
                end
              end
            })
          })
        })
      }),
      PlaceObj("XTemplateForEach", {
        "comment",
        "give to squad",
        "array",
        function(parent, context)
          return context.action == "giveToSquad" and InventoryGetTargetsForGiveToSquadAction(context) or {}
        end,
        "condition",
        function(parent, context, item, i)
          return not InventoryIsCombatMode() and context.action == "giveToSquad"
        end,
        "run_after",
        function(child, context, item, i, n, last)
          child:SetText(Untranslated(item.Name))
          child.squad = item
          child:SetFocusOrder(point(2, i))
        end
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "give to squad",
          "__template",
          "ContextMenuButton",
          "OnPress",
          function(self, gamepad)
            PopupMenuGiveItemToSquad(self)
          end
        })
      }),
      PlaceObj("XTemplateForEach", {
        "comment",
        "split and give merc",
        "array",
        function(parent, context)
          return context.action == "splitgiveToSquad" and InventoryGetTargetsForGiveAction(context) or {}
        end,
        "condition",
        function(parent, context, item, i)
          return not InventoryIsCombatMode() and context.action == "splitgiveToSquad"
        end,
        "run_after",
        function(child, context, item, i, n, last)
          local unit
          if gv_SatelliteView then
            unit = gv_UnitData[item]
          else
            unit = g_Units[item] or gv_UnitData[item] or item
          end
          child:SetText(unit:GetDisplayName())
          child.unit = unit
          child:SetFocusOrder(point(2, i))
        end
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "split and give",
          "__template",
          "ContextMenuButton",
          "OnPress",
          function(self, gamepad)
            PopupMenuSplitGiveToSquad(self)
          end
        })
      }),
      PlaceObj("XTemplateForEach", {
        "comment",
        "split and give squad",
        "array",
        function(parent, context)
          return context.action == "splitgiveToSquad" and InventoryGetTargetsForGiveToSquadAction(context) or {}
        end,
        "condition",
        function(parent, context, item, i)
          return not InventoryIsCombatMode() and context.action == "splitgiveToSquad"
        end,
        "run_after",
        function(child, context, item, i, n, last)
          child:SetText(Untranslated(item.Name))
          child.squad = item
          child:SetFocusOrder(point(2, i + #InventoryGetTargetsForGiveAction(context)))
        end
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "split and give",
          "__template",
          "ContextMenuButton",
          "OnPress",
          function(self, gamepad)
            PopupMenuSplitGiveToSquad(self)
          end
        })
      }),
      PlaceObj("XTemplateForEach", {
        "comment",
        "combine",
        "array",
        function(parent, context)
          return context.action == "combine" and InventoryGetTargetsRecipe(context.item, context.unit) or {}
        end,
        "condition",
        function(parent, context, item, i)
          return context.action == "combine"
        end,
        "item_in_context",
        "recipe_item",
        "run_after",
        function(child, context, item, i, n, last)
          local container_slot = item.container_data.slot
          local recipe = item.recipe
          local amount = recipe.Ingredients[item.second_idx].amount or 1
          local item_id = item.second
          local result_id = recipe.ResultItems[1].item
          local result_name = InventoryItemDefs[result_id].DisplayName
          local result_amount = recipe.ResultItems[1].amount
          local name = InventoryItemDefs[item_id].DisplayName
          if 1 < amount then
            child:SetText(T({
              736794276226,
              "+<name>(<amount>) = <result>(<result_amount>)",
              name = name,
              amount = amount,
              result = result_name,
              result_amount = result_amount
            }))
          else
            child:SetText(T({
              619588210566,
              "+<name><equipped> = <result>",
              name = name,
              result = result_name,
              equipped = IsEquipSlot(container_slot) and T({
                678824253741,
                "(Equipped-<Nick>)",
                item.container_data.container
              }) or ""
            }))
          end
          child:SetFocusOrder(point(2, i))
        end
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "combine",
          "__template",
          "ContextMenuButton",
          "OnPress",
          function(self, gamepad)
          end
        })
      }),
      PlaceObj("XTemplateForEach", {
        "comment",
        "use",
        "array",
        function(parent, context)
          return context.action == "use" and InventoryGetSquadUnits() or {}
        end,
        "condition",
        function(parent, context, item, i)
          return context.action == "use"
        end,
        "run_after",
        function(child, context, item, i, n, last)
          local unit
          if gv_SatelliteView then
            unit = gv_UnitData[item]
          else
            unit = g_Units[item] or gv_UnitData[item] or item
          end
          child:SetText(unit:GetDisplayName())
          child.unit = unit
          child:SetFocusOrder(point(2, i))
        end
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "use",
          "__template",
          "ContextMenuButton",
          "FocusOrder",
          point(1, 1),
          "OnPress",
          function(self, gamepad)
            local context = self.context
            local item = context.item
            local unit = self.unit
            InventoryUseItem(unit, item, context.context, context.slot_wnd.slot_name)
            context.slot_wnd:ClosePopup()
          end
        })
      }),
      PlaceObj("XTemplateForEach", {
        "comment",
        "ammo (reload action)",
        "array",
        function(parent, context)
          return context.action == "reload" and GetReloadOptionsForWeapon(context.item, context.context) or {}
        end,
        "condition",
        function(parent, context, item, i)
          return context.action == "reload"
        end,
        "run_after",
        function(child, context, item, i, n, last)
          child:SetContext(item)
          local count = context.unit:CountAvailableAmmo(item.ammo.class)
          child:SetText(T({
            433225540474,
            "<ammo_type>(<count>)",
            ammo_type = item.ammo.DisplayName,
            count = count
          }))
          child:SetFocusOrder(point(2, i))
          if not IsWeaponAvailableForReload(item.weapon, {
            item.ammo
          }) then
            child:SetEnabled(false)
          end
        end
      }, {
        PlaceObj("XTemplateTemplate", {
          "comment",
          "reload",
          "__template",
          "ContextMenuButton",
          "FocusOrder",
          point(1, 1),
          "OnPress",
          function(self, gamepad)
            local ammo = self.context.ammo
            local weapon = self.context.weapon
            local context = self:ResolveId("node"):GetContext()
            local container = context.context
            local unit = context.unit
            local pos = container:GetItemPackedPos(weapon)
            local actionArgs = {
              target = ammo.class,
              pos = pos,
              item_id = weapon.id
            }
            local ap = CombatActions.Reload:GetAPCost(unit, actionArgs)
            ap = InventoryIsCombatMode(unit) and ap or 0
            if IsKindOf(unit, "Unit") then
              NetStartCombatAction("Reload", unit, ap, actionArgs)
            elseif IsKindOf(unit, "UnitData") then
              NetSyncEvent("InvetoryAction_RealoadWeapon", unit.session_id, ap, actionArgs, ammo.class)
            end
            context.slot_wnd:ClosePopup()
            ObjModified(unit)
            InventoryUpdate(unit)
          end,
          "Text",
          T(231508638088, "Ammo")
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
        T(404959391934, "OPTIONS"),
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
        local parent = self.popup_parent
        if parent and parent.spawned_subpopup and parent.spawned_subpopup == self then
          parent.spawned_subpopup = false
        end
        return ZuluContextMenu.Close(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnShortcut(self, shortcut, source, ...)",
      "func",
      function(self, shortcut, source, ...)
        if shortcut == "Escape" or shortcut == "ButtonB" then
          self:Close()
          return "break"
        end
        return ZuluContextMenu.OnShortcut(self, shortcut, source, ...)
      end
    })
  })
})
