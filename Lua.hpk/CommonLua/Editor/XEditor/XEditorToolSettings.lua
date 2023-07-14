if FirstLoad then
  XEditorToolSettingsUpdateThreads = {}
end
DefineClass.XEditorToolSettings = {
  __parents = {
    "PropertyObject"
  }
}
local resolve_default = function(value, default)
  if value == nil then
    return default
  end
  return value
end
function OnMsg.ClassesPostprocess()
  ClassDescendantsList("XEditorToolSettings", function(name, classdef)
    for _, prop_meta in ipairs(classdef.properties or empty_table) do
      if prop_meta.editor then
        local prop_id = prop_meta.id
        if prop_meta.shared_setting then
          rawset(classdef, "Get" .. prop_id, function(self)
            local meta = self:GetPropertyMetadata(prop_id)
            local store_as = prop_eval(prop_meta.store_as, self, prop_meta) or prop_meta.id
            return resolve_default(LocalStorage[store_as], meta.default)
          end)
          rawset(classdef, "Set" .. prop_id, function(self, value)
            local meta = self:GetPropertyMetadata(prop_id)
            local store_as = prop_eval(prop_meta.store_as, self, prop_meta) or prop_meta.id
            value = ValidateNumberPropValue(value, meta)
            if resolve_default(LocalStorage[store_as], meta.default) ~= value then
              LocalStorage[store_as] = value
              if not IsValidThread(XEditorToolSettingsUpdateThreads[self]) then
                XEditorToolSettingsUpdateThreads[self] = CreateRealTimeThread(function()
                  Sleep(150)
                  SaveLocalStorage()
                  ObjModified(self)
                end)
              end
            end
          end)
          rawset(classdef, prop_id, nil)
        elseif prop_meta.persisted_setting then
          rawset(classdef, "Get" .. prop_id, function(self)
            local storage = LocalStorage[classdef.class]
            local meta = self:GetPropertyMetadata(prop_id)
            local store_as = prop_eval(prop_meta.store_as, self, prop_meta) or prop_meta.id
            return resolve_default(storage and storage[store_as], meta.default)
          end)
          rawset(classdef, "Set" .. prop_id, function(self, value)
            local meta = self:GetPropertyMetadata(prop_id)
            local store_as = prop_eval(prop_meta.store_as, self, prop_meta) or prop_meta.id
            value = ValidateNumberPropValue(value, meta)
            local storage = LocalStorage[classdef.class] or {}
            if resolve_default(storage and storage[store_as], meta.default) ~= value then
              LocalStorage[classdef.class] = storage
              storage[store_as] = value
              if not IsValidThread(XEditorToolSettingsUpdateThreads[self]) then
                XEditorToolSettingsUpdateThreads[self] = CreateRealTimeThread(function()
                  Sleep(150)
                  SaveLocalStorage()
                  ObjModified(self)
                end)
              end
            end
          end)
          rawset(classdef, prop_id, nil)
        end
      end
    end
  end)
end
function OnMsg.ClassesBuilt()
  ClassDescendants("XEditorToolSettings", function(class_name, class)
    local parent_props = {}
    for parent, _ in pairs(class.__ancestors) do
      if g_Classes[parent] and not IsKindOf(g_Classes[parent], "XEditorToolSettings") then
        for _, prop_meta in ipairs(g_Classes[parent].properties) do
          parent_props[prop_meta.id] = true
        end
      end
    end
    local props = class.properties or empty_table
    for idx, prop_meta in ipairs(props) do
      if parent_props[prop_meta.id] then
        props[idx] = table.copy(prop_meta)
        props[idx].no_edit = true
      end
    end
  end)
end
