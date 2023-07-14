local voxelSizeX = const.SlabSizeX or 0
local voxelSizeY = const.SlabSizeY or 0
local voxelSizeZ = const.SlabSizeZ or 0
local halfVoxelSizeX = voxelSizeX / 2
local halfVoxelSizeY = voxelSizeY / 2
local halfVoxelSizeZ = voxelSizeZ / 2
local InvalidZ = const.InvalidZ
local halfGuim = guim / 2
local eightGuim = guim / 8
if FirstLoad then
  DbgPropagateSlabDestructionInEditor = false
  DbgDestruction_DisableWallAndObjPropagation = false
  DbgDestruction_OnlyVerticalPropagation = false
  DbgDestruction_OnlyVerticalPropagationObjsOnly = true
  DbgDestruction_HorizontalObjPropagationOnlyAffectsProps = false
  DbgDestruction_WallAndObjPropatationOnlyAffectsProps = false
  DbgDestruction_UseIsHangingLogic = false
end
MapVar("DestructionInProgressObjs", {})
MapVar("DestructionInProgressObjsCarryOverData", {})
local AddCarryOverData = function(o, ...)
  local t = DestructionInProgressObjsCarryOverData[o] or {}
  DestructionInProgressObjsCarryOverData[o] = t
  for i = 1, select("#", ...), 2 do
    t[select(i, ...)] = select(i + 1, ...)
  end
end
DefineClass.CascadeDestroyForbidden = {
  __parents = {}
}
MapVar("TemporarilyInvulnerableObjs", {})
InteractableClassesThatAreDestroyable = {
  "MachineGunEmplacement",
  "RangeGrantMarker",
  "CuttableFence",
  "Door"
}
local nonDestroyableClasses = {
  "Slab",
  "Ladder",
  "Unit",
  "EditorMarker",
  "Decal",
  "InvisibleObjectHelper",
  "SoundSource",
  "ParSystem",
  "Room",
  "CascadeDestroyForbidden",
  "TwoPointsAttach",
  "Debris"
}
function ShouldDestroyObject(obj, clsTable)
  local isAlreadyDestroyed = obj:GetEnumFlags(const.efVisible) == 0 or IsGenericObjDestroyed(obj) or obj:GetStateText() == "broken" or DestructionInProgressObjs[obj]
  if isAlreadyDestroyed then
    return false
  end
  if IsObjVulnerableDueToLDMark(obj) then
    return true
  end
  if TemporarilyInvulnerableObjs[obj] then
    return false
  end
  clsTable = clsTable or nonDestroyableClasses
  if obj:GetGameFlags(const.gofPermanent) ~= 0 and obj:GetEnumFlags(const.efVisible) ~= 0 and not obj:GetParent() and not IsKindOfClasses(obj, table.unpack(clsTable)) and (not IsKindOf(obj, "DestroyableWallDecoration") or not obj.managed_by_slab) then
    return not DestructionInProgressObjs[obj] and not obj:IsInvulnerable() and not obj:GetStateText():starts_with("broken")
  end
  return false
end
local distPen2dDelim = guim / 2
local distPenZDelim = guim
local GetDistPenalty = function(dist2d, distZ)
  return dist2d / distPen2dDelim + distZ / distPenZDelim
end
Destroyable.__parents[1] = "GameDynamicDataObject"
function Destroyable:SetDynamicData(data)
  self.is_destroyed = data.is_destroyed or false
  self:SetupFlags()
  if self.is_destroyed then
    KillAssociatedLights(self)
  end
end
function Destroyable:GetDynamicData(data)
  if self.is_destroyed then
    data.is_destroyed = self.is_destroyed
  end
end
function DestroyableSlab:SetDynamicData(data)
  self.destroyed_neighbours = data.destroyed_neighbours or 0
  self.use_replace_ent_destruction = data.use_replace_ent_destruction or false
  if self.is_destroyed then
    self:SetDestroyedState(true)
  end
  if self.is_destroyed or self.destroyed_neighbours ~= 0 then
    self:DelayedUpdateEntity()
  end
end
function DestroyableSlab:GetDynamicData(data)
  if self.destroyed_neighbours ~= 0 then
    data.destroyed_neighbours = self.destroyed_neighbours
  end
  if self.use_replace_ent_destruction then
    data.use_replace_ent_destruction = true
  end
end
local CanCanvasEnterBrokenState = function(o)
  return not IsKindOf(o, "Canvas") or o:IsStaticAnim(GetStateIdx("broken")) == o:IsStaticAnim(GetStateIdx("idle"))
end
local KillObj = function(o)
  if IsKindOfClasses(o, "ExplosiveObject", "ExplosiveContainer", "DynamicSpawnLandmine") then
    o:OnDie()
  elseif IsKindOf(o, "CombatObject") then
    DoneCombatObject(o)
  else
    o:Destroy()
  end
end
function ProcessObjectsAroundSlabs(destroyedFloorBoxes, destroyedFloorMap, destroyedWallBoxes, destroyedRoofBoxes, destroyedWallBoxesOnTop)
  if not DbgPropagateSlabDestructionInEditor and IsEditorActive() then
    return
  end
  for i = 1, #destroyedFloorBoxes do
    do
      local origb = destroyedFloorBoxes[i]
      local bcx, bcy, bcz = origb:Center():xyz()
      bcz = select(3, SnapToVoxel(bcx, bcy, bcz + const.SlabSizeZ / 2))
      local testTouchingFloorBox = box(origb:min():AddZ(-const.SlabSizeZ), origb:max():AddZ(20))
      local queryb = Offset(origb:grow(voxelSizeX, voxelSizeY, voxelSizeZ * 3), point(0, 0, voxelSizeZ * 3 / 2))
      MapForEach(queryb, "CObject", const.efVisible, function(o)
        if ShouldDestroyObject(o) then
          local ob = o:GetObjectBBox()
          o:ForEachAttach(function(att)
            ob = AddRects(ob, att:GetObjectBBox())
          end)
          if ob:Intersect(testTouchingFloorBox) ~= const.irOutside then
            do
              local obsx, obsy, obsz = ob:size():xyz()
              local shouldDie = false
              local traverseFunc = (obsx < voxelSizeX or obsy < voxelSizeY) and ForEachVoxelInBox2DExclusive or ForEachVoxelInBox2D
              traverseFunc(ob, function(x, y, z)
                if destroyedFloorMap[EncodeVoxelPos(x, y, z)] then
                  shouldDie = true
                  return "break"
                end
              end, bcz)
              if shouldDie then
                AddCarryOverData(o, "dist2d", distPen2dDelim)
                KillObj(o)
              end
            end
          end
        end
      end)
    end
  end
  local filterRoof = function(o, dist2d, distZ, box, oBB)
    if ShouldDestroyObject(o) then
      AddCarryOverData(o, "dist2d", dist2d + distPen2dDelim, "distZ", distZ)
      return true
    end
    return false
  end
  local filterWall = function(o, dist2d, distZ, box, oBB, i)
    local kill = false
    if ShouldDestroyObject(o) then
      local m = o:GetMaterialPreset()
      local nb = IntersectRects(box, oBB)
      if nb == oBB then
        kill = true
      else
        local nbsz = nb:sizez()
        local bmz = box:maxz()
        if destroyedWallBoxesOnTop[i] then
          bmz = bmz - 200
        end
        local pos = o:GetPos()
        local oz
        if oBB:PointInside(pos) then
          oz = pos:z()
        else
          oz = oBB:Center():z()
        end
        local percFromSelf = MulDivRound(nbsz, 100, Max(oBB:sizez(), 1))
        local percFromVox = MulDivRound(nbsz, 100, voxelSizeZ)
        local isHorizontal = (50 < percFromVox or 20 < percFromSelf) and (not oz or bmz - oz >= eightGuim)
        if isHorizontal and DbgDestruction_OnlyVerticalPropagation then
          return false
        end
        local isProp = m and m.is_prop
        if isHorizontal and not isProp then
          isProp = IsObjPropDueToLDMark(o)
        end
        if DbgDestruction_WallAndObjPropatationOnlyAffectsProps and not isProp then
          return false
        end
        if not isHorizontal or isProp then
          kill = true
        end
      end
    end
    if kill then
      AddCarryOverData(o, "dist2d", dist2d + distPen2dDelim, "distZ", distZ, "step", 1)
    end
    return kill
  end
  local objsToKill
  if not DbgDestruction_DisableWallAndObjPropagation then
    objsToKill = FindDebrisObjectsToDestroy(destroyedWallBoxes, filterWall)
    for i, o in ipairs(objsToKill or empty_table) do
      KillObj(o)
    end
  end
  objsToKill = FindDebrisObjectsToDestroy(destroyedRoofBoxes, filterRoof)
  for i, o in ipairs(objsToKill or empty_table) do
    KillObj(o)
  end
