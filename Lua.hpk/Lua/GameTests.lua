GameTests.BuildingButtons = nil
config.EditorsToTest = false and {
  "AutoAttachPreset",
  "TextStyle",
  "XTemplate",
  "ClassDef",
  "ParticleSystemPreset",
  "MapDataPreset",
  "Achievement",
  "FXPreset",
  "SoundPreset",
  "LootDef",
  "ConstDef",
  "Camera",
  "BanterDef",
  "CampaignPreset",
  "Conversation",
  "EnemySquads",
  "PopupNotification",
  "QuestsDef",
  "ConflictDescription",
  "SectorOperation",
  "SetpiecePrg",
  "AppearancePreset",
  "InventoryItemCompositeDef",
  "UnitDataCompositeDef",
  "AIArchetype",
  "ActionCameraDef",
  "ChanceToHitModifier",
  "CharacterEffectCompositeDef"
}
function g_UIGetBuildingsList()
  return {}
end
GameTestsNightly.NonInferedShaders = nil
GameTestsNightly.ReferenceImages = nil
GameTestsNightly.RenderingBenchmark = nil
function GameTests_LoadTestSaves()
  local err, savegames = AsyncListFiles("svnAssets/Source/TestSaves/", "*.savegame.sav")
  if err then
    GameTestsPrint("Error while getting test savegames: %s", err)
  end
  table.sort(savegames)
  local test_time = 1500
  local max_time = 0
  for _, savegame in ipairs(savegames) do
    local _, file, ext = SplitPath(savegame)
    if not string.match(file, "^%[TS 4%]") then
      GameTestsPrintf("Loading savegame: %s", savegame)
      local start_time = GetPreciseTicks()
      local err = LoadGame(file .. ext)
      if not err then
        GameTestsPrintf("Testing savegame '%s' for %.1fs", savegame, test_time * 0.001)
        WaitLoadingScreenClose()
        local end_time = GetPreciseTicks() + test_time
        while end_time >= GetPreciseTicks() do
          Sleep(1)
        end
        local time = GetPreciseTicks() - start_time
        if max_time <= time then
          max_time = time or max_time
        end
      else
        GameTestsErrorf("Error loading savegame: '%s'", savegame)
      end
    end
  end
  GameTestsPrintf("Longest load save took: %.1fs", max_time * 0.001)
end
function GetMapRevision(map_id)
  local err, list = AsyncListFiles("Maps/" .. map_id)
  if err then
    return 0
  end
  local last_rev = 0
  for _, file in ipairs(list) do
    local rev = GetAssetFileRevision(file)
    if last_rev < rev and rev ~= 999999999 then
      last_rev = rev
    end
  end
  return last_rev
end
ChangeGameplayMaps_LastChangedToTest = 6
function ViewRandomMapPositions(duration)
  local bam = MapGetMarkers("BorderArea")[1]
  if bam then
    local end_time = GetPreciseTicks() + (duration or 1500)
    for _, pos in random_ipairs(bam:GetAreaPositions(), 0) do
      ViewPos(point(point_unpack(pos)))
      WaitNextFrame()
      if end_time < GetPreciseTicks() then
        break
      end
    end
  end
end
ChangeVideoSettings_ViewPositions = ViewRandomMapPositions
function GetMapsToTest(game_tests_name)
  local campaign_maps = {}
  for _, map in pairs(MapData) do
    if map.Status ~= "Not started" then
      campaign_maps[#campaign_maps + 1] = {
        map.id,
        GetMapRevision(map.id)
      }
    end
  end
  table.sortby_field_descending(campaign_maps, 2)
  local maps_to_test = game_tests_name == "GameTestsNightly" and #campaign_maps or ChangeGameplayMaps_LastChangedToTest
  while maps_to_test < #campaign_maps and campaign_maps[#campaign_maps][2] ~= campaign_maps[1][2] do
    table.remove(campaign_maps)
  end
  return campaign_maps
