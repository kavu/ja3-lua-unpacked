ClassNonInheritableMembers = {
  __index = true,
  __parents = true,
  __ancestors = true,
  __generated_by_class = true,
  NoInstances = true,
  class = true
}
local noninheritable = ClassNonInheritableMembers
local noncopyable = {__hierarchy_cache = true}
RecursiveCallMethods = {}
AutoResolveMethods = {}
local AutoResolveMethods = AutoResolveMethods
local ipairs = ipairs
local pairs = pairs
local icopy = table.icopy
local copy = table.copy
local map = table.map
local insert_unique = table.insert_unique
local find = table.find
local insert = table.insert
local remove = table.remove
local clear = table.clear
local concat = table.concat
local developer = Platform.developer
if FirstLoad then
  g_Classes = {}
else
  for name, class in pairs(g_Classes) do
    rawset(_G, name, nil)
  end
end
local classdefs = {}
local resolved = {}
local classes = g_Classes
local ancestors_by_parents = {}
function ClassesResolved()
  return classdefs == nil
end
function ReportMissingMembers(table, key)
  if type(key) ~= "number" then
  end
end
local report_missing_members = {
  __index = ReportMissingMembers
}
local define = function(class, class_def, ...)
  if type(class_def) == "table" then
  else
    class_def = {
      __parents = {
        class_def,
        ...
      }
    }
  end
  if rawget(_G, class) ~= nil then
    return
  end
  rawset(_G, class, class_def)
  classdefs[class] = class_def
  return class_def
end
local undefine = function(class)
  if classdefs[class] then
    classdefs[class] = nil
    _G[class] = nil
  end
end
DefineClass = SetupFuncCallTable(define)
UndefineClass = SetupFuncCallTable(undefine)
local unresolved_func = function()
end
local ScheduleAutoResolve = function(classname, member, class1, class2, auto_resolved)
  local method_to_classes = auto_resolved[classname] or {}
  auto_resolved[classname] = method_to_classes
  local classes = method_to_classes[member]
  if not classes then
    classes = {}
    method_to_classes[member] = classes
  end
  if class1 ~= unresolved_func then
    insert_unique(classes, class1)
  end
  if class2 ~= unresolved_func then
    insert_unique(classes, class2)
  end
end
local function GatherAutoResolved(funcs, method, classes, auto_resolved)
  for _, class in ipairs(classes) do
    local method_to_classes = auto_resolved[class]
    local parents = method_to_classes and method_to_classes[method]
    if not parents then
      local func = classdefs[class][method]
      insert_unique(funcs, func)
    else
      GatherAutoResolved(funcs, method, parents, auto_resolved)
    end
  end
end
CombinedMethodGenerator = {}
local remove_entries = function(array, entry)
  for i = #(array or ""), 1, -1 do
    if array[i] == entry then
      remove(array, i)
    end
  end
end
function CombinedMethodGenerator.call(method_list)
  remove_entries(method_list, empty_func)
  local count = #(method_list or "")
  if count == 0 then
    return empty_func
  end
  if count == 1 then
    return method_list[1]
  end
  if count == 2 then
    local f1, f2 = method_list[1], method_list[2]
    return function(obj, ...)
      f1(obj, ...)
      f2(obj, ...)
    end
  end
  if count == 3 then
    local f1, f2, f3 = method_list[1], method_list[2], method_list[3]
    return function(obj, ...)
      f1(obj, ...)
      f2(obj, ...)
      f3(obj, ...)
    end
  end
  return function(obj, ...)
    for i = 1, count do
      method_list[i](obj, ...)
    end
  end
end
CombinedMethodGenerator[true] = CombinedMethodGenerator.call
function CombinedMethodGenerator.procall_parents_last(method_list)
  remove_entries(method_list, empty_func)
  local count = #(method_list or "")
  if count == 0 then
    return empty_func
  end
  if count == 1 then
    local f = method_list[1]
    return function(obj, ...)
      procall(f, obj, ...)
    end
  end
  if count == 2 then
    local f1, f2 = method_list[1], method_list[2]
    return function(obj, ...)
      procall(f2, obj, ...)
      procall(f1, obj, ...)
    end
  end
  if count == 3 then
    local f1, f2, f3 = method_list[1], method_list[2], method_list[3]
    return function(obj, ...)
      procall(f3, obj, ...)
      procall(f2, obj, ...)
      procall(f1, obj, ...)
    end
  end
  return function(obj, ...)
    for i = count, 1, -1 do
      procall(method_list[i], obj, ...)
    end
  end