end
MapVar("Destruction_DestroyedObjects", {})
MapVar("Destruction_DestroyedCObjects", {})
local destroyedMask = const.efVisible | const.efCollision | const.efApplyToGrids
local GetVisualStateHashForDestroyedObj = rawget(_G, "GetVisualStateHashForDestroyedObj")
function OnMsg.LoadDynamicData(data)
  Destruction_DestroyedObjects = data.Destruction_DestroyedObjects or {}
  Destruction_DestroyedCObjects = data.Destruction_DestroyedCObjects or {}
  LoadSavedDestroyedObjects()
end
function OnMsg.SaveDynamicData(data)
  data.Destruction_DestroyedObjects = Destruction_DestroyedObjects
  data.Destruction_DestroyedCObjects = Destruction_DestroyedCObjects
end
function AppendDestroyedObject(obj)
  table.insert(DestroyedObjectsThisTick, obj)
  WakeUpDestructionPP()
end
local xyGrowth = 50
function GetDestroyQueryBoxForObj(obj)
  local bbox = obj:GetObjectBBox()
  local isLarge = Max(bbox:sizex(), bbox:sizey()) / voxelSizeX > 0
  obj:ForEachAttach(function(o)
    bbox = AddRects(bbox, o:GetObjectBBox())
  end)
  local x, y, z = bbox:sizexyz()
  local growth = isLarge and string.find(obj:GetEntity(), "Dec") and 0 or xyGrowth
  return Offset(Resize(bbox, MulDivRound(x, 100 + growth, 100), MulDivRound(y, 100 + growth, 100), MulDivRound(z, 100, 85)), -MulDivRound(x, growth / 2, 100), -MulDivRound(y, growth / 2, 100), 25), bbox
end
function GetDestroyQueryBoxForObj_HangingTest(obj)
  local bbox = obj:GetObjectBBox()
  obj:ForEachAttach(function(o)
    bbox = AddRects(bbox, o:GetObjectBBox())
  end)
  local x, y, z = bbox:sizexyz()
  return Offset(bbox:grow(x / 2, y / 2, z / 2), 0, 0, z / 2 + 25), bbox
end
local particleTimeout = 33
MapVar("DestructionParticleGrid", false)
local ShouldPlayDestructionFX = function(obj)
  local e = obj:GetEntity()
  local size = s_EntitySizeCache[e]
  local mat = GetObjMaterialFXTarget(obj)
  local tId = xxhash(size, mat)
  DestructionParticleGrid = DestructionParticleGrid or {}
  local t = DestructionParticleGrid[tId] or {}
  DestructionParticleGrid[tId] = t
  local voxId = xxhash(WorldToVoxel(obj:GetPos()))
  local ts = t[voxId] or -particleTimeout
  local now = GameTime()
  if now - ts >= particleTimeout then
    t[voxId] = now
    return true
  end
  return false
end
CObject.OnDestroy = empty_func
function CObject:Destroy()
  if self:GetEnumFlags(const.efVisible) == 0 and self:GetParent() then
    return
  end
  DestructionInProgressObjs[self] = true
  AppendDestroyedObject(self)
  if ShouldPlayDestructionFX(self) then
    self:PlayDestructionFX()
  end
  if self:HasMember("HitPoints") then
    self.HitPoints = 0
  end
  self:OnDestroy()
  KillAssociatedLights(self)
  if rawget(self, "command") then
    self:SetCommand(false)
  end
end
function CObject:SpreadDebris()
end
local brokenStateMax = 9
local brokenStateCache = {}
function ClearBrokenStateCache()
  brokenStateCache = {}
end
function OnMsg.DataReloadDone()
  ClearBrokenStateCache()
end
function GetMaxBrokenState(obj)
  local ent = obj:GetEntity()
  local max = brokenStateCache[ent]
  if not max then
    for i = brokenStateMax, 1, -1 do
      if obj:HasState(string.format("broken%d", i)) then
        max = i
        break
      end
    end
    max = max or 0
    brokenStateCache[ent] = max
  end
  return max
end
function GetBrokenStateName(num)
  if num <= 1 then
    return "broken"
  else
    return string.format("broken%d", num)
  end
end
function ComputeBrokenStateForObj(obj)
  local max = GetMaxBrokenState(obj)
  local num = BraidRandom(xxhash(obj:GetPos()), max) + 1
  local state = GetBrokenStateName(num)
  return state
end
function IsOnGround(obj)
  local isOnGround
  local x, y, z = obj:GetPosXYZ()
  isOnGround = not z or z == const.InvalidZ
  if not isOnGround then
    local b = obj:GetObjectBBox()
    local th = terrain.GetHeight(x, y)
    if th >= b:minz() or abs(th - b:minz()) < guim / 10 then
      isOnGround = true
    end
  end
  return isOnGround
end
function OnMsg.DestroyableSlabDestroyed()
  if g_Combat then
    g_Combat.visibility_update_hash = false
  end
end
function ShouldNetCheckObj(obj)
  return obj:GetDetailClass() == "Essential"
