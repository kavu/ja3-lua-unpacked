local voxelSizeX = const.SlabSizeX or 0
local voxelSizeY = const.SlabSizeY or 0
local voxelSizeZ = const.SlabSizeZ or 0
if FirstLoad then
  CollectionsToHideVisuals = true
  CollectionsToHideVisualMeshes = false
end
MapVar("g_CollectionsToHideContainer", false)
function GetCollectionsToHideContainer()
  if not g_CollectionsToHideContainer then
    local t = MapGet("detached", "CollectionsToHideContainer")
    if t and 1 < #t then
      for i = #t, 2, -1 do
        DoneObject(t[i])
        t[i] = nil
      end
    end
    g_CollectionsToHideContainer = t and t[1] or PlaceObject("CollectionsToHideContainer")
  end
  g_CollectionsToHideContainer.contents = g_CollectionsToHideContainer.contents or {}
  return g_CollectionsToHideContainer
end
function GetCollectionsToHide()
  return GetCollectionsToHideContainer().contents
end
function GetCollectionsToHideDataForRoom(r, create)
  local c = GetCollectionsToHide()
  local idx = table.find(c, "room", r)
  if idx then
    return c[idx], c
  elseif create then
    local data = PlaceObject("CollectionsToHidePersistableData", {room = r})
    return data, c
  else
    return false, c
  end
end
local tMembers = {
  "West",
  "East",
  "North",
  "South",
  "Roof"
}
function GetCollectionsToHideAssociatedRooms(col)
  local ret
  local c = GetCollectionsToHide()
  for i = 1, #c do
    local d = c[i]
    for j = 1, #tMembers do
      local idx = table.find(d[tMembers[j]] or empty_table, col)
      if idx then
        ret = ret or {}
        ret[d.room] = ret[d.room] or {}
        table.insert(ret[d.room], tMembers[j])
      end
    end
  end
  return ret
end
MapVar("colToRoomCache", false)
MapVar("roomToColCache", false)
local GetCollectionsToHideForRoom = function(r, side)
  local t = table.get(roomToColCache, r, side)
  if t == nil then
    local data = GetCollectionsToHideDataForRoom(r)
    t = data and data[side] or false
    roomToColCache = roomToColCache or {}
    roomToColCache[r] = roomToColCache[r] or {}
    roomToColCache[r][side] = t
  end
  return t
end
function GetRoomDataForCollection(col)
  if not col then
    return false
  end
  local t2
  if colToRoomCache then
    t2 = colToRoomCache[col]
  end
  if t2 == nil then
    t2 = GetCollectionsToHideAssociatedRooms(col) or false
    colToRoomCache = colToRoomCache or {}
    colToRoomCache[col] = t2
  end
  return t2
end
function GetRoomDataForObjCollection(obj)
  local col = obj:GetRootCollection()
  return GetRoomDataForCollection(col)
end
if FirstLoad then
  CollectionsRelations = false
end
function BuildCollectionsRelations()
  CollectionsRelations = {}
  local t = CollectionsRelations
  local function insertC(c)
    if t[c] then
      return
    end
    local p = c:GetCollection()
    t[c] = {parent = p, children = false}
    if p then
      insertC(p)
      t[p].children = t[p].children or {}
      table.insert(t[p].children, c)
    end
  end
  for idx, c in pairs(Collections) do
    insertC(c)
  end