end
function GameTests.ChangeGameplayMaps(_, game_tests_name)
  GameTestMapLoadRandom = xxhash("GameTestMapLoadRandomSeed")
  MapLoadRandom = InitMapLoadRandom()
  ResetInteractionRand(0)
  local maps_to_test = GetMapsToTest(game_tests_name)
  for _, map_descr in ipairs(maps_to_test) do
    local map = MapData[map_descr[1]]
    ClearErrorSource()
    GameTestsPrint(map.id)
    local time = GetPreciseTicks()
    ChangeMap(map.id)
    GameTestsPrint("... changing map took " .. GetPreciseTicks() - time .. " ms")
    ValidateMapObjects({validate_properties = true})
    WaitLoadingScreenClose()
    GameTestsPrint("... changing map and validation took " .. GetPreciseTicks() - time .. " ms")
    ViewRandomMapPositions()
    GameTestsFlushErrors()
  end
end
GameTestsNightly.ChangeGameplayMaps = GameTests.ChangeGameplayMaps
GameTestsNightly.TestMapEntranceMarkersAL = GameTests.TestMapEntranceMarkersAL
function GameTests.Ladders()
  ChangeMap("__CombatTest")
  if not HasGameSession() then
    NewGameSession()
  end
  local tf = GetTimeFactor()
  SetTimeFactor(10000)
  InitTestCombat(false, {
    TestTeamDef:new({
      mercs = {"Barry"},
      team_color = RGB(0, 0, 200),
      spawn_marker_group = "TestTeamA",
      side = "player1"
    }),
    TestTeamDef:new({
      mercs = {"Grizzly"},
      team_color = RGB(200, 0, 0),
      spawn_marker_group = "TestTeamB",
      side = "enemy1"
    })
  })
  g_Combat:Start()
  while GameTime() == 0 do
    Sleep(10)
  end
  local exec_action = function(action_id, unit, ...)
    if g_Combat then
      CombatActions[action_id]:Execute({unit}, ...)
      Sleep(100)
      while IsValidTarget(unit) and not unit:IsIdleCommand() do
        WaitMsg("Idle", 200)
      end
    end
  end
  local ladder = MapGetFirst(true, "Ladder", function(ladder)
    return ladder.LadderParts > 0
  end)
  if not ladder then
    GameTestsErrorf("Ladders not present on '%s' map", GetMapName())
    return
  end
  local pos1, pos2 = ladder:GetTunnelPositions()
  local Barry = g_Units.Barry
  local Grizzly = g_Units.Grizzly
  while not Barry:CanBeControlled() do
    Sleep(10)
  end
  Barry:ForEachItemInSlot("Handheld A", false, function(item)
    Barry:RemoveItem("Handheld A", item)
  end)
  local maxPoints = Barry:GetMaxActionPoints()
  function Barry.GetMaxActionPoints()
    return maxPoints * 3
  end
  Barry.ActionPoints = Barry:GetMaxActionPoints()
  Barry:SetPos(pos1)
  SnapCameraToObj(Barry)
  Grizzly:SetPos(pos1 + point(const.SlabSizeX, const.SlabSizeY))
  exec_action("Move", Barry, {goto_pos = pos2})
  if pos2:Dist(Barry:GetPos()) > 2 * guim / 10 then
    GameTestsErrorf("Climbing ladder up error")
  end
  exec_action("Move", Barry, {goto_pos = pos1})
  if pos1:Dist(Barry:GetPos()) > 2 * guim / 10 then
    GameTestsErrorf("Climbing ladder down error")
  end
  SetTimeFactor(tf)
