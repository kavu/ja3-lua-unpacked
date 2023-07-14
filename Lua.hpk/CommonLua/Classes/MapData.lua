function GetPlayBox(border)
  local pb = mapdata.PassBorder + (border or 0)
  local mw, mh = terrain.GetMapSize()
  local maxh = const.MaxTerrainHeight
  return boxdiag(pb, pb, 0, mw - pb, mh - pb, maxh)
end
function ClampToPlayArea(pt)
  return terrain.ClampPoint(pt, mapdata.PassBorder)
end
function GetTerrainCursorClamped()
  return ClampToPlayArea(GetTerrainCursor())
end
if FirstLoad then
  UpdateMapDataThread = false
end
MapTypesCombo = {"game", "system"}
function HGMembersCombo(group, extra_item)
  return function()
    local combo = extra_item and {extra_item} or {}
    for name, _ in sorted_pairs(table.get(Presets, "HGMember", group)) do
      if type(name) == "string" then
        table.insert(combo, name)
      end
    end
    return combo
  end
end
function MapOrientCombo()
  return {
    {text = "East", value = 0},
    {text = "South", value = 90},
    {text = "West", value = 180},
    {text = "North", value = 270}
  }
end
function MapNorthOrientCombo()
  return {
    {text = "East(90)", value = 90},
    {text = "South(180)", value = 180},
    {text = "West(270)", value = 270},
    {text = "North(0)", value = 0}
  }
end
local map_statuses = {
  {
    id = "Not started",
    color = "<color 205 32 32>"
  },
  {
    id = "In progress",
    color = ""
  },
  {
    id = "Awaiting feedback",
    color = "<color 180 0 180>"
  },
  {
    id = "Blocked",
    color = "<color 205 32 32>"
  },
  {
    id = "Ready",
    color = "<color 0 128 0>"
  }
}
for _, item in ipairs(map_statuses) do
  map_statuses[item.id] = item.color
end
local filter_by = {
  {
    id = "Map production status",
    color_prop = "Status",
    prop_match = function(id)
      return id == "Author" or id == "Status"
    end
  },
  {
    id = "Scripting production status",
    color_prop = "ScriptingStatus",
    prop_match = function(id)
      return id:starts_with("Scripting")
    end
  },
  {
    id = "Sounds production status",
    color_prop = "SoundsStatus",
    prop_match = function(id)
      return id:starts_with("Sounds")
    end
  }
}
DefineClass.MapDataPresetFilter = {
  __parents = {"GedFilter"},
  properties = {
    no_edit = function(self, prop_meta)
      local match_fn = table.find_value(filter_by, "id", self.FilterBy).prop_match
      return prop_meta.id ~= "FilterBy" and prop_meta.id ~= "_" and prop_meta.id ~= "Tags" and (not match_fn or not match_fn(prop_meta.id))
    end,
    {
      id = "_",
      editor = "help",
      help = "<center>Double-click above to change map.",
      default = false
    },
    {
      id = "FilterBy",
      name = "Filter/colorize by",
      editor = "choice",
      default = filter_by[1].id,
      items = filter_by
    },
    {
      id = "Author",
      name = "Map author",
      editor = "choice",
      default = "",
      items = HGMembersCombo("Level Design", "")
    },
    {
      id = "Status",
      name = "Map status",
      editor = "choice",
      default = "",
      items = table.iappend({""}, map_statuses)
    },
    {
      id = "ScriptingAuthor",
      name = "Scripting author",
      editor = "choice",
      default = "",
      items = HGMembersCombo("Design", "")
    },
    {
      id = "ScriptingStatus",
      name = "Scripting status",
      editor = "choice",
      default = "",
      items = table.iappend({""}, map_statuses)
    },
    {
      id = "SoundsStatus",
      name = "Sounds status",
      editor = "choice",
      default = "",
      items = table.iappend({""}, map_statuses)
    },
    {
      id = "Tags",
      name = "Tags",
      editor = "set",
      default = set({old = false}),
      three_state = true,
      items = {
        "old",
        "prefab",
        "random",
        "test",
        "playable"
      }
    }
  }
}
function MapDataPresetFilter:FilterObject(o)
  if not IsKindOf(o, "MapDataPreset") then
    return true
  end
  local filtered = true
  if self.Tags.old then
    filtered = filtered and IsOldMap(o.id)
  elseif self.Tags.old == false and filtered then
    filtered = not IsOldMap(o.id)
  end
  if self.Tags.prefab then
    filtered = filtered and o.IsPrefabMap
  elseif self.Tags.prefab == false and filtered then
    filtered = not o.IsPrefabMap
  end
  if self.Tags.random then
    filtered = filtered and o.IsRandomMap
  elseif self.Tags.random == false and filtered then
    filtered = not o.IsRandomMap
  end
  if self.Tags.test then
    filtered = filtered and IsTestMap(o.id)
  elseif self.Tags.test == false and filtered then
    filtered = not IsTestMap(o.id)
  end
  if self.Tags.playable then
    filtered = filtered and o.GameLogic
  elseif self.Tags.playable == false and filtered then
    filtered = not o.GameLogic
  end
  if self.FilterBy == "Map production status" then
    return filtered and (self.Author == "" or self.Author == o.Author) and (self.Status == "" or self.Status == o.Status)
  elseif self.FilterBy == "Scripting production status" then
    return filtered and (self.ScriptingAuthor == "" or self.ScriptingAuthor == o.ScriptingAuthor) and (self.ScriptingStatus == "" or self.ScriptingStatus == o.ScriptingStatus)
  elseif self.FilterBy == "Sounds production status" then
    return filtered and self.SoundsStatus == "" or self.SoundsStatus == o.SoundsStatus
  end
  return filtered