end
function CObject:SetupDestroyedState(destroyed, spread_debris, dont_update_hash)
  if destroyed then
    dont_update_hash = dont_update_hash or not ShouldNetCheckObj(self)
    if spread_debris then
      self:SpreadDebris()
    end
    local oldState = self:GetStateText()
    local isOnGround
    local isExplosiveObject = IsKindOf(self, "ExplosiveObject")
    if self:GetEntity() ~= "" and (axis_z == self:GetAxis() or isExplosiveObject) and self:HasState("broken") and CanCanvasEnterBrokenState(self) then
      isOnGround = IsOnGround(self)
      if isOnGround then
        local setup = function()
          local s = ComputeBrokenStateForObj(self)
          self:SetState(s)
          if not dont_update_hash then
            NetUpdateHash("Object:SetupDestroyedState_SetState", self:IsSyncObject() and self or self.class, self:GetPos(), self:GetAngle(), self:GetAxis(), oldState, s, self:GetStateText())
          end
        end
        if isExplosiveObject then
          CreateGameTimeThread(function()
            Sleep(200)
            if IsValid(self) then
              setup()
            end
          end)
          return
        end
        setup()
        return
      end
    end
    local b = self:GetObjectBBox():grow(200, 200, 50)
    MapForEach(b, "Debris", function(o)
      if o:IsFadingAway() then
        DoneObject(o)
      end
    end)
    self:ClearEnumFlags(destroyedMask)
    collision.SetAllowedMask(self, 0)
    self:ForEachAttach(function(attach)
      attach:ClearEnumFlags(destroyedMask)
      collision.SetAllowedMask(attach, 0)
    end)
    if g_Combat then
      g_Combat.visibility_update_hash = false
    end
    if not dont_update_hash then
      NetUpdateHash("Object:SetupDestroyedState", self:IsSyncObject() and self or self.class, self:GetPos(), self:GetAngle(), self:GetAxis(), oldState, self:GetStateText())
    end
  else
    self:SetEnumFlags(destroyedMask)
    if self:GetStateText() == "broken" then
      self:SetState("idle")
    end
  end
end
function TwoPointsAttachParent:SetupDestroyedState(destroyed)
  CObject.SetupDestroyedState(self, destroyed)
  MapForEach("map", "TwoPointsAttach", function(obj, destroyed)
    if obj.obj1 == self or obj.obj2 == self then
      obj:SetupDestroyedState(destroyed)
    end
  end, destroyed)
end
function TwoPointsAttach:SetupDestroyedState(destroyed)
  self:SetVisible(not destroyed)
end
function CObject:IsInvulnerable()
  if IsObjVulnerableDueToLDMark(self) then
    return false
  end
  if TemporarilyInvulnerableObjs[self] then
    return true
  end
  local p = self:GetMaterialPreset()
  if p and p.invulnerable then
    return true
  end
  return IsObjInvulnerableDueToLDMark(self)
end
local materials = table.get(Presets, "ObjMaterial", "Default")
function CObject:GetMaterialPreset()
  materials = materials or table.get(Presets, "ObjMaterial", "Default")
  local id = self:GetMaterialType()
  if id then
    return materials and materials[id]
  end
  return false
end
function CObject:IsPropMaterial()
  local preset = self:GetMaterialPreset()
  return preset and preset.is_prop or false
end
function CObject:GetDestructionPorpagationProps()
  local preset = self:GetMaterialPreset()
  return preset and preset.destruction_propagation_strength or 0, preset and preset.invulnerable or false, preset and preset.is_prop or false
end
function DbgShowMeSeloDestroyQBox()
  local dqb, bb = GetDestroyQueryBoxForObj(selo())
  DbgAddBox(dqb)
end
function DbgShowMeSeloDestroyQBox_H()
  local dqb, bb = GetDestroyQueryBoxForObj_HangingTest(selo())
  DbgAddBox(dqb)
end
local dbgGenericDestruction = false
function ProcessDestroyedGenericObjectsThisTick()
  if #DestroyedObjectsThisTick <= 0 then
    return
  end
  local pos_cache = {}
  local pass = 0
  while #DestroyedObjectsThisTick > 0 do
    local t = DestroyedObjectsThisTick
    DestroyedObjectsThisTick = {}
    if dbgGenericDestruction then
      print("pass", pass)
    end
    for i, obj in ipairs(t) do
      local h = rawget(obj, "handle")
      if h then
        Destruction_DestroyedObjects[h] = true
        table.insert(Destruction_DestroyedObjects, h)
      else
        h = GetVisualStateHashForDestroyedObj(obj)
        Destruction_DestroyedCObjects[h] = true
        table.insert(Destruction_DestroyedCObjects, h)
      end
      local cascadeDestruction = not DbgDestruction_DisableWallAndObjPropagation and not obj:IsGrassOrShrub() and obj:GetDetailClass() == "Essential"
      local dqb, bb
      if cascadeDestruction then
        if DbgDestruction_UseIsHangingLogic then
          dqb, bb = GetDestroyQueryBoxForObj_HangingTest(obj)
        else
          dqb, bb = GetDestroyQueryBoxForObj(obj)
        end
      end
      obj:SetupDestroyedState(true, "spread_debris")
      DestructionInProgressObjs[obj] = nil
      if cascadeDestruction then
        local cascadeDestroyed
        if DbgDestruction_UseIsHangingLogic then
          local objs = FindDebrisObjectsToDestroy(dqb, function(o, _, _, mb, hb)
            if o == obj or not ShouldDestroyObject(o) then
              return false
            end
            return hb:Center():z() >= bb:minz()
          end)
          if objs then
            cascadeDestroyed = Destruction_CheckForHangingObjs(objs)
          end
        else
          cascadeDestroyed = GetCascadeDestroyObjects(obj, pos_cache, dqb, bb)
        end
        for j, cascadeObj in ipairs(cascadeDestroyed or empty_table) do
          KillObj(cascadeObj)
        end
      end
      DestructionInProgressObjsCarryOverData[obj] = nil
    end
    pass = pass + 1
  end
end
function GetCascadeDestroyObjects(obj, pos_cache, dqb, bb)
  if DbgDestruction_DisableWallAndObjPropagation then
    return
  end
  pos_cache = pos_cache or {}
  local getPosFromCache = function(obj, box)
    local b = pos_cache[obj]
    if not b then
      box = box or obj:GetObjectBBox()
      pos_cache[obj] = box
      b = box
    end
    return b:Center(), b
  end
  if not dqb then
    dqb, bb = GetDestroyQueryBoxForObj(obj)
  end
  local ds = obj:GetDestructionPorpagationProps()
  local cod = DestructionInProgressObjsCarryOverData[obj]
  local dist2d = 0
  local distZ = 0
  local step = 0
  if cod then
    dist2d = cod.dist2d or 0
    distZ = cod.distZ or 0
    step = cod.step or 0
  end
  local distPenalty = GetDistPenalty(dist2d, distZ)
  local dsp = ds - distPenalty
  local myPos = getPosFromCache(obj, bb)
  if dbgGenericDestruction then
    DbgAddVector(obj:GetPos())
    DbgAddBox(bb)
    DbgAddBox(dqb)
    print("distPenalty", obj.class, distPenalty, dist2d, distZ)
  end
  local objects = FindDebrisObjectsToDestroy(dqb, function(o, toHim2d, toHimZ, box, oBB)
    if o == obj or not ShouldDestroyObject(o) then
      return false
    end
    local hisDs, invulnerable, is_prop = o:GetDestructionPorpagationProps()
    is_prop = is_prop or IsObjPropDueToLDMark(o)
    local hisPos, hisBox = getPosFromCache(o)
    local toHim = hisPos - myPos
    local toHimZOrigins = toHim:z()
    local toHimZOriginsAbs = abs(toHimZOrigins)
    local toHimLen2D = toHim:Len2D()
    local myBMinZ = bb:minz()
    local myBMaxZ = bb:maxz()
    local hisBMaxZ = hisBox:maxz()
    local hisBMinZ = hisBox:minz()
    local myZ = myPos:z()
    local hisZ = hisPos:z()
    local isHorizontalPropagation = toHimZOriginsAbs < eightGuim or toHimLen2D > halfGuim / 2 and (hisBMaxZ > myZ and hisBMinZ < myZ or myBMaxZ > hisZ and myBMinZ < hisZ)
    if isHorizontalPropagation then
      if bb:Intersect2D(oBB) == const.irInside then
        isHorizontalPropagation = false
      elseif (o:GetPos() - obj:GetPos()):Len2() < 27225 then
        isHorizontalPropagation = false
      end
    end
    if isHorizontalPropagation and (0 < step or not is_prop) then
      return false
    end
    if not isHorizontalPropagation and not is_prop and toHimZOrigins < 0 and myBMinZ > hisBMinZ then
      return false
    end
    if isHorizontalPropagation and DbgDestruction_OnlyVerticalPropagationObjsOnly then
      return false
    end
    if isHorizontalPropagation and DbgDestruction_OnlyVerticalPropagation then
      return false
    end
    if isHorizontalPropagation and DbgDestruction_HorizontalObjPropagationOnlyAffectsProps and not is_prop then
      return false
    end
    if DbgDestruction_WallAndObjPropatationOnlyAffectsProps and not is_prop then
      return false
    end
    local myDs = dsp
    if 0 < ds and (toHimLen2D <= halfGuim or not isHorizontalPropagation and bb:Point2DInsideInclusive(hisPos)) then
      myDs = ds
    end
    if hisDs <= myDs then
      AddCarryOverData(o, "dist2d", toHim2d + dist2d, "distZ", toHimZ + distZ, "step", step + (isHorizontalPropagation and 1 or 0))
      if dbgGenericDestruction then
        print("cascade destroying", o.class, myDs, hisDs)
      end
      return true
    end
    return false
  end)
  return objects
