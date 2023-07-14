if FirstLoad then
  Mods = {}
  ModsList = false
  ModsLoaded = false
  ModsPackFileName = "ModContent.hpk"
  ModContentPath = "Mod/"
  ModsScreenshotPrefix = "ModScreenshot_"
  ModMessageLog = {}
  ModMinLuaRevision = 233360
  ModRequiredLuaRevision = 233360
end
function IsUserCreatedContentAllowed()
  return true
end
mod_print = CreatePrint({
  "mod",
  format = "printf",
  output = DebugPrint
})
function ModLog(log)
  log = _InternalTranslate(log)
  ModMessageLog[#ModMessageLog + 1] = log
  mod_print("%s", log)
  ObjModifiedDelayed(ModMessageLog)
end
function ModLogF(fmt, ...)
  return ModLog(Untranslated(string.format(fmt, ...)))
end
function OnMsg.Autorun()
  ObjModified(ModMessageLog)
end
if not config.Mods then
  return
end
DocsRoot = "ModTools/Docs/"
if Platform.developer then
  DocsRoot = "svnProject/Docs/ModTools/"
end
DefineClass.ModElement = {}
function ModElement:OnLoad(mod)
  self:AddPathPrefix()
end
function ModElement:OnUnload(mod)
end
function ModElement:IsMounted()
end
function ModElement:GetModRootPath()
end
function ModElement:GetModContentPath()
end
function ModConvertSlashes(path)
  return string.gsub(path, "\\", "/")
end
local EscapeMagicSymbols = function(path)
  return string.gsub(ModConvertSlashes(path), "[%(%)%.%%%+%-%*%?%[%^%$]", "%%%1")
end
local GetChildren = function(item)
  if IsKindOf(item, "ModDef") then
    return item.items
  else
    return item
  end
end
function ModElement:PostSave()
  self:AddPathPrefix()
end
local ModResourceExists = function(path)
  if io.exists(path) then
    return true
  end
  local res_id = ResourceManager.GetResourceID(path)
  return res_id ~= const.InvalidResourceID
end
local function RecursiveAddPathPrefix(item, mod_path, mod_os_path, mod_content_path, is_packed)
  for i, prop in ipairs(item:GetProperties()) do
    if prop.editor == "browse" or prop.editor == "ui_image" then
      local prop_id = prop.id
      local path = item:GetProperty(prop_id)
      if (path or "") ~= "" and not path:starts_with(ModContentPath) then
        if is_packed then
          if not ModResourceExists(path) then
            item:SetProperty(prop_id, mod_content_path .. path)
          end
        elseif not ModResourceExists(path) then
          local prefix = (prop.editor == "ui_image" or prop.os_path) and mod_os_path or mod_path
          if not string.find(path, EscapeMagicSymbols(prefix)) then
            item:SetProperty(prop_id, ModConvertSlashes(prefix .. path))
          end
        end
      end
    end
  end
  for _, child in ipairs(GetChildren(item)) do
    RecursiveAddPathPrefix(child, mod_path, mod_os_path, mod_content_path, is_packed)
  end
end
function ModElement:AddPathPrefix()
  local mod_path = ModConvertSlashes(self:GetModRootPath())
  local mod_os_path = ConvertToOSPath(mod_path)
  local mod_content_path = self:GetModContentPath()
  local is_packed = self.packed
  RecursiveAddPathPrefix(self, mod_path, mod_os_path, mod_content_path, is_packed)
end
function ModElement:PreSave()
  self:RemovePathPrefix()
end
local function RecursiveRemovePathPrefix(item, mod_path, mod_os_path, mod_content_path, is_packed)
  for i, prop in ipairs(item:GetProperties()) do
    if prop.editor == "browse" or prop.editor == "ui_image" then
      local prop_id = prop.id
      local path = item:GetProperty(prop_id)
      if (path or "") ~= "" and not path:starts_with(ModContentPath) then
        path = ModConvertSlashes(path)
        local prefix = is_packed and mod_content_path or (prop.editor == "ui_image" or prop.os_path) and mod_os_path or mod_path
        local new_path, substitutions = string.gsub(path, EscapeMagicSymbols(prefix), "")
        item:SetProperty(prop_id, new_path)
      end
    end
  end
  for _, child in ipairs(GetChildren(item)) do
    RecursiveRemovePathPrefix(child, mod_path, mod_os_path, mod_content_path, is_packed)
  end
end
function ModElement:RemovePathPrefix()
  local mod_path = ModConvertSlashes(self:GetModRootPath())
  local mod_os_path = ModConvertSlashes(ConvertToOSPath(mod_path))
  local mod_content_path = self:GetModContentPath()
  local is_packed = self.packed
  RecursiveRemovePathPrefix(self, mod_path, mod_os_path, mod_content_path, is_packed)
end
local update_folder = function(obj, org_folder)
  local mod_paths
  if obj.mod then
    mod_paths = {
      {
        obj.mod.path,
        os_path = true
      },
      {
        obj.mod.content_path,
        game_path = true
      }
    }
  else
    return org_folder
  end
  if type(org_folder) == "string" then
    local result = {org_folder}
    table.iappend(result, mod_paths)
    return result
  elseif type(org_folder) == "table" then
    local result = table.icopy(org_folder, false)
    table.iappend(result, mod_paths)
    return result
  else
    return mod_paths
  end
end
function ModElementFixPathProp(prop_meta)
  if prop_meta.mod_path_fixed then
    return prop_meta
  end
  prop_meta = table.copy(prop_meta, false)
  prop_meta.os_path = true
  prop_meta.mod_path_fixed = true
  prop_meta.no_validate = true
  local org_folder = prop_meta.folder
  if type(org_folder) == "function" then
    function prop_meta.folder(obj)
      return update_folder(obj, org_folder(obj))
    end
  elseif org_folder or prop_meta.editor == "ui_image" then
    function prop_meta.folder(obj)
      return update_folder(obj, org_folder)
    end
  end
  return prop_meta
end
function OnMsg.ClassesBuilt()
  for classname, classdef in pairs(ClassDescendants("ModItem")) do
    local properties = classdef.properties
    if properties ~= rawget(classdef, "properties") then
      classdef.properties = table.icopy(properties, false)
    end
    for i, prop_meta in ipairs(properties) do
      if prop_meta.editor == "browse" or prop_meta.editor == "ui_image" then
        properties[i] = ModElementFixPathProp(prop_meta)
      end
    end
  end
end
local folder_fn = function(def)
  return {
    def.content_path
  }
end
DefineClass.ModDef = {
  __parents = {
    "GedEditedObject",
    "ModElement",
    "Container"
  },
  properties = {
    {
      category = "Mod",
      id = "title",
      name = T(231279648013, "Title"),
      editor = "text",
      default = ""
    },
    {
      category = "Mod",
      id = "description",
      name = T(709903985268, "Description"),
      editor = "text",
      default = "",
      lines = 5,
      max_len = 8000
    },
    {
      category = "Mod",
      id = "tags",
      name = T(466449563015, "Tags"),
      editor = false,
      default = ""
    },
    {
      category = "Mod",
      id = "image",
      name = T(204294694071, "Preview image"),
      editor = "ui_image",
      default = "",
      folder = folder_fn,
      os_path = true,
      no_validate = true
    },
    {
      category = "Mod",
      id = "last_changes",
      name = T(206883363869, "Last changes"),
      editor = "text",
      default = "",
      lines = 3
    },
    {
      category = "Mod",
      id = "ignore_files",
      name = T(905481241550, "Ignore files"),
      editor = "string_list",
      default = {"*.git/*", "*.svn/*"}
    },
    {
      category = "Mod",
      id = "dependencies",
      name = T(913027412018, "Dependencies"),
      editor = "nested_list",
      default = false,
      base_class = "ModDependency",
      inclusive = true
    },
    {
      category = "Mod",
      id = "id",
      name = T(165832210760, "ID"),
      editor = "text",
      default = "",
      read_only = true
    },
    {
      category = "Mod",
      id = "content_path",
      name = T(882205310709, "Content path"),
      editor = "text",
      default = false,
      read_only = true,
      help = "Folder to access the mod files.",
      buttons = {
        {
          name = "Copy",
          func = "CopyContentPath"
        }
      }
    },
    {
      category = "Mod",
      id = "author",
      name = T(333967444298, "Author"),
      editor = "text",
      default = "",
      read_only = true
    },
    {
      category = "Mod",
      id = "version_major",
      name = T(736930500436, "Major Version"),
      editor = "number",
      default = 0
    },
    {
      category = "Mod",
      id = "version_minor",
      name = T(306168574153, "Minor Version"),
      editor = "number",
      default = 0
    },
    {
      category = "Mod",
      id = "version",
      name = T(361684282180, "Revision"),
      editor = "number",
      default = 0,
      read_only = true
    },
    {
      category = "Mod",
      id = "lua_revision",
      name = T(712321515235, "Required game version"),
      editor = "number",
      default = 0,
      read_only = true
    },
    {
      category = "Mod",
      id = "saved_with_revision",
      name = T(875810353513, "Saved with game version"),
      editor = "number",
      default = 0,
      read_only = true
    },
    {
      category = "Mod",
      id = "bin_assets",
      editor = "bool",
      default = false,
      no_edit = true
    },
    {
      category = "Mod",
      id = "code",
      editor = "prop_table",
      default = false,
      no_edit = true
    },
    {
      category = "Mod",
      id = "loctables",
      editor = "prop_table",
      default = false,
      no_edit = true
    },
    {
      category = "Mod",
      id = "has_options",
      editor = "bool",
      default = false,
      no_edit = true
    },
    {
      category = "Mod",
      id = "saved",
      editor = "number",
      default = false,
      no_edit = true
    },
    {
      category = "Mod",
      id = "code_hash",
      editor = "number",
      default = false,
      no_edit = true
    },
    {
      category = "Screenshot",
      id = "screenshot1",
      name = T(280411343974, "Screenshot"),
      editor = "ui_image",
      default = "",
      folder = folder_fn,
      os_path = true,
      no_validate = true
    },
    {
      category = "Screenshot",
      id = "screenshot2",
      name = T(280411343974, "Screenshot"),
      editor = "ui_image",
      default = "",
      folder = folder_fn,
      os_path = true,
      no_validate = true
    },
    {
      category = "Screenshot",
      id = "screenshot3",
      name = T(280411343974, "Screenshot"),
      editor = "ui_image",
      default = "",
      folder = folder_fn,
      os_path = true,
      no_validate = true
    },
    {
      category = "Screenshot",
      id = "screenshot4",
      name = T(280411343974, "Screenshot"),
      editor = "ui_image",
      default = "",
      folder = folder_fn,
      os_path = true,
      no_validate = true
    },
    {
      category = "Screenshot",
      id = "screenshot5",
      name = T(280411343974, "Screenshot"),
      editor = "ui_image",
      default = "",
      folder = folder_fn,
      os_path = true,
      no_validate = true
    }
  },
  path = "",
  source = "appdata",
  env = false,
  packed = false,
  mounted = false,
  status = "alive",
  items = false,
  options = false,
  dev_message = "",
  ContainerClass = "ModItem",
  force_reload = false,
  GedTreeChildren = function(self)
    return self.items
  end
}
function ModDef:CopyContentPath()
  CopyToClipboard(self.content_path)
end
function ModDef:delete()
  if self.status == "deleted" then
    return
  end
  self:UnloadItems()
  if self:IsMounted() then
    self:UnmountContent()
  end
  self.status = "deleted"
end
function ModDef:__eq(rhs)
  return self.id == rhs.id and self.source == rhs.source and self.version == rhs.version
end
function ModDef:GetTags()
  return {}
end
function ModDef:GetEditorView()
  if self:ItemsLoaded() then
    return Untranslated([[
<u(title)> (loaded)
id <u(id)>, version <VersionText>]])
  else
    return Untranslated([[
<color 128 128 128><u(title)>
id <u(id)>, version <VersionText></color>]])
  end
end
local ModIdCharacters = "ACDEFGHJKLMNPQRSTUVWXYabcdefghijkmnopqrstuvwxyz345679"
function ModDef:GenerateId()
  local id = ""
  for i = 1, 7 do
    local rand = AsyncRand(1 < i and #ModIdCharacters or #ModIdCharacters - 10)
    id = id .. ModIdCharacters:sub(rand, rand)
  end
  return id
end
function ModDef:ChangePaths(mod_path, content_path)
  self:RemovePathPrefix()
  self.path = mod_path
  self.content_path = content_path
  rawset(self.env, "CurrentModPath", self.content_path)
  self:AddPathPrefix()
end
function ModDef:SortItems()
  table.stable_sort(self.items, function(a, b)
    if a.class == b.class then
      return a.name < b.name
    end
    return a.class < b.class
  end)
end
function ModDef:ItemsLoaded()
  return not not self.items
end
function ModDef:GenerateModItemId(mod_item)
  return string.format("autoid_%s_%s", self.id, self:GenerateId())
end
function ModDef:GetOptionItems(test)
  local options_items = not test and {}
  if not self.items then
    return options_items
  end
  for _, item in ipairs(self.items) do
    if IsKindOf(item, "ModItemOption") and item.name and item.name ~= "" then
      if test then
        return true
      end
      table.insert(options_items, item)
    end
  end
  return options_items
end
function ModDef:LoadItems()
  if self:ItemsLoaded() then
    return
  end
  mod_print("once", "Loading %s(id %s, version %s) items from %s", self.title, self.id, self:GetVersionString(), self.content_path or self.path)
  local ok, items = pdofile(self.content_path .. "items.lua", self.env)
  self.items = ok and items or {}
  if not ok then
    local err = items
    ModLog(T({
      759318486004,
      "Failed to load mod items from <ModLabel>. Error: <u(err)>",
      err = err,
      self
    }))
  else
    PopulateParentTableCache(self)
  end
  for _, item in ipairs(self.items) do
    item.mod = self
    item:OnModLoad(self)
  end
end
function ModDef:LoadOptions()
  if not self.has_options then
    self:UnloadOptions()
    return
  end
  if AccountStorage then
    local options_in_storage = AccountStorage.ModOptions and AccountStorage.ModOptions[self.id]
    local options_data = options_in_storage and table.copy(options_in_storage)
    local options_obj = ModOptionsObject:new(options_data)
    options_obj.__mod = self
    self.options = options_obj
    for i, prop in ipairs(self.options:GetProperties()) do
      if rawget(self.options, prop.id) == nil then
        rawset(self.options, prop.id, self.options:GetDefaultPropertyValue(prop.id))
      end
    end
    rawset(self.env, "CurrentModOptions", options_obj)
  end
end
function ModDef:UnloadOptions()
  if IsKindOf(self.options, "ModOptionsObject") then
    self.options:delete()
  end
  self.options = false
  if self.env then
    rawset(self.env, "CurrentModOptions", {})
  end
end
function ModDef:UnloadItems()
  if not self:ItemsLoaded() then
    return
  end
  for _, item in ipairs(self.items) do
    item:OnModUnload(self)
    item:delete()
  end
  self.items = false
end
function ApplyModOptions(host)
  CreateRealTimeThread(function(host)
    local mod = GetDialogModeParam(host)
    local options = mod.options
    if not options then
      return
    end
    Msg("ApplyModOptions", mod.id)
    AccountStorage.ModOptions = AccountStorage.ModOptions or {}
    local storage_table = AccountStorage.ModOptions[mod.id] or {}
    for _, prop in ipairs(options:GetProperties()) do
      local value = options:GetProperty(prop.id)
      value = type(value) == "table" and table.copy(value) or value
      storage_table[prop.id] = value
    end
    AccountStorage.ModOptions[mod.id] = storage_table
    SaveAccountStorage(1000)
    SetBackDialogMode(host)
  end, host)
end
function CancelModOptions(host)
  CreateRealTimeThread(function(host)
    local mod = GetDialogModeParam(host)
    local original_obj = ResolvePropObj(host:ResolveId("idOriginalModOptions").context)
    if not mod or not original_obj then
      return
    end
    local properties = mod.options:GetProperties()
    for i = 1, #properties do
      local prop = properties[i]
      local original_value = original_obj:GetProperty(prop.id)
      mod.options:SetProperty(prop.id, original_value)
    end
    SetBackDialogMode(host)
  end, host)
end
function ResetModOptions(host)
  CreateRealTimeThread(function(host)
    local mod = GetDialogModeParam(host)
    local options = mod and mod.options
    if not options then
      return
    end
    local properties = mod.options:GetProperties()
    for i = 1, #properties do
      local prop = properties[i]
      local default_value = mod.options:GetDefaultPropertyValue(prop.id, prop)
      mod.options:SetProperty(prop.id, default_value)
    end
    ObjModified(mod.options)
  end, host)
end
function HasModsWithOptions()
  local mods_to_load = AccountStorage and AccountStorage.LoadMods
  if not mods_to_load then
    return
  end
  for i, id in ipairs(mods_to_load) do
    local mod_def = Mods[id]
    if mod_def and mod_def.has_options then
      return true
    end
  end
end
function HasModsWithLoadedOptions()
  local mods_to_load = AccountStorage and AccountStorage.LoadMods
  if not mods_to_load then
    return false
  end
  for i, id in ipairs(mods_to_load) do
    local mod_def = Mods[id]
    if mod_def and mod_def.has_options and mod_def.options then
      return true
    end
  end
end
function ModDef:UpdateBinAssets()
  self.bin_assets = false
  if self.items then
    for i, item in ipairs(self.items) do
      if IsKindOfClasses(item, "ModItemEntity", "ModItemDecalEntity") then
        self.bin_assets = true
        break
      end
    end
  end
end
function ModDef:UpdateCode()
  local dirty
  if self.items then
    local code = false
    local code_hash
    for _, item in ipairs(self.items) do
      local name = item:GetCodeFileName() or ""
      if name ~= "" or item.lua_reload then
        code = code or {}
        code[#code + 1] = name
        local err, hash
        if name ~= "" then
          err, hash = AsyncFileToString(item:GetCodeFilePath(), nil, nil, "hash")
        end
        code_hash = xxhash(code_hash, name, hash)
        dirty = dirty or err or item:IsDirty()
      end
    end
    dirty = dirty or code_hash ~= self.code_hash
    self.code = code
    self.code_hash = code_hash
  end
  return dirty
end
function ModDef:UpdateLocTables()
  if self.items then
    local loctables
    for _, item in ipairs(self.items) do
      if IsKindOf(item, "ModItemLocTable") then
        loctables = loctables or {}
        item:RemovePathPrefix()
        loctables[#loctables + 1] = {
          filename = item.filename,
          language = item.language
        }
        item:AddPathPrefix()
      end
    end
    self.loctables = loctables
  end
end
function ModDef:MountContent()
  if self.mounted then
    return
  end
  self.mounted = true
  if self.packed then
    MountPack(self.content_path, self.path .. ModsPackFileName)
  else
    MountFolder(self.content_path, self.path)
  end
end
function ModDef:UnmountContent()
  if not self.mounted then
    return
  end
  UnmountByPath(self.content_path)
  self.mounted = false
end
function ModDef:IsMounted()
  return self.mounted
end
function ModDef:GetModRootPath()
  local os_root_path = ConvertToOSPath(SlashTerminate(self.content_path))
  return io.exists(os_root_path) and os_root_path or self.content_path
end
function ModDef:GetModContentPath()
  return self.content_path
end
function ModDef:IsTooOld()
  return self.lua_revision < ModMinLuaRevision
end
function ModDef:IsTooNew()
  return self.lua_revision > LuaRevision
end
function ModDef:SaveDef(serialize_only)
  if self.content_path then
    local code_dirty
    if not serialize_only then
      GedSetUiStatus("mod_save", "Saving...")
      Msg("ModDefUpdate", self)
      self.lua_revision = ModRequiredLuaRevision
      self.saved_with_revision = LuaRevision
      self.version = self.version + 1
      self.saved = os.time()
      self.has_options = self:GetOptionItems("test")
      self:UpdateBinAssets()
      self:UpdateLocTables()
      code_dirty = self:UpdateCode()
    end
    local data = pstr("return ", 32768)
    self:PreSave()
    data:appendv(self, "")
    self:PostSave()
    local err = AsyncStringToFile(self.content_path .. "metadata.lua", data)
    if not serialize_only then
      CreateRealTimeThread(function()
        Sleep(200)
        GedSetUiStatus("mod_save")
        self:MarkClean()
        for _, item in ipairs(self.items) do
          item:MarkClean()
        end
        ObjModified(self)
      end)
    end
    return err, code_dirty
  end
end
function ModDef:SaveItems()
  InvalidateGetFuncSourceCache()
  if not self:ItemsLoaded() then
    return "not loaded"
  end
  local data = pstr("return {\n", 65536)
  for _, item in ipairs(self.items) do
    item:PreSave()
    ValueToLuaCode(item, "", data)
    data:append(",\n")
    item:PostSave()
  end
  data:append("}\n")
  local err = AsyncStringToFile(self.content_path .. "items.lua", data)
  data:free()
  return err
end
function ModDef:SaveOptions()
  if self.options then
    self.options.properties = nil
    self.options.__defaults = nil
  end
end
function ModDef:CompareVersion(other_mod, ignore_revision)
  local version_diffs = {
    self.version_major - (other_mod.version_major or self.version_major),
    self.version_minor - (other_mod.version_minor or self.version_minor),
    ignore_revision and 0 or self.version - (other_mod.version or 0)
  }
  for i = 1, #version_diffs do
    local diff = version_diffs[i]
    if diff ~= 0 then
      return diff
    end
  end
  return 0
end
function ModDef:GetVersionString()
  return string.format("%d.%02d-%03d", self.version_major, self.version_minor, self.version)
end
function ModDef:GetVersionText()
  return Untranslated(self:GetVersionString())
end
function ModDef:GetModLabel()
  return T({
    154821836384,
    "<u(title)> (id <u(id)>, version <VersionText>)",
    self
  })
end
function ModDef:__persist()
  local mod_info = {
    title = self.title,
    id = self.id,
    version_major = self.version_major,
    version_minor = self.version_minor,
    version = self.version,
    lua_revision = self.lua_revision
  }
  return function()
    setmetatable(mod_info, ModDef)
    local mod_def = Mods[mod_info.id]
    if mod_def then
      if not mod_def.items then
        ModLog(T({
          305692853246,
          "This savegame tries to load Mod <ModLabel>, which is present, but not loaded",
          mod_def
        }))
      elseif mod_def:CompareVersion(mod_info) ~= 0 then
        ModLog(T({
          989575993422,
          "This savegame tries to load Mod <ModLabel>, which is loaded with a different version <version>",
          mod_info,
          version = mod_def:GetVersionText()
        }))
      else
        ModLog(T({
          370182116047,
          "This savegame loads Mod <ModLabel>",
          mod_def
        }))
      end
      return mod_def
    else
      ModLog(T({
        919286620422,
        "Savegame references Mod <ModLabel> which is not present",
        mod_info
      }))
    end
    return mod_info
  end
end
function OnMsg.PersistSave(data)
  data.ModsLoaded = ModsLoaded
end
function OnMsg.BugReportStart(print_func)
  local list = {}
  for i, mod in ipairs(ModsLoaded) do
    table.insert(list, string.format("%s (Id: %s, Source: %s, Version: %s, Required Lua: %d, Saved with Lua: %d", mod.title, mod.id, mod.source, mod:GetVersionString(), mod.lua_revision, mod.saved_with_revision))
  end
  table.sort(list)
  print_func("Loaded Mods: " .. (next(list) and [[

	]] .. table.concat(list, [[

	]]) or "None") .. "\n")
  local codes = {}
  Msg("GatherModDownloadCode", codes)
  if next(codes) then
    print_func("Paste in the console to download mods:")
    for source, code in pairs(codes) do
      print_func("\t", code)
    end
    print_func("\n")
  end
end
ModEnvBlacklist = {
  IsDlcOwned = true,
  AccountStorage = true,
  async = true,
  AsyncOpWait = true,
  FirstLoad = true,
  InitDefaultAccountStorage = true,
  ReloadLua = true,
  SetAccountStorage = true,
  SaveAccountStorage = true,
  XPlayerActivate = true,
  XPlayersReset = true,
  WaitLoadAccountStorage = true,
  WaitSaveAccountStorage = true,
  _DoSaveAccountStorage = true,
  ConsoleExec = true,
  Crash = true,
  Stomp = true,
  Msg = true,
  OnMsg = true,
  ModMsgBlacklist = true,
  GetAutoCompletionList = true,
  GedOpInspectorSetGlobal = true,
  getfileline = true,
  CompileExpression = true,
  CompileFunc = true,
  GetFuncSourceString = true,
  GetFuncSource = true,
  FuncSource = true,
  LoadConfig = true,
  FileToLuaValue = true,
  SVNDeleteFile = true,
  SVNAddFile = true,
  SVNMoveFile = true,
  SVNLocalInfo = true,
  SVNShowLog = true,
  SVNShowBlame = true,
  SVNShowDiff = true,
  SaveSVNFile = true,
  GetSvnInfo = true,
  StringToFileIfDifferent = true,
  GetCallLine = true,
  SaveLuaTableToDisk = true,
  LoadLuaTableFromDisk = true,
  insideHG = true,
  SaveLanguageOption = true,
  GetMachineID = true,
  SaveDLCOwnershipDataToDisk = true,
  LoadDLCOwnershipDataFromDisk = true,
  GetLuaSaveGameData = true,
  GetLuaLoadGamePermanents = true,
  AsyncAchievementUnlock = true,
  AsyncCopyFile = true,
  AsyncCreatePath = true,
  AsyncDeletePath = true,
  AsyncExec = true,
  AsyncFileClose = true,
  AsyncFileDelete = true,
  AsyncFileFlush = true,
  AsyncFileOpen = true,
  AsyncFileRead = true,
  AsyncFileRename = true,
  AsyncFileToString = true,
  AsyncFileWrite = true,
  AsyncGetFileAttribute = true,
  AsyncGetSourceInfo = true,
  AsyncListFiles = true,
  AsyncMountPack = true,
  AsyncPack = true,
  AsyncStringToFile = true,
  AsyncSetFileAttribute = true,
  AsyncUnmount = true,
  AsyncUnpack = true,
  CheatPlatformUnlockAllAchievements = true,
  CheatPlatformResetAllAchievements = true,
  CopyFile = true,
  DeleteFolderTree = true,
  EV_OpenFile = true,
  FileToLuaValue = true,
  LoadFilesForSearch = true,
  MountFolder = true,
  MountPack = true,
  OS_OpenFile = true,
  PreloadFiles = true,
  StringToFileIfDifferent = true,
  Unmount = true,
  DeleteMod = true,
  AsyncWebRequest = true,
  AsyncWebSocket = true,
  hasRfnPrefix = true,
  LocalIPs = true,
  sockAdvanceDeadline = true,
  sockConnect = true,
  sockDelete = true,
  sockDisconnect = true,
  sockEncryptionKey = true,
  sockGenRSAEncryptedKey = true,
  sockGetGroup = true,
  sockGetHostName = true,
  sockGroupStats = true,
  sockListen = true,
  sockNew = true,
  sockProcess = true,
  sockResolveName = true,
  sockSend = true,
  sockSetGroup = true,
  sockSetOption = true,
  sockSetRSAEncryptedKey = true,
  sockStr = true,
  sockStructs = true,
  ModEnvBlacklist = true,
  LuaModEnv = true,
  ModsReloadDefs = true,
  ModsPackFileName = true,
  ModsScreenshotPrefix = true,
  _G = true,
  getfenv = true,
  setfenv = true,
  getmetatable = true,
  rawget = true,
  collectgarbage = true,
  load = true,
  loadfile = true,
  loadstring = true,
  dofile = true,
  pdofile = true,
  dofolder = true,
  dofolder_files = true,
  dofolder_folders = true,
  dostring = true,
  module = true,
  require = true,
  debug = true,
  io = true,
  os = true,
  package = true,
  lfs = true
}
ModMsgBlacklist = {
  PersistGatherPermanents = true,
  PersistLoad = true,
  PersistSave = true,
  ModBlacklistPrefixes = true,
  PasswordChanged = true
}
function OnMsg.Autorun()
  local string_starts_with = string.starts_with
  local prefixes = {"Debug"}
  Msg("ModBlacklistPrefixes", prefixes)
  for key, value in pairs(_G) do
    if type(key) == "string" then
      for _, prefix in ipairs(prefixes) do
        if string_starts_with(key, prefix, true) then
          ModEnvBlacklist[key] = true
          break
        end
      end
    end
  end
end
const.MaxModDataSize = 32768
local max_data_length = const.MaxModDataSize
local WriteModPersistentData = function(mod, data)
  if type(data) ~= "string" then
    return "data must be a string"
  end
  if #data > max_data_length then
    return string.format("data longer than const.MaxModDataSize (%d bytes)", max_data_length)
  end
  if not AccountStorage.ModPersistentData then
    AccountStorage.ModPersistentData = {}
  end
  AccountStorage.ModPersistentData[mod.id] = data
  SaveAccountStorage(5000)
end
local ReadModPersistentData = function(mod)
  return nil, AccountStorage.ModPersistentData and AccountStorage.ModPersistentData[mod.id]
end
local WriteModPersistentStorageTable = function(mod)
  local storage = rawget(mod.env, "CurrentModStorageTable")
  if type(storage) ~= "table" then
    storage = {}
  end
  local data = TupleToLuaCode(storage)
  return WriteModPersistentData(mod, data)
end
local CreateModPersistentStorageTable = function(mod)
  if not AccountStorage then
    WaitLoadAccountStorage()
  end
  local storage
  local err, data = ReadModPersistentData(mod)
  if not err then
    err, storage = LuaCodeToTuple(data, mod.env)
  end
  if type(storage) ~= "table" then
    storage = {}
  end
  return storage
end
function LuaModEnv(env)
  env = env or {}
  local env_meta = {}
  local original_G = _G
  local value_whitelist = {}
  local env_blacklist = ModEnvBlacklist
  local meta_blacklist = {}
  meta_blacklist[env_meta] = true
  meta_blacklist[original_G] = true
  for k in pairs(value_whitelist) do
    if env[k] == nil then
      env[k] = original_G[k]
    end
  end
  function env_meta.__index(env, key)
    if env_blacklist[key] then
      return
    end
    return original_G[key]
  end
  function env_meta.__newindex(env, key, value)
    if env_blacklist[key] then
      return
    end
    original_G[key] = value
  end
  local safe_getmetatable = function(t)
    local meta = getmetatable(t)
    if meta_blacklist[meta] then
      return
    end
    return meta
  end
  local safe_setmetatable = function(t, new_meta)
    local meta = getmetatable(t)
    if meta_blacklist[meta] then
      return
    end
    return setmetatable(t, new_meta)
  end
  local safe_rawget = function(t, key)
    local t_value = rawget(t, key)
    if t == env and t_value == nil and not env_blacklist[key] then
      return rawget(original_G, key)
    end
    return t_value
  end
  local safe_Msg = function(name, ...)
    if ModMsgBlacklist[name] then
      return
    end
    local raw_Msg = original_G.Msg
    return raw_Msg(name, ...)
  end
  local safe_OnMsg = {}
  setmetatable(safe_OnMsg, {
    __newindex = function(_, name, func)
      if ModMsgBlacklist[name] then
        return
      end
      local raw_OnMsg = original_G.OnMsg
      raw_OnMsg[name] = func
    end
  })
  env._G = env
  env.getmetatable = safe_getmetatable
  env.rawget = safe_rawget
  env.os = {
    time = os.time
  }
  env.Msg = safe_Msg
  env.OnMsg = safe_OnMsg
  setmetatable(env, env_meta)
  return env
end
if FirstLoad then
  SharedModEnv = {}
end
function ModDef:SetupEnv()
  local env = self.env
  rawset(env, "CurrentModPath", self.content_path)
  rawset(env, "CurrentModId", self.id)
  rawset(env, "CurrentModDef", self)
  rawset(env, "CurrentModStorageTable", CreateModPersistentStorageTable(self))
  rawset(env, "WriteModPersistentData", function(...)
    return WriteModPersistentData(self, ...)
  end)
  rawset(env, "ReadModPersistentData", function(...)
    return ReadModPersistentData(self, ...)
  end)
  rawset(env, "WriteModPersistentStorageTable", function(...)
    return WriteModPersistentStorageTable(self, ...)
  end)
end
function OnMsg.PersistGatherPermanents(permanents)
  permanents["func:getmetatable"] = getmetatable
  permanents["func:setmetatable"] = setmetatable
  permanents["func:os.time"] = os.time
  permanents["func:Msg"] = Msg
end
function CanLoadUnpackedMods()
  return not Platform.console
end
function ListModFolders(path, source)
  path = SlashTerminate(path)
  local folders = io.listfiles(path, "*", "folders")
  table.sort(folders, CmpLower)
  if next(folders) then
    local folder_names = table.imap(folders, string.sub, #path + 1)
    mod_print("once", "Mods folders (%s): %s", source, table.concat(folder_names, ", "))
  end
  for i = 1, #folders do
    folders[i] = {
      path = folders[i],
      source = source
    }
  end
  return folders
end
function SortModsList()
  if #(ModsList or "") <= 1 then
    return
  end
  table.sort(ModsList, function(a, b)
    if b:ItemsLoaded() then
      return a:ItemsLoaded() and a.title < b.title
    end
    return a:ItemsLoaded() or a.title < b.title
  end)
end
function ModsReloadDefs()
  local folders = {}
  if Platform.desktop then
    local f = ListModFolders("AppData/Mods/", "appdata")
    table.iappend(folders, f)
  end
  if config.AdditionalModFolder then
    local f = ListModFolders(config.AdditionalModFolder, "additional")
    table.iappend(folders, f)
  end
  Msg("GatherModDefFolders", folders)
  ModLog(T({
    450227350871,
    "Loading mod metadata for <n> mods...",
    n = #folders
  }))
  local metadata_env = {
    PlaceObj = function(class, ...)
      if class ~= "ModDef" and class ~= "ModDependency" then
        return
      end
      return PlaceObj(class, ...)
    end
  }
  local new_mods = {}
  for i, folder in ipairs(folders) do
    local env, ok, def, is_packed
    local source = folder.source
    local pack_path = folder.path .. "/" .. ModsPackFileName
    local folder_name = string.sub(folder.path, (string.match(folder.path, "^.*()/") or 0) + 1)
    if io.exists(pack_path) then
      local hpk_mounted_path = "PackedMods/" .. folder_name
      local err = MountPack(hpk_mounted_path, pack_path)
      if not err then
        env = LuaModEnv()
        is_packed = true
        ok, def = pdofile(hpk_mounted_path .. "/metadata.lua", metadata_env, "t")
        if ok and IsKindOf(def, "ModDef") then
          Msg("PackedModDefLoaded", pack_path, def)
        end
        UnmountByPath(hpk_mounted_path)
      else
        mod_print("once", "Failed to unpack mod from <%s>/%s: %s", source, folder_name, err)
      end
    elseif folder.source == "appdata" or folder.source == "additional" or CanLoadUnpackedMods() then
      env = LuaModEnv()
      ok, def = pdofile(folder.path .. "/metadata.lua", metadata_env, "t")
    end
    if env and def and IsKindOf(def, "ModDef") then
      def.env = env
      def.packed = is_packed
      def.path = folder.path .. "/"
      def.content_path = ModContentPath .. def.id .. "/"
      def.source = source
      local mod_used
      if def:IsTooOld() then
        ModLog(T({
          412548794790,
          "Outdated definition for <ModLabel> loaded from <source>. (Unsupported game version)",
          def,
          source = Untranslated(def.source)
        }))
      else
        local packed_str = is_packed and "packed" or "unpacked"
        mod_print("once", "Loaded mod def %s(id %s, version %s) %s from %s", def.title, def.id, def:GetVersionString(), packed_str, def.source)
      end
      local old = new_mods[def.id]
      if old then
        if 0 <= old:CompareVersion(def) then
          ModLog(T({
            399686028761,
            "Mod <ModLabel> ignored because a newer version is already loaded",
            def
          }))
        else
          ModLog(T({
            367179878997,
            "Mod <ModLabel> will replace an older version of the same mod",
            def
          }))
          new_mods[def.id] = def
          mod_used = true
        end
      else
        new_mods[def.id] = def
        mod_used = true
      end
      if mod_used then
        if old then
          old:delete()
        end
        def:SetupEnv()
        def:MountContent()
        def:OnLoad()
      else
        def:delete()
      end
    else
      local err = def
      if not err:ends_with("File Not Found") then
        ModLog(T({
          847285427293,
          "Failed to load mod metadata from <u(path)>. Error: <u(err)>",
          path = folder.path,
          err = err
        }))
      end
    end
  end
  local old_mods = Mods
  local new_ids, old_ids = table.keys(new_mods), table.keys(old_mods)
  local any_changes = not table.is_subset(new_ids, old_ids) or not table.is_subset(old_ids, new_ids)
  if not any_changes then
    for id, new_mod in pairs(new_mods) do
      local old_mod = old_mods[id]
      if not old_mod or new_mod ~= old_mod then
        any_changes = true
        break
      end
    end
  end
  if not any_changes then
    for id, new_mod in pairs(new_mods) do
      if new_mod:IsMounted() then
        new_mod.mounted = false
      end
      new_mod:delete()
    end
    ModsList = ModsList or {}
    return
  end
  local any_loaded = not not next(ModsLoaded)
  for id, mod in pairs(Mods or empty_table) do
    mod:delete()
  end
  Mods = new_mods
  ModsList = {}
  for id, mod in pairs(Mods) do
    ModsList[#ModsList + 1] = mod
  end
  SortModsList()
  CacheModDependencyGraph()
  Msg("ModDefsLoaded")
  if any_loaded then
    ModsReloadItems()
  end
end
local GetModAllDependencies = function(mod)
  local result = {}
  for i, dep in ipairs(mod.dependencies or empty_table) do
    if dep.id and dep.id ~= "" and not table.find(result, "id", dep.id) then
      table.insert(result, dep)
    end
  end
  return result
end
local function GetModDependenciesList(mod, result)
  result = result or {}
  if mod then
    local dependencies = GetModAllDependencies(mod)
    for i, dep in ipairs(dependencies) do
      local dep_id = dep.id
      local dep_mod = Mods[dep_id]
      if dep_mod then
        if table.find(result, dep_mod) then
          return "cycle"
        end
        table.insert(result, dep_mod)
        local err = GetModDependenciesList(dep_mod, result)
        if err then
          return err
        end
      else
        table.insert(result, dep_id)
      end
    end
  end
  return false, result
end
local DetectDependencyError = function(dep, all, dep_mod, stack)
  if dep.required then
    if stack[dep.id] then
      return "cycle"
    elseif not table.find(all, dep.id) then
      return "not loaded"
    end
  elseif not dep:ModFits(dep_mod) then
    return "incompatible"
  end
end
local function EnqueueMod(mod, all, queue, stack)
  if not mod then
    return "no mod"
  end
  if queue[mod.id] then
    return
  end
  local dependencies = GetModAllDependencies(mod)
  if next(dependencies) then
    stack[mod.id] = true
    local prev_queue = table.copy(queue)
    for i, dep in ipairs(dependencies) do
      local dep_mod = Mods[dep.id]
      if not mod.force_reload then
        if dep_mod then
          local err = DetectDependencyError(dep, all, dep_mod, stack)
          if err then
            if err == "cycle" then
              local other_mods = {}
              for id in pairs(stack) do
                table.insert(other_mods, Untranslated(Mods[id].title))
              end
              ModLog(T({
                142054361193,
                "Mod <depending_mod> creates circular dependency cylce with <other_mods>.",
                depending_mod = mod:GetModLabel(),
                other_mods = TList(other_mods)
              }))
            elseif err == "not loaded" then
              ModLog(T({
                268731583612,
                "Cannot load <depending_mod> because dependency mod <dependency> is not active.",
                depending_mod = mod:GetModLabel(),
                dependency = dep_mod:GetModLabel()
              }))
            elseif err == "incompatible" then
              ModLog(T({
                188148282695,
                "Cannot load <depending_mod> because dependency mod <dependency> is not compatible.",
                depending_mod = mod:GetModLabel(),
                dependency = dep_mod:GetModLabel()
              }))
            end
            stack[mod.id] = nil
            return err
          end
        else
          ModLog(T({
            330783547362,
            "Cannot load <depending_mod> because dependency mod <title> is not found.",
            depending_mod = mod:GetModLabel(),
            title = Untranslated(dep.title)
          }))
          stack[mod.id] = nil
          return "not found"
        end
      end
      local err = EnqueueMod(dep_mod, all, queue, stack)
      if err then
        local i = 1
        while i <= #queue do
          local id = queue[i]
          if not prev_queue[id] then
            queue[id] = nil
            table.remove(queue, i)
          else
            i = i + 1
          end
        end
        if not mod.force_reload then
          stack[mod.id] = nil
          return err
        end
      end
    end
    stack[mod.id] = nil
  end
  table.insert(queue, mod.id)
  queue[mod.id] = mod
end
local GetLoadingQueue = function(list)
  local queue = {}
  for i, mod_id in ipairs(list) do
    EnqueueMod(Mods[mod_id], list, queue, {})
  end
  return queue
end
function ModsReloadItems(map_folder, force_reload)
  if not config.Mods then
    return
  end
  local list
  if AccountStorage and AccountStorage.LoadAllMods or config.LoadAllMods then
    list = table.keys(Mods or {})
    table.sort(list)
  end
  list = list or AccountStorage and table.icopy(AccountStorage.LoadMods) or {}
  local loaded_ids = ModsLoaded and table.map(ModsLoaded, "id") or {}
  table.sort(loaded_ids)
  table.sort(list)
  if table.iequal(loaded_ids, list) and not force_reload then
    return
  end
  if 0 < #list then
    ModLog(T({
      974645109089,
      "Loading mod items for <n> mods...",
      n = #list
    }))
  end
  local reload_assets, reload_lua
  if ModsLoaded then
    for _, mod in ipairs(ModsLoaded) do
      if mod:ItemsLoaded() or mod.status == "deleted" then
        mod:UnloadItems()
        mod:UnloadOptions()
        if mod.code then
          reload_lua = true
        end
        if mod.bin_assets then
          reload_assets = true
        end
      end
    end
  end
  ModsLoaded = {}
  if IsUserCreatedContentAllowed() then
    local queue = GetLoadingQueue(list)
    for i, id in ipairs(queue) do
      local mod = Mods[id]
      if mod then
        if not mod:IsTooOld() or mod.force_reload then
          mod.force_reload = false
          ModsLoaded[#ModsLoaded + 1] = mod
          if mod.code then
            reload_lua = true
          end
          if mod.bin_assets then
            reload_assets = true
          end
        else
          ModLog(T({
            294257203898,
            "Outdated mod <ModLabel> cannot be loaded. (Unsupported game version)",
            mod
          }))
        end
      end
    end
  end
  local new_mods_loaded
  for _, mod in ipairs(ModsLoaded) do
    if not mod:ItemsLoaded() then
      mod:LoadItems()
      new_mods_loaded = true
    end
  end
  for _, mod in ipairs(ModsLoaded) do
    mod:LoadOptions()
  end
  if reload_assets then
    ModsLoadAssets(map_folder)
    WaitDelayedLoadEntities()
  end
  if reload_lua then
    ReloadLua()
  end
  if new_mods_loaded then
    WaitDelayedLoadEntities()
    ReloadClassEntities()
    if const.UseDistanceFading then
      for i, mod in ipairs(ModsLoaded) do
        for j, item in ipairs(mod.items) do
          if IsKindOf(item, "ModItemDecalEntity") then
            SetEntityFadeDistances(item.entity_name, -1, -1)
          end
        end
      end
    end
  end
  PopulateParentTableCache(Mods)
  ObjModified(ModsList)
  Msg("ModsReloaded")
end
function ModsLoadAssets(map_folder)
  LoadingScreenOpen("idModEntitesReload", "ModEntitesReload")
  local old_render_mode = GetRenderMode()
  WaitRenderMode("ui")
  ForceReloadBinAssets()
  DlcReloadAssets(DlcDefinitions)
  LoadBinAssets(map_folder or CurrentMapFolder)
  while AreBinAssetsLoading() do
    Sleep(1)
  end
  UnmountBinAssets()
  WaitRenderMode(old_render_mode)
  hr.TR_ForceReloadNoTextures = 1
  LoadingScreenClose("idModEntitesReload", "ModEntitesReload")
end
if FirstLoad then
  LuaLoadedForMods = {}
end
function ModsLoadCode()
  for _, mod in ipairs(ModsLoaded or empty_table) do
    if not LuaLoadedForMods[mod.id] then
      rawset(mod.env, "FirstLoad", true)
      LuaLoadedForMods[mod.id] = true
    end
    for _, filename in ipairs(mod.code or empty_table) do
      local file_path = mod.content_path .. filename
      local ok, err = pdofile(file_path, mod.env, "t")
      if not ok then
        ModLog(T({
          832337318277,
          "Error loading <u(file)>: <u(err)>",
          file = file_path,
          err = err or ""
        }))
      end
    end
    rawset(mod.env, "FirstLoad", false)
  end
end
function ModsLoadLocTables()
  local list
  if not config.Mods then
    return
  end
  if AccountStorage and AccountStorage.LoadAllMods or config.LoadAllMods then
    list = table.keys(Mods or {})
    table.sort(list)
  end
  list = list or AccountStorage and AccountStorage.LoadMods or {}
  local loctables_loaded
  for i, id in ipairs(list) do
    local mod = Mods[id]
    if mod then
      if mod:IsTooOld() then
        ModLog(T({
          294257203898,
          "Outdated mod <ModLabel> cannot be loaded. (Unsupported game version)",
          mod
        }))
      else
        for _, loctable in ipairs(mod.loctables or empty_table) do
          if loctable.language == GetLanguage() or loctable.language == "Any" then
            local file_path = mod.content_path .. loctable.filename
            if io.exists(file_path) then
              LoadTranslationTableFile(file_path)
              loctables_loaded = true
            end
          end
        end
      end
    end
  end
  if loctables_loaded then
    Msg("TranslationChanged")
  end
end
function RemoveOutdatedMods(parent)
  local list = AccountStorage and AccountStorage.LoadMods
  if not list then
    return
  end
  if not Mods then
    return
  end
  local has_outdated_mods
  local i = 1
  while i <= #list do
    local mod = Mods[list[i]]
    if mod and mod:IsTooOld() then
      table.remove(list, i)
      has_outdated_mods = true
    else
      i = i + 1
    end
  end
  if has_outdated_mods then
    SaveAccountStorage(5000)
    CreateRealTimeThread(WaitMessage, parent or terminal.desktop, T(196483346617, "Outdated Mods"), T(167380182495, "Certain mods are disabled because they are not supported by the current version of the game."))
  end
end
function OnMsg.NewMapLoaded()
  if CurrentMap ~= "Mod" then
    return
  end
  local classes = {}
  Msg("GatherTestableModItemClasses", classes)
  if not next(classes) then
    return
  end
  local latest_mod
  for i, mod_def in ipairs(ModsLoaded) do
    if (mod_def.source == "appdata" or mod_def.source == "additional") and not mod_def.packed and (not latest_mod or mod_def.saved > latest_mod.saved) then
      latest_mod = mod_def
    end
  end
  local chosen_items = {}
  local all_items = {}
  if latest_mod then
    for j, item in ipairs(latest_mod.items or empty_table) do
      for k, classname in ipairs(classes) do
        if not chosen_items[classname] and IsKindOf(item, classname) then
          all_items[classname] = all_items[classname] or {}
          table.insert(all_items[classname], item)
        end
      end
    end
  end
  for j, classname in ipairs(classes) do
    if not chosen_items[classname] and #(all_items[classname] or "") == 1 then
      chosen_items[classname] = all_items[classname][1]
    end
  end
  Msg("CurrentlyEditedModItemsChosen", chosen_items, all_items)
end
DefineClass.ModItem = {
  __parents = {
    "GedEditedObject",
    "InitDone",
    "ModElement",
    "Container"
  },
  properties = {
    {
      category = "Mod",
      id = "name",
      name = T(126741858615, "Name"),
      default = "",
      editor = "text",
      editor_update = "items"
    },
    {
      category = "Mod",
      id = "comment",
      name = T(964541079092, "Comment"),
      default = "",
      editor = "text",
      editor_update = "items",
      lines = 1,
      max_lines = 5
    }
  },
  mod = false,
  lua_reload = false,
  EditorName = false,
  ModItemDescription = T(674857971939, "<u(name)>"),
  EditorView = Untranslated("<color 128 128 128><u(EditorName)></color> <ModItemDescription> <color 75 105 198><u(comment)></color>")
}
function ModItem:OnEditorNew(mod, ged, is_paste)
end
function ModItem:OnEditorDelete(mod, ged)
  local path = self:GetCodeFilePath()
  if path and path ~= "" then
    AsyncFileDelete(path)
  end
end
function ModItem:OnEditorSetProperty(prop_id, old_value, ged)
end
function ModItem:OnEditorSelect(selected, ged)
end
function ModItem:IsMounted()
  return self.mod and self.mod:IsMounted()
end
function ModItem:GetModRootPath()
  return self.mod and self.mod:GetModRootPath()
end
function ModItem:GetModContentPath()
  return self.mod and self.mod:GetModContentPath()
end
function ModItem:OnModLoad(mod)
  return ModElement.OnLoad(self, mod)
end
function ModItem:OnModUnload(mod)
  return ModElement.OnUnload(self, mod)
end
function ModItem:TestModItem(ged)
end
function ModItem:GetCodeFileName(name)
end
function ModItem:GetCodeFilePath(name)
  name = self:GetCodeFileName(name)
  if not name or name == "" then
    return ""
  end
  return self.mod.content_path .. name
end
function ModItem:FindFreeFilename(name)
  local n = 1
  local file_name = name
  while io.exists(self:GetCodeFilePath(file_name)) do
    n = n + 1
    file_name = name .. tostring(n)
  end
  return file_name
end
function ModOptionEditorContext(context, prop_meta)
  local value_fn = function()
    return context:GetProperty(prop_meta.id)
  end
  local prop_meta_subcontext = SubContext(prop_meta, {context_override = context})
  local new_context = SubContext(context, {prop_meta = prop_meta_subcontext, value = value_fn})
  if prop_meta.help and prop_meta.help ~= "" then
    new_context.RolloverTitle = Untranslated(prop_meta.name)
    new_context.RolloverText = Untranslated(prop_meta.help)
  end
  return new_context
end
DefineClass.ModOptionsObject = {
  __parents = {
    "PropertyObject"
  },
  __defaults = false,
  __mod = false
}
function ModOptionsObject:Clone(class, parent)
  class = class or self.class
  local obj = g_Classes[class]:new(parent)
  obj.__mod = self.__mod
  obj:CopyProperties(self)
  return obj
end
function ModOptionsObject:GetProperties()
  local properties = rawget(self, "properties")
  if properties then
    return properties
  end
  local properties = {}
  self.properties = properties
  self.__defaults = {}
  local option_items = self.__mod:GetOptionItems()
  for i, option in ipairs(option_items) do
    local option_prop_meta = option:GetOptionMeta()
    table.insert(properties, option_prop_meta)
    self.__defaults[option.name] = option.DefaultValue
  end
  return properties
end
function ModOptionsObject:GetProperty(id)
  self:GetProperties()
  local value = rawget(self, id)
  if value ~= nil then
    return value
  end
  return self.__defaults[id]
end
function ModOptionsObject:SetProperty(id, value)
  rawset(self, id, value)
end
DefineClass.ModItemOption = {
  __parents = {"ModItem"},
  properties = {
    {
      id = "name",
      name = "Id",
      editor = "text",
      default = "",
      translate = false,
      validate = ValidateIdentifier
    },
    {
      id = "DisplayName",
      name = "Display Name",
      editor = "text",
      default = "",
      translate = false
    },
    {
      id = "Help",
      name = "Tooltip",
      editor = "text",
      default = "",
      translate = false
    }
  },
  mod_option = false,
  ValueEditor = false,
  EditorView = Untranslated("Option <name> = <DefaultValue> <color 0 128 0><opt(u(comment),' ','')>"),
  EditorSubmenu = "Mod options"
}
function ModItemOption:OnEditorNew(mod, ged, is_paste)
  mod.has_options = true
  mod:LoadOptions()
end
function ModItemOption:OnModLoad()
  ModItem.OnModLoad(self)
  self.mod_option = self.class
end
function ModItemOption:GetOptionMeta()
  local display_name = self.DisplayName
  if not display_name or display_name == "" then
    display_name = self.name
  end
  return {
    id = self.name,
    name = T(display_name),
    editor = self.ValueEditor,
    default = self.DefaultValue,
    help = self.Help
  }
end
DefineClass.ModItemOptionToggle = {
  __parents = {
    "ModItemOption"
  },
  properties = {
    {
      id = "DefaultValue",
      name = "Default Value",
      editor = "bool",
      default = false
    }
  },
  ValueEditor = "bool",
  EditorName = "Toggle"
}
function ModItemOptionToggle:GetEditorView()
  return T({
    497158553367,
    "Option <name> = <u(v)> <color 0 128 0><opt(u(comment),' ','')>",
    v = self.DefaultValue and "On" or "Off",
    comment = self.comment
  })
end
DefineClass.ModItemOptionNumber = {
  __parents = {
    "ModItemOption"
  },
  properties = {
    {
      id = "DefaultValue",
      name = "Default Value",
      editor = "number",
      default = 0
    },
    {
      id = "MinValue",
      name = "Min",
      editor = "number",
      default = 0
    },
    {
      id = "MaxValue",
      name = "Max",
      editor = "number",
      default = 100
    },
    {
      id = "StepSize",
      name = "Step Size",
      editor = "number",
      default = 1
    }
  },
  ValueEditor = "number",
  EditorName = "Number"
}
function ModItemOptionNumber:GetOptionMeta()
  local meta = ModItemOption.GetOptionMeta(self)
  meta.min = self.MinValue
  meta.max = self.MaxValue
  meta.step = self.StepSize
  meta.slider = true
  meta.show_value_text = true
  return meta
end
DefineClass.ModItemOptionChoice = {
  __parents = {
    "ModItemOption"
  },
  properties = {
    {
      id = "DefaultValue",
      name = "Default Value",
      editor = "text",
      default = "",
      items = function(self)
        return self.ChoiceList
      end
    },
    {
      id = "ChoiceList",
      name = "Choice List",
      editor = "string_list",
      default = false
    }
  },
  ValueEditor = "choice",
  EditorName = "Choice"
}
function ModItemOptionChoice:GetOptionMeta()
  local meta = ModItemOption.GetOptionMeta(self)
  meta.items = {}
  for i, item in ipairs(self.ChoiceList or empty_table) do
    table.insert(meta.items, {
      text = T(item),
      value = item
    })
  end
  return meta
end
local GetModDependencyDescription = function(mod)
  return string.format("%s - %s - v %d.%d", mod.title, mod.id, mod.version_major, mod.version_minor)
end
function ModDependencyCombo()
  local result = {}
  for id, mod in pairs(Mods) do
    local text = GetModDependencyDescription(mod)
    local entry = {
      id = id,
      text = Untranslated(text)
    }
    table.insert(result, entry)
  end
  return result
end
DefineClass.ModDependency = {
  __parents = {
    "PropertyObject"
  },
  properties = {
    {
      id = "id",
      name = T(918258873393, "Mod"),
      editor = "combo",
      default = "",
      items = ModDependencyCombo
    },
    {
      id = "title",
      name = T(231279648013, "Title"),
      editor = "text",
      default = "",
      translate = false,
      read_only = function(dep)
        return dep.id ~= ""
      end,
      no_edit = function(dep)
        return dep.title == "" or dep.id == "" or Mods[dep.id]
      end
    },
    {
      id = "version_major",
      name = T(736930500436, "Major Version"),
      editor = "number",
      default = 0
    },
    {
      id = "version_minor",
      name = T(306168574153, "Minor Version"),
      editor = "number",
      default = 0
    },
    {
      id = "required",
      name = T(545900814494, "Required"),
      editor = "bool",
      default = true,
      help = "Untick if your mod could run without the dependency."
    }
  },
  own_mod = false
}
function ModDependency:ModFits(mod_def)
  if not mod_def then
    return false, "no mod"
  end
  if self.id ~= mod_def.id then
    return false, "different mod"
  end
  if mod_def:CompareVersion(self, "ignore_revision") < 0 then
    return false, "incompatible"
  end
  return true
end
function ModDependency:GetEditorView()
  local mod = Mods[self.id]
  if mod then
    return GetModDependencyDescription(self)
  end
  return self.class
end
function ModDependency:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "id" then
    local mod = Mods[self.id]
    if mod then
      local err, list = GetModDependenciesList(mod)
      if err == "cycle" then
        ged:ShowMessage("Warning: Cycle", "This mod dependency creates a cycle (or refers to an already existing cycle)")
      end
      self.title = mod.title
      self.version_major = mod.version_major
      self.version_minor = mod.version_minor
    else
      self.title = nil
      self.version_major = nil
      self.version_minor = nil
    end
  end
end
if FirstLoad then
  ModDependencyGraph = false
end
local function CollapseDependencyGraph(node, direction, root_id, all_nodes, visited, list, list_failed)
  list = list or {}
  list_failed = list_failed or {}
  visited = visited or {}
  if not visited[node] then
    visited[node] = true
    for i, dep in ipairs(node[direction]) do
      local dep_mod = Mods[dep.id]
      local successful = dep:ModFits(dep_mod)
      local target_list = successful and list or list_failed
      local idx
      if direction == "incoming" then
        idx = table.find(target_list, "own_mod", dep.own_mod)
      else
        idx = table.find(target_list, "id", dep.id)
      end
      if idx then
        if not target_list[idx].required then
          target_list[idx] = dep
        end
      elseif direction == "outgoing" or successful or dep.id == root_id then
        table.insert(target_list, dep)
      end
      if successful then
        local next_id = direction == "outgoing" and dep.id or dep.own_mod.id
        CollapseDependencyGraph(all_nodes[next_id], direction, root_id, all_nodes, visited, list, list_failed)
      end
    end
  end
  return list, list_failed
end
function CacheModDependencyGraph()
  local nodes = {}
  for id, mod in pairs(Mods) do
    local entry = nodes[id] or {
      incoming = {},
      outgoing = {}
    }
    nodes[id] = entry
    entry.outgoing = GetModAllDependencies(mod)
    for i, dep in ipairs(entry.outgoing) do
      dep.own_mod = mod
      local dep_entry = nodes[dep.id] or {
        incoming = {},
        outgoing = {}
      }
      nodes[dep.id] = dep_entry
      table.insert(dep_entry.incoming, dep)
    end
  end
  ModDependencyGraph = {}
  for id, mod in pairs(Mods) do
    local root_id = mod.id
    local outgoing, outgoing_failed = CollapseDependencyGraph(nodes[root_id], "outgoing", root_id, nodes)
    local incoming, incoming_failed = CollapseDependencyGraph(nodes[root_id], "incoming", root_id, nodes)
    ModDependencyGraph[id] = {
      outgoing = outgoing,
      incoming = incoming,
      outgoing_failed = outgoing_failed,
      incoming_failed = incoming_failed
    }
  end
end
function WaitWarnAboutSkippedMods()
  local all_mods = AccountStorage and AccountStorage.LoadMods
  local skipped_mods = {}
  for _, id in ipairs(all_mods or empty_table) do
    local dependency_data = ModDependencyGraph and ModDependencyGraph[id]
    if dependency_data then
      for _, dep in ipairs(dependency_data.outgoing or empty_table) do
        if dep.required and not table.find(AccountStorage.LoadMods, dep.id) then
          table.insert_unique(skipped_mods, dep.own_mod.title)
        end
      end
      for _, dep in ipairs(dependency_data.outgoing_failed or empty_table) do
        if dep.required then
          table.insert_unique(skipped_mods, dep.own_mod.title)
        end
      end
    end
  end
  if #(skipped_mods or "") > 0 then
    local skipped = table.concat(skipped_mods, "\n")
    WaitMessage(terminal.desktop, T(824112417429, "Warning"), T({
      949870544095,
      [[
The following mods will not be loaded because of missing or incompatible dependencies:

<skipped>]],
      skipped = Untranslated(skipped)
    }), T(325411474155, "OK"))
  end
end
if FirstLoad then
  ReportedMods = false
end
function ReportModLuaError(mod, err, stack)
  ReportedMods = ReportedMods or {}
  if ReportedMods[mod.id] then
    return
  end
  ReportedMods[mod.id] = true
  local v_major = mod.version_major or ModDef.version_major
  local v_minor = mod.version_minor or ModDef.version_minor
  local v = mod.version or ModDef.version
  local ver_str = string.format("%d.%02d-%03d", v_major or 0, v_minor or 0, v or 0)
  mod_print("Lua error in mod %s(id %s, version %s) from %s", mod.title, mod.id, ver_str, mod.source)
  Msg("OnModLuaError", mod, err, stack)
end
function OnMsg.ModsReloaded()
  config.SpecialLuaErrorHandling = #ModsLoaded > 0
end
function OnMsg.OnLuaError(err, stack)
  for _, mod in ipairs(ModsLoaded) do
    if mod.content_path and (string.find_lower(err, mod.content_path) or string.find_lower(stack, mod.content_path)) then
      ReportModLuaError(mod, err, stack)
    end
  end
end
if not Platform.developer and not Platform.asserts then
  function OnMsg.ChangeMap(map)
    ConsoleSetEnabled(IsModEditorMap(map))
    local dev_interface = GetDialog(GetDevUIViewport())
    if dev_interface then
      dev_interface:SetUIVisible(false)
    end
  end
end
