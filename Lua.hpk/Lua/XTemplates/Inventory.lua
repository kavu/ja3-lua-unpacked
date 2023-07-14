PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "Inventory",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return context or {
        unit = SelectedObj
      }
    end,
    "__class",
    "XDialog",
    "Id",
    "idInventory",
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      self:CloseCompare()
      self.selected_unit = context.unit
      self.idRight:SetContext(context, true)
      if self.selected_unit then
        self.idUnitInfo:SetContext(self.selected_unit, true)
        local left = self:ResolveId("idPartyContainer")
        local squad_list = left.idParty and left.idParty.idContainer or empty_table
        for _, button in ipairs(squad_list) do
          local bctx = button:GetContext()
          local is_selected = bctx and bctx.session_id == self.selected_unit.session_id
          button:SetSelected(is_selected)
        end
      end
      self:CompareWeaponSetUI()
    end,
    "CursorsFolder",
    "UI/DesktopGamepad/",
    "InitialMode",
    "ammo",
    "InternalModes",
    "loot, ammo",
    "FocusOnOpen",
    "child"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XCameraLockLayer",
      "lock_id",
      "Inventory"
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return not netInGame and not gv_SatelliteView
      end,
      "__class",
      "XPauseLayer"
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        self.spawned_popup = false
        self.item_wnd = false
        if gv_SatelliteView then
          SetCampaignSpeed(0, GetUICampaignPauseReason("Inventory"))
        end
        local context = self:GetContext()
        self.selected_unit = context.unit
        self.slots = {}
        self.compare_wnd = {}
        self.compare_mode = false
        self.compare_mode_weaponslot = context.unit.current_weapon == "Handheld A" and 1 or 2
        local retVal = XDialog.Open(self, ...)
        self.idPartyContainer:SelectSquad(gv_Squads[self.selected_unit.Squad])
        local container_mode = context.container and "loot" or "ammo"
        if InventoryDisabled(context) then
          container_mode = "ammo"
        end
        if gv_SatelliteView and context.unit and (context.unit.Operation == "Arriving" or context.unit.Operation == "Traveling") then
          container_mode = "ammo"
        end
        self:SetMode(container_mode)
        local ctrl_right_area = self.idScrollArea
        for _, wnd in ipairs(ctrl_right_area) do
          local wnd_context = wnd:GetContext()
          local wnd_id = wnd_context and wnd_context.session_id
          if wnd and wnd_id and context.unit and wnd_id == context.unit.session_id then
            ctrl_right_area:ScrollIntoView(wnd)
            wnd.idName:SetHightlighted(true)
            break
          end
        end
        self:CompareWeaponSetUI()
        return retVal
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete()",
      "func",
      function()
        if gv_SatelliteView then
          SetCampaignSpeed(nil, GetUICampaignPauseReason("Inventory"))
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        local context = self.context
        if context and IsKindOf(context.container, "SectorStash") then
          InventoryUIResetSectorStash()
          NetSyncEvent("SectorStashOpenedBy", false)
        end
        if gv_SquadBag then
          InventoryUIResetSquadBag()
        end
        self:CloseCompare()
        return XDialog.Close(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetSlotByName(self,slot_name, slot_context)",
      "func",
      function(self, slot_name, slot_context)
        local slots = self:GetSlotsArray()
        for slot in pairs(slots) do
          if slot.slot_name == slot_name and (not slot_context or slot_context == slot:GetContext()) then
            return slot
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnEscape",
      "func",
      function(self, ...)
        local slots = self:GetSlotsArray()
        for slot in pairs(slots) do
          if slot:CancelDragging() then
            return true
          end
        end
        if self.spawned_popup and self.spawned_popup.window_state ~= "destroying" then
          local slot = next(slots)
          slot:ClosePopup()
          return true
        end
        if InventoryIsCompareMode(self) then
          self:CloseCompare()
          self.compare_mode = false
          self:ActionsUpdated()
          return true
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CloseCompare(self, up)",
      "func",
      function(self, up)
        local cmp_item = self.compare_wnd and self.compare_wnd.item
        if cmp_item then
          HighlightCompareSlots(cmp_item, self.compare_wnd.other, false)
          local mode = self.compare_mode
          self.compare_mode = false
          SetInventoryHighlights(cmp_item, up)
          self.compare_mode = mode
        end
        if next(self.compare_wnd) then
          for _, wnd in ipairs(self.compare_wnd) do
            wnd:delete()
          end
          self.compare_wnd = {}
          XInventoryItem.RolloverTemplate = "RolloverInventory"
          return
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OpenCompare(self, item_wnd, item)",
      "func",
      function(self, item_wnd, item)
        if next(self.compare_wnd) then
          return false
        end
        if not item_wnd or not item then
          local pt = terminal:GetMousePos()
          local win = terminal.desktop:GetMouseTarget(pt)
          while win and not IsKindOf(win, "XInventorySlot") do
            win = win:GetParent()
          end
          if not win then
            return false
          end
          item_wnd, item = win:FindItemWnd(pt)
        end
        self.compare_wnd.item = item
        if item then
          self.compare_mode = false
          SetInventoryHighlights(item, false)
          self.compare_mode = true
        end
        local container = item_wnd and item_wnd.parent and item_wnd.parent.context
        local no_compare = IsKindOfClasses(container, "SectorStash", "ItemDropContainer")
        if no_compare then
          return false
        end
        local equip_slots = GetSlotsToEquipItem(item)
        if item and next(equip_slots) then
          local dlg = GetMercInventoryDlg()
          local unit = GetInventoryUnit()
          local list = XTemplateSpawn("XWindow", dlg.idCompare)
          list:SetHAlign("right")
          list:SetVAlign("top")
          list:SetLayoutMethod("HList")
          list:SetLayoutVSpacing(10)
          local other = {}
          local is_weapon = item:IsWeapon()
          local is_grenade = IsKindOf(item, "Grenade")
          self.compare_mode_weaponslot = self.compare_mode_weaponslot or 1
          if is_weapon or 1 < #equip_slots then
            equip_slots = self.compare_mode_weaponslot == 1 and {"Handheld A"} or {"Handheld B"}
          end
          for idx, slot_name in ipairs(equip_slots) do
            unit:ForEachItemInSlot(slot_name, function(itm)
              if itm and item ~= itm then
                local is_weapon_eq = itm:IsWeapon()
                local is_grenade_eq = IsKindOf(itm, "Grenade")
                if is_weapon and is_weapon_eq or not is_weapon and not is_weapon_eq and (InventoryItemDefs[item.class].group == InventoryItemDefs[itm.class].group or is_grenade_eq and is_grenade) then
                  local context = SubContext(itm)
                  context.control = self:GetSlotByName(slot_name)
                  local rollover_slot = XTemplateSpawn("RolloverInventoryCompare", list, context)
                  rollover_slot:SetMargins(box(10, 0, 0, 0))
                  table.insert(other, 1, itm)
                end
              end
            end, other)
          end
          local context = SubContext(item)
          context.control = item_wnd
          context.other = other
          if #other <= 0 then
            XInventoryItem.RolloverTemplate = "RolloverInventory"
            list:delete()
            return false
          end
          if RolloverWin then
            RolloverWin:Close()
            RolloverWin = false
            HighlightCompareSlots(item, other, true)
          end
          self.compare_wnd[#self.compare_wnd + 1] = list
          self.compare_wnd.other = other
          local rollover_item = XTemplateSpawn("RolloverInventoryCompare", list, context)
          rollover_item:SetMargins(box(10, 0, 0, 0))
          list:Open()
          XInventoryItem.RolloverTemplate = ""
          return true
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnKillFocus(self)",
      "func",
      function(self)
        local slots = self:GetSlotsArray()
        for slot in pairs(slots) do
          if slot:CancelDragging() then
            break
          end
        end
        XDialog.OnKillFocus(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetSlotsArray(self)",
      "func",
      function(self)
        return self.slots or empty_table
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDialogModeChange(self, mode, dialog)",
      "func",
      function(self, mode, dialog)
        if dialog == self then
          if gv_SatelliteView then
            self.idCenterHeading:SetText(mode == "loot" and T({
              288565331426,
              "SECTOR <SectorId(sector)> STASH",
              sector = dialog.context.container.sector_id or gv_CurrentSectorId
            }) or T(197418134567, "Squad Supplies"))
          else
            self.idCenterHeading:SetText(mode == "loot" and T(899428826682, "Loot") or T(197418134567, "Squad Supplies"))
          end
          return
        end
        if mode ~= "inventory" and dialog ~= self then
          Msg("CloseInventorySubDialog", "inventory")
          PlayFX("InventoryClose")
          self:OnEscape()
          self:Close()
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnXButtonDown(self, button, controller_id)",
      "func",
      function(self, button, controller_id)
        local res = XDialog.OnXButtonDown(self, button, controller_id)
        if res == "break" then
          return "break"
        end
        local dlg = GetDialog("FullscreenGameDialogs")
        if button == "ButtonY" and XInput.IsCtrlButtonPressed(controller_id, "RightTrigger") then
          if self.compare_mode then
            self:CloseCompare()
            XInventoryItem.RolloverTemplate = "RolloverInventory"
            self.compare_mode = not self.compare_mode
          else
            self.compare_mode = not self.compare_mode
            self:OpenCompare()
          end
          self:ActionsUpdated()
          return "break"
        end
        if button == "RightThumbClick" then
          local pos, slot
          for ctrl, val in pairs(self.slots) do
            local ctx = ctrl:GetContext()
            if IsKindOf(ctrl, "BrowseInventorySlot") and ctx and ctx.session_id and ctx.session_id == self.selected_unit.session_id then
              slot = ctrl
            end
          end
          pos = slot and slot.box:min() or self.slots[1]:GetPos()
          if pos then
            terminal.SetMousePos(pos)
          end
          return "break"
        end
        if XInput.IsCtrlButtonPressed(controller_id, "LeftTrigger") then
          local pt = GamepadMouseGetPos()
          local win = terminal.desktop:GetMouseTarget(pt)
          while win and not IsKindOf(win, "XInventorySlot") do
            win = win:GetParent()
          end
          local owner, item
          if win then
            local _, left, top = win:FindTile(pt)
            owner = win.context
            item = owner:GetItemInSlot(win.slot_name, false, left, top)
          end
          if button == "DPadRight" or button == "Right" then
            if item and item:IsWeapon() and IsKindOf(item, "Firearm") then
              if not IsInMultiplayerGame() or not g_Combat then
                OpenDialog("ModifyWeaponDlg", false, {
                  weapon = item,
                  slot = owner:GetItemPackedPos(item),
                  owner = owner
                })
              end
              return "break"
            end
          elseif button == "DPadUp" or button == "Up" then
            if win and not IsEquipSlot(win.slot_name) then
              if InventoryDragItem then
                self:CancelDragging()
              end
              win:EquipItem(item)
              return "break"
            end
          elseif button == "DPadDown" or button == "DPadDown" then
            if IsEquipSlot(win.slot_name) then
              win:UnEquipItem(item)
              return "break"
            elseif owner.Operation ~= "Arriving" and (not IsKindOf(owner, "Unit") or not owner:IsDead()) and not IsKindOf(owner, "ItemContainer") then
              win:DropItem(item)
              return "break"
            end
          elseif button == "DPadLeft" or button == "Left" then
            local ammo, weapon
            local unit = GetInventoryUnit()
            if IsKindOf(item, "Ammo") then
              ammo = item
              unit:ForEachItemInSlot(unit.current_weapon, function(witem, slot, l, t, weapon)
                if witem.Caliber == ammo.Caliber then
                  weapon = witem
                  return "break"
                end
              end, weapon)
            elseif item:IsWeapon() then
              weapon = item
              local ammos, containers, slots = owner:GetAvailableAmmos(weapon, nil, "unique")
              local can, err = IsWeaponAvailableForReload(weapon, ammos)
              if can and err ~= AttackDisableReasons.FullClipHaveOther then
                local ammo = weapon.ammo
                if ammo then
                  local haveMoreFromCurrent = table.find(ammos, "class", ammo.class)
                  ammo = haveMoreFromCurrent and ammos[haveMoreFromCurrent] or ammos[1]
                else
                  ammo = ammos[1]
                end
              end
            end
            if weapon and ammo then
              do
                local context = self:ResolveId("node"):GetContext()
                local container = context.context
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
                ObjModified(unit)
                InventoryUpdate(unit)
              end
            end
          end
        end
        if button == "ButtonB" and not self:OnEscape() then
          if CurrentTutorialPopup and CurrentTutorialPopup.window_state ~= "destroying" then
            local ctx = CurrentTutorialPopup:ResolveId("idText"):GetContext()
            TutorialDismissHint(ctx)
            CloseCurrentTutorialPopup()
          else
            dlg:SetMode("empty")
            dlg:Close()
          end
          return "break"
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSquadSelected(self, selected_squad)",
      "func",
      function(self, selected_squad)
        if selected_squad then
          local ctx = self:GetContext()
          local firstUnitId = selected_squad.units[1]
          local clone
          local fromPDA = GetDialog("PDADialog") or gv_SatelliteView
          local ctx_unit = fromPDA and gv_UnitData[firstUnitId] or g_Units[firstUnitId]
          ctx.unit = ctx_unit
          local sector_id = ctx.unit and gv_Squads[ctx.unit.Squad].CurrentSector
          if gv_SatelliteView and gv_SectorInventory and ctx.unit then
            if sector_id then
              gv_SectorInventory:Clear()
              gv_SectorInventory:SetSectorId(sector_id)
              ctx.container = gv_SectorInventory
            else
              ctx.container = false
            end
          end
          if clone then
            ObjModified(clone)
          end
          ObjModified(ctx_unit)
          local prep_context = PrepareInventoryContext(ctx.unit, ctx.container)
          ctx.unit = prep_context.unit
          ctx.container = prep_context.container
          self:SetContext(ctx)
          self:OnContextUpdate(ctx)
          InventoryUIResetSquadBag()
          InventoryUIRespawn()
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "TakeAllState(self)",
      "func",
      function(self)
        local context = self:GetContext()
        local container = context and context.container
        if not container or InventoryIsCombatMode() then
          return "hidden"
        end
        if not InventoryIsValidTargetForUnit(container) then
          return "hidden"
        end
        local containers = InventoryGetLootContainers(container) or empty_table
        local hasItem = false
        for _, cont in ipairs(containers) do
          local container_slot_name = GetContainerInventorySlotName(cont)
          if cont:GetItemInSlot(container_slot_name) then
            hasItem = true
            break
          end
        end
        if not hasItem then
          return "hidden"
        end
        if InventoryDisabled(context) then
          return "disabled"
        end
        local unit = context.unit
        if not unit then
          return
        end
        local units = {unit}
        local left = self:ResolveId("idPartyContainer")
        local list = left.idParty and left.idParty.idContainer or empty_table
        for _, ctrl in ipairs(list) do
          local data = ctrl:GetContext()
          if data then
            table.insert_unique(units, data)
          end
        end
        local free_space = false
        for _, container in ipairs(containers) do
          local container_slot_name = GetContainerInventorySlotName(container)
          container:ForEachItemInSlot(container_slot_name, false, function(item, slot_name, src_left, src_top)
            if IsKindOf(item, "SquadBagItem") then
              free_space = true
              return "break"
            end
            local is_stack = IsKindOf(item, "InventoryStack")
            for _, unit in ipairs(units) do
              local pos, reason = unit:CanAddItem("Inventory", item)
              if pos then
                free_space = true
                return "break"
              elseif is_stack then
                local res = unit:ForEachItemInSlot("Inventory", item.class, function(itm, slot_n, l, t)
                  if itm.Amount + item.Amount <= itm.MaxStacks then
                    return "break"
                  end
                end)
                if res == "break" then
                  free_space = true
                  return "break"
                end
              end
            end
          end)
          if free_space then
            break
          end
        end
        if not free_space then
          return "disabled", T(545718357333, "Inventory is full")
        end
        return "enabled"
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "TakeAllStateWarning(self,ctrl)",
      "func",
      function(self, ctrl)
        if not ctrl.enabled then
          local state, reason = self:TakeAllState()
          if reason and not self:IsThreadRunning("warning text") then
            self:CreateThread("warning text", function()
              local node = ctrl:ResolveId("node")
              local txt = node.idWarningText
              txt:SetText(reason)
              txt:SetVisible(true)
              Sleep(1037)
              txt:SetVisible(false)
            end)
          end
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "TakeAllAction(self)",
      "func",
      function(self)
        local dlg = self
        local context = dlg:GetContext()
        local unit = context.unit
        if not unit then
          return
        end
        local containers = InventoryGetLootContainers(context.container) or empty_table
        local units = {unit}
        local left = dlg:ResolveId("idPartyContainer")
        local list = left.idParty and left.idParty.idContainer or empty_table
        for _, ctrl in ipairs(list) do
          local data = ctrl:GetContext()
          if data then
            table.insert_unique(units, data)
          end
        end
        InventoryTakeAll(units, containers)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "CompareWeaponSetUI(self, force_stop)",
      "func",
      function(self, force_stop)
        local set1, set2 = self.idUnitInfo.idWeapons1, self.idUnitInfo.idWeapons2
        if not force_stop and self.compare_mode_weaponslot then
          local ctrl = self.idUnitInfo["idWeapons" .. self.compare_mode_weaponslot]
          ctrl:SetToggled(true)
          ctrl:SetIconColumn(ctrl.Toggled and 2 or 1)
          local slot_ctrl
          if self.compare_mode then
            slot_ctrl = self.idUnitInfo["idWeapon" .. (self.compare_mode_weaponslot == 1 and "A" or "B")]
            local item_wnds = slot_ctrl.item_windows
            for item_ctrl, item in pairs(item_wnds) do
              item_ctrl.idText:SetEnabled(true)
              item_ctrl.idCenterText:SetEnabled(true)
              item_ctrl.idTopRightText:SetEnabled(true)
              item_ctrl.idItemImg:SetTransparency(0)
              item_ctrl.idItemImg:SetDesaturation(0)
            end
          end
          ctrl = self.idUnitInfo["idWeapons" .. (self.compare_mode_weaponslot == 1 and 2 or 1)]
          ctrl:SetToggled(false)
          ctrl:SetIconColumn(ctrl.Toggled and 2 or 1)
          if self.compare_mode then
            slot_ctrl = self.idUnitInfo["idWeapon" .. (self.compare_mode_weaponslot == 1 and "B" or "A")]
            local item_wnds = slot_ctrl.item_windows
            for item_ctrl, item in pairs(item_wnds) do
              item_ctrl.idText:SetEnabled(false)
              item_ctrl.idCenterText:SetEnabled(false)
              item_ctrl.idTopRightText:SetEnabled(false)
              item_ctrl.idItemImg:SetTransparency(180)
              item_ctrl.idItemImg:SetDesaturation(200)
            end
          end
        else
          for _, slot in ipairs({"idWeaponA", "idWeaponB"}) do
            local slot_ctrl = self.idUnitInfo[slot]
            local item_wnds = slot_ctrl.item_windows
            for item_ctrl, item in pairs(item_wnds) do
              item_ctrl.idText:SetEnabled(true)
              item_ctrl.idCenterText:SetEnabled(true)
              item_ctrl.idTopRightText:SetEnabled(true)
              item_ctrl.idItemImg:SetTransparency(0)
              item_ctrl.idItemImg:SetDesaturation(0)
            end
          end
        end
        self:SetChangeWeaponRollover()
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetChangeWeaponRollover(self)",
      "func",
      function(self)
        local set1, set2 = self.idUnitInfo.idWeapons1, self.idUnitInfo.idWeapons2
        local unit = self.selected_unit
        if not self.compare_mode and InventoryIsCombatMode(unit) then
          local action = CombatActions.ChangeWeapon
          local state, reason = action:GetUIState({unit})
          local ap = action:GetAPCost(unit)
          local has_ap = unit:UIHasAP(ap)
          local active_set = self.idUnitInfo["idWeapons" .. self.compare_mode_weaponslot]
          local new_set = self.idUnitInfo["idWeapons" .. (self.compare_mode_weaponslot == 1 and 2 or 1)]
          active_set:SetRolloverText("")
          new_set:SetRolloverText(T({
            789323452495,
            "<ap(ap_cost)>",
            ap_cost = ap
          }))
          if state == "hidden" then
            new_set.RolloverTemplate = "SmallRolloverGeneric"
            new_set:SetRolloverText(T(462153644901, "Character is busy"))
          elseif state == "disabled" and has_ap then
          elseif has_ap then
            new_set.RolloverTemplate = "ChangeActiveWeaponAPRollover"
          else
            new_set.RolloverTemplate = "ChangeActiveWeaponAPFailedRollover"
          end
        else
          set1:SetRolloverText("")
          set2:SetRolloverText("")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SwapWeaponSet(self)",
      "func",
      function(self)
        local unit = self.selected_unit
        if InventoryIsCombatMode() then
          local action = CombatActions.ChangeWeapon
          local state = action:GetUIState({unit})
          local ap = action:GetAPCost(unit)
          local has_ap = unit:UIHasAP(ap)
          if not has_ap or state ~= "enabled" then
            PlayFX("UnjamFail", "start")
            return false
          else
            if IsKindOf(unit, "Unit") then
              NetStartCombatAction("ChangeWeapon", unit, ap)
            else
              NetSyncEvent("InvetoryAction_SwapWeapon", unit.session_id, ap)
            end
            PlayFX("UnjamWeapon", "start")
          end
        else
          NetSyncEvent("InvetoryAction_SwapWeapon", unit.session_id, 0)
        end
        return true
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "ChangeContainerMode(self, mode)",
      "func",
      function(self, mode)
        local dlg = self
        local win, button
        if InventoryDragItem then
          local bag = GetSquadBagInventory(dlg.context.unit.Squad)
          local container_slot_name = GetContainerInventorySlotName(dlg.context.container)
          local slot_ctrl = mode == "ammo" and dlg:GetSlotByName(InventoryStartDragSlotName or container_slot_name, dlg.context.container) or dlg:GetSlotByName(InventoryStartDragSlotName or "Inventory", bag)
          win = slot_ctrl.drag_win
          button = slot_ctrl.drag_button
          slot_ctrl.drag_win = false
          local desktop = slot_ctrl.desktop
          if desktop:GetMouseCapture() == slot_ctrl then
            desktop:SetMouseCapture(false)
          end
        end
        dlg:SetMode(mode)
        if InventoryDragItem then
          local bag = GetSquadBagInventory(dlg.context.unit.Squad)
          local container_slot_name = GetContainerInventorySlotName(dlg.context.container)
          local slot_ctrl = mode == "ammo" and dlg:GetSlotByName(InventoryStartDragSlotName or "Inventory", bag) or dlg:GetSlotByName(InventoryStartDragSlotName or container_slot_name, dlg.context.container)
          slot_ctrl.drag_win = win
          slot_ctrl.drag_button = button
          DragSource = slot_ctrl
          slot_ctrl.desktop:SetMouseCapture(slot_ctrl)
          HighlightEquipSlots(InventoryDragItem, true)
          HighlightWeaponsForAmmo(InventoryDragItem, true)
        end
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "NextUnit",
      "ActionName",
      T(488448512300, "Next Unit"),
      "ActionShortcut",
      "Tab",
      "ActionGamepad",
      "RightShoulder",
      "ActionBindable",
      true,
      "OnAction",
      function(self, host, source, ...)
        host:CloseCompare()
        if InventoryDragItem and StartDragSource then
          StartDragSource:CancelDragging()
        end
        local context = host:GetContext()
        if InventoryIsCombatMode() then
          g_Combat:NextUnit()
          context.unit = SelectedObj
        elseif gv_SatelliteView then
          local squad = context.unit.Squad and gv_Squads[context.unit.Squad]
          local idx = table.find(squad.units, context.unit.session_id)
          idx = idx + 1
          if idx > #squad.units then
            idx = 1
          end
          context.unit = gv_UnitData[squad.units[idx]]
        else
          GetInGameInterfaceModeDlg():NextUnit()
          context.unit = SelectedObj
        end
        host:SetContext(context)
        host:OnContextUpdate(context)
        InventoryUIRespawn()
      end,
      "IgnoreRepeated",
      true,
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPressGeneric",
      "FXPressDisabled",
      "IactDisabled"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "PrevUnit",
      "ActionName",
      T(123120196907, "Prev Unit"),
      "ActionGamepad",
      "LeftShoulder",
      "ActionBindable",
      true,
      "OnAction",
      function(self, host, source, ...)
        local context = host:GetContext()
        host:CloseCompare()
        if InventoryIsCombatMode() then
          g_Combat:PrevUnit()
          context.unit = SelectedObj
        elseif gv_SatelliteView then
          local squad = context.unit.Squad and gv_Squads[context.unit.Squad]
          local idx = table.find(squad.units, context.unit.session_id)
          idx = idx - 1
          if idx < 1 then
            idx = 1
          end
          context.unit = gv_UnitData[squad.units[idx]]
        else
          GetInGameInterfaceModeDlg():NextUnit(nil, nil, nil, true)
          context.unit = SelectedObj
        end
        host:SetContext(context)
        host:OnContextUpdate(context)
        InventoryUIRespawn()
      end,
      "IgnoreRepeated",
      true,
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPressGeneric",
      "FXPressDisabled",
      "IactDisabled"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "NextSquad",
      "ActionName",
      T(225808868216, "Next Squad"),
      "ActionGamepad",
      "LeftTrigger-RightShoulder",
      "ActionBindable",
      true,
      "OnAction",
      function(self, host, source, ...)
        local left = host:ResolveId("idPartyContainer")
        local squads = left:GetContext()
        if #squads <= 1 then
          return
        end
        local selected = left.selected_squad
        local idx = table.find(squads, selected)
        idx = idx + 1
        if idx > #squads then
          idx = 1
        end
        left:SelectSquad(squads[idx])
      end,
      "IgnoreRepeated",
      true,
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPressGeneric",
      "FXPressDisabled",
      "IactDisabled"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "PrevSquad",
      "ActionName",
      T(924232255805, "Prev Squad"),
      "ActionGamepad",
      "LeftTrigger-LeftShoulder",
      "ActionBindable",
      true,
      "OnAction",
      function(self, host, source, ...)
        local left = host:ResolveId("idPartyContainer")
        local squads = left:GetContext()
        if #squads <= 1 then
          return
        end
        local selected = left.selected_squad
        local idx = table.find(squads, selected)
        idx = idx - 1
        if idx < 1 then
          idx = #squads
        end
        left:SelectSquad(squads[idx])
      end,
      "IgnoreRepeated",
      true,
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPressGeneric",
      "FXPressDisabled",
      "IactDisabled"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "CurrentWeapon1",
      "ActionName",
      T(625383249041, "Active Weapon I"),
      "ActionShortcut",
      "Z",
      "ActionButtonTemplate",
      "InventoryActionBarButton",
      "ActionState",
      function(self, host)
        return not host.compare_mode and "enabled" or "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        if host.compare_mode_weaponslot and host.compare_mode_weaponslot ~= 1 and host:SwapWeaponSet() then
          host.compare_mode_weaponslot = 1
          host:CompareWeaponSetUI()
        end
      end,
      "IgnoreRepeated",
      true,
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPress",
      "FXPressDisabled",
      "IactDisabled"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "CurrentWeapon2",
      "ActionName",
      T(270530821357, "Active Weapon II"),
      "ActionShortcut",
      "X",
      "ActionButtonTemplate",
      "InventoryActionBarButton",
      "ActionState",
      function(self, host)
        return not host.compare_mode and "enabled" or "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        if host.compare_mode_weaponslot and host.compare_mode_weaponslot ~= 2 and host:SwapWeaponSet() then
          host.compare_mode_weaponslot = 2
          host:CompareWeaponSetUI()
        end
      end,
      "IgnoreRepeated",
      true,
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPress",
      "FXPressDisabled",
      "IactDisabled"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Primary",
      "ActionName",
      T(751371171497, "Loadout I"),
      "ActionToolbar",
      "InventoryActionBar",
      "ActionShortcut",
      "Z",
      "ActionShortcut2",
      "Shift-Z",
      "ActionButtonTemplate",
      "InventoryActionBarButton",
      "ActionState",
      function(self, host)
        return host.compare_mode and "enabled" or "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        if host.compare_mode_weaponslot and host.compare_mode_weaponslot ~= 1 then
          host.compare_mode_weaponslot = 1
          host:CloseCompare()
          host:OpenCompare()
          host:CompareWeaponSetUI()
        end
      end,
      "IgnoreRepeated",
      true,
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPress",
      "FXPressDisabled",
      "IactDisabled"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Secondary",
      "ActionName",
      T(327566264426, "Loadout II"),
      "ActionToolbar",
      "InventoryActionBar",
      "ActionShortcut",
      "X",
      "ActionShortcut2",
      "Shift-X",
      "ActionButtonTemplate",
      "InventoryActionBarButton",
      "ActionState",
      function(self, host)
        return host.compare_mode and "enabled" or "hidden"
      end,
      "OnAction",
      function(self, host, source, ...)
        if host.compare_mode_weaponslot and host.compare_mode_weaponslot ~= 2 then
          host.compare_mode_weaponslot = 2
          host:CloseCompare()
          host:OpenCompare()
          host:CompareWeaponSetUI()
        end
      end,
      "IgnoreRepeated",
      true,
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPress",
      "FXPressDisabled",
      "IactDisabled"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "Actions",
      "ActionName",
      T(822111640935, "Item Menu"),
      "ActionToolbar",
      "InventoryActionBar",
      "ActionShortcut",
      "right_click",
      "ActionGamepad",
      "ButtonX",
      "ActionButtonTemplate",
      "InventoryActionBarButton",
      "ActionState",
      function(self, host)
        return not host.compare_mode and "enabled" or "hidden"
      end,
      "IgnoreRepeated",
      true,
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPress",
      "FXPressDisabled",
      "IactDisabled"
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "CompareItems",
      "ActionName",
      T(959647610798, "Compare"),
      "ActionToolbar",
      "InventoryActionBar",
      "ActionShortcut",
      "Shift",
      "ActionGamepad",
      "RightTrigger-ButtonY",
      "ActionButtonTemplate",
      "InventoryActionBarButton",
      "ActionState",
      function(self, host)
        if host.compare_mode then
          self.ActionName = T(917414532426, "<GameColorL>Compare</GameColorL>")
        else
          self.ActionName = T(341553928683, "Compare")
        end
      end,
      "OnAction",
      function(self, host, source, ...)
        if not host.compare_mode then
          host.compare_mode = true
          host.compare_mode_weaponslot = host.context.unit.current_weapon == "Handheld A" and 1 or 2
          host:OpenCompare()
          PlayFX("buttonPress", "start")
        end
        host:CompareWeaponSetUI()
        host:ActionsUpdated()
      end,
      "OnShortcutUp",
      function(self, host, source, ...)
        if host.window_state == "destroying" then
          return
        end
        if host.compare_mode then
          host:CloseCompare("up")
          host.compare_mode_weaponslot = host.context.unit.current_weapon == "Handheld A" and 1 or 2
          XInventoryItem.RolloverTemplate = "RolloverInventory"
          host.compare_mode = false
        end
        host:CompareWeaponSetUI("force")
        host:ActionsUpdated()
      end,
      "IgnoreRepeated",
      true,
      "FXMouseIn",
      "buttonRollover",
      "FXPressDisabled",
      "IactDisabled"
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idDlgContent",
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateTemplate", {
        "__context",
        function(parent, context)
          return SortSquads(gv_SatelliteView and GetSquadsInSector(false, false, false) or GetSquadsOnMap("reference"))
        end,
        "__template",
        "SquadsAndMercs",
        "Margins",
        box(25, 25, 10, 0),
        "MinWidth",
        446,
        "MaxWidth",
        446
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "SelectSquad(self, ...)",
          "func",
          function(self, ...)
            if SquadsAndMercsClass.SelectSquad(self, ...) then
              local invDiag = GetDialog(self)
              invDiag:OnSquadSelected(self.selected_squad)
            end
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "left",
        "__context",
        function(parent, context)
          return context.unit
        end,
        "__class",
        "XContentTemplate",
        "Id",
        "idUnitInfo",
        "Margins",
        box(-338, 0, 0, 75),
        "HAlign",
        "left",
        "MinWidth",
        332,
        "MaxWidth",
        332,
        "RespawnOnContext",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "background rectangle",
          "__class",
          "XImage",
          "BorderWidth",
          1,
          "Dock",
          "box",
          "HAlign",
          "center",
          "VAlign",
          "bottom",
          "MinWidth",
          332,
          "MinHeight",
          610,
          "MaxWidth",
          332,
          "MaxHeight",
          610,
          "Background",
          RGBA(43, 43, 43, 255),
          "Image",
          "UI/Inventory/character_pad"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "big portrait",
          "__class",
          "XContextImage",
          "Id",
          "idBigPortrait",
          "Dock",
          "box",
          "MaxWidth",
          332,
          "MaxHeight",
          610,
          "ImageFit",
          "scale-down",
          "ImageRect",
          box(550, 50, 1480, 1950),
          "FrameBottom",
          300,
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            self:SetImage(context.BigPortrait)
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "Margins",
            box(0, 100, 0, 0),
            "HandleMouse",
            true
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "IsDropTarget(self, draw_win, pt)",
              "func",
              function(self, draw_win, pt)
                return IsKindOf(InventoryDragItem, "MiscItem") and InventoryDragItem.effect_moment == "on_use"
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnDrop(self, drag_win, pt, drag_source_win)",
              "func",
              function(self, drag_win, pt, drag_source_win)
                if (not gv_SatelliteView or InventoryIsCombatMode()) and not InventoryIsValidGiveDistance(InventoryStartDragContext, self:GetContext()) then
                  PlayFX("IactDisabled", "start", InventoryDragItem)
                  return true
                end
                if InventoryUnitCanUseItem(self.context, InventoryDragItem) and (not g_Combat or self.context:HasAP(InventoryDragItem.APCost * const.Scale.AP)) then
                  InventoryUseItem(self.context, InventoryDragItem, InventoryStartDragContext, InventoryStartDragSlotName)
                  if InventoryDragItem and StartDragSource then
                    StartDragSource:ClearDragState(drag_win)
                  end
                else
                  PlayFX("IactDisabled", "start", InventoryDragItem)
                end
                return true
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnDropEnter(self, draw_win, pt, drag_source)",
              "func",
              function(self, draw_win, pt, drag_source)
                local mouse_text = T({
                  863973882023,
                  "<merc> Uses <em><item_name></em>",
                  merc = self.context.Nick,
                  item_name = InventoryDragItem.DisplayName
                })
                local can_use = InventoryUnitCanUseItem(self.context, InventoryDragItem)
                if not can_use then
                  mouse_text = mouse_text .. "\n" .. T(498556428804, "<style InventoryHintTextRed>Max stat</style>")
                end
                local valid, reason = InventoryIsValidGiveDistance(InventoryStartDragContext, self:GetContext())
                if (not gv_SatelliteView or InventoryIsCombatMode()) and not valid and reason and reason ~= "" then
                  mouse_text = mouse_text .. "\n" .. reason
                end
                if not mouse_text then
                  mouse_text = action_name or ""
                  if InventoryIsCombatMode() and item.APCost and item.APCost > 0 then
                    mouse_text = InventoryFormatAPMouseText(self.context, item.APCost, mouse_text)
                  end
                end
                InventoryShowMouseText(true, mouse_text)
                return
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnDropLeave(self, drag_win)",
              "func",
              function(self, drag_win)
                InventoryShowMouseText(false)
                return
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "FindTile",
              "func",
              function(self, ...)
                return
              end
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContentTemplate",
          "IdNode",
          false,
          "Margins",
          box(0, 0, 0, 30),
          "Dock",
          "bottom",
          "RespawnOnContext",
          false
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContentTemplate",
            "Id",
            "idEquipSlots",
            "IdNode",
            false,
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            10,
            "RespawnOnContext",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "armor",
              "HAlign",
              "center",
              "LayoutMethod",
              "HList"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "EquipInventorySlot",
                "Id",
                "idHead",
                "ScaleModifier",
                point(900, 900),
                "MouseCursor",
                "UI/Cursors/Pda_Cursor.tga",
                "slot_name",
                "Head"
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "Open",
                  "func",
                  function(self, ...)
                    EquipInventorySlot.Open(self, ...)
                    local dlg = GetDialog(self)
                    dlg.slots[self] = true
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnDelete",
                  "func",
                  function(self, ...)
                    local dlg = GetDialog(self)
                    dlg.slots[self] = nil
                  end
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "EquipInventorySlot",
                "Id",
                "idTorso",
                "ScaleModifier",
                point(900, 900),
                "slot_name",
                "Torso"
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "Open",
                  "func",
                  function(self, ...)
                    EquipInventorySlot.Open(self, ...)
                    local dlg = GetDialog(self)
                    dlg.slots[self] = true
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnDelete",
                  "func",
                  function(self, ...)
                    local dlg = GetDialog(self)
                    dlg.slots[self] = nil
                  end
                })
              }),
              PlaceObj("XTemplateWindow", {
                "__class",
                "EquipInventorySlot",
                "Id",
                "idLegs",
                "ScaleModifier",
                point(900, 900),
                "slot_name",
                "Legs"
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "Open",
                  "func",
                  function(self, ...)
                    EquipInventorySlot.Open(self, ...)
                    local dlg = GetDialog(self)
                    dlg.slots[self] = true
                  end
                }),
                PlaceObj("XTemplateFunc", {
                  "name",
                  "OnDelete",
                  "func",
                  function(self, ...)
                    local dlg = GetDialog(self)
                    dlg.slots[self] = nil
                  end
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "weapons",
              "LayoutMethod",
              "VList"
            }, {
              PlaceObj("XTemplateWindow", nil, {
                PlaceObj("XTemplateWindow", {
                  "Id",
                  "idWeaponAEx",
                  "Margins",
                  box(-30, 0, -30, 0)
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "EquipInventorySlot",
                    "Id",
                    "idWeaponA",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "ScaleModifier",
                    point(900, 900),
                    "slot_name",
                    "Handheld A"
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "Open",
                      "func",
                      function(self, ...)
                        EquipInventorySlot.Open(self, ...)
                        local dlg = GetDialog(self)
                        dlg.slots[self] = true
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnDelete",
                      "func",
                      function(self, ...)
                        local dlg = GetDialog(self)
                        dlg.slots[self] = nil
                      end
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XToggleButton",
                  "RolloverTemplate",
                  "ChangeActiveWeaponAPRollover",
                  "RolloverTitle",
                  T(372870127725, "AP"),
                  "Id",
                  "idWeapons1",
                  "Margins",
                  box(0, 5, 39, 0),
                  "HAlign",
                  "right",
                  "VAlign",
                  "top",
                  "OnContextUpdate",
                  function(self, context, ...)
                    XToggleButton.OnContextUpdate(self, context, ...)
                    local unit = GetDialog(self).selected_unit
                    self:SetVisible(unit:CanBeControlled())
                  end,
                  "OnPress",
                  function(self, gamepad)
                    if self.Toggled then
                      return
                    end
                    local dlg = GetDialog(self)
                    local action
                    if dlg.compare_mode then
                      action = dlg:ActionById("Primary")
                    else
                      action = dlg:ActionById("CurrentWeapon1")
                    end
                    action:OnAction(dlg)
                    XTextButton.OnPress(self)
                  end,
                  "Image",
                  "UI/Inventory/loadout_01",
                  "Columns",
                  2,
                  "Icon",
                  "UI/Inventory/loadout_01",
                  "IconColumns",
                  2,
                  "ColumnsUse",
                  "abbba"
                })
              }),
              PlaceObj("XTemplateWindow", nil, {
                PlaceObj("XTemplateWindow", {
                  "Id",
                  "idWeaponBEx",
                  "Margins",
                  box(-30, 0, -30, 0)
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "EquipInventorySlot",
                    "Id",
                    "idWeaponB",
                    "HAlign",
                    "center",
                    "VAlign",
                    "center",
                    "ScaleModifier",
                    point(900, 900),
                    "slot_name",
                    "Handheld B"
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "Open",
                      "func",
                      function(self, ...)
                        EquipInventorySlot.Open(self, ...)
                        local dlg = GetDialog(self)
                        dlg.slots[self] = true
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnDelete",
                      "func",
                      function(self, ...)
                        local dlg = GetDialog(self)
                        dlg.slots[self] = nil
                      end
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XToggleButton",
                  "RolloverTemplate",
                  "ChangeActiveWeaponAPRollover",
                  "RolloverTitle",
                  T(498938149015, "AP"),
                  "Id",
                  "idWeapons2",
                  "Margins",
                  box(0, 5, 39, 0),
                  "HAlign",
                  "right",
                  "VAlign",
                  "top",
                  "OnContextUpdate",
                  function(self, context, ...)
                    XToggleButton.OnContextUpdate(self, context, ...)
                    local unit = GetDialog(self).selected_unit
                    self:SetVisible(unit:CanBeControlled())
                  end,
                  "OnPress",
                  function(self, gamepad)
                    if self.Toggled then
                      return
                    end
                    local dlg = GetDialog(self)
                    local action
                    if dlg.compare_mode then
                      action = dlg:ActionById("Secondary")
                    else
                      action = dlg:ActionById("CurrentWeapon2")
                    end
                    action:OnAction(dlg)
                    XTextButton.OnPress(self)
                  end,
                  "Image",
                  "UI/Inventory/loadout_02",
                  "Columns",
                  2,
                  "Icon",
                  "UI/Inventory/loadout_02",
                  "IconColumns",
                  2,
                  "ColumnsUse",
                  "abbba"
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idEquipHint",
            "Margins",
            box(70, 0, 0, -25),
            "HAlign",
            "left",
            "VAlign",
            "bottom",
            "MinWidth",
            190,
            "Visible",
            false,
            "TextStyle",
            "PDABrowserTextLight",
            "Translate",
            true,
            "Text",
            T(331801298547, "Not Enough AP "),
            "TextHAlign",
            "center"
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "center - loot/ammo",
        "__class",
        "XContextWindow",
        "Margins",
        box(18, 18, 0, 0),
        "HAlign",
        "left",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idCenterHeading",
          "Padding",
          box(0, 0, 0, 0),
          "TextStyle",
          "InventoryContainerTitle",
          "Translate",
          true,
          "Text",
          T(455809205633, "Loot"),
          "TextHAlign",
          "center",
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "center",
          "__class",
          "XContentTemplate",
          "Id",
          "idCenter",
          "IdNode",
          false,
          "Margins",
          box(0, 20, 0, 0),
          "HAlign",
          "center",
          "MinWidth",
          485,
          "MinHeight",
          752,
          "MaxWidth",
          485,
          "MaxHeight",
          752,
          "OnContextUpdate",
          function(self, context, ...)
            if self.RespawnOnContext then
              if self.window_state == "open" then
                self:RespawnContent()
              end
            else
              local respawn_value = self:RespawnExpression(context)
              if rawget(self, "respawn_value") ~= respawn_value then
                self.respawn_value = respawn_value
                if self.window_state == "open" then
                  self:RespawnContent()
                end
              end
            end
            local node = self:ResolveId("node")
            local mode = GetDialog(self).Mode
            if gv_SatelliteView then
              node.idCenterHeading:SetText(mode == "loot" and T({
                288565331426,
                "SECTOR <SectorId(sector)> STASH",
                sector = context.container.sector_id or gv_CurrentSectorId
              }) or T(197418134567, "Squad Supplies"))
            else
              node.idCenterHeading:SetText(mode == "loot" and T(899428826682, "Loot") or T(197418134567, "Squad Supplies"))
            end
          end,
          "RespawnOnContext",
          false
        }, {
          PlaceObj("XTemplateMode", {"mode", "loot"}, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "loot",
              "__context",
              function(parent, context)
                return context.container
              end,
              "__class",
              "XContextWindow"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "IdNode",
                false,
                "Image",
                "UI/Inventory/T_Backpack_Inventory_Container"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__condition",
                  function(parent, context)
                    local unit = GetInventoryUnit()
                    if gv_SatelliteView and unit.Squad and gv_Squads[unit.Squad] and context.sector_id ~= gv_Squads[unit.Squad].CurrentSector then
                      return true
                    end
                    return false
                  end,
                  "__class",
                  "XText",
                  "Id",
                  "idOtherSectorStash",
                  "Margins",
                  box(24, 0, 24, 0),
                  "HAlign",
                  "left",
                  "VAlign",
                  "top",
                  "MinWidth",
                  430,
                  "MinHeight",
                  60,
                  "MaxWidth",
                  430,
                  "MaxHeight",
                  60,
                  "TextStyle",
                  "InventoryWarning",
                  "Translate",
                  true,
                  "Text",
                  T(553785802738, "The selected squad is not in the sector"),
                  "TextHAlign",
                  "center",
                  "TextVAlign",
                  "center"
                }),
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "inventory list",
                  "__class",
                  "XScrollArea",
                  "Id",
                  "idScrollAreaCenter",
                  "Margins",
                  box(0, 20, 0, 65),
                  "LayoutMethod",
                  "VList",
                  "LayoutVSpacing",
                  10,
                  "VScroll",
                  "idScrollbarCenter"
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnXButtonRepeat(self, button, controler_id)",
                    "func",
                    function(self, button, controler_id)
                      local pt = GamepadMouseGetPos()
                      if button == "RightThumbUp" or button == "RightThumbUpLeft" or button == "RightThumbUpRight" then
                        self:SetMouseWheelStep(self.MouseWheelStep + 30)
                        return self:OnMouseWheelForward(pt)
                      elseif button == "RightThumbDown" or button == "RightThumbDownLeft" or button == "RightThumbDownRight" then
                        self:SetMouseWheelStep(self.MouseWheelStep + 30)
                        return self:OnMouseWheelBack(pt)
                      end
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnXButtonDown(self, button, controler_id)",
                    "func",
                    function(self, button, controler_id)
                      if button == "RightThumbUp" or button == "RightThumbUpLeft" or button == "RightThumbUpRight" then
                        return self:OnMouseWheelForward()
                      elseif button == "RightThumbDown" or button == "RightThumbDownLeft" or button == "RightThumbDownRight" then
                        return self:OnMouseWheelBack()
                      end
                      return XScrollArea.OnXButtonDown(self, button, controler_id)
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnXButtonUp(self, button, controler_id)",
                    "func",
                    function(self, button, controler_id)
                      if button == "RightThumbUp" or button == "RightThumbUpLeft" or button == "RightThumbUpRight" or button == "RightThumbDown" or button == "RightThumbDownLeft" or button == "RightThumbDownRight" then
                        self:SetMouseWheelStep(80)
                      end
                      return XScrollArea.OnXButtonUp(self, button, controler_id)
                    end
                  }),
                  PlaceObj("XTemplateForEach", {
                    "array",
                    function(parent, context)
                      return InventoryGetLootContainers(context)
                    end,
                    "__context",
                    function(parent, context, item, i, n)
                      return item
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                      child.container = context
                      if IsKindOf(context, "ItemContainer") then
                        local unit = GetInventoryUnit()
                        if not context:IsOpened() then
                          NetSyncEvent("OpenContainer", context, unit.session_id)
                        end
                        if i ~= 1 and IsKindOf(context, "Interactable") then
                          context:LogInteraction(unit, {id = "ProxyLoot"})
                        end
                      end
                      local name = T(495002164195, "BAG")
                      local is_sector_stash = IsKindOf(context, "SectorStash")
                      if is_sector_stash then
                        name = Untranslated("   ")
                      elseif IsKindOf(context, "Unit") then
                        name = context:IsMerc() and T(185167895211, "<Nick> BODY") or T(698760915819, "DEAD BODY")
                      elseif context:HasMember("spawner") and IsKindOf(context.spawner, "ContainerMarker") then
                        name = context.spawner.DisplayName or T(495002164195, "BAG")
                      elseif context:HasMember("DisplayName") then
                        name = context.DisplayName
                      end
                      child.idName:SetText(name)
                      if not IsMerc(context) then
                        context:ForEachItem(function(item)
                          if not g_GossipItemsSeenByPlayer[item.id] and not g_GossipItemsTakenByPlayer[item.id] and not g_GossipItemsMoveFromPlayerToContainer[item.id] then
                            g_GossipItemsSeenByPlayer[item.id] = true
                            NetGossip("Loot", "PlayerSeen", item.class, rawget(item, "Amount") or 1, GetCurrentPlaytime(), Game and Game.CampaignTime)
                          end
                        end)
                      end
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContentTemplate",
                      "Margins",
                      box(24, 0, 24, 0),
                      "LayoutMethod",
                      "VList",
                      "RespawnOnContext",
                      false
                    }, {
                      PlaceObj("XTemplateWindow", nil, {
                        PlaceObj("XTemplateWindow", {
                          "__condition",
                          function(parent, context)
                            return context
                          end,
                          "__class",
                          "XText",
                          "Id",
                          "idName",
                          "Padding",
                          box(6, 2, 2, 2),
                          "TextStyle",
                          "InventoryBackpackTitle",
                          "Translate",
                          true,
                          "Text",
                          T(575554482996, "BAG"),
                          "TextVAlign",
                          "center"
                        })
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__condition",
                        function(parent, context)
                          return context and IsKindOf(context, "Unit")
                        end,
                        "__class",
                        "BrowseInventorySlot",
                        "Id",
                        "idInventorySlot",
                        "HAlign",
                        "left",
                        "UniformColumnWidth",
                        true,
                        "UniformRowHeight",
                        true,
                        "slot_name",
                        "InventoryDead"
                      }, {
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "Open",
                          "func",
                          function(self, ...)
                            BrowseInventorySlot.Open(self, ...)
                            local dlg = GetDialog(self)
                            dlg.slots[self] = true
                          end
                        }),
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "OnDelete",
                          "func",
                          function(self, ...)
                            local dlg = GetDialog(self)
                            dlg.slots[self] = nil
                          end
                        })
                      }),
                      PlaceObj("XTemplateWindow", {
                        "__condition",
                        function(parent, context)
                          return context and not IsKindOf(context, "Unit")
                        end,
                        "__class",
                        "BrowseInventorySlot",
                        "Id",
                        "idInventorySlot",
                        "HAlign",
                        "left",
                        "UniformColumnWidth",
                        true,
                        "UniformRowHeight",
                        true,
                        "slot_name",
                        "Inventory"
                      }, {
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "Open",
                          "func",
                          function(self, ...)
                            BrowseInventorySlot.Open(self, ...)
                            local dlg = GetDialog(self)
                            dlg.slots[self] = true
                          end
                        }),
                        PlaceObj("XTemplateFunc", {
                          "name",
                          "OnDelete",
                          "func",
                          function(self, ...)
                            local dlg = GetDialog(self)
                            dlg.slots[self] = nil
                          end
                        })
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XZuluScroll",
                  "Id",
                  "idScrollbarCenter",
                  "Margins",
                  box(0, 30, 10, 65),
                  "HAlign",
                  "right",
                  "MouseCursor",
                  "UI/Cursors/Hand.tga",
                  "Target",
                  "idScrollAreaCenter",
                  "Max",
                  9999,
                  "AutoHide",
                  true
                }),
                PlaceObj("XTemplateWindow", {
                  "ZOrder",
                  2,
                  "Margins",
                  box(0, 0, 0, 20),
                  "VAlign",
                  "bottom",
                  "DrawOnTop",
                  true
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "comment",
                    "ammo pack -  set invisble",
                    "__condition",
                    function(parent, context)
                      local host = GetActionsHost(parent, true)
                      local context = host:GetContext()
                      return context.container
                    end,
                    "__template",
                    "InventoryActionBarButtonCenter",
                    "HAlign",
                    "left",
                    "VAlign",
                    "bottom",
                    "MinWidth",
                    240,
                    "MaxHeight",
                    240,
                    "Visible",
                    false,
                    "OnPressEffect",
                    "action",
                    "OnPressParam",
                    "AmmoPack"
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "IsDropTarget(self, draw_win, pt)",
                      "func",
                      function(self, draw_win, pt)
                        return true
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnDropEnter(self, draw_win, pt, drag_source)",
                      "func",
                      function(self, draw_win, pt, drag_source)
                        self:SetRollover(true)
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnDropLeave(self, drag_win)",
                      "func",
                      function(self, drag_win)
                        self:SetRollover(false)
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "OnDrop(self, drag_win, pt, drag_source_win)",
                      "func",
                      function(self, drag_win, pt, drag_source_win)
                        local dlg = GetDialog(self)
                        dlg:ChangeContainerMode("ammo")
                        return "not valid target"
                      end
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idWarningText",
                    "Margins",
                    box(0, 0, 0, 40),
                    "HAlign",
                    "center",
                    "VAlign",
                    "bottom",
                    "Visible",
                    false,
                    "FoldWhenHidden",
                    true,
                    "TextStyle",
                    "InventoryActionsTextRedBig",
                    "Translate",
                    true,
                    "Text",
                    T(657578945215, "Inventory is full"),
                    "HideOnEmpty",
                    true
                  }),
                  PlaceObj("XTemplateTemplate", {
                    "comment",
                    "takeall",
                    "__condition",
                    function(parent, context)
                      local host = GetActionsHost(parent, true)
                      local context = host:GetContext()
                      return context.container
                    end,
                    "__template",
                    "InventoryActionBarButtonCenter",
                    "HAlign",
                    "center",
                    "VAlign",
                    "bottom",
                    "MinWidth",
                    240,
                    "MaxHeight",
                    240,
                    "OnContextUpdate",
                    function(self, context, ...)
                      local host = GetActionsHost(self.parent, true)
                      local hidden = host:TakeAllState() == "hidden"
                      self:SetVisible(not hidden)
                    end,
                    "OnPressEffect",
                    "action",
                    "OnPressParam",
                    "TakeAll"
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "Open",
                      "func",
                      function(self, ...)
                        XTextButton.Open(self)
                        if self.action then
                          self:SetText(self.action.ActionName)
                        end
                        local host = GetActionsHost(self.parent, true)
                        local hidden = host:TakeAllState() == "hidden"
                        self:SetVisible(not hidden)
                      end
                    }),
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "Press(self, alt, force, gamepad)",
                      "func",
                      function(self, alt, force, gamepad)
                        local dlg = GetDialog(self)
                        dlg:TakeAllStateWarning(self)
                        XTextButton.Press(self, alt, force, gamepad)
                      end
                    })
                  })
                })
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "AmmoPack",
                "ActionName",
                T(599664273908, "SQUAD SUPPLIES"),
                "ActionShortcut",
                "A",
                "ActionState",
                function(self, host)
                  local context = host:GetContext()
                  return context.container and "enabled" or "hidden"
                end,
                "OnAction",
                function(self, host, source, ...)
                end
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "TakeAll",
                "ActionName",
                T(867497972621, "TAKE ALL"),
                "ActionShortcut",
                "T",
                "ActionGamepad",
                "ButtonY",
                "ActionState",
                function(self, host)
                  return host:TakeAllState()
                end,
                "OnAction",
                function(self, host, source, ...)
                  return host:TakeAllAction()
                end
              })
            })
          }),
          PlaceObj("XTemplateMode", {"mode", "ammo"}, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "ammo",
              "__class",
              "XContextWindow"
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "IdNode",
                false,
                "Image",
                "UI/Inventory/T_Backpack_Inventory_Container"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XScrollArea",
                  "Id",
                  "idScrollAreaCenter",
                  "Margins",
                  box(0, 20, 0, 65),
                  "LayoutMethod",
                  "VList",
                  "LayoutVSpacing",
                  10,
                  "VScroll",
                  "idScrollbarCenter"
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnXButtonRepeat(self, button, controler_id)",
                    "func",
                    function(self, button, controler_id)
                      local pt = GamepadMouseGetPos()
                      if button == "RightThumbUp" or button == "RightThumbUpLeft" or button == "RightThumbUpRight" then
                        self:SetMouseWheelStep(self.MouseWheelStep + 30)
                        return self:OnMouseWheelForward(pt)
                      elseif button == "RightThumbDown" or button == "RightThumbDownLeft" or button == "RightThumbDownRight" then
                        self:SetMouseWheelStep(self.MouseWheelStep + 30)
                        return self:OnMouseWheelBack(pt)
                      end
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnXButtonDown(self, button, controler_id)",
                    "func",
                    function(self, button, controler_id)
                      if button == "RightThumbUp" or button == "RightThumbUpLeft" or button == "RightThumbUpRight" then
                        return self:OnMouseWheelForward()
                      elseif button == "RightThumbDown" or button == "RightThumbDownLeft" or button == "RightThumbDownRight" then
                        return self:OnMouseWheelBack()
                      end
                      return XScrollArea.OnXButtonDown(self, button, controler_id)
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnXButtonUp(self, button, controler_id)",
                    "func",
                    function(self, button, controler_id)
                      if button == "RightThumbUp" or button == "RightThumbUpLeft" or button == "RightThumbUpRight" or button == "RightThumbDown" or button == "RightThumbDownLeft" or button == "RightThumbDownRight" then
                        self:SetMouseWheelStep(80)
                      end
                      return XScrollArea.OnXButtonUp(self, button, controler_id)
                    end
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__context",
                    function(parent, context)
                      return context and context.unit and context.unit.Squad and GetSquadBagInventory(context.unit.Squad, "small")
                    end,
                    "__class",
                    "XContentTemplate",
                    "Id",
                    "idSquadBag",
                    "Margins",
                    box(24, 0, 24, 0),
                    "LayoutMethod",
                    "VList",
                    "RespawnOnContext",
                    false
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "just to save space",
                      "Visible",
                      false
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__condition",
                        function(parent, context)
                          return context
                        end,
                        "__class",
                        "XText",
                        "Id",
                        "idName",
                        "Padding",
                        box(6, 2, 2, 2),
                        "TextStyle",
                        "InventoryBackpackTitle",
                        "Translate",
                        true,
                        "Text",
                        T(723855553115, "BAG"),
                        "TextVAlign",
                        "center"
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__condition",
                      function(parent, context)
                        return context
                      end,
                      "__class",
                      "BrowseInventorySlot",
                      "Id",
                      "idInventorySlot",
                      "HAlign",
                      "left",
                      "UniformColumnWidth",
                      true,
                      "UniformRowHeight",
                      true,
                      "slot_name",
                      "Inventory"
                    }, {
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "Open",
                        "func",
                        function(self, ...)
                          BrowseInventorySlot.Open(self, ...)
                          local dlg = GetDialog(self)
                          dlg.slots[self] = true
                        end
                      }),
                      PlaceObj("XTemplateFunc", {
                        "name",
                        "OnDelete",
                        "func",
                        function(self, ...)
                          local dlg = GetDialog(self)
                          dlg.slots[self] = nil
                        end
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XZuluScroll",
                  "Id",
                  "idScrollbarCenter",
                  "Margins",
                  box(0, 30, 10, 65),
                  "HAlign",
                  "right",
                  "MouseCursor",
                  "UI/Cursors/Hand.tga",
                  "Target",
                  "idScrollAreaCenter",
                  "Max",
                  9999,
                  "AutoHide",
                  true
                }),
                PlaceObj("XTemplateWindow", {
                  "ZOrder",
                  2,
                  "Margins",
                  box(0, 0, 0, 20),
                  "VAlign",
                  "bottom",
                  "DrawOnTop",
                  true
                }, {
                  PlaceObj("XTemplateTemplate", {
                    "comment",
                    "loot",
                    "__condition",
                    function(parent, context)
                      local host = GetActionsHost(parent, true)
                      local context = host:GetContext()
                      return context.container
                    end,
                    "__template",
                    "InventoryActionBarButtonCenter",
                    "HAlign",
                    "left",
                    "VAlign",
                    "bottom",
                    "MinWidth",
                    240,
                    "MaxHeight",
                    240,
                    "OnPressEffect",
                    "action",
                    "OnPressParam",
                    "Loot"
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "IsDropTarget(self, draw_win, pt)",
                    "func",
                    function(self, draw_win, pt)
                      return true
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnDropEnter(self, draw_win, pt, drag_source)",
                    "func",
                    function(self, draw_win, pt, drag_source)
                      self:SetRollover(true)
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnDropLeave(self, drag_win)",
                    "func",
                    function(self, drag_win)
                      self:SetRollover(false)
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnDrop(self, drag_win, pt, drag_source_win)",
                    "func",
                    function(self, drag_win, pt, drag_source_win)
                      local dlg = GetDialog(self)
                      dlg:ChangeContainerMode("loot")
                      return "not valid target"
                    end
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idWarningText",
                    "Margins",
                    box(0, 0, 0, 40),
                    "HAlign",
                    "center",
                    "VAlign",
                    "bottom",
                    "Visible",
                    false,
                    "FoldWhenHidden",
                    true,
                    "TextStyle",
                    "InventoryActionsTextRedBig",
                    "Translate",
                    true,
                    "Text",
                    T(657578945215, "Inventory is full"),
                    "HideOnEmpty",
                    true
                  }),
                  PlaceObj("XTemplateTemplate", {
                    "comment",
                    "take loot",
                    "__condition",
                    function(parent, context)
                      local host = GetActionsHost(parent, true)
                      local context = host:GetContext()
                      return context.container and InventoryIsValidTargetForUnit(context.container)
                    end,
                    "__template",
                    "InventoryActionBarButtonCenter",
                    "HAlign",
                    "right",
                    "VAlign",
                    "bottom",
                    "MinWidth",
                    240,
                    "MaxHeight",
                    240,
                    "OnPressEffect",
                    "action",
                    "OnPressParam",
                    "TakeLoot"
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "Press(self, alt, force, gamepad)",
                      "func",
                      function(self, alt, force, gamepad)
                        local dlg = GetDialog(self)
                        dlg:TakeAllStateWarning(self)
                        XTextButton.Press(self, alt, force, gamepad)
                      end
                    })
                  })
                })
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "Loot",
                "ActionName",
                T(130903108184, "Show Loot"),
                "ActionToolbar",
                "ActionBarCenter",
                "ActionShortcut",
                "L",
                "ActionState",
                function(self, host)
                  local context = host:GetContext()
                  if not context.container then
                    return "hidden"
                  end
                  return "enabled"
                end,
                "OnAction",
                function(self, host, source, ...)
                  host:ChangeContainerMode("loot")
                end
              }),
              PlaceObj("XTemplateAction", {
                "ActionId",
                "TakeLoot",
                "ActionName",
                T(435910084510, "Take Loot"),
                "ActionToolbar",
                "ActionBarCenter",
                "ActionShortcut",
                "T",
                "ActionGamepad",
                "ButtonY",
                "ActionState",
                function(self, host)
                  return host:TakeAllState()
                end,
                "OnAction",
                function(self, host, source, ...)
                  host:SetMode("loot")
                  return host:TakeAllAction()
                end
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "right - backpacks",
        "Margins",
        box(26, 18, 32, 32),
        "HAlign",
        "right",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "center",
          "TextStyle",
          "InventoryContainerTitle",
          "Translate",
          true,
          "Text",
          T(995023004139, "Squad Backpacks")
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "right",
          "__class",
          "XContentTemplate",
          "Id",
          "idRight",
          "IdNode",
          false,
          "Margins",
          box(0, 20, 0, 0),
          "MinWidth",
          706,
          "MinHeight",
          752,
          "MaxWidth",
          706,
          "MaxHeight",
          752,
          "Clip",
          "parent & self",
          "RespawnOnContext",
          false
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "IdNode",
            false,
            "Image",
            "UI/Inventory/T_Backpack_Inventory_Container",
            "ImageFit",
            "stretch"
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "inventory list",
            "__class",
            "XScrollArea",
            "Id",
            "idScrollArea",
            "Margins",
            box(0, 20, 0, 30),
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            10,
            "VScroll",
            "idScrollbar"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "OnXButtonRepeat(self, button, controler_id)",
              "func",
              function(self, button, controler_id)
                local pt = GamepadMouseGetPos()
                if button == "RightThumbUp" or button == "RightThumbUpLeft" or button == "RightThumbUpRight" then
                  self:SetMouseWheelStep(self.MouseWheelStep + 30)
                  return self:OnMouseWheelForward(pt)
                elseif button == "RightThumbDown" or button == "RightThumbDownLeft" or button == "RightThumbDownRight" then
                  self:SetMouseWheelStep(self.MouseWheelStep + 30)
                  return self:OnMouseWheelBack(pt)
                end
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnXButtonDown(self, button, controler_id)",
              "func",
              function(self, button, controler_id)
                if button == "RightThumbUp" or button == "RightThumbUpLeft" or button == "RightThumbUpRight" then
                  return self:OnMouseWheelForward()
                elseif button == "RightThumbDown" or button == "RightThumbDownLeft" or button == "RightThumbDownRight" then
                  return self:OnMouseWheelBack()
                end
                return XScrollArea.OnXButtonDown(self, button, controler_id)
              end
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnXButtonUp(self, button, controler_id)",
              "func",
              function(self, button, controler_id)
                if button == "RightThumbUp" or button == "RightThumbUpLeft" or button == "RightThumbUpRight" or button == "RightThumbDown" or button == "RightThumbDownLeft" or button == "RightThumbDownRight" then
                  self:SetMouseWheelStep(80)
                end
                return XScrollArea.OnXButtonUp(self, button, controler_id)
              end
            }),
            PlaceObj("XTemplateForEach", {
              "array",
              function(parent, context)
                return context and context.unit and context.unit.Squad and gv_Squads[context.unit.Squad].units
              end,
              "condition",
              function(parent, context, item, i)
                return context
              end,
              "__context",
              function(parent, context, item, i, n)
                if not item then
                  return false
                end
                local unit
                if gv_SatelliteView then
                  unit = gv_UnitData[item]
                else
                  unit = g_Units[item] or gv_UnitData[item]
                end
                return unit
              end,
              "run_after",
              function(child, context, item, i, n, last)
                child.unit = context
                if InventoryUIGrayOut(context) then
                  child:SetTransparency(150)
                end
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XContentTemplate",
                "LayoutMethod",
                "VList",
                "RespawnOnContext",
                false
              }, {
                PlaceObj("XTemplateCode", {
                  "run",
                  function(self, parent, context)
                    if InventoryIsNotControlled(context) then
                      parent.RespawnOnContext = true
                    end
                  end
                }),
                PlaceObj("XTemplateWindow", {
                  "Margins",
                  box(26, 0, 0, 0)
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__condition",
                    function(parent, context)
                      return context
                    end,
                    "__class",
                    "XText",
                    "Id",
                    "idName",
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "InventoryBackpackTitle",
                    "Translate",
                    true,
                    "Text",
                    T(396385158705, "<Nick> BACKPACK"),
                    "TextVAlign",
                    "center"
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "SetHightlighted(self, show)",
                      "func",
                      function(self, show)
                        local dlg = GetDialog(self)
                        local show = show or dlg.selected_unit.session_id == self:GetContext().session_id
                        self:SetTextStyle(not show and "InventoryBackpackTitle" or "InventoryBackpackTitleHighlight")
                      end
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__condition",
                  function(parent, context)
                    return context
                  end,
                  "__class",
                  "BrowseInventorySlot",
                  "Id",
                  "idInventorySlot",
                  "Margins",
                  box(24, 0, 0, 0),
                  "HAlign",
                  "left",
                  "UniformColumnWidth",
                  true,
                  "UniformRowHeight",
                  true,
                  "slot_name",
                  "Inventory"
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "Open",
                    "func",
                    function(self, ...)
                      BrowseInventorySlot.Open(self, ...)
                      local dlg = GetDialog(self)
                      dlg.slots[self] = true
                      if dlg.context.unit and self.context.session_id == dlg.context.unit.session_id then
                        self.parent.idName:SetHightlighted(true)
                      end
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnDelete",
                    "func",
                    function(self, ...)
                      local dlg = GetDialog(self)
                      dlg.slots[self] = nil
                    end
                  })
                })
              })
            }),
            PlaceObj("XTemplateMode", {"mode", "loot"}, {
              PlaceObj("XTemplateWindow", {
                "__context",
                function(parent, context)
                  return context and context.unit and context.unit.Squad and GetSquadBagInventory(context.unit.Squad, "large")
                end,
                "__class",
                "XContentTemplate",
                "Id",
                "idSquadBag",
                "LayoutMethod",
                "VList",
                "RespawnOnContext",
                false
              }, {
                PlaceObj("XTemplateWindow", {
                  "Margins",
                  box(26, 0, 0, 0)
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__condition",
                    function(parent, context)
                      return context
                    end,
                    "__class",
                    "XText",
                    "Id",
                    "idName",
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "InventoryBackpackTitle",
                    "Translate",
                    true,
                    "Text",
                    T(141372786399, "Squad Supplies"),
                    "TextVAlign",
                    "center"
                  }, {
                    PlaceObj("XTemplateFunc", {
                      "name",
                      "SetHightlighted(self, show)",
                      "func",
                      function(self, show)
                        self:SetTextStyle(not show and "InventoryBackpackTitle" or "InventoryBackpackTitleHighlight")
                      end
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__condition",
                  function(parent, context)
                    return context
                  end,
                  "__class",
                  "BrowseInventorySlot",
                  "Id",
                  "idInventorySlot",
                  "Margins",
                  box(24, 0, 0, 0),
                  "HAlign",
                  "left",
                  "UniformColumnWidth",
                  true,
                  "UniformRowHeight",
                  true,
                  "slot_name",
                  "Inventory"
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "Open",
                    "func",
                    function(self, ...)
                      BrowseInventorySlot.Open(self, ...)
                      local dlg = GetDialog(self)
                      dlg.slots[self] = true
                    end
                  }),
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnDelete",
                    "func",
                    function(self, ...)
                      local dlg = GetDialog(self)
                      dlg.slots[self] = nil
                    end
                  })
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XZuluScroll",
            "Id",
            "idScrollbar",
            "Margins",
            box(0, 30, 10, 20),
            "HAlign",
            "right",
            "FoldWhenHidden",
            false,
            "MouseCursor",
            "UI/Cursors/Hand.tga",
            "Target",
            "idScrollArea",
            "Max",
            9999,
            "AutoHide",
            true
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "MoveThumb",
              "func",
              function(self, ...)
                XZuluScroll.MoveThumb(self, ...)
                if not self.layout_update then
                  Msg("ScrollInventory")
                end
              end
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idCompare",
        "Margins",
        box(100, 110, 0, 0),
        "Dock",
        "box",
        "HAlign",
        "left",
        "MinWidth",
        855
      })
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "InventoryActionBar",
      "ZOrder",
      2,
      "Margins",
      box(0, 0, 50, 10),
      "MarginPolicy",
      "FitInSafeArea",
      "Dock",
      "box",
      "VAlign",
      "bottom",
      "FoldWhenHidden",
      true,
      "DrawOnTop",
      true,
      "ToolbarName",
      "InventoryActionBar"
    })
  })
})
