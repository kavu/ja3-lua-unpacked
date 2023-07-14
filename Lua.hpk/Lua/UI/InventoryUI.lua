local equip_slot_images = {
  Head = "UI/Icons/Items/background_helmet",
  Legs = "UI/Icons/Items/background_pants",
  Torso = "UI/Icons/Items/background_vest",
  ["Handheld A"] = "UI/Icons/Items/background_weapon",
  ["Handheld B"] = "UI/Icons/Items/background_weapon",
  ["Handheld A Big"] = "UI/Icons/Items/background_weapon_big",
  ["Handheld B Big"] = "UI/Icons/Items/background_weapon_big"
}
local tile_size = 90
local tile_size_rollover = 110
local GetTileImage = function(ctrl, tile)
  local enabled = ctrl:GetEnabled()
  local slot = ctrl.parent:GetInventorySlotCtrl()
  return enabled and (tile and "UI/Inventory/T_Backpack_Slot_Small_Empty.tga" or "UI/Inventory/T_Backpack_Slot_Small.tga") or "UI/Inventory/T_Backpack_Slot_Small_Empty.tga"
end
DefineClass.XInventoryTile = {
  __parents = {
    "XHoldButtonControl"
  },
  MinWidth = tile_size_rollover,
  MaxWidth = tile_size_rollover,
  MinHeight = tile_size_rollover,
  MaxHeight = tile_size_rollover,
  ImageFit = "width",
  slot_image = false,
  MouseCursor = "UI/Cursors/Hand.tga",
  CursorsFolder = "UI/DesktopGamepad/"
}
function XInventoryTile:Init()
  local image = XImage:new({
    MinWidth = tile_size,
    MaxWidth = tile_size,
    MinHeight = tile_size,
    MaxHeight = tile_size,
    Id = "idBackImage",
    Image = "UI/Inventory/T_Backpack_Slot_Small_Empty.tga",
    ImageColor = 4291018156
  }, self)
  if self.slot_image then
    local imgslot = XImage:new({
      MinWidth = tile_size,
      MaxWidth = tile_size,
      MinHeight = tile_size,
      MaxHeight = tile_size,
      Dock = "box",
      Id = "idEqSlotImage",
      ImageFit = "width"
    }, self)
    imgslot:SetImage(self.slot_image)
    image:SetImage("UI/Inventory/T_Backpack_Slot_Small.tga")
    image:SetImageColor(RGB(255, 255, 255))
  end
  local rollover_image = XImage:new({
    MinWidth = tile_size_rollover,
    MaxWidth = tile_size_rollover,
    MinHeight = tile_size_rollover,
    MaxHeight = tile_size_rollover,
    Id = "idRollover",
    Image = "UI/Inventory/T_Backpack_Slot_Small_Hover.tga",
    ImageColor = 4291018156,
    Visible = false
  }, self)
  rollover_image:SetVisible(false)
end
function XInventoryTile:GetInventorySlotCtrl()
  return IsKindOf(self.parent, "XInventorySlot") and self.parent or false
end
function XInventoryTile:GetMouseCursor()
  return InventoryIsCompareMode() and "UI/Cursors/Inspect.tga" or XWindow.GetMouseCursor(self)
end
function XInventoryTile:IsDropTarget(drag_win, pt, source)
  local slot = self:GetInventorySlotCtrl()
  return slot:_IsDropTarget(drag_win, pt, source)
end
function XInventoryTile:OnDrop(drag_win, pt, drag_source_win)
end
function XInventoryTile:OnDropEnter(drag_win, pt, drag_source_win)
  local drag_item = InventoryDragItem
  local slot = self:GetInventorySlotCtrl()
  local mouse_text = InventoryGetMoveIsInvalidReason(slot.context, InventoryStartDragContext)
  local wnd, under_item = slot:FindItemWnd(pt)
  if under_item == drag_item then
    under_item = false
  end
  local is_reload = IsReload(drag_item, under_item)
  local ap_cost, unit_ap, action_name = GetAPCostAndUnit(drag_item, InventoryStartDragContext, InventoryStartDragSlotName, slot:GetContext(), slot.slot_name, under_item, is_reload)
  if not mouse_text then
    mouse_text = action_name or ""
    if InventoryIsCombatMode() and ap_cost and 0 < ap_cost then
      mouse_text = InventoryFormatAPMouseText(unit_ap, ap_cost, mouse_text)
    end
  end
  InventoryShowMouseText(true, mouse_text)
  HighlightDropSlot(self, true, pt, drag_win)
  HighlightAPCost(InventoryDragItem, true, self)
end
function XInventoryTile:OnDropLeave(drag_win, pt, source)
  if drag_win and drag_win.window_state ~= "destroying" then
    HighlightDropSlot(self, false, pt, drag_win)
    InventoryShowMouseText(false)
    HighlightAPCost(InventoryDragItem, false, self)
  end
end
function XInventoryTile:OnSetRollover(rollover)
  XDragAndDropControl.OnSetRollover(self, rollover)
  local img = self.idBackImage
  local slot = self:GetInventorySlotCtrl()
  if slot.rollover_image_transparency then
    img:SetTransparency(rollover and slot.rollover_image_transparency or slot.image_transparency)
  end
end
function XInventoryTile:SetEnabled(enabled)
  XContextControl.SetEnabled(self, enabled)
  self.idBackImage:SetImage(GetTileImage(self.idBackImage, true))
  self:SetHandleMouse(enabled)
end
if FirstLoad then
  StartDragSource = false
  InventoryStartDragSlotName = false
  InventoryStartDragContext = false
  InventoryDragItem = false
  InventoryDragItemPos = false
  InventoryDragItemPt = false
  SectorStashOpen = false
  WasDraggingLastLMBClick = false
end
function ClearDragGlobals()
  StartDragSource = false
  InventoryStartDragSlotName = false
  InventoryStartDragContext = false
  InventoryDragItem = false
  InventoryDragItemPos = false
  InventoryDragItemPt = false
end
DefineClass.XInventoryItem = {
  __parents = {
    "XHoldButtonControl"
  },
  HandleMouse = true,
  HandleKeyboard = true,
  UseClipBox = false,
  IdNode = true,
  RolloverTemplate = "RolloverInventory",
  MouseCursor = "UI/Cursors/Hand.tga",
  CursorsFolder = "UI/DesktopGamepad/"
}
function XInventoryItem:GetMouseCursor()
  return InventoryIsCompareMode() and "UI/Cursors/Inspect.tga" or XWindow.GetMouseCursor(self)
end
function XInventoryItem:OnMouseEnter(pt, child)
  XWindow.OnMouseEnter(self, pt, child)
  PlayFX("ItemRollover", "start", self.context.class)
end
function XInventoryItem:OnMouseLeft(pt, child)
  XWindow.OnMouseLeft(self, pt, child)
  local item = self.context
  if item and item.locked then
    self.idimgLocked:SetImageColor(GameColors.D)
  end
  PlayFX("ItemRollover", "end", self.context.class)
end
function XInventoryItem:Done()
  local slot = self:GetInventorySlotCtrl()
  if slot then
    slot.item_windows[self] = nil
  end
end
function XInventoryItem:Init()
  local dropshadow = XTemplateSpawn("XImage", self)
  dropshadow:SetId("idDropshadow")
  dropshadow:SetMargins(box(0, 20, 20, 0))
  dropshadow:SetUseClipBox(false)
  dropshadow:SetVisible(false)
  dropshadow:SetImageColor(2147483648)
  local item_pad = XTemplateSpawn("XImage", self)
  local item = self:GetContext()
  local w = item.LargeItem and tile_size_rollover * 2 or tile_size_rollover
  item_pad:SetMinWidth(w)
  item_pad:SetMaxWidth(w)
  item_pad:SetMinHeight(tile_size_rollover)
  item_pad:SetMaxHeight(tile_size_rollover)
  item_pad:SetHAlign("center")
  item_pad:SetVAlign("center")
  item_pad:SetId("idItemPad")
  item_pad:SetUseClipBox(false)
  item_pad:SetHandleMouse(true)
  function item_pad.SetRollover(this, rollover)
    XImage.SetRollover(this, rollover)
    local item = this:GetContext()
    local bShow = rollover
    if not bShow and DragSource then
      bShow = true
    end
    SetInventoryHighlights(item, bShow)
    local slot = self:GetInventorySlotCtrl()
    local owner = slot and slot:GetContext()
    local valid, mouse_text = InventoryIsValidTargetForUnit(owner or gv_UnitData[item.owner])
    if not valid then
      InventoryShowMouseText(rollover, mouse_text)
    end
  end
  function item_pad.OnSetRollover(this, rollover)
    XImage.OnSetRollover(this, rollover)
    local item = this:GetContext()
    local slot = this.parent:GetInventorySlotCtrl()
    if slot and slot.rollover_image_transparency then
      this:SetTransparency(rollover and slot.rollover_image_transparency or slot.image_transparency)
    end
    if slot and next(GetSlotsToEquipItem(self.context)) then
      local dlg = GetMercInventoryDlg()
      if not dlg then
        return
      end
      if InventoryIsCompareMode(dlg) then
        dlg:CloseCompare()
        if rollover then
          dlg:OpenCompare(self, item)
        end
      end
    end
  end
  local slot = self:GetInventorySlotCtrl()
  if slot then
    item_pad:SetTransparency(slot.image_transparency)
  end
  local rollover_image = XImage:new({
    MinWidth = tile_size_rollover,
    MaxWidth = tile_size_rollover,
    MinHeight = tile_size_rollover,
    MaxHeight = tile_size_rollover,
    Id = "idRollover",
    Image = "UI/Inventory/T_Backpack_Slot_Small_Hover.tga",
    Visible = false,
    UseClipBox = false,
    ImageColor = 4291018156
  }, self)
  function rollover_image.SetVisible(this, visible, ...)
    XImage.SetVisible(this, visible, ...)
    this.parent.idimgLocked:SetVisible(visible and item.locked, ...)
  end
  local item_img = XTemplateSpawn("XImage", self)
  item_img:SetPadding(box(15, 15, 15, 15))
  item_img:SetImageFit("width")
  item_img:SetId("idItemImg")
  item_img:SetUseClipBox(false)
  item_img:SetHandleMouse(false)
  if item.SubIcon and item.SubIcon ~= "" then
    local item_subimg = XTemplateSpawn("XImage", item_img)
    item_subimg:SetHAlign("left")
    item_subimg:SetVAlign("bottom")
    item_subimg:SetId("idItemSubImg")
    item_subimg:SetUseClipBox(false)
    item_subimg:SetHandleMouse(false)
  end
  if item:IsWeapon() and item.ComponentSlots and 0 < #item.ComponentSlots then
    local count, max = CountWeaponUpgrades(item)
    if 0 < count then
      local item_modimg = XTemplateSpawn("XImage", item_img)
      item_modimg:SetHAlign("left")
      item_modimg:SetVAlign("top")
      item_modimg:SetId("idItemModImg")
      item_modimg:SetUseClipBox(false)
      item_modimg:SetHandleMouse(false)
      item_modimg:SetImage("UI/Inventory/w_mod")
      item_modimg:SetScaleModifier(point(700, 700))
      item_modimg:SetMargins(box(-5, -5, 0, 0))
    end
  end
  local text = XTemplateSpawn("XText", self)
  text:SetTranslate(true)
  text:SetTextStyle("InventoryItemsCount")
  text:SetId("idText")
  text:SetUseClipBox(false)
  text:SetClip(false)
  text:SetPadding(box(2, 2, 10, 5))
  text:SetTextHAlign("right")
  text:SetTextVAlign("bottom")
  text:SetHandleMouse(false)
  local center_text = XTemplateSpawn("AutoFitText", self)
  center_text:SetTranslate(true)
  center_text:SetTextStyle("DescriptionTextAPRed")
  center_text:SetId("idCenterText")
  center_text:SetUseClipBox(false)
  center_text:SetTextHAlign("center")
  center_text:SetTextVAlign("center")
  center_text:SetHAlign("center")
  center_text:SetVAlign("center")
  center_text:SetHandleMouse(false)
  local topRightText = XTemplateSpawn("XText", self)
  topRightText:SetTranslate(true)
  topRightText:SetTextStyle("InventoryItemsCount")
  topRightText:SetId("idTopRightText")
  topRightText:SetUseClipBox(false)
  topRightText:SetClip(false)
  topRightText:SetPadding(box(2, 6, 10, 2))
  topRightText:SetTextHAlign("right")
  topRightText:SetTextVAlign("top")
  topRightText:SetHandleMouse(false)
  local imgLocked = XTemplateSpawn("XImage", self)
  imgLocked:SetId("idimgLocked")
  imgLocked:SetUseClipBox(false)
  imgLocked:SetClip(false)
  imgLocked:SetPadding(box(10, 2, 2, 10))
  imgLocked:SetHAlign("left")
  imgLocked:SetVAlign("bottom")
  imgLocked:SetHandleMouse(false)
  imgLocked:SetVisible(false)
  imgLocked:SetImage("UI/Inventory/padlock")
  imgLocked:SetImageColor(GameColors.D)
  rollover_image:SetVisible(false)
end
function XInventoryItem:OnSetRollover(rollover)
  if self.HandleMouse then
    XHoldButtonControl.OnSetRollover(self, rollover)
    local dlgContext = GetDialogContext(self)
    if dlgContext then
      local invDis, reason = InventoryDisabled(dlgContext)
      if invDis then
        InventoryShowMouseText(rollover, reason)
      end
    end
  end
end
function XInventoryItem:GetRolloverAnchor()
  local slot = self:GetInventorySlotCtrl()
  if slot and IsKindOf(slot, "BrowseInventorySlot") then
    local dlg = GetMercInventoryDlg()
    if InventoryIsCompareMode(dlg) and next(dlg.compare_wnd[1]) and next(GetSlotsToEquipItem(self.context)) then
      return "right"
    end
  end
  return "smart"
end
function XInventoryItem:OnContextUpdate(item, ...)
  local w, h = item:GetUIWidth(), item:GetUIHeight()
  self:SetMinWidth(tile_size * w)
  self:SetMaxWidth(tile_size * w)
  self:SetMinHeight(tile_size * h)
  self:SetMaxHeight(tile_size * h)
  self:SetGridWidth(w)
  self:SetGridHeight(h)
  self:SetRolloverTitle(item:GetRolloverTitle())
  self:SetRolloverText(item:GetRollover())
  self.idDropshadow:SetImage(item.LargeItem and "UI/Inventory/T_Backpack_Slot_Large" or GetTileImage(self.idItemPad))
  self.idItemPad:SetImage(item.LargeItem and "UI/Inventory/T_Backpack_Slot_Large_Empty.tga" or "UI/Inventory/T_Backpack_Slot_Small_Empty.tga")
  local slot = self:GetInventorySlotCtrl()
  if slot and IsEquipSlot(slot.slot_name) then
    self.idItemPad:SetImage(item.LargeItem and "UI/Inventory/T_Backpack_Slot_Large.tga" or GetTileImage(self.idItemPad))
  end
  self.idRollover:SetImage(item.LargeItem and "UI/Inventory/T_Backpack_Slot_Large_Hover.tga" or "UI/Inventory/T_Backpack_Slot_Small_Hover.tga")
  self.idRollover:SetImageColor(4291018156)
  self.idText:SetText(item:GetItemSlotUI() or "")
  if IsKindOfClasses(item, "Armor", "Firearm", "HeavyWeapon", "MeleeWeapon", "ToolItem", "Medicine") and not IsKindOf(item, "InventoryStack") then
    self.idTopRightText:SetText(item:GetConditionText() or "")
  end
  local txt = item:GetItemStatusUI()
  self.idCenterText:SetTextStyle("DescriptionTextAPRed")
  self.idCenterText:SetText(txt)
  self.idItemImg:SetTransparency(txt and txt ~= "" and 128 or 0)
  self.idItemImg:SetImage(item:GetItemUIIcon())
  if item.SubIcon and item.SubIcon ~= "" then
    self.idItemImg.idItemSubImg:SetImage(item.SubIcon or "")
  end