end
function CombinedMethodGenerator.procall(method_list)
  remove_entries(method_list, empty_func)
  local count = #(method_list or "")
  if count == 0 then
    return empty_func
  end
  if count == 1 then
    local f = method_list[1]
    return function(obj, ...)
      procall(f, obj, ...)
    end
  end
  if count == 2 then
    local f1, f2 = method_list[1], method_list[2]
    return function(obj, ...)
      procall(f1, obj, ...)
      procall(f2, obj, ...)
    end
  end
  if count == 3 then
    local f1, f2, f3 = method_list[1], method_list[2], method_list[3]
    return function(obj, ...)
      procall(f1, obj, ...)
      procall(f2, obj, ...)
      procall(f3, obj, ...)
    end
  end
  return function(obj, ...)
    for i = 1, count do
      procall(method_list[i], obj, ...)
    end
  end
end
CombinedMethodGenerator["and"] = function(method_list)
  remove_entries(method_list, return_true)
  local count = #(method_list or "")
  if count == 0 then
    return return_true
  end
  if count == 1 then
    return method_list[1]
  end
  if find(method_list, empty_func) then
    return empty_func
  end
  if count == 2 then
    local f1, f2 = method_list[1], method_list[2]
    return function(obj, ...)
      return f1(obj, ...) and f2(obj, ...)
    end
  end
  if count == 3 then
    local f1, f2, f3 = method_list[1], method_list[2], method_list[3]
    return function(obj, ...)
      return f1(obj, ...) and f2(obj, ...) and f3(obj, ...)
    end
  end
  return function(obj, ...)
    local result
    for i = 1, count do
      result = method_list[i](obj, ...)
      if not result then
        return result
      end
    end
    return result
  end
end
CombinedMethodGenerator["or"] = function(method_list)
  remove_entries(method_list, empty_func)
  local count = #(method_list or "")
  if count == 0 then
    return empty_func
  end
  if count == 1 then
    return method_list[1]
  end
  if find(method_list, return_true) then
    return return_true
  end
  if count == 2 then
    local f1, f2 = method_list[1], method_list[2]
    return function(obj, ...)
      return f1(obj, ...) or f2(obj, ...)
    end
  end
  if count == 3 then
    local f1, f2, f3 = method_list[1], method_list[2], method_list[3]
    return function(obj, ...)
      return f1(obj, ...) or f2(obj, ...) or f3(obj, ...)
    end
  end
  return function(obj, ...)
    local result
    for i = 1, count do
      result = method_list[i](obj, ...)
      if result then
        return result
      end
    end
    return result
  end
end
CombinedMethodGenerator["+"] = function(method_list)
  remove_entries(method_list, empty_func)
  remove_entries(method_list, return_0)
  local count = #(method_list or "")
  if count == 0 then
    return return_0
  end
  if count == 1 then
    return method_list[1]
  end
  return function(obj, ...)
    local result = method_list[1](obj, ...) or 0
    for i = 2, count do
      result = result + (method_list[i](obj, ...) or 0)
    end
    return result
  end
end
function CombinedMethodGenerator.max(method_list)
  remove_entries(method_list, empty_func)
  local count = #(method_list or "")
  if count == 0 then
    return empty_func
  end
  if count == 1 then
    return method_list[1]
  end
  return function(obj, ...)
    local result = method_list[1](obj, ...)
    for i = 2, count do
      if type(result) ~= "number" then
        result = method_list[i](obj, ...)
      else
        local next_result = method_list[i](obj, ...)
        if type(next_result) == "number" then
          result = Max(result, next_result)
        end
      end
    end
    return result
  end
