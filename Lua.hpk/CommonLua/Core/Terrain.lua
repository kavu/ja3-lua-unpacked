if FirstLoad then
  TerrainTextures = {}
  TerrainNameToIdx = {}
end
function GetTerrainTextureIndex(nameTerrain)
  return TerrainNameToIdx[nameTerrain]
end
function GetTerrainTexturePreview(nameTerrain)
  local idx = GetTerrainTextureIndex(nameTerrain)
  return idx and TerrainTextures[idx] and GetTerrainImage(TerrainTextures[idx].texture) or false
end
function GetTerrainNamesCombo()
  return PresetsCombo("TerrainObj", false, "")
end
if FirstLoad then
  suspendReasons = {}
end
function SuspendTerrainInvalidations(reason)
  reason = reason or false
  if next(suspendReasons) == nil and GetMap() ~= "" then
    terrain.SuspendInvalidation()
  end
  suspendReasons[reason] = true
end
function ResumeTerrainInvalidations(reason, reload)
  reason = reason or false
  suspendReasons[reason] = nil
  if next(suspendReasons) == nil and GetMap() ~= "" then
    if reload then
      hr.TR_ForceReloadNoTextures = 1
    end
    terrain.ResumeInvalidation()
  end
end
if FirstLoad then
  activeThread = false
end
function ScheduleReloadTerrain()
  if not IsValidThread(activeThread) then
    print("The terrain will be reloaded in 3 sec.")
    activeThread = CreateRealTimeThread(function()
      Sleep(2800)
      hr.TR_ForceReloadTextures = true
      activeThread = false
    end)
  end
end
