DefineClass.CompositeDef = {
  __parents = {"Preset"},
  properties = {
    {
      category = "Preset",
      id = "object_class",
      name = "Class",
      editor = "choice",
      default = "",
      items = function(self)
        return ClassDescendantsCombo(self.ObjectBaseClass, true)
      end
    },
    {
      category = "Preset",
      id = "code",
      name = "Global Code",
      editor = "func",
      default = false,
      lines = 1,
      max_lines = 100,
      params = ""
    }
  },
  GeneratesClass = true,
  SingleFile = false,
  GedShowTemplateProps = true,
  ObjectBaseClass = false,
  ComponentClass = false,
  components_cache = false,
  components_sorting = false,
  properties_cache = false,
  EditorMenubarName = false
}
function CompositeDef.new(class, obj)
  local object = Preset.new(class, obj)
  object.object_class = CompositeDef.GetObjectClass(object)
  return object
end
function CompositeDef:GetObjectClass()
  return self.object_class ~= "" and self.object_class or self.ObjectBaseClass
end
function CompositeDef:GetComponents(filter)
  if not self.ComponentClass then
    return empty_table
  end
  local components_cache = self.components_cache
  if not components_cache then
    local sorting_keys = {}
    components_cache = ClassDescendantsList(self.ComponentClass, function(classname, class, base_class, base_def, sorting_keys)
      if class:IsKindOf(base_class) or base_def:IsKindOf(classname) then
        return
      end
      if (class.ComponentSortKey or 0) ~= 0 then
        sorting_keys[classname] = class.ComponentSortKey
      end
      return true
    end, self.ObjectBaseClass, g_Classes[self.ObjectBaseClass], sorting_keys)
    local classdef = g_Classes[self.class]
    rawset(classdef, "components_cache", components_cache)
    rawset(classdef, "components_sorting", sorting_keys)
  end
  if filter == "active" then
    return table.ifilter(components_cache, function(_, classname)
      return self:GetProperty(classname)
    end)
  elseif filter == "inactive" then
    return table.ifilter(components_cache, function(_, classname)
      return not self:GetProperty(classname)
    end)
  end
  return components_cache
