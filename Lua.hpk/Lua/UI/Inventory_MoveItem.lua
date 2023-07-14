invprint = CreatePrint({})
function IsReload(ammo, weapon)
  return weapon and IsWeaponReloadTarget(ammo, weapon)
end
function IsMedicineRefill(meds, medicine)
  return medicine and medicine.object_class == "Medicine" and medicine.Condition < medicine:GetMaxCondition() and IsKindOf(meds, "Meds")
end
function GetAPCostAndUnit(item, src_container, src_container_slot_name, dest_container, dest_container_slot_name, item_at_dest, is_reload)
  if not is_reload and not dest_container:CheckClass(item, dest_container_slot_name) then
    return 0, GetInventoryUnit()
  end
  local ap = 0
  local unit = false
  local action_name = false
  local costs = const["Action Point Costs"]
  local are_diff_containers = src_container ~= dest_container
  local is_src_bag = IsKindOf(src_container, "SquadBag")
  local is_dest_bag = IsKindOf(dest_container, "SquadBag")
  local is_src_unit = IsKindOfClasses(src_container, "Unit", "UnitData")
  local is_dest_unit = IsKindOfClasses(dest_container, "Unit", "UnitData")
  local is_src_dead = is_src_unit and src_container:IsDead()
  local is_dest_dead = is_dest_unit and dest_container:IsDead()
  local between_bag_and_unit = is_src_bag and is_dest_unit and not is_src_dead or is_dest_bag and is_src_unit and not is_src_dead
  local is_refill, is_combine
  is_refill = IsMedicineRefill(item, item_at_dest)
  is_combine = not is_dest_dead and not IsKindOf(dest_container, "ItemContainer") and InventoryIsCombineTarget(item, item_at_dest)
  if are_diff_containers and is_dest_bag and (not is_src_unit or is_src_dead) then
    ap = costs.PickItem
    unit = GetInventoryUnit()
    action_name = T(273687388621, "Put in squad supplies")
  end
  if are_diff_containers and not between_bag_and_unit then
    if (not is_src_unit or is_src_dead) and is_dest_unit and not is_dest_dead then
      ap = costs.PickItem
      unit = dest_container
      action_name = T(265622314229, "Put in backpack")
    elseif is_src_unit and is_dest_unit and not is_src_dead and not is_dest_dead and not IsKindOf(item, "SquadBagItem") then
      ap = costs.GiveItem
      unit = src_container
      action_name = T({
        386181237071,
        "Give to <merc>",
        merc = dest_container.Nick
      })
    end
  end
  if is_refill then
    return 0, unit or GetInventoryUnit(), T(479821153570, "Refill")
  end
  if is_combine then
    return 0, unit or GetInventoryUnit(), T(426883432738, "Combine")
  end
  if is_reload then
    local dest_unit = dest_container
    if IsKindOf(dest_unit, "UnitData") then
      dest_unit = g_Units[dest_unit.session_id]
    end
    local inv_unit = GetInventoryUnit()
    unit = IsKindOf(dest_unit, "Unit") and not dest_unit:IsDead() and dest_unit or inv_unit
    local action = CombatActions.Reload
    local pos = dest_container:GetItemPackedPos(item_at_dest)
    ap = ap + action:GetAPCost(unit, {
      weapon = item_at_dest.class,
      pos = pos
    }) or 0
    action_name = T(160472488023, "Reload")
  elseif IsEquipSlot(dest_container_slot_name) and (not (src_container == dest_container and IsEquipSlot(src_container_slot_name)) or src_container_slot_name ~= dest_container_slot_name) then
    ap = ap + item:GetEquipCost()
    unit = dest_container
    action_name = T(622693158009, "Equip")
  end
  if not unit and is_src_unit and IsKindOf(dest_container, "LocalDropContainer") then
    unit = src_container
    action_name = T(778324934848, "Drop")
  end
  unit = unit or GetInventoryUnit()
  return ap, unit, action_name