end
function XInventoryItem:SetPosition(left, top)
  self:SetGridX(left)
  self:SetGridY(top)
end
function XInventoryItem:OnHoldDown(pt, button)
  if button == "ButtonA" then
    local unit = GetInventoryUnit()
    local item = self:GetContext()
    local dlg = GetMercInventoryDlg()
    local container = dlg and dlg:GetContext().container
    if unit and container and IsKindOf(item, "InventoryItem") then
      local ctrl = self:GetInventorySlotCtrl()
      if not ctrl and item == InventoryDragItem then
        ctrl = DragSource
      end
      local context = ctrl and ctrl:GetContext()
      if IsKindOf(context, "ItemContainer") or IsKindOf(context, "Unit") and context:IsDead() then
        ctrl:CancelDragging()
        MoveItem({
          item = item,
          src_container = context,
          src_slot = GetContainerInventorySlotName(context),
          dest_container = unit,
          dest_slot = "Inventory"
        })
      end
    end
  end
end
function XInventoryItem:IsDropTarget(drag_win, pt, source)
  local slot = self:GetInventorySlotCtrl()
  return self:GetVisible() and slot and slot:_IsDropTarget(drag_win, pt, source)
end
function XInventoryItem:OnDrop(drag_win, pt, drag_source_win)
end
function XInventoryItem:OnDropEnter(drag_win, pt, drag_source_win)
  local slot = self:GetInventorySlotCtrl()
  local context = slot:GetContext()
  local mouse_text = InventoryGetMoveIsInvalidReason(context, InventoryStartDragContext)
  local drag_item = InventoryDragItem
  HighlightDropSlot(self, true, pt, drag_win)
  local cur_item = self:GetContext()
  local slot_name = slot.slot_name
  if IsKindOf(context, "UnitData") and g_Combat then
    context = g_Units[context.session_id]
  end
  local is_reload = IsReload(drag_item, cur_item)
  local ap_cost, unit_ap, action_name = GetAPCostAndUnit(drag_item, InventoryStartDragContext, InventoryStartDragSlotName, context, slot_name, cur_item, is_reload)
  if not mouse_text then
    mouse_text = action_name or ""
    local is_combat = InventoryIsCombatMode()
    if not is_combat then
      drag_win:OnContextUpdate(drag_win:GetContext())
    end
    if is_combat and ap_cost and 0 < ap_cost then
      mouse_text = InventoryFormatAPMouseText(unit_ap, ap_cost, mouse_text)
    end
  end
  InventoryShowMouseText(true, mouse_text)
  HighlightAPCost(InventoryDragItem, true, self)
end
function XInventoryItem:OnDropLeave(drag_win, pt, source)
  if drag_win and drag_win.window_state ~= "destroying" then
    HighlightDropSlot(self, false, pt, drag_win)
    InventoryShowMouseText(false)
    HighlightAPCost(InventoryDragItem, false, self)
  end
end
function XInventoryItem:GetInventorySlotCtrl()
  return IsKindOf(self.parent, "XInventorySlot") and self.parent or false
end
DefineClass.XInventorySlot = {
  __parents = {
    "XDragAndDropControl"
  },
  properties = {
    {
      category = "General",
      id = "image_transparency",
      name = "Tile Transparency",
      editor = "number",
      default = 0
    },
    {
      category = "General",
      id = "rollover_image_transparency",
      name = "Rolllover Tile Transparency",
      editor = "number",
      default = false
    },
    {
      category = "General",
      id = "slot_name",
      name = "Slot Name",
      editor = "text",
      default = ""
    }
  },
  LayoutMethod = "Grid",
  ChildrenHandleMouse = true,
  IdNode = true,
  ClickToDrag = true,
  ClickToDrop = true,
  LayoutHSpacing = 0,
  LayoutVSpacing = 0
}
function XInventorySlot:SpawnTile(slot_name)
  return XInventoryTile:new({}, self)
end
function XInventorySlot:SetContext(context, update)
  if not context then
    return
  end
  XDragAndDropControl.SetContext(self, context, update)
end
function XInventorySlot:Setslot_name(slot_name)
  local context = self:GetContext()
  if not context then
    return
  end
  self.tiles = {}
  self.slot_name = slot_name
  local slot_data = context:GetSlotData(slot_name)
  local width, height, last_row_width = context:GetSlotDataDim(slot_name)
  for i = 1, width do
    self.tiles[i] = {}
    for j = 1, height do
      if j ~= height or i <= last_row_width then
        local tile = self:SpawnTile(slot_name, i, j)
        if tile then
          tile:SetContext(context)
          tile:SetGridX(i)
          tile:SetGridY(j)
          tile.idBackImage:SetTransparency(self.image_transparency)
          if slot_data.enabled == false then
            tile:SetEnabled(false)
          end
          self.tiles[i][j] = tile
        end
      end
    end
  end
  self.item_windows = {}
  self.rollover_windows = {}
  self:InitialSpawnItems()
end
function XInventorySlot:InitialSpawnItems()
  local context = self:GetContext()
  if not IsKindOf(context, "Inventory") then
    return
  end
  local slot_name = self.slot_name
  context:ForEachItemInSlot(slot_name, function(item, slotname, left, top)
    self:SpawnItemUI(item, left, top)
  end)
end
function XInventorySlot:OnContextUpdate(context)
  self:ClosePopup()
  for item_wnd, item in pairs(self.item_windows or empty_table) do
    if item_wnd.window_state ~= "destroying" then
      item_wnd:OnContextUpdate(item)
    end
  end
end
function XInventorySlot:GetInventorySlotCtrl()
  return self
end
function XInventorySlot:SpawnDropUI(width, height, left, top)
  local item_wnd = XTemplateSpawn("XContextWindow", self)
  item_wnd:SetHandleMouse(false)
  item_wnd:SetMinWidth(tile_size_rollover * width)
  item_wnd:SetMaxWidth(tile_size_rollover * width)
  item_wnd:SetMinHeight(tile_size_rollover * height)
  item_wnd:SetMaxHeight(tile_size_rollover * height)
  item_wnd:SetGridX(left)
  item_wnd:SetGridY(top)
  item_wnd:SetGridWidth(width)
  item_wnd:SetGridHeight(height)
  item_wnd:SetUseClipBox(false)
  item_wnd:SetIdNode(true)
  local item_pad = XTemplateSpawn("XImage", item_wnd)
  item_pad:SetImageFit("width")
  item_pad:SetId("idItemPad")
  item_pad:SetUseClipBox(false)
  item_pad:SetHandleMouse(false)
  item_pad:SetImage(width == 2 and "UI/Inventory/T_Backpack_Slot_Large.tga" or "UI/Inventory/T_Backpack_Slot_Small.tga")
  local rollover_image = XImage:new({
    MinWidth = tile_size_rollover,
    MaxWidth = tile_size_rollover,
    MinHeight = tile_size_rollover,
    MaxHeight = tile_size_rollover
  }, item_wnd)
  rollover_image:SetImage(width == 2 and "UI/Inventory/T_Backpack_Slot_Large_Hover.tga" or "UI/Inventory/T_Backpack_Slot_Small_Hover.tga")
  local center_text = XTemplateSpawn("AutoFitText", item_wnd)
  center_text:SetTranslate(true)
  center_text:SetTextStyle("DescriptionTextAPRed")
  center_text:SetId("idCenterText")
  center_text:SetUseClipBox(false)
  center_text:SetTextHAlign("center")
  center_text:SetTextVAlign("center")
  center_text:SetHAlign("center")
  center_text:SetVAlign("center")
  center_text:SetHandleMouse(false)
  return item_wnd
end
function XInventorySlot:SpawnRolloverUI(width, height, left, top)
  local image = self.tiles[left][top]
  image:SetVisible(false)
  if width == 2 then
    self.tiles[left + 1][top]:SetVisible(false)
  end
  local pos = point_pack(left, top, width)
  if not self.rollover_windows[pos] then
    local item_wnd = XTemplateSpawn("XContextWindow", self)
    item_wnd:SetHandleMouse(true)
    item_wnd:SetMinWidth(tile_size_rollover * width)
    item_wnd:SetMaxWidth(tile_size_rollover * width)
    item_wnd:SetMinHeight(tile_size_rollover * height)
    item_wnd:SetMaxHeight(tile_size_rollover * height)
    item_wnd:SetGridX(left)
    item_wnd:SetGridY(top)
    item_wnd:SetGridWidth(width)
    item_wnd:SetGridHeight(height)
    item_wnd:SetUseClipBox(false)
    item_wnd:SetIdNode(true)
    local item_pad = XTemplateSpawn("XImage", item_wnd)
    item_pad:SetMinWidth(tile_size * width)
    item_pad:SetMaxWidth(tile_size * width)
    item_pad:SetMinHeight(tile_size * height)
    item_pad:SetMaxHeight(tile_size * height)
    item_pad:SetId("idItemPad")
    item_pad:SetUseClipBox(false)
    item_pad:SetHandleMouse(false)
    item_pad:SetImage(width == 1 and "UI/Inventory/T_Backpack_Slot_Small_Hover.tga" or "UI/Inventory/T_Backpack_Slot_Large_Hover.tga")
    item_pad:SetImageColor(4291018156)
    item_pad:SetTransparency(self.image_transparency)
    function item_pad.OnSetRollover(this, rollover)
      XImage.OnSetRollover(this, rollover)
      if self.rollover_image_transparency then
        this:SetTransparency(rollover and self.rollover_image_transparency or self.image_transparency)
      end
    end
    local slot_img = equip_slot_images[self.slot_name]
    if equip_slot_images[self.slot_name] then
      local image = XImage:new({
        MinWidth = tile_size,
        MaxWidth = tile_size,
        MinHeight = tile_size,
        MaxHeight = tile_size,
        Id = "idBackImage",
        Image = "UI/Inventory/T_Backpack_Slot_Small.tga"
      }, item_wnd)
      image:SetImage(1 < width and "UI/Inventory/T_Backpack_Slot_Large.tga" or "UI/Inventory/T_Backpack_Slot_Small.tga")
      local imgslot = XImage:new({
        MinWidth = tile_size,
        MaxWidth = tile_size,
        MinHeight = tile_size,
        MaxHeight = tile_size,
        Dock = "box",
        Id = "idEqSlotImage"
      }, image)
      imgslot:SetImageFit(1 < width and "none" or "width")
      imgslot:SetImage(1 < width and equip_slot_images[self.slot_name .. " Big"] or slot_img)
    end
    local rollover_image = XImage:new({
      MinWidth = tile_size_rollover,
      MaxWidth = tile_size_rollover,
      MinHeight = tile_size_rollover,
      MaxHeight = tile_size_rollover,
      Id = "idRollover",
      Image = width == 1 and "UI/Inventory/T_Backpack_Slot_Small_Hover.tga" or "UI/Inventory/T_Backpack_Slot_Large_Hover.tga",
      ImageColor = 4291018156
    }, item_wnd)
    local center_text = XTemplateSpawn("AutoFitText", item_wnd)
    center_text:SetTranslate(true)
    center_text:SetTextStyle("DescriptionTextAPRed")
    center_text:SetId("idCenterText")
    center_text:SetText("")
    center_text:SetUseClipBox(false)
    center_text:SetTextHAlign("center")
    center_text:SetTextVAlign("center")
    center_text:SetHandleMouse(false)
    function item_wnd.IsDropTarget(this, drag_win, pt, source)
      return self:_IsDropTarget(drag_win, pt, source)
    end
    function item_wnd.OnDropEnter(this, drag_win, pt, drag_source_win)
      local mouse_text = InventoryGetMoveIsInvalidReason(self.context, InventoryStartDragContext)
      local drag_item = InventoryDragItem
      HighlightDropSlot(this, true, pt, drag_win)
      local slot = self
      local unit_ap, ap_cost, action_name
      local dest_container = slot:GetContext()
      if dest_container:CheckClass(drag_item, slot.slot_name) then
        local wnd, l, t = slot:FindTile(pt)
        if l and t then
          ap_cost, unit_ap, action_name = GetAPCostAndUnit(drag_item, InventoryStartDragContext, InventoryStartDragSlotName, dest_container, slot.slot_name)
        end
      end
      local is_combat = InventoryIsCombatMode()
      if not is_combat then
        drag_win:OnContextUpdate(drag_win:GetContext())
      end
      if not mouse_text then
        mouse_text = action_name or T(155594239482, "Move item")
        if is_combat and ap_cost and 0 < ap_cost then
          mouse_text = InventoryFormatAPMouseText(unit_ap, ap_cost, mouse_text)
        end
      end
      InventoryShowMouseText(true, mouse_text)
      HighlightAPCost(InventoryDragItem, true, this)
    end
    function item_wnd.OnDropLeave(this, drag_win, pt, source)
      if drag_win and drag_win.window_state ~= "destroying" then
        HighlightDropSlot(this, false, pt, drag_win)
        InventoryShowMouseText(false)
        HighlightAPCost(InventoryDragItem, false, this)
      end
    end
    function item_wnd.GetInventorySlotCtrl(this)
      return this.parent or self
    end
    self.rollover_windows[pos] = item_wnd
  end
end
function XInventorySlot:SpawnItemUI(item, left, top)
  local image = self.tiles[left][top]
  if not image then
    return
  end
  image:SetVisible(false)
  if item.LargeItem then
    self.tiles[left + 1][top]:SetVisible(false)
  end
  local item_wnd = XTemplateSpawn("XInventoryItem", self, item)
  item_wnd.idItemPad:SetTransparency(self.image_transparency)
  item_wnd:SetPosition(left, top)
  self.item_windows[item_wnd] = item
end
function XInventorySlot:ShowTiles(show, size, left, top)
  if not left then
    return
  end
  if type(left) ~= "number" then
    local wnd
    wnd, left, top = self:FindTile(left)
  end
  if left then
    local image = self.tiles[left][top]
    if not image then
      return
    end
    image:SetVisible(show)
    if size == 2 and self.tiles[left + 1] then
      self.tiles[left + 1][top]:SetVisible(show)
    end
  end
end
function XInventorySlot:FindTile(pt)
  local context = self:GetContext()
  local width, height, last_row_width = context:GetSlotDataDim(self.slot_name)
  for i = 1, width do
    for j = 1, height do
      if (j ~= height or i <= last_row_width) and j <= #self.tiles[i] then
        local wnd = self.tiles[i][j]
        if wnd:PointInWindow(pt) then
          return wnd, i, j
        end
      end
    end
  end