end
local mat_props_names = {
  "Body",
  "Head",
  "Hat",
  "Pants",
  "Shirt"
}
function TestEntityMaterialsUnitLighting()
  for _, group in ipairs(Presets.AppearancePreset) do
    for _, appearance in ipairs(group) do
      for _, mat_name in ipairs(mat_props_names) do
        local mat_name_value = appearance[mat_name]
        if mat_name_value and mat_name_value ~= "" then
          local filename = string.format("%s_mesh.mtl", mat_name_value)
          if io.exists("Materials/" .. filename) then
            local mat_props = GetMaterialProperties(filename)
            if mat_props.UnitLighting == 0 then
              local err_text = string.format("Unit Appearance material '%s' should have UnitLighting flag", filename)
              GameTestsErrorf(err_text)
              print(err_text)
            end
          end
        end
      end
    end
  end
  for _, group in ipairs(Presets.WeaponComponent) do
    for _, weapon_component in ipairs(group) do
      for _, visual in ipairs(weapon_component.Visuals) do
        local filename = string.format("%s_mesh.mtl", visual.Entity)
        if io.exists("Materials/" .. filename) then
          local mat_props = GetMaterialProperties(filename)
          if mat_props.UnitLighting == 0 then
            local err_text = string.format("Weapon material '%s' should have UnitLighting flag", filename)
            GameTestsErrorf(err_text)
            print(err_text)
          end
        end
      end
    end
  end
end
function GameTests.EntityMaterials()
  GameTests_LoadAnyMap()
  local all_entities = GetAllEntities()
  local materials = Presets.ObjMaterial.Default
  for entity_name in pairs(all_entities) do
    local entity_data = EntityData[entity_name]
    if entity_data and entity_data.entity then
      local material_type = entity_data.entity.material_type
      local material_preset = materials[material_type]
      if material_preset and entity_data.editor_category ~= "Decal" and material_preset.impenetrable and HasAnySurfaces(entity_name, -1) then
        local has_collision = HasCollisions(entity_name)
        local has_obstruction = HasMeshWithCollisionMask(entity_name, const.cmObstruction)
        if not has_collision and not has_obstruction then
          local err_text = string.format("Entity '%s' has impenetrable material '%s' without S collision mask/surfaces", entity_name, material_type)
          GameTestsErrorf(err_text)
        end
      end
    end
  end
  TestEntityMaterialsUnitLighting()
end
function GameTests.EntityMissingFiles()
  GameTests_LoadAnyMap()
  local all_entities = GetAllEntities()
  for entity in sorted_pairs(all_entities) do
    local existing, non_existing = EntitySpec.GetEntityFiles(nil, entity)
    for _, ne in ipairs(non_existing) do
      if not string.match(ne, ".json$") then
        GameTestsErrorf("%s: missing %s", entity, ne)
      end
    end
  end
end
function GameTests.Interactables()
  print("Entering interaction test...")
  NewGameSession()
  local interactionTest = Presets.TestCombat.GameTest.InteractionTest
  TestCombatEnterSector(interactionTest, interactionTest.map)
  WaitLoadingScreenClose()
  wait_interface_mode("IModeExploration")
  local unitsToDeploy = GetAllPlayerUnitsOnMap()
  local unit = unitsToDeploy[1]
  local lGetNearbyInteractable = function(obj)
    return MapGetFirst(obj:GetPos(), guim * 5, "Interactable")
  end
  local impassable = MapGetMarkers("Position", "InteractableOnImpassable")[1]
  local interactable = lGetNearbyInteractable(impassable)
  unit:SetPos(impassable:GetPos())
  UIInteractWith(unit, interactable)
  Sleep(500)
  CloseDialog("FullscreenGameDialogs")
  if not interactable.interaction_log or interactable.interaction_log == 0 then
    GameTestsError("Cant interact with interactable on impassable.")
  end
  local behindWall = MapGetMarkers("Position", "InteractableBehindWall")[1]
  interactable = lGetNearbyInteractable(behindWall)
  unit:SetPos(behindWall:GetPos())
  UIInteractWith(unit, interactable)
  Sleep(500)
  while unit.goto_target do
    Sleep(100)
  end
  Sleep(1000)
  CloseDialog("FullscreenGameDialogs")
  if not interactable.interaction_log or interactable.interaction_log == 0 then
    GameTestsError("Cant interact with interactable behind wall.")
  end
  if unit:GetPos() == behindWall:GetPos() then
    GameTestsError("Interacted through a wall.")
  end