end
function MergeStackIntoContainer(dest_container, dest_slot, item, check, up_to_amount, local_changes)
  local get_local_changes = function(i)
    return local_changes and local_changes[i] or 0
  end
  local a = Min(item.Amount, up_to_amount)
  local cls = item.class
  local other_stack_items = {}
  dest_container:ForEachItemInSlot(dest_slot, false, function(item_at_dest)
    if item_at_dest.class == cls then
      table.insert(other_stack_items, item_at_dest)
    end
  end)
  table.sort(other_stack_items, function(a, b)
    local a_a = a.Amount + get_local_changes(a)
    local b_a = b.Amount + get_local_changes(a)
    return a_a > b_a
  end)
  for _, item_at_dest in ipairs(other_stack_items) do
    local to_add = item_at_dest.MaxStacks - (item_at_dest.Amount + get_local_changes(item_at_dest))
    to_add = Min(to_add, a)
    if 0 < to_add then
      a = a - to_add
      if not check then
        item.Amount = item.Amount - to_add
        item_at_dest.Amount = item_at_dest.Amount + to_add
      elseif local_changes then
        local_changes[item] = (local_changes[item] or 0) - to_add
        local_changes[item_at_dest] = (local_changes[item_at_dest] or 0) + to_add
      end
      if a <= 0 then
        break
      end
    end
  end
  return a ~= item.Amount, a
end
local packed11 = point_pack(1, 1)
DefineClass.PartialContainer = {
  __parents = {
    "PropertyObject"
  }
}
function PartialContainer:ForEachItemInSlot(...)
end
function PartialContainer:CanAddItem(...)
  return packed11
end
function PartialContainer:CheckClass(...)
  return true
end
function PartialContainer:GetSlotIdx(...)
  return false
end
DefineClass("LocalDropContainer", "PartialContainer")
DefineClass.UnopennedSquadBag = {
  __parents = {
    "PartialContainer"
  },
  squad_id = false
}
function UnopennedSquadBag:GetItemInSlot(...)
  return false
end
function UnopennedSquadBag:CheckClass(item, ...)
  return IsKindOf(item, "SquadBagItem")
end
function UnopennedSquadBag:AddItem(slot_name, item, left, top, local_execution)
  AddItemsToSquadBag(self.squad_id, {item})
  return packed11
end
function UnopennedSquadBag:ForEachItemInSlot(slot_name, base_class, fn, ...)
  local bag = GetSquadBag(self.squad_id)
  local arg1
  if type(base_class) == "function" then
    arg1 = fn
    fn = base_class
    base_class = false
  end
  for _, item in ipairs(bag) do
    if not base_class or IsKindOfClasses(item, base_class) then
      local res
      if arg1 ~= nil then
        res = fn(item, slot_name, -1, -1, arg1, ...)
      else
        res = fn(item, slot_name, -1, -1, ...)
      end
      if res == "break" then
        return "break"
      end
    end
  end
end
function GetContainerNetId(container)
  if not container then
    return
  end
  local net_context = container
  if IsKindOfClasses(container, "UnitData", "Unit") then
    net_context = container.session_id
  elseif IsKindOf(container, "SectorStash") then
    net_context = container.sector_id
  elseif IsKindOf(container, "SquadBag") then
    net_context = point_pack(container.squad_id, container.ui_mode == "large" and 1 or 0)
  elseif IsKindOf(container, "LocalDropContainer") then
    net_context = "drop"
  elseif IsKindOf(container, "UnopennedSquadBag") then
    net_context = point_pack(container.squad_id, -1)
  end
  return net_context
end
function GetContainerFromContainerNetId(net_id)
  if type(net_id) == "number" then
    local id, mode = point_unpack(net_id)
    if mode == -1 then
      net_id = PlaceObject("UnopennedSquadBag", {squad_id = id})
    else
      net_id = GetSquadBagInventory(id, mode == 1 and "large" or "small")
    end
  elseif type(net_id) == "string" and net_id ~= "drop" then
    net_id = gv_SatelliteView and gv_UnitData[net_id] or g_Units[net_id] or GetSectorInventory(net_id) or gv_UnitData[net_id]
  end
  return net_id
end
function GetContainerSlotNetId(container, slot)
  if container then
    return container:GetSlotIdx(slot)
  end
end
function GetContainerSlotFromContainerSlotNetId(container, net_id)
  if container and net_id then
    return container.inventory_slots[net_id].slot_name
  end