end
function testHashing()
  local data = {}
  MapForEach("map", "CObject", function(o)
    if not IsKindOf(o, "Object") then
      local h = GetVisualStateHashForDestroyedObj(o)
      if data[h] then
        print("collision", o.class, data[h].class)
      end
      data[h] = o
    end
  end)
end
function IsGenericObjDestroyed(obj)
  local h = rawget(obj, "handle")
  return h and Destruction_DestroyedObjects[h] or not h and Destruction_DestroyedCObjects[GetVisualStateHashForDestroyedObj(obj)]
end
function IsObjectDestroyed(obj)
  return obj.is_destroyed or IsGenericObjDestroyed(obj)
end
function LoadSavedDestroyedObjects()
  if not next(Destruction_DestroyedCObjects) and not next(Destruction_DestroyedObjects) then
    return
  end
  local total = #Destruction_DestroyedObjects + #Destruction_DestroyedCObjects
  local count = 0
  MapForEach("map", "CObject", const.efVisible, function(o, IsGenericObjDestroyed, total)
    if IsGenericObjDestroyed(o) then
      o:SetupDestroyedState(true)
      KillAssociatedLights(o)
      count = count + 1
      if total <= count then
        return "break"
      end
    end
  end, IsGenericObjDestroyed, total)
end
function OnMsg.GameExitEditor()
  SuspendPassEdits("GameExitEditor_HideDestroyedObjs")
  MapForEach("map", "CObject", function(o)
    if IsGenericObjDestroyed(o) then
      o:SetupDestroyedState(true, nil, "dont_update_hash")
    end
  end)
  ResumePassEdits("GameExitEditor_HideDestroyedObjs")
end
function OnMsg.GameEnterEditor()
  SuspendPassEdits("GameEnterEditor_ShowDestroyedObjs")
  MapForEach("map", "CObject", function(o)
    if IsGenericObjDestroyed(o) then
      o:SetupDestroyedState(false, nil, "dont_update_hash")
    end
  end)
  ResumePassEdits("GameEnterEditor_ShowDestroyedObjs")
end
function OnMsg.SetObjectDetail(action, params)
  if action == "done" then
    local editor = IsEditorActive()
    MapForEach("map", "CObject", const.efVisible, function(obj, IsGenericObjDestroyed, editor)
      if IsGenericObjDestroyed(obj) then
        obj:SetupDestroyedState(not editor, nil, "dont_update_hash")
      end
    end, IsGenericObjDestroyed, editor)
  end
end
if FirstLoad then
  DestroyedAttachSelectionEnabled = false
end
MapVar("SelectedDestroyedAttaches", false)
local RestoreDestroyedAttach = function(o)
  if o then
    if not o.parent then
      print("<color 255 0 0>SelectedDestroyedAttach has no parent!</color>")
      return
    end
    o.parent:Attach(o)
    o:SetAttachOffset(o.offset)
    o:SetAttachAngle(o.angle)
    o:SetMirrored(o.mirror)
    o.offset = nil
    o.angle = nil
    o.parent = nil
    o.mirror = nil
  end
end
local RestoreDestroyedAttaches = function()
  if SelectedDestroyedAttaches then
    SuspendPassEdits("RestoreDestroyedAttaches")
    for _, att in ipairs(SelectedDestroyedAttaches) do
      RestoreDestroyedAttach(att)
    end
    SelectedDestroyedAttaches = false
    ResumePassEdits("RestoreDestroyedAttaches")
  end
end
local SetSelectedDestroyedAttach = function(attach)
  local slab = attach:GetParent()
  if not slab then
    return
  end
  attach.parent = slab
  attach.offset = attach:GetAttachOffset()
  attach.angle = attach:GetAttachAngle()
  attach.mirror = attach:GetMirrored()
  local pos = attach:GetVisualPos()
  local angle = attach:GetAngle()
  local mirror = slab:GetMirrored() and attach.angle > 0 or not slab:GetMirrored() and attach.mirror
  attach:Detach()
  attach:SetPosAngle(pos, angle)
  attach:SetMirrored(mirror)
end
function ToggleDestroyedAttachSelectionMode()
  if DestroyedAttachSelectionEnabled then
    RestoreDestroyedAttaches()
  end
  DestroyedAttachSelectionEnabled = not DestroyedAttachSelectionEnabled
  print("Destroyed Attach Selection is " .. (DestroyedAttachSelectionEnabled and "ON" or "OFF"))
end
local fiddlingWithSelection = false
function OnMsg.EditorSelectionChanged(objects)
  if not DestroyedAttachSelectionEnabled then
    return
  end
  if fiddlingWithSelection then
    return
  end
  local attaches = false
  local attach = false
  if objects then
    for i = 1, #objects do
      local obj = objects[i]
      if IsKindOf(obj, "DestroyableSlab") and obj.is_destroyed then
        local cp = GetCursorPos()
        local ptCamera, ptCameraLookAt = GetCamera()
        attach = GetNextObjectAtScreenPos(function(o)
          return IsKindOf(o, "DestroyedSlabAttach")
        end)
        if not attach then
          local atts = objects[1]:GetAttaches("DestroyedSlabAttach")
          for i = 1, #(atts or "") do
            if not attach then
              attach = atts[i]
            else
              local b1 = attach:GetObjectBBox()
              local b2 = atts[i]:GetObjectBBox()
              local c1, c2 = b1:Center(), b2:Center()
              if IsCloser(cp, c2, c1) then
                attach = atts[i]
              end
            end
          end
        end
      elseif IsKindOf(obj, "DestroyedSlabAttach") then
        attach = obj
      end
      if attach then
        attaches = attaches or {}
        table.insert(attaches, attach)
      end
    end
  end
  if not SelectedDestroyedAttaches and not attaches then
    return
  end
  SuspendPassEdits("DestroyedAttachSelectionEnabled")
  for _, att in ipairs(SelectedDestroyedAttaches or empty_table) do
    if not attaches or not table.find(attaches, att) then
      RestoreDestroyedAttach(att)
    end
  end
  if attaches then
    fiddlingWithSelection = true
    editor.ClearSel()
    for i = #attaches, 1, -1 do
      if not SelectedDestroyedAttaches or not table.find(SelectedDestroyedAttaches, attaches[i]) then
        SetSelectedDestroyedAttach(attaches[i])
      end
    end
    editor.SetSel(attaches)
    fiddlingWithSelection = false
    SelectedDestroyedAttaches = attaches
  else
    SelectedDestroyedAttaches = false
  end
  ResumePassEdits("DestroyedAttachSelectionEnabled")
