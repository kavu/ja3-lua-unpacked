XEditorCopyScriptTag = "--[[HGE place script 2.0]]"
if FirstLoad then
  XEditorUndo = false
  EditorMapDirty = false
  EditorDirtyObjects = false
  EditorSelectionInProgress = false
end
function SetEditorMapDirty(dirty)
  EditorMapDirty = dirty
  if dirty then
    Msg("EditorMapDirty")
  end
end
function OnMsg.ChangeMap()
  XEditorUndo = XEditorUndoQueue:new()
  SetEditorMapDirty(false)
end
function OnMsg.GameEnteringEditor()
  XEditorUndo = XEditorUndo or XEditorUndoQueue:new()
end
function OnMsg.GedPropertyEdited(ged, obj, prop_id, old_value)
  if IsKindOf(obj, "CObject") then
    SetEditorMapDirty(true)
  end
end
function OnMsg.SaveMapDone()
  SetEditorMapDirty(false)
end
local s_IsEditorObjectOperation = {
  EditorCallbackMove = true,
  EditorCallbackRotate = true,
  EditorCallbackScale = true,
  EditorCallbackClone = true
}
function OnMsg.EditorCallback(id, objects)
  if s_IsEditorObjectOperation[id] then
    Msg("EditorObjectOperation", false, objects)
  end
end
local ef_to_restore = const.efVisible | const.efCollision | const.efApplyToGrids
local gf_to_restore = const.gofPermanent | const.gofMirrored
local ef_to_ignore = const.efSelectable | const.efAudible
local gf_to_ignore = const.gofEditorHighlight | const.gofSolidShadow | const.gofRealTimeAnim | const.gofEditorSelection | const.gofAnimated
DefineClass.XEditorUndoQueue = {
  __parents = {"InitDone"},
  last_handle = 0,
  obj_to_handle = false,
  handle_to_obj = false,
  handle_remap = false,
  op_stack = false,
  undo_queue = false,
  undo_index = 0,
  names_index = 1,
  names_to_queue_idx_map = false,
  watch_thread = false,
  undoredo_in_progress = false,
  update_collections_thread = false
}
function XEditorUndoQueue:Init()
  self.obj_to_handle = {}
  self.handle_to_obj = {}
  self.op_stack = {}
  self.undo_queue = {}
  self.names_to_queue_idx_map = {}
  self.watch_thread = CreateRealTimeThread(function()
    while true do
      if #self.op_stack == 0 or terminal.desktop:GetMouseCapture() then
        Sleep(250)
      else
        self.op_stack = {}
        Sleep(250)
      end
    end
  end)
end
function XEditorUndoQueue:Done()
  DeleteThread(self.watch_thread)
end
function XEditorUndoQueue:GetUndoRedoHandle(obj)
  local handle = self.obj_to_handle[obj]
  if not handle then
    handle = self.last_handle + 1
    self.last_handle = handle
    self.obj_to_handle[obj] = handle
    self.handle_to_obj[handle] = obj
  end
  return handle
end
function XEditorUndoQueue:GetUndoRedoObject(handle, is_collection)
  if not handle then
    return false
  end
  local obj = self.handle_to_obj[handle]
  if self.handle_remap then
    local new_handle = self.handle_remap[handle]
    if new_handle then
      return self.handle_to_obj[new_handle]
    else
      self.handle_remap[handle] = self.last_handle + 1
      handle = self.last_handle + 1
      self.last_handle = handle
      obj = nil
    end
  end
  if not obj then
    obj = {}
    self.handle_to_obj[handle] = obj
    self.obj_to_handle[obj] = handle
    if is_collection then
      Collection.SetIndex(obj, -1)
    end
  end
  return obj
end
function XEditorUndoQueue:UndoRedoHandleClear(handle)
  local obj = self.handle_to_obj[handle]
  self.handle_to_obj[handle] = nil
  self.obj_to_handle[obj] = nil