end
function XInventorySlot:FindItemWnd(pt)
  if IsKindOf(pt, "InventoryItem") then
    for wnd, item in pairs(self.item_windows) do
      if pt == item then
        return wnd, item
      end
    end
  else
    for wnd, item in pairs(self.item_windows) do
      if wnd:MouseInWindow(pt) then
        return wnd, item
      end
    end
  end
end
function OnMsg.InventoryChange(obj)
  local dlg = GetDialog("FullscreenGameDialogs")
  if dlg then
    dlg:ActionsUpdated()
  end
end
function InventoryUpdate(unit)
  local dlg = GetMercInventoryDlg()
  if dlg then
    local context = dlg:GetContext() or {}
    local is_unit_data = IsKindOf(context.unit, "UnitData")
    if is_unit_data and unit and context.unit.session_id == unit.session_id then
      context.unit = gv_UnitData[unit.session_id]
    else
      context.unit = unit
    end
    dlg:SetContext(context, "update")
    dlg:OnContextUpdate(context)
  end
  InventoryUIRespawn()
end
function OnMsg.CombatActionEnd(unit)
  if unit:CanBeControlled() then
    InventoryUpdate(unit)
  end
  if gv_SatelliteView then
    unit:SyncWithSession("map")
  end
  ObjModified(unit)
end
function OnMsg.InventoryUnload(src, dest)
  InventoryUIRespawn()
end
function OnMsg.InventoryChangeItemUI(obj)
  local dlg = GetMercInventoryDlg()
  if dlg then
    local context = dlg:GetContext() or {}
    if obj.session_id == context.unit.session_id and obj:CanBeControlled() then
      InventoryUpdate(obj)
    else
      InventoryUIRespawn()
    end
  else
    InventoryUIRespawn()
  end
end
function XInventorySlot:DropItem(item)
  if not item then
    return
  end
  local dlg = GetMercInventoryDlg()
  local dest = dlg and dlg:GetContext()
  dest = dest and dest.container
  local args = {
    item = item,
    src_container = self.context,
    src_slot = self.slot_name
  }
  if dest and IsKindOf(dest, "SectorStash") then
    args.dest_container = dest
    args.dest_slot = "Inventory"
  else
    args.dest_container = "drop"
  end
  if not g_GossipItemsMoveFromPlayerToContainer[item.id] then
    g_GossipItemsMoveFromPlayerToContainer[item.id] = true
  end
  MoveItem(args)
  local unit = GetInventoryUnit(dlg)
  local surface_fx_type = false
  if IsKindOf(unit, "Unit") then
    local pos = SnapToPassSlab(unit) or unit:GetPos()
    surface_fx_type = GetObjMaterial(pos)
  end
  PlayFX("DropItem", "start", unit, surface_fx_type, item.class)
end
function _ENV:InventoryGetStartSlotControl()
  local slot_ctrl = StartDragSource or self
  local context = slot_ctrl and slot_ctrl:GetContext()
  if context ~= InventoryStartDragContext then
    local dlg = GetMercInventoryDlg()
    slot_ctrl = dlg:GetSlotByName(InventoryStartDragSlotName, InventoryStartDragContext)
  end
  return slot_ctrl
end
function XInventorySlot:CancelDragging()
  local drag_win = self.drag_win
  if not drag_win then
    return
  end
  self:ClearDragState(drag_win)
  InventoryUIRespawn()
  return true
end
function XInventorySlot:OnCloseDialog()
  self:CancelDragging()
  self:ClosePopup()
end
function XInventorySlot:OnMouseButtonUp(pt, button)
  local wnd_found, item = self:FindItemWnd(pt)
  if item and item.locked then
    wnd_found.idimgLocked:SetImageColor(GameColors.D)
  end
  return XDragAndDropControl.OnMouseButtonUp(self, pt, button)
end
function XInventorySlot:OnMouseButtonDown(pt, button)
  if button == "M" then
    return "break"
  end
  if not self:GetEnabled() then
    return "break"
  end
  local dlgContext = GetDialogContext(self)
  if dlgContext and InventoryDisabled(dlgContext) then
    PlayFX("IactDisabled", "start", InventoryDragItem)
    return "break"
  end
  local wnd_found, item = self:FindItemWnd(pt)
  if InventoryIsCompareMode() then
    return "break"
  end
  if button == "L" then
    if not wnd_found then
      local wnd, l, t = self:FindTile(pt)
      if wnd then
        PlayFX("InventoryEmptyTileClick", "start")
      end
    end
    local unit = GetInventoryUnit()
    if item and item.locked then
      wnd_found.idimgLocked:SetImageColor(GameColors.I)
      PlayVoiceResponse(unit, "LockedItemMove")
      PlayFX("IactDisabled", "start", item)
      return "break"
    end
    if terminal.IsKeyPressed(const.vkShift) == true and wnd_found then
      if not IsKindOf(item, "InventoryStack") or item.Amount < 2 then
        return "break"
      end
      local container = self.context
      if IsKindOfClasses(container, "SquadBag", "SectorStash", "ItemDropContainer") then
        return "break"
      end
      local slot = GetContainerInventorySlotName(container)
      local freeSpace = container:FindEmptyPosition(slot, item)
      if not freeSpace then
        return "break"
      end
      OpenDialog("SplitStackItem", false, {
        context = container,
        item = item,
        slot_wnd = self
      })
      return "break"
    end
    WasDraggingLastLMBClick = not not InventoryDragItem
  end
  if button == "R" then
    if InventoryDragItem then
      self:CancelDragging()
      return "break"
    else
      local dlg = GetDialog(self)
      if wnd_found then
        if dlg.item_wnd == wnd_found then
          self:ClosePopup()
        else
          self:OpenPopup(wnd_found, item, dlg)
          local context = self:GetContext()
          if self.slot_name == "Inevnetory" and IsKindOfClasses(context, "Unit", "UnitData") then
            InventoryUpdate(context)
          end
        end
        return "break"
      end
    end
  end
  return XDragAndDropControl.OnMouseButtonDown(self, pt, button)
end
function XInventorySlot:OpenPopup(wnd_found, item, dlg)
  local context = self:GetContext()
  self:ClosePopup()
  local dlg = dlg or GetDialog(self)
  local unit = IsKindOfClasses(context, "Unit", "UnitData") and not context:IsDead() and context or GetInventoryUnit()
  if InventoryIsNotControlled(unit) then
    return
  end
  if InventoryIsCompareMode(dlg) then
    dlg:CloseCompare()
    dlg.compare_mode = false
    dlg:ActionsUpdated()
  end
  wnd_found.RolloverTemplate = ""
  local popup = XTemplateSpawn("InventoryContextMenu", terminal.desktop, {
    item = item,
    unit = unit,
    container = IsKindOfClasses(context, "ItemContainer", "SectorStash") and context,
    context = context,
    wnd = wnd_found,
    slot_wnd = self
  })
  dlg.spawned_popup = popup
  dlg.item_wnd = wnd_found
  popup:SetAnchor(wnd_found.box)
  function popup.OnDelete(this)
    dlg.spawned_popup = false
    dlg.item_wnd.RolloverTemplate = "RolloverInventory"
    dlg.item_wnd = false
  end
  popup:Open()
end
function XInventorySlot:ClosePopup()
  local dlg = GetDialog(self)
  InventoryClosePopup(dlg)
end
function InventoryClosePopup(dlg)
  local popup = dlg and rawget(dlg, "spawned_popup")
  if popup and popup.window_state ~= "destroying" then
    popup:Close()
    if dlg.item_wnd then
      dlg.item_wnd.RolloverTemplate = "RolloverInventory"
      dlg.item_wnd = false
    end
    return true
  end
end
function XInventorySlot:ClearDragState(drag_win)
  drag_win = drag_win or self.drag_win
  if drag_win then
    self:StopDrag()
    ClearDragGlobals()
    self.item_windows[drag_win] = nil
    if drag_win.window_state ~= "destroying" then
      drag_win:delete()
    end
    self.drag_win = false
  end
end
function XInventorySlot:DragDrop_MoveItem(pt, target, check_only)
  if not InventoryDragItem then
    return "no item being dragged"
  end
  if not (target and InventoryIsValidTargetForUnit(self.context) and InventoryIsValidTargetForUnit(InventoryStartDragContext)) or not InventoryIsValidGiveDistance(self.context, InventoryStartDragContext) then
    return "not valid target"
  end
  local item = InventoryDragItem
  local dest_slot = target.slot_name
  local _, pt = self:GetNearestTileInDropSlot(pt)
  local _, dx, dy = target:FindTile(pt)
  if not dx then
    return "no target tile"
  end
  local ssx, ssy, sdx = point_unpack(InventoryDragItemPos)
  if item.LargeItem then
    dx = dx - sdx
    if IsEquipSlot(dest_slot) then
      dx = 1
    end
  end
  local dest_container = target:GetContext()
  local src_container = InventoryStartDragContext
  local under_item = dest_container:GetItemInSlot(dest_slot, nil, dx, dy)
  local src_slot_name = InventoryStartDragSlotName
  local use_alternative_swap_pos = IsEquipSlot(dest_slot) and not IsEquipSlot(src_slot_name) and not not under_item
  local args = {
    item = item,
    src_container = src_container,
    src_slot = src_slot_name,
    dest_container = dest_container,
    dest_slot = dest_slot,
    dest_x = dx,
    dest_y = dy,
    check_only = check_only,
    exec_locally = false,
    alternative_swap_pos = use_alternative_swap_pos
  }
  local r1, r2, sync_unit = MoveItem(args)
  if r1 or not check_only then
    PlayFXOnMoveItemResult(r1, item, dest_slot, sync_unit)
  end
  if not r1 and not check_only and (not r2 or r2 ~= "no change") then
    self:Gossip(item, src_container, target, ssx, ssy, dx, dy)
  end
  return r1, r2
end
function XInventorySlot:Gossip(item, src_container, target, src_x, src_y, dest_x, dest_y)
  local context = target:GetContext()
  local item_id = item.id
  if (context == "drop" or IsKindOfClasses(context, "SectorStash", "ItemDropContainer", "ItemContainer", "ContainerMarker") or IsKindOf(context, "Unit") and context:IsDead()) and IsKindOfClasses(src_container, "Unit", "UnitData", "SquadBag") and not g_GossipItemsMoveFromPlayerToContainer[item_id] then
    g_GossipItemsMoveFromPlayerToContainer[item_id] = true
  end
  if IsKindOfClasses(context, "Unit", "UnitData", "SquadBag") and (IsKindOfClasses(src_container, "SectorStash", "ItemDropContainer", "ItemContainer", "ContainerMarker") or IsKindOf(src_container, "Unit") and src_container:IsDead()) and not g_GossipItemsTakenByPlayer[item_id] and g_GossipItemsSeenByPlayer[item_id] and not g_GossipItemsMoveFromPlayerToContainer[item_id] then
    NetGossip("Loot", "TakeByPlayer", item.class, rawget(item, "Amount") or 1, GetCurrentPlaytime(), Game and Game.CampaignTime)
    g_GossipItemsTakenByPlayer[item_id] = true
  end
  local ammo = IsKindOfClasses(item, "Ammo", "Ordnance")
  if ammo then
    return
  end
  local src = IsKindOfClasses(src_container, "Unit", "UnitData") and src_container.session_id or src_container.class
  local dest = IsKindOfClasses(context, "Unit", "UnitData") and context.session_id or context.class
  local src_part = IsKindOf(self, "EquipInventorySlot") and "Body" or "Items"
  local dest_part = IsKindOf(target, "EquipInventorySlot") and "Body" or "Items"
  if not g_GossipItemsEquippedByPlayer[item_id] and dest_part == "Body" and src_part == "Items" then
    NetGossip("EquipItem", item.class, src, src_part, src_x, src_y, dest, dest_part, dest_x, dest_y, GetCurrentPlaytime(), Game and Game.CampaignTime)
    g_GossipItemsEquippedByPlayer[item_id] = true
  end
end
function GetInventoryItemDragDropFXActor(item)
  if IsKindOf(item, "Ammo") then
    return item.Caliber
  end
  if IsKindOf(item, "Armor") then
    if item.Slot == "Head" then
      return "ArmorHelmet"
    elseif item.PenetrationClass <= 2 then
      return "ArmorLight"
    else
      return "ArmorHeavy"
    end
  end
  if InventoryItemDefs[item.class].group == "Magazines" then
    return "Magazines"
  end
  return item.class
end
function PlayFXOnMoveItemResult(result, item, dest_slot, unit)
  item = item or InventoryDragItem
  if not result then
    if dest_slot and IsEquipSlot(dest_slot) and IsKindOfClasses(item, "Firearm", "HeavyWeapon") then
      PlayFX("WeaponEquip", "start", item.class, item.object_class)
    else
      PlayFX("InventoryItemDrop", "start", GetInventoryItemDragDropFXActor(item))
    end
    if dest_slot and IsEquipSlot(dest_slot) and item:IsCondition("Poor") then
      local unit = unit or GetInventoryUnit()
      PlayVoiceResponse(unit.session_id, "ItemInPoorConditionEquipped")
    end
  elseif result == "Unit doesn't have ap to execute action" then
    if IsEquipSlot(dest_slot) then
      CombatLog("important", T({
        536432871775,
        "<DisplayName> doesn't have enough AP to pick and equip the item",
        unit or GetInventoryUnit()
      }))
      PlayFX("EquipFail", "start", item)
    else
      CombatLog("important", T({
        925174211499,
        "<DisplayName> doesn't have enough AP",
        unit or GetInventoryUnit()
      }))
    end
  elseif result == "not valid target" or result == "no item being dragged" then
    PlayFX("IactDisabled", "start", item)
  elseif result == "item underneath is locked" or result == "item is locked" then
    PlayFX("IactDisabled", "start", item)
  elseif result == "Unit doesn't have ap to execute action" then
    PlayFX("IactDisabled", "start", item)
  elseif result == "too many items underneath" or result == "not valid target" then
    PlayFX("IactDisabled", "start", item)
  elseif result == "invalid reload target" then
    PlayFX("IactDisabled", "start", item)
  elseif result == "Unit doesn't have ap to reload" then
    CombatLog("important", T({
      984048298727,
      "<DisplayName> doesn't have enough AP to reload",
      unit or GetInventoryUnit()
    }))
    PlayFX("ReloadFail", "start", item)
  elseif result == "Could not swap items, source container does not accept item at dest" or result == "Could not swap items, dest container does not accept source item" or result == "Could not swap items, item at dest does not fit in source container at the specified position" or result == "Could not swap items, item does not fit in dest container at the specified position" or result == "Could not swap items, items overlap after swap" then
    PlayFX("IactDisabled", "start", item)
  elseif result == "Can't add item to container, wrong class" then
    PlayFX("IactDisabled", "start", item)
  elseif result then
    PlayFX("IactDisabled", "start", item)
  end
end
function XInventorySlot:GetDragTarget(pt)
  local target = self.drag_target
  if not target then
    target, pt = self:GetNearestTileInDropSlot(pt)
    if target then
      local is_valid_target = target:IsDropTarget(self.drag_win, pt, self)
      target = is_valid_target and target or false
    end
  end
  if target and target:HasMember("GetInventorySlotCtrl") then
    target = target:GetInventorySlotCtrl()
  end
  return target, pt
