DefineClass.InventoryItem = {
  __parents = {
    "ZuluModifiable",
    "InventoryItemProperties"
  },
  properties = {
    {
      id = "id",
      editor = "number",
      default = false
    }
  }
}
if FirstLoad then
  g_ItemIdToItem = setmetatable({}, weak_values_meta)
  nextItemId = 0
  g_UnarmedWeapon = false
end
function ClearItemIdData()
  for id, item in pairs(g_ItemIdToItem) do
    DoneObject(item)
  end
  g_ItemIdToItem = setmetatable({}, weak_values_meta)
  nextItemId = 0
  g_UnarmedWeapon = PlaceInventoryItem("Unarmed")
end
function GenerateItemId()
  nextItemId = nextItemId + 1
  return nextItemId - 1
end
function InventoryItem:HasCondition()
  return true
end
function InventoryItem:Init()
  self:InitializeItemId()
end
function InventoryItem:Done()
  if not GameState.loading and self.owner then
    local owner = self.owner
    self.owner = false
  end
end
local lInventoryItemInitializeItemId = function(self)
  self:Setid(self.id or GenerateItemId(), true)
end
InventoryItem.InitializeItemId = lInventoryItemInitializeItemId
local lInventoryItemSetId = function(self, val, new)
  if self.id == val then
    return
  end
  local old_item
  if not new and g_ItemIdToItem[val] then
    old_item = g_ItemIdToItem[val]
    old_item:Setid(GenerateItemId(), true)
  end
  nextItemId = Max(nextItemId, val + 1)
  if self.id then
    g_ItemIdToItem[self.id] = nil
  end
  self.id = val
  g_ItemIdToItem[val] = self
  NetUpdateHash("InventoryItem:Setid", val, nextItemId, new, self.class, old_item and old_item.class, old_item and old_item.id)
end
InventoryItem.Setid = lInventoryItemSetId
if FirstLoad then
  g_InventoryItemIdInitDetachReasons = {}
end
function InventoryItem.DetachIdInitialization(reason)
  reason = reason or false
  g_InventoryItemIdInitDetachReasons[reason] = true
  InventoryItem.InitializeItemId = empty_func
  InventoryItem.Setid = empty_func
end
function InventoryItem.AttachIdInitialization(reason)
  reason = reason or false
  g_InventoryItemIdInitDetachReasons[reason] = nil
  if not next(g_InventoryItemIdInitDetachReasons) then
    InventoryItem.InitializeItemId = lInventoryItemInitializeItemId
    InventoryItem.Setid = lInventoryItemSetId
  end
end
function InventoryItem:UIClone()
  local code = pstr("", 8192)
  code:clear()
  code:append("return {")
  self:__toluacode(nil, code)
  code:append("}")
  local func, err = load(code:str())
  InventoryItem.DetachIdInitialization("UIClone")
  local ok, clonedItem = procall(func)
  InventoryItem.AttachIdInitialization("UIClone")
  if not (ok and clonedItem) or not clonedItem[1] then
    return false
  end
  local clone = clonedItem[1]
  rawset(clone, "is_clone", true)
  return clone
end
function dumpIds()
  local f = io.open("iddump.txt", "w")
  local str = TableToLuaCode(g_ItemIdToItem)
  f:write(str)
  f:close()
end
DefineClass("ItemUpgrade", "InventoryItem", "ItemUpgradeProperties")
DefineClass.InventoryStack = {
  __parents = {
    "InventoryItem"
  },
  properties = {
    {
      id = "Amount",
      editor = "number",
      default = 1
    },
    {
      id = "MaxStacks",
      template = true,
      editor = "number",
      default = 10
    }
  }
}
function OnMsg.ClassesPreprocess(classdefs)
  for class, value in pairs(const.BaseDropChance) do
    if classdefs[class] and not classdefs[class].base_drop_chance then
      classdefs[class].base_drop_chance = value
    end
  end