end
function MapDataPresetFilter:TryReset(ged, op, to_view)
  return false
end
DefineClass.MapDataPreset = {
  __parents = {"Preset"},
  properties = {
    {
      category = "Production",
      id = "Author",
      name = "Map author",
      editor = "choice",
      items = HGMembersCombo("Level Design"),
      default = false
    },
    {
      category = "Production",
      id = "Status",
      name = "Map status",
      editor = "choice",
      items = map_statuses,
      default = map_statuses[1].id
    },
    {
      category = "Production",
      id = "ScriptingAuthor",
      name = "Scripting author",
      editor = "choice",
      items = HGMembersCombo("Design"),
      default = false
    },
    {
      category = "Production",
      id = "ScriptingStatus",
      name = "Scripting status",
      editor = "choice",
      items = map_statuses,
      default = map_statuses[1].id
    },
    {
      category = "Production",
      id = "SoundsStatus",
      name = "Sounds status",
      editor = "choice",
      items = map_statuses,
      default = map_statuses[1].id
    },
    {
      category = "Base",
      id = "DisplayName",
      name = "Display Name",
      editor = "text",
      default = "",
      translate = true,
      help = "Translated Map name"
    },
    {
      category = "Base",
      id = "Description",
      name = "Description",
      editor = "text",
      lines = 5,
      default = "",
      translate = true,
      help = "Translated Map description"
    },
    {
      category = "Base",
      id = "MapType",
      editor = "combo",
      default = "game",
      items = function()
        return MapTypesCombo
      end,
      developer = true
    },
    {
      category = "Base",
      id = "GameLogic",
      editor = "bool",
      default = true,
      no_edit = function(self)
        return self.MapType == "system"
      end,
      developer = true
    },
    {
      category = "Base",
      id = "ArbitraryScale",
      name = "Allow arbitrary object scale",
      editor = "bool",
      default = false,
      developer = true
    },
    {
      category = "Base",
      id = "Width",
      editor = "number",
      default = 257
    },
    {
      category = "Base",
      id = "Height",
      editor = "number",
      default = 257
    },
    {
      category = "Base",
      id = "NoTerrain",
      editor = "bool",
      default = false
    },
    {
      category = "Base",
      id = "DisablePassability",
      editor = "bool",
      default = false
    },
    {
      category = "Base",
      id = "ModEditor",
      editor = "bool",
      default = false
    },
    {
      category = "Camera",
      id = "CameraUseBorderArea",
      editor = "bool",
      default = true,
      help = "Use Border marker's area for camera area."
    },
    {
      category = "Camera",
      id = "CameraArea",
      editor = "number",
      default = 100,
      min = 0,
      max = max_int,
      help = "With center of map as center, this is the length of the bounding square side in voxels."
    },
    {
      category = "Camera",
      id = "CameraFloorHeight",
      editor = "number",
      default = 5,
      min = 0,
      max = 20,
      help = "The voxel height of camera floors."
    },
    {
      category = "Camera",
      id = "CameraMaxFloor",
      editor = "number",
      default = 5,
      min = 0,
      max = 20,
      help = "The highest camera floors, counting from 0."
    },
    {
      category = "Camera",
      id = "CameraType",
      editor = "choice",
      default = "Max",
      items = GetCameraTypesItems
    },
    {
      category = "Camera",
      id = "CameraPos",
      editor = "point",
      default = false
    },
    {
      category = "Camera",
      id = "CameraLookAt",
      editor = "point",
      default = false
    },
    {
      category = "Camera",
      id = "CameraFovX",
      editor = "number",
      default = false
    },
    {
      category = "Camera",
      id = "buttons",
      editor = "buttons",
      default = "RTS",
      buttons = {
        {
          name = "View Camera",
          func = "ViewCamera"
        },
        {name = "Set Camera", func = "SetCamera"}
      }
    },
    {
      category = "Random Map",
      id = "IsPrefabMap",
      editor = "bool",
      default = false,
      read_only = true
    },
    {
      category = "Random Map",
      id = "IsRandomMap",
      editor = "bool",
      default = false
    },
    {
      category = "Visual",
      id = "Lightmodel",
      editor = "preset_id",
      default = false,
      preset_class = "LightmodelPreset",
      help = "",
      developer = true
    },
    {
      category = "Visual",
      id = "EditorLightmodel",
      editor = "preset_id",
      default = false,
      preset_class = "LightmodelPreset",
      help = "",
      developer = true
    },
    {
      category = "Visual",
      id = "AtmosphericParticles",
      editor = "combo",
      default = "",
      items = ParticlesComboItems,
      buttons = {
        {
          name = "Edit",
          func = "EditParticleAction"
        }
      },
      developer = true
    },
    {
      category = "Orientation",
      id = "MapOrientation",
      name = "North",
      editor = "choice",
      items = MapNorthOrientCombo,
      default = 0,
      buttons = {
        {name = "Look North", func = "LookNorth"}
      }
    },
    {
      category = "Terrain",
      id = "Terrain",
      editor = "bool",
      default = true,
      help = "Enable drawing of terrain",
      developer = true
    },
    {
      category = "Terrain",
      id = "BaseLayer",
      name = "Terrain base layer",
      editor = "combo",
      items = function()
        return GetTerrainNamesCombo()
      end,
      default = "",
      developer = true
    },
    {
      category = "Terrain",
      id = "ZOrder",
      editor = "choice",
      default = "z_order",
      items = {
        "z_order",
        "z_order_2nd"
      },
      help = "Indicates which Z Order property from terrains to use for sorting",
      developer = true
    },
    {
      category = "Terrain",
      id = "OrthoTop",
      editor = "number",
      default = 50 * guim,
      scale = "m",
      developer = true
    },
    {
      category = "Terrain",
      id = "OrthoBottom",
      editor = "number",
      default = 0,
      scale = "m",
      developer = true
    },
    {
      category = "Terrain",
      id = "PassBorder",
      name = "Passability Border",
      editor = "number",
      default = 0,
      scale = "m",
      developer = true,
      help = "Width of the border zone with no passability"
    },
    {
      category = "Terrain",
      id = "PassBorderTiles",
      name = "Passability Border (tiles)",
      editor = "number",
      default = 0,
      developer = true
    },
    {
      category = "Terrain",
      id = "TerrainTreeRows",
      name = "Number of terrain trees per row(NxN grid)",
      editor = "number",
      default = 4,
      developer = true
    },
    {
      category = "Terrain",
      id = "HeightMapAvg",
      name = "Height Map Avg",
      editor = "number",
      default = 0,
      scale = "m",
      read_only = true
    },
    {
      category = "Terrain",
      id = "HeightMapMin",
      name = "Height Map Min",
      editor = "number",
      default = 0,
      scale = "m",
      read_only = true
    },
    {
      category = "Terrain",
      id = "HeightMapMax",
      name = "Height Map Max",
      editor = "number",
      default = 0,
      scale = "m",
      read_only = true
    },
    {
      category = "Audio",
      id = "Playlist",
      editor = "combo",
      default = "",
      items = PlaylistComboItems,
      developer = true
    },
    {
      category = "Audio",
      id = "Blacklist",
      editor = "prop_table",
      default = false,
      no_edit = true
    },
    {
      category = "Audio",
      id = "BlacklistStr",
      name = "Blacklist",
      editor = "text",
      lines = 5,
      default = "",
      developer = true,
      buttons = {
        {
          name = "Add",
          func = "ActionAddToBlackList"
        }
      },
      dont_save = true
    },
    {
      category = "Audio",
      id = "Reverb",
      editor = "preset_id",
      default = false,
      preset_class = "ReverbDef",
      developer = true
    },
    {
      category = "Objects",
      id = "MaxObjRadius",
      editor = "number",
      default = 0,
      scale = "m",
      read_only = true,
      buttons = {
        {
          name = "Show",
          func = "ShowMapMaxRadiusObj"
        }
      }
    },
    {
      category = "Objects",
      id = "MaxSurfRadius2D",
      editor = "number",
      default = 0,
      scale = "m",
      read_only = true,
      buttons = {
        {
          name = "Show",
          func = "ShowMapMaxSurfObj"
        }
      }
    },
    {
      category = "Compatibility",
      id = "LockMarkerChanges",
      name = "Lock Markers Changes",
      editor = "bool",
      default = false,
      help = "Disable changing marker meta (e.g. prefab markers)."
    },
    {
      category = "Compatibility",
      id = "PublishRevision",
      name = "Published Revision",
      editor = "number",
      default = 0,
      help = "The first revision where the map has been officially published. Should be filled to ensure compatibility after map changes."
    },
    {
      category = "Compatibility",
      id = "CreateRevisionOld",
      name = "Compatibility Revision",
      editor = "number",
      default = 0,
      read_only = true,
      help = "Revision when the compatibility map ('old') was created. The 'AssetsRevision' of the 'old' maps is actually the revision of the original map."
    },
    {
      category = "Compatibility",
      id = "ForcePackOld",
      name = "Compatibility Pack",
      editor = "bool",
      default = false,
      help = "Force the map to be packed in builds when being a compatibility map ('old')."
    },
    {
      category = "Developer",
      id = "StartupEnable",
      name = "Use Startup",
      editor = "bool",
      default = false,
      dev_option = true
    },
    {
      category = "Developer",
      id = "StartupCam",
      name = "Startup Cam",
      editor = "prop_table",
      default = false,
      dev_option = true,
      no_edit = PropChecker("StartupEnable", false),
      buttons = {
        {
          name = "Update",
          func = "UpdateStartup"
        },
        {
          name = "Goto",
          func = "GotoStartup"
        }
      }
    },
    {
      category = "Developer",
      id = "StartupEditor",
      name = "Startup Editor",
      editor = "bool",
      default = false,
      dev_option = true,
      no_edit = PropChecker("StartupEnable", false)
    },
    {
      category = "Developer",
      id = "LuaRevision",
      editor = "number",
      default = 0,
      read_only = true
    },
    {
      category = "Developer",
      id = "OrgLuaRevision",
      editor = "number",
      default = 0,
      read_only = true
    },
    {
      category = "Developer",
      id = "AssetsRevision",
      editor = "number",
      default = 0,
      read_only = true
    },
    {
      category = "Developer",
      id = "NetHash",
      name = "NetHash",
      editor = "number",
      default = 0,
      read_only = true
    },
    {
      category = "Developer",
      id = "ObjectsHash",
      name = "ObjectsHash",
      editor = "number",
      default = 0,
      read_only = true
    },
    {
      category = "Developer",
      id = "TerrainHash",
      name = "TerrainHash",
      editor = "number",
      default = 0,
      read_only = true
    },
    {
      category = "Developer",
      id = "SaveEntityList",
      name = "SaveEntityList",
      editor = "bool",
      default = false,
      help = "Saves all entities used on that map, e.g. Objects, Markers, Auto Attaches..."
    }
  },
  Zoom = false,
  SingleFile = false,
  GlobalMap = "MapData",
  GedEditor = "GedMapDataEditor",
  EditorMenubarName = false,
  EditorViewPresetPostfix = Untranslated("<color 128 128 128><opt(u(Author),' [',']')></color>"),
  FilterClass = "MapDataPresetFilter"
}
function EditParticleAction(root, obj, prop_id, ged)
  local parsysid = obj[prop_id]
  if parsysid and parsysid ~= "" then
    EditParticleSystem(parsysid)
  end
