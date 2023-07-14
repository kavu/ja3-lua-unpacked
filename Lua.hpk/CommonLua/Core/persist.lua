const.InvalidZ = 2147483647
function OnMsg.PersistGatherPermanents(permanents)
  permanents["point.meta"] = getmetatable(point20)
  permanents["box.meta"] = getmetatable(box(0, 0, 0, 0))
  permanents["quaternion.meta"] = getmetatable(quaternion())
  permanents["range.meta"] = getmetatable(range(0, 0))
  permanents["set.meta"] = getmetatable(set())
  permanents["pstr.meta"] = getmetatable(pstr())
  permanents["grid.meta"] = getmetatable(NewGrid(1, 1, 1))
  if rawget(_G, "grid") then
    permanents["XMgrid.meta"] = getmetatable(grid(1))
  end
  permanents["table.find"] = table.find
  permanents["table.ifind"] = table.ifind
  permanents["table.find_value"] = table.find_value
  permanents["table.findfirst"] = table.findfirst
  permanents["table.insert"] = table.insert
  permanents["table.remove"] = table.remove
  permanents["table.remove_value"] = table.remove_value
  permanents["table.clear"] = table.clear
  permanents["table.move"] = table.move
  permanents["table.icopy"] = table.icopy
  permanents.Min = Min
  permanents.Max = Max
  permanents.Clamp = Clamp
  permanents.MulDivRound = MulDivRound
  permanents.IsValid = IsValid
  permanents.IsKindOf = IsKindOf
  permanents.IsKindOfClasses = IsKindOfClasses
end
function __unpersisted_function__()
end
function GetLuaSaveGameData()
  local inv_permanents = createtable(0, 32768)
  local t = {}
  setmetatable(t, {
    __newindex = function(t, key, value)
      inv_permanents[value] = key
    end
  })
  t._G = _G
  Msg("PersistGatherPermanents", t, "save")
  local data = createtable(0, 2048)
  Msg("PersistSave", data)
  setmetatable(inv_permanents, {
    __index = __indexSavePermanents
  })
  return inv_permanents, data
end
function LoadMissingPermanent(permanents, id)
  local permanent
  if type(id) == "string" then
    local colon = type(id) == "string" and id:find(":", 2, true)
    if colon then
      local baseclass = g_Classes[id:sub(1, colon - 1)] or UnpersistedMissingClass
      local func = baseclass.UnpersistMissingClass
      permanent = func and func(baseclass, id, permanents) or UnpersistedMissingClass
    end
  end
  permanents[id] = permanent or false
  GameTestsError("Unpersist missing permanent:", id, "| Fallback permanent:", permanent and permanent.class or false)
  return permanent
end
function GetLuaLoadGamePermanents()
  local permanents = createtable(0, 32768)
  local t = {}
  setmetatable(t, {
    __newindex = function(t, key, value)
      permanents[key] = value
    end
  })
  t._G = _G
  Msg("PersistGatherPermanents", t, "load")
  Msg("PersistPreLoad")
  setmetatable(permanents, {
    __index = __indexLoadPermanents
  })
  return permanents
end
function LuaLoadGameData(data)
  Msg("PersistLoad", data)
  Msg("PersistPostLoad", data)
end
function OnMsg.PersistSave(data)
  local threadFlagPersist = 1048576
  for k, v in pairs(PersistableGlobals) do
    if v then
      data[k] = _G[k]
    end
  end
end
function OnMsg.PersistLoad(data)
  for k, v in pairs(PersistableGlobals) do
    if v and data[k] ~= nil then
      _G[k] = data[k]
    end
  end
end
function OnMsg.PersistGatherPermanents(permanents, direction)
  permanents.__pairs_aux__ = pairs({})
  permanents.__ipairs_aux__ = ipairs({})
  permanents.__ripairs_aux__ = ripairs({})
  permanents.__pairs = pairs
  permanents.__ipairs = ipairs
  permanents.__ripairs = ripairs
  permanents.__procall = procall
  permanents.__sprocall = sprocall
  permanents.__finish_sprocall = __finish_sprocall
  permanents.__procall_errorhandler = __procall_errorhandler
  permanents.g_Classes = g_Classes
  permanents.IsKindOf = IsKindOf
  permanents.IsKindOfClasses = IsKindOfClasses
  permanents.IsValid = IsValid
  local concat = string.concat
  for name, class in pairs(g_Classes) do
    local baseclass = class.persist_baseclass or "class"
    permanents[concat(":", baseclass, name)] = class
    if direction == "load" and baseclass ~= "class" then
      permanents["class:" .. name] = class
    end
  end
end
DefineClass.UnpersistedMissingClass = {
  __parents = {
    "ComponentAttach"
  }
}
MapVar("ObjsToDeleteOnLoadGame", {})
function OnMsg.PersistPostLoad()
  for obj in pairs(ObjsToDeleteOnLoadGame or empty_table) do
    DoneObject(obj)
  end
  table.clear(ObjsToDeleteOnLoadGame)
end
function DeleteOnLoadGame(obj)
  if not IsValid(obj) then
    return
  end
  ObjsToDeleteOnLoadGame[obj] = true
end
function CancelDeleteOnLoadGame(obj)
  if not obj then
    return
  end
  ObjsToDeleteOnLoadGame[obj] = nil
end
function ValidateDeleteOnLoadGame()
  table.validate_map(ObjsToDeleteOnLoadGame)
end
OnMsg.StartSaveGame = ValidateDeleteOnLoadGame