end
local dbgMoveItem = true
g_ItemNetEvents = {MoveItems = true, DestroyItem = true}
function MoveItemsNetEvent(data)
  NetUpdateHash("MoveItemResults", MoveItem(MoveItem_RecieveNetArgs(data)))
end
function CustomCombatActions.MoveItems(unit, ap, data)
  MoveItemsNetEvent(data)
end
function NetSyncEvents.MoveItems(data)
  MoveItemsNetEvent(data)
end
function MoveItem_RecieveNetArgs(data)
  local item, src_container, src_container_slot_name, dest_container, dest_container_slot_name, dest_x, dest_y, amount, merge_up_to_amount, exec_locally, src_x, src_y, item_at_dest, alternative_swap_pos, sync_unit, player_id = unpack_params(data)
  local args = {}
  args.item = g_ItemIdToItem[item]
  args.src_container = GetContainerFromContainerNetId(src_container)
  args.dest_container = GetContainerFromContainerNetId(dest_container)
  args.src_container_slot_name = GetContainerSlotFromContainerSlotNetId(args.src_container, src_container_slot_name)
  args.dest_container_slot_name = GetContainerSlotFromContainerSlotNetId(args.dest_container, dest_container_slot_name)
  args.dest_x = dest_x
  args.dest_y = dest_y
  args.amount = amount
  args.merge_up_to_amount = merge_up_to_amount
  args.exec_locally = exec_locally
  args.s_src_x = src_x
  args.s_src_y = src_y
  args.s_sync_unit = GetContainerFromContainerNetId(sync_unit)
  args.s_item_at_dest = item_at_dest and g_ItemIdToItem[item_at_dest]
  args.s_player_id = player_id
  args.sync_call = true
  args.alternative_swap_pos = alternative_swap_pos
  return args
end
function MoveItem_SendNetArgs(item, src_container, src_container_slot_name, dest_container, dest_container_slot_name, dest_x, dest_y, amount, merge_up_to_amount, exec_locally, src_x, src_y, item_at_dest, alternative_swap_pos, sync_unit)
  return pack_params(item.id, GetContainerNetId(src_container), GetContainerSlotNetId(src_container, src_container_slot_name), GetContainerNetId(dest_container), GetContainerSlotNetId(dest_container, dest_container_slot_name), dest_x, dest_y, amount, merge_up_to_amount, exec_locally, src_x, src_y, item_at_dest and item_at_dest.id, alternative_swap_pos, GetContainerNetId(sync_unit), netUniqueId)
end
function MoveItem_UpdateUnitOutfit(src_container, dest_container, check_only)
  NetUpdateHash("MoveItem_UpdateUnitOutfit", src_container, dest_container, check_only)
  if check_only then
    return
  end
  local has_unit
  if IsKindOfClasses(src_container, "Unit") then
    src_container:UpdatePreparedAttackAndOutfit()
    ObjModified(src_container)
    Msg("InventoryChange", src_container)
    has_unit = true
  end
  if IsKindOfClasses(dest_container, "Unit") and src_container ~= dest_container then
    dest_container:UpdatePreparedAttackAndOutfit()
    ObjModified(dest_container)
    Msg("InventoryChange", dest_container)
    has_unit = true
  end
  if has_unit then
    ObjModified("hud weapon context")
  end
  local igi = GetInGameInterfaceModeDlg()
  if IsKindOf(igi, "IModeCombatMovement") and igi.targeting_blackboard and igi.targeting_blackboard.movement_avatar then
    UpdateMovementAvatar(igi, nil, nil, "update_weapon")
  end
end
if FirstLoad then
  g_MoveItemLocalChanges = {}