end
function SelectedDestroyedAttach_GetNeighbourWallSlab(o)
  local p = o.parent
  local s = o:GetSide()
  if IsKindOfClasses(p, "DestroyableFloorSlab", "RoofPlaneSlab") then
    return p:GetNeighbour(s)
  else
    local pos = p:GetRelativePoint(o.offset)
    local dir = slabAngleToDir[p:GetAngle()]
    if SlabNeighbourMask.Left == s then
      local offs = wallSidewaysOffsets[dir]
      pos = pos + point(offs.x * voxelSizeX, offs.y * voxelSizeY, 0)
    elseif SlabNeighbourMask.Right == s then
      local offs = wallSidewaysOffsets[dir]
      pos = pos - point(offs.x * voxelSizeX, offs.y * voxelSizeY, 0)
    elseif SlabNeighbourMask.Top == s then
      pos = pos + point(0, 0, voxelSizeZ)
    else
      pos = pos - point(0, 0, voxelSizeZ)
    end
    return MapGet(pos, 0, "WallSlab", nil, const.efVisible)
  end
end
function OnDestroyedAttachDeleted(o)
  if SelectedDestroyedAttaches and table.find(SelectedDestroyedAttaches, o) then
    SuspendPassEdits("OnDestroyedAttachDeleted")
    local nbrs = SelectedDestroyedAttach_GetNeighbourWallSlab(o)
    local id = o:GetId()
    local p = o.parent
    local sideFlag = o:GetSide()
    if nbrs then
      nbrs = IsValid(nbrs) and {nbrs} or nbrs
      for _, nbr in ipairs(nbrs) do
        if nbr and not nbr.is_destroyed then
          nbr:Repair()
          nbr.force_destroyed_entity = GetNeigbhourSideFlagTowardMe(sideFlag, nbr, p)
          nbr.force_no_destroyed_entity = false
          nbr:UpdateDestroyedState()
        end
      end
    end
    p.da_subvariants = p.da_subvariants or {}
    p.da_subvariants[id] = 0
    table.remove_entry(SelectedDestroyedAttaches, o)
    if #SelectedDestroyedAttaches <= 0 then
      SelectedDestroyedAttaches = false
    end
    if IsKindOf(p, "RoofWallSlab") then
      local lst = MapGet(p, 0, "RoofWallSlab")
      for _, slab in ipairs(lst) do
        if slab ~= p then
          local da = slab.destroyed_attaches
          local sf = sideFlag & 12 == 0 or p:GetAngle() == slab:GetAngle() and sideFlag or maskToOppositeMask[sideFlag]
          local att = da[maskToString[sf]]
          if att then
            slab:DestroyDestroyedAttach(sf)
            slab.da_subvariants = slab.da_subvariants or {}
            slab.da_subvariants[att:GetId()] = 0
          end
        end
      end
    end
    ResumePassEdits("OnDestroyedAttachDeleted")
    return true
  end
  return false
end
function OnMsg.EditorCallback(id, objs)
  if not SelectedDestroyedAttaches then
    return
  end
  if id == "EditorCallbackDelete" then
    for i = 1, #objs do
      local o = objs[i]
      if OnDestroyedAttachDeleted(o) then
        return
      end
    end
  end
end
local preSaveAttach = false
function OnMsg.PreSaveMap()
  if not SelectedDestroyedAttaches then
    return
  end
  preSaveAttach = SelectedDestroyedAttaches
  RestoreDestroyedAttaches()
  SelectedDestroyedAttaches = false
end
function OnMsg.PostSaveMap()
  if preSaveAttach then
    for _, att in ipairs(preSaveAttach) do
      SetSelectedDestroyedAttach(att)
    end
    SelectedDestroyedAttaches = preSaveAttach
    editor.SetSel({
      SelectedDestroyedAttaches
    })
    preSaveAttach = false
  end