end
CombinedMethodGenerator["%"] = function(method_list)
  remove_entries(method_list, empty_func)
  remove_entries(method_list, return_100)
  local count = #(method_list or "")
  if count == 0 then
    return return_100
  end
  if count == 1 then
    return method_list[1]
  end
  if find(method_list, return_0) then
    return return_0
  end
  return function(obj, ...)
    local result = method_list[1](obj, ...) or 100
    for i = 2, count do
      result = MulDivRound(result, method_list[i](obj, ...) or 100, 100)
    end
    return result
  end
end
CombinedMethodGenerator[".."] = function(method_list)
  remove_entries(method_list, empty_func)
  local count = #(method_list or "")
  if count == 0 then
    return empty_func
  end
  if count == 1 then
    return method_list[1]
  end
  return function(obj, ...)
    local result = method_list[1](obj, ...) or ""
    if result == "" then
      result = nil
    end
    local results_list
    for i = 2, #method_list do
      local next_result = method_list[i](obj, ...) or ""
      if next_result ~= "" then
        if not result then
          result = next_result
        elseif results_list then
          results_list[#results_list + 1] = next_result
        else
          results_list = {result, next_result}
        end
      end
    end
    return results_list and concat(results_list, "\n") or result or ""
  end
end
function CombinedMethodGenerator.modify(method_list)
  remove_entries(method_list, return_first)
  local count = #(method_list or "")
  if count == 0 then
    return return_first
  end
  if count == 1 then
    return method_list[1]
  end
  return function(obj, result, ...)
    for i = 1, count do
      result = method_list[i](obj, result, ...) or result
    end
    return result
  end
end
local AutoResolve = function(class, methods, auto_resolved)
  local classdef = classdefs[class]
  for method, classes in pairs(methods) do
    local funcs = {}
    GatherAutoResolved(funcs, method, classes, auto_resolved)
    local op = AutoResolveMethods[method]
    classdef[method] = (CombinedMethodGenerator[op] or op)(funcs)
  end
end
local function ResolveComplexInheritance(classname, classdef, force, auto_resolved)
  local parents = classdef.__parents
  if not force and #parents <= 1 and not classdef.__hierarchy_cache then
    return
  end
  local current = resolved[classname]
  if current then
    if not current.__ancestors then
    end
    return current
  else
    current = {}
    resolved[classname] = current
  end
  local ancestors = {}
  for member, value in pairs(classdef) do
    if noninheritable[member] then
      current[member] = value
    else
      current[member] = classname
    end
  end
  for i = 1, #parents do
    local parent_name = parents[i]
    if not ancestors[parent_name] then
      ancestors[parent_name] = true
      local parent_def = classdefs[parent_name]
      local parent = ResolveComplexInheritance(parent_name, parent_def, true, auto_resolved)
      local parent_ancestors = parent.__ancestors
      for member, value in pairs(parent) do
        if not noninheritable[member] then
          local src = current[member]
          if src ~= classname and src ~= value then
            if not src or parent_ancestors[src] then
              current[member] = value
            else
              if AutoResolveMethods[member] then
                current[member] = unresolved_func
                ScheduleAutoResolve(classname, member, src, value, auto_resolved)
              else
              end
            end
          end
        end
      end
      for class, _ in pairs(parent_ancestors) do
        ancestors[class] = true
      end
    end
  end
  for method in pairs(auto_resolved[classname]) do
    current[method] = classname
  end
  local shared_ancestors = ancestors_by_parents[parents]
  if not shared_ancestors then
    ancestors_by_parents[parents] = ancestors
    shared_ancestors = ancestors
  end
  current.__ancestors = shared_ancestors
  return current
end
local function ResolveValues(classname, resolved_class, classdef)
  local class = classes[classname]
  if class.class then
    if not class.__index then
    end
    return class
  end
  class.class = classname
  local meta
  if resolved_class then
    local cache_classname = resolved_class.__hierarchy_cache
    local cache_ancestors
    if cache_classname then
      local cache = resolved[cache_classname]
      cache_ancestors = cache.__ancestors
      if cache_classname ~= classname then
        meta = ResolveValues(cache_classname, cache, classdefs[cache_classname])
      end
    else
      cache_ancestors = {}
    end
    for member, source in pairs(resolved_class) do
      if not noncopyable[member] then
        if not noninheritable[member] then
          local value = classdefs[source][member]
          if cache_classname == classname or source ~= cache_classname and not cache_ancestors[source] then
            class[member] = value
          end
        else
          class[member] = source
        end
      end
    end
  else
    local __parents = classdef.__parents
    local parent_name = __parents[1] or false
    local ancestors = ancestors_by_parents[__parents]
    if parent_name then
      local parent_def = classdefs[parent_name]
      local parent = ResolveValues(parent_name, resolved[parent_name], parent_def)
      if parent_def.__hierarchy_cache == nil then
        for member, value in pairs(parent) do
          if not noninheritable[member] then
            class[member] = value
          end
        end
        meta = getmetatable(parent)
      else
        meta = parent
      end
      if not ancestors then
        ancestors = {
          [parent_name] = true
        }
        for class, _ in pairs(parent.__ancestors) do
          ancestors[class] = true
        end
        ancestors_by_parents[__parents] = ancestors
      end
    elseif not ancestors then
      ancestors = {}
      ancestors_by_parents[__parents] = ancestors
    end
    class.__ancestors = ancestors
    for member, value in pairs(classdef) do
      if not noncopyable[member] then
        class[member] = value
      end
    end
  end
  class.__index = class.__index or class
  setmetatable(class, meta)
  return class
end
local resolved_flags = {}
local flag_defs = {}
local empty_flags = {}
local enum_flag_modified = function(flags, flag, parent, child)
  if not flag_defs[child] or flag_defs[child][flag] == nil then
    return
  end
  if parent and string.match(flag, "^ef+") and const[flag] & const.StaticClassEnumFlags ~= 0 then
    local pval = flag_defs[parent][flag]
    local cval = flag_defs[child][flag]
    if pval ~= cval then
      printf("once", "[Warning] Modifying enum flag %s from %s child class of %s: map enum functions will not work properly with these classes", flag, child, parent)
    end
  end
end
local function ResolveFlagInheritance(name, classdef, force)
  local flags = resolved_flags[name]
  if flags then
    return flags
  end
  local flag_def = flag_defs[name]
  local parents = classdef.__parents
  if not force and not flag_def and #parents <= 1 then
    return
  end
  local parent = parents[1]
  flags = parent and ResolveFlagInheritance(parent, classdefs[parent], true) or empty_flags
  local org_flags = flags
  if flag_def then
    flags = copy(flags)
    for flag in pairs(flag_def) do
      if not const[flag] then
      else
        enum_flag_modified(flags, flag, flags[flag], name)
        flags[flag] = name
      end
    end
  end
  for i = 2, #parents do
    parent = parents[i]
    local parent_flags = ResolveFlagInheritance(parent, classdefs[parent], true)
    local parent_ancestors = classes[parent].__ancestors
    for flag, src2 in pairs(parent_flags) do
      local src = flags[flag]
      if src ~= name and src ~= src2 and (not src or flag_defs[src][flag] ~= flag_defs[src2][flag]) then
        if not src or parent_ancestors[src] then
          if flags == org_flags then
            flags = copy(flags)
          end
          enum_flag_modified(flags, flag, src2, name)
          flags[flag] = src2
        elseif not classes[src].__ancestors[src2] then
        end
      end
    end
  end
  resolved_flags[name] = flags
  return flags
end
function FlagValuesTable(base_class, prefix, f)
  local const = const
  local flag_values = {}
  for name, class in pairs(classes) do
    local ancestors = class.__ancestors
    if name == base_class or ancestors and ancestors[base_class] then
      local flags = resolved_flags[name]
      if flags then
        local flags_value = 0
        for flag, src in pairs(flags) do
          if flag:starts_with(prefix) then
            if flag_defs[src][flag] then
              flags_value = flags_value | const[flag]
            else
              flags_value = flags_value & ~const[flag]
            end
          end
        end
        flag_values[name] = flags_value
      end
    end
  end
  return setmetatable({}, {
    __index = function(t, name)
      local flags_value = flag_values[name]
      local class_name = name
      while not flags_value do
        local class = classes[class_name]
        local parent = class.__parents[1]
        flags_value = not parent and 0 or flag_values[parent]
        class_name = parent
      end
      return f and f(name, flags_value) or flags_value
    end
  })
end
function ClassDescendants(ancestor, filter, ...)
  PauseInfiniteLoopDetection("ClassDescendants")
  local descendants
  for name, class in pairs(classes) do
    local ancestors = class.__ancestors
    if ancestors and ancestors[ancestor] and (not filter or filter(name, class, ...)) then
      descendants = descendants or {}
      descendants[name] = class
    end
  end
  ResumeInfiniteLoopDetection("ClassDescendants")
  return descendants or empty_table
end
function ClassDescendantsList(ancestor, filter, ...)
  PauseInfiniteLoopDetection("ClassDescendantsList")
  local descendants = {}
  for name, class in pairs(classes) do
    local ancestors = class.__ancestors
    if ancestors and ancestors[ancestor] and (not filter or filter(name, class, ...)) then
      descendants[#descendants + 1] = name
    end
  end
  table.sort(descendants)
  ResumeInfiniteLoopDetection("ClassDescendantsList")
  return descendants
end
function ClassDescendantsListInclusive(ancestor, filter, ...)
  local descendants = ClassDescendantsList(ancestor, filter, ...)
  if not filter or filter(ancestor, classes[ancestor], ...) then
    insert(descendants, 1, ancestor)
  end
  return descendants
end
function ClassLeafDescendantsList(classname, filter, ...)
  PauseInfiniteLoopDetection("ClassLeafDescendantsList")
  local non_leaves = {}
  for name, class in pairs(classes) do
    local parents = class.__parents
    if parents then
      for i = 1, #parents do
        non_leaves[parents[i]] = true
      end
    end
  end
  local leaf_descendants = {}
  if non_leaves[classname] then
    for name, class in pairs(classes) do
      if not non_leaves[name] and class.__ancestors and class.__ancestors[classname] and (not filter or filter(name, class, ...)) then
        leaf_descendants[#leaf_descendants + 1] = name
      end
    end
    table.sort(leaf_descendants)
  end
  ResumeInfiniteLoopDetection("ClassLeafDescendantsList")
  return leaf_descendants
end
function ClassValuesCombo(class, member, additional)
  return function()
    local values = {}
    ClassDescendants(class, function(name, classdef, values)
      values[classdef[member] or false] = true
    end, values)
    values[false] = nil
    values[additional or false] = nil
    values = table.keys(values, true)
    if additional then
      insert(values, 1, additional)
    end
    return values
  end
end
function ProcessClassdefChildren(root, process)
  local processed = {}
  local function process_classdef(classdef, class_name)
    if not classdef then
      return
    end
    local seen = processed[class_name]
    if seen ~= nil then
      return seen
    end
    for _, parent in ipairs(classdef.__parents or empty_table) do
      seen = process_classdef(classdefs[parent], parent) or seen
    end
    if seen then
      process(classdef, class_name)
    end
    processed[class_name] = seen or false
    return seen
  end
  process(classdefs[root], root)
  processed[root] = true
  for class_name, classdef in pairs(classdefs) do
    process_classdef(classdef, class_name)
  end
end
local function ClassdefHasMember(classdef, name)
  if not classdef then
    return
  end
  if classdef[name] ~= nil then
    return true
  end
  for _, parent in ipairs(classdef.__parents or empty_table) do
    if ClassdefHasMember(classdefs[parent], name) then
      return true
    end
  end
end
_G.ClassdefHasMember = ClassdefHasMember
function OnMsg.Autorun()
  SuspendThreadDebugHook("Classes")
  Msg("ClassesGenerate", classdefs)
  MsgClear("ClassesGenerate")
  Msg("ClassesPreprocess", classdefs)
  MsgClear("ClassesPreprocess")
  for name, class in pairs(classes) do
    if classdefs[name] then
      setmetatable(class, nil)
      clear(class)
    else
      classes[name] = nil
    end
  end
  local no_parents = {}
  for name, classdef in pairs(classdefs) do
    if not rawget(classes, name) then
      classes[name] = {}
    end
    local parents = classdef.__parents
    if parents == nil then
      classdef.__parents = no_parents
    else
      if type(parents) == "table" then
        for i = #parents, 1, -1 do
          if not classdefs[parents[i]] then
            table.remove(parents, i)
          end
        end
      else
      end
    end
    flag_defs[name] = classdef.flags
    classdef.flags = nil
  end
  local parents_by_hash = {}
  for name, class in pairs(classdefs) do
    local parents = class.__parents
    if not parents_by_hash[parents] then
      local parent_hash = #parents == 1 and parents[1] or concat(parents, "|")
      local parents_table = parents_by_hash[parent_hash]
      if parents_table then
        class.__parents = parents_table
      else
        parents_by_hash[parent_hash] = parents
        parents_by_hash[parents] = name
      end
    end
  end
  parents_by_hash = nil
  local auto_resolved = {}
  for name, classdef in pairs(classdefs) do
    ResolveComplexInheritance(name, classdef, false, auto_resolved)
  end
  for classname, methods in pairs(auto_resolved) do
    AutoResolve(classname, methods, auto_resolved)
  end
  for name, class in pairs(classdefs) do
    ResolveValues(name, resolved[name], class)
  end
  for name, classdef in pairs(classdefs) do
    ResolveFlagInheritance(name, classdef)
  end
  for name, class in pairs(classdefs) do
    rawset(_G, name, classes[name])
  end
  resolved = nil
  classdefs = nil
  ancestors_by_parents = nil
  ClassNonInheritableMembers = nil
  DefineClass = nil
  Msg("ClassesPostprocess")
  MsgClear("ClassesPostprocess")
  Msg("ClassesBuilt")
  MsgClear("ClassesBuilt")
  CombinedMethodGenerator = false
  FlagValuesTable = nil
  resolved_flags = nil
  flag_defs = nil
  collectgarbage("collect")
  if developer then
    local meta = {
      __newindex = function(t, k, v)
      end
    }
    ClassDescendants("PropertyObject", function(classname, classdef, meta)
      for k, v in pairs(classdef) do
        if k ~= "__index" and type(v) == "table" and not getmetatable(v) then
          setmetatable(v, meta)
        end
      end
    end, meta)
  end
  ResumeThreadDebugHook("Classes")
end
local reported_missing = {}
local present_on_map = false
local warned_once = {}
local delayed_warns = {}
local valid_entity = false
local ReportObjectEntity = function(obj)
  if present_on_map and not present_on_map[obj:GetEntity()] and valid_entity[obj:GetEntity()] and not warned_once[obj:GetEntity()] then
    printf("[Warning] trying to place an object of class %s:", obj.class)
    warned_once[obj:GetEntity()] = true
  end
end
if developer then
  function OnMsg.NewMapLoaded()
    for k, v in pairs(delayed_warns) do
      if v then
        ReportObjectEntity(k)
      end
    end
    delayed_warns = {}
  end
end
function PlaceObject(classname, luaobj, components, ...)
  local class = classname and g_Classes[classname]
  if not class then
    if developer and not reported_missing[classname or false] then
      reported_missing[classname or false] = true
      printf("[Warning] %s is trying to place an object of missing class \"%s\"", GetCallLine(), tostring(classname))
    end
    return
  end
  local obj = class:new(luaobj, components, ...)
  if developer and not IsEditorActive() and present_on_map and not class:IsKindOf("Template") then
    if not obj:HasMember("entity") then
      if not warned_once[classname] then
        printf("[Warning] %s is trying to place an object of class \"%s\" without entity!", GetCallLine(), classname)
        warned_once[classname] = true
      end
      return
    end
    if IsChangingMap() then
      delayed_warns[obj] = true
    else
      ReportObjectEntity(obj)
    end
  end
  return obj
end
function DoneObject(obj)
  if not obj then
    return
  end
  if ChangingMap then
    delayed_warns[obj] = nil
  end
  obj:delete()
end
function DoneObjects(objs, clear_objs)
  if not objs then
    return
  end
  for k, obj in ipairs(objs) do
    DoneObject(obj)
  end
  if clear_objs then
    clear(objs)
  end
end
function DoneField(obj, field_name)
  if not obj then
    return
  end
  DoneObject(obj[field_name])
  obj[field_name] = nil
end
function ClassDescendantsCombo(class, inclusive, filter)
  return function(obj, prop_meta, validate_fn)
    if validate_fn == "validate_fn" then
      return "validate_fn", function(value, obj, prop_meta)
        return value == "" or IsKindOf(g_Classes[value], class) and (inclusive or value ~= class) and (not filter or filter(value, g_Classes[value]))
      end
    end
    local list = ClassDescendantsList(class, filter) or {}
    if inclusive then
      list[#list + 1] = class
    end
    table.sort(list)
    table.insert(list, 1, "")
    return list
  end
end
function ClassLeafDescendantsCombo(class, inclusive)
  return function(obj)
    local list = ClassLeafDescendantsList(class) or {}
    list[#list + 1] = ""
    if inclusive then
      list[#list + 1] = class
    end
    table.sort(list)
    return list
  end
end
function GetClassValue(obj, prop)
  return getmetatable(obj)[prop]
end
local function EnumFuncNames(def, funcs)
  funcs = funcs or {}
  if not def then
    return funcs
  end
  for key, val in pairs(def) do
    if type(val) == "function" and type(key) == "string" then
      funcs[key] = true
    end
  end
  return EnumFuncNames(getmetatable(def), funcs)
end
function GetFuncInheritance(def, funcs)
  local funcs = type(funcs) == "string" and {funcs} or funcs or table.keys(EnumFuncNames(def), true)
  local ancestors = {}
  for class_i in pairs(def.__ancestors) do
    ancestors[class_i] = g_Classes[class_i]
  end
  local class = def.class
  local map = {}
  for _, name in ipairs(funcs) do
    local func = def[name]
    local class_found, def_found
    for class_i, def_i in pairs(ancestors) do
      if rawget(def_i, name) == func and (not def_found or def_found.__ancestors[class_i]) then
        class_found = class_i
        def_found = def_i
      end
    end
    map[name] = class_found or class
  end
  return map
end
function OnMsg.ClassesPreprocess(classdefs)
  local merge = function(list1, list2)
    if not (list1 and list2) or list1 == list2 then
      return list1 or list2
    end
    local list = list1.cached and icopy(list1) or list1
    for _, item in ipairs(list2) do
      if not find(list1, item) then
        list[#list + 1] = item
      end
    end
    return list
  end
  local method_name, generated_methods, method_generator, lists_cache, generated_cache
  local class_to_method = function(class_name)
    return classdefs[class_name][method_name]
  end
  local function process(class)
    local list = lists_cache[class]
    if list ~= nil then
      return list
    end
    local classdef = classdefs[class] or empty_table
    for _, parent in ipairs(classdef.__parents) do
      list = merge(list, process(parent))
    end
    if classdef[method_name] then
      list = list and list.cached and icopy(list) or list or {}
      list[#list + 1] = class
    end
    if list and not list.cached then
      local str = concat(list, "|")
      local method = generated_cache[str]
      if not method then
        method = method_generator(map(list, class_to_method))
        generated_cache[str] = method
      end
      generated_methods[class] = method
      list.cached = true
    end
    lists_cache[class] = list or false
    return list
  end
  for entry, func in pairs(RecursiveCallMethods) do
    method_name = entry
    method_generator = CombinedMethodGenerator[func] or func
    lists_cache = {
      [false] = false
    }
    generated_cache = {}
    generated_methods = {}
    for class, classdef in pairs(classdefs) do
      process(class, classdef)
    end
    for class, method in pairs(generated_methods) do
      classdefs[class][method_name] = method
    end
  end
end
AppendClassMembers = {}
AppendClassMembers.__parents = table.iappend
function AppendClassMembers.properties(t, props)
  for _, prop_meta in ipairs(props) do
    local idx = table.find(t, "id", prop_meta.id)
    if idx then
      table.remove(t, idx)
    end
  end
  return table.iappend(t, props)
end
AppendClassMembers.flags = table.overwrite
AppendClass = SetupFuncCallTable(function(class_name, additions)
  local class_def = classdefs and classdefs[class_name]
  if not class_def then
    if classdefs then
    end
    return
  end
  local AppendClassMembers = AppendClassMembers
  for member, new_value in pairs(additions) do
    local append = AppendClassMembers[member]
    if append then
      class_def[member] = class_def[member] and append(class_def[member], new_value) or new_value
    else
      class_def[member] = new_value
    end
  end
end)