end
function CompositeDef:GetProperties()
  local object_class = self:GetObjectClass()
  local object_def = g_Classes[object_class]
  if not object_def then
    return self.properties
  end
  local cache = self.properties_cache or {}
  if not cache[object_class] then
    local props, prop_data = {}, {}
    local add_prop = function(prop, default, class)
      local added
      if not prop_data[prop.id] then
        added = true
        if prop.default ~= default then
          prop = table.copy(prop)
          prop.default = default
        end
        props[#props + 1] = prop
      else
      end
      prop_data[prop.id] = {default = default, class = class}
      return added and prop or table.find_value(props, "id", prop.id)
    end
    for _, prop in ipairs(self.properties) do
      if prop.id ~= "code" then
        add_prop(prop, prop.default, self.class)
      end
    end
    for _, prop in ipairs(object_def.properties) do
      if prop.template then
        add_prop(prop, object_def:GetDefaultPropertyValue(prop.id), self.class)
      end
    end
    local components = self:GetComponents()
    for _, classname in ipairs(components) do
      local inherited = object_def:IsKindOf(classname) or false
      local help = inherited and "Inherited from the base class"
      local prop = {
        category = "Components",
        id = classname,
        editor = "bool",
        default = inherited,
        read_only = inherited,
        help = help
      }
      add_prop(prop, inherited, self.class)
    end
    add_prop(table.find_value(self.properties, "id", "code"), self:GetDefaultPropertyValue("code"), self.class)
    for _, classname in ipairs(components) do
      if not object_def:IsKindOf(classname) then
        local component_def = g_Classes[classname]
        for _, prop in ipairs(component_def.properties) do
          local category = prop.category or classname
          local no_edit = prop.no_edit
          prop = table.copy(prop, "deep")
          prop.category = category
          prop = add_prop(prop, component_def:GetDefaultPropertyValue(prop.id), classname)
          local composite_owner_classes = prop.composite_owner_classes or {}
          composite_owner_classes[#composite_owner_classes + 1] = classname
          prop.composite_owner_classes = composite_owner_classes
          function prop:no_edit(...)
            if no_edit == true or type(no_edit) == "function" and no_edit(self, ...) then
              return true
            end
            local prop_meta = select(1, ...)
            for _, name in ipairs(prop_meta.composite_owner_classes or empty_table) do
              if rawget(self, name) then
                return
              end
            end
            return true
          end
        end
      end
    end
    rawset(g_Classes[self.class], "properties_cache", cache)
    rawset(cache, object_class, props)
    return props
  end
  return cache[object_class]
end
function CompositeDef:SetProperty(prop_id, value)
  local prop_meta = self:GetPropertyMetadata(prop_id)
  if prop_meta and prop_meta.template and prop_meta.setter then
    return prop_meta.setter(self, value, prop_id, prop_meta)
  end
  if table.find(CompositeDef.properties, "id", prop_id) then
    return Preset.SetProperty(self, prop_id, value)
  end
  if value and table.find(self:GetComponents(), prop_id) and _G[prop_id]:HasMember("OnEditorNew") then
    _G[prop_id].OnEditorNew(self)
  end
  rawset(self, prop_id, value)
end
function CompositeDef:GetProperty(prop_id)
  local prop_meta = self:GetPropertyMetadata(prop_id)
  if prop_meta and prop_meta.template and prop_meta.getter then
    return prop_meta.getter(self, prop_id, prop_meta)
  end
  local value = Preset.GetProperty(self, prop_id)
  if value ~= nil then
    return value
  end
  return prop_meta and prop_meta.default
end
function CompositeDef:__toluacode(...)
  local properties = self:GetProperties()
  local find = table.find
  local rawget = rawget
  for _, classname in ipairs(self:GetComponents("inactive")) do
    for _, prop in ipairs(g_Classes[classname].properties) do
      if rawget(self, prop.id) ~= nil and not find(properties, "id", prop.id) then
        self[prop.id] = nil
      end
    end
  end
  return Preset.__toluacode(self, ...)
end
function CompositeDef:GetCompanionFilesList(save_path)
  local files = {}
  for _, prop in pairs(self:GetProperties()) do
    local save_in = prop.dlc or ""
    if not files[save_in] then
      files[save_in] = self:GetCompanionFileSavePath(self:GetSavePath(prop.dlc or self.save_in))
    end
  end
  return files
end
function CompositeDef:GenerateCompanionFileCode(code, dlc)
  code:appendf([[
UndefineClass('%s')
DefineClass.%s = {
]], self.id, self.id)
  self:GenerateParents(code)
  self:AppendGeneratedByProps(code)
  self:GenerateFlags(code)
  self:GenerateConsts(code, dlc)
  code:append([[
}

]])
  self:GenerateGlobalCode(code)
end
function CompositeDef:GenerateParents(code)
  local object_class = self:GetObjectClass()
  local list = self:GetComponents("active")
  if 0 < #list then
    local object_def = g_Classes[object_class]
    if object_def then
      list = table.ifilter(list, function(_, classname)
        return not object_def:IsKindOf(classname)
      end)
    end
  end
  if #list == 0 then
    code:appendf("\t__parents = { \"%s\" },\n", object_class)
    return
  end
  if next(self.components_sorting) then
    table.insert(list, 1, object_class)
    local sorting_keys = self.components_sorting
    table.stable_sort(list, function(class1, class2)
      return (sorting_keys[class1] or 0) < (sorting_keys[class2] or 0)
    end)
    code:append("\t__parents = { \"", table.concat(list, "\", \""), "\" },\n")
  else
    code:appendf("\t__parents = { \"%s\", \"", object_class)
    code:append(table.concat(list, "\", \""))
    code:append("\" },\n")
  end
end
ClassNonInheritableMembers.composite_flags = true
function CompositeDef:GenerateFlags(code)
  local object_def = g_Classes[self:GetObjectClass()]
  if not object_def then
    return
  end
  local flags = table.copy(object_def.composite_flags or empty_table)
  for _, component in ipairs(self:GetComponents("active")) do
    for flag, set in pairs(g_Classes[component].composite_flags) do
      flags[flag] = set
    end
  end
  if not next(flags) then
    return
  end
  code:append("\tflags = { ")
  for flag, set in sorted_pairs(flags) do
    code:appendf("%s = %s, ", flag, set and "true" or "false")
  end
  code:append("},\n")
end
function CompositeDef:IncludePropAs(prop, dlc)
  local id = prop.id
  if Preset:GetPropertyMetadata(id) or id == "code" then
    return false
  end
  if not (prop.dlc or dlc ~= "" and prop.dlc_override) or prop.dlc == dlc then
    return prop.maingame_prop_id or prop.id
  end
end
function CompositeDef:GenerateConsts(code, dlc)
  local props = self:GetProperties()
  code:append(0 < #props and "\n" or "")
  local has_embedded_objects = false
  for _, prop in ipairs(props) do
    local id = prop.id
    local include_as = self:IncludePropAs(prop, dlc)
    if include_as then
      local value = rawget(self, id)
      if not self:IsDefaultPropertyValue(id, prop, value) then
        code:append("\t", include_as, " = ")
        ValueToLuaCode(value, 1, code)
        code:append(",\n")
      end
    end
  end
  return has_embedded_objects
end
function CompositeDef:GenerateGlobalCode(code)
  if self.code and self.code ~= "" then
    code:append("\n")
    local name, params, body = GetFuncSource(self.code)
    if type(body) == "table" then
      for _, line in ipairs(body) do
        code:append(line, "\n")
      end
    elseif type(body) == "string" then
      code:append(body)
    end
    code:append("\n")
  end
end
function CompositeDef:GetObjectClassLuaFilePath(path)
  if self.save_in == "" then
    return string.format("Lua/%s/__%s.generated.lua", self.class, self.ObjectBaseClass)
  elseif self.save_in == "Common" then
    return string.format("CommonLua/Classes/%s/__%s.generated.lua", self.class, self.ObjectBaseClass)
  elseif self.save_in:starts_with("Libs/") then
    return string.format("CommonLua/%s/%s/__%s.generated.lua", save_in, self.class, self.ObjectBaseClass)
  else
    return string.format("svnProject/Dlc/%s/Presets/%s/__%s.generated.lua", save_in, self.class, self.ObjectBaseClass)
  end
end
function CompositeDef:GetWarning()
  if not g_Classes[self.id] then
    return [[
The class for this preset has not been generated yet.
It needs to be saved before it can be used or referenced from elsewhere.]]
  end
end
function OnMsg.ClassesPreprocess(classdefs)
  for name, classdef in pairs(classdefs) do
    if classdef.__parents and classdef.__parents[1] == "CompositeDef" then
      classdefs[classdef.ObjectBaseClass].__hierarchy_cache = true
    end
  end
end
function OnMsg.ClassesBuilt()
  ClassDescendants("CompositeDef", function(class_name, class)
    if IsKindOf(class, "ModItem") then
      return
    end
    local objclass = class.ObjectBaseClass
    local path = class:GetObjectClassLuaFilePath()
    if Platform.developer and not Platform.console then
      local methods = {}
      for _, component in ipairs(class:GetComponents()) do
        for name, member in pairs(g_Classes[component]) do
          if type(member) == "function" and not RecursiveCallMethods[name] then
            local classlist = methods[name]
            if classlist then
              classlist[#classlist + 1] = component
            else
              methods[name] = {component}
            end
          end
        end
      end
      local code = pstr(exported_files_header_warning, 16384)
      code:appendf("function __%sExtraDefinitions()\n", objclass)
      code:appendf("\t%s.components_cache = false\n", objclass)
      code:appendf("\t%s.GetComponents = %s.GetComponents\n", objclass, class_name)
      code:appendf("\t%s.ComponentClass = %s.ComponentClass\n", objclass, class_name)
      code:appendf([[
	%s.ObjectBaseClass = %s.ObjectBaseClass

]], objclass, class_name)
      local objprops = _G[objclass].properties
      for _, prop in ipairs(class:GetProperties()) do
        if not table.find(class.properties, "id", prop.id) and not table.find(objprops, "id", prop.id) then
          code:append("\t", objclass, ".", prop.id, " = ")
          ValueToLuaCode(class:GetDefaultPropertyValue(prop.id, prop), nil, code)
          code:append("\n")
        end
      end
      code:append([[
end

]])
      code:appendf("function OnMsg.ClassesBuilt() __%sExtraDefinitions() end\n", objclass)
      local err = SaveSVNFile(path, code, class.LocalPreset)
      if err then
        printf("Error '%s' saving %s", tostring(err), path)
        return
      end
    end
    dofile(path)
    _G[string.format("__%sExtraDefinitions", objclass)]()
  end)
end