end
if Platform.developer then
  DefineClass.DestroyedSlabMarker = {
    __parents = {
      "EditorVisibleObject"
    },
    flags = {gofPermanent = false},
    entity = "DestroyedSlab",
    slab = false
  }
  local ignoreSelectionChangedMsg = false
  function OnMsg.EditorSelectionChanged(objects)
    if ignoreSelectionChangedMsg then
      return
    end
    local markers = false
    local slabs = false
    for i = 1, #(objects or "") do
      local o = objects[i]
      if IsKindOf(o, "DestroyedSlabMarker") then
        markers = markers or {}
        slabs = slabs or {}
        table.insert(markers, o)
        if IsValid(o.slab) then
          table.insert(slabs, o.slab)
          o:SetPosAngle(o.slab:GetPos(), o.slab:GetAngle())
        end
      end
    end
    ignoreSelectionChangedMsg = true
    if markers then
      editor.RemoveFromSel(markers)
    end
    if slabs then
      editor.AddToSel(slabs)
    end
    ignoreSelectionChangedMsg = false
  end
  function OnMsg.ChangeMapDone(map)
    if map == "" then
      return
    end
    MapForEach("map", "DestroyableSlab", const.efVisible, function(s)
      if s.is_destroyed then
        s:ManageSelectionMarker(true)
      end
    end)
  end
  function DestroyableSlab:Done()
    self:ManageSelectionMarker(false)
  end
  function DestroyableSlab:ManageSelectionMarker(create)
    if create then
      local m = PlaceObject("DestroyedSlabMarker", {slab = self})
      self.selection_marker = m
      m:SetPosAngle(self:GetPos(), self:GetAngle())
      XEditorFilters:UpdateObject(m)
      if IsEditorActive() and not XEditorFilters:IsObjectHidden(m) then
        m:SetEnumFlags(const.efVisible)
      else
        m:ClearEnumFlags(const.efVisible)
      end
    else
      if IsValid(self.selection_marker) then
        DoneObject(self.selection_marker)
      end
      self.selection_marker = false
    end
  end
  local InvulnerableSlabOwned = RGBA(0, 0, 255, 0)
  local InvulnerableSlabUnowned = RGBA(255, 0, 255, 0)
  local InvulnerableObjDueToMaterial = RGBA(255, 0, 0, 0)
  local InvulnerableObjDueToLDMark = RGBA(70, 0, 255, 0)
  local InvulnerableObjDueToInteractables = RGBA(175, 0, 255, 0)
  local MaterialStrengthRanges = {
    [1] = 10,
    [2] = 15,
    [3] = 30,
    [4] = 9999
  }
  local MaterialStrengthColors = {
    [1] = RGBA(0, 255, 0, 0),
    [2] = RGBA(255, 255, 0, 0),
    [3] = RGBA(255, 150, 0, 0),
    [4] = RGBA(255, 70, 0, 0)
  }
  function PrintDestroyableOverlayLegend()
    local helper = function(color, name)
      local r, g, b = GetRGB(color)
      return string.format([[
<color %d %d %d>%s
</color>]], r, g, b, name)
    end
    local s = ""
    s = s .. helper(InvulnerableSlabOwned, "InvulnerableSlabOwned (part of room)")
    s = s .. helper(InvulnerableSlabUnowned, "InvulnerableSlabUnowned (not part of room)")
    s = s .. helper(InvulnerableObjDueToMaterial, "InvulnerableObjDueToMaterial")
    s = s .. helper(InvulnerableObjDueToLDMark, "InvulnerableObjDueToLDMark")
    s = s .. helper(InvulnerableObjDueToInteractables, "InvulnerableObjDueToInteractables")
    local str = 0
    for i = 1, #MaterialStrengthRanges do
      s = s .. helper(MaterialStrengthColors[i], "Vulnerable non slab objects; Material Strength: " .. tostring(str) .. "-" .. tostring(MaterialStrengthRanges[i]))
      str = MaterialStrengthRanges[i] + 1
    end
    print(s)
  end
  local StrengthToColor = function(str)
    for i = 1, #MaterialStrengthRanges do
      if str <= MaterialStrengthRanges[i] then
        return MaterialStrengthColors[i]
      end
    end
  end
  MapVar("InvulnerabilityPainted", false)
  MapVar("MarkInvulnerableObjectsData", false)
  function OnMsg.EditorPreSerialize()
    ClearInvulnerableMarking("keep_data")
  end
  function OnMsg.EditorPostSerialize()
    if InvulnerabilityPainted then
      local old_colors = table.copy(MarkInvulnerableObjectsData)
      MarkInvulnerableObjectsData = {}
      for obj, col in pairs(old_colors) do
        if IsValid(obj) then
          MarkInvulnerableObject(obj, col)
        end
      end
    end
  end
  function OnMsg.EditorCallback(callback, objects)
    if InvulnerabilityPainted and callback == "EditorCallbackPlace" then
      for _, obj in ipairs(objects) do
        SetupObjInvulnerabilityColorMarking(obj)
      end
    end
  end
  function MarkInvulnerableObject(o, col)
    if not MarkInvulnerableObjectsData[o] then
      MarkInvulnerableObjectsData[o] = o:GetColorModifier()
    end
    o:SetColorModifier(col)
  end
  function SetupObjInvulnerabilityColorMarkingOnValueChanged(o)
    if not InvulnerabilityPainted then
      return
    end
    if not SetupObjInvulnerabilityColorMarking(o) then
      local c = MarkInvulnerableObjectsData[o]
      if c then
        o:SetColorModifier(c)
        MarkInvulnerableObjectsData[o] = nil
      end
    end
  end
  function SetupObjInvulnerabilityColorMarking(o)
    if IsKindOf(o, "Slab") then
      if o:IsInvulnerable() then
        MarkInvulnerableObject(o, (o.room or o.always_visible) and InvulnerableSlabOwned or InvulnerableSlabUnowned)
        return true
      end
    else
      local m = o:GetMaterialPreset()
      local inv = false
      local str = 0
      if m then
        inv = m.invulnerable
        str = m.destruction_propagation_strength
      end
      if not IsObjVulnerableDueToLDMark(o) and inv then
        MarkInvulnerableObject(o, InvulnerableObjDueToMaterial)
        return true
      elseif IsObjInvulnerableDueToLDMark(o) then
        MarkInvulnerableObject(o, InvulnerableObjDueToLDMark)
        return true
      elseif ShouldDestroyObject(o) then
        local c = StrengthToColor(str)
        MarkInvulnerableObject(o, c)
        return true
      elseif TemporarilyInvulnerableObjs[o] then
        MarkInvulnerableObject(o, InvulnerableObjDueToInteractables)
        return true
      end
    end
    return false
  end
  function MarkInvulnerableObjects()
    MarkInvulnerableObjectsData = MarkInvulnerableObjectsData or {}
    MapForEach("map", SetupObjInvulnerabilityColorMarking)
    InvulnerabilityPainted = true
    PrintDestroyableOverlayLegend()
  end
  function ClearInvulnerableMarking(keep_data)
    if not InvulnerabilityPainted then
      return
    end
    for obj, col in pairs(MarkInvulnerableObjectsData or empty_table) do
      if IsValid(obj) then
        MarkInvulnerableObjectsData[obj] = obj:GetColorModifier()
        obj:SetColorModifier(col)
      end
    end
    if not keep_data then
      MarkInvulnerableObjectsData = false
      InvulnerabilityPainted = false
    end
  end
  function ToggleInvulnerabilityMarkings()
    if InvulnerabilityPainted then
      ClearInvulnerableMarking()
    else
      MarkInvulnerableObjects()
    end
  end
  function OnMsg.ReloadLua()
    if not InvulnerabilityPainted then
      return
    end
    DelayedCall(1, ClearInvulnerableMarking)
    DelayedCall(2, MarkInvulnerableObjects)
  end
  local wasMarked = false
  function OnMsg.PreSaveMap()
    if InvulnerabilityPainted then
      wasMarked = true
      ClearInvulnerableMarking()
    end
  end
  function OnMsg.PostSaveMap()
    if wasMarked then
      MarkInvulnerableObjects()
      wasMarked = false
    end
  end
end
MapVar("InvObjsContainerInstance", false)
local InvulnerableObjsContainer_Version = 2
local invulnerable_state = "inv"
local vulnerable_state = "vul"
local prop_state = "prp"
DefineClass.InvulnerableObjsContainer = {
  __parents = {"Object"},
  entity = "InvisibleObject",
  flags = {
    gofPermanent = true,
    efCollision = false,
    efApplyToGrids = false,
    efSelectable = false,
    efWalkable = false,
    efVisible = false
  },
  properties = {
    {
      id = "dataCobjs",
      editor = "prop_table",
      default = false,
      read_only = true
    },
    {
      id = "dataVCobjs",
      editor = "prop_table",
      default = false,
      read_only = true
    },
    {
      id = "dataObjs",
      editor = "prop_table",
      default = false,
      read_only = true
    },
    {
      id = "dataVObjs",
      editor = "prop_table",
      default = false,
      read_only = true
    },
    {
      id = "data",
      editor = "prop_table",
      default = false,
      read_only = true
    },
    {
      id = "version",
      editor = "number",
      default = 1,
      read_only = true
    }
  }
}
function InvulnerableObjsContainer:Init()
end
function InvulnerableObjsContainer:PostLoad()
  if self.version == 1 then
    self:PatchV1ToV2()
  end
  if self.version == 2 then
    self:PatchV2ToV3()
  end