end
MoveItem_CombinesItems = true
function MoveItem(args)
  local item = args.item
  local src_container = args.src_container
  local src_container_slot_name = args.src_container_slot_name or args.src_slot
  local dest_container = args.dest_container
  local dest_container_slot_name = args.dest_container_slot_name or args.dest_slot
  local dest_x = args.dest_x or args.x
  local dest_y = args.dest_y or args.y
  local amount = args.amount
  local check_only = args.check_only
  local ap_cost = args.ap_cost
  local merge_up_to_amount = args.merge_up_to_amount
  local local_changes = args.local_changes
  local exec_locally = args.exec_locally
  local sync_call = args.sync_call
  local s_src_x = args.s_src_x
  local s_src_y = args.s_src_y
  local s_item_at_dest = args.s_item_at_dest
  local s_sync_unit = args.s_sync_unit
  local s_player_id = args.s_player_id
  local alternative_swap_pos = args.alternative_swap_pos
  if sync_call then
    NetUpdateHash("MoveItem", item and item.class, item and item.id, dest_container and type(dest_container) == "table" and dest_container.class or dest_container, dest_container_slot_name, src_container and src_container.class, src_container_slot_name)
  end
  exec_locally = not not exec_locally
  if dest_container == "drop" then
    dest_container_slot_name = "Inventory"
    if sync_call then
      dest_container = GetDropContainer(s_sync_unit, false, item)
    else
      dest_container = PlaceObject("LocalDropContainer")
    end
  elseif type(dest_container) == "number" then
    dest_container = PlaceObject("UnopennedSquadBag", {squad_id = dest_container})
  end
  local src_x, src_y
  if src_container then
    src_x, src_y = src_container:GetItemPosInSlot(src_container_slot_name, item)
    if not src_x then
      return "item not found in src container!"
    elseif not s_src_x then
      s_src_x = src_x
      s_src_y = src_y
    end
  end
  local item_at_dest = dest_x and dest_container:GetItemInSlot(dest_container_slot_name, nil, dest_x, dest_y)
  if item_at_dest == item then
    item_at_dest = false
  end
  local item_at_dest_2 = false
  if dest_x and item.LargeItem then
    local other_item_at_dest = dest_container:GetItemInSlot(dest_container_slot_name, nil, dest_x + 1, dest_y)
    if other_item_at_dest == item then
      other_item_at_dest = false
    end
    if item_at_dest and other_item_at_dest and other_item_at_dest ~= item_at_dest then
      if IsEquipSlot(dest_container_slot_name) then
        item_at_dest_2 = other_item_at_dest
      else
        return "too many items underneath"
      end
    end
    if not item_at_dest and other_item_at_dest then
      item_at_dest = other_item_at_dest
    end
  end
  if src_x and dest_x and not item.LargeItem and item_at_dest and item_at_dest.LargeItem then
    local other_item_at_dest = dest_container:GetItemInSlot(dest_container_slot_name, nil, dest_x + 1, dest_y)
    if other_item_at_dest ~= item_at_dest then
      src_x = src_x - 1
    end
  end
  if dbgMoveItem then
    invprint("MoveItem sync", sync_call, "check_only", check_only, "amount", amount, string.format("moving %s %s from %s %s %d %d to %s %s %d %d, item_at_dest %s %s", item.class, tostring(item.id), src_container and src_container.session_id or src_container and src_container.class or false, src_container_slot_name, src_x or -1, src_y or -1, dest_container.session_id or dest_container.class, tostring(dest_container_slot_name), dest_x or -1, dest_y or -1, item_at_dest and item_at_dest.class or tostring(item_at_dest), item_at_dest and tostring(item_at_dest.id) or "n/a"))
  end
  if not sync_call or item_at_dest == s_item_at_dest and src_x == s_src_x and src_y == s_src_y or IsKindOf(src_container, "SectorStash") and item_at_dest == s_item_at_dest then
  elseif IsKindOf(dest_container, "SectorStash") then
    if item_at_dest and not s_item_at_dest then
      item_at_dest = false
      dest_x = nil
      dest_y = nil
    elseif s_item_at_dest then
      item_at_dest = s_item_at_dest
      dest_x, dest_y = dest_container:GetItemPosInSlot(dest_container_slot_name, item_at_dest)
    end
  else
    NetUpdateHash("MoveItem state changed", item_at_dest and item_at_dest.class or "no item_at_dest", s_item_at_dest and s_item_at_dest.class or "no s_item_at_dest", src_x, s_src_x, src_y, s_src_y, src_container, dest_container)
    return "state has changed"
  end
  if not item_at_dest and src_x == dest_x and src_y == dest_y and src_container == dest_container and src_container_slot_name == dest_container_slot_name then
    if dbgMoveItem then
      invprint("no change required")
    end
    return false, "no change"
  end
  local is_reload = IsReload(item, item_at_dest)
  local is_refill = IsMedicineRefill(item, item_at_dest)
  local is_combine = (not IsKindOf(dest_container, "Unit") or not dest_container:IsDead()) and not IsKindOf(dest_container, "ItemContainer") and MoveItem_CombinesItems and InventoryIsCombineTarget(item, item_at_dest)
  if src_container and item.locked then
    return "item is locked"
  end
  if not is_reload and not is_refill then
    if item_at_dest and item_at_dest.locked then
      return "item underneath is locked"
    end
    if item_at_dest_2 and item_at_dest_2.locked then
      return "item underneath is locked"
    end
  end
  local is_local_changes = exec_locally and not sync_call
  local item_is_stack = IsKindOf(item, "InventoryStack")
  local partial_stack_merge = false
  if not is_reload and not is_combine and not is_refill and not dest_container:CheckClass(item, dest_container_slot_name) then
    return "Can't add item to container, wrong class"
  end
  local sync_ap, sync_unit
  if not sync_call then
    sync_ap, sync_unit = GetAPCostAndUnit(item, src_container, src_container_slot_name, dest_container, dest_container_slot_name, item_at_dest, is_reload)
    sync_ap = ap_cost or sync_ap
    if dbgMoveItem then
      invprint("MoveItem ap cost", sync_ap, "InventoryIsCombatMode()", InventoryIsCombatMode())
    end
    if InventoryIsCombatMode() then
      if not sync_unit:UIHasAP(sync_ap) then
        return is_reload and "Unit doesn't have ap to reload" or "Unit doesn't have ap to execute action", false, sync_unit
      end
    else
      sync_ap = 0
    end
  end
  local sync_err = false
  local Sync = function()
    if check_only then
      return true
    end
    if not sync_call then
      local args = MoveItem_SendNetArgs(item, src_container, src_container_slot_name, dest_container, dest_container_slot_name, dest_x, dest_y, amount, merge_up_to_amount, exec_locally, src_x, src_y, item_at_dest, alternative_swap_pos, sync_unit)
      if IsKindOf(sync_unit, "UnitData") then
        NetSyncEvent("MoveItems", args)
      elseif not NetStartCombatAction("MoveItems", sync_unit, sync_ap, args) then
        sync_err = "NetStartCombatAction refused to start"
      end
      if not exec_locally or is_reload or is_refill then
        return true
      end
    end
    return false
  end
  if not item_at_dest then
    local merge_stacks = item_is_stack and not dest_x and not amount
    local local_stack_changes = local_changes and local_changes.local_stack_changes or false
    local local_items_moved = local_changes and local_changes.local_items_moved or false
    local p_pos, reason
    if merge_stacks then
      local is_mergable, new_amount = MergeStackIntoContainer(dest_container, dest_container_slot_name, item, "check", merge_up_to_amount, local_stack_changes)
      if not is_mergable or 0 < new_amount then
        p_pos, reason = dest_container:CanAddItem(dest_container_slot_name, item, dest_x, dest_y, local_items_moved)
        if not p_pos then
          if not is_mergable then
            return "move failed, no part of the stack is transferable and dest inventory refused item", reason, sync_unit
          else
            partial_stack_merge = new_amount
          end
        end
      end
    else
      p_pos, reason = dest_container:CanAddItem(dest_container_slot_name, item, dest_x, dest_y, local_items_moved)
      if not p_pos then
        return "move failed, dest inventory refused item, reason", reason, sync_unit
      end
    end
    local x, y
    if p_pos then
      x, y = point_unpack(p_pos)
      if local_items_moved then
        local_items_moved[xxhash(x, y)] = item
        if item.LargeItem then
          local_items_moved[xxhash(x + 1, y)] = item
        end
      end
    end
    if Sync() then
      return sync_err, partial_stack_merge, sync_unit
    end
    local DoMove = function()
      if src_container then
        local pos, reason = src_container:RemoveItem(src_container_slot_name, item, "no_update")
      end
      local pos, reason = dest_container:AddItem(dest_container_slot_name, item, x, y, is_local_changes)
    end
    if amount and item_is_stack and amount < item.Amount then
      local new_item = item:SplitStack(amount)
      local pos, reason = dest_container:AddItem(dest_container_slot_name, new_item, x, y)
    elseif merge_stacks then
      MergeStackIntoContainer(dest_container, dest_container_slot_name, item, false, merge_up_to_amount)
      if 0 >= item.Amount then
        if src_container then
          src_container:RemoveItem(src_container_slot_name, item, "no_update")
          local cntrl = GetInventorySlotCtrl(true, src_container, src_container_slot_name)
          if cntrl then
            local wnd = cntrl:FindItemWnd(item)
            if wnd then
              wnd:SetVisible(false)
            end
          end
        end
        DoneObject(item)
        item = false
      elseif x then
        DoMove()
      end
    else
      DoMove()
    end
    ObjModified(src_container)
    ObjModified(dest_container)
    MoveItem_UpdateUnitOutfit(src_container, dest_container, check_only)
    InventoryUIRespawn()
    return false, partial_stack_merge, sync_unit
  end
  if item_is_stack and item.class == item_at_dest.class and item_at_dest.Amount < item_at_dest.MaxStacks then
    local to_add = Min(item_at_dest.MaxStacks - item_at_dest.Amount, item.Amount, amount or max_int)
    if amount and amount ~= to_add and not sync_call then
      print("MoveItem requested to add specific amount, but not possible", amount, to_add)
    end
    if Sync() then
      return sync_err
    end
    item_at_dest.Amount = item_at_dest.Amount + to_add
    item.Amount = item.Amount - to_add
    if 0 >= item.Amount then
      if src_container then
        src_container:RemoveItem(src_container_slot_name, item, "no_update")
      end
      DoneObject(item)
      item = false
    end
    ObjModified(src_container)
    ObjModified(dest_container)
    MoveItem_UpdateUnitOutfit(src_container, dest_container, check_only)
    InventoryUIRespawn()
    return false
  end
  if is_reload then
    local weapon_obj = FindWeaponReloadTarget(item_at_dest, item)
    if not weapon_obj then
      return "invalid reload target"
    end
    if Sync() then
      return sync_err
    end
    local prev_loaded_ammo = weapon_obj:Reload(item)
    if prev_loaded_ammo then
      if prev_loaded_ammo.Amount == 0 then
        DoneObject(prev_loaded_ammo)
        prev_loaded_ammo = false
      else
        local squad_id = src_container and src_container.Squad or dest_container.Squad
        if not squad_id then
          local squads = GetSquadsInSector(gv_CurrentSectorId)
          squad_id = squads[1] and squads[1].UniqueId
        end
        local prev_ammo_dest_container = GetSquadBagInventory(squad_id)
        prev_ammo_dest_container:AddAndStackItem(prev_loaded_ammo)
      end
    end
    if item.Amount == 0 then
      if src_container then
        src_container:RemoveItem(src_container_slot_name, item, "no_update")
      end
      DoneObject(item)
      item = false
    else
    end
    ObjModified(src_container)
    if dest_container ~= src_container then
      ObjModified(dest_container)
    end
    MoveItem_UpdateUnitOutfit(src_container, dest_container, check_only)
    InventoryUIRespawn()
    return false
  end
  if is_refill then
    if Sync() then
      return sync_err
    end
    local allmedsNeeded = AmountOfMedsToFill(item_at_dest)
    if allmedsNeeded <= 0 then
      return "not refill needed"
    end
    local usedmeds = Min(item.Amount, allmedsNeeded)
    local max_condition = item_at_dest:GetMaxCondition()
    if usedmeds == allmedsNeeded then
      item_at_dest.Condition = max_condition
    else
      item_at_dest.Condition = Clamp(MulDivRound(usedmeds, max_condition, allmedsNeeded), 0, max_condition)
    end
    item.Amount = item.Amount - usedmeds
    if item.Amount == 0 then
      if src_container then
        src_container:RemoveItem(src_container_slot_name, item, "no_update")
      end
      DoneObject(item)
      item = false
    end
    ObjModified(src_container)
    if dest_container ~= src_container then
      ObjModified(dest_container)
    end
    InventoryUIRespawn()
    return false
  end
  if is_combine then
    if check_only then
      return false
    end
    local recipe = is_combine
    CombineItemsFromDragAndDrop(recipe.id, sync_unit, item, src_container, item_at_dest, dest_container)
    return false
  end
  local swap_src_x = src_x
  if item.LargeItem and dest_container == src_container and dest_container_slot_name == src_container_slot_name and dest_x + 1 == src_x then
    swap_src_x = src_x + 1
  end
  if item_at_dest and IsEquipSlot(src_container_slot_name) and IsEquipSlot(dest_container_slot_name) and (not InventoryCanEquip(item, dest_container, dest_container_slot_name, point_pack(dest_x, dest_y)) or not InventoryCanEquip(item_at_dest, src_container, src_container_slot_name, point_pack(swap_src_x, src_y))) then
    return "Could not swap equipped items"
  end
  if not src_container:CheckClass(item_at_dest, src_container_slot_name) then
    return "Could not swap items, source container does not accept item at dest"
  end
  if not dest_container:CheckClass(item, dest_container_slot_name) then
    return "Could not swap items, dest container does not accept source item"
  end
  local alternative_pos, reason
  if not src_container:IsEmptyPosition(src_container_slot_name, item_at_dest, swap_src_x, src_y, item) then
    if alternative_swap_pos and IsEquipSlot(dest_container_slot_name) and not IsEquipSlot(src_container_slot_name) and item_at_dest then
      alternative_pos, reason = src_container:CanAddItem(src_container_slot_name, item_at_dest, nil, nil, {
        force_empty = {
          [xxhash(src_container:GetItemPosInSlot(src_container_slot_name, item))] = true
        }
      })
      if not alternative_pos then
        return "Could not swap items, item at dest does not fit in source container at the specified position"
      end
    else
      return "Could not swap items, item at dest does not fit in source container at the specified position"
    end
  end
  if not item_at_dest_2 and not dest_container:IsEmptyPosition(dest_container_slot_name, item, dest_x, dest_y, item_at_dest) then
    return "Could not swap items, item does not fit in dest container at the specified position"
  end
  if (item.LargeItem or item_at_dest.LargeItem) and src_container == dest_container and src_container_slot_name == dest_container_slot_name and dest_y == src_y then
    local occupied1, occupied2 = dest_x, item.LargeItem and dest_x + 1 or dest_x
    local needed1, needed2 = swap_src_x, item_at_dest.LargeItem and swap_src_x + 1 or swap_src_x
    if needed1 == occupied1 or needed1 == occupied2 or needed2 == occupied1 or needed2 == occupied2 then
      return "Could not swap items, items overlap after swap"
    end
  end
  if Sync() then
    return sync_err
  end
  src_container:RemoveItem(src_container_slot_name, item, "no_update")
  dest_container:RemoveItem(dest_container_slot_name, item_at_dest, "no_update")
  if item_at_dest_2 then
    dest_container:RemoveItem(dest_container_slot_name, item_at_dest_2, "no_update")
  end
  local pos, reason = dest_container:AddItem(dest_container_slot_name, item, dest_x, dest_y, is_local_changes, dest_x)
  if alternative_pos then
    local x, y = point_unpack(alternative_pos)
    local pos2, reason2 = src_container:AddItem(src_container_slot_name, item_at_dest, x, y, is_local_changes, dest_x)
  else
    local pos2, reason2 = src_container:AddItem(src_container_slot_name, item_at_dest, swap_src_x, src_y, is_local_changes, dest_x)
  end
  if item_at_dest_2 then
    src_container:AddItem(src_container_slot_name, item_at_dest_2, swap_src_x + 1, src_y, is_local_changes)
  end
  MoveItem_UpdateUnitOutfit(src_container, dest_container, check_only)
  InventoryUIRespawn()
  return false