end
local function store_objects_prop(value)
  if not value then
    return false
  end
  local ret = {}
  for k, v in pairs(value) do
    ret[k] = IsValid(v) and XEditorUndo:GetUndoRedoHandle(v) or store_objects_prop(v)
  end
  return ret
end
local function restore_objects_prop(value)
  if not value then
    return false
  end
  local ret = {}
  for k, v in pairs(value) do
    ret[k] = type(v) == "table" and restore_objects_prop(v) or XEditorUndo:GetUndoRedoObject(v)
  end
  return ret
end
function XEditorUndoQueue:GetObjectData(obj)
  local data = {
    __undo_handle = self:GetUndoRedoHandle(obj),
    class = obj.class
  }
  for _, prop_meta in ipairs(obj:GetProperties()) do
    local id = prop_meta.id
    local value = obj:GetProperty(id)
    if not obj:ShouldCleanPropForSave(id, prop_meta, value) then
      local editor = prop_meta.editor
      if id == "CollectionIndex" then
        data[id] = self:GetUndoRedoHandle(obj:GetCollection())
      elseif editor == "objects" then
        data[id] = store_objects_prop(value)
      elseif editor == "object" then
        data[id] = self:GetUndoRedoHandle(value)
      elseif editor == "nested_list" then
        data[id] = value and {}
        for i, o in ipairs(value) do
          data[id][i] = o:Clone()
        end
      elseif editor == "nested_obj" or editor == "script" then
        data[id] = value and value:Clone()
      elseif editor == "grid" and value then
        data[id] = value:clone()
      else
        data[id] = value
      end
    end
  end
  data.eFlags = band(obj:GetEnumFlags(), ef_to_restore)
  data.gFlags = band(obj:GetGameFlags(), gf_to_restore)
  return data
end
local get_flags_xor = function(flags1, flags2, flagsList)
  local result = {}
  for i, flag in pairs(flagsList) do
    if flag ~= "gofDirtyTransform" and flag ~= "gofDirtyVisuals" and flag ~= "gofEditorSelection" and band(flags1, shift(1, i - 1)) ~= band(flags2, shift(1, i - 1)) then
      table.insert(result, flag.name or flag)
    end
  end
  return table.concat(result, ", ")
end
function XEditorUndoQueue:RestoreObject(obj, obj_data, prev_data)
  if not IsValid(obj) then
    return
  end
  for _, prop_meta in ipairs(obj:GetProperties()) do
    local id = prop_meta.id
    local value = obj_data[id]
    if value == nil and prev_data and prev_data[id] then
      value = obj:GetDefaultPropertyValue(id, prop_meta)
    end
    if value ~= nil then
      local prop = prop_meta.editor
      if id == "CollectionIndex" then
        if value == 0 then
          CObject.SetCollectionIndex(obj, 0)
        else
          local collection = self:GetUndoRedoObject(value, "Collection")
          if obj_data.class == "Collection" and collection.Index == editor.GetLockedCollectionIdx() then
            editor.AddToLockedCollectionIdx(obj.Index)
          end
          CObject.SetCollectionIndex(obj, collection.Index)
        end
      elseif prop == "objects" then
        obj:SetProperty(id, restore_objects_prop(value))
      elseif prop == "object" then
        obj:SetProperty(id, self:GetUndoRedoObject(value))
      elseif prop == "nested_list" then
        local objects = {}
        for i, o in ipairs(value) do
          objects[i] = o:Clone()
        end
        obj:SetProperty(id, value and objects)
      elseif prop == "nested_obj" then
        obj:SetProperty(id, value and value:Clone())
      else
        obj:SetProperty(id, value)
      end
    end
  end
  obj:SetEnumFlags(obj_data.eFlags)
  obj:ClearEnumFlags(band(bnot(obj_data.eFlags), ef_to_restore))
  obj:SetGameFlags(obj_data.gFlags)
  obj:ClearGameFlags(band(bnot(obj_data.gFlags), gf_to_restore))
  obj:ClearGameFlags(const.gofEditorHighlight)
  return obj