end
function GameTests.TestSaveLoadSystem()
  do return end
  GameTests_LoadAnyMap()
  print("Starting new game...")
  CreateRealTimeThread(QuickStartCampaign)
  WaitMsg("EnterSector", 5000)
  WaitLoadingScreenClose()
  local oldOpenPopup = OpenPopupNotification
  OpenPopupNotification = empty_func
  local intro = GetDialog("Intro")
  if intro then
    intro:Close()
    WaitMsg("Resume", 2000)
  end
  while IsSetpiecePlaying() do
    print("Waiting for setpiece...")
    WaitMsg("SetpieceEnded", 100)
  end
  Sleep(500)
  Pause("g_TestingSaveLoadSystem")
  g_TestingSaveLoadSystem = true
  local finally = function(err)
    if err then
      GameTestsErrorf(err)
    end
    if OpenPopupNotification == empty_func then
      OpenPopupNotification = oldOpenPopup
    end
    g_TestingSaveLoadSystem = false
    table.restore(hr, "g_TestingSaveLoadSystem", "ignore_error")
    ResumeGame()
    Resume("g_TestingSaveLoadSystem")
    print("Done!")
  end
  print("Grabbing unit info...")
  local units = GetAllPlayerUnitsOnMap()
  local propertiesPreSave = {}
  local unitPropertiesProperties = UnitProperties:GetProperties()
  for i, u in ipairs(units) do
    local unitTable = {}
    for i = 1, #unitPropertiesProperties do
      local prop_meta = unitPropertiesProperties[i]
      if not prop_meta.dont_save then
        local prop_id = prop_meta.id
        local value = u:GetProperty(prop_id)
        local default = u:GetDefaultPropertyValue(prop_id, prop_meta)
        local is_default = true
        if type(value) == "table" and type(default) == "table" then
          is_default = value == default or table.hash(value) == table.hash(default)
        else
          is_default = value == nil or value == default
        end
        if is_default then
          unitTable[prop_id] = "~~default~~"
        elseif type(value) == "table" then
          unitTable[prop_id] = ValueToLuaCode(value)
        else
          unitTable[prop_id] = value
        end
      end
    end
    propertiesPreSave[u.session_id] = unitTable
  end
  local lComparePropertiesWithPreSave = function()
    local units = GetAllPlayerUnitsOnMap()
    for i, u in ipairs(units) do
      local unitTable = propertiesPreSave[u.session_id]
      if unitTable then
        for i = 1, #unitPropertiesProperties do
          local prop_meta = unitPropertiesProperties[i]
          if not prop_meta.dont_save then
            local prop_id = prop_meta.id
            local value = u:GetProperty(prop_id)
            local default = u:GetDefaultPropertyValue(prop_id, prop_meta)
            local is_default = true
            if type(value) == "table" and type(default) == "table" then
              is_default = value == default or table.hash(value) == table.hash(default)
            else
              is_default = value == nil or value == default
            end
            if is_default then
              value = "~~default~~"
            elseif type(value) == "table" then
              value = ValueToLuaCode(value)
            end
            local preSaveVal = unitTable[prop_id]
            if preSaveVal ~= nil and preSaveVal ~= value then
              GameTestsErrorf("Property %s of unit %s changed its value from %s to %s", prop_id, u.session_id, preSaveVal, value)
            end
          end
        end
      end
    end
  end
  local lReallyWaitForLSToClose = function()
    local timeout = 5000
    local ts = GetPreciseTicks()
    while GetLoadingScreenDialog() and not (timeout < GetPreciseTicks() - ts) do
      print("waiting for ls to close...")
      Sleep(100)
    end
  end
  print("Opening satellite view...")
  if SatelliteToggleActionState() ~= "enabled" then
    finally("Satellite view is disabled!")
    return
  end
  lReallyWaitForLSToClose()
  local err = SatelliteToggleActionRun()
  if not err then
    WaitMsg("OpenSatelliteView", 10000)
  end
  if not gv_SatelliteView then
    finally("Couldn't open satellite view, " .. (err or ""))
    return
  end
  print("Closing satellite view...")
  lReallyWaitForLSToClose()
  err = SatelliteToggleActionRun()
  if not err then
    WaitMsg("CloseSatelliteView", 10000)
  end
  if gv_SatelliteView then
    finally("Couldn't close satellite view, " .. (err or ""))
    return
  end
  print("Checking if satellite sync changed unit properties...")
  lComparePropertiesWithPreSave()
  OpenPopupNotification = oldOpenPopup
  local lResetVariablesExpectedToChange = function()
    InteractionSeed = 0
    InteractionSeeds = {}
    MapLoadRandom = 0
    Game.loaded_from_id = false
  end
  PauseGame()
  table.change(hr, "g_TestingSaveLoadSystem", {CameraTacMouseEdgeScrolling = false, CameraTacClampToTerrain = false})
  print("Saving game and loading it...")
  lResetVariablesExpectedToChange()
  local saveOne = GatherSessionData():str()
  LoadGameSessionData(saveOne)
  local filePath = "AppData/TestSave.lua"
  local err = AsyncStringToFile(filePath, saveOne)
  if err then
    printf("Failed to save to file %s: %s", filePath, err)
  end
  print("Checking if loading the save changed unit properties...")
  lComparePropertiesWithPreSave()
  print("Saving game again, and checking difff...")
  local filePathTwo = "AppData/TestSaveTwo.lua"
  lResetVariablesExpectedToChange()
  local saveTwo = GatherSessionData():str()
  err = AsyncStringToFile(filePathTwo, saveTwo)
  if err then
    printf("Failed to save to file %s: %s", filePathTwo, err)
  end
  local _, str = SVNDiffTwoUnrelatedFiles(filePath, filePathTwo)
  local diff = {}
  for s in str:gmatch("[^\r\n]+") do
    diff[#diff + 1] = s
    if #diff == 20 then
      break
    end
  end
  if 0 < #diff then
    GameTestsError("Second save is different from the first?!")
    GameTestsPrint(table.concat(diff, "\n"))
  end
  finally()
  print("Success!")
end
function GameTests_LandmineLOF()
  NewGameSession()
  local retreatTest = Presets.TestCombat.GameTest.RetreatTest
  TestCombatEnterSector(retreatTest, retreatTest.map)
  WaitLoadingScreenClose()
  wait_interface_mode("IModeDeployment")
  local dlg = GetInGameInterfaceModeDlg()
  dlg:StartExploration()
  WaitMsg("ExplorationTick", 10000)
  local landmine = PlaceObject("Landmine")
  landmine:SetPos(point(198499, 117922, 6950))
  landmine.discovered_by.player1 = true
  local kalyna = g_Units.Kalyna
  local defaultAction = kalyna:GetDefaultAttackAction("ranged")
  local results = defaultAction:GetActionResults(kalyna, {target = landmine})
  if not results.target_hit then
    GameTestsErrorf("LOF didn't hit landmine!")
  end
end
function GameTests.DeploymentLogic()
  print("Entering deployment combat test...")
  NewGameSession()
  local deploymentTest = Presets.TestCombat.GameTest.DeploymentTest
  TestCombatEnterSector(deploymentTest, deploymentTest.map)
  WaitLoadingScreenClose()
  wait_interface_mode("IModeDeployment")
  if not gv_Deployment then
    GameTestsErrorf("Deployment didn't start!")
    return
  end
  local allTheMarkers = MapGetMarkers()
  local cliff = table.find_value(allTheMarkers, "ID", "Cliff")
  local raised = table.find_value(allTheMarkers, "ID", "Raised")
  local flat = table.find_value(allTheMarkers, "ID", "Flat")
  local house = table.find_value(allTheMarkers, "ID", "House")
  local beach = table.find_value(allTheMarkers, "ID", "Beach")
  local raisedTerrain = table.find_value(allTheMarkers, "ID", "RaisedTerrain")
  local markerInHouse = table.find_value(allTheMarkers, "ID", "InBuilding")
  local unitsToDeploy = GetCurrentDeploymentSquadUnits()
  ResetInteractionRand(0)
  local CheckDeploymentAllCool = function()
    local highestZ = -9999999999
    local lowestZ = 9999999999
    for i, u in ipairs(unitsToDeploy) do
      local _, _, vZ = WorldToVoxel(u)
      highestZ = Max(highestZ, vZ)
      lowestZ = Min(lowestZ, vZ)
    end
    if abs(highestZ - lowestZ) > 1 then
      GameTestsErrorf("Units were deployed very far apart on the z axis, possibly to an invalid pos.")
      return false
    end
    return true
  end
  SnapCameraToObj(cliff, true)
  Sleep(300)
  local pointOnTerrainPart = point(172200, 132600)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, cliff, "show", pointOnTerrainPart)
    if not CheckDeploymentAllCool() then
      return
    end
  end
  local pointOnObjectPart = point(168600, 131400, 15400)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, cliff, "show", pointOnObjectPart)
    if not CheckDeploymentAllCool() then
      return
    end
  end
  SnapCameraToObj(raised, true)
  Sleep(300)
  local OnArea = point(126600, 136200, 13300)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, raised, "show", OnArea)
    if not CheckDeploymentAllCool() then
      return
    end
  end
  local downTheStairs = point(126600, 131400, 12600)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, raised, "show", downTheStairs)
    if not CheckDeploymentAllCool() then
      return
    end
  end
  local inTheVoid = point(124200, 137400)
  if raised:IsInsideArea(inTheVoid) then
    GameTestsErrorf("The point below the marker shouldn't be considered inside it.")
    return
  end
  SnapCameraToObj(flat, true)
  Sleep(300)
  local partOne = point(127800, 177000)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, flat, "show", partOne)
    if not CheckDeploymentAllCool() then
      return
    end
  end
  local partTwo = point(124200, 163800)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, flat, "show", partTwo)
    if not CheckDeploymentAllCool() then
      return
    end
  end
  SnapCameraToObj(house, true)
  Sleep(300)
  local insideHouse = point(166200, 177000, 7000)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, house, "show", insideHouse)
    if not CheckDeploymentAllCool() then
      return
    end
    for i, u in ipairs(unitsToDeploy) do
      local unitPos = u:GetPos()
    end
  end
  local outsideHouse = point(175800, 178200)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, house, "show", outsideHouse)
    if not CheckDeploymentAllCool() then
      return
    end
  end
  beach.Reachable = true
  SnapCameraToObj(beach, true)
  Sleep(300)
  local onTheBeach = point(178200, 157800)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, beach, "show", onTheBeach)
    if not CheckDeploymentAllCool() then
      return
    end
  end
  SnapCameraToObj(raisedTerrain, true)
  local lowArea = point(185400, 108600)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, raisedTerrain, "show", lowArea)
    if not CheckDeploymentAllCool() then
      return
    end
  end
  local highArea = point(174600, 108600)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, raisedTerrain, "show", highArea)
    if not CheckDeploymentAllCool() then
      return
    end
  end
  SnapCameraToObj(markerInHouse, true)
  local outsideArea = point(102600, 162600)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, markerInHouse, "show", outsideArea)
    if not CheckDeploymentAllCool() then
      return
    end
  end
  local insideArea = point(103800, 155400, 7700)
  for i = 1, 5 do
    LocalDeployUnitsOnMarker(unitsToDeploy, markerInHouse, "show", insideArea)
    if not CheckDeploymentAllCool() then
      return
    end
  end
  print("Entering retreat test...")
  local retreatTest = Presets.TestCombat.GameTest.RetreatTest
  TestCombatEnterSector(retreatTest, retreatTest.map)
  WaitLoadingScreenClose()
  wait_interface_mode("IModeDeployment")
  local dlg = GetInGameInterfaceModeDlg()
  dlg:StartExploration()
  WaitMsg("ExplorationStart", 5000)
  Sleep(100)
  gv_Sectors.I1.Side = "player1"
  AllowRevealSectors({
    "H2",
    "H3",
    "H4",
    "I1",
    "I2",
    "I3"
  })
  unitsToDeploy = GetCurrentDeploymentSquadUnits()
  local marker = MapGetMarkers("ExitZoneInteractable", "East")
  marker[1]:UnitLeaveSector(unitsToDeploy[1])
  WaitMsg("ZuluMessagePopup", 1000)
  local popup = g_ZuluMessagePopup[1]
  popup:Close(1)
  WaitMsg("InitSatelliteView", 3000)
