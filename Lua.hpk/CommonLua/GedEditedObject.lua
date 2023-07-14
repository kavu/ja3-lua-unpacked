DefineClass("GedEditedObject")
if FirstLoad then
  g_GedEditorData = setmetatable({}, weak_keys_meta)
  g_DirtyObjects = {}
  g_DirtyObjectsById = {}
end
local notify_dirty_status = function(obj, dirty)
  g_DirtyObjects[obj] = dirty or nil
  GedUpdateDirtyObjectsById()
  GedNotify(obj, "OnEditorDirty", dirty)
  for id, ged in pairs(GedConnections) do
    GedUpdateObjectValue(ged, nil, "root|dirty_objects")
  end
end
function GedEditedObject:EditorData()
  local data = g_GedEditorData[self]
  if not data then
    data = {}
    g_GedEditorData[self] = data
  end
  return data
end
function OnMsg.GedBindObj(obj)
  while obj do
    if IsKindOf(obj, "GedEditedObject") then
      obj:TrackDirty()
    end
    obj = ParentTableCache[obj]
  end
end
function OnMsg.ObjModified(obj)
  local ged_edited_object, is_bound_in_ged
  while obj do
    if IsKindOf(obj, "GedEditedObject") then
      ged_edited_object = obj
    end
    is_bound_in_ged = is_bound_in_ged or GedObjects[obj]
    obj = ParentTableCache[obj]
  end
  if ged_edited_object and is_bound_in_ged then
    ged_edited_object:UpdateDirtyStatus()
  end
end
function GedEditedObject:TrackDirty()
  local data = self:EditorData()
  if not data.old_hash then
    data.old_hash = self:CalculatePersistHash()
    data.current_hash = data.old_hash
  end
end
function GedEditedObject:UpdateDirtyStatus()
  local data = self:EditorData()
  local old_hash = data.old_hash
  if old_hash then
    local new_hash = self:CalculatePersistHash()
    if data.current_hash ~= new_hash then
      data.current_hash = new_hash
      notify_dirty_status(self, old_hash ~= new_hash)
    end
  end
end
function GedEditedObject:IsDirty()
  local data = self:EditorData()
  local old_hash = data.old_hash
  return old_hash and (old_hash == 0 or old_hash ~= data.current_hash)
end
function GedEditedObject:MarkDirty(notify)
  if not self:IsDirty() then
    self:EditorData().old_hash = 0
    if notify ~= false then
      notify_dirty_status(self, true)
    end
  end
end
function GedEditedObject:MarkClean()
  local data = self:EditorData()
  data.current_hash = self:CalculatePersistHash()
  if self:IsDirty() then
    data.old_hash = data.current_hash
    notify_dirty_status(self, false)
  end
end
function GedUpdateDirtyObjectsById()
  local dirty = {}
  for obj in pairs(g_DirtyObjects) do
    dirty[tostring(obj)] = true
    for parent_preset, linked_presets in pairs(LinkedPresetClasses) do
      if table.find(linked_presets, obj.class) then
        local obj = FindLinkedPresetOfClass(obj, parent_preset)
        if obj then
          dirty[tostring(obj)] = true
        end
      end
    end
  end
  g_DirtyObjectsById = dirty
end
function GedGetDirtyObjects(obj, filter, preset_class)
  return g_DirtyObjectsById
end