end
function XInventorySlot:InternalDragStop(pt)
  local drag_win = self.drag_win
  self:UpdateDrag(drag_win, pt)
  local result = "not valid target"
  local target = self:GetDragTarget(pt)
  if target then
    result = target:OnDrop(drag_win, pt, self)
  else
    PlayFX("DropItemFail", "start")
  end
  if not result then
    self:OnDragDrop(target, drag_win, result, pt)
  end
end
function XInventorySlot:CanDropAt(pt)
  if not pt then
    return true
  end
  local unit = self:GetContext()
  if not unit then
    return
  end
  local stackable = IsKindOf(InventoryDragItem, "InventoryStack")
  local dest_slot = self.slot_name
  local _, dx, dy = self:FindTile(pt)
  if not dx then
    return true
  end
  local item_at_dest = dx and unit:GetItemInSlot(dest_slot, nil, dx, dy)
  stackable = stackable and item_at_dest and item_at_dest.class == InventoryDragItem.class
  if IsReload(InventoryDragItem, item_at_dest) or IsMedicineRefill(InventoryDragItem, item_at_dest) or InventoryIsCombineTarget(InventoryDragItem, item_at_dest) then
    return true
  end
  if not unit:CheckClass(InventoryDragItem, dest_slot) then
    return false, "different class"
  end
  local is_equip_slot = IsEquipSlot(dest_slot)
  if not is_equip_slot and item_at_dest and item_at_dest ~= InventoryDragItem and not stackable and InventoryDragItem.LargeItem ~= item_at_dest.LargeItem then
    return false, "cannot swap"
  end
  if not is_equip_slot and InventoryDragItem.LargeItem then
    local ssx, ssy, sdx = point_unpack(InventoryDragItemPos)
    if 0 <= sdx then
      dx = dx - sdx
    end
    local otherItem = unit:GetItemInSlot(dest_slot, nil, dx, dy)
    if otherItem and (otherItem.LargeItem ~= InventoryDragItem.LargeItem or item_at_dest and item_at_dest ~= otherItem) then
      return false, "cannot swap"
    end
  end
  return true
end
function XInventorySlot:OnDrop(drag_win, pt, drag_source_win)
  if not self:CanDropAt(pt) then
    PlayFX("DropItemFail", "start")
    return "not valid target"
  end
  return self:DragDrop_MoveItem(pt, self, "check_only")
end
function XInventorySlot:OnDragDrop(target, drag_win, drop_res, pt)
  local result, result2 = self:DragDrop_MoveItem(pt, target)
  local sync_err = result == "NetStartCombatAction refused to start"
  self:ClearDragState(drag_win)
  if sync_err or result2 == "no change" then
    InventoryUIRespawn()
  end
end
function XInventorySlot:GetNearestTileInDropSlot(pt)
  local target = self.desktop.modal_window:GetMouseTarget(pt)
  if IsKindOf(target, "XInventoryTile") then
    return target, pt
  elseif IsKindOf(target, "XInventorySlot") then
    return target:FindNearestTile(pt)
  else
    return false, pt
  end
end
function XInventorySlot:FindNearestTile(pt)
  if not self.tiles or #self.tiles < 1 then
    return
  end
  local closestTile = false
  local newPt = pt
  local minDistance = 9999
  for x, column in ipairs(self.tiles) do
    for y, tile in ipairs(column) do
      local tileCenter = tile.box:Center()
      local dist = pt:Dist2D(tileCenter)
      if minDistance > dist then
        minDistance = dist
        closestTile = tile
        newPt = tileCenter
      end
    end
  end
  return closestTile, newPt
end
function XInventorySlot:OnDragStart(pt, button)
  local context = self:GetContext()
  local unit = IsKindOf(context, "Unit") and context or not IsKindOf(context, "SquadBag") and g_Units[context.session_id]
  if unit and IsMerc(unit) and (not (unit:IsLocalPlayerControlled() or unit:IsDead()) or not InventoryIsValidTargetForUnit(unit)) then
    return
  end
  self:ClosePopup()
  local wnd_found, item = self:FindItemWnd(pt)
  if wnd_found and item then
    local left, top = self.context:GetItemPosInSlot(self.slot_name, item)
    if not left then
      self:StopDrag()
      return
    end
    wnd_found.idItemPad:SetHandleMouse(false)
    wnd_found.idItemPad:SetVisible(false)
    wnd_found.idText:SetVisible(false)
    wnd_found.idTopRightText:SetVisible(false)
    local img_mod = rawget(wnd_found.idItemImg, "idItemModImg")
    if img_mod then
      img_mod:SetVisible(false)
    end
    wnd_found.idDropshadow:SetVisible(false)
    wnd_found:SetHandleMouse(false)
    wnd_found.idRollover:SetVisible(false)
    self:ShowTiles(true, item:GetUIWidth(), left, top)
    InventoryDragItem = item
    HighlightEquipSlots(InventoryDragItem, true)
    HighlightWeaponsForAmmo(InventoryDragItem, true)
    local w, lleft, ltop = self:FindTile(pt)
    InventoryDragItemPos = point_pack(left, top, left < lleft and 1 or 0)
    InventoryDragItemPt = pt
    StartDragSource = self
    InventoryStartDragSlotName = self.slot_name
    InventoryStartDragContext = self:GetContext()
    PlayFX("InventoryItemDrag", "start", GetInventoryItemDragDropFXActor(item))
  end
  return wnd_found
end
function XInventorySlot:OnDragNewTarget(target, drag_win, drop_res, pt)
end
function InventoryDisabled(inventoryContext)
  local unit = inventoryContext.unit
  if unit and not inventoryContext.autoResolve then
    if IsKindOf(unit, "UnitData") then
      return unit:InventoryDisabled()
    end
  else
    return false, T("")
  end
end
function XInventorySlot:OnDragEnded(drag_win, last_target, drag_res)
  local dlg = GetMercInventoryDlg()
  if InventoryIsCompareMode() then
    dlg:CloseCompare()
    dlg.compare_mode = false
    dlg:ActionsUpdated()
    XInventoryItem.RolloverTemplate = "RolloverInventory"
  end
  if drag_win and drag_win.window_state ~= "destroying" then
    drag_win:OnContextUpdate(drag_win:GetContext())
  end
  local context = self:GetContext()
  self:OnContextUpdate(context)
end
function XInventorySlot:_IsDropTarget(drag_win, pt, drag_source_win)
  if not self:GetEnabled() then
    HighlightDropSlot(false, false, false, drag_win)
    return false
  end
  local context = self:GetContext()
  if InventoryIsNotControlled(context) then
    HighlightDropSlot(false, false, false, drag_win)
    return false
  end
  local slot_name = self.slot_name
  local drag_item = InventoryDragItem
  local drag_size = drag_item:GetUIWidth()
  local res, reason = self:CanDropAt(pt)
  if not res then
    HighlightDropSlot(false, false, false, drag_win)
    return false
  end
  HighlightDropSlot(self, true, pt, drag_win)
  local ctrl, itm = self:FindItemWnd(pt)
  ctrl = ctrl or self:FindTile(pt)
  if ctrl and itm ~= InventoryDragItem then
    HighlightAPCost(InventoryDragItem, true, ctrl)
  end
  return true
end
function XInventorySlot:OnTargetDragWnd(drag_win, pt)
  local left, top = point_unpack(InventoryDragItemPos)
  return self.tiles[left][top]
end
function SplitInventoryItem(item, splitAmount, unit, xInventorySlot)
  local container = unit
  local slot = GetContainerInventorySlotName(container)
  local result = MoveItem({
    item = item,
    src_container = container,
    src_slot = xInventorySlot.slot_name,
    dest_container = container,
    dest_slot = slot,
    amount = splitAmount
  })
  if result then
    PlayFXOnMoveItemResult(result, item)
  else
    PlayFX("SplitItem", "start", item.class, item.object_class)
  end
end
function SetInventoryHighlights(item, bShow)
  HighlightEquipSlots(item, bShow)
  HighlightWeaponsForAmmo(item, bShow)
  HighlightItemStats(item, bShow)
  HighlightWoundedCharacterPortraits(item, bShow)
  HighlightAmmoForWeapons(item, bShow)
  HighlightMedsForMedicine(item, bShow)
  HighlightMedicinesForMeds(item, bShow)
end
function HighlihgtRollover(width, wnd, bShow)
  local rollover_image = wnd.idRollover
  local item = wnd:GetContext()
  local large
  if item then
    large = item.LargeItem
  else
    large = width and 1 < width
  end
  if bShow then
    rollover_image:SetImage(large and "UI/Inventory/T_Backpack_Slot_Large_Hover_2.tga" or "UI/Inventory/T_Backpack_Slot_Small_Hover_2.tga")
    rollover_image:SetImageColor(RGB(255, 255, 255))
  else
    rollover_image:SetImage(large and "UI/Inventory/T_Backpack_Slot_Large_Hover.tga" or "UI/Inventory/T_Backpack_Slot_Small_Hover.tga")
    rollover_image:SetImageColor(4291018156)
  end
end
local dropWnd = false
function HighlightAPCost(item, bShow, wnd)
end
function HighlightCompareSlots(item, other, bShow)
  local dlg = GetMercInventoryDlg()
  if not dlg then
    return
  end
  local compare_mode_on = InventoryIsCompareMode(dlg)
  local compare_mode_slot = compare_mode_on and dlg.compare_mode_weaponslot == 1 and "Handheld A" or compare_mode_on and "Handheld B" or false
  local context = GetInventoryUnit()
  for _, slot_data in ipairs(context.inventory_slots) do
    local slot_name = slot_data.slot_name
    if IsEquipSlot(slot_name) and context:CheckClass(item, slot_name) and (not compare_mode_slot or compare_mode_slot == slot_name) then
      local target = dlg:GetSlotByName(slot_name)
      for wnd, witem in pairs(target.item_windows or empty_table) do
        if witem ~= item and table.find(other, witem) then
          wnd:OnSetRollover(bShow)
        end
      end
    end
  end
end
function HighlightEquipSlots(item, bShow)
  local dlg = GetMercInventoryDlg()
  if not dlg then
    return
  end
  local compare_mode_on = item:IsWeapon() and InventoryIsCompareMode(dlg)
  local compare_mode_slot = compare_mode_on and dlg.compare_mode_weaponslot == 1 and "Handheld A" or compare_mode_on and "Handheld B" or false
  local context = GetInventoryUnit()
  local width = item:GetUIWidth()
  local height = 1
  local p1 = point_pack(point(1, 1))
  local p2 = point_pack(point(2, 1))
  for _, slot_data in ipairs(context.inventory_slots) do
    local slot_name = slot_data.slot_name
    if IsEquipSlot(slot_name) and context:CheckClass(item, slot_name) and (not compare_mode_slot or compare_mode_slot == slot_name) then
      local target = dlg:GetSlotByName(slot_name)
      local valid_idx = {
        target:CanEquip(item, p1) or false,
        target:CanEquip(item, p2) or false
      }
      local count = context:CountItemsInSlot(slot_name)
      if width == 1 or count <= 1 then
        if count == 0 then
          if width == 1 then
            if bShow then
              target:SpawnRolloverUI(width, height, 1, 1)
              if target.tiles[2] then
                target:SpawnRolloverUI(width, height, 2, 1)
              end
              for pos, wnd in pairs(target.rollover_windows or empty_table) do
                wnd:OnSetRollover(bShow)
                HighlihgtRollover(width, wnd, bShow)
              end
            else
              for pos, wnd in pairs(target.rollover_windows or empty_table) do
                local l, t, w = point_unpack(pos)
                target.tiles[l][t]:SetVisible(true)
                if 1 < w then
                  target.tiles[l + 1][t]:SetVisible(true)
                end
                wnd:delete()
              end
              target.rollover_windows = {}
            end
          elseif 1 < width then
            if bShow then
              target:SpawnRolloverUI(width, height, 1, 1)
              for pos, wnd in pairs(target.rollover_windows or empty_table) do
                wnd:OnSetRollover(bShow)
                HighlihgtRollover(width, wnd, bShow)
              end
            else
              for pos, wnd in pairs(target.rollover_windows or empty_table) do
                local l, t, w = point_unpack(pos)
                target.tiles[l][t]:SetVisible(true)
                if 1 < w then
                  target.tiles[l + 1][t]:SetVisible(true)
                end
                wnd:delete()
              end
              target.rollover_windows = {}
            end
          end
        elseif count == 1 and width == 1 then
          for wnd, witem in pairs(target.item_windows or empty_table) do
            if witem ~= item then
              wnd:OnSetRollover(bShow)
              HighlihgtRollover(width, wnd, bShow)
            end
          end
          if bShow then
            for i = 1, context:GetMaxTilesInSlot(slot_name) do
              if target.tiles[i][1]:GetVisible() then
                if valid_idx[i] then
                  target:SpawnRolloverUI(width, height, i, 1)
                else
                  local ctrl = target.tiles[i][1]
                  local ctrl_eq = ctrl.idEqSlotImage
                  ctrl_eq:SetImage("UI/Inventory/cross")
                  ctrl_eq:SetImageFit("none")
                end
              end
            end
            for pos, wnd in pairs(target.rollover_windows or empty_table) do
              wnd:OnSetRollover(bShow)
              HighlihgtRollover(width, wnd, bShow)
            end
          else
            for pos, wnd in pairs(target.rollover_windows or empty_table) do
              local l, t, w = point_unpack(pos)
              target.tiles[l][t]:SetVisible(true)
              wnd:delete()
            end
            target.rollover_windows = {}
            for i = 1, context:GetMaxTilesInSlot(slot_name) do
              if not valid_idx[i] then
                local ctrl = target.tiles[i][1]
                local ctrl_eq = ctrl.idEqSlotImage
                ctrl_eq:SetImage(equip_slot_images[slot_name])
                ctrl_eq:SetImageFit("width")
              end
            end
          end
        else
          for wnd, witem in pairs(target.item_windows or empty_table) do
            if valid_idx[wnd.GridX] and witem ~= item then
              wnd:OnSetRollover(bShow)
              HighlihgtRollover(width, wnd, bShow)
            end
          end
        end
      end
    end
  end
end
function HighlightAmmoForWeapons(weapon, bShow)
  local dlg = GetMercInventoryDlg()
  if not dlg or not weapon then
    return
  end
  if dlg.compare_mode then
    bShow = false
  end
  local is_weapon = IsKindOf(weapon, "Firearm")
  local heavy_weapon = IsKindOf(weapon, "HeavyWeapon")
  if not is_weapon and not heavy_weapon then
    return
  end
  local ammo_class = heavy_weapon and "Ordnance" or "Ammo"
  local all_slots = dlg:GetSlotsArray()
  for slot_wnd in pairs(all_slots) do
    local slot_name = slot_wnd.slot_name
    local target = slot_wnd:GetContext()
    local found = false
    for wnd, item in pairs(slot_wnd.item_windows or empty_table) do
      if IsKindOf(item, ammo_class) and weapon.Caliber == item.Caliber then
        wnd:OnSetRollover(bShow)
        HighlihgtRollover(item:GetUIWidth(), wnd, bShow)
        found = true
      end
    end
  end