end
function LookNorth(root, obj, prop_id, ged)
  local pos, lookat, camtype = GetCamera()
  local cam_orient = CalcOrientation(pos, lookat)
  local map_orient = (obj.MapOrientation - 90) * 60
  local cam_vector = RotateAxis(lookat - pos, point(0, 0, 4096), map_orient - cam_orient)
  if camtype == "Max" then
    InterpolateCameraMaxWakeup({pos = pos, lookat = lookat}, {
      pos = pos - cam_vector,
      lookat = pos
    }, 650, nil, "polar", "deccelerated")
  else
    SetCamera(pos - cam_vector, pos, camtype)
  end
end
function GedMapDataOpenMap(ged)
  local preset = ged:ResolveObj("SelectedPreset")
  CreateRealTimeThread(ChangeMap, preset.id)
end
function MapDataPreset:GetEditorViewPresetPrefix()
  local ged = FindGedApp(MapDataPreset.GedEditor)
  local filter = ged and ged:FindFilter("root")
  local color_prop = filter and table.find_value(filter_by, "id", filter.FilterBy).color_prop or "Status"
  return map_statuses[self[color_prop]] or ""
end
function MapDataPreset:GetMapName()
  return self.id
end
function MapDataPreset:SetPassBorderTiles(tiles)
  self.PassBorder = tiles * const.HeightTileSize
  ObjModified(self)