end
local add_child_objects = function(objects, method, param)
  local added = {}
  for _, obj in ipairs(objects) do
    added[obj] = true
  end
  for _, obj in ipairs(objects) do
    for _, related in ipairs(obj[method or "GetEditorRelatedObjects"](obj, param)) do
      if IsValid(related) and not added[related] then
        objects[#objects + 1] = related
        added[related] = true
      end
    end
  end
end
local add_parent_objects = function(objects, for_copy, locked_collection)
  local added = {}
  for _, obj in ipairs(objects) do
    added[obj] = true
  end
  local i = 1
  while i <= #objects do
    local obj = objects[i]
    local parent = obj:GetEditorParentObject()
    if not for_copy and IsValid(parent) and not added[parent] then
      objects[#objects + 1] = parent
      added[parent] = true
    end
    local collection = obj:GetCollection()
    if IsValid(collection) and collection ~= locked_collection and not added[collection] then
      objects[#objects + 1] = collection
      added[collection] = true
    end
    i = i + 1
  end
end
local add_obj_data = function(data, obj_data)
  if obj_data.class == "Collection" then
    table.insert(data, 1, obj_data)
  else
    data[#data + 1] = obj_data
  end
end
function XEditorUndoQueue:BeginOp(settings)
  if not IsEditorActive() or self.undoredo_in_progress then
    return
  end
  PauseInfiniteLoopDetection("Undo")
  if settings then
    if settings.objects then
      settings.objects = table.copy_valid(settings.objects)
      add_child_objects(settings.objects)
      add_parent_objects(settings.objects)
      EditorDirtyObjects = settings.objects
    end
    EditorSelectionInProgress = settings.selection and not settings.edit_op or false
    if EditorDirtyObjects and #EditorDirtyObjects > 0 then
      Msg("EditorObjectOperation", false, EditorDirtyObjects)
    end
  end
  settings = settings or empty_table
  local edit_operation = {
    clipboard = settings.clipboard
  }
  if settings.objects then
    local data, by_handle = {}, {}
    for _, obj in ipairs(settings.objects) do
      local obj_data = self:GetObjectData(obj)
      obj_data.op = "delete"
      by_handle[obj_data.__undo_handle] = obj_data
      add_obj_data(data, obj_data)
    end
    edit_operation.objects = ObjectsEditOp:new({data = data, by_handle = by_handle})
  end
  edit_operation.selection = SelectionEditOp:new()
  for i, obj in ipairs(editor.GetSel()) do
    edit_operation.selection.before[i] = self:GetUndoRedoHandle(obj)
  end
  for _, grid in ipairs(editor.GetGridNames()) do
    if settings[grid] then
      edit_operation[grid] = GridEditOp:new({
        name = grid,
        before = editor.GetGrid(grid)
      })
    end
  end
  edit_operation.name = edit_operation.name or settings.name
  self.op_stack[#self.op_stack + 1] = edit_operation
  ResumeInfiniteLoopDetection("Undo")
end
function XEditorUndoQueue:EndOp(objects, bbox)
  if not IsEditorActive() or self.undoredo_in_progress then
    return
  end
  local edit_operation = self.op_stack[#self.op_stack]
  if not edit_operation then
    return
  end
  PauseInfiniteLoopDetection("Undo")
  if objects and objects[1] then
    objects = table.copy_valid(objects)
    add_child_objects(objects)
    EditorDirtyObjects = table.union(objects or {}, table.validate(EditorDirtyObjects or empty_table))
    if not edit_operation.objects then
      edit_operation.objects = ObjectsEditOp:new({
        data = {},
        by_handle = {}
      })
    end
    local data = edit_operation.objects.data
    local by_handle = edit_operation.objects.by_handle
    for _, obj in ipairs(objects) do
      local obj_data = self:GetObjectData(obj)
      local handle = obj_data.__undo_handle
      local old_data = by_handle[handle]
      if old_data then
        if old_data.op == "create" then
          table.clear(old_data)
          for k, v in pairs(obj_data) do
            old_data[k] = v
          end
          old_data.op = "create"
        else
          old_data.op = "update"
          old_data.after = obj_data
        end
      else
        obj_data.op = "create"
        by_handle[handle] = obj_data
        add_obj_data(data, obj_data)
      end
    end
    local old_len = #objects
    add_parent_objects(objects)
    for i = old_len + 1, #objects do
      local obj = objects[i]
      local obj_data = self:GetObjectData(obj)
      local handle = obj_data.__undo_handle
      local old_data = by_handle[handle]
      if old_data then
        old_data.op = "update"
        old_data.after = obj_data
      else
        obj_data.op = "related"
        by_handle[handle] = obj_data
        add_obj_data(data, obj_data)
      end
    end
  end
  if edit_operation.selection then
    local selDiff = #editor.GetSel() ~= #edit_operation.selection.before
    for i, obj in ipairs(editor.GetSel()) do
      edit_operation.selection.after[i] = self:GetUndoRedoHandle(obj)
      if edit_operation.selection.after[i] ~= edit_operation.selection.before[i] then
        selDiff = true
      end
    end
    if not selDiff then
      edit_operation.selection:delete()
      edit_operation.selection = nil
    end
  end
  for _, grid in ipairs(editor.GetGridNames()) do
    local grid_op = edit_operation[grid]
    if grid_op then
      local before, after = grid_op.before, editor.GetGrid(grid)
      grid_op.after, grid_op.before, grid_op.box = editor.GetGridDifference(grid, after, before, bbox)
      before:free()
      after:free()
    end
  end
  local parent_op = self.op_stack[#self.op_stack - 1]
  if parent_op then
    if edit_operation.objects then
      if not parent_op.objects then
        parent_op.objects = ObjectsEditOp:new({
          data = {},
          by_handle = {}
        })
      end
      if not parent_op.name then
        parent_op.name = edit_operation.name
      end
      local data = parent_op.objects.data
      local by_handle = parent_op.objects.by_handle
      for _, obj_data in ipairs(edit_operation.objects.data) do
        local op = obj_data.op
        local handle = obj_data.__undo_handle
        local old_data = by_handle[handle]
        if not old_data then
          by_handle[handle] = obj_data
          add_obj_data(data, obj_data)
        elseif op == "delete" then
          if old_data.op ~= "delete" then
            by_handle[handle] = nil
            table.remove_value(data, old_data)
          end
        elseif old_data.op == "create" or old_data.op == "related" then
          local h = old_data.__undo_handle
          local op = old_data.op
          table.clear(old_data)
          for k, v in pairs(obj_data.after or obj_data) do
            old_data[k] = v
          end
          old_data.op = op
          old_data.__undo_handle = h
        elseif old_data.op == "update" then
          old_data.after = obj_data
        end
      end
    end
    if edit_operation.selection then
      if not parent_op.selection then
        parent_op.selection = SelectionEditOp:new()
        parent_op.selection.before = edit_operation.selection.before
        parent_op.selection.after = edit_operation.selection.after
      else
        parent_op.selection.after = edit_operation.selection.after
      end
    end
    parent_op.clipboard = parent_op.clipboard or edit_operation.clipboard
    self.op_stack[#self.op_stack] = nil
    self.op_stack[#self.op_stack] = parent_op
    ResumeInfiniteLoopDetection("Undo")
    return
  end
  local objs_op = edit_operation.objects
  if objs_op then
    local objs_data = objs_op.data
    for i = #objs_data, 1, -1 do
      local obj_data = objs_data[i]
      local obj_handle = obj_data.__undo_handle
      if not IsValid(self:GetUndoRedoObject(obj_handle)) then
        local op = obj_data.op
        if op == "delete" then
          self:UndoRedoHandleClear(obj_handle)
        elseif op == "create" then
          table.remove(objs_data, i)
        else
          self:UndoRedoHandleClear(obj_handle)
          obj_data.op = "delete"
          obj_data.after = nil
        end
      end
    end
    edit_operation.objects.by_handle = nil
  end
  self.op_stack = {}
  self.undo_index = self.undo_index + 1
  self.undo_queue[self.undo_index] = edit_operation
  edit_operation = nil
  local queueSize = #self.undo_queue
  for i = self.undo_index + 1, queueSize do
    self.undo_queue[i] = nil
  end
  if EditorDirtyObjects and #EditorDirtyObjects > 0 then
    Msg("EditorObjectOperation", true, table.validate(EditorDirtyObjects))
  end
  EditorDirtyObjects = false
  EditorSelectionInProgress = false
  self:UpdateOnOperationEnd(edit_operation)
  ResumeInfiniteLoopDetection("Undo")
end
function XEditorUndoQueue:UndoRedo(op_type)
  local undo = op_type == "undo"
  local edit_op = undo and self.undo_queue[self.undo_index] or self.undo_queue[self.undo_index + 1]
  if not edit_op then
    return
  end
  self.undo_index = undo and self.undo_index - 1 or self.undo_index + 1
  if self.undo_index < 0 or self.undo_index > #self.undo_queue then
    self.undo_index = Clamp(self.undo_index, 0, #self.undo_queue)
    return
  end
  self.undoredo_in_progress = true
  SuspendPassEditsForEditOp(edit_op.objects and edit_op.objects.data or empty_table)
  PauseInfiniteLoopDetection("XEditorEditOps")
  for _, op in sorted_pairs(edit_op) do
    if IsKindOf(op, "EditOp") then
      procall(undo and op.Undo or op.Do, op)
    end
  end
  if edit_op.clipboard then
    CopyToClipboard(edit_op.clipboard)
  end
  self:UpdateOnOperationEnd(edit_op)
  ResumeInfiniteLoopDetection("XEditorEditOps")
  ResumePassEditsForEditOp()
  self.undoredo_in_progress = false
end
function XEditorUndoQueue:UpdateOnOperationEnd(edit_operation)
  for key in pairs(edit_operation) do
    if key ~= "selection" and key ~= "clipboard" then
      SetEditorMapDirty(true)
    end
  end
  XEditorUpdateToolbars()
  if not self.update_collections_thread then
    self.update_collections_thread = CreateRealTimeThread(function()
      Sleep(1000)
      Collection.DestroyEmpty()
      UpdateCollectionsEditor()
      self.update_collections_thread = false
    end)
  end
end
function XEditorUndoQueue:GetOpNames(plain)
  local names = {
    "No operations"
  }
  local idx_map = {0}
  local cur_op_passed, cur_op_idx = false, false
  for i = 1, #self.undo_queue do
    local cur = self.undo_queue[i] and self.undo_queue[i].name
    cur_op_passed = cur_op_passed or i == self.undo_index + 1
    if cur then
      local prev = names[#names]
      if prev and string.ends_with(prev, cur) and not cur_op_passed then
        local n = (tonumber(string.match(prev, "%s(%d+)[^%s%d]")) or 1) + 1
        cur = string.format("%d. %dX %s", #names - 1, n, cur)
        names[#names] = cur
        idx_map[#idx_map] = i
      else
        if cur_op_passed then
          cur_op_idx = #idx_map
          cur_op_passed = false
        end
        table.insert(names, string.format("%d. %s", #names, cur))
        table.insert(idx_map, i)
      end
    end
  end
  if not plain then
    self.names_to_queue_idx_map = idx_map
    self.names_index = cur_op_idx or Max(#idx_map, 1)
    for i = self.names_index + 1, #names do
      names[i] = "<color 96 96 96>" .. names[i] .. "</color>"
    end
  end
  return names
end
function XEditorUndoQueue:GetCurrentOpNameIdx()
  return self.names_index
end
function XEditorUndoQueue:RollToOpIndex(new_index)
  if new_index ~= self.names_index then
    local new_undo_index = self.names_to_queue_idx_map[new_index]
    local op = new_undo_index < self.undo_index and "undo" or "redo"
    while self.undo_index ~= new_undo_index do
      self:UndoRedo(op)
    end
    self.names_index = new_index
  end
end
DefineClass.EditOp = {
  __parents = {"InitDone"}
}
function EditOp:Do()
end
function EditOp:Undo()
end
DefineClass.ObjectsEditOp = {
  __parents = {"EditOp"},
  data = false,
  by_handle = false
}
function ObjectsEditOp:EditorCallbackPreUndoRedo()
  local objs = {}
  for _, obj_data in ipairs(self.data) do
    local handle = obj_data.__undo_handle
    local obj = XEditorUndo:GetUndoRedoObject(handle)
    table.insert(objs, obj)
  end
  Msg("EditorCallbackPreUndoRedo", table.validate(objs))
end
function ObjectsEditOp:Do()
  self:EditorCallbackPreUndoRedo()
  local newobjs = {}
  local oldobjs = {}
  local movedobjs = {}
  for _, obj_data in ipairs(self.data) do
    local op = obj_data.op
    local handle = obj_data.__undo_handle
    local obj = XEditorUndo:GetUndoRedoObject(handle)
    if op == "delete" then
      XEditorUndo:UndoRedoHandleClear(handle)
      oldobjs[#oldobjs + 1] = obj
    elseif op == "create" then
      obj = XEditorPlaceObjectByClass(obj_data.class, obj)
      XEditorUndo:RestoreObject(obj, obj_data)
      newobjs[#newobjs + 1] = obj
    elseif op == "related" then
      XEditorUndo:RestoreObject(obj, obj_data)
    else
      XEditorUndo:RestoreObject(obj, obj_data.after, obj_data)
      if obj_data.after and obj_data.Pos ~= obj_data.after.Pos then
        movedobjs[#movedobjs + 1] = obj
      end
    end
  end
  for _, obj_data in ipairs(self.data) do
    if obj_data.op ~= "delete" then
      local obj = XEditorUndo:GetUndoRedoObject(obj_data.__undo_handle)
      if IsValid(obj) and obj:HasMember("PostLoad") then
        obj:PostLoad("undo")
      end
    end
  end
  Msg("EditorCallback", "EditorCallbackPlace", table.validate(newobjs))
  Msg("EditorCallback", "EditorCallbackDelete", table.validate(oldobjs))
  Msg("EditorCallback", "EditorCallbackMove", table.validate(movedobjs))
  for _, obj in ipairs(oldobjs) do
    DoneObject(obj)
  end
end
function ObjectsEditOp:Undo()
  self:EditorCallbackPreUndoRedo()
  local newobjs = {}
  local oldobjs = {}
  local movedobjs = {}
  for _, obj_data in ipairs(self.data) do
    local op = obj_data.op
    local handle = obj_data.__undo_handle
    local obj = XEditorUndo:GetUndoRedoObject(handle)
    if op == "delete" then
      obj = XEditorPlaceObjectByClass(obj_data.class, obj)
      XEditorUndo:RestoreObject(obj, obj_data)
      newobjs[#newobjs + 1] = obj
    elseif op == "create" then
      XEditorUndo:UndoRedoHandleClear(handle)
      oldobjs[#oldobjs + 1] = obj
    else
      XEditorUndo:RestoreObject(obj, obj_data, obj_data.after)
      if obj_data.after and obj_data.Pos ~= obj_data.after.Pos then
        movedobjs[#movedobjs + 1] = obj
      end
    end
  end
  for _, obj_data in ipairs(self.data) do
    if obj_data.op ~= "create" then
      local obj = XEditorUndo:GetUndoRedoObject(obj_data.__undo_handle)
      if IsValid(obj) and obj:HasMember("PostLoad") then
        obj:PostLoad("undo")
      end
    end
  end
  Msg("EditorCallback", "EditorCallbackPlace", table.validate(newobjs))
  Msg("EditorCallback", "EditorCallbackDelete", table.validate(oldobjs))
  Msg("EditorCallback", "EditorCallbackMove", table.validate(movedobjs))
  for _, obj in ipairs(oldobjs) do
    DoneObject(obj)
  end
end
DefineClass.SelectionEditOp = {
  __parents = {"EditOp"},
  before = false,
  after = false
}
function SelectionEditOp:Init()
  self.before = {}
  self.after = {}
end
function SelectionEditOp:Do()
  editor.SetSel(table.map(self.after, function(handle)
    return XEditorUndo:GetUndoRedoObject(handle)
  end))
end
function SelectionEditOp:Undo()
  editor.SetSel(table.map(self.before, function(handle)
    return XEditorUndo:GetUndoRedoObject(handle)
  end))
end
DefineClass.GridEditOp = {
  __parents = {"EditOp"},
  name = false,
  before = false,
  after = false,
  box = false
}
function GridEditOp:Do()
  editor.SetGrid(self.name, self.after, self.box)
  if self.name == "height" then
    Msg("EditorHeightChanged", true, self.box)
  end
  if self.name == "terrain_type" then
    Msg("EditorTerrainTypeChanged", self.box)
  end
end
function GridEditOp:Undo()
  editor.SetGrid(self.name, self.before, self.box)
  if self.name == "height" then
    Msg("EditorHeightChanged", true, self.box)
  end
  if self.name == "terrain_type" then
    Msg("EditorTerrainTypeChanged", self.box)
  end
end
function XEditorSerialize(objs, root_collection)
  local obj_data = {}
  local org_count = #objs
  objs = table.copy(objs)
  add_child_objects(objs)
  add_parent_objects(objs, "for_copy", root_collection)
  table.remove_value(objs, root_collection)
  Msg("EditorPreSerialize", objs)
  PauseInfiniteLoopDetection("XEditorSerialize")
  for idx, obj in ipairs(objs) do
    local data = XEditorUndo:GetObjectData(obj)
    if obj.class == "Collection" then
      data.Index = -1
    end
    if obj:GetCollection() == root_collection or XEditorSelectSingleObjects == 1 then
      data.CollectionIndex = nil
    end
    data.__original_object = org_count >= idx or nil
    add_obj_data(obj_data, data)
  end
  ResumeInfiniteLoopDetection("XEditorSerialize")
  Msg("EditorPostSerialize", objs)
  return {obj_data = obj_data}
end
function XEditorDeserialize(data, root_collection, ...)
  PauseInfiniteLoopDetection("XEditorPaste")
  SuspendPassEditsForEditOp(data.obj_data)
  XEditorUndo:BeginOp()
  XEditorUndo.handle_remap = {}
  local objs, orig_objs = {}, {}
  for _, obj_data in ipairs(data.obj_data) do
    local obj = XEditorUndo:GetUndoRedoObject(obj_data.__undo_handle)
    obj = XEditorPlaceObjectByClass(obj_data.class, obj)
    obj = XEditorUndo:RestoreObject(obj, obj_data)
    if root_collection and not obj:GetCollection() then
      obj:SetCollection(root_collection)
    end
    objs[#objs + 1] = obj
    if obj_data.__original_object then
      orig_objs[#orig_objs + 1] = obj
    end
  end
  for _, obj in ipairs(objs) do
    if obj:HasMember("PostLoad") then
      obj:PostLoad("paste")
    end
  end
  Msg("EditorCallback", "EditorCallbackPlace", table.validate(table.copy(orig_objs)), ...)
  XEditorUndo.handle_remap = nil
  XEditorUndo:EndOp(table.validate(objs))
  ResumePassEditsForEditOp()
  ResumeInfiniteLoopDetection("XEditorPaste")
  return orig_objs
end
function XEditorToClipboardFormat(data)
  return ValueToLuaCode(data, nil, pstr(XEditorCopyScriptTag, 32768)):str()
end
function XEditorPaste(lua_code)
  local err, data = LuaCodeToTuple(lua_code, LuaValueEnv({
    GridReadStr = GridReadStr
  }))
  if err or type(data) ~= "table" or not data.obj_data then
    print("Error restoring objects:", err)
    return
  end
  local fn = data.paste_fn or "Default"
  if not XEditorPasteFuncs[fn] then
    print("Error restoring objects: invalid paste function ", fn)
    return
  end
  procall(XEditorPasteFuncs[fn], data, lua_code, "paste")
end
function XEditorPasteFuncs.Default(data, lua_code, ...)
  XEditorUndo:BeginOp({name = "Paste"})
  local objs = XEditorDeserialize(data, Collection.GetLockedCollection(), ...)
  local place = editor.GetPlacementPoint(GetTerrainCursor())
  local offs = (place:IsValidZ() and place or place:SetTerrainZ()) - data.pivot
  objs = XEditorSelectAndMoveObjects(objs, offs)
  table.find_value(XEditorUndo.op_stack, "name", "Paste").name = string.format("Pasted %d objects", #objs)
  XEditorUndo:EndOp(objs)
end
function XEditorCopyToClipboard()
  local objs = editor.GetSel("permanent")
  local data = XEditorSerialize(objs, Collection.GetLockedCollection())
  data.pivot = CenterPointOnBase(objs)
  CopyToClipboard(XEditorToClipboardFormat(data))
end
function XEditorPasteFromClipboard()
  local lua_code = GetFromClipboard(-1)
  if lua_code:starts_with(XEditorCopyScriptTag) then
    XEditorPaste(lua_code)
  end
end
function XEditorClone(objs)
  local locked_collection = Collection.GetLockedCollection()
  local single_collection = editor.GetSingleSelectedCollection(objs)
  if single_collection and #objs < MapCount("map", "collection", single_collection.Index, true) then
    locked_collection = single_collection
  end
  return XEditorDeserialize(XEditorSerialize(objs, locked_collection), locked_collection, "clone")
end
function CenterPointOnBase(objs)
  local minz
  for _, obj in ipairs(objs) do
    local pos = obj:GetVisualPos()
    local z = Max(terrain.GetHeight(pos), pos:z())
    if not minz or minz > z then
      minz = z
    end
  end
  return CenterOfMasses(objs):SetZ(minz)
end
function XEditorSelectAndMoveObjects(objs, offs)
  editor.SetSel(objs)
  SuspendPassEditsForEditOp()
  objs = editor.SelectionCollapseChildObjects()
  if const.SlabSizeX and HasAlignedObjs(objs) then
    local x = offs:x() / const.SlabSizeX * const.SlabSizeX
    local y = offs:y() / const.SlabSizeY * const.SlabSizeY
    local z = offs:z() and (offs:z() + const.SlabSizeZ / 2) / const.SlabSizeZ * const.SlabSizeZ or 0
    offs = point(x, y, z)
  end
  for _, obj in ipairs(objs) do
    if obj:IsKindOf("AlignedObj") then
      obj:AlignObj(obj:GetPos() + offs)
    elseif obj:IsValidPos() then
      obj:SetPos(obj:GetPos() + offs)
    end
  end
  Msg("EditorCallback", "EditorCallbackMove", objs)
  ResumePassEditsForEditOp()
  return objs
end
function XEditorPropagateParentAndChildObjects(objs)
  add_parent_objects(objs)
  add_child_objects(objs)
  return objs
end
function XEditorPropagateChildObjects(objs)
  add_child_objects(objs)
  return objs
end
function XEditorCollapseChildObjects(objs)
  local objset = {}
  for _, obj in ipairs(objs) do
    objset[obj] = true
  end
  local i, count = 1, #objs
  while i <= count do
    local obj = objs[i]
    if objset[obj:GetEditorParentObject()] then
      objs[i] = objs[count]
      objs[count] = nil
      count = count - 1
    else
      i = i + 1
    end
  end
  return objs
end