end
DefineClass.SquadBagItem = {
  __parents = {
    "InventoryStack"
  }
}
DefineClass.Armor = {
  __parents = {
    "InventoryItem",
    "ArmorProperties"
  },
  properties = {
    {
      id = "SumDamageReduction",
      name = "Damage Reduction",
      editor = "number",
      default = 0,
      no_edit = true,
      read_only = true
    }
  },
  GetRolloverType = function()
    return "Armor"
  end
}
DefineClass.Ammo = {
  __parents = {
    "SquadBagItem",
    "AmmoProperties"
  }
}
DefineClass.QuickSlotItem = {
  __parents = {
    "InventoryItem"
  }
}
DefineClass.Medicine = {
  __parents = {
    "InventoryItem"
  },
  properties = {
    {
      id = "max_meds_parts",
      name = "Max Meds Parts",
      template = true,
      category = "Condition",
      editor = "number",
      default = 0
    }
  }
}
function Armor:GetRolloverHint()
  local hint = {}
  local parts = {}
  for part, val in sorted_pairs(self.ProtectedBodyParts) do
    local preset = Presets.TargetBodyPart.Default[part]
    parts[#parts + 1] = preset.display_name
  end
  hint[#hint + 1] = T({
    378508273050,
    "<bullet_point> Body parts - <parts>",
    parts = table.concat(parts, ", ")
  })
  hint[#hint + 1] = self.AdditionalHint or ""
  return table.concat(hint, "\n")
end
function Armor:GetSumDamageReduction()
  return self.DamageReduction + self.AdditionalReduction
end
function Armor:GetItemStatusUI()
  if self:IsCondition("Broken") then
    return T(623193685060, "BROKEN")
  end
  return InventoryItem.GetItemStatusUI(self)
end
function Medicine:GetItemStatusUI()
  if self.Condition == 0 then
    return T(963116994412, "DEPLETED")
  end
  return InventoryItem.GetItemStatusUI(self)
end
DefineClass.ConditionAndRepair = {
  __parents = {
    "QuickSlotItem",
    "CapacityItemProperties"
  }
}
DefineClass.Valuables = {
  __parents = {
    "InventoryStack"
  }
}
DefineClass.QuestItem = {
  __parents = {
    "InventoryItem",
    "QuestItemProperties"
  }
}
DefineClass.QuestStackItem = {
  __parents = {
    "QuestItem",
    "InventoryStack"
  }
}
DefineClass.ResourceItem = {
  __parents = {
    "SquadBagItem"
  }
}
DefineClass.TransmutedArmor = {
  __parents = {
    "Armor",
    "TransmutedItemProperties"
  },
  RevertConditionCounter = const.Weapons.ItemDegradationCounter
}
DefineClass.TransmutedMachete = {
  __parents = {
    "MacheteWeapon",
    "TransmutedItemProperties"
  },
  RevertConditionCounter = const.Weapons.ItemDegradationCounter
}
DefineClass.TransmutedFirearm = {
  __parents = {
    "Firearm",
    "TransmutedItemProperties"
  },
  RevertConditionCounter = const.Weapons.ItemDegradationCounter
}
DefineClass.TransmutedHeavyWeapon = {
  __parents = {
    "HeavyWeapon",
    "TransmutedItemProperties"
  },
  RevertConditionCounter = const.Weapons.ItemDegradationCounter
}
function _ENV:TransmutedItemProperties_Init()
  local recipe = Recipes[self.class]
  if not recipe then
    for rec, rec_data in pairs(Recipes) do
      if rec_data.ResultItems and rec_data.ResultItems[1].item == self.class then
        recipe = rec_data
        break
      end
    end
  end
  if recipe then
    self.RevertCondition = recipe.RevertCondition
    self.RevertConditionCounter = recipe.RevertConditionValue
    self.OriginalItemId = recipe.Ingredients[1].item
  end
end
function TransmutedArmor:Init()
  TransmutedItemProperties_Init(self)
end
function TransmutedMachete:Init()
  TransmutedItemProperties_Init(self)
end
function TransmutedFirearm:Init()
  TransmutedItemProperties_Init(self)
end
function TransmutedHeavyWeapon:Init()
  TransmutedItemProperties_Init(self)
end
function TransmutedFirearm:MakeTransmutation(fromitem)
  local new_item, prev_item = TransmutedItemProperties.MakeTransmutation(self, fromitem)
  if prev_item.ammo then
    local ammo = prev_item.ammo
    prev_item.ammo = false
    new_item:Reload(ammo)
  end
  for slot, component in pairs(prev_item.components) do
    new_item:SetWeaponComponent(slot, component)
  end
  new_item.jammed = prev_item.jammed
  return new_item, prev_item
end
function TransmutedHeavyWeapon:MakeTransmutation(fromitem)
  return TransmutedFirearm:MakeTransmutation(self, fromitem)
end
function InventoryStack:GetItemSlotUI()
  return T({
    709831548750,
    "<style InventoryItemsCount><cur><valign bottom 0><style InventoryItemsCountMax>/<max></style>",
    cur = self.Amount,
    max = self.MaxStacks
  })
end
function InventoryStack:GetRolloverTitle()
  if self.Amount == 1 then
    return self:GetColoredName()
  else
    return self:GetColoredName("plural")
  end
end
function InventoryStack:GetScrapParts()
  local parts = InventoryItem.GetScrapParts(self)
  return parts * self.Amount
end
function InventoryStack:IsMaxCondition()
  return true
end
function InventoryStack:IsCondition()
  return false
end
function InventoryStack:GetConditionPercent()
  return 100
end
function InventoryStack:HasCondition()
  return false
end
function InventoryStack:MergeStack(otherItem, amount)
  amount = amount or otherItem.Amount
  local to_add = Min(amount, otherItem.Amount, self.MaxStacks - self.Amount)
  self.Amount = self.Amount + to_add
  otherItem.Amount = otherItem.Amount - to_add
  return otherItem.Amount <= 0
end
function InventoryStack:SplitStack(newStackAmount, splitIfEqual)
  if newStackAmount < 0 then
    return
  end
  if not splitIfEqual and newStackAmount >= self.Amount or splitIfEqual and newStackAmount > self.Amount then
    return
  end
  local newItem = PlaceInventoryItem(self.class)
  if not newItem then
    return
  end
  self.Amount = self.Amount - newStackAmount
  newItem.Amount = newStackAmount
  return newItem
end
DefineClass.InventoryItemCompositeDef = {
  __parents = {
    "CompositeDef"
  },
  ObjectBaseClass = "InventoryItem",
  ComponentClass = false,
  EditorMenubarName = "Inventory Item Editor",
  EditorIcon = "CommonAssets/UI/Icons/alcohol beverage bottle drink glass wine.png",
  EditorMenubar = "Characters",
  EditorShortcut = "Ctrl-Alt-Y",
  FilterClass = "InventoryFilter",
  GlobalMap = "InventoryItemDefs",
  StoreAsTable = false,
  store_as_obj_prop_list = true
}
DefineModItemCompositeObject("InventoryItemCompositeDef", {
  EditorName = "Inventory Item",
  EditorSubmenu = "Item"
})
if config.Mods then
  function ModItemInventoryItemCompositeDef:TestModItem(ged)
    ModItemCompositeObject.TestModItem(self, ged)
    if IsKindOf(SelectedObj, "UnitInventory") then
      UIPlaceInInventory(nil, self)
    else
      ModLog(T(770217791797, "Cannot add the item as no merc is selected."))
    end
  end
end
function InventoryItemCompositeDef:GetDPS()
  if self.group == "Firearm" then
    return FirearmProperties.GetDPS(self)
  end
end
local TransformedItemIds = {
  CrocodileJawsInventoryItem = "CrocodileJaws"
}
function TransformItemId(item_id)
  if not item_id then
    return item_id
  end
  local id = item_id
  if string.match(id, "^%d") then
    id = "_" .. id
  end
  if TransformedItemIds[id] then
    id = TransformedItemIds[id]
    print("Class name Collision resolved (PlaceItem):", id)
  elseif g_Classes[id .. "InventoryItem"] then
    id = id .. "InventoryItem"
    print("Class name Collision resolved (PlaceItem):", id)
  end
  return id
end
function PlaceInventoryItem(item_id, instance, ...)
  local id = TransformItemId(item_id)
  local class = g_Classes[id]
  if not class then
    printf("once", "InventoryItem class %s not found, replacing with MissingItem", id)
    return PlaceInventoryItem("MissingItem", instance, ...)
  end
  local obj
  if InventoryItemCompositeDef.store_as_obj_prop_list then
    InventoryItem.DetachIdInitialization("PlaceInventoryItem")
    obj = class:new({}, ...)
    InventoryItem.AttachIdInitialization("PlaceInventoryItem")
    SetObjPropertyList(obj, instance)
    if not obj.id then
      obj:InitializeItemId()
    end
    if IsKindOf(obj, "BaseWeapon") and obj.subweapons then
      for i, w in pairs(obj.subweapons) do
        if not w.parent_weapon then
          w.parent_weapon = obj
        end
      end
    end
  else
    obj = class:new(instance, ...)
  end
  return obj
end
function InventoryItem:__toluacode(indent, pstr, GetPropFunc)
  if not pstr then
    local props = self:SavePropsToLuaCode(indent, GetPropFunc)
    props = props or "nil"
    return string.format("PlaceInventoryItem('%s', %s)", self.class, props)
  end
  pstr:appendf("PlaceInventoryItem('%s', ", self.class)
  if not self:SavePropsToLuaCode(indent, GetPropFunc, pstr) then
    pstr:append("nil")
  end
  return pstr:append(")")
end
function InventoryItem:GetItemSlotUI()
end
function InventoryItem:GetConditionText()
  return T({
    686202559556,
    "<percent(condPercent)>",
    condPercent = self.Condition
  })
end
function InventoryItem:GetItemStatusUI()
end
function InventoryItem:GetItemUIIcon()
  local icon
  if self.Icon ~= "" then
    icon = self.Icon
  elseif self:IsKindOfClasses("Firearm", "MeleeWeapon") then
    icon = self.LargeItem and "UI/Icons/Weapons/weapon_placeholder.tga" or "UI/Icons/Weapons/pistol_placeholder.tga"
  elseif self:IsKindOfClasses("Armor") then
    icon = "UI/Icons/Items/vest_placeholder.tga"
  else
    icon = "UI/Icons/Items/medkit_placeholder.tga"
  end
  return icon
end
function InventoryItem:IsWeapon()
  return IsKindOfClasses(self, "Firearm", "MeleeWeapon", "HeavyWeapon")
end
function InventoryItem:GetRolloverTitle()
  return self:GetColoredName()
end
function InventoryItem:GetRollover()
  if (self.Description or "") ~= "" then
    return self.Description
  end
  if (self.DisplayName or "") ~= "" then
    return self.DisplayName
  end
  return ""
end
function InventoryItem:GetRolloverHint()
  local hint = {}
  hint[#hint + 1] = self.AdditionalHint or ""
  return table.concat(hint, "\n")
end
function InventoryItem:GetRolloverHintWithCondition()
  local condition = self:GetConditionKeyword()
  if self.AdditionalHint and condition ~= "" then
    return self.AdditionalHint .. "\n" .. condition
  end
  return (self.AdditionalHint or "") .. condition
end
function InventoryItem:GetConditionKeyword()
  local text = self:GetConditionKeywordNoPrefix()
  return T({
    186484098339,
    "Condition: <keyword> (<percent(condPercent)>)",
    keyword = text,
    condPercent = self.Condition
  })
end
function InventoryItem:GetConditionKeywordNoPrefix()
  if not self.Condition then
    return ""
  end
  local presets = Presets.ConstDef.Weapons
  local color
  local keyword = ""
  local conditionPercent = self:GetConditionPercent()
  if conditionPercent >= const.Weapons.ItemConditionExcellent then
    color = "item_green"
    keyword = T(486989771291, "Excellent")
  elseif conditionPercent >= const.Weapons.ItemConditionUsed then
    color = "item_green"
    keyword = T(299810656374, "Used")
  elseif conditionPercent >= const.Weapons.ItemConditionNeedsRepair then
    color = "red"
    keyword = T(567857971439, "Needs Repair")
  elseif conditionPercent >= const.Weapons.ItemConditionPoor then
    color = "red"
    keyword = T(939310080350, "Poor")
  else
    color = "red"
    keyword = T(968409848233, "Broken")
  end
  return T({
    997078176629,
    "<clr><keyword><closeclr>",
    clr = const.TagLookupTable[color],
    closeclr = const.TagLookupTable["/" .. color],
    keyword = keyword
  })
end
function IsConditionType(condition, maxCondition, condition_type)
  local conditionPercent = MulDivRound(condition, 100, maxCondition)
  if conditionPercent >= const.Weapons.ItemConditionExcellent then
    return condition_type == "Excellent"
  elseif conditionPercent >= const.Weapons.ItemConditionUsed then
    return condition_type == "Used"
  elseif conditionPercent >= const.Weapons.ItemConditionNeedsRepair then
    return condition_type == "NeedRepair"
  elseif conditionPercent >= const.Weapons.ItemConditionPoor then
    return condition_type == "Poor"
  else
    return condition_type == "Broken"
  end
end
function InventoryItem:IsCondition(condition_type)
  local condition = self.Condition
  local maxCondition = self:GetMaxCondition()
  return IsConditionType(condition, maxCondition, condition_type)
end
function InventoryItem:IsMaxCondition()
  return self.Condition >= self:GetMaxCondition()
end
function InventoryItem:GetMaxCondition()
  return InventoryItemDefs[self.class]:GetProperty("Condition")
end
function InventoryItem:GetConditionPercent()
  return MulDivRound(self.Condition, 100, self:GetMaxCondition())
end
function InventoryItem:SaveToLuaCode(indent, pstr, GetPropFunc, pos)
  if not pstr then
    local props = self:SavePropsToLuaCode(indent, GetPropFunc)
    props = props or "nil"
    return string.format("%d, PlaceInventoryItem('%s', %s)", pos, self.class, props)
  else
    pstr:append(tostring(pos) .. ", ")
    pstr:appendf("PlaceInventoryItem('%s', ", self.class)
    if not self:SavePropsToLuaCode(indent, GetPropFunc, pstr) then
      pstr:append("nil")
    end
    pstr:append(")")
  end
end
function InventoryItem:OnAdd(u, slot, pos, item)
end
function InventoryItem:OnRemove(u)
end
DefineClass.InventoryFilter = {
  __parents = {"GedFilter"},
  properties = {
    {
      id = "Caliber",
      editor = "combo",
      default = "",
      items = PresetGroupCombo("Caliber", "Default")
    },
    {
      id = "ItemClass",
      editor = "combo",
      default = "",
      items = ClassDescendantsCombo("InventoryItem")
    }
  }
}
function InventoryFilter:FilterObject(preset)
  if self.Caliber ~= "" and (not preset:HasMember("Caliber") or not string.find(preset.Caliber or "", self.Caliber)) then
    return false
  end
  if self.ItemClass ~= "" then
    local class = preset:HasMember("object_class") and g_Classes[preset.object_class]
    if not IsKindOf(class, self.ItemClass) then
      return false
    end
  end
  return true
end
DefineClass.InventorySlot = {
  __parents = {
    "PropertyObject"
  }
}
function InventorySlot:__fromluacode(props)
  local slot = self:new(props)
  if not next(slot) then
    return slot
  end
  for item, pos in pairs(slot) do
    if type(item) ~= "number" then
      local idx = #slot + 1
      for i = 1, #slot, 2 do
        local cpos = slot[i]
        if pos <= cpos then
          idx = i
          break
        end
      end
      table.insert(slot, idx, pos)
      table.insert(slot, idx + 1, item)
    end
  end
  return slot
end
function InventorySlot:__toluacode(indent, pstr, GetPropFunc)
  self:GenerateLocalizationContext(self)
  if not pstr then
    local items = {}
    for i = 1, #self, 2 do
      local pos, item = self[i], self[i + 1]
      local item_code = item:SaveToLuaCode(indent, false, GetPropFunc, pos)
      table.insert(items, item_code)
    end
    return string.format("PlaceObj('InventorySlot', {%s})", table.concat(items, ", "))
  else
    pstr:append("PlaceObj('InventorySlot', {")
    for i = 1, #self, 2 do
      local pos, item = self[i], self[i + 1]
      item:SaveToLuaCode(indent, pstr, GetPropFunc, pos)
      if i ~= #self then
        pstr:append(", ")
      end
    end
    pstr:append("})")
    return pstr
  end
end
DefineClass.Inventory = {
  __parents = {
    "PropertyObject",
    "InitDone"
  },
  inventory_slots = {}
}
function OnMsg.ClassesGenerate(classdefs)
  for classname, classdef in pairs(classdefs) do
    if classdef.inventory_slots then
      classdef.properties = classdef.properties or {}
      for _, slot_data in ipairs(classdef.inventory_slots) do
        table.insert(classdef.properties, {
          id = slot_data.slot_name,
          editor = "nested_obj",
          default = false,
          base_class = "InventorySlot",
          read_only = slot_data.read_only,
          dont_save = slot_data.dont_save
        })
        classdef.inventory_slots[slot_data.slot_name] = slot_data
      end
    end
  end
end
function Inventory:Init()
  for _, slot_data in ipairs(self.inventory_slots) do
    local slot_name = slot_data.slot_name
    self[slot_name] = rawget(self, slot_name) or InventorySlot:new()
  end
end
function Inventory:GetMaxTilesInSlot(slot_name)
  local slot_data = self:GetSlotData(slot_name)
  return slot_data.width * slot_data.height
end
function Inventory:ForEachItem(base_class, fn, ...)
  local arg1
  if type(base_class) == "function" then
    arg1 = fn
    fn = base_class
    base_class = false
  end
  for _, slot_data in ipairs(self.inventory_slots) do
    local slot_name = slot_data.slot_name
    local items = self[slot_name]
    local lbase_class = base_class or slot_data.base_class
    local lcheck_slot_name = slot_data.check_slot_name
    if next(items) then
      for i = #items, 1, -2 do
        local item, pos = items[i], items[i - 1]
        if item:IsKindOfClasses(lbase_class) and (not lcheck_slot_name or item.Slot == slot_name) then
          local left, top = point_unpack(pos)
          local res
          if arg1 ~= nil then
            res = fn(item, slot_name, left, top, arg1, ...)
          else
            res = fn(item, slot_name, left, top, ...)
          end
          if res == "break" then
            return "break"
          end
        end
      end
    end
  end
end
function Inventory:CheckClass(item, slot_name, base_class)
  local slot_data = self:GetSlotData(slot_name)
  local base_class = base_class or slot_data.base_class
  if not base_class then
    return true
  end
  return item:IsKindOfClasses(base_class) and (not slot_data.check_slot_name or item.Slot == slot_name)
end
function Inventory:HasItem(class)
  local res
  self:ForEachItem(function(item, slot_name, left, top, ...)
    if not class or item.class == class then
      res = true
      return "break"
    end
  end, res)
  return res
end
function Inventory:HasItemInSlot(slot_name, search_item)
  if not search_item then
    return false
  end
  if not self[slot_name] then
    return false
  end
  local items = self[slot_name]
  for i = 1, #items, 2 do
    local pos, item = items[i], items[i + 1]
    if item == search_item then
      return true
    end
  end
  return false
end
function Inventory:ForEachItemDef(item_class, fn, ...)
  for _, slot_data in ipairs(self.inventory_slots) do
    local slot_name = slot_data.slot_name
    local items = self[slot_data.slot_name]
    if next(items) then
      for i = #items, 1, -2 do
        local item, pos = items[i], items[i - 1]
        if item.class == item_class and fn(item, slot_name, ...) == "break" then
          return "break"
        end
      end
    end
  end
end
function Inventory:IsEmpty(slot_name)
  local items = self[slot_name]
  if not next(items) then
    return true
  end
  return false
end
function Inventory:ForEachItemInSlot(slot_name, base_class, fn, ...)
  local arg1
  if type(base_class) == "function" then
    arg1 = fn
    fn = base_class
    base_class = false
  end
  local items = self[slot_name]
  if not next(items) then
    return
  end
  local slot_data = self:GetSlotData(slot_name)
  local lbase_class = base_class or slot_data.base_class
  local lcheck_slot_name = slot_data.check_slot_name
  for i = #items, 1, -2 do
    local item, pos = items[i], items[i - 1]
    if item:IsKindOfClasses(lbase_class) and (not lcheck_slot_name or item.Slot == slot_name) then
      local left, top = point_unpack(pos)
      local res
      if arg1 ~= nil then
        res = fn(item, slot_name, left, top, arg1, ...)
      else
        res = fn(item, slot_name, left, top, ...)
      end
      if res == "break" then
        return "break"
      end
    end
  end
end
function Inventory:GetItem(base_class, left, top)
  for _, slot_data in ipairs(self.inventory_slots) do
    local slot_name = slot_data.slot_name
    local item, ileft, itop = self:GetItemInSlot(slot_name, base_class, left, top)
    if item then
      return item, ileft, itop
    end
  end
  return false
end
function Inventory:GetItems()
  local items = {}
  self:ForEachItem(function(item)
    items[#items + 1] = item
  end)
  return items
end
function Inventory:GetItemInSlot(slot_name, base_class, left, top)
  local items = self[slot_name]
  local slot_data = self:GetSlotData(slot_name)
  local lbase_class = base_class or slot_data.base_class
  local lcheck_slot_name = slot_data.check_slot_name
  for i = 1, #items, 2 do
    local pos, item = items[i], items[i + 1]
    if item:IsKindOfClasses(lbase_class) and (not lcheck_slot_name or item.Slot == slot_name) then
      local ileft, itop = point_unpack(pos)
      if left then
        if top then
          if left >= ileft and left < ileft + item:GetUIWidth() and top >= itop and top < itop + item:GetUIHeight() then
            return item, ileft, itop
          end
        elseif left >= ileft and left < ileft + item:GetUIWidth() then
          return item, ileft, itop
        end
      elseif top then
        if top >= itop and top < itop + item:GetUIHeight() then
          return item, ileft, itop
        end
      else
        return item, ileft, itop
      end
    end
  end
  return false
end
function Inventory:GetItemsInSlot(slot_name)
  local items = {}
  self:ForEachItemInSlot(slot_name, function(item, _, x)
    items[x] = item
  end)
  table.compact(items)
  return items
end
function Inventory:GetItemSlot(item)
  for _, slot_data in ipairs(self.inventory_slots) do
    local slot_name = slot_data.slot_name
    if self:HasItemInSlot(slot_name, item) then
      return slot_name
    end
  end
end
function Inventory:GetItemPos(item)
  for _, slot_data in ipairs(self.inventory_slots) do
    local slot_name = slot_data.slot_name
    local ileft, itop = self:GetItemPosInSlot(slot_name, item)
    if ileft and itop then
      return ileft, itop
    end
  end
  return false
end
function Inventory:GetItemPosInSlot(slot_name, item)
  local slot_items = self[slot_name]
  for i = 1, #slot_items, 2 do
    local pos, cur_item = slot_items[i], slot_items[i + 1]
    if item == cur_item then
      return point_unpack(pos)
    end
  end
end
function Inventory:GetItemPackedPos(item)
  for i, slot_data in ipairs(self.inventory_slots) do
    local slot_name = slot_data.slot_name
    local ileft, itop = self:GetItemPosInSlot(slot_name, item)
    if ileft and itop then
      return point_pack(ileft, itop, i)
    end
  end
end
function Inventory:GetItemWithId(slot_name, id)
  local items = self[slot_name]
  for i = 1, #items, 2 do
    local pos, item = items[i], items[i + 1]
    if item.id == id then
      return item, pos
    end
  end
end
function Inventory:GetItemAtPos(slot_name, left, top)
  local value = point_pack(left, top)
  local items = self[slot_name]
  for i = 1, #items, 2 do
    local pos, item = items[i], items[i + 1]
    if pos == value then
      return item
    end
  end
end
function Inventory:GetItemAtPackedPos(value)
  local x, y, z = point_unpack(value)
  local slot = z and self.inventory_slots[z]
  local item = slot and self:GetItemAtPos(slot.slot_name, x, y)
  return item
end
function Inventory:CountItemsInSlot(slot_name, filterfn)
  local count = {count = 0}
  self:ForEachItemInSlot(slot_name, function(slot_item, slot_name, item_left, item_top, count)
    if not filterfn or filterfn(slot_item, slot_name, item_left, item_top) then
      count.count = count.count + 1
    end
  end, count)
  return count.count
end
function Inventory:CanAddItem(slot_name, item, left, top, local_changes)
  local pos, reason
  if not self:CheckClass(item, slot_name) then
    return false, "different class"
  end
  reason = ""
  local stack = false
  if left and top then
    local currentitem = self:GetItemInSlot(slot_name, false, left, top)
    if currentitem == item then
      if item.LargeItem and not self:IsEmptyPosition(slot_name, item, left, top, nil, local_changes) then
        return false, "full or smaller position"
      end
      return point_pack(left, top), "current"
    end
    local is_current_stack = IsKindOf(currentitem, "InventoryStack")
    if is_current_stack and item.class == currentitem.class then
      if currentitem.Amount + item.Amount > currentitem.MaxStacks then
        return false, "full stack"
      else
        reason = "stack items"
        stack = true
      end
    end
    if not stack and not self:IsEmptyPosition(slot_name, item, left, top, nil, local_changes) then
      return false, "full or smaller position"
    end
  else
    left, top = self:FindEmptyPosition(slot_name, item, local_changes)
    if not left or not top then
      return false, "inventory full"
    end
  end
  pos = point_pack(left, top)
  return pos, reason
end
function Inventory:AddItem(slot_name, item, left, top, local_execution)
  local pos, reason = self:CanAddItem(slot_name, item, left, top)
  if not pos then
    return false, reason
  end
  if reason == "current" then
    return pos, reason
  end
  item.owner = false
  if reason == "stack items" then
    local currentitem = self:GetItemInSlot(slot_name, false, left, top)
    currentitem.Amount = currentitem.Amount + item.Amount
    self:RemoveItem(slot_name, item)
    DoneObject(item)
  else
    local slot_items = self[slot_name]
    local idx = #slot_items + 1
    for i = 1, #slot_items, 2 do
      local cpos = slot_items[i]
      if pos <= cpos then
        idx = i
        break
      end
    end
    table.insert(slot_items, idx, pos)
    table.insert(slot_items, idx + 1, item)
    self[slot_name] = slot_items
  end
  return pos, reason
end
function Inventory:CanRemoveItem(slot_name, item)
  return true
end
function Inventory:RemoveItem(slot_name, item, no_update)
  if not self:CanRemoveItem(slot_name, item) then
    return
  end
  local slot_items = self[slot_name]
  if not slot_items then
    return
  end
  local pos
  for i = #slot_items, 2, -2 do
    local cur_item, cur_pos = slot_items[i], slot_items[i - 1]
    if item == cur_item then
      pos = cur_pos
      table.remove(slot_items, i - 1)
      table.remove(slot_items, i - 1)
      break
    end
  end
  self[slot_name] = slot_items
  if not pos then
    return
  end
  if not no_update then
    ObjModified(self)
  end
  return item, pos
end
function Inventory:ClearSlot(slot_name)
  self[slot_name] = {}
  ObjModified(self)
end
function Inventory:GetSlotIdx(slot_name)
  return table.find(self.inventory_slots, "slot_name", slot_name)
end
function Inventory:GetSlotData(slot_name)
  return self.inventory_slots[slot_name]
end
function Inventory:GetSlotDataDim(slot_name)
  local slot_data = self:GetSlotData(slot_name)
  local width = slot_data.width
  local height = slot_data.height
  local max_tiles = self:GetMaxTilesInSlot(slot_name)
  local last_row_width = width
  if max_tiles < width * height then
    local rem = max_tiles % width
    height = max_tiles / width + (rem == 0 and 0 or 1)
    last_row_width = rem == 0 and width or rem
  end
  return width, height, last_row_width
end
function Inventory:IsEmptyPosition(slot_name, item, left, top, ignore_item, local_changes)
  if left < 1 or top < 1 then
    return false
  end
  local width, height, last_row_width = self:GetSlotDataDim(slot_name)
  local iwidth = item:GetUIWidth()
  local iheight = item:GetUIHeight()
  if width < left + iwidth - 1 or height < top + iheight - 1 then
    return false
  end
  if top + iheight - 1 == height and last_row_width < left + iwidth - 1 then
    return false
  end
  if local_changes and local_changes[xxhash(left, top)] then
    return false
  end
  local ibox = box(left, top, left + iwidth - 1, top + iheight - 1)
  local res = self:ForEachItemInSlot(slot_name, function(slot_item, slot_name, item_left, item_top, ibox, item)
    if item ~= slot_item and slot_item ~= ignore_item then
      local intersection = IntersectRects(ibox, box(item_left, item_top, item_left + slot_item:GetUIWidth() - 1, item_top + slot_item:GetUIHeight() - 1))
      if intersection:IsValid() then
        return "break"
      end
    end
  end, ibox, item)
  if res == "break" then
    return false
  end
  return true
end
function Inventory:FindEmptyPosition(slot_name, item, local_changes)
  local slot_data = self:GetSlotData(slot_name)
  local space = {}
  local width, height, last_row_width = self:GetSlotDataDim(slot_name)
  for i = 1, width do
    space[i] = {}
  end
  local free_space = self:GetMaxTilesInSlot(slot_name)
  local fe = local_changes and local_changes.force_empty
  self:ForEachItemInSlot(slot_name, function(slot_item, slot_name, left, top, space)
    local item_width = slot_item:GetUIWidth()
    local item_height = slot_item:GetUIHeight()
    for i = left, left + item_width - 1 do
      for j = top, top + item_height - 1 do
        if not fe or not fe[xxhash(i, j)] then
          space[i][j] = true
        else
          free_space = free_space + 1
        end
      end
    end
    free_space = free_space - item_width * item_height
  end, space)
  if last_row_width ~= width then
    for i = last_row_width + 1, width do
      space[i][height] = true
    end
  end
  local iwidth = item:GetUIWidth()
  local iheight = item:GetUIHeight()
  if free_space < iwidth * iheight then
    return
  end
  local x, y = 1, 1
  local raw_width = width
  while x <= raw_width and height >= y and raw_width >= x + iwidth - 1 and height >= y + iheight - 1 do
    local full = false
    for i = x, x + iwidth - 1 do
      for j = y, y + iheight - 1 do
        if not space[i] or space[i][j] or local_changes and local_changes[xxhash(i, j)] then
          full = true
          break
        end
      end
      if full then
        break
      end
    end
    if not full then
      return x, y
    end
    x = x + 1
    if raw_width < x or raw_width < x + iwidth - 1 then
      x = 1
      y = y + 1
      if y == height then
        raw_width = last_row_width
      end
    end
  end
end
function SortItemsArray(items)
  for i = 1, #items do
    if IsKindOf(items[i], "InventoryStack") then
      for j = i + 1, #items do
        if items[i].class == items[j].class then
          local transferAmount = Min(items[i].MaxStacks - items[i].Amount, items[j].Amount)
          items[i].Amount = items[i].Amount + transferAmount
          items[j].Amount = items[j].Amount - transferAmount
        end
      end
    end
  end
  for i = #items, 1, -1 do
    if items[i].Amount and items[i].Amount <= 0 then
      local item = table.remove(items, i)
      DoneObject(item)
    end
  end
  table.sortby_field(items, "class")
  return items
end
function SectorOperationItems_GetItemsQueue(sector_id, operation_id)
  local queue = {}
  if IsCraftOperation(operation_id) then
    local qu = GetCraftOperationListsIds(operation_id)
    queue = gv_Sectors[sector_id][qu] or {}
  end
  return queue
end
function SectorOperationRepairItems_GetItemFromData(data)
  return data and (data.id and g_ItemIdToItem[data.id] or data[1])
end
function SectorOperationItemToRepair(sector, dont_progress)
  local queue = SectorOperationItems_GetItemsQueue(sector, "RepairItems")
  if not next(queue) then
    return
  end
  local data = queue[1]
  local item = SectorOperationRepairItems_GetItemFromData(data)
  local once = false
  if not dont_progress then
    NetUpdateHash("SectorOperationItemToRepair", Game and Game.CampaignTime, item and item.class, not not next(queue), item and item:IsMaxCondition(), item and item.id, item and item.Condition)
  end
  while not dont_progress and next(queue) and (not item or item:IsMaxCondition()) do
    table.remove(queue, 1)
    data = queue[1]
    item = SectorOperationRepairItems_GetItemFromData(data)
    if not once then
      RecalcOperationETAs(sector, "RepairItems")
      once = true
    end
  end
  if once then
    InventoryUIRespawn()
  end
  gv_Sectors[sector].sector_repair_items_queued = queue
  return item, data
end
function SectorOperationItems_GetAllItems(sector_id, operation_id)
  local sector = gv_Sectors[sector_id]
  local mercs = GetOperationProfessionals(sector_id, operation_id)
  if operation_id == "RepairItems" then
    if next(sector.sector_repair_items) then
      return sector.sector_repair_items
    end
    return SectorOperationFillItemsToRepair(sector_id, mercs)
  end
  if operation_id == "CraftAmmo" or operation_id == "CraftExplosives" then
    return SectorOperationFillItemsToCraft(sector_id, operation_id, mercs[1])
  end
end
function SectorOperationRepairItems_FillMostDamagedItems(sector_id)
  local all = table.icopy(gv_Sectors[sector_id].sector_repair_items)
  table.iappend(all, table.icopy(gv_Sectors[sector_id].sector_repair_items_queued))
  table.sortby(all, function(item)
    local itm = SectorOperationRepairItems_GetItemFromData(item)
    return itm and itm.Condition or -1
  end)
  local width, idx = 0, 0
  local queued = {}
  local rem
  while width < 9 and idx < #all do
    idx = idx + 1
    local item = all[idx]
    local itm = SectorOperationRepairItems_GetItemFromData(item)
    local item_width = itm and itm.LargeItem and 2 or 1
    width = width + item_width
    if 9 < width then
      idx = idx - 1
      rem = 9 - (width - item_width)
      break
    end
    queued[#queued + 1] = item
  end
  local tbl_all = {}
  for i = idx + 1, #all do
    local added = false
    if rem and 0 < rem then
      local item = all[i]
      local itm = SectorOperationRepairItems_GetItemFromData(item)
      local item_width = itm and itm.LargeItem and 2 or 1
      if rem >= item_width then
        queued[#queued + 1] = item
        rem = rem - item_width
        added = true
      end
    end
    if not added then
      tbl_all[#tbl_all + 1] = all[i]
    end
  end
  NetSyncEvent("ChangeSectorOperationItemsOrder", sector_id, "RepairItems", TableWithItemsToNet(tbl_all), TableWithItemsToNet(queued))
  return tbl_all, queued, idx
end
function SectorOperation_ItemsUpdateItemLists(dlg)
  dlg = dlg or table.get(GetDialog("SectorOperationsUI"), "idBase", "idMain")
  if not dlg then
    return
  end
  local items_ctrl = dlg.idQueueList
  if not items_ctrl then
    return
  end
  items_ctrl:RespawnContent()
  items_ctrl:OnContextUpdate(items_ctrl:GetContext())
  local allitems_ctrl = dlg.idAllList
  allitems_ctrl:RespawnContent()
  allitems_ctrl:OnContextUpdate(allitems_ctrl:GetContext())
  local node = items_ctrl:ResolveId("node")
  node:OnContextUpdate(node:GetContext())
  local node = allitems_ctrl:ResolveId("node")
  node:OnContextUpdate(node:GetContext())
  ObjModified(items_ctrl)
  ObjModified(allitems_ctrl)
end
local priority_slots = {
  "Handheld A",
  "Handheld B",
  "Head",
  "Torso",
  "Legs"
}
function SectorOperationFillItemsToRepair(sector_id, mercs, check_only)
  local queue = gv_Sectors[sector_id].sector_repair_items_queued
  if not check_only then
    gv_Sectors[sector_id].sector_repair_items = {}
  end
  local all_to_repair = gv_Sectors[sector_id].sector_repair_items or {}
  local chek_only_var = {var_bool = false}
  local act_mercs = {}
  for _, slot in ipairs(priority_slots) do
    for _, merc in ipairs(mercs) do
      act_mercs[merc.session_id] = true
      merc:ForEachItemInSlot(slot, "ItemWithCondition", function(item, slot_name, left, top, all_to_repair, chek_only_var)
        if item and not item:IsMaxCondition() and item.Repairable then
          if check_only then
            chek_only_var.var_bool = true
            return "break"
          end
          if not table.find(all_to_repair, "id", item.id) and not table.find(queue, "id", item.id) then
            table.insert(all_to_repair, {
              unit = merc.session_id,
              id = item.id,
              slot = slot,
              pos_left = left,
              pos_top = top
            })
          end
        end
      end, all_to_repair, chek_only_var)
    end
  end
  if chek_only_var.var_bool then
    return true
  end
  for _, slot in ipairs(priority_slots) do
    for _, merc in ipairs(mercs) do
      local squad = merc.Squad
      local units = gv_Squads[squad].units
      for _, unit_id in ipairs(units) do
        if not act_mercs[unit_id] then
          local unit = gv_UnitData[unit_id]
          unit:ForEachItemInSlot(slot, "ItemWithCondition", function(item, slot_name, left, top, all_to_repair, chek_only_var)
            if item and not item:IsMaxCondition() and item.Repairable then
              if check_only then
                chek_only_var.var_bool = true
                return "break"
              end
              if not table.find(all_to_repair, "id", item.id) and not table.find(queue, "id", item.id) then
                table.insert(all_to_repair, {
                  unit = unit_id,
                  id = item.id,
                  slot = slot,
                  pos_left = left,
                  pos_top = top
                })
              end
            end
          end, all_to_repair, chek_only_var)
        end
      end
    end
  end
  if chek_only_var.var_bool then
    return true
  end
  for _, merc in ipairs(mercs) do
    local squad = merc.Squad
    local units = gv_Squads[squad].units
    for _, unit_id in ipairs(units) do
      local unit = gv_UnitData[unit_id]
      local slot = GetContainerInventorySlotName(unit)
      unit:ForEachItemInSlot(slot, "ItemWithCondition", function(item, slot_name, left, top, all_to_repair, chek_only_var)
        if not item:IsMaxCondition() and item.Repairable and item:IsWeapon() then
          if check_only then
            chek_only_var.var_bool = true
            return "break"
          end
          if not table.find(all_to_repair, "id", item.id) and not table.find(queue, "id", item.id) then
            table.insert(all_to_repair, {
              unit = unit_id,
              id = item.id,
              slot = slot,
              pos_left = left,
              pos_top = top
            })
          end
        end
      end, all_to_repair, chek_only_var)
    end
  end
  if chek_only_var.var_bool then
    return true
  end
  for _, merc in ipairs(mercs) do
    local squad = merc.Squad
    local units = gv_Squads[squad].units
    for _, unit_id in ipairs(units) do
      local unit = gv_UnitData[unit_id]
      local slot = GetContainerInventorySlotName(unit)
      unit:ForEachItemInSlot(slot, "ItemWithCondition", function(item, slot_name, left, top, all_to_repair, chek_only_var)
        if not item:IsMaxCondition() and item.Repairable and not item:IsWeapon() then
          if check_only then
            chek_only_var.var_bool = true
            return "break"
          end
          if not table.find(all_to_repair, "id", item.id) and not table.find(queue, "id", item.id) then
            table.insert(all_to_repair, {
              unit = unit_id,
              id = item.id,
              slot = slot,
              pos_left = left,
              pos_top = top
            })
          end
        end
      end, all_to_repair, chek_only_var)
    end
  end
  if chek_only_var.var_bool then
    return true
  end
  if check_only then
    return false
  end
  gv_Sectors[sector_id].sector_repair_items = all_to_repair
  return all_to_repair
end
function SectorOperation_FindItemDef(item)
  if item.id then
    return SectorOperationRepairItems_GetItemFromData(item)
  end
  local item_id = item.item_id
  return type(item_id) == "string" and g_Classes[item_id]
end
if FirstLoad then
  g_RecipesCraftAmmo = false
  g_RecipesCraftExplosives = false
end
function SectorOperationFillItemsToCraft(sector_id, operation_id, merc)
  local id = "g_Recipes" .. operation_id
  if _G[id] then
    SectorOperationValidateItemsToCraft(sector_id, operation_id, merc)
    return _G[id]
  end
  _G[id] = {}
  local res_items = SectorOperation_CalcCraftResources(sector_id, operation_id)
  local all_to_craft = _G[id] or {}
  local mercs = merc and gv_Squads[merc.Squad].units
  local checked_amount_cach = {}
  for recipe_id, recipe in pairs(CraftOperationsRecipes) do
    local is_ammocraft = recipe.group == "Ammo" and operation_id == "CraftAmmo"
    local is_explosivescraft = recipe.group == "Explosives" and operation_id == "CraftExplosives"
    if is_ammocraft or is_explosivescraft then
      local hidden = false
      if recipe.RequiredCrafter and merc and merc.session_id ~= recipe.RequiredCrafter then
        hidden = true
      end
      local condition = not recipe.QuestConditions or EvalConditionList(recipe.QuestConditions)
      hidden = hidden or not condition
      local res = merc and SectorOperation_ValidateRecipeIngredientsAmount(mercs, recipe, res_items, checked_amount_cach)
      local item = recipe.ResultItem.item
      local find_idx = table.find(all_to_craft, "recipe", recipe_id)
      if not find_idx then
        table.insert(all_to_craft, {
          recipe = recipe_id,
          item_id = item,
          amount = recipe.ResultItem.amount,
          enabled = not not res,
          hidden = hidden
        })
      else
        all_to_craft[find_idx].enabled = not not res
        all_to_craft[find_idx].hidden = hidden
      end
    end
  end
  table.sort(all_to_craft, function(a, b)
    if not a or not b then
      return true
    end
    return a.enabled and not b.enabled
  end)
  _G[id] = all_to_craft
  return all_to_craft
end
function OnMsg.InventoryChange(obj)
  return RepairItems_InventoryChange(obj)
end
function OnMsg.ItemAdded(obj)
  return RepairItems_InventoryChange(obj)
end
function OnMsg.ItemRemoved(obj, item, slot_name, pos)
  return RepairItems_InventoryChange(obj, "removed", item.id)
end
function RepairItems_InventoryChange(obj, removed, item_id)
  if not IsMerc(obj) or obj:IsDead() or not obj.Squad then
    return
  end
  local sector_id = gv_Squads[obj.Squad].CurrentSector
  local repair_all = gv_Sectors[sector_id].sector_repair_items
  local repair_queue = gv_Sectors[sector_id].sector_repair_items_queued
  if not next(repair_all) and not next(repair_queue) then
    return
  end
  local mercs = GetOperationProfessionals(sector_id, "RepairItems")
  if not next(mercs) then
    return
  end
  for i = #repair_queue, 1, -1 do
    local items_data = repair_queue[i]
    local itm = SectorOperationRepairItems_GetItemFromData(items_data)
    if not itm then
      table.remove_value(repair_queue, "id", items_data.id)
    else
      local unit_session_id = items_data.unit
      if unit_session_id == obj.session_id then
        local new_unit_session_id = (not removed or item_id ~= itm.id) and itm.owner or false
        if not new_unit_session_id then
          table.remove_value(repair_queue, "id", itm.id)
        else
          local found = table.find(mercs, "session_id", new_unit_session_id)
          local new_unit = gv_UnitData[new_unit_session_id]
          if not found then
            local sq = new_unit and new_unit.Squad
            local squads = table.map(mercs, "Squad")
            found = table.find(squads, sq)
          end
          if not found then
            table.remove_value(repair_queue, "id", itm.id)
          else
            local ps = new_unit:GetItemPackedPos(itm)
            if ps then
              local left, top, slot_idx = point_unpack(ps)
              items_data.pos_left = left
              items_data.pos_top = top
              items_data.slot = new_unit.inventory_slots[slot_idx].slot_name
            end
          end
        end
      end
    end
  end
  gv_Sectors[sector_id].sector_repair_items_queued = repair_queue
  gv_Sectors[sector_id].sector_repair_items = {}
  SectorOperationFillItemsToRepair(sector_id, mercs)
  NetSyncEvent("ChangeSectorOperationItemsOrder", sector_id, "RepairItems", TableWithItemsToNet(gv_Sectors[sector_id].sector_repair_items), TableWithItemsToNet(repair_queue))
end
function OnMsg.PreLoadSessionData()
  for sector_id, sector in pairs(gv_Sectors) do
    for i = #(sector.sector_repair_items or empty_table), 1, -1 do
      local items_data = sector.sector_repair_items[i]
      local unit = items_data.unit
      local slot = items_data.slot
      local pos_left = items_data.pos_left
      local pos_top = items_data.pos_top
      local itm = gv_UnitData[unit]:GetItemAtPos(slot, pos_left, pos_top)
      if items_data.id and items_data[1] then
        items_data[1] = nil
      elseif not items_data.id and not itm then
        table.remove(sector.sector_repair_items, i)
      elseif not items_data.id and itm and items_data[1] then
        items_data.id = itm.id
        items_data[1] = nil
      elseif itm and items_data.id ~= itm.id then
        items_data.id = itm.id
        items_data[1] = nil
      end
    end
    for i = #(sector.sector_repair_items_queued or empty_table), 1, -1 do
      local items_data = sector.sector_repair_items_queued[i]
      local unit = items_data.unit
      local slot = items_data.slot
      local pos_left = items_data.pos_left
      local pos_top = items_data.pos_top
      local itm = gv_UnitData[unit]:GetItemAtPos(slot, pos_left, pos_top)
      if items_data.id and items_data[1] then
        items_data[1] = nil
      elseif not items_data.id and not itm then
        table.remove(sector.sector_repair_items_queued, i)
      elseif not items_data.id and itm and items_data[1] then
        items_data.id = itm.id
        items_data[1] = nil
      elseif itm and items_data.id ~= itm.id then
        items_data.id = itm.id
        items_data[1] = nil
      end
    end
  end
end
function AreAllEquippedItemsRepaired(merc)
  for i = 1, #priority_slots do
    local item, left, top = merc:GetItemInSlot(priority_slots[i])
    if item and not item:IsMaxCondition() then
      return false
    end
  end
  return true
end
function SavegameSessionDataFixups.InventoryRemoveObsoleteItems(data)
  local l_gv_unit_data = GetGameVarFromSession(data, "gv_UnitData")
  local l_gv_sectors = GetGameVarFromSession(data, "gv_Sectors")
  local l_gv_squads = GetGameVarFromSession(data, "gv_Squads")
  for k, merc in pairs(l_gv_unit_data) do
    local deleted = false
    merc:ForEachItem(function(item, slot_name, left, top)
      if item.class == "InventoryItem" then
        merc:RemoveItem(slot_name, item)
        deleted = true
      end
    end)
    if deleted then
      print("Inventory items of unknown type were found in the inventory " .. merc.session_id .. " - deleting them.")
    end
  end
  for sector, sector_data in pairs(l_gv_sectors) do
    local deleted = false
    local sector_inventory = sector_data.sector_inventory
    if sector_inventory then
      for _, inv_data in ipairs(sector_inventory) do
        local items = inv_data[3] or {}
        for i = #items, 1, -1 do
          local item = items[i]
          if item and item.class == "InventoryItem" then
            table.remove(items, i)
            deleted = true
          end
        end
      end
    end
    if deleted then
      print("Inventory items of unknown type were found in some containers in sector " .. sector .. " - deleting them.")
    end
  end
  for squad_id, squad_data in pairs(l_gv_squads) do
    local deleted = false
    local bag = squad_data.squad_bag
    if bag then
      for i = #bag, 1, -1 do
        local item = bag[i]
        if item and item.class == "InventoryItem" then
          table.remove(bag, i)
          deleted = true
        end
      end
    end
    if deleted then
      print("Inventory items of unknown type were found in the squad bags of squad " .. squad_id .. " - deleting them.")
    end
  end
end
function SavegameSessionDataFixups.InventoryFixChangedSlots(data)
  local l_gv_unit_data = GetGameVarFromSession(data, "gv_UnitData")
  for k, merc in pairs(l_gv_unit_data) do
    local items = rawget(merc, "Weapon A")
    if items then
      for item, pos in pairs(items) do
        merc:AddItem("Handheld A", item, point_unpack(pos))
      end
      rawset(merc, "Weapon A", nil)
    end
    items = rawget(merc, "Weapon B")
    if items then
      for item, pos in pairs(items) do
        merc:AddItem("Handheld B", item, point_unpack(pos))
      end
      rawset(merc, "Weapon B", nil)
    end
    items = rawget(merc, "Quick Slot A")
    if items then
      local quicka = merc["Quick Slot A"]
      for item, pos in pairs(items) do
        merc:AddItem("Handheld B", item, point_unpack(pos))
      end
      rawset(merc, "Quick Slot A", nil)
    end
    items = rawget(merc, "Quick Slot B")
    if items then
      local quickb = merc["Quick Slot B"]
      for item, pos in pairs(items) do
        merc:AddItem("Handheld B", item, point_unpack(pos))
      end
      rawset(merc, "Quick Slot B", nil)
    end
  end
end
function InventoryItemCombo()
  local items = {""}
  ForEachPreset("InventoryItemCompositeDef", function(o)
    table.insert(items, o.id)
  end)
  return items
end
function InventoryItemWeaponsCombo()
  local items = {""}
  ForEachPreset("InventoryItemCompositeDef", function(o)
    if o.WeaponType and o.WeaponType ~= "" then
      table.insert(items, o.id)
    end
  end)
  return items
end
function GetWeaponTypes()
  local weaponTypes = {}
  local excludeWeaponGroups = {
    GrenadeLauncher = true,
    MissileLauncher = true,
    Mortar = true,
    Throwables = true
  }
  ForEachPreset("WeaponType", function(o)
    if not excludeWeaponGroups[o.id] then
      table.insert(weaponTypes, o)
    end
  end)
  table.sort(weaponTypes, function(a, b)
    return tostring(a.SortKey) < tostring(b.SortKey)
  end)
  return weaponTypes
end
function GetWeaponsByType(weaponType)
  local weapons = {}
  local excludeWeapons = {
    BrowningM2HMG = true,
    UnderslungGrenadeLauncher = true,
    SteroidPunchGrenade = true
  }
  ForEachPreset("InventoryItemCompositeDef", function(o)
    if not excludeWeapons[o.id] then
      local classdef = g_Classes[o.object_class]
      if weaponType == "Grenade" and IsKindOfClasses(classdef, "Grenade", "ThrowableTrapItem") then
        table.insert(weapons, o)
      elseif weaponType == "GrenadeGas" and IsKindOf(classdef, "Grenade") and classdef:IsGasGrenade(o.aoeType) then
        table.insert(weapons, o)
      elseif weaponType == "GrenadeFire" and IsKindOf(classdef, "Grenade") and classdef:IsFireGrenade(o.aoeType) then
        table.insert(weapons, o)
      elseif classdef.WeaponType == weaponType or weaponType == "HeavyWeapon" and (o.group == weaponType or IsKindOf(classdef, "HeavyWeapon")) then
        table.insert(weapons, o)
      elseif weaponType == "Armor" and IsKindOf(classdef, "Armor") then
        table.insert(weapons, o)
      end
    end
  end)
  TSort(weapons, function(x)
    return x:GetProperty("DisplayName") or Untranslated(x.id)
  end)
  return weapons
end
local AmmoRarity = {
  AmmoBasicColor = 0,
  AmmoAPColor = 1,
  AmmoHPColor = 2,
  AmmoMatchColor = 3,
  AmmoTracerColor = 4
}
function GetAmmosWithCaliber(caliber, sort)
  local items = {}
  ForEachPreset("InventoryItemCompositeDef", function(o)
    local tclass = g_Classes[o.object_class]
    if IsKindOfClasses(tclass, "Ammo", "Ordnance") and o.Caliber == caliber then
      table.insert(items, o)
    end
  end)
  if sort then
    table.sort(items, function(a, b)
      return (AmmoRarity[a.colorStyle] or 100) < (AmmoRarity[b.colorStyle] or 100)
    end)
  end
  return items
end
function TFormat.ItemName(context, item)
  return g_Classes[item] and g_Classes[item].DisplayName or Untranslated("")
end
function OnMsg.CombatActionCanceled(action_id, unit)
  if g_ItemNetEvents[action_id] and unit then
    local dlg = GetMercInventoryDlg()
    local context = dlg and dlg:GetContext()
    if context then
      dlg:SetContext(context, "update")
      dlg:OnContextUpdate(context)
      InventoryUIRespawn()
    end
  end
end
function InventoryUIGrayOut(obj)
  if (not gv_SatelliteView or InventoryIsCombatMode()) and not InventoryIsValidGiveDistance(obj, GetInventoryUnit()) then
    return true
  end
  if InventoryIsNotControlled(obj) then
    return true
  end
end
function InventoryIsNotControlled(obj)
  if IsKindOf(obj, "Unit") and obj:IsDead() then
    return false
  end
  if IsKindOfClasses(obj, "Unit", "UnitData") and (obj:HasStatusEffect("BandageInCombat") or obj:IsDowned() or obj:HasStatusEffect("Unconscious") or g_Overwatch[obj] or g_Pindown[obj]) then
    return true
  end
  return IsKindOf(obj, "Unit") and obj:IsPlayerAlly() and not obj:CanBeControlled() or IsKindOf(obj, "UnitData") and gv_Squads[obj.Squad] and gv_Squads[obj.Squad].Side == "player1" and not obj:CanBeControlled()
end
function GetDropContainer(unit, pos, item_to_add)
  pos = pos or SnapToPassSlab(unit) or unit:GetPos()
  local container = MapGetFirst(pos, const.SlabSizeX / 2, "ItemDropContainer", function(o)
    if not item_to_add then
      return true
    end
    local pos, reason = o:CanAddItem("Inventory", item_to_add)
    return not not pos
  end)
  if not container then
    container = PlaceObject("ItemDropContainer")
    container:SetAngle(container:Random(21600))
    container:SetPos(pos)
  end
  return container
end
local SquadBagAction = function(srcInventory, srcSlotName, itemId, squadId, actionName)
  NetUpdateHash("SquadBagAction", srcSlotName, itemId, squadId, actionName)
  local squadBag = squadId and GetSquadBagInventory(squadId)
  local srcType = type(srcInventory)
  if srcType == "number" then
    srcInventory = GetSquadBagInventory(srcInventory)
  elseif srcType == "string" then
    local val = gv_SatelliteView and gv_UnitData[srcInventory] or g_Units[srcInventory]
    if not val then
      if gv_Sectors[srcInventory] then
        InventoryUIResetSectorStash()
        val = GetSectorInventory(srcInventory)
      else
        val = gv_UnitData[srcInventory]
      end
    end
    srcInventory = val
  end
  local item = g_ItemIdToItem[itemId]
  if actionName == "unload" then
    UnloadWeapon(item, squadBag)
  elseif actionName == "unload underslung" then
    if IsKindOf(item, "FirearmBase") then
      item = item:GetSubweapon("Firearm")
      if item then
        UnloadWeapon(item, squadBag)
      end
    end
  elseif actionName == "scrap" then
    ScrapItem(srcInventory, srcSlotName, item, squadBag, squadId)
  elseif actionName == "salvage" then
    SalvageItem(srcInventory, srcSlotName, item, squadBag)
  elseif actionName == "refill" then
    RefillMedsItem(srcInventory, srcSlotName, item, squadBag)
  elseif actionName == "cashin" then
    CashInItem(srcInventory, srcSlotName, item, 1)
  elseif actionName == "cashstack" or actionName == "cashstack-nolog" then
    CashInItem(srcInventory, srcSlotName, item, nil, actionName == "cashstack-nolog")
  end
  Msg("InventoryChange", srcInventory)
  Msg("InventoryChange", squadBag)
  Msg("InventoryAddItem", squadBag)
  Msg("InventoryRemoveItem", srcInventory)
  ObjModified(srcInventory)
  ObjModified(squadBag)
  if srcInventory:HasMember("CanBeControlled") and srcInventory:CanBeControlled() and not srcInventory:IsDead() then
    InventoryUpdate(srcInventory)
  end
end
function NetSyncEvents.SquadBagAction(session_id, pack)
  for i, data in ipairs(pack or empty_table) do
    SquadBagAction(unpack_params(data))
  end
end
function CustomCombatActions.SquadBagAction(unit, ap, pack)
  for i, data in ipairs(pack) do
    SquadBagAction(unpack_params(data))
  end
end
function Combine2Items(recipe_id, outcome, outcome_hp, skill_type, unit_operator, item1_context, item1_pos, item2_context, item2_pos, item2, combine_count)
  Combine2ItemsInternal(recipe_id, outcome, outcome_hp, skill_type, unit_operator, item1_context, item1_pos, item2_context, item2_pos, item2)
  local combineCount = combine_count
  if combineCount and 1 < combineCount then
    combineCount = combineCount - 1
    local unit = gv_UnitData[unit_operator]
    local recipe = Recipes[recipe_id]
    local ingredients = InventoryGetIngredientsForRecipe(recipe, unit)
    for i = 1, combineCount do
      local ingredientOne = ingredients[1].total_data[i]
      local ingredientTwo = ingredients[2].total_data[i]
      local item1Ctx = GetContainerNetId(ingredientOne.container)
      local item1Pos = ingredientOne.container:GetItemPackedPos(ingredientOne.item)
      local item2Ctx = GetContainerNetId(ingredientTwo.container)
      local item2Pos = ingredientTwo.container:GetItemPackedPos(ingredientTwo.item)
      Combine2ItemsInternal(recipe_id, outcome, outcome_hp, skill_type, unit_operator, item1Ctx, item1Pos, item2Ctx, item2Pos)
    end
  end
end
function Combine2ItemsInternal(recipe_id, outcome, outcome_hp, skill_type, unit_operator, item1_context, item1_pos, item2_context, item2_pos, item2)
  local recipe = Recipes[recipe_id]
  local is_string = type(unit_operator) == "string"
  local combat_mode
  if is_string then
    combat_mode = g_Units[unit_operator] and InventoryIsCombatMode(g_Units[unit_operator])
    unit_operator = (not gv_SatelliteView or combat_mode) and g_Units[unit_operator] or gv_UnitData[unit_operator]
    if combat_mode and gv_SatelliteView then
      unit_operator:SyncWithSession("session")
    end
  end
  local context1 = GetContainerFromContainerNetId(item1_context)
  local is_bag1 = type(item1_context) == "number"
  local context2 = GetContainerFromContainerNetId(item2_context)
  local is_bag2 = type(item2_context) == "number"
  local pos1x, pos1y, slot1_idx = point_unpack(item1_pos)
  local pos2x, pos2y, slot2_idx = point_unpack(item2_pos)
  local slot1 = context1.inventory_slots[slot1_idx].slot_name
  local item1 = context1:GetItemAtPos(slot1, pos1x, pos1y)
  local slot2 = context2.inventory_slots[slot2_idx].slot_name
  local item2 = item2 or context2:GetItemAtPos(slot2, pos2x, pos2y)
  local is_stack1 = IsKindOf(item1, "InventoryStack")
  local is_stack2 = IsKindOf(item2, "InventoryStack")
  if outcome == "crit-fail" then
    if skill_type == "Explosives" then
      local _, src_pos1 = context1:RemoveItem(slot1, item1)
      local _, src_pos2 = context2:RemoveItem(slot2, item2)
      local hp = outcome_hp
      local diff = MulDivRound(unit_operator.HitPoints, hp, 100)
      unit_operator.HitPoints = unit_operator.HitPoints - diff
      unit_operator:AccumulateDamageTaken(diff)
      if is_stack1 then
        item1.Amount = item1.Amount - recipe.Ingredients[first_idx].amount
        if item1.Amount <= 0 then
          DoneObject(item1)
        end
      else
        DoneObject(item1)
      end
      if is_stack2 then
        item2.Amount = item2.Amount - recipe.Ingredients[second_index].amount
        if item2.Amount <= 0 then
          DoneObject(item2)
        end
      else
        DoneObject(item2)
      end
      if is_string then
        Msg("InventoryRemoveItem", context1)
        Msg("InventoryRemoveItem", context2)
        if combat_mode and gv_SatelliteView then
          unit_operator:SyncWithSession("map")
        end
      end
      return
    end
    outcome = "fail"
  end
  local first_idx, sec_idx = 1, 2
  local first_ing_item, second_ing_item = item1, item2
  if recipe.Ingredients[1].item == item2.class then
    first_idx, sec_idx = 2, 1
    first_ing_item, second_ing_item = item2, item1
  end
  if outcome == "fail" then
    local is_ammo1 = IsKindOf(item1, "Ammo")
    local is_ammo2 = IsKindOf(item2, "Ammo")
    if is_ammo1 then
      local change_amount = -MulDivRound(recipe.Ingredients[first_idx].amount, 20, 100) or 0
      item1.Amount = item1.Amount + change_amount
    elseif item1:HasCondition() then
      local change_condition = -MulDivRound(item1.Condition, 20, 100)
      context1:ItemModifyCondition(item1, change_condition)
    end
    if is_string then
      Msg("InventoryChange", context1)
      Msg("InventoryChangeItemUI", context1)
    end
    if is_ammo2 then
      local change_amount = -MulDivRound(recipe.Ingredients[sec_idx].amount, 20, 100) or 0
      item2.Amount = item2.Amount + change_amount
    elseif item2:HasCondition() then
      local change_condition = -MulDivRound(item2.Condition, 20, 100)
      context2:ItemModifyCondition(item2, change_condition)
    end
    if is_string then
      Msg("InventoryChange", context2)
      Msg("InventoryChangeItemUI", context2)
      if combat_mode and gv_SatelliteView then
        unit_operator:SyncWithSession("map")
      end
    end
    return
  end
  if is_stack1 then
    item1.Amount = item1.Amount - recipe.Ingredients[first_idx].amount
  end
  if is_stack2 then
    item2.Amount = item2.Amount - recipe.Ingredients[sec_idx].amount
  end
  local delete_item1, delete_item2, src_pos1, src_pos2
  if not is_stack1 or item1.Amount == 0 then
    delete_item1, src_pos1 = context1:RemoveItem(slot1, item1)
  end
  if not is_stack2 or item2.Amount == 0 then
    delete_item2, src_pos2 = context2:RemoveItem(slot2, item2)
  end
  for i = 1, #recipe.ResultItems do
    local new_item_id = recipe.ResultItems[i].item
    local new_item_amount = recipe.ResultItems[i].amount
    local new_item = PlaceInventoryItem(new_item_id)
    local item = i == 1 and first_ing_item or second_ing_item
    new_item.Condition = item.Condition
    local is_transmuted = IsKindOf(new_item, "TransmutedItemProperties")
    local is_stack = IsKindOf(new_item, "InventoryStack")
    if is_transmuted then
      new_item:MakeTransmutation(item)
      new_item.RevertCondition = recipe.RevertCondition
      new_item.RevertConditionCounter = recipe.RevertConditionValue
      new_item.OriginalItemId = recipe.Ingredients[1].item
    end
    if is_stack then
      new_item.Amount = new_item_amount
    end
    local skip = i == 1 and not IsEquipSlot(slot1) and IsEquipSlot(slot2)
    local context, new_slot, pos, reason
    if not skip then
      context = i == 1 and context1 or context2
      new_slot = i == 1 and slot1 or slot2
      local equip_to_inventory = false
      if IsWeaponSlot(new_slot) then
        equip_to_inventory = (i == 1 and is_stack1 or is_stack2) and (i == 1 and is_stack1 and item1.Amount > 0 or is_stack2 and item2.Amount > 0)
      end
      if new_slot == "Inventory" or equip_to_inventory then
        pos, reason = AddItemsToInventory(context, {new_item}, IsKindOf("UnitProperties", context))
      else
        pos, reason = context:AddItem(new_slot, new_item)
      end
      if not pos then
        pos, reason = AddItemsToInventory(context, {new_item}, IsKindOf("UnitProperties", context))
      end
    end
    if not pos then
      context = i == 1 and context2 or context1
      new_slot = i == 1 and slot2 or slot1
      local equip_to_inventory = false
      if IsWeaponSlot(new_slot) then
        equip_to_inventory = (i == 1 and is_stack1 or is_stack2) and (i == 1 and is_stack1 and item1.Amount > 0 or is_stack2 and item2.Amount > 0)
      end
      if new_slot == "Inventory" or equip_to_inventory then
        pos, reason = AddItemsToInventory(context, {new_item}, IsKindOf("UnitProperties", context))
      else
        pos, reason = context:AddItem(new_slot, new_item)
      end
      if not pos then
        pos, reason = AddItemsToInventory(context, {new_item}, IsKindOf("UnitProperties", context))
      end
    end
    local target
    if not pos then
      local units = {
        context1,
        context2,
        unit_operator
      }
      for i = 1, #units do
        local unit = units[i]
        target = IsKindOf(unit, "Unit") and GetDropContainer(unit, false, new_item) or unit.Squad and GetSectorInventory(gv_Squads[unit.Squad].CurrentSector)
        if target then
          pos, reason = target:AddItem("Inventory", new_item)
          if pos then
            local amount = is_stack and new_item.Amount or 1
            CombatLog("important", T({
              740183432105,
              "  Inventory full. <amount><em><item></em> dropped by <name>",
              amount = 1 < amount and Untranslated(amount .. " x ") or "",
              item = 1 < amount and item.DisplayNamePlural or item.DisplayName,
              name = unit:GetDisplayName()
            }))
            break
          end
        end
      end
    end
    if is_string then
      Msg("InventoryChange", context)
      if pos then
        Msg("InventoryAddItem", target or context)
      end
    end
  end
  Msg("CombineItemsSuccess", unit_operator, skill_type)
  DoneObject(delete_item1)
  DoneObject(delete_item2)
  if is_string then
    if delete_item1 then
      Msg("InventoryRemoveItem", context1)
    end
    if delete_item2 then
      Msg("InventoryRemoveItem", context2)
    end
    Msg("InventoryChangeItemUI", context1)
    Msg("InventoryChangeItemUI", context2)
    if combat_mode and gv_SatelliteView then
      unit_operator:SyncWithSession("map")
    end
  end
end
function Inventory:ItemModifyCondition(item, amount)
  if not item:HasCondition() then
    return
  end
  local prev = item.Condition
  local newValue = Max(0, item.Condition + amount)
  item.Condition = newValue
  Msg("InventoryChange", self)
  if prev ~= newValue then
    Msg("ItemChangeCondition", item, prev, newValue, self)
  end
  ObjModified(item)
  ObjModified(self)
  return newValue
end
function NetSyncEvents.CombineItems(pack)
  Combine2Items(unpack_params(pack))
end
function NetSyncEvents.WeaponModifyCondition(ownerId, weaponSlot, amount)
  local owner = gv_SatelliteView and gv_UnitData[ownerId] or g_Units[ownerId]
  if not owner then
    return
  end
  local weaponItem = owner:GetItemAtPackedPos(weaponSlot)
  owner:ItemModifyCondition(weaponItem, amount)
end
function NetSyncEvents.WeaponModified(ownerId, weaponSlot, components, color, success, modAdded, mechanicId)
  local owner = gv_SatelliteView and gv_UnitData[ownerId] or g_Units[ownerId]
  if not owner then
    return
  end
  local weaponItem = owner:GetItemAtPackedPos(weaponSlot)
  if weaponItem then
    for s, c in sorted_pairs(components) do
      weaponItem:SetWeaponComponent(s, c)
    end
    if color then
      weaponItem.Color = color
    end
    weaponItem:UpdateVisualObj()
    ObjModified(weaponItem)
  end
  if not gv_SatelliteView then
    owner:FlushCombatCache()
    owner:RecalcUIActions(true)
  end
  local mechanic = gv_SatelliteView and gv_UnitData[mechanicId] or g_Units[mechanicId]
  if success then
    Msg("WeaponModifiedSuccessSync", weaponItem, owner, modAdded, mechanic)
  end
end
function CustomCombatActions.CombineItems(unit, ap, pack)
  Combine2Items(unpack_params(pack))
end
DefineClass.MiscItem = {
  __parents = {
    "InventoryStack",
    "MiscItemProperties"
  }
}
DefineClass.StatBoostItem = {
  __parents = {
    "QuickSlotItem",
    "StatBoostItemProperties"
  },
  modifiers_added = {},
  modifier_id = false
}
function StatBoostItem:GenerateModifierId(u, slot, pos)
  self.modifier_id = string.format("StatBoostItem-%s-%s-%s-%d", self.class, u.session_id, slot, pos)
end
function StatBoostItem:OnAdd(u, slot, pos, item)
  InventoryItem.OnAdd(self, u, slot, item)
  if not IsKindOf(u, "Modifiable") or not IsEquipSlot(slot) then
    return
  end
  if not self.stat or not self.boost then
    return
  end
  self:GenerateModifierId(u, slot, pos)
  local mod = u:AddModifier(self.modifier_id, self.stat, false, self.boost, self.DisplayName, nil, self.boost)
  ObjModified(u)
  Msg("ModifierAdded", u, self.stat, mod)
end
function StatBoostItem:OnRemove(u, slot, pos, item)
  if not IsKindOf(u, "Modifiable") or not IsEquipSlot(slot) then
    return
  end
  if not self.stat or not self.boost then
    return
  end
  if not self.modifier_id then
    self:GenerateModifierId(u, slot, pos)
  end
  u:RemoveModifier(self.modifier_id, self.stat)
  ObjModified(u)
end
function OnMsg.InventoryChange(obj)
  if IsKindOf(obj, "Unit") then
    obj:ApplyModifiersList(obj.applied_modifiers)
  end
end
g_InventoryItemEffectMoments = {"on_pickup", "on_use"}
function InventoryItemEffectMoments()
  return g_InventoryItemEffectMoments
end
function ScrapItem(inventory, slot_name, item, squadBag, squadId)
  local partsAmount = item:AmountOfScrapPartsFromItem()
  local additional
  if IsKindOf(item, "Firearm") then
    additional = item:GetSpecialScrapItems()
  end
  if next(additional) then
    local units = gv_Squads[squadId].units
    local unit_id = table.max(units, function(unit_id)
      return gv_UnitData[unit_id].Mechanical
    end)
    local max_mech = gv_UnitData[unit_id].Mechanical / 2
    local rnd_unit = gv_UnitData[units[1]]
    local rand = rnd_unit:Random(100)
    if max_mech > rand then
      local res_idx = 1 + rnd_unit:Random(#additional)
      local res = additional[res_idx]
      local item = PlaceInventoryItem(res.restype)
      if IsKindOf(item, "InventoryStack") then
        item.Amount = res.amount
      end
      inventory:AddItem("Inventory", item)
    end
  end
  if item.ammo then
    UnloadWeapon(item, squadBag)
  end
  if 0 < partsAmount then
    local parts = PlaceInventoryItem("Parts")
    parts.Amount = partsAmount
    squadBag:AddAndStackItem(parts)
  end
  local removedItem, pos = inventory:RemoveItem(slot_name, item)
  DoneObject(removedItem)
  if IsKindOf(inventory, "Unit") and slot_name == inventory.current_weapon and inventory:IsIdleCommand() then
    inventory:SetCommand("Idle")
  end
end
function AmountOfMedsToFill(item)
  local meds = AmountOfSalvagedMeds(item, item.Condition, const.MedicineRefillToSalvageFactor)
  return MulDivRound(item.max_meds_parts, const.MedicineRefillToSalvageFactor, 100) - meds
end
function RefillMedsItem(inventory, slot_name, item, squadBag)
  local medsNeeded = AmountOfMedsToFill(item)
  if medsNeeded <= 0 then
    return
  end
  local allmedsNeeded = medsNeeded
  local rem
  if IsKindOfClasses(inventory, "UnitData", "Unit") and not inventory:IsDead() then
    rem = TakeItemFromMercs({
      inventory.session_id
    }, "Meds", medsNeeded)
  else
    rem = TakeItemFromSquadBag(squadBag.squad_id, "Meds", medsNeeded)
  end
  local usedmeds = allmedsNeeded - rem
  local max_condition = item:GetMaxCondition()
  if rem == 0 then
    item.Condition = max_condition
  else
    item.Condition = Clamp(item.Condition + MulDivRound(usedmeds, max_condition - item.Condition, allmedsNeeded), 0, max_condition)
  end
end
function AmountOfSalvagedMeds(item, condition, factor)
  local condition = condition or item.Condition
  if condition and 1 <= condition then
    local max_meds = factor and MulDivRound(item.max_meds_parts, const.MedicineRefillToSalvageFactor, 100) or item.max_meds_parts
    return Clamp(MulDivRound(condition, max_meds, item:GetMaxCondition()), 1, max_meds)
  end
  return 0
end
function SalvageItem(inventory, slot_name, item, squadBag)
  local medsAmount = AmountOfSalvagedMeds(item)
  if medsAmount <= 0 then
    return
  end
  local meds = PlaceInventoryItem("Meds")
  meds.Amount = medsAmount
  squadBag:AddAndStackItem(meds)
  local removedItem, pos = inventory:RemoveItem(slot_name, item)
  DoneObject(removedItem)
end
function CashInItem(inventory, slot_name, item, amount, dontLog)
  local money = item.Cost
  local to_remove
  if IsKindOf(item, "InventoryStack") then
    amount = amount or item.Amount
    amount = Min(amount, item.Amount)
    money = money * amount
    item.Amount = item.Amount - amount
    to_remove = item.Amount == 0
  else
    to_remove = true
  end
  AddMoney(money, "deposit", dontLog)
  Msg("CashInItem", item)
  if to_remove then
    local removedItem, pos = inventory:RemoveItem(slot_name, item)
    DoneObject(removedItem)
  end
end
function GetValuablesWorthInMerc(mercId)
  local ud = gv_UnitData[mercId]
  if not ud then
    return
  end
  local moneyAmount = 0
  ud:ForEachItem(false, function(item, slot)
    if not IsKindOf(item, "Valuables") then
      return
    end
    local amount = 1
    if IsKindOf(item, "InventoryStack") then
      amount = item.Amount
    end
    moneyAmount = moneyAmount + item.Cost * amount
  end)
  return moneyAmount
end
function CashInMercValuables(mercId)
  local ud = gv_UnitData[mercId]
  if not ud then
    return
  end
  local params = {}
  ud:ForEachItem(false, function(item, slot_name)
    if not IsKindOf(item, "Valuables") then
      return
    end
    NetSquadBagAction(ud, ud, slot_name, item, false, "cashstack-nolog", 0)
  end)
end
function UnloadWeapon(item, squadBag)
  local ammo = item.ammo
  item.ammo = false
  if ammo and ammo.Amount > 0 then
    squadBag:AddAndStackItem(ammo)
  end
  if IsKindOf(item, "Firearm") then
    item:OnUnloadWeapon()
  end
end
local o1, o2
function SuppressInvUpdates()
  if not o1 then
    o1, o2 = InventoryUIRespawn, ObjModified
    InventoryUIRespawn = empty_func
    ObjModified = empty_func
    print("suppressed")
  else
    InventoryUIRespawn, ObjModified = o1, o2
    o1 = false
    o2 = false
    print("restored")
  end
end
function InventoryTakeAll(units, containers)
  if InventoryDragItem and StartDragSource then
    StartDragSource:CancelDragging()
  end
  local net_units, net_containers = {}, {}
  for i, unit in ipairs(units) do
    net_units[i] = GetContainerNetId(unit)
  end
  for i, container in ipairs(containers) do
    net_containers[i] = GetContainerNetId(container)
  end
  NetSyncEvent("InventoryTakeAllNet", netUniqueId, net_units, net_containers)
end
function NetSyncEvents.InventoryTakeAllNet(playerId, net_units, net_containers)
  local units, containers = {}, {}
  for i, unit in ipairs(net_units) do
    units[i] = GetContainerFromContainerNetId(unit)
  end
  for i, container in ipairs(net_containers) do
    containers[i] = GetContainerFromContainerNetId(container)
  end
  local is_local_player = playerId == netUniqueId
  local pick_cost = g_Combat and const["Action Point Costs"].PickItem or 0
  local squad_bag = GetSquadBagInventory(units[1] and units[1].Squad) or gv_SquadBag
  local unit_done = {}
  local itemsTakenCount, itemsNonTakenCount = 0, 0
  for _, container in ipairs(containers or empty_table) do
    if IsKindOf(container, "SectorStash") then
      container:ResetBinding()
    end
    local container_slot_name = GetContainerInventorySlotName(container)
    local result = container:ForEachItemInSlot(container_slot_name, false, function(item, slot_name, src_left, src_top)
      local overwriteApCost = 0 < itemsTakenCount and 0
      local item_placeholder = {
        id = item.id,
        DisplayName = item.DisplayName,
        DisplayNamePlural = item.DisplayNamePlural,
        class = item.class
      }
      local is_stack = IsKindOf(item, "InventoryStack")
      local amount = is_stack and item.Amount or 1
      local args = {
        item = item,
        src_container = container,
        src_slot = container_slot_name,
        dest_container = squad_bag,
        dest_slot = "Inventory",
        ap_cost = overwriteApCost,
        sync_call = true
      }
      local result, new_amount = MoveItem(args)
      if result then
        for _, unit in ipairs(units) do
          if not unit_done[unit] and InventoryIsValidGiveDistance(container, unit) then
            local args = {
              item = item,
              src_container = container,
              src_slot = container_slot_name,
              dest_container = unit,
              dest_slot = "Inventory",
              ap_cost = overwriteApCost,
              sync_call = true
            }
            result, new_amount = MoveItem(args)
            if result then
              if result == "Unit doesn't have ap to execute action" then
                unit_done[unit] = true
                if is_local_player then
                  CombatLog("important", T({
                    308028682851,
                    "<DisplayName> doesn't have enough AP to pick all items",
                    unit
                  }))
                  PlayFX("TakeAllFail", "start", unit)
                end
              end
              if new_amount == "inventory full" and not item.LargeItem then
                unit_done[unit] = true
              end
            else
              local transfered = not new_amount and amount or amount - new_amount
              amount = amount - transfered
              if is_local_player then
                Msg("InventoryTakeAllAddItem", unit, item_placeholder, transfered)
              end
              if amount <= 0 then
                itemsTakenCount = itemsTakenCount + 1
                return
              end
            end
          end
        end
      else
        itemsTakenCount = itemsTakenCount + 1
        if is_local_player then
          Msg("SquadBagTakeAllAddItem", item_placeholder, amount)
        end
        return
      end
      itemsNonTakenCount = itemsNonTakenCount + 1
    end, units)
  end
  if is_local_player then
    if itemsNonTakenCount <= 0 then
      local dlg = GetDialog("FullscreenGameDialogs")
      if dlg then
        dlg:SetMode("empty")
        dlg:Close()
      end
    else
      CombatLog("important", T(928914188428, "The inventory of the nearby mercs is full"))
    end
  end
  return itemsTakenCount, itemsNonTakenCount
end
function TakeLootFromAutoResolve(units, items, sectorId)
  local netUnits = {}
  local netItems = {}
  for i, unit in ipairs(units) do
    netUnits[i] = GetContainerNetId(unit)
  end
  for i, item in ipairs(items) do
    netItems[i] = item.id
  end
  NetSyncEvent("TakeLootFromAutoResolveNet", netUniqueId, netUnits, netItems, sectorId)
end
function NetSyncEvents.TakeLootFromAutoResolveNet(executingNetId, netUnits, netItems, sectorId)
  local isLocalPlayer = netUniqueId == executingNetId
  local units, items = {}, {}
  for i, unitId in ipairs(netUnits) do
    units[i] = GetContainerFromContainerNetId(unitId)
  end
  for i, itemId in ipairs(netItems) do
    items[i] = g_ItemIdToItem[itemId]
  end
  local src_container = GetSectorInventory(sectorId)
  local src_container_slot_name = "Inventory"
  local squad_bag = GetSquadBagInventory(units[1] and units[1].Squad) or gv_SquadBag
  local unit_done = {}
  local itemsTakenCount = 0
  local itemsNonTaken = {}
  for _, item in ipairs(items) do
    local item_placeholder = {
      id = item.id,
      DisplayName = item.DisplayName,
      DisplayNamePlural = item.DisplayNamePlural,
      class = item.class
    }
    local is_stack = IsKindOf(item, "InventoryStack")
    local amount = is_stack and item.Amount or 1
    local args = {
      item = item,
      dest_container = squad_bag,
      dest_slot = "Inventory",
      src_container = src_container,
      src_container_slot_name = src_container_slot_name,
      sync_call = true
    }
    local result, new_amount = MoveItem(args)
    if result then
      for _, unit in ipairs(units) do
        if not unit_done[unit] then
          local args = {
            item = item,
            dest_container = unit,
            dest_slot = "Inventory",
            src_container = src_container,
            src_container_slot_name = src_container_slot_name,
            sync_call = true
          }
          result, new_amount = MoveItem(args)
          if result then
            if new_amount == "inventory full" and not item.LargeItem then
              unit_done[unit] = true
            end
          else
            local transfered = not new_amount and amount or amount - new_amount
            amount = amount - transfered
            Msg("InventoryTakeAllAddItem", unit, item_placeholder, transfered, "auto_resolve")
            if amount <= 0 then
              itemsTakenCount = itemsTakenCount + 1
              goto lbl_138
            end
          end
        end
      end
    else
      itemsTakenCount = itemsTakenCount + 1
      Msg("SquadBagTakeAllAddItem", item_placeholder, amount, "auto_resolve")
      goto lbl_138
    end
    itemsNonTaken[#itemsNonTaken + 1] = item
    ::lbl_138::
  end
  local conflictDlg = GetDialog("SatelliteConflict")
  if isLocalPlayer then
    if 0 < #itemsNonTaken then
      CreateRealTimeThread(function()
        local popupHost = GetDialog("PDADialog")
        popupHost = popupHost and popupHost:ResolveId("idDisplayPopupHost")
        local popup = CreateMessageBox(nil, T(719913116871, "Not enough space"), T(585970067597, "Some of the items were placed in the sector stash"), T(6877, "OK"), popupHost)
        popup:Wait()
        conflictDlg:Close()
      end)
    else
      conflictDlg:Close()
    end
  elseif conflictDlg then
    conflictDlg:Close()
  end
end
function GetItemsNamesText(items)
  local texts = {}
  for _, item in ipairs(items) do
    local item_id = item.class
    local item_name = item.DisplayName
    local item_name_pl = item.DisplayNamePlural
    if item_id == "Money" then
      texts[#texts + 1] = T({
        975705544014,
        "<em><money(Amount)></em>",
        Amount = item.Amount
      })
    elseif item.Amount then
      texts[#texts + 1] = T({
        322035442910,
        "<Amount> x <em><item></em>",
        Amount = item.Amount,
        item = 1 >= item.Amount and item_name or item_name_pl
      })
    else
      texts[#texts + 1] = T({
        817405706345,
        "<em><item></em>",
        item = item_name
      })
    end
  end
  return table.concat(texts, ", ")
end
function GetInventoryHash(obj)
  local hash = 0
  for i = 1, #obj, 2 do
    local pos = obj[i]
    local item = obj[i + 1]
    local itemId = item.id
    hash = xxhash(hash, pos, itemId)
  end
  return hash
end
function UseNewInventoryRollover(item)
  return item and (item:IsWeapon() or IsKindOfClasses(item, "Grenade", "Ordnance") or IsKindOf(item, "Armor"))
end
function OnMsg.UnitDieStart(unit)
  if not IsMerc(unit) then
    return
  end
  unit:ForEachItem(function(item, slot)
    if item.locked then
      unit:RemoveItem(slot, item)
    end
  end)
end