end
function MapDataPreset:GetPassBorderTiles()
  return self.PassBorder / const.HeightTileSize
end
function MapDataPreset:ActionAddToBlackList(preset, prop_id, ged)
  local track, err = ged:WaitUserInput("", "Select track", PlaylistTracksCombo())
  if not track or track == "" then
    return
  end
  local blacklist = self.Blacklist or {}
  table.insert_unique(blacklist, track)
  preset.Blacklist = 0 < #blacklist and blacklist or nil
  ObjModified(self)
end
function MapDataPreset:SetBlacklistStr(str)
  local blacklist = string.tokenize(str, ",", nil, true)
  self.Blacklist = 0 < #blacklist and blacklist or nil
  ObjModified(self)
end
function MapDataPreset:SetTerrainTreeSize(value)
  hr.TR_TerrainTreeRows = value
  ObjModified(self)
end
function MapDataPreset:GetBlacklistStr()
  return self.Blacklist and table.concat(self.Blacklist, ",\n") or ""
end
function MapDataPreset:SetSaveIn(save_in)
  if self.save_in == save_in then
    return
  end
  if save_in ~= "" and Playlists[save_in] then
    if self.Playlist == self:GetDefaultPropertyValue("Playlist") or self.save_in ~= "" and self.Playlist == self.save_in then
      self.Playlist = save_in
    end
  elseif self.save_in ~= "" and Playlists[self.save_in] and self.Playlist == self.save_in then
    self.Playlist = self:GetDefaultPropertyValue("Playlist")
  end
  Preset.SetSaveIn(self, save_in)
  ObjModified(self)