end
local function pushChildren(col, t)
  local cr = CollectionsRelations
  local children = cr[col].children
  for i = 1, #(children or "") do
    local child = children[i]
    pushChildren(child, t)
    t[#t + 1] = child.Index
  end
end
function OnMsg.DoneMap()
  CollectionsRelations = false
end
OnMsg.ChangeMapDone = BuildCollectionsRelations
OnMsg.GameExitEditor = BuildCollectionsRelations
function IsAnyCollectionLinkedToRooms(col)
  local cr = CollectionsRelations
  local rc = col:GetRootCollection() or col
  local function overflowHelper(c)
    if IsCollectionLinkedToRooms(c) then
      return true
    end
    local children = cr[c] and cr[c].children
    for i = 1, #(children or "") do
      if overflowHelper(children[i]) then
        return true
      end
    end
    return false
  end
  return overflowHelper(rc)
end
function IsCollectionLinkedToRooms(col)
  if type(col) == "number" then
    col = Collections[col]
  end
  return GetRoomDataForCollection(col) ~= false
end
local ClearCollectionsToHideCache = function(col, room)
  if roomToColCache then
    roomToColCache[room] = nil
  end
  if colToRoomCache then
    colToRoomCache[col] = nil
  end
end
DefineClass.CollectionsToHideContainer = {
  __parents = {"Object"},
  flags = {
    gofPermanent = true,
    efWalkable = false,
    efCollision = false,
    efApplyToGrids = false
  },
  properties = {
    {
      id = "contents",
      editor = "objects",
      default = false
    }
  }
}
function CollectionsToHideContainer:GetEditorRelatedObjects()
  return self.contents
end
function CollectionsToHideContainer:CleanBadEntries()
  colToRoomCache = false
  roomToColCache = false
  local t = self.contents
  for i = #t, 1, -1 do
    local o = t[i]
    o:CleanBadEntries()
    if not IsValid(o.room) or o:IsEmpty() then
      DoneObject(o)
      table.remove(t, i)
    end
  end
end
function CollectionsToHideContainer:CleanUp()
  colToRoomCache = false
  roomToColCache = false
  local t = self.contents
  for i = #t, 1, -1 do
    local o = t[i]
    if o:IsEmpty() then
      DoneObject(o)
      table.remove(t, i)
    end
  end
end
function CollectionsToHideContainer:PostLoad(reason)
  if reason == "undo" then
    colToRoomCache = false
    roomToColCache = false
    Msg("EditorSelectionChanged", editor.GetSel())
  end
end
DefineClass.CollectionsToHidePersistableData = {
  __parents = {"Object"},
  flags = {
    gofPermanent = true,
    efWalkable = false,
    efCollision = false,
    efApplyToGrids = false
  },
  properties = {
    {
      id = "room",
      editor = "object",
      default = false
    },
    {
      id = "West",
      editor = "objects",
      default = false
    },
    {
      id = "East",
      editor = "objects",
      default = false
    },
    {
      id = "North",
      editor = "objects",
      default = false
    },
    {
      id = "South",
      editor = "objects",
      default = false
    },
    {
      id = "Roof",
      editor = "objects",
      default = false
    }
  }
}
function CollectionsToHidePersistableData:Init()
  if not IsChangingMap() then
    table.insert(GetCollectionsToHide(), self)
  end
end
function CollectionsToHidePersistableData:Done()
  table.remove_value(GetCollectionsToHide(), self)
end
function CollectionsToHidePersistableData:ClearColTooRoomCacheForAffectedCols()
  if not colToRoomCache then
    return
  end
  for j = 1, #tMembers do
    for k = 1, #(self[tMembers[j]] or "") do
      colToRoomCache[self[tMembers[j]][k]] = nil
    end
  end
end
function CollectionsToHidePersistableData:IsEmpty()
  for i = 1, #tMembers do
    local m = self[tMembers[i]]
    if m and 0 < #m then
      return false
    end
  end
  return true
end
local printRedLine = function(count)
  for i = 1, count or 1 do
    print("<color 255 0 0>-----------------------------------------------------------------------------------------</color>")
  end
end
local printError = function(str)
  printRedLine(2)
  print(str)
  printRedLine(2)
end
local printMsg = function(str)
  printRedLine()
  print(str)
  printRedLine()
end
function CollectionsToHidePersistableData:CleanBadEntries()
  local all_cleared = true
  if not IsKindOf(self.room, "Room") then
    printError("<color 255 0 0>Found non room room in CollectionsToHidePersistableData and removed it[" .. (self.room and rawget(self.room, "name") or "") .. ", " .. (self.room and self.room.class or tostring(self.room) or "") .. "]!</color>")
    self:delete()
    return
  end
  for i = 1, #tMembers do
    local m = tMembers[i]
    local t = self[m]
    for j = #(t or ""), 1, -1 do
      local e = t[j]
      if not IsValid(e) then
        table.remove(t, j)
        printError("<color 255 0 0>Found invalid collection in CollectionsToHidePersistableData[" .. m .. ", " .. self.room.name .. "]!</color>")
      end
    end
    if t and #t <= 0 then
      self[m] = false
    end
    if self[m] then
      local room = self.room
      if m == "Roof" and not room:HasRoof() then
        printError(string.format("<color 255 0 0>Removed hook to %s's roof because the roof does not exist.</color>", room.name))
        self[m] = false
      end
      all_cleared = false
    end
  end
  if all_cleared then
    self:delete()
  end
end
CollectionsToHidePersistableData.PostLoad = CollectionsToHidePersistableData.CleanBadEntries
function OnMsg.SaveMap()
  if g_CollectionsToHideContainer then
    g_CollectionsToHideContainer:CleanBadEntries()
    if #g_CollectionsToHideContainer.contents <= 0 and not next(g_CollectionsToHideContainer.contents) then
      DoneObject(g_CollectionsToHideContainer)
      g_CollectionsToHideContainer = false
    end
  end
end
function OnMsg.GatherRoomRelatedObjects(room, objs)
  local data = GetCollectionsToHideDataForRoom(room)
  if data then
    objs[#objs + 1] = data
  end
end
local _ReadInputHelper = function(obj)
  if not IsKindOf(obj, "Slab") or IsKindOf(obj, "FloorSlab") then
    return
  end
  local r = rawget(obj, "room")
  if not r then
    return
  end
  local side
  if IsKindOfClasses(obj, "RoofSlab", "RoofWallSlab") then
    side = "Roof"
  else
    side = obj.side
  end
  return r, side
end
function LinkUnlinkCollectionToElement(collection, r, side, op)
  ClearCollectionsToHideCache(collection, r)
  rawset(collection, "hidden", nil)
  XEditorUndo:BeginOp({
    objects = {
      GetCollectionsToHideContainer()
    },
    name = string.format("Unlink collection from room %s side %s", r.name, side)
  })
  local d, c = GetCollectionsToHideDataForRoom(r)
  if (not op or op == "unlink") and d and table.remove_entry(d[side] or empty_table, collection) then
    if d:IsEmpty() then
      table.remove_entry(c, d)
      DoneObject(d)
    end
    op = "unlink"
  elseif not op or op == "link" then
    d = GetCollectionsToHideDataForRoom(r, true)
    d[side] = d[side] or {}
    table.insert_unique(d[side], collection)
    op = "link"
  end
  printMsg(string.format("%s %s %s", op == "link" and "Linking" or "Unlinking", r.name, side))
  XEditorUndo:EndOp({
    GetCollectionsToHideContainer()
  })
  return op
end
local d_call_args_show = false
local d_call_args_hide = false
local pushDelayedCollectionsToHideCall = function(args, r, side, fnHide, t)
  args = args or {}
  local k = xxhash(r.handle, side)
  args[k] = pack_params(r, side, fnHide, t)
  return args
end
function CancelDelayedCollectionProcessing(args, r, side)
  if not args then
    return
  end
  local k = xxhash(r.handle, side)
  args[k] = nil
end
function CollectionsToHideHideCollections(r, side, fnHide)
  local t = GetCollectionsToHideForRoom(r, side)
  if not t or #t <= 0 then
    return
  end
  CancelShowDelayedCollection(r, side)
  d_call_args_hide = pushDelayedCollectionsToHideCall(d_call_args_hide, r, side, fnHide, t)
end
function CancelShowDelayedCollection(r, side)
  CancelDelayedCollectionProcessing(d_call_args_show, r, side)
end
function CancelHideDelayedCollection(r, side)
  CancelDelayedCollectionProcessing(d_call_args_hide, r, side)
end
local finishCollectionsToHideProcessing = function(colls, func, edit, hide, cleanup)
  local qf
  if func then
    function qf(o)
      func(o, hide)
    end
  elseif edit then
    function qf(o)
      o:SetShadowOnlyImmediate(hide)
    end
  else
    function qf(o)
      o:SetShadowOnly(hide)
    end
  end
  if not edit then
    MapForEach("map", "collection", colls, false, qf)
  else
    MapForEach("map", "collection", colls, true, qf)
  end
  if cleanup then
    print("Found bad collections in data, running cleanup!")
    g_CollectionsToHideContainer:CleanBadEntries()
  end
end
function CollectionsToHideProcessDelayedHides()
  if not d_call_args_hide then
    return
  end
  local cleanup = false
  local edit = IsEditorActive()
  local colls = {}
  local func
  local pc = not edit and pushChildren or empty_func
  for k, params in pairs(d_call_args_hide) do
    local r, side, fnHide, t = unpack_params(params)
    func = func or fnHide
    for j = 1, #t do
      local col = t[j]
      if IsValid(col) then
        if edit or not rawget(col, "hidden") then
          colls[#colls + 1] = col.Index
          pc(col, colls)
          rawset(col, "hidden", true)
        end
      else
        cleanup = cleanup or true
      end
    end
  end
  d_call_args_hide = false
  if #colls <= 0 then
    return
  end
  finishCollectionsToHideProcessing(colls, func, edit, true, cleanup)
end
local ShouldStillShowCollection = function(col)
  local data = GetRoomDataForCollection(col)
  for room, sides in pairs(data or empty_table) do
    for j = 1, #sides do
      if not IsElementVisible(room, sides[j]) then
        return false
      end
    end
  end
  return true
end
function CollectionsToHideProcessDelayedShows()
  if not d_call_args_show then
    return
  end
  local cleanup = false
  local edit = IsEditorActive()
  local colls = {}
  local func
  local pc = not edit and pushChildren or empty_func
  for k, params in pairs(d_call_args_show) do
    local r, side, fnHide, t = unpack_params(params)
    func = func or fnHide
    for j = 1, #t do
      local col = t[j]
      if IsValid(col) then
        if (edit or rawget(col, "hidden")) and ShouldStillShowCollection(col) then
          colls[#colls + 1] = col.Index
          pc(col, colls)
          rawset(col, "hidden", nil)
        end
      else
        cleanup = cleanup or true
      end
    end
  end
  d_call_args_show = false
  if #colls <= 0 then
    return
  end
  finishCollectionsToHideProcessing(colls, func, edit, false, cleanup)
end
function IsElementVisible(r, side)
  local cd = VT2CollapsedWalls and VT2CollapsedWalls[r]
  if cd and (side == "Roof" and next(cd) or side ~= "Roof" and cd[side] == "full" and r.size:z() > 1) then
    return false
  end
  if not cd and side == "Roof" and not r.is_roof_visible then
    return false
  end
  local bld = r.building
  local f = VT2TouchedBuildings and VT2TouchedBuildings[bld]
  if f and f < r.floor then
    return false
  end
  return true
end
function CollectionsToHideShowCollections(r, side, fnHide)
  local t = GetCollectionsToHideForRoom(r, side)
  if not t or #t <= 0 then
    return
  end
  CancelHideDelayedCollection(r, side)
  d_call_args_show = pushDelayedCollectionsToHideCall(d_call_args_show, r, side, fnHide, t)
end
function OnMsg.GameEnterEditor()
  d_call_args_show = false
  d_call_args_hide = false
end
function CollectionsToHide_GetCollectionVisibilityState(col)
  local t2 = GetRoomDataForCollection(col)
  for room, t3 in pairs(t2 or empty_table) do
    for j = 1, #t3 do
      if not IsElementVisible(room, t3[j]) then
        goto lbl_25
      end
    end
    return true
  end
  ::lbl_25::
end
local PutInTHelper = function(cols, col)
  if col then
    cols = cols or {}
    cols[col] = true
  end
  return cols
end
function ExtractCollectionsFromObjs(objs)
  local cols
  for i = 1, #(objs or "") do
    local obj = objs[i]
    if IsValid(obj) then
      cols = PutInTHelper(cols, obj:GetRootCollection())
      cols = PutInTHelper(cols, obj:GetCollection())
    end
  end
  return cols
end
function OnMsg.CollectionDeleted(col)
  CollectionsToHideDeletionHandlerHelper({
    [col] = true
  })
end
function OnMsg.EditorCallback(id, objs, replace)
  if id == "EditorCallbackDelete" and not replace then
    local cols, rooms
    for i = 1, #(objs or "") do
      local obj = objs[i]
      if IsValid(obj) then
        cols = PutInTHelper(cols, obj:GetRootCollection())
        cols = PutInTHelper(cols, obj:GetCollection())
        if IsKindOf(obj, "Room") then
          rooms = rooms or {}
          rooms[obj] = true
        end
      end
    end
    local isCollectionEmptyNow = function(col)
      local ret = true
      MapForEach("map", "collection", col.Index, true, function(o, objs)
        if not table.find(objs, o) then
          ret = false
          return "break"
        end
      end, objs)
      return ret
    end
    for col, _ in pairs(cols or empty_table) do
      if not isCollectionEmptyNow(col) then
        cols[col] = nil
      end
    end
    CollectionsToHideDeletionHandlerHelper(cols, rooms)
  end
end
function CollectionsToHideDeletionHandlerHelper(cols, rooms)
  if (not cols or not next(cols)) and (not rooms or not next(rooms)) then
    return
  end
  roomToColCache = false
  colToRoomCache = false
  XEditorUndo:BeginOp({
    objects = {
      GetCollectionsToHideContainer()
    },
    name = "Linked objects' deletion"
  })
  local allData = GetCollectionsToHide()
  for col, _ in pairs(cols or empty_table) do
    for i = #allData or "", 1, -1 do
      local d = allData[i]
      for j = 1, #tMembers do
        local idx = table.find(d[tMembers[j]] or empty_table, col)
        if idx then
          printError(string.format("<color 255 144 0>Removing CollectionsToHidePersistableData hook to collection from delete handler (collection deleted)[%s, %s]!</color>", d.room and d.room.name or tostring(d.room), tMembers[j]))
          table.remove(d[tMembers[j]], idx)
          if #d[tMembers[j]] <= 0 then
            d[tMembers[j]] = false
            printError(string.format("<color 255 144 0>CollectionsToHidePersistableData hook empty on side, removing[%s]!</color>", tMembers[j]))
          end
        end
      end
      if d:IsEmpty() then
        DoneObject(d)
        table.remove(allData, i)
        printError(string.format("<color 255 144 0>CollectionsToHidePersistableData hook empty, removing[%s]!</color>", d.room and d.room.name or tostring(d.room)))
      end
    end
  end
  for room, _ in pairs(rooms or empty_table) do
    local idx = table.find(allData or empty_table, "room", room)
    if idx then
      local d = allData[idx]
      DoneObject(d)
      table.remove(allData, idx)
      printError(string.format("<color 255 144 0>Clearing CollectionsToHidePersistableData hook - room deleted[%s]!</color>", d.room and d.room.name or tostring(d.room)))
    end
  end
  XEditorUndo:EndOp({
    GetCollectionsToHideContainer()
  })
end
local RefreshCollectionHidingVisuals = function(selection)
  selection = selection or editor.GetSel()
  for i = #(CollectionsToHideVisualMeshes or ""), 1, -1 do
    DoneObject(CollectionsToHideVisualMeshes[i])
    CollectionsToHideVisualMeshes[i] = nil
  end
  CollectionsToHideVisualMeshes = false
  if CollectionsToHideVisuals then
    local cleanup = false
    local cols = ExtractCollectionsFromObjs(selection)
    for col, _ in pairs(cols or empty_table) do
      local d = GetRoomDataForCollection(col)
      for room, sides in pairs(d or empty_table) do
        CollectionsToHideVisualMeshes = CollectionsToHideVisualMeshes or {}
        for j = 1, #sides do
          local s = sides[j]
          if s == "Roof" then
            if room:HasRoof() and room.roof_box then
              table.insert(CollectionsToHideVisualMeshes, PlaceBox(room.roof_box:grow(voxelSizeX, voxelSizeY, voxelSizeZ), RGB(255, 0, 0)))
            else
              cleanup = true
            end
          else
            local b = room:GetWallBox(s):grow(voxelSizeX, voxelSizeY, voxelSizeZ)
            table.insert(CollectionsToHideVisualMeshes, PlaceBox(b, RGB(255, 0, 0)))
          end
        end
      end
    end
    if cleanup then
      print("Found bad entries in data, running cleanup!")
      g_CollectionsToHideContainer:CleanBadEntries()
    end
  end
end
function OnMsg.EditorSelectionChanged(selection)
  RefreshCollectionHidingVisuals(selection)
end
function StartAssignElementToCollection()
  print("deprecated")
end
DefineClass.XCollectionHidingTool = {
  __parents = {
    "XEditorTool"
  },
  ToolTitle = "Link collection to wall",
  ToolSection = "Misc",
  Description = {
    "Click on a wall slab to link the selected collection(s) to the wall, so that they are hidden together.",
    "(click again to unlink)"
  },
  ActionSortKey = "2",
  ActionIcon = "CommonAssets/UI/Editor/Tools/LinkToWall.tga",
  ActionShortcut = "C",
  ActionMode = "Editor",
  ToolKeepSelection = true,
  time_activated = false,
  selected_collections = false
}
function XCollectionHidingTool:Init()
  self.time_activated = now()
  self:SetCollectionsHelper(editor.GetSel())
end
function XCollectionHidingTool:CheckStartOperation(pt)
end
function XCollectionHidingTool:SetCollectionsHelper(selection)
  self.selected_collections = ExtractCollectionsFromObjs(selection) or false
end
function XCollectionHidingTool:OnShortcut(shortcut, source, repeated)
  local released1 = string.format("-%s", self.ActionShortcut)
  local released2 = string.format("-%s", self.ActionShortcut2)
  if shortcut == self.ActionShortcut or shortcut == self.ActionShortcut2 then
    return "break"
  elseif (shortcut == released1 or shortcut == released2) and now() - self.time_activated > 100 then
    XEditorSetDefaultTool()
    return "break"
  end
end
function XCollectionHidingTool:OnMouseButtonDown(pt, button)
  if button == "L" then
    local updateSelection = false
    local cols = self.selected_collections
    if cols and next(cols) then
      local so = GetObjectAtCursor()
      local didWork
      if IsValid(so) and IsKindOf(so, "Slab") and not IsKindOf(so, "FloorSlab") then
        local slabs = MapGet(so, 0, "Slab", function(o)
          return not IsKindOf(o, "FloorSlab")
        end)
        local op
        for i, lo in ipairs(slabs) do
          if IsValid(lo) then
            local r, side = _ReadInputHelper(lo)
            if r then
              for col in pairs(cols) do
                op = LinkUnlinkCollectionToElement(col, r, side, op)
              end
              didWork = true
            end
          end
        end
      end
      if not didWork then
        updateSelection = true
      else
        RefreshCollectionHidingVisuals()
        local isCHeld = terminal.IsKeyPressed(const.vkC)
        if not isCHeld then
          XEditorSetDefaultTool()
        end
      end
    else
      updateSelection = true
    end
    if updateSelection then
      local o = GetObjectAtCursor()
      local sel = editor.SelectionPropagate({o})
      editor.SetSel(sel)
      self:SetCollectionsHelper(sel)
    end
  end
end
function OnMsg.GameExitEditor()
  HideFloorsAbove(999)
  MapForEach("map", "collected", true, function(obj)
    local col = obj:GetCollection()
    if col and rawget(col, "hidden") then
      obj:SetShadowOnly(true)
    end
  end)
end
function OnMsg.FloorsHiddenAbove(floor, fnHide)
  SuspendPassEdits("HidingCollectionsAndObjects")
  local c = GetCollectionsToHide()
  for i = 1, #c do
    local r = c[i].room
    if floor >= r.floor then
      for j = 1, #tMembers do
        CollectionsToHideShowCollections(r, tMembers[j], fnHide)
      end
    else
      for j = 1, #tMembers do
        CollectionsToHideHideCollections(r, tMembers[j], fnHide)
      end
    end
  end
  CollectionsToHideProcessDelayedHides()
  CollectionsToHideProcessDelayedShows()
  EnumVolumes(function(r, floor)
    HideShowRoomObjects(r, floor < r.floor, "inEditor", fnHide)
  end, floor)
  ResumePassEdits("HidingCollectionsAndObjects")
end