end
function InvulnerableObjsContainer:PatchV1ToV2()
  print("InvulnerableObjsContainer:PatchV1ToV2")
  self.data = {}
  for id, _ in pairs(self.dataCobjs or empty_table) do
    self.data[id] = invulnerable_state
  end
  self.dataCobjs = false
  for id, _ in pairs(self.dataVCobjs or empty_table) do
    self.data[id] = vulnerable_state
  end
  self.dataVCobjs = false
  for id, _ in pairs(self.dataObjs or empty_table) do
    self.data[id] = invulnerable_state
  end
  self.dataObjs = false
  for id, _ in pairs(self.dataVObjs or empty_table) do
    self.data[id] = vulnerable_state
  end
  self.dataVObjs = false
  if not next(self.data) then
    self.data = false
  end
  self.version = 2
end
function InvulnerableObjsContainer:TestV3()
  local data = self.data
  if not data then
    return
  end
  MapForEach("map", "CObject", function(obj)
    local id = self:GetIdForObj(obj)
    if data[id] then
      local val = data[id]
      if val == prop_state then
      elseif val == vulnerable_state then
      elseif val == invulnerable_state then
      end
    end
  end)
end
function InvulnerableObjsContainer:PatchV2ToV3()
  print("InvulnerableObjsContainer:PatchV2ToV3")
  local data = self.data
  local success = true
  if data then
    local passed = {}
    MapForEach("map", "CObject", function(obj)
      local id = self:GetIdForObj(obj)
      if data[id] then
        passed[id] = true
        local val = data[id]
        if val == prop_state then
          obj:SetIsProp(true)
        elseif val == vulnerable_state then
          obj:SetIsForcedVulnerable(true)
        elseif val == invulnerable_state then
          obj:SetIsForcedInvulnerable(true)
        end
      end
    end)
    local missing = 0
    for id, _ in pairs(data) do
      if not passed[id] then
        data[id] = nil
        missing = missing + 1
      end
    end
    if 0 < missing then
      print("Missing objects!!!!!!!!!!", missing)
      success = false
    end
  end
  print("Done!")
  self.version = 3
  if success then
    Msg("DoneV3")
  end
end
function ResaveForV3()
  CreateRealTimeThread(function()
    local maps = {}
    ResaveAllMaps(nil, function()
      if not InvObjsContainerInstance then
        return "no save"
      end
      maps[GetMapName()] = true
    end)
  end)
end
function TestResaveForV3()
  ResaveAllMaps(nil, function()
    if not InvObjsContainerInstance then
      return "no save"
    end
    InvObjsContainerInstance:TestV3()
    DoneObject(InvObjsContainerInstance)
  end)
end
function InvulnerableObjsContainer:GameInit()
  InvObjsContainerInstance = self
end
function InvulnerableObjsContainer:Done()
  InvObjsContainerInstance = false
end
function InvulnerableObjsContainer:GetIdForObj(obj)
  local h = rawget(obj, "handle")
  return h and h or GetVisualStateHashForDestroyedObj(obj)
end
function InvulnerableObjsContainer:GetStateForObj(obj)
  local data = self.data
  if not data then
    return nil
  end
  return data[self:GetIdForObj(obj)]
end
function InvulnerableObjsContainer:IsProp(obj)
  return self:GetStateForObj(obj) == prop_state
end
function InvulnerableObjsContainer:IsVulnerable(obj)
  local state = self:GetStateForObj(obj)
  return state == vulnerable_state or state == prop_state
end
function InvulnerableObjsContainer:IsInvulnerable(obj)
  return self:GetStateForObj(obj) == invulnerable_state
end
function InvulnerableObjsContainer:GetData(create)
  if not self.data and create then
    self.data = {}
  end
  return self.data
end
function InvulnerableObjsContainer:_MarkObj(obj, val, mark)
  local data = self:GetData(val)
  if not data then
    return
  end
  data[self:GetIdForObj(obj)] = val and mark or nil
  if not val then
    Notify(self, "CheckIfEmptyAndDel")
  end
end
function InvulnerableObjsContainer:MarkObjVulnerable(obj, val)
  self:_MarkObj(obj, val, vulnerable_state)
end
function InvulnerableObjsContainer:MarkObjInvulnerable(obj, val)
  self:_MarkObj(obj, val, invulnerable_state)
end
function InvulnerableObjsContainer:MarkObjProp(obj, val)
  self:_MarkObj(obj, val, prop_state)
end
function InvulnerableObjsContainer:CheckIfEmptyAndDel()
  if self.data and not next(self.data) then
    self.data = false
  end
  if not self.data then
    DoneObject(self)
  end
end
function InvulnerableObjsContainer:DataCleanup()
  local data = self.data
  if not data then
    return
  end
  local passed = {}
  MapForEach("map", "CObject", function(o)
    local id = self:GetIdForObj(o)
    if data[id] then
      passed[id] = true
    end
  end)
  local missing = 0
  for id, _ in pairs(data) do
    if not passed[id] then
      data[id] = nil
      missing = missing + 1
    end
  end
  if 0 < missing then
    StoreErrorSource(false, string.format("InvulnerableObjsContainer found %d missing hooks. If invulnerable/vulnerable CObjs were moved/rotated/scaled they are no longer invulnerable!", missing))
    self:CheckIfEmptyAndDel()
  end
end
table.insert(CObject.properties, {
  category = "Destruction",
  id = "MarkInvulnerable",
  name = "Force Invulnerable",
  editor = "bool",
  default = false,
  dont_save = true
})
table.insert(CObject.properties, {
  category = "Destruction",
  id = "MarkVulnerable",
  name = "Force Vulnerable",
  editor = "bool",
  default = false,
  dont_save = true
})
table.insert(CObject.properties, {
  category = "Destruction",
  id = "MarkProp",
  name = "Force Prop",
  editor = "bool",
  default = false,
  dont_save = true,
  read_only = function(self)
    return self:IsPropMaterial()
  end,
  help = "Disabled when obj has a prop material already set."
})
table.insert(StripCObjectProperties.properties, {
  id = "MarkInvulnerable"
})
table.insert(StripCObjectProperties.properties, {
  id = "MarkVulnerable"
})
table.insert(StripCObjectProperties.properties, {id = "MarkProp"})
table.insert(Slab.properties, {
  id = "MarkInvulnerable"
})
table.insert(Slab.properties, {
  id = "MarkVulnerable"
})
table.insert(Slab.properties, {id = "MarkProp"})
function CObject:GetMarkProp(val)
  return IsObjPropDueToLDMark(self)
end
function CObject:SetMarkProp(val)
  self:SetIsProp(val)
  SetupObjInvulnerabilityColorMarkingOnValueChanged(self)
end
function CObject:SetMarkVulnerable(val)
  self:SetIsForcedVulnerable(val)
  SetupObjInvulnerabilityColorMarkingOnValueChanged(self)
end
function CObject:SetMarkInvulnerable(val)
  self:SetIsForcedInvulnerable(val)
  SetupObjInvulnerabilityColorMarkingOnValueChanged(self)
end
function CObject:GetMarkVulnerable()
  return IsObjVulnerableDueToLDMark(self)
end
function CObject:GetMarkInvulnerable()
  return IsObjInvulnerableDueToLDMark(self)
end
function GetInvObjsContainerInstance()
  if not InvObjsContainerInstance then
    InvObjsContainerInstance = PlaceObject("InvulnerableObjsContainer", {version = InvulnerableObjsContainer_Version})
  end
  return InvObjsContainerInstance
end
function IsObjInvulnerableDueToLDMark(obj)
  return obj:IsForcedInvulnerable()
end
function IsObjVulnerableDueToLDMark(obj)
  return obj:IsForcedVulnerable()