end
function MapDataPreset:OnEditorSetProperty(prop_id, old_value, ged)
  if prop_id == "MapType" then
    if self.MapType == "system" then
      self.GameLogic = false
    end
    ObjModified(self)
  elseif prop_id == "PassBorder" then
    if self.PassBorder == old_value or GetMapName() ~= self:GetMapName() then
      return
    end
    CreateRealTimeThread(function()
      SaveMap("no backup")
      ChangeMap(GetMapName())
    end)
  elseif prop_id == "Group" then
    XEditorUpdateMapName()
  elseif prop_id == "EditorLightmodel" and GetMapName() == self.id then
    self:ApplyLightmodel()
  end
  if CurrentMap ~= "" then
    DeleteThread(UpdateMapDataThread)
    UpdateMapDataThread = CreateMapRealTimeThread(function()
      Sleep(100)
      self:ApplyMapData()
      AtmosphericParticlesUpdate()
    end)
  end
end
function MapDataPreset:GetSaveFolder(save_in)
  return string.format("Maps/%s/", self.id)
end
function MapDataPreset:GetSavePath(save_in, group)
  return self:GetSaveFolder(save_in) .. "mapdata.lua"
end
function MapDataPreset:GenerateCode(code)
  local sizex, sizey = terrain.GetMapSize()
  self.Width = self.Width or sizex and sizex / guim + 1
  self.Height = self.Height or sizey and sizey / guim + 1
  code:append("DefineMapData")
  code:appendt(self)