end
function DestroyItemNetEvent(data)
  DestroyItem(DestroyItem_RecieveNetArgs(data))
end
function CustomCombatActions.DestroyItem(unit, ap, data)
  DestroyItemNetEvent(data)
end
function NetSyncEvents.DestroyItem(data)
  DestroyItemNetEvent(data)
end
function DestroyItem_RecieveNetArgs(data)
  local item, session_id, src_container, src_container_slot_name, amount = unpack_params(data)
  item = g_ItemIdToItem[item]
  src_container = GetContainerFromContainerNetId(src_container)
  src_container_slot_name = GetContainerSlotFromContainerSlotNetId(src_container, src_container_slot_name)
  local unit = GetContainerFromContainerNetId(session_id)
  return item, unit, src_container, src_container_slot_name, amount, true
end
function DestroyItem_SendNetArgs(item, unit, src_container, src_container_slot_name, amount)
  return pack_params(item.id, GetContainerNetId(unit), GetContainerNetId(src_container), GetContainerSlotNetId(src_container, src_container_slot_name), amount)
end
function DestroyItem(item, unit, src_container, src_container_slot_name, amount, sync_call)
  if not sync_call then
    local args = DestroyItem_SendNetArgs(item, unit, src_container, src_container_slot_name, amount)
    if IsKindOf(unit, "UnitData") then
      NetSyncEvent("DestroyItem", args)
    else
      NetStartCombatAction("DestroyItem", unit, 0, args)
    end
  else
    local rem = true
    if amount and IsKindOf(item, "InventoryStack") then
      item.Amount = Max(item.Amount - amount, 0)
      rem = 0 >= item.Amount
    end
    if rem then
      src_container:RemoveItem(src_container_slot_name, item)
      DoneObject(item)
    end
    ObjModified(src_container)
    InventoryUIRespawn()
  end