end
function HighlightMedsForMedicine(medicine, bShow)
  local dlg = GetMercInventoryDlg()
  if not dlg or not medicine then
    return
  end
  if dlg.compare_mode then
    bShow = false
  end
  if not IsKindOf(medicine, "Medicine") then
    return
  end
  local all_slots = dlg:GetSlotsArray()
  for slot_wnd in pairs(all_slots) do
    local slot_name = slot_wnd.slot_name
    local target = slot_wnd:GetContext()
    local found = false
    for wnd, item in pairs(slot_wnd.item_windows or empty_table) do
      if IsKindOf(item, "Meds") then
        wnd:OnSetRollover(bShow)
        HighlihgtRollover(item:GetUIWidth(), wnd, bShow)
        found = true
      end
    end
  end
end
function HighlightItemStats(item, bShow)
  local dlg = GetMercInventoryDlg()
  if not dlg or not item then
    return
  end
  if dlg.compare_mode then
    bShow = false
  end
  local isWeapon = item:IsWeapon()
  local has_stat = not not item.UnitStat
  local left = dlg:ResolveId("idPartyContainer")
  local squad_list = left.idParty and left.idParty.idContainer or empty_table
  for _, button in ipairs(squad_list) do
    local member = button:GetContext()
    if member then
      if isWeapon then
        button:SetHighlighted(bShow and item.base_skill)
      elseif has_stat then
        button:SetHighlighted(bShow and item.UnitStat)
      end
    end
  end
end
function HighlightWeaponsForAmmo(ammo, bShow)
  local dlg = GetMercInventoryDlg()
  if not dlg or not ammo then
    return
  end
  if dlg.compare_mode then
    bShow = false
  end
  local h_members = {}
  local is_bag_item = ammo:IsKindOf("SquadBagItem")
  if is_bag_item then
    local bag = gv_SquadBag
    h_members[bag] = true
  end
  local is_ammo = IsKindOf(ammo, "Ammo")
  local is_ordnance = IsKindOf(ammo, "Ordnance")
  if not is_ammo and not is_ordnance and not is_bag_item then
    return
  end
  local weapon_class = is_ammo and "Firearm" or "HeavyWeapon"
  local left = dlg:ResolveId("idPartyContainer")
  local squad_list = left.idParty and left.idParty.idContainer or empty_table
  for _, button in ipairs(squad_list) do
    local member = button:GetContext()
    if (is_ammo or is_ordnance) and member then
      for _, slot_data in ipairs(member.inventory_slots) do
        local slot_name = slot_data.slot_name
        if IsEquipSlot(slot_name) then
          member:ForEachItemInSlot(slot_name, weapon_class, function(witem, slot, l, t)
            if witem.Caliber == ammo.Caliber then
              button:SetHighlighted(bShow)
              h_members[member] = true
              return "break"
            end
          end)
        end
      end
    end
    local all_slots = dlg:GetSlotsArray()
    for slot_wnd in pairs(all_slots) do
      local slot_name = slot_wnd.slot_name
      local target = slot_wnd:GetContext()
      local found = false
      for wnd, witem in pairs(slot_wnd.item_windows or empty_table) do
        if (is_ammo or is_ordnance) and IsKindOf(witem, weapon_class) and ammo.Caliber == witem.Caliber then
          wnd:OnSetRollover(bShow)
          HighlihgtRollover(witem:GetUIWidth(), wnd, bShow)
          found = true
        end
      end
      if not IsKindOf(target, "SquadBag") and slot_wnd and not IsEquipSlot(slot_name) and IsKindOf(target, "Unit") and not target:IsDead() and (not (not found and bShow) or h_members[target]) then
        local name = slot_wnd.parent.idName
        name:SetHightlighted(bShow)
      end
    end
    if not bShow then
      button:SetHighlighted(bShow)
    end
  end
end
function HighlightMedicinesForMeds(meds, bShow)
  local dlg = GetMercInventoryDlg()
  if not (dlg and meds) or not IsKindOf(meds, "Meds") then
    return
  end
  if dlg.compare_mode then
    bShow = false
  end
  local h_members = {}
  local bag = gv_SquadBag
  h_members[bag] = true
  local left = dlg:ResolveId("idPartyContainer")
  local squad_list = left.idParty and left.idParty.idContainer or empty_table
  for _, button in ipairs(squad_list) do
    local member = button:GetContext()
    if member then
      member:ForEachItemInSlot(GetContainerInventorySlotName(member), "Medicine", function(witem, slot, l, t)
        if witem.Condition < witem:GetMaxCondition() then
          button:SetHighlighted(bShow)
          h_members[member] = true
          return "break"
        end
      end)
    end
    local all_slots = dlg:GetSlotsArray()
    for slot_wnd in pairs(all_slots) do
      local slot_name = slot_wnd.slot_name
      local target = slot_wnd:GetContext()
      local found = false
      for wnd, witem in pairs(slot_wnd.item_windows or empty_table) do
        if IsKindOf(witem, "Medicine") then
          wnd:OnSetRollover(bShow)
          HighlihgtRollover(witem:GetUIWidth(), wnd, bShow)
          found = true
        end
      end
      if slot_wnd and IsKindOf(target, "Unit") and not target:IsDead() and (not (not found and bShow) or h_members[target]) then
        local name = slot_wnd.parent.idName
        if name then
          name:SetHightlighted(bShow)
        end
      end
    end
    if not bShow then
      button:SetHighlighted(bShow)
    end
  end
end
function HighlightWoundedCharacterPortraits(item, show)
  local dlg = GetMercInventoryDlg()
  if not dlg or not item then
    return
  end
  if not item.class or item.class ~= "MetaviraShot" then
    return
  end
  if dlg.compare_mode then
    show = false
  end
  local left = dlg:ResolveId("idPartyContainer")
  local squad_list = left.idParty and left.idParty.idContainer or empty_table
  for _, portrait in ipairs(squad_list) do
    local member = portrait:GetContext()
    if member:HasStatusEffect("Wounded") then
      portrait:SetHighlighted(show)
      portrait.idStatusHighlighter:SetVisible(show)
    end
  end
end
function HighlightDropSlot(wnd, bShow, pt, drag_win)
  local width = InventoryDragItem and InventoryDragItem:GetUIWidth()
  local height = InventoryDragItem and InventoryDragItem:GetUIHeight()
  local dlg = GetMercInventoryDlg()
  local slot_ctrl = (InventoryStartDragSlotName == "Inventory" or InventoryStartDragSlotName == "InventoryDead") and dlg:GetSlotByName(InventoryStartDragSlotName, InventoryStartDragContext) or dlg:GetSlotByName(InventoryStartDragSlotName)
  local drag_win = drag_win or slot_ctrl and slot_ctrl.drag_win
  if bShow then
    local slot = IsKindOf(wnd, "XInventorySlot") and wnd or wnd:GetInventorySlotCtrl()
    local win, left, top = slot:FindTile(pt)
    local blong = 1 < width
    local swidth, sheight, last_row_width = slot.context:GetSlotDataDim(slot.slot_name)
    if drag_win then
      if left and blong and swidth == 2 and IsKindOf(wnd, "EquipInventorySlot") then
        left = 1
      elseif left and blong then
        local l, t, dx = point_unpack(InventoryDragItemPos)
        left = left - dx
        if left <= 0 then
          left = false
        end
      end
    end
    if left and (swidth < left + width - 1 or sheight < top + height - 1 or top + height - 1 == sheight and last_row_width < left + width - 1) then
      left = false
    end
    if left then
      if dropWnd and dropWnd.window_state ~= "destroying" then
        local thesame = dropWnd:GetParent() == slot and dropWnd:GetGridX() == left and dropWnd:GetGridY() == top and dropWnd:GetGridWidth() == width and dropWnd:GetGridHeight() == height
        if thesame then
          return
        end
        dropWnd:delete()
        dropWnd = false
      end
      dropWnd = slot:SpawnDropUI(width, height, left, top)
    end
    local canDrop = slot and slot:CanDropAt(pt)
    if dropWnd then
      local wnd = dropWnd.idItemPad
      wnd:SetImageColor(canDrop and white or GetColorWithAlpha(GameColors.I, 150))
    end
  else
    if dropWnd and dropWnd.window_state ~= "destroying" then
      dropWnd:delete()
    end
    dropWnd = false
  end
end
function InventoryShowMouseText(bShow, text)
  local dlg = GetDialog("FullscreenGameDialogs")
  local ctrl = dlg.idMouseText
  ctrl:SetVisible(bShow)
  if bShow then
    ctrl:AddDynamicPosModifier({id = "DragText", target = "mouse"})
    if text then
      ctrl:SetText(text)
    end
  else
    ctrl:RemoveModifier("DragText")
  end
end
function InventoryFormatAPMouseText(unit_ap, ap_cost, mouse_text)
  mouse_text = mouse_text .. "\n" .. unit_ap.Nick .. " "
  if not unit_ap:UIHasAP(ap_cost) then
    mouse_text = mouse_text .. T({
      262015822006,
      "<style InventoryHintTextRed><apn(ap_cost)>/<apn(max_ap)>AP</style>",
      ap_cost = ap_cost,
      max_ap = unit_ap:GetUIActionPoints()
    })
    mouse_text = mouse_text .. "\n" .. T(582323369969, "<style InventoryHintTextRed>Not enough AP</style>")
  else
    mouse_text = mouse_text .. T({
      939649362145,
      "<style InventoryMouseText><apn(ap_cost)>/<apn(max_ap)>AP</style>",
      ap_cost = ap_cost,
      max_ap = unit_ap:GetUIActionPoints()
    })
  end
  return mouse_text
end
function InventoryEquipAPText(bShow, text)
  local dlg = GetMercInventoryDlg()
  local ctrl = dlg.idUnitInfo.idEquipHint
  ctrl:SetVisible(bShow)
  ctrl:SetText(bShow and text or "")
end
DefineClass.BrowseInventorySlot = {
  __parents = {
    "XInventorySlot"
  }
}
function BrowseInventorySlot:OnMouseButtonDoubleClick(pt, button)
  local dlgContext = GetDialogContext(self)
  if dlgContext and InventoryDisabled(dlgContext) then
    return "break"
  end
  if not InventoryIsContainerOnSameSector({
    context = self.context
  }) then
    return "break"
  end
  if button == "L" and not IsMouseViaGamepadActive() then
    if WasDraggingLastLMBClick then
      return
    end
    local wnd_found, item
    local is_dragging = not not InventoryDragItem
    if is_dragging then
      item = InventoryDragItem
      self:CancelDragging()
    else
      wnd_found, item = self:FindItemWnd(pt)
    end
    if self:TryMoveToBag(item) then
      return "break"
    elseif is_dragging then
      self:EquipItem(item)
    end
  end
  return "break"
end
function BrowseInventorySlot:TryMoveToBag(item)
  if not IsKindOf(item, "SquadBagItem") or not IsKindOfClasses(self.context, "ItemContainer", "SectorStash") and (not IsKindOf(self.context, "Unit") or not self.context:IsDead()) then
    return false
  end
  local unit = GetInventoryUnit()
  local src_container = self.context
  local args = {
    item = item,
    src_container = src_container,
    src_slot = GetContainerInventorySlotName(src_container),
    dest_container = GetSquadBagInventory(unit.Squad),
    dest_slot = "Inventory"
  }
  MoveItem(args)
  return true
end
function BrowseInventorySlot:GetPrevEquipItem(item)
  local unit = GetInventoryUnit()
  if not unit then
    return
  end
  local slot
  local slot_pos = point_pack(1, 1)
  local prev_item
  local slots = {"Handheld A", "Handheld B"}
  local is_weapon = item and item:IsWeapon()
  local is_quick_slot_item = IsKindOf(item, "QuickSlotItem")
  if is_quick_slot_item or is_weapon then
    local free = false
    for _, slot_name in ipairs(slots) do
      slot_pos = unit:CanAddItem(slot_name, item)
      local slot_ctrl = GetInventorySlotCtrl(true, unit, slot_name)
      if slot_pos and slot_ctrl and slot_ctrl:CanEquip(item, slot_pos) then
        slot = slot_name
        free = true
        break
      end
    end
    if free then
      return prev_item, slot, slot_pos
    end
  end
  if is_weapon then
    local free = false
    for _, slot_name in ipairs(slots) do
      local aitem = unit:GetItemInSlot(slot_name, false, 1, 1)
      local bitem = unit:GetItemInSlot(slot_name, false, 2, 1)
      local size = item:GetUIWidth()
      local prev, s_name, pos
      if size == 1 then
        return aitem, slot_name, point_pack(1, 1)
      elseif aitem and bitem and aitem ~= bitem then
        prev, s_name, pos = aitem, slot_name, point_pack(1, 1)
      elseif aitem then
        prev, s_name, pos = aitem, slot_name, point_pack(1, 1)
      else
        prev, s_name, pos = bitem, slot_name, point_pack(2, 1)
      end
      local slot_ctrl = GetInventorySlotCtrl(true, unit, slot_name)
      if pos and slot_ctrl and slot_ctrl:CanEquip(item, pos) then
        return prev, s_name, pos
      end
    end
  elseif is_quick_slot_item then
    local free = false
    for _, slot_name in ipairs(slots) do
      local aitem, l, t = unit:GetItemInSlot(slot_name, "QuickSlotItem")
      if aitem then
        prev_item = aitem
        slot = slot_name
        slot_pos = point_pack(l, t)
        free = true
        break
      end
    end
    if free then
      return prev_item, slot, slot_pos
    end
  elseif IsKindOf(item, "Armor") then
    prev_item = unit:GetItemInSlot(item.Slot)
    slot = item.Slot
  end
  return prev_item, slot, slot_pos
end
function BrowseInventorySlot:EquipItem(item)
  if not item then
    return
  end
  local context = self:GetContext()
  local unit = GetInventoryUnit()
  self:ClosePopup()
  if not unit then
    return
  end
  if not InventoryIsContainerOnSameSector(context) then
    return
  end
  local slot
  local slot_pos = point_pack(1, 1)
  local prev_item, slot, slot_pos = self:GetPrevEquipItem(item)
  if not slot then
    return
  end
  local slot_ctrl = GetInventorySlotCtrl(true, unit, slot)
  if slot_ctrl and slot_ctrl:CanEquip(item, slot_pos) then
    local x, y = point_unpack(slot_pos)
    if 1 < item:GetUIWidth() and 1 < x then
      x = 1
    end
    local result = MoveItem({
      item = item,
      src_container = context,
      src_slot = self.slot_name,
      dest_container = unit,
      dest_slot = slot,
      dest_x = x,
      dest_y = y
    })
    if result then
      PlayFXOnMoveItemResult(result, item, slot)
    else
      PlayFX("WeaponEquip", "start", item.class, item.object_class)
    end
    local src_x, src_y = context:GetItemPosInSlot(self.slot_name, item)
    self:Gossip(item, context, slot_ctrl, src_x, src_y, x, y)
  end
end
DefineClass.EquipInventorySlot = {
  __parents = {
    "XInventorySlot"
  }
}
function EquipInventorySlot:SpawnTile(slot_name)
  return XInventoryTile:new({
    slot_image = equip_slot_images[slot_name]
  }, self)
end
function EquipInventorySlot:CanEquip(item, pt_or_slot_pos)
  if IsPoint(pt_or_slot_pos) then
    local _, tl, tt = self:FindTile(pt_or_slot_pos)
    pt_or_slot_pos = point_pack(tl, tt)
  end
  return InventoryCanEquip(item, self:GetContext(), self.slot_name, pt_or_slot_pos)