end
function WriteAnimSetsCSV()
  local anims, csv, columns = {}, {}, {"name"}
  for _, model in ipairs({"Male", "Female"}) do
    for _, prefix in ipairs({
      "ar_",
      "civ_",
      "dw_",
      "gr_",
      "hg_",
      "hmg_",
      "hw_",
      "mk_",
      "nw_",
      "sg_",
      "inf_"
    }) do
      local column = string.sub(model .. "_" .. prefix, 1, -2)
      columns[#columns + 1] = column
      for _, anim in ipairs(table.map(EnumValidStates(model), GetStateName)) do
        if anim:starts_with(prefix) then
          local anim_name = anim:sub(#prefix + 1)
          anims[anim_name] = anims[anim_name] or {name = anim_name}
          anims[anim_name][column] = GetAnimDuration(model, anim)
        end
      end
    end
  end
  for name, columns in sorted_pairs(anims) do
    csv[#csv + 1] = columns
  end
  SaveCSV("AnimsBySet.csv", csv, columns, columns, ",")
end
function GameTests.AnimsCheckList()
  return
end
GameTestsNightly.TestDoesPrefabMapsSavingGenerateFakeDeltas = empty_func
function GameTestsNightly.TestBantersUsage()
  GameTests_LoadAnyMap()
  ClearErrorSource()
  local undefinedBanters, unusedBanters, ignoredGroups = TestBantersUsage()
  for _, undefinedBanterMarkers in ipairs(undefinedBanters) do
    StoreErrorSource(undefinedBanterMarkers[2], string.format("Did not find a banter id or group '%s' on map: %s", undefinedBanterMarkers[1], undefinedBanterMarkers[2].map))
  end
  for _, unusedBanter in ipairs(unusedBanters) do
    StoreWarningSource(unusedBanter, string.format("Banter not used anywhere: '%s'", unusedBanter.id))
  end
  print("<color 255 0 0> These banter groups are ignored: " .. table.concat(ignoredGroups, ", ") .. "</color>")
end
function GameTestsNightly_TestLootTablesUsage()
  GameTests_LoadAnyMap()
  ClearErrorSource()
  local undefinedLootTableIds, unusedLootTableIds, ignoredLootTableGroups = TestLootTablesUsage()
  for _, undefinedBanterMarkers in ipairs(undefinedLootTableIds) do
    StoreErrorSource(undefinedBanterMarkers[2], string.format("Did not find a loot table id or group '%s' on map: %s", undefinedBanterMarkers[1], undefinedBanterMarkers[2].map))
  end
  for _, unusedLootTable in ipairs(unusedLootTableIds) do
    StoreWarningSource(unusedLootTable, string.format("Loot table not used anywhere: '%s'", unusedLootTable.id))
  end
  print("<color 255 0 0> These loot table groups are ignored: " .. table.concat(ignoredLootTableGroups, ", ") .. "</color>")
end
GameTests.CheckSpots = nil