end
function CanPlaceItemInInventory(item_name, amount, unit)
  unit = unit or GetMercInventoryDlg() and GetInventoryUnit() or SelectedObj
  local item = PlaceInventoryItem(item_name)
  if IsKindOf(item, "InventoryStack") then
    item.Amount = amount or item.MaxStacks
  end
  local args = {
    item = item,
    dest_container = unit,
    dest_slot = "Inventory",
    sync_call = true,
    check_only = true
  }
  local r, r2 = MoveItem(args)
  return r, r2
end
function NetSyncEvents.PlaceItemInInventory(item_name, amount, container_id, drop_chance)
  PlaceItemInInventory(item_name, amount, GetContainerFromContainerNetId(container_id), drop_chance, true)
end
function PlaceItemInInventory(item_name, amount, unit, drop_chance, sync_call)
  if not sync_call then
    unit = unit or GetMercInventoryDlg() and GetInventoryUnit() or SelectedObj
    NetSyncEvent("PlaceItemInInventory", item_name, amount, GetContainerNetId(unit), drop_chance)
    return
  end
  local item = PlaceInventoryItem(item_name)
  item.drop_chance = drop_chance or nil
  if IsKindOf(item, "InventoryStack") then
    item.Amount = amount or item.MaxStacks
  end
  local args = {
    item = item,
    dest_container = unit,
    dest_slot = "Inventory",
    sync_call = true
  }
  local r, r2 = MoveItem(args)
  return r, r2