end
function MapDataPreset:GetSaveData(file_path, presets, ...)
  return Preset.GetSaveData(self, file_path, presets, ...)
end
function MapDataPreset:HandleRenameDuringSave(save_path, path_to_preset_list)
  local presets = path_to_preset_list[save_path]
  if #presets ~= 1 then
    return
  end
  local last_save_path = g_PresetLastSavePaths[presets[1]]
  if last_save_path and last_save_path ~= save_path then
    local old_dir = SplitPath(last_save_path)
    local new_dir = SplitPath(save_path)
    SVNMoveFile(old_dir, new_dir)
  end
end
function MapDataPreset:ChooseLightmodel()
  return self.Lightmodel
end
function MapDataPreset:ApplyLightmodel()
  if IsEditorActive() then
    SetLightmodel(1, self.EditorLightmodel, 0)
  else
    SetLightmodel(1, LightmodelOverride and LightmodelOverride.id or self:ChooseLightmodel(), 0)
  end
end
local ToggleEditor = function()
  if mapdata.EditorLightmodel then
    mapdata:ApplyLightmodel()
  end
end
OnMsg.GameEnterEditor = ToggleEditor
OnMsg.GameExitEditor = ToggleEditor
function MapDataPreset:ApplyMapData(setCamera)
  self:ApplyLightmodel()
  AtmosphericParticlesApply()
  if config.UseReverb and self.Reverb then
    local reverb = ReverbDefs[self.Reverb]
    if not reverb then
      self.Reverb = false
    else
      reverb:Apply()
    end
  end
  if setCamera and self.CameraPos and self.CameraPos ~= InvalidPos() and self.CameraLookAt and self.CameraLookAt ~= InvalidPos() then
    SetCamera(self.CameraPos, self.CameraLookAt, self.CameraType, self.Zoom, nil, self.CameraFovX)
  end
  hr.TR_TerrainTreeRows = self.TerrainTreeRows
  SetMusicBlacklist(self.Blacklist)
  if self.Playlist ~= "" then
    SetMusicPlaylist(self.Playlist)
  end
end
function MapDataPreset:GetPlayableSize()
  local sizex, sizey = terrain.GetMapSize()
  return sizex - 2 * mapdata.PassBorder, sizey - 2 * mapdata.PassBorder