end
function InventoryCanEquip(item, context, slot_name, slot_pos)
  local drag_item = item
  local drag_size = drag_item:GetUIWidth()
  if (slot_name == "Handheld A" or slot_name == "Handheld B") and drag_size == 1 then
    local weapon1 = context:GetItemInSlot(slot_name, false, 1, 1)
    local weapon2 = context:GetItemInSlot(slot_name, false, 2, 1)
    local res
    if not weapon1 and not weapon2 then
      return true
    elseif weapon1 == weapon2 and weapon1:GetUIWidth() > 1 then
      return true
    elseif (not weapon1 or not weapon1:IsWeapon()) and (not weapon2 or not weapon2:IsWeapon()) then
      return true
    elseif not (weapon1 ~= drag_item or weapon2) or weapon2 == drag_item and not weapon1 then
      return true
    end
    local tl, tt = point_unpack(slot_pos)
    if tl == 1 then
      res = not weapon2 or not weapon2:IsWeapon() or not drag_item:IsWeapon() or IsKindOf(weapon2, "Firearm") and IsKindOf(drag_item, "Firearm")
      return res
    end
    if tl == 2 then
      res = not weapon1 or not weapon1:IsWeapon() or not drag_item:IsWeapon() or IsKindOf(weapon1, "Firearm") and IsKindOf(drag_item, "Firearm")
      return res
    end
    return true
  end
  return true
end
function EquipInventorySlot:UnEquipItem(item)
  if not item then
    return
  end
  local context = self:GetContext()
  local unit = GetInventoryUnit()
  self:ClosePopup()
  if not unit then
    return
  end
  local src_x, src_y = context:GetItemPosInSlot(self.slot_name, item)
  local pos, reason = unit:CanAddItem("Inventory", item)
  if pos then
    local x, y = point_unpack(pos)
    local result = MoveItem({
      item = item,
      src_container = context,
      src_slot = self.slot_name,
      dest_container = unit,
      dest_slot = "Inventory",
      dest_x = x,
      dest_y = y
    })
    if result then
      PlayFXOnMoveItemResult(result, item, "Inventory")
    else
      PlayFX("WeaponUnequip", "start", item.class, item.object_class)
    end
  else
    self:DropItem(item)
  end
end
function EquipInventorySlot:_IsDropTarget(drag_win, pt, drag_source_win)
  local res = XInventorySlot._IsDropTarget(self, drag_win, pt, drag_source_win)
  if not res then
    HighlightDropSlot(false, false, false, drag_win)
    return false
  end
  res = self:CanEquip(InventoryDragItem, pt)
  HighlightDropSlot(self, res, pt, drag_win)
  local ctrl, itm = self:FindItemWnd(pt)
  ctrl = ctrl or self:FindTile(pt)
  if ctrl and itm ~= InventoryDragItem then
    HighlightAPCost(InventoryDragItem, true, ctrl)
  end
  return res
end
function XInventorySlot:GetCostAP(dest, dest_slot_name, dest_pos, is_reload, drag_item, src_context)
  if not InventoryIsCombatMode() or not dest and not dest_pos then
    return 0
  end
  if dest == "drop" then
    return 0
  end
  local src = src_context or self.context
  local item, l, t
  dest_pos = dest_pos or InventoryDragItemPos
  if IsKindOf(dest_pos, "InventoryItem") then
    l, t = dest:GetItemPos(dest_pos)
    item = dest_pos
  else
    l, t = point_unpack(dest_pos)
    item = dest:GetItemAtPos(dest_slot_name, l, t)
    if not item then
      item = dest:GetItemAtPos(dest_slot_name, l - 1, t)
      if item and 1 < item:GetUIWidth() then
        l = l - 1
      end
    end
  end
  if not drag_item and item then
    drag_item = item
    item = false
  end
  return GetAPCostAndUnit(drag_item, src, self.slot_name, dest, dest_slot_name, item, is_reload)
end
function NetSquadBagAction(unit, srcInventory, src_slot_name, item, squadBag, actionName, ap)
  local unit = unit or GetInventoryUnit()
  local ap = ap or 0
  local net_src = GetContainerNetId(srcInventory)
  local squadId = squadBag and squadBag.squad_id or false
  local pack = {}
  table.insert(pack, pack_params(net_src, src_slot_name, item.id, squadId, actionName))
  if IsKindOf(unit, "UnitData") then
    NetSyncEvent("SquadBagAction", unit.session_id, pack)
    return
  end
  NetStartCombatAction("SquadBagAction", unit, ap, pack)
end
function NetCombineItems(recipe_id, outcome, outcome_hp, skill_type, unit_operator_id, item1_context, item1_pos, item2_context, item2_pos, combine_count)
  local container_unit = GetInventoryUnit()
  if not container_unit then
    return
  end
  local net_context1 = GetContainerNetId(item1_context)
  local net_context2 = GetContainerNetId(item2_context)
  local params = pack_params(recipe_id, outcome, outcome_hp, skill_type, unit_operator_id, net_context1, item1_pos, net_context2, item2_pos, false, combine_count)
  if IsKindOf(container_unit, "UnitData") then
    NetSyncEvent("CombineItems", params)
    return
  end
  NetStartCombatAction("CombineItems", container_unit, 0, params)
end
GameVar("gv_SectorInventory", false)
function OnMsg.OpenSatelliteView()
  if gv_CurrentSectorId and gv_SectorInventory then
    gv_SectorInventory:Clear()
    gv_SectorInventory:SetSectorId(gv_CurrentSectorId)
  end
end
function OnMsg.LoadSessionData()
  if gv_SectorInventory then
    gv_SectorInventory:Clear()
  end
end
function NetEvents.OpenSectorInventory(unit_id)
  local unit = gv_UnitData[unit_id]
  if not unit then
    return
  end
  OpenInventory(unit)
end
DefineClass.VirtualSectorStash = {
  __parents = {"Inventory"},
  inventory_slots = {
    {
      slot_name = "Inventory",
      width = 4,
      height = 1,
      base_class = "InventoryItem",
      enabled = true
    }
  },
  sector_id = false
}
function GetSectorInventoryVirtual(sector_id)
  local virtualStash = PlaceObject("VirtualSectorStash")
  virtualStash:SetSectorId(sector_id)
  return virtualStash
end
function VirtualSectorStash:SetSectorId(sector_id)
  self.sector_id = sector_id
end
function VirtualSectorStash:AddItem(slot_name, item, left, top, local_execution, use_pos)
  AddToSectorInventory(self.sector_id, {item})
  local x, y = 1, 1
  if use_pos and left then
    x, y = left, top
  end
  return x, y
end
function GetSectorInventory(sector_id)
  if not gv_SatelliteView or not gv_Sectors[sector_id] then
    return
  end
  if not gv_SectorInventory then
    gv_SectorInventory = PlaceObject("SectorStash")
  end
  gv_SectorInventory:SetSectorId(sector_id)
  return gv_SectorInventory
end
function NetSyncEvents.SectorStashOpenedBy(player)
  SectorStashOpen = player
  ObjModified(GetSatelliteDialog())