end
function CombineItemsFromDragAndDrop(recipe_id, unit, item1, container1, item2, container2)
  local options = InventoryGetTargetsRecipe(item1, unit, item2, container2)
  local option = false
  for i, opt in ipairs(options) do
    if opt.recipe and opt.recipe.id == recipe_id and opt.container_data and opt.container_data.item and opt.container_data.item.id == item2.id then
      option = opt
      break
    end
  end
  local combinePopup = XTemplateSpawn("CombineItemPopup", terminal.desktop, {
    unit = unit,
    item = item1,
    context = container1
  })
  combinePopup:Open()
  combinePopup:SetChosenCombination(option)
end
function CombineItemsLocal(recipe, unit_or_unit_data, item1, container1, item2, container2, combineCount)
  local maxSkill, mercMaxskill, skill_type = InventoryCombineItemMaxSkilled(unit_or_unit_data, recipe)
  if not maxSkill then
    return
  end
  local operator_ud = gv_UnitData[mercMaxskill]
  local pos1 = container1:GetItemPackedPos(item1)
  local pos2 = container2:GetItemPackedPos(item2)
  NetCombineItems(recipe.id, "success", 0, skill_type, operator_ud.session_id, container1, pos1, container2, pos2, combineCount)
  ObjModified(container1)
  ObjModified(container2)
  InventoryUIRespawn()
  PlayFX("CombineItems", "start")
end
if dbgMoveItem then
  local mi = MoveItem
  function MoveItem(...)
    local rez, partial_stack_merge, x, y = mi(...)
    invprint("MoveItem result", rez, partial_stack_merge)
    return rez, partial_stack_merge, x, y
  end
end