end
function IsObjPropDueToLDMark(obj)
  return obj:IsProp()
end
function EditorMarkSelectedObjsAsInvulnerable(val)
  local sel = editor.GetSel()
  for i, o in ipairs(sel) do
    o:SetIsForcedInvulnerable(val)
    SetupObjInvulnerabilityColorMarkingOnValueChanged(o)
  end
end
function EditorMarkSelectedObjsAsVulnerable(val)
  local sel = editor.GetSel()
  for i, o in ipairs(sel) do
    o:SetIsForcedVulnerable(val)
    SetupObjInvulnerabilityColorMarkingOnValueChanged(o)
  end
end
local default = 0
local vulnerable = 1
local prop = 2
local invulnerable = 3
local flag1 = const.gofGameSpecific2
local flag2 = const.gofGameSpecific3
local GetObjMask = function(obj, f1, f2)
  f1 = f1 or obj:GetGameFlags(flag1)
  f2 = f2 or obj:GetGameFlags(flag2)
  return bor(f1 ~= 0 and 1 or 0, shift(f2 ~= 0 and 1 or 0, 1))
end
local SetObjMask = function(obj, mask)
  if mask & 1 ~= 0 then
    obj:SetGameFlags(flag1)
  else
    obj:ClearGameFlags(flag1)
  end
  if mask & 2 ~= 0 then
    obj:SetGameFlags(flag2)
  else
    obj:ClearGameFlags(flag2)
  end
end
AppendClass.CObject = {
  properties = {
    {
      id = "DestructionOverrideMask",
      editor = "number",
      default = function(obj)
        local cls = obj.class
        return GetObjMask(obj, GetClassGameFlags(cls, flag1), GetClassGameFlags(cls, flag2))
      end
    }
  }
}
function CObject:GetDestructionOverrideMask()
  return GetObjMask(self)
end
function CObject:SetDestructionOverrideMask(val)
  SetObjMask(self, val)
end
function CObject:SetIsProp(val)
  SetObjMask(self, val and prop or default)
end
function CObject:IsProp()
  local v = GetObjMask(self)
  return v == prop
end
function CObject:SetIsForcedVulnerable(val)
  SetObjMask(self, val and vulnerable or default)
end
function CObject:IsForcedVulnerable()
  local v = GetObjMask(self)
  return v == vulnerable or v == prop
end
function CObject:SetIsForcedInvulnerable(val)
  SetObjMask(self, val and invulnerable or default)
end
function CObject:IsForcedInvulnerable()
  local v = GetObjMask(self)
  return v == invulnerable
end
function RepairAll()
  SuspendPassEdits("RepairAll")
  MapForEach("map", "Destroyable", function(o)
    o:Repair()
  end)
  if not next(Destruction_DestroyedCObjects) and not next(Destruction_DestroyedObjects) then
    return
  end
  local total = #Destruction_DestroyedObjects + #Destruction_DestroyedCObjects
  local count = 0
  MapForEach("map", "CObject", function(o, IsGenericObjDestroyed, total)
    if IsGenericObjDestroyed(o) then
      local h = rawget(o, "handle")
      if h then
        Destruction_DestroyedObjects[h] = nil
        table.remove_entry(Destruction_DestroyedObjects, h)
      else
        h = GetVisualStateHashForDestroyedObj(o)
        Destruction_DestroyedCObjects[h] = nil
        table.remove_entry(Destruction_DestroyedCObjects, h)
      end
      o:SetupDestroyedState(false)
      count = count + 1
      if total <= count then
        return "break"
      end
    end
  end, IsGenericObjDestroyed, total)
  ResumePassEdits("RepairAll")
end
function DestroyableSlab:ShouldUseReplaceEntDestruction()
  if not IsEditorActive() or dbgForceUseDamaged then
    local svd = self:GetMaterialPreset()
    if svd.use_damaged then
      return true
    elseif svd.use_damaged_first_floor then
      local r = self.room
      if not r then
        return self.floor == 1
      else
        local meta = VolumeBuildingsMeta
        return meta and self.floor == meta[r.building].firstFloorWithFloor
      end
    end
  end
end
function dbgSetWoodScaffVulnerable()
  local didWork = false
  MapForEach("map", "FloorSlab", function(o)
    if not o.room and o.material == "WoodScaff" and not o.forceInvulnerableBecauseOfGameRules then
      didWork = true
      o.forceInvulnerableBecauseOfGameRules = true
      o.invulnerable = true
    end
  end)
  return didWork
end
function dbgSetWoodScaffVulnerableAllMaps()
  CreateRealTimeThread(function()
    ForEachMap(ListMaps(), function()
      if dbgSetWoodScaffVulnerable() then
        SaveMap("no backup")
        print("saved", GetMapName())
      end
    end)
  end)
end
function SetupDestroyableWallDecorationManagedBySlab()
  MapForEach("map", "DestroyableWallDecoration", function(o)
    o.managed_by_slab = false
  end)
  MapForEach("map", "WallSlab", "SlabWallObject", "RoomCorner", const.efVisible, function(o)
    if o:GetEntity() == "InvisibleObject" then
      return
    end
    local decs = o:GetDecorations()
    for i = 1, #(decs or "") do
      local dec = decs[i]
      if IsKindOf(dec, "DestroyableWallDecoration") then
        if dec.handle == 1875741007 then
          print(o.handle, o.class)
          DbgAddVector(o:GetPos())
        end
        dec.managed_by_slab = true
      end
    end
  end)
end
function OnMsg.PreSaveMap()
  SetupDestroyableWallDecorationManagedBySlab()
end
function DestroyableWallDecoration:Destroy()
  if self.managed_by_slab then
    return
  end
  if self.is_destroyed then
    return
  end
  Destroyable.Destroy(self)
  CObject.Destroy(self)
end
AutoResolveMethods.OnDestroy = "call"
AppendClass.Object = {
  properties = {
    {
      id = "AssociatedLights",
      editor = "objects",
      default = false,
      name = "Associated Lights",
      help = "Objects in this list will get destroyed when this object is destroyed.",
      category = "Destruction"
    }
  }
}
function Destroyable:OnDestroy()
  KillAssociatedLights(self)
end
function KillAssociatedLights(o)
  local t = o:HasMember("AssociatedLights") and o.AssociatedLights or false
  for i, l in ipairs(t or empty_table) do
    if ShouldDestroyObject(l) then
      KillObj(l)
    end
  end
end
function AssociateLights()
  local sel = editor.GetSel()
  local objs = {}
  local lights = {}
  for i, o in ipairs(sel or empty_table) do
    if IsKindOf(o, "Light") then
      table.insert(lights, o)
    else
      table.insert(objs, o)
    end
  end
  if #lights <= 0 then
    lights = false
  end
  for i, o in ipairs(objs) do
    o.AssociatedLights = lights
  end
  printf("%d lights associated with %d objects.", #(lights or ""), #objs)
end
function OnMsg.PreSaveMap()
  MapForEach("map", "Object", function(o)
    local t = o.AssociatedLights
    if t then
      for i = #t, 1, -1 do
        if not IsValid(t[i]) then
          table.remove(t, i)
        end
      end
      if #t <= 0 then
        o.AssociatedLights = false
      end
    end
  end)
end
ShouldShowAssociateLightsShortcut = return_true