end
function MapDataPreset:SetCamera()
  local zoom, props
  self.CameraPos, self.CameraLookAt, self.CameraType, zoom, props, self.CameraFovX = GetCamera()
  GedObjectModified(self)
end
function MapDataPreset:ViewCamera()
  if self.CameraPos and self.CameraLookAt and self.CameraPos ~= InvalidPos() and self.CameraLookAt ~= InvalidPos() then
    SetCamera(self.CameraPos, self.CameraLookAt, self.CameraType, nil, nil, self.CameraFovX)
  end
end
function OnMsg.NewMap()
  if mapdata.MapType == "system" then
    mapdata.GameLogic = false
  end
  if IsKindOf(mapdata, "MapDataPreset") then
    mapdata:ApplyMapData("set camera")
  end
end
function LoadAllMapData()
  MapData = {}
  local map
  local fenv = LuaValueEnv({
    DefineMapData = function(data)
      local preset = MapDataPreset:new(data)
      preset:SetGroup(preset:GetGroup())
      preset:SetId(map)
      preset:PostLoad()
      g_PresetLastSavePaths[preset] = preset:GetSavePath()
      MapData[map] = preset
    end
  })
  if IsFSUnpacked() then
    local err, folders = AsyncListFiles("Maps", "*", "relative folders")
    if err then
      return
    end
    for i = 1, #folders do
      map = folders[i]
      local ok, err = pdofile(string.format("Maps/%s/mapdata.lua", map), fenv)
    end
  else
    local LoadMapDataFolder = function(folder)
      local err, files = AsyncListFiles(folder, "*.lua")
      if err then
        return
      end
      for i = 1, #files do
        local dir, file, ext = SplitPath(files[i])
        if file ~= "__load" then
          map = file
          dofile(files[i], fenv)
        end
      end
    end
    LoadMapDataFolder("Data/MapData")
    for i = 1, #(DlcFolders or "") do
      LoadMapDataFolder(string.format("%s/Data/MapData", DlcFolders[i]))
    end
  end
  Msg("MapDataLoaded")
end
function OnMsg.PersistSave(data)
  if IsKindOf(mapdata, "MapDataPreset") then
    data.mapdata = {}
    local props = mapdata:GetProperties()
    for _, meta in ipairs(props) do
      local id = meta.id
      data.mapdata[id] = mapdata:GetProperty(id)
    end
  end
end
function OnMsg.PersistLoad(data)
  if data.mapdata then
    mapdata = MapDataPreset:new(data.mapdata)
  end
end
function MapDataPreset:UpdateStartup()
  if GetMap() == "" then
    return
  end
  self:SetStartupCam({
    GetCamera()
  })
  self:SetStartupEditor(IsEditorActive())
  ObjModified(self)
end
function MapDataPreset:GotoStartup()
  if GetMap() == "" then
    return
  end
  local in_editor = self:GetStartupEditor()
  if in_editor then
    EditorActivate()
  end
  local startup_cam = self:GetStartupCam()
  if startup_cam then
    SetCamera(table.unpack(startup_cam))
  end
end
for _, prop in ipairs(MapDataPreset.properties) do
  if prop.dev_option then
    prop.developer = true
    prop.dont_save = true
    MapDataPreset["Get" .. prop.id] = function(self)
      return GetDeveloperOption(prop.id, "MapStartup", self.id, false)
    end
    MapDataPreset["Set" .. prop.id] = function(self, value)
      SetDeveloperOption(prop.id, value, "MapStartup", self.id)
    end
  end
end
local MapStartup = function()
  if MapReloadInProgress or GetMap() == "" or not mapdata:GetStartupEnable() then
    return
  end
  mapdata:GotoStartup()
end
local MapStartupDelayed = function()
  DelayedCall(0, MapStartup)
end
OnMsg.EngineStarted = MapStartupDelayed
OnMsg.ChangeMapDone = MapStartupDelayed
