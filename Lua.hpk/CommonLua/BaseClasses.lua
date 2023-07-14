DefineClass.ForcedTemplate = {
  __parents = {
    "EditorObject"
  },
  template_class = "Template"
}
function GetTemplateBase(class_name)
  local class = g_Classes[class_name]
  return class and class.template_class or ""
end
MapVar("ForcedTemplateObjs", {})
function ForcedTemplate:EditorEnter()
  if self:GetGameFlags(const.gofPermanent) == 0 and self:GetEnumFlags(const.efVisible) ~= 0 then
    ForcedTemplateObjs[self] = true
    self:ClearEnumFlags(const.efVisible)
  end
end
function ForcedTemplate:EditorExit()
  if ForcedTemplateObjs[self] then
    self:SetEnumFlags(const.efVisible)
  end
end
MapVar("HiddenSpawnedObjects", false)
local HideSpawnedObjects = function(hide)
  if not hide == not HiddenSpawnedObjects then
    return
  end
  SuspendPassEdits("HideSpawnedObjects")
  if hide then
    HiddenSpawnedObjects = setmetatable({}, weak_values_meta)
    for template, obj in pairs(TemplateSpawn) do
      if IsValid(obj) and obj:GetEnumFlags(const.efVisible) ~= 0 then
        obj:ClearEnumFlags(const.efVisible)
        HiddenSpawnedObjects[#HiddenSpawnedObjects + 1] = obj
      end
    end
  elseif HiddenSpawnedObjects then
    for i = 1, #HiddenSpawnedObjects do
      local obj = HiddenSpawnedObjects[i]
      if IsValid(obj) then
        obj:SetEnumFlags(const.efVisible)
      end
    end
    HiddenSpawnedObjects = false
  end
  ResumePassEdits("HideSpawnedObjects")
end
function ToggleSpawnedObjects()
  HideSpawnedObjects(not HiddenSpawnedObjects)
end
function OnMsg.GameEnterEditor()
  HideSpawnedObjects(true)
end
function OnMsg.GameExitEditor()
  HideSpawnedObjects(false)
end
local SortByItems = function(self)
  return self:GetSortItems()
end
DefineClass.SortedBy = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      id = "SortBy",
      editor = "set",
      default = false,
      items = SortByItems,
      max_items_in_set = 1,
      border = 2,
      three_state = true
    }
  }
}
function SortedBy:GetSortItems()
  return {}
end
function SortedBy:SetSortBy(sort_by)
  self.SortBy = sort_by
  self:Sort()
end
function SortedBy:ResolveSortKey()
  for key, value in pairs(self.SortBy) do
    return key, value
  end
end
function SortedBy:Cmp(c1, c2, sort_by)
end
function SortedBy:Sort()
  local key, dir = self:ResolveSortKey()
  table.sort(self, function(c1, c2)
    return self:Cmp(c1, c2, key)
  end)
  if not dir then
    table.reverse(self)
  end
end