end
local function GetLootTableItems(loot_tbl, items)
  for _, entry in ipairs(loot_tbl) do
    local item = rawget(entry, "item")
    if item then
      items[#items + 1] = item
    else
      GetLootTableItems(LootDefs[entry.loot_def], items)
    end
  end
end
function PlayResponseOpenContainer(unit, container)
  if container then
    local play_unit = false and GetRandomMapMerc(unit.Squad, AsyncRand()) or unit
    local found = container:GetItem("Valuables")
    if found then
      PlayVoiceResponse(play_unit, "ValuableItemFound")
      return
    else
      container:ForEachItem(function(item, slot, l, t)
        if item.is_valuable then
          PlayVoiceResponse(play_unit, "ValuableItemFound")
          found = true
          return "break"
        end
      end)
    end
  end
end
function PrepareInventoryContext(obj, container)
  local context
  if obj then
    local coop = IsCoOpGame()
    if coop then
      local class_tbl = IsKindOf(obj, "Unit") and g_Units or gv_UnitData
      if not obj:IsLocalPlayerControlled() then
        local squad = gv_Squads[obj.Squad]
        local controlled = false
        for _, id in ipairs(squad.units) do
          local u = class_tbl[id]
          if u:IsLocalPlayerControlled() then
            obj = u
            break
          end
        end
      end
    end
    local unit
    if IsKindOfClasses(obj, "Unit", "UnitData") then
      unit = obj
    end
    if g_Units[unit.session_id] and InventoryIsCombatMode(g_Units[unit.session_id]) then
      unit = g_Units[unit.session_id]
    end
    context = context or {}
    context.unit = unit or obj
  end
  if container then
    context = context or {}
    context.container = container
  end
  return context
end
function OpenInventory(obj, container, autoResolve)
  local dlg = GetInGameInterfaceModeDlg()
  if IsKindOf(dlg, "IModeCombatAttackBase") then
    SetInGameInterfaceMode(g_Combat and "IModeCombatMovement" or "IModeExploration", {suppress_camera_init = true})
  end
  if gv_SatelliteView and obj then
    local squad = obj.Squad and gv_Squads[obj.Squad]
    if squad and not IsSquadTravelling(squad) and not container then
      container = GetSectorInventory(squad.CurrentSector)
    end
    NetSyncEvent("SectorStashOpenedBy", netUniqueId)
  end
  local context = PrepareInventoryContext(obj, container)
  if context then
    if autoResolve then
      context.autoResolve = true
    end
    local dlg = GetDialog("FullscreenGameDialogs")
    if dlg and dlg.Mode == "inventory" then
      dlg:SetMode("empty")
      dlg:Close()
    end
    dlg = OpenDialog("FullscreenGameDialogs", GetInGameInterface(), context)
    PlayFX("InventoryPanelOpen")
    NetGossip("InventoryPanel", "Open", GetCurrentPlaytime(), Game and Game.CampaignTime)
    if dlg and dlg.Mode ~= "inventory" then
      dlg:SetMode("inventory")
    end
    return dlg
  end
end
function OnMsg.CloseInventorySubDialog()
  PlayFX("InventoryClose")
  NetSyncEvent("SectorStashOpenedBy", false)
  NetGossip("InventoryPanel", "Close", GetCurrentPlaytime(), Game and Game.CampaignTime)
end
function IsInventoryOpened()
  return not not GetDialog("FullscreenGameDialogs")
end
function OpenPerksDialog(unit, item_ctrl)
  local dlg = GetDialog("FullscreenGameDialogs")
  if dlg then
    local context = dlg:GetContext()
    context.unit = unit
    if dlg.Mode == "perks" then
      if item_ctrl then
        item_ctrl:SelectUnit()
      end
    else
      dlg:SetContext(context)
      dlg:OnContextUpdate(context)
      dlg:SetMode("perks")
    end
  else
    local context = PrepareInventoryContext(unit)
    dlg = OpenDialog("FullscreenGameDialogs", GetInGameInterface(), context)
    dlg:SetMode("perks")
  end
end
function GetMercInventoryDlg()
  local dlg = GetDialog("FullscreenGameDialogs")
  if dlg and dlg.Mode == "inventory" then
    return dlg.idModeDialog[2]
  end
end
function GetInventoryUnit(dlg)
  local dlg = dlg or GetMercInventoryDlg()
  local context = dlg and dlg:GetContext()
  return context and context.unit
end
function InventoryIsCombatMode(unit)
  local unit = unit or GetInventoryUnit()
  local squad_id = unit and unit.Squad
  return squad_id and SquadIsInCombat(squad_id)
end
function InventoryIsCompareMode(dlg)
  local dlg = dlg or GetMercInventoryDlg()
  return dlg and dlg.compare_mode
end
function InventoryIsValidTargetForUnitInTransit(ctrl_context)
  if gv_SatelliteView and IsKindOf(ctrl_context, "SectorStash") then
    local unit = GetInventoryUnit()
    if unit and (unit.Operation == "Arriving" or unit.Squad and IsSquadTravelling(gv_Squads[unit.Squad])) then
      return false, T(257112039195, "<style InventoryHintTextRed>In transit")
    end
  end
  return true
end
function InventoryIsValidTargetForUnit(ctrl_context)
  local unit = GetInventoryUnit()
  if gv_SatelliteView and IsKindOf(ctrl_context, "SectorStash") then
    if not InventoryIsValidTargetForUnitInTransit(ctrl_context) then
      return false, T(257112039195, "<style InventoryHintTextRed>In transit")
    end
    if unit.Squad and gv_Squads[unit.Squad] and ctrl_context.sector_id ~= gv_Squads[unit.Squad].CurrentSector then
      return false, T(212348537316, "<style InventoryHintTextRed>Not on sector")
    end
  end
  if IsKindOfClasses(ctrl_context, "Unit", "UnitData") and not ctrl_context:IsDead() then
    if ctrl_context:HasStatusEffect("BandageInCombat") then
      return false, T(107419565286, "Character is busy bandaging")
    elseif ctrl_context:IsDowned() then
      return false, T(360582491602, "Character is Downed")
    elseif ctrl_context:HasStatusEffect("Unconscious") then
      return false, T(894812059755, "Character is Unconscious")
    elseif g_Overwatch[ctrl_context] or g_Pindown[ctrl_context] then
      return false, T(462153644901, "Character is busy")
    elseif ctrl_context.retreat_to_sector then
      return false, T(462153644901, "Character is busy")
    end
  end
  return true
end
function InventoryIsValidGiveDistance(context1, context2)
  if context1 == context2 then
    return true
  end
  local obj1 = IsKindOf(context1, "UnitData") and InventoryIsCombatMode(context1) and g_Units[context1.session_id] or context1
  local obj2 = IsKindOf(context2, "UnitData") and InventoryIsCombatMode(context2) and g_Units[context2.session_id] or context2
  if IsKindOf(obj1, "CObject") and IsKindOf(obj2, "CObject") and obj1:GetDist2D(obj2) > const.InventoryGiveDistance then
    return false, T(201109005967, "Character too far")
  end
  return true
end
function InventoryGetMoveIsInvalidReason(context1, context2)
  local valid, reason = InventoryIsValidTargetForUnit(context1)
  if not valid then
    return reason
  else
    local valid, reason = InventoryIsValidTargetForUnit(context2)
    if not valid then
      return reason
    else
      local valid, reason = InventoryIsValidGiveDistance(context1, context2)
      if not valid then
        return reason
      end
    end
  end
end
function GetInventorySlotCtrl(bContainer, container, slot_name)
  local dlg = GetMercInventoryDlg()
  if not dlg then
    return
  end
  local context = dlg:GetContext()
  if bContainer then
  end
  local searched_context = container or context.container or context.unit
  local slots = dlg:GetSlotsArray()
  local container_slot_name = slot_name or GetContainerInventorySlotName(container)
  for slot in pairs(slots) do
    if slot.slot_name == container_slot_name and slot:GetContext() == searched_context then
      return slot
    end
  end
end
function PerksUIRespawn()
  local dlg
  local fdlg = GetDialog("FullscreenGameDialogs")
  if fdlg and fdlg.Mode == "perks" then
    dlg = fdlg.idModeDialog[2]
  end
  if dlg then
    local context = dlg:GetContext()
    dlg.idUnitInfo:RespawnContent()
    dlg.idRight:RespawnContent()
    dlg.idRight:OnContextUpdate(context)
    dlg:OnContextUpdate(context)
  end
end
function InventoryUIResetSquadBag()
  if gv_SquadBag then
    gv_SquadBag:Clear()
  end
end
function InventoryUIResetSectorStash(id)
  if gv_SectorInventory then
    gv_SectorInventory:Clear()
    if id then
      gv_SectorInventory:SetSectorId(id)
    end
  end
end
local InventoryUIRespawn_shield
function InventoryUIRespawn()
  if InventoryUIRespawn_shield then
    return
  end
  DelayedCall(0, _InventoryUIRespawn)
end
function CancelDrag(dlg)
  dlg = dlg or GetMercInventoryDlg()
  if not dlg then
    return
  end
  local slots = dlg:GetSlotsArray()
  for slot_ctrl in pairs(slots) do
    if slot_ctrl:CancelDragging() then
      return slot_ctrl
    end
  end
end
function RestartDrag(dlg, item)
  local slots = dlg:GetSlotsArray()
  for slot_ctrl in pairs(slots) do
    local wnd = slot_ctrl:FindItemWnd(item)
    if wnd then
      slot_ctrl:OnMouseButtonDown((wnd.interaction_box or wnd.box):Center(), "L")
      HighlightDropSlot(nil, false)
      return
    end
  end
end
function _InventoryUIRespawn()
  if IsValidThread(g_squad_bag_sort_thread) then
    Sleep(1)
    InventoryUIRespawn()
    return
  end
  InventoryUIRespawn_shield = true
  local dlg = GetMercInventoryDlg()
  if dlg then
    local drag_item = InventoryDragItem
    if drag_item then
      CancelDrag(dlg)
    end
    local saveScroll = dlg.idScrollbar.Scroll
    local saveScrollCenter = dlg.idScrollbarCenter.Scroll
    local context = dlg:GetContext()
    dlg.idUnitInfo:RespawnContent()
    dlg.idPartyContainer.idParty:RespawnContent()
    dlg.idRight:RespawnContent()
    dlg.idCenter:RespawnContent()
    dlg.idRight:OnContextUpdate(context)
    dlg.idCenter:OnContextUpdate(context)
    dlg.idCenter:RespawnContent()
    dlg:OnContextUpdate(context)
    dlg.idScrollbar:ScrollTo(saveScroll)
    dlg.idScrollbarCenter:ScrollTo(saveScrollCenter)
    Msg("RespawnedInventory")
    if drag_item then
      Sleep(0)
      RestartDrag(dlg, drag_item)
    end
  end
  InventoryUIRespawn_shield = nil
end
OnMsg.InventoryRemoveItem = InventoryUIRespawn
OnMsg.InventoryAddItem = InventoryUIRespawn
function GetValidMercsToTakeItem(context)
  local remove_self = not context.container and "remove self"
  local unit
  if not (not IsKindOf(context.context, "Unit") or context.context:IsDead()) or IsKindOf(context.context, "UnitData") or IsKindOf(context.context, "SectorStash") and context.unit.Operation == "Arriving" then
    remove_self = "remove self"
    unit = context.context
  else
    remove_self = false
    unit = context.unit
  end
  local item = context.item
  local units = InventoryGetSquadUnits(unit, remove_self, function(u)
    if type(u) == "string" then
      u = gv_UnitData[u]
    end
    if (not gv_SatelliteView or InventoryIsCombatMode(unit)) and not InventoryIsValidGiveDistance(u, unit) then
      return false
    end
    local pos, reason = u:CanAddItem("Inventory", item)
    return not not pos
  end)
  return units
end
function InventoryIsContainerOnSameSector(context)
  local unit = GetInventoryUnit()
  local unit_sector = unit.Squad
  unit_sector = unit_sector and gv_Squads[unit_sector].CurrentSector
  if IsKindOf(context.context, "SectorStash") and context.context.sector_id ~= unit_sector then
    return false
  end
  return true
end
function InventoryGetTargetsForGiveAction(context)
  if not InventoryIsContainerOnSameSector(context) then
    return {}
  end
  local targets = table.copy(GetValidMercsToTakeItem(context))
  if IsKindOf(context.item, "SquadBagItem") and not IsKindOf(context.context, "SquadBag") and InventoryIsValidTargetForUnitInTransit(context.context) then
    targets[#targets + 1] = context.unit.Squad
  end
  return targets
end
function InventoryGetTargetsForGiveToSquadAction(context)
  local unit = context.context
  local unit_squad = unit.Squad or unit.squad_id
  local squads = GetCurrentSectorPlayerSquads()
  table.remove_entry(squads, "UniqueId", unit_squad)
  return squads
end
function InventoryGetSquadUnits(unit, remove_self, filter)
  if gv_SatelliteView then
    local dlg = GetSatelliteDialog()
    local squad = dlg and dlg.selected_squad
    if unit then
      if type(unit) ~= "string" then
        squad = unit.Squad and gv_Squads[unit.Squad]
        unit = unit.session_id
      else
        squad = gv_UnitData[unit] and gv_UnitData[unit].Squad and gv_Squads[gv_UnitData[unit]]
      end
    end
    local units = squad and squad.units or empty_table
    unit = unit or units[1]
    return table.ifilter(units, function(i, u)
      return (not remove_self or u ~= unit) and (not filter or filter(u))
    end)
  else
    unit = unit or SelectedObj
    local team = unit.team
    team = GetFilteredCurrentTeam(team)
    return team and table.ifilter(team.units, function(i, u)
      return not u:IsDead() and (not remove_self or u.session_id ~= unit.session_id) and (not filter or filter(u))
    end) or empty_table
  end
end
function InventoryFindItemInMercs(all_mercs, item_id, amount, check)
  local result
  local results = {}
  for idx, merc in ipairs(all_mercs) do
    local unit = not gv_SatelliteView and g_Units[merc] or gv_UnitData[merc]
    unit:ForEachItemDef(item_id, function(item, slot)
      local is_stack = IsKindOf(item, "InventoryStack")
      local val = is_stack and item.Amount or 1
      if val >= amount and item:GetConditionPercent() > 0 then
        if check then
          return "break"
        end
        local found = {
          container = unit,
          slot = slot,
          item = item
        }
        result = result or found
        if not check then
          while val >= amount do
            results[#results + 1] = found
            val = val - amount
          end
        end
      end
    end)
    if next(result) then
      break
    end
  end
  if not next(result) then
    local unit = gv_UnitData[all_mercs[1]]
    local bag = unit and GetSquadBag(unit.Squad) or empty_table
    local bag_obj = unit and GetSquadBagInventory(unit.Squad)
    for i = #bag, 1, -1 do
      local item = bag[i]
      if item.class == item_id then
        local is_stack = IsKindOf(item, "InventoryStack")
        local val = is_stack and item.Amount or 1
        if amount <= val and item:GetConditionPercent() > 0 then
          if check then
            break
          end
          local found = {
            container = bag_obj,
            slot = "Inventory",
            item = item
          }
          result = result or found
          if not check then
            while amount <= val do
              results[#results + 1] = found
              val = val - amount
            end
          end
        end
      end
    end
  end
  return result, results
end
function InventoryGetIngredientsForRecipe(recipe, unit)
  local unit_id = unit.session_id
  local squad = gv_UnitData[unit_id] and gv_UnitData[unit_id].Squad
  if not squad then
    return
  end
  local all_mercs = table.copy(gv_Squads[squad].units)
  if not gv_SatelliteView or InventoryIsCombatMode(unit) then
    for i = #all_mercs, 1, -1 do
      if not InventoryIsValidGiveDistance(g_Units[all_mercs[i]], unit) then
        table.remove(all_mercs, i)
      end
    end
  end
  local ingredients = {}
  for i, ingrd in ipairs(recipe.Ingredients) do
    local result, results = InventoryFindItemInMercs(all_mercs, ingrd.item, ingrd.amount)
    ingredients[#ingredients + 1] = {
      recipe = recipe,
      container_data = result,
      total_data = results
    }
  end
  return ingredients
end
function InventoryGetTargetsRecipe(item, unit, item2, container2)
  local is_stack = IsKindOf(item, "InventoryStack")
  if item:GetConditionPercent() <= 0 then
    return empty_table
  end
  local item_id = item.class
  local targets = {}
  local unit_id = unit.session_id
  local container2_id = container2 and container2.session_id
  local squad = gv_UnitData[unit_id] and gv_UnitData[unit_id].Squad
  if not squad then
    return
  end
  local all_mercs = container2 and {container2_id} or table.copy(gv_Squads[squad].units)
  if not gv_SatelliteView or InventoryIsCombatMode(unit) then
    for i = #all_mercs, 1, -1 do
      if not InventoryIsValidGiveDistance(g_Units[all_mercs[i]], unit) then
        table.remove(all_mercs, i)
      end
    end
  end
  for id, recipe in pairs(Recipes) do
    local ingredients = recipe.Ingredients
    for i, ingrd in ipairs(ingredients) do
      if ingrd.item == item_id and (not is_stack or ingrd.amount <= (item.Amount or 1)) then
        local second_idx = i == 1 and 2 or 1
        local second = ingredients[second_idx]
        if not item2 or second.item == item2.class then
          local result, results = InventoryFindItemInMercs(all_mercs, second.item, second.amount)
          if next(result) then
            targets[#targets + 1] = {
              recipe = recipe,
              second_idx = second_idx,
              second = second.item,
              container_data = result,
              total_data = results
            }
          end
        end
      end
    end
  end
  return targets
end
function InventoryUnitCanUseItem(unit, item)
  if InventoryItemDefs[item.class].group == "Magazines" then
    return unit[item.UnitStat] < 100
  end
  return true
end
function InventoryUseItem(unit, item, source_context, source_slot_name)
  NetSyncEvent("InvetoryAction_UseItem", unit.session_id, item.id)
  if InventoryItemDefs[item.class].group == "Magazines" then
    PlayVoiceResponse(unit.session_id, "LevelUp")
  end
  if item.class == "MetaviraShot" then
    PlayVoiceResponse(unit.session_id, "HealReceived")
  end
  CombatLog("short", T({
    750272913405,
    "<merc> uses <item>",
    merc = unit:GetDisplayName(),
    item = item.DisplayName
  }))
  if item.destroy_item then
    DestroyItem(item, unit, source_context, source_slot_name, 1)
  end
end
if FirstLoad then
  ItemClassToRecipes = false
end
function OnMsg.DataLoaded()
  ItemClassToRecipes = {}
  local push = function(item_class, recipe)
    local t = ItemClassToRecipes[item_class] or {}
    ItemClassToRecipes[item_class] = t
    table.insert(t, recipe)
  end
  for recipe_id, recipe in pairs(Recipes) do
    local ingredients = recipe.Ingredients
    local ing1 = ingredients[1]
    local ing2 = ingredients[2]
    push(ing1.item, recipe)
    push(ing2.item, recipe)
  end
end
function InventoryIsCombineTarget(drag_item, target_item)
  if g_Combat then
    return false
  end
  if not target_item then
    return
  end
  local drag_id = drag_item.class
  local target_id = target_item.class
  local drag_amount = IsKindOf(drag_item, "InventoryStack") and drag_item.Amount or 1
  local target_amount = IsKindOf(target_item, "InventoryStack") and target_item.Amount or 1
  local recipes = ItemClassToRecipes[drag_id]
  for _, recipe in ipairs(recipes) do
    local ingredients = recipe.Ingredients
    local ing1 = ingredients[1]
    local ing2 = ingredients[2]
    if ing1.item == drag_id and ing2.item == target_id and drag_amount >= ing1.amount and target_amount >= ing2.amount or ing2.item == drag_id and ing1.item == target_id and drag_amount >= ing2.amount and target_amount >= ing1.amount then
      return recipe, ing1.item == drag_id
    end
  end
end
function InventoryCombineItemMaxSkilled(unit, recipe)
  local maxSkill, mercMaxSkill, skill_type
  local is_unit = IsKindOf(unit, "Unit")
  for i, u_id in ipairs(gv_Squads[unit.Squad].units) do
    local u = is_unit and g_Units[u_id] or gv_UnitData[u_id]
    skill_type = recipe.MechanicalRoll and "Mechanical" or "Explosives"
    local skill = u[recipe.MechanicalRoll and "Mechanical" or "Explosives"]
    if not maxSkill or maxSkill < skill then
      maxSkill = skill
      mercMaxSkill = u.session_id
    end
  end
  return maxSkill, mercMaxSkill, skill_type
end
function InventoryGetLootContainers(container)
  if IsKindOf(container, "SectorStash") then
    return {container}
  elseif InventoryIsCombatMode() then
    return {container}
  elseif IsKindOfClasses(container, "ItemDropContainer", "Unit") or IsKindOf(container, "ContainerMarker") and container:IsInGroup("DeadBody") then
    local pos = container:GetPos()
    local unit = container.interacting_unit or false
    local containers = MapGet(pos, const.AreaLootSize * const.SlabSizeX, "ItemDropContainer", "Unit", "ItemContainer", function(o, unit)
      if o == container then
        return false
      end
      local spawner = o:HasMember("spawner") and o.spawner
      if not IsKindOfClasses(o, "ItemDropContainer", "Unit") and (not (IsKindOf(o, "ContainerMarker") and o:IsMarkerEnabled()) or not o:IsInGroup("DeadBody")) then
        return false
      end
      if spawner and spawner.Type == "IntelInventoryItemSpawn" and not gv_Sectors[gv_CurrentSectorId].intel_discovered then
        return false
      end
      if IsKindOf(o, "Unit") then
        if not o:IsDead() then
          return false
        end
        if o.interacting_unit ~= unit then
          return false
        end
        return o:GetItemInSlot("InventoryDead")
      end
      if IsKindOf(o, "ItemContainer") then
        if not o:IsOpened() and o:CannotOpen() then
          return false
        end
        if o.interacting_unit then
          if not unit then
            return false
          elseif unit and o.interacting_unit ~= unit then
            return false
          end
        end
      end
      return o:GetItem()
    end, unit)
    local ret = {container}
    for _, cont in ipairs(containers) do
      ret[#ret + 1] = cont
    end
    return ret
  else
    return {container}
  end
end
function GetContainerNamesCombo()
  local presets = Presets.ContainerNames.Default
  local combo = {}
  for _, preset in ipairs(presets) do
    combo[#combo + 1] = preset.id
  end
  return combo
end
function GetContainerInventorySlotName(container)
  return IsKindOfClasses(container, "Unit", "UnitData") and container:IsDead() and "InventoryDead" or "Inventory"
end
function SpawnInventoryActionsSecondaryPopup(actionButton, action)
  local node = actionButton:ResolveId("node")
  local context = node.context
  context.action = action
  node = node.parent
  if node.spawned_subpopup then
    node.spawned_subpopup:Close()
  end
  actionButton:SetSelected(true)
  local popup = XTemplateSpawn("InventoryContextSubMenu", terminal.desktop, context)
  popup:SetAnchorType("right")
  popup:SetAnchor(actionButton.box)
  popup.popup_parent = node
  node.spawned_subpopup = popup
  popup:Open()
end
if Platform.developer then
  local wait_interface_mode = function(mode, step)
    while GetInGameInterfaceMode() ~= mode do
      Sleep(step or 10)
    end
  end
  local wait_units_idle = function()
    local units = table.icopy(g_Units)
    repeat
      for i = #units, 1, -1 do
        if units[i]:IsDead() or units[i]:IsIdleCommand() then
          table.remove(units, i)
        end
      end
      if 0 < #units then
        WaitMsg("Idle", 20)
      end
    until #units == 0
  end
  local wait_game_time = function(ms, step)
    local t = GameTime()
    while GameTime() < t + ms do
      Sleep(step or 10)
    end
  end
  local GameTestInventoryDlgAction = function(dlg, action_id, time)
    local action = dlg:ActionById(action_id)
    if action then
      action:OnAction(dlg)
    end
    Sleep(time or 20)
  end
  local GameTestInventoryCloseInvDialog = function()
    local dlg = GetDialog("FullscreenGameDialogs")
    GameTestInventoryDlgAction(dlg, "Close")
    while GetDialog("FullscreenGameDialogs") do
      Sleep(50)
    end
  end
  local GameTestInventoryOpenPopup = function(ctrl, posctrl)
    posctrl = posctrl or ctrl
    ctrl:OnMouseButtonDown(posctrl.box:min() + posctrl.box:size() / 3, "R")
  end
  local GameTestInventoryStartPopupAction = function(action_name, inv_dlg, ctrl, posctrl)
    inv_dlg = inv_dlg or GetMercInventoryDlg()
    ctrl:ClosePopup()
    local popup
    while not popup or popup.window_state == "destroying" do
      GameTestInventoryOpenPopup(ctrl, posctrl)
      Sleep(50)
      popup = inv_dlg.spawned_popup
      if not popup then
        return
      end
    end
    local btn
    for _, wnd in ipairs(popup.idPopupWindow) do
      btn = wnd
      if not IsKindOf(wnd, "XButton") then
        btn = wnd[1]
      end
      if btn.Id == action_name then
        btn:Press()
        break
      end
    end
    Sleep(50)
    WaitAllCombatActionsEnd()
    Sleep(50)
    return popup
  end
  local GameTestInventoryGetBrowseCtrl = function(inv_dlg, n)
    return inv_dlg.idScrollArea[n].idInventorySlot
  end
  local GameTestInventory = function(bExploration)
    g_Units.Buns.Strength = 100
    g_Units.Len.Strength = 100
    g_Units.Buns:AddToInventory("Parts", 100)
    g_Units.Len:AddToInventory("AK47")
    g_Units.Len:AddToInventory("AK74")
    AddItemToSquadBag(g_Units.Len.Squad, "762WP_AP", 50)
    SelectObj(g_Units.Buns)
    wait_game_time(50, 10)
    local dlg = GetInGameInterfaceModeDlg()
    InvokeShortcutAction(dlg, "idInventory")
    local dlg = GetDialog("FullscreenGameDialogs")
    while not dlg do
      dlg = GetDialog("FullscreenGameDialogs")
      Sleep(20)
    end
    Sleep(200)
    local inv_dlg = GetMercInventoryDlg()
    local ctrl = inv_dlg.idUnitInfo.idWeaponA
    GameTestInventoryStartPopupAction("unload", inv_dlg, ctrl)
    g_Units.Buns:GainAP(100000)
    local ctrl = inv_dlg.idUnitInfo.idWeaponA
    local popup = GameTestInventoryStartPopupAction("reload", inv_dlg, ctrl)
    if popup then
      local subpopup = popup.spawned_subpopup
      subpopup.idPopupWindow[1]:Press()
      Sleep(100)
    end
    SelectObj(g_Units.Buns)
    local inv_dlg = GetMercInventoryDlg()
    local ctrl = GameTestInventoryGetBrowseCtrl(inv_dlg, bExploration and 3 or 4)
    for item_ctrl, item in pairs(ctrl.item_windows) do
      if bExploration or not IsKindOf(item, "InventoryStack") then
        GameTestInventoryStartPopupAction("drop", inv_dlg, ctrl, item_ctrl)
        Sleep(100)
        break
      end
    end
    local inv_dlg = GetMercInventoryDlg()
    local ctrl = GameTestInventoryGetBrowseCtrl(inv_dlg, 2)
    for item_ctrl, item in pairs(ctrl.item_windows) do
      local ctrl = GameTestInventoryGetBrowseCtrl(inv_dlg, 2)
      if IsKindOf(item, "InventoryStack") and 3 < item.Amount then
        GameTestInventoryStartPopupAction("split", inv_dlg, ctrl, item_ctrl)
        local splitdlg = GetDialog("SplitStackItem")
        local slider = splitdlg.idContext.idSlider
        slider:SetScroll(3)
        local actions = splitdlg:GetActions()
        actions[1]:OnAction(splitdlg)
        Sleep(100)
        break
      end
    end
    local inv_dlg = GetMercInventoryDlg()
    local ctrl = GameTestInventoryGetBrowseCtrl(inv_dlg, bExploration and 1 or 4)
    local to_bag = false
    for item_ctrl, item in pairs(ctrl.item_windows) do
      local ctrl = GameTestInventoryGetBrowseCtrl(inv_dlg, bExploration and 1 or 4)
      local popup = GameTestInventoryStartPopupAction("give", inv_dlg, ctrl, item_ctrl)
      popup = popup and popup.spawned_subpopup
      if not to_bag and IsKindOf(item, "InventoryStack") then
        popup.idPopupWindow[#popup.idPopupWindow]:Press()
        to_bag = true
        Sleep(100)
      else
        popup.idPopupWindow[1]:Press()
        Sleep(100)
        if to_bag then
          break
        end
      end
    end
    local inv_dlg = GetMercInventoryDlg()
    local ctrl = inv_dlg.idUnitInfo.idWeaponA
    GameTestInventoryStartPopupAction("modify", inv_dlg, ctrl)
    local m_dlg = GetDialog("ModifyWeaponDlg")
    while not m_dlg or not rawget(m_dlg, "idModifyDialog") do
      Sleep(50)
      m_dlg = GetDialog("ModifyWeaponDlg")
    end
    local trigger = m_dlg.idModifyDialog.idWeaponParts[3]
    trigger.idCurrent:OnPress()
    Sleep(50)
    Sleep(50)
    GameTestInventoryDlgAction(m_dlg, "actionClosePanel")
    Sleep(30)
    CloseDialog("ModifyWeaponDlg")
    while GetDialog("ModifyWeaponDlg") do
      Sleep(30)
    end
    local inv_dlg = GetMercInventoryDlg()
    GameTestInventoryDlgAction(inv_dlg, "NextUnit")
    local ctrl = GameTestInventoryGetBrowseCtrl(inv_dlg, 2)
    for item_ctrl, item in pairs(ctrl.item_windows) do
      if item.class == "AK47" then
        GameTestInventoryStartPopupAction("equip", inv_dlg, ctrl, item_ctrl)
        break
      end
    end
    local ctrl = GameTestInventoryGetBrowseCtrl(inv_dlg, 2)
    for item_ctrl, item in pairs(ctrl.item_windows) do
      if item:IsWeapon() then
        GameTestInventoryStartPopupAction("scrap", inv_dlg, ctrl, item_ctrl)
        Sleep(50)
        for d, _ in pairs(g_OpenMessageBoxes) do
          if d and d[1] then
            d[1].idActionBar.ididOk:Press()
            Sleep(50)
          end
        end
        break
      end
    end
    local inv_dlg = GetMercInventoryDlg()
    local ctrl = GameTestInventoryGetBrowseCtrl(inv_dlg, 1)
    for item_ctrl, item in pairs(ctrl.item_windows) do
      if item.class == "Parts" then
        local popup = GameTestInventoryStartPopupAction("give", inv_dlg, ctrl, item_ctrl)
        popup = popup and popup.spawned_subpopup
        popup.idPopupWindow[#popup.idPopupWindow]:Press()
        Sleep(30)
        break
      end
    end
    local inv_dlg = GetMercInventoryDlg()
    GameTestInventoryDlgAction(inv_dlg, "NextUnit")
    local inv_dlg = GetMercInventoryDlg()
    local ctrl = inv_dlg.idUnitInfo.idWeaponA
    GameTestInventoryStartPopupAction("unload", inv_dlg, ctrl)
    local ctrl = inv_dlg.idUnitInfo.idWeaponA
    popup = GameTestInventoryStartPopupAction("reload", inv_dlg, ctrl)
    if popup then
      popup = popup.spawned_subpopup
      if popup then
        popup.idPopupWindow[1]:Press()
        Sleep(30)
      end
    end
    GameTestInventoryCloseInvDialog()
    SelectObj(g_Units.Buns)
    wait_game_time(50, 10)
    wait_game_time(50, 10)
    local modedlg = GetInGameInterfaceModeDlg()
    local t = now()
    local interactAction = modedlg:ResolveId("Interact")
    if interactAction then
      interactAction:Press()
    end
    local dlg = GetDialog("FullscreenGameDialogs")
    while not dlg and now() - t < 500 do
      dlg = GetDialog("FullscreenGameDialogs")
      Sleep(20)
    end
    dlg = GetDialog("FullscreenGameDialogs")
    if dlg then
      GameTestInventoryDlgAction(dlg, "TakeLoot", 50)
      GameTestInventoryCloseInvDialog()
    end
  end
  function GameTests.Inventory()
    local t = RealTime()
    local test_combat_id = "Default"
    GameTestMapLoadRandom = xxhash("GameTestMapLoadRandomSeed")
    MapLoadRandom = InitMapLoadRandom()
    ResetInteractionRand(0)
    local expected_sequence = {}
    for i = 1, 10 do
      expected_sequence[i] = InteractionRand(100, "GameTest")
    end
    local testPreset = Presets.TestCombat.GameTest[test_combat_id]
    NewGameSession()
    gv_CurrentSectorId = testPreset.sector_id
    CreateNewSatelliteSquad({
      Side = "player1",
      CurrentSector = testPreset.sector_id,
      Name = "GAMETEST"
    }, {
      "Buns",
      "Len",
      "Ivan",
      "Tex"
    }, 14, 1234567)
    local combat_test_in_progress = true
    CreateRealTimeThread(function()
      while combat_test_in_progress do
        if GetDialog("PopupNotification") then
          Dialogs.PopupNotification:Close()
        end
        Sleep(10)
      end
    end)
    TestCombatEnterSector(testPreset)
    SetTimeFactor(10000)
    for i = 1, 10 do
      local value = InteractionRand(100, "GameTest")
    end
    while GetInGameInterfaceMode() ~= "IModeDeployment" and GetInGameInterfaceMode() ~= "IModeExploration" do
      Sleep(20)
    end
    GameTestMapLoadRandom = false
    if GetInGameInterfaceMode() == "IModeDeployment" then
      Dialogs.IModeDeployment:StartExploration()
      while GetInGameInterfaceMode() == "IModeDeployment" do
        Sleep(10)
      end
    end
    if GetInGameInterfaceMode() == "IModeExploration" then
      NetSyncEvent("ExplorationStartCombat")
      wait_interface_mode("IModeCombatMovement")
    end
    wait_units_idle()
    while g_Combat.camera_use do
      Sleep(100)
    end
    GameTestInventory()
    NetSyncEvent("KillAllEnemies")
    if g_Combat then
      g_Combat:EndCombatCheck()
    end
    while GetInGameInterfaceMode() ~= "IModeExploration" do
      WaitMsg("ExplorationStart", 50)
    end
    combat_test_in_progress = false
    GameTestInventory("exploration")
    print("Inventory test time:", (RealTime() - t) / 1000)
  end
end
function PopupMenuGiveItem(node)
  local context = node and node.context
  if context then
    local ui_slot = context.slot_wnd
    local dest_container = node.unit
    local args = {
      item = context.item,
      src_container = context.context,
      src_slot = ui_slot.slot_name,
      dest_container = dest_container,
      dest_slot = GetContainerInventorySlotName(dest_container)
    }
    MoveItem(args)
    ui_slot:ClosePopup()
    PlayFX("GiveItem", "start")
  end
end
function PopupMenuGiveItemToSquad(node)
  local context = node and node.context
  if context then
    local ui_slot = context.slot_wnd
    local dest_squad = node.squad
    local src_container = context.context
    local item = context.item
    local squadBag = dest_squad.UniqueId
    local args = {
      item = item,
      src_container = src_container,
      src_slot = ui_slot.slot_name,
      dest_container = squadBag,
      dest_slot = "Inventory"
    }
    local rez = MoveItem(args)
    if rez then
      local su = dest_squad.units
      for _, unitName in ipairs(su) do
        local dest_container = gv_SatelliteView and gv_UnitData[unitName] or g_Units[unitName]
        args.dest_container = dest_container
        args.dest_slot = GetContainerInventorySlotName(dest_container)
        rez = MoveItem(args)
        if not rez then
          break
        end
      end
    end
    if rez then
      print("failed to transfer to squad", rez)
    end
  end
end
function PopupMenuGiveItem(node)
  local context = node and node.context
  if context then
    local ui_slot = context.slot_wnd
    local dest_container = node.unit
    local args = {
      item = context.item,
      src_container = context.context,
      src_slot = ui_slot.slot_name,
      dest_container = dest_container,
      dest_slot = GetContainerInventorySlotName(dest_container)
    }
    MoveItem(args)
    ui_slot:ClosePopup()
    PlayFX("GiveItem", "start")
  end
end
function PopupMenuSplitGiveToSquad(node)
  local context = node and node.context
  if not context then
    return
  end
  if node.squad then
    OpenDialog("SplitStackItem", false, SubContext(context, {
      squad_id = node.squad and node.squad.UniqueId,
      fnOK = function(context, splitAmount)
        local ui_slot = context.slot_wnd
        local dest_squad = gv_Squads[context.squad_id]
        local src_container = context.context
        local item = context.item
        local squadBag = context.squad_id
        local args = {
          item = item,
          src_container = src_container,
          src_slot = ui_slot.slot_name,
          dest_container = squadBag,
          dest_slot = "Inventory",
          amount = splitAmount
        }
        local rez = MoveItem(args)
        if rez then
          local su = dest_squad.units
          for _, unitName in ipairs(su) do
            local dest_container = gv_SatelliteView and gv_UnitData[unitName] or g_Units[unitName]
            args.dest_container = dest_container
            args.dest_slot = GetContainerInventorySlotName(dest_container)
            rez = MoveItem(args)
            if not rez then
              break
            end
          end
        end
        if rez then
          print("failed to transfer to squad", rez)
        end
      end
    }))
  elseif node.unit then
    OpenDialog("SplitStackItem", false, SubContext(context, {
      udata = IsKindOf(node.unit, "UnitData"),
      unit = node.unit.session_id,
      fnOK = function(context, splitAmount)
        local ui_slot = context.slot_wnd
        local dest_container = context.udata and gv_UnitData[context.unit] or g_Units[context.unit]
        local args = {
          item = context.item,
          src_container = context.context,
          src_slot = ui_slot.slot_name,
          dest_container = dest_container,
          dest_slot = GetContainerInventorySlotName(dest_container),
          amount = splitAmount
        }
        MoveItem(args)
        ui_slot:ClosePopup()
        PlayFX("GiveItem", "start")
      end
    }))
  end
end
DefineClass.CombineItemPopupClass = {
  __parents = {
    "ZuluModalDialog"
  }
}
