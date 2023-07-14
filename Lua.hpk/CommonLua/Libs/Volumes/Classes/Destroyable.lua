ShouldShowAssociateLightsShortcut = empty_func
local voxelSizeX = const.SlabSizeX or 0
local voxelSizeY = const.SlabSizeY or 0
local voxelSizeZ = const.SlabSizeZ or 0
local halfVoxelSizeX = voxelSizeX / 2
local halfVoxelSizeY = voxelSizeY / 2
local halfVoxelSizeZ = voxelSizeZ / 2
local InvalidZ = const.InvalidZ
local noneWallMat = const.SlabNoMaterial
if FirstLoad then
  DestroyedSlabsThisTick = {}
  RepairedSlabsThisTick = {}
  DestroyedCOThisTick = {}
  DestroyedObjectsThisTick = {}
end
SlabNeighbourMask = {
  Top = 1,
  Bottom = 2,
  Left = 4,
  Right = 8,
  AllDestroyed = 15
}
local IsStructuralRow = function(r)
  return false
end
maskToOppositeMask = {
  [SlabNeighbourMask.Left] = SlabNeighbourMask.Right,
  [SlabNeighbourMask.Right] = SlabNeighbourMask.Left,
  [SlabNeighbourMask.Top] = SlabNeighbourMask.Bottom,
  [SlabNeighbourMask.Bottom] = SlabNeighbourMask.Top
}
local invertDiagEntMask = {
  [SlabNeighbourMask.Right | SlabNeighbourMask.Top] = SlabNeighbourMask.Left | SlabNeighbourMask.Bottom,
  [SlabNeighbourMask.Left | SlabNeighbourMask.Top] = SlabNeighbourMask.Right | SlabNeighbourMask.Bottom,
  [SlabNeighbourMask.Right | SlabNeighbourMask.Bottom] = SlabNeighbourMask.Left | SlabNeighbourMask.Top,
  [SlabNeighbourMask.Left | SlabNeighbourMask.Bottom] = SlabNeighbourMask.Right | SlabNeighbourMask.Top
}
local maskToCharWall = {
  [SlabNeighbourMask.Left] = "R",
  [SlabNeighbourMask.Right] = "R",
  [SlabNeighbourMask.Top] = "T",
  [SlabNeighbourMask.Bottom] = "B",
  [SlabNeighbourMask.Right | SlabNeighbourMask.Top] = "RT",
  [SlabNeighbourMask.Left | SlabNeighbourMask.Top] = "RT",
  [SlabNeighbourMask.Right | SlabNeighbourMask.Bottom] = "RB",
  [SlabNeighbourMask.Left | SlabNeighbourMask.Bottom] = "RB"
}
local maskToCharFloor = {
  [SlabNeighbourMask.Left] = "R",
  [SlabNeighbourMask.Right] = "R",
  [SlabNeighbourMask.Top] = "B",
  [SlabNeighbourMask.Bottom] = "B"
}
maskToString = {
  [SlabNeighbourMask.Left] = "Left",
  [SlabNeighbourMask.Right] = "Right",
  [SlabNeighbourMask.Top] = "Top",
  [SlabNeighbourMask.Bottom] = "Bottom"
}
local manageAttachsAttaches = function(self, a, sc, suffix, variant, index, m1, m2)
  variant = variant or self.variant
  if variant == "IndoorIndoor" then
    local atts = a:GetAttaches() or empty_table
    local a1 = atts[1] or PlaceObject("Object")
    local a2 = atts[2] or PlaceObject("Object")
    if self:GetGameFlags(const.gofPermanent) ~= 0 then
      a1:SetGameFlags(const.gofPermanent)
      a2:SetGameFlags(const.gofPermanent)
    end
    m2 = m2 or self.indoor_material_1
    m1 = m1 or self.indoor_material_2
    local e1 = self:ComposeBrokenDecInteriorAttachName(sc, suffix, m1, index)
    local e2 = self:ComposeBrokenDecInteriorAttachName(sc, suffix, m2, (index or 0) + 2659)
    if not IsValidEntity(e1) then
      self:ReportMissingBrokenDecInteriorAttach(e1)
    else
      a1:ChangeEntity(e1)
    end
    if not IsValidEntity(e2) then
      self:ReportMissingBrokenDecInteriorAttach(e2)
    else
      a2:ChangeEntity(e2)
    end
    a:Attach(a1)
    a1:SetAttachAngle(0)
    a1:SetMirrored(false)
    a:Attach(a2)
    a2:SetAttachAngle(10800)
    a2:SetMirrored(true)
  elseif variant == "OutdoorIndoor" then
    local atts = a:GetAttaches() or empty_table
    local a1 = atts[1] or PlaceObject("Object")
    for i = 2, #atts do
      DoneObject(atts[i])
    end
    if self:GetGameFlags(const.gofPermanent) ~= 0 then
      a1:SetGameFlags(const.gofPermanent)
    end
    m1 = m1 or self.indoor_material_1
    local e1 = self:ComposeBrokenDecInteriorAttachName(sc, suffix, m1, index)
    if not IsValidEntity(e1) then
      self:ReportMissingBrokenDecInteriorAttach(e1)
    else
      a1:ChangeEntity(e1)
    end
    a:Attach(a1)
    a1:SetAttachAngle(10800)
    a1:SetMirrored(true)
  else
    a:DestroyAttaches()
  end
end
function GetDestroyedSlabAttachId(sideFlag, offset)
  return xxhash(sideFlag, offset)
end
DefineClass("DestroyableFloorSlab", "Slab")
DefineClass.DestroyedSlabAttach = {
  __parents = {
    "Object",
    "EditorSubVariantObject"
  },
  flags = {gofPermanent = false},
  use_self_colors = false,
  index = false,
  parent = false,
  offset = false,
  angle = false
}
DestroyedAttachClass = "DestroyedSlabAttach"
function OnDestroyedAttachDeleted(o)
end
function DestroyedSlabAttach:Destroy()
  OnDestroyedAttachDeleted(self)
  DoneObject(self)
end
function DestroyedSlabAttach:GetId()
  return GetDestroyedSlabAttachId(self:GetSide(), self:GetParent() and self:GetAttachOffset() or self.offset)
end
function DestroyedSlabAttach:GetSide()
  local p = self:GetParent() or self.parent
  local da = p.destroyed_attaches
  if da.Top == self or table.find(da.Top, self) then
    return SlabNeighbourMask.Top
  elseif da.Bottom == self or table.find(da.Bottom, self) then
    return SlabNeighbourMask.Bottom
  elseif da.Right == self or table.find(da.Right, self) then
    return SlabNeighbourMask.Right
  else
    return SlabNeighbourMask.Left
  end
end
function DestroyedSlabAttach:ManageAttaches()
  local p = self:GetParent() or self.parent
  local sideFlag = self:GetSide()
  local sc = p:MaskToChar(maskToOppositeMask[sideFlag])
  local curE = self:GetEntity()
  local suffix = string.match(curE, "%d+$")
  local variant = p.variant
  if IsKindOf(p, "SlabWallObject") then
    local slabAtAttchPos = MapGetFirst(self, 0, "WallSlab", function(o)
      return o.invisible_reasons and not o.invisible_reasons.suppressed
    end)
    if slabAtAttchPos then
      variant = slabAtAttchPos.variant
    end
  end
  manageAttachsAttaches(p, self, sc, suffix, variant, self.index)
end
function DestroyedSlabAttach:CycleEntity(delta)
  if EditorSubVariantObject.CycleEntity(self, delta) then
    self:ManageAttaches()
    local p = self.parent or self:GetParent()
    local id = self:GetId()
    p.da_subvariants = p.da_subvariants or {}
    p.da_subvariants[id] = self.subvariant
  end
end
function Slab:ComposeBrokenDecInteriorAttachName(side, suffix, material, index)
  material = material or self.material
  local svd = (Presets.SlabPreset.SlabIndoorMaterials or empty_table)[material]
  local subvarId = string.format("broken_attach_attaches_%s_subvariants", string.lower(side))
  local subvariants, total = GetMaterialSubvariants(svd, subvarId)
  if subvariants and 0 < #subvariants then
    return GetRandomSubvariantEntity(self:GetSeed(total, 7001 + (index or 0)), subvariants, function(suffix, material, side)
      return string.format("WallInt_%s_Wall_BrokenDec_%s_%s", material, side, suffix)
    end, material, side)
  else
    return string.format("WallInt_%s_Wall_BrokenDec_%s_%s", material, side, suffix)
  end
end
function Slab:GetBrokenDecAttachesBaseString()
  return "broken_attaches_%s_subvariants"
end
local roofCompToDecSubvariantArr = {
  Eave = "broken_attaches_eave_%s_subvariants",
  Rake = "broken_attaches_rake_%s_subvariants",
  Ridge = "broken_attaches_ridge_%s_subvariants",
  Gable = "broken_attaches_gable_%s_subvariants"
}
function RoofSlab:GetBrokenDecAttachesBaseString()
  return roofCompToDecSubvariantArr[self.roof_comp] or Slab.GetBrokenDecAttachesBaseString()
end
function GetRandomSubvariantEntityAvoidSubvariant(random, subvariants, avoidSubvariant, get_ent_func, ...)
  if not avoidSubvariant then
    return GetRandomSubvariantEntity(random, subvariants, get_ent_func, ...)
  end
  local t = 0
  for i = 1, #subvariants do
    t = t + subvariants[i].chance
    if i == #subvariants or random < t then
      local suff = subvariants[i].suffix
      if suff == avoidSubvariant then
        if i < #subvariants then
          i = i + 1
        elseif 1 < i then
          i = i - 1
        end
      end
      local ret = get_ent_func(subvariants[i].suffix, ...)
      while 1 < i and not IsValidEntity(ret) do
        i = i - 1
        ret = (0 < subvariants[i].chance or i == 1) and get_ent_func(subvariants[i].suffix, ...) or false
      end
      return ret, subvariants[i].suffix
    end
  end
end
function Slab:ComposeBrokenDecName(side, seedConst, subvariant, avoidSubvariant)
  local svd = self:GetMaterialPreset()
  local str = self:GetBrokenDecAttachesBaseString()
  local subvarId = string.format(str, string.lower(side))
  local subvariants, total = GetMaterialSubvariants(svd, subvarId)
  local e = self:GetBaseEntityName()
  if not subvariant and subvariants and 0 < #subvariants then
    return GetRandomSubvariantEntityAvoidSubvariant(self:GetSeed(total, seedConst or 0), subvariants, avoidSubvariant, function(suffix, e, side)
      return string.format("%s_BrokenDec_%s_%s", e, side, suffix)
    end, e, side)
  elseif subvariant then
    local subvarStr = 10 <= subvariant and tostring(subvariant) or string.format("0%s", tostring(subvariant))
    return string.format("%s_BrokenDec_%s_%s", e, side, subvarStr), subvarStr
  else
    return string.format("%s_BrokenDec_%s_01", e, side), "01"
  end
end
function RoofPlaneSlab:ComposeBrokenDecName(side, ...)
  if side == "T" or side == "B" then
    local a = self:GetAngle() / 60
    if a == 180 or a == 270 then
      side = side == "T" and "B" or "T"
    end
  end
  return Slab.ComposeBrokenDecName(self, side, ...)
end
function RoofPlaneSlab:ComposeBrokenEntityName(side)
  if side == "T" or side == "B" then
    local a = self:GetAngle() / 60
    if a == 180 or a == 270 then
      side = side == "T" and "B" or "T"
    end
  end
  return Slab.ComposeBrokenEntityName(self, side)
end
function SlabWallObject:ComposeBrokenDecName(side, nbrvar, count, subvariant, material)
  local material_list = Presets.SlabPreset.SlabMaterials
  material = material or self.material
  local svd = material_list and material_list[material]
  local subvarId = string.format("broken_attaches_%s_subvariants", string.lower(side))
  local subvariants, total = GetMaterialSubvariants(svd, subvarId)
  local e = string.format("WallExt_%s_Wall_%s", material, variantToVariantName[nbrvar])
  if not subvariant and subvariants and 0 < #subvariants then
    return GetRandomSubvariantEntity(self:GetSeed(total, count), subvariants, function(suffix, e, side)
      return string.format("%s_BrokenDec_%s_%s", e, side, suffix)
    end, e, side)
  elseif subvariant then
    local subvarStr = 10 <= subvariant and tostring(subvariant) or string.format("0%s", tostring(subvariant))
    return string.format("%s_BrokenDec_%s_%s", e, side, subvarStr), subvarStr
  else
    return string.format("%s_BrokenDec_%s_01", e, side), "01"
  end
end
function Slab:ComposeBrokenEntityName(side)
  local svd = self:GetMaterialPreset()
  local subvarId = string.format("broken_%s_subvariants", string.lower(side))
  local subvariants, total = GetMaterialSubvariants(svd, subvarId)
  local e = self:GetBaseEntityName()
  if subvariants and 0 < #subvariants then
    if self.subvariant ~= -1 then
      local digitStr = self:GetSubvariantDigitStr(subvariants)
      return string.format("%s_Broken_%s_%s", e, side, digitStr)
    else
      return GetRandomSubvariantEntity(self:GetSeed(total), subvariants, function(suffix, e, side)
        return string.format("%s_Broken_%s_%s", e, side, suffix)
      end, e, side)
    end
  else
    local digitStr = self:GetSubvariantDigitStr()
    return string.format("%s_Broken_%s_%s", e, side, digitStr)
  end
end
function Slab:ComposeDamagedEntityName()
  local svd = self:GetMaterialPreset()
  local subvariants, total = GetMaterialSubvariants(svd, "damaged_subvariants")
  local e = self:GetBaseEntityName()
  if subvariants and 0 < #subvariants then
    if self.subvariant ~= -1 then
      local digitStr = self:GetSubvariantDigitStr(subvariants)
      return string.format("%s_Damaged_%s", e, digitStr)
    else
      return GetRandomSubvariantEntity(self:GetSeed(total), subvariants, function(suffix, e)
        return string.format("%s_Damaged_%s", e, suffix)
      end, e)
    end
  else
    local digitStr = self:GetSubvariantDigitStr()
    return string.format("%s_Damaged_%s", e, digitStr)
  end
end
function Slab:ComposeBrokenIndoorMaterialEntityName(mat)
  local svd = (Presets.SlabPreset.SlabIndoorMaterials or empty_table)[mat]
  local side = maskToCharWall[self.diagonal_ent_mask ~= 0 and invertDiagEntMask[self.diagonal_ent_mask] or self.destroyed_entity_side]
  local subvarId = string.format("broken_%s_subvariants", string.lower(side))
  local subvariants, total = GetMaterialSubvariants(svd, subvarId)
  if subvariants and 0 < #subvariants then
    return GetRandomSubvariantEntity(self:GetSeed(total), subvariants, function(suffix, mat, side)
      return string.format("WallInt_%s_Wall_Broken_%s_%s", mat, side, suffix)
    end, mat, side)
  else
    return string.format("WallInt_%s_Wall_Broken_%s_01", mat, side)
  end
end
function Slab:MaskToChar(m)
  return maskToCharWall[m]
end
function DestroyableFloorSlab:MaskToChar(m)
  return maskToCharFloor[m]
end
local maskToCharRake = {
  [SlabNeighbourMask.Left] = "B",
  [SlabNeighbourMask.Right] = "T"
}
function RoofEdgeSlab:MaskToChar(m)
  if self.roof_comp == "Rake" then
    return maskToCharRake[m]
  end
  return maskToCharWall[m]
end
function Slab:ShouldAddAttachOnNoNbr(sideFlag)
  return false
end
function Slab:IsRoofPlane()
  return false
end
function RoofPlaneSlab:IsRoofPlane()
  return true
end
function Slab:UpdateDestroyedState()
  if not self.use_replace_ent_destruction then
    return self:UpdateDestroyedStateInternal()
  else
    return self:UpdateDestroyedStateInternal_ReplaceEntity()
  end
end
function Slab:UpdateDestroyedStateInternal_ReplaceEntity()
  local e = self:ComposeDamagedEntityName()
  if IsValidEntity(e) then
    if e ~= self:GetEntity() then
      self.destroyed_entity_side = 0
      self.destroyed_entity = false
      self.diagonal_ent_mask = 0
      self:ChangeEntity(e)
      self:SetEnumFlags(const.efCollision + const.efApplyToGrids)
      self:ResetVisibilityFlags()
      collision.SetAllowedMask(self, self.collision_mask or 0)
    end
  else
    self:ReportMissingDamagedEntity(e)
  end
  return true
end
function WallSlab:ShouldAddAttachOnNoNbr(sideFlag, isStructuralRow, osf)
  osf = osf or maskToOppositeMask[sideFlag]
  local cnbr = self:GetNeighbourCorner(sideFlag)
  if not cnbr or cnbr.is_destroyed then
    local x, y, z = self:GetPosXYZ()
    local nbr = self:GetNeighbour(sideFlag, nil, 0)
    if not nbr or not nbr.wall_obj then
      return false
    end
  end
  return true
end
function DestroyableFloorSlab:ShouldAddAttachOnNoNbr(sideFlag)
  return self:IsStructuralRow(sideFlag)
end
function ShouldFlipSideFlag(sideFlag, nbr, myAngle, me)
  return sideFlag & 12 == 0 or nbr:GetAngle() == myAngle or IsKindOfClasses(nbr, "DestroyableFloorSlab", "RoomCorner") or me and IsKindOf(me, "RoomCorner")
end
function GetNeigbhourSideFlagTowardMe(sideFlag, nbr, self)
  local a = self:GetAngle()
  if self:IsRoofPlane() then
    local ha = nbr:GetAngle()
    if abs(a - ha) / 60 % 180 == 90 then
      return 0
    end
  end
  return ShouldFlipSideFlag(sideFlag, nbr, a, self) and maskToOppositeMask[sideFlag] or sideFlag
end
local sideToSeedConst = {
  [SlabNeighbourMask.Left] = 0,
  [SlabNeighbourMask.Right] = 181,
  [SlabNeighbourMask.Top] = 0,
  [SlabNeighbourMask.Bottom] = 83
}
local processSideHelper = function(self, da, sideFlag, mask)
  local ss = maskToString[sideFlag]
  local osf = maskToOppositeMask[sideFlag]
  local hasDestroyedNbr = mask & sideFlag == sideFlag
  local a = self:GetAngle()
  if self.is_destroyed then
    local isStructuralRow = self:IsStructuralRow(sideFlag)
    if not hasDestroyedNbr or isStructuralRow then
      local attId = GetDestroyedSlabAttachId(sideFlag, point30)
      local forcedSubvariant = self.da_subvariants and self.da_subvariants[attId] or false
      local addAttch = forcedSubvariant ~= 0
      local nbrs = self:GetNeighbour(sideFlag, "all")
      local firstNbr = IsValid(nbrs) and nbrs or type(nbrs) == "table" and nbrs[1]
      if addAttch then
        if not IsValid(firstNbr) then
          addAttch = self:ShouldAddAttachOnNoNbr(sideFlag, isStructuralRow, osf)
        else
          local isRoofPlane = self:IsRoofPlane()
          local processNbr = function(nbr)
            local ha = nbr:GetAngle()
            if not (hasDestroyedNbr or nbr.use_replace_ent_destruction) and ((a == ha or sideFlag < 4) and nbr.destroyed_entity_side & osf == osf or a ~= ha and 4 <= sideFlag and nbr.destroyed_entity_side & sideFlag == sideFlag) or isRoofPlane and #nbrs == 1 and abs(a - ha) / 60 % 180 ~= 0 then
              addAttch = false
            end
          end
          if IsValid(nbrs) then
            processNbr(nbrs)
          elseif type(nbrs) == "table" then
            for i = 1, #nbrs do
              processNbr(nbrs[i])
              if not addAttch then
                goto lbl_100
              end
            end
          end
        end
      end
      ::lbl_100::
      if addAttch then
        local sc = self:MaskToChar(osf)
        local avoidSubviariant
        if not forcedSubvariant and sideFlag == SlabNeighbourMask.Right then
          local ssc = maskToString[osf]
          if da[ssc] then
            local ose = da[ssc]:GetEntity()
            avoidSubviariant = string.match(ose, "%d+$")
          end
        end
        local e, suffix = self:ComposeBrokenDecName(sc, sideToSeedConst[sideFlag], forcedSubvariant, avoidSubviariant)
        if not da[ss] then
          local a = PlaceObject(DestroyedAttachClass)
          if self:GetGameFlags(const.gofPermanent) ~= 0 then
            a:SetGameFlags(const.gofPermanent)
          end
          if not IsValidEntity(e) then
            self:ReportMissingBrokenDec(e)
            a:ChangeEntity("InvisibleObject", "idle")
          else
            a:ChangeEntity(e)
          end
          da[ss] = a
        elseif e and e ~= da[ss]:GetEntity() then
          if not IsValidEntity(e) then
            self:ReportMissingBrokenDec(e)
            da[ss]:ChangeEntity("InvisibleObject", "idle")
          else
            da[ss]:ChangeEntity(e)
          end
        end
        local a = da[ss]
        collision.SetAllowedMask(a, 0)
        manageAttachsAttaches(self, a, sc, suffix)
      elseif da[ss] then
        DoneObject(da[ss])
        da[ss] = false
      end
    elseif not isStructuralRow then
      DoneObject(da[ss])
      da[ss] = false
      local nbr = self:GetNeighbour(sideFlag)
      if IsValid(nbr) then
        if sideFlag & 12 == 0 or nbr:GetAngle() == a then
          nbr:DestroyDestroyedAttach(osf, self)
        else
          nbr:DestroyDestroyedAttach(sideFlag, self)
        end
      end
    end
  else
    local nbr
    local destroyedNbrSideIsFree = true
    if hasDestroyedNbr then
      nbr = self:GetNeighbour(sideFlag)
      if IsValid(nbr) then
        if IsKindOf(nbr, "SlabWallObject") then
          local _, state = nbr:GetDestroyedEntityAndState()
          destroyedNbrSideIsFree = not state:starts_with("broken") and (sideFlag ~= 1 or self.force_destroyed_entity == sideFlag)
        else
          destroyedNbrSideIsFree = nbr.diagonal_ent_mask & osf == 0
        end
      end
    end
    if hasDestroyedNbr and not self.destroyed_entity then
      if self.force_no_destroyed_entity then
        return
      end
      local random = -1
      local isStackable = self.class == "RoofWallSlab"
      local stack
      if self.force_destroyed_entity then
        if self.force_destroyed_entity == sideFlag then
          random = 100
        else
          random = 0
        end
      elseif isStackable then
        stack = MapGet(self, 0, self.class, nil, const.efVisible)
        for _, obj in ipairs(stack) do
          random = Max(obj:GetSeed(100, 102317), random)
        end
      else
        random = self:GetSeed(100, 102317)
      end
      if destroyedNbrSideIsFree and 50 <= random then
        if IsValid(nbr) then
          if ShouldFlipSideFlag(sideFlag, nbr, a) then
            nbr:DestroyDestroyedAttach(osf, self)
          else
            nbr:DestroyDestroyedAttach(sideFlag, self)
          end
        else
        end
        local sc = self:MaskToChar(sideFlag)
        self:UnlockSubvariantReversible()
        self.destroyed_entity = self:ComposeBrokenEntityName(sc)
        if not IsValidEntity(self.destroyed_entity) then
          self:ReportMissingBrokenEntity(self.destroyed_entity)
          self.destroyed_entity = nil
          return
        end
        self.destroyed_entity_side = sideFlag
        for i = 1, #(stack or "") do
          if stack[i] ~= self then
            stack[i].destroyed_entity_side = sideFlag & 12 ~= 0 and a ~= stack[i]:GetAngle() and osf or sideFlag
            stack[i].destroyed_entity = self.destroyed_entity
            stack[i]:UnlockSubvariantReversible()
          end
        end
        if IsValid(nbr) then
          nbr:UpdateDecorationsDestroyedState()
        end
      end
    elseif not hasDestroyedNbr and self.destroyed_entity_side & sideFlag == sideFlag then
      self.destroyed_entity_side = 0
      self.destroyed_entity = false
      self:RestorePreDestructionSubvariant()
    elseif hasDestroyedNbr and self.destroyed_entity_side & sideFlag == sideFlag then
      if destroyedNbrSideIsFree then
        local sc = self:MaskToChar(sideFlag)
        self.destroyed_entity = self:ComposeBrokenEntityName(sc)
        if not IsValidEntity(self.destroyed_entity) then
          self:ReportMissingBrokenEntity(self.destroyed_entity)
          self.destroyed_entity = nil
          return
        end
      else
        self.destroyed_entity_side = 0
        self.destroyed_entity = false
        self:RestorePreDestructionSubvariant()
      end
    end
  end
end
function Slab:ForEachStackedVisible(func, ...)
  MapForEach(self, 0, self.class, nil, const.efVisible, function(o, func, ...)
    func(o, ...)
  end, func, ...)
end
function Slab:ForEachNeighbour(sideFlag, func, ...)
  local nbrs = self:GetNeighbour(sideFlag, "all")
  if IsValid(nbrs) then
    func(nbrs, ...)
  else
    for i = 1, #(nbrs or "") do
      func(nbrs[i], ...)
    end
  end
end
function Slab:SetDestroyedEntityAndFlags()
  self.destroyed_entity_side = 0
  self.destroyed_entity = false
  self.diagonal_ent_mask = 0
  if self:GetEntity() ~= "InvisibleObject" then
    self:ChangeEntity("InvisibleObject", "idle")
    self.entity = "InvisibleObject"
  end
  self:ClearEnumFlags(const.efCollision + const.efApplyToGrids)
end
function SlabWallObject:SetDestroyedEntityAndFlags()
  local e = self:GetEntity()
  local ne, state = self:GetDestroyedEntityAndState()
  if e and e ~= "" and e ~= "InvisibleObject" and e ~= self.class then
    print("once", "SlabWallObject non destroyed ent unrecoverable. Ent - " .. e .. " Cls - " .. self.class)
  end
  self.destroyed_entity_side = 0
  self.destroyed_entity = false
  self.diagonal_ent_mask = 0
  if self:GetEntity() ~= ne or self:GetStateText() ~= state then
    if ne == "InvisibleObject" then
      self:DestroyAttaches("ParSystem", "SpotLight")
    end
    self:ChangeEntity(ne, state)
    self:SetState(state)
  end
  self:ClearEnumFlags(const.efCollision + const.efApplyToGrids)
  if self.is_destroyed and self:HasMember("pass_through_state") then
    self.pass_through_state = "broken"
  end
end
function RoofEdgeSlab:UpdateDestroyedStateInternal()
  local mask = self.destroyed_neighbours
  self.destroyed_attaches = self.destroyed_attaches or {
    Top = false,
    Bottom = false,
    Left = false,
    Right = false
  }
  local da = self.destroyed_attaches
  local isDestroyed = self.is_destroyed
  if isDestroyed then
    self:SetDestroyedEntityAndFlags()
  else
    return false
  end
  for i = 2, 3 do
    processSideHelper(self, da, 1 << i, mask)
  end
  local isMirrored = self:GetMirrored()
  local rc = self.roof_comp
  if da.Right then
    local ml = isMirrored
    if rc == "Gable" or rc == "Eave" then
      ml = not ml
    end
    da.Right:SetMirrored(ml)
    self:Attach(da.Right)
  end
  if da.Left then
    local ml = isMirrored
    if rc == "Ridge" then
      ml = not ml
    end
    da.Left:SetMirrored(ml)
    self:Attach(da.Left)
  end
  self:RefreshColors()
  self:SetWarped(self:GetWarped())
  return true
end
function SlabWallObject:GetOffset(row)
  return row - self.width / 2 - (self.width % 2 == 0 and 0 or 1)
end
function SlabWallObject:GetLeftOffset()
  return self:GetOffset(1)
end
function SlabWallObject:GetRightOffset()
  return self:GetOffset(self.width)
end
local SlabWallObjectBrokenDecAttachMaterials = {Colonial = true}
local SlabWallObjectBrokenDecExceptionEnts = {
  TallDoor_Colonial_Double_02 = true,
  Window_Colonial_Single_01 = true,
  WindowBig_Colonial_Single_03 = true,
  WindowBig_Colonial_Single_04 = true,
  WindowBig_Colonial_Single_05 = true,
  WindowBig_Colonial_Double_02 = true
}
function SlabWallObject:ForEachNeighbourOnAllSidesAndAroundCorners(func, ...)
  local iterate = function(nbrs, func, ...)
    for j = 1, #(nbrs or "") do
      if func(nbrs[j], ...) == "break" then
        return true
      end
    end
  end
  for i = 0, 3 do
    local sf = 1 << i
    local nbrs = self:GetNeighbour(sf)
    if iterate(nbrs, func, ...) then
      return
    end
    if 2 <= i then
      nbrs = self:GetNeighboursAroundCorner(sf)
      if iterate(nbrs, func, ...) then
        return
      end
    else
      nbrs = self:GetNeighbourFloor(sf)
      if iterate(nbrs, func, ...) then
        return
      end
    end
  end
end
function SlabWallObject:HasLiveNeighbour()
  local ret = false
  self:ForEachNeighbourOnAllSidesAndAroundCorners(function(nbr)
    if not nbr.is_destroyed then
      ret = true
      return "break"
    end
  end)
  return ret
end
function SlabWallObject:HasLiveNeighbourBelow()
  local nbrs = self:GetNeighbour(SlabNeighbourMask.Bottom)
  for i = 1, #(nbrs or "") do
    if not nbrs[i].is_destroyed then
      return true
    end
  end
  return false
end
function SlabWallObject:HasLivingNeighbourOnTwoSidesOrBelow()
  local left, right, top, bot = self:GetNeighbours()
  local count = 0
  local test = function(arr)
    for i = 1, #(arr or "") do
      if not arr[i].is_destroyed then
        return true
      end
    end
  end
  if test(bot) then
    return true
  end
  if test(top) then
    count = count + 1
  end
  if test(left) then
    count = count + 1
  end
  if 2 <= count then
    return true
  end
  if test(right) then
    count = count + 1
  end
  return 2 <= count
end
function ComputeBrokenStateForObj(obj)
  return "broken"
end
function SlabWallObject:GetDestroyedEntityAndState()
  if not self:ShouldHaveBrokenDecAttaches() and self:HasState("broken") and (self.width > 0 and self:HasLivingNeighbourOnTwoSidesOrBelow() or self.width == 0 and self:HasLiveNeighbourBelow()) then
    local state = ComputeBrokenStateForObj(self)
    return self:GetEntity(), state
  end
  return "InvisibleObject", "idle"
end
function SlabWallObject:ShouldHaveBrokenDecAttaches()
  if not SlabWallObjectBrokenDecAttachMaterials[self.material] then
    return false
  end
  local notDestroyedEnt = self.class
  if SlabWallObjectBrokenDecExceptionEnts[notDestroyedEnt] then
    return false
  end
  return true
end
local DecSetDestroyedEnt = function(dec, e, de, destroyed_by)
  if e ~= "InvisibleObject" then
    if not rawget(dec, "orig_decoration_ent") then
      rawset(dec, "orig_decoration_ent", e)
    end
    if destroyed_by and not rawget(dec, "destroyed_by") then
      rawset(dec, "destroyed_by", destroyed_by)
    end
    de = de or "InvisibleObject"
    if not IsValidEntity(de) then
      print("once", "Failed to find entity for broken decoration: " .. de)
    else
      dec:ChangeEntity(de)
    end
  end
end
local DecRestoreOrigEnt = function(dec, e, repaired_by)
  local destroyed_by = rawget(dec, "destroyed_by")
  if destroyed_by ~= nil and repaired_by ~= destroyed_by then
    return
  end
  local oe = rawget(dec, "orig_decoration_ent")
  if oe ~= e then
    dec:ChangeEntity(oe)
    rawset(dec, "orig_decoration_ent", nil)
  end
end
function SlabWallObject:UpdateDestroyedStateInternal()
  local isDestroyed = self.is_destroyed
  if isDestroyed then
    self:SetDestroyedEntityAndFlags()
  else
    return false
  end
  self.destroyed_attaches = self.destroyed_attaches or {
    Top = {},
    Bottom = {},
    Left = {},
    Right = {}
  }
  local da = self.destroyed_attaches
  local left, right, top, bottom = self:GetNeighbours()
  local count = 0
  local h = self.height
  local leftOffset = self:GetLeftOffset()
  local rightOffset = self:GetRightOffset()
  local ma = self:GetAngle()
  local mp = self:GetPos()
  local side = self.side or slabAngleToDir[ma]
  local isFlipped = side ~= slabAngleToDir[ma]
  local flippedMultiplier = isFlipped and 1 or -1
  local addAttchObj = function(arr)
    count = count + 1
    local o = IsValid(arr[count]) and arr[count] or PlaceObject(DestroyedAttachClass)
    if rawget(o, "use_self_colors") then
      table.insert(arr, count, PlaceObject(DestroyedAttachClass))
      o = arr[count]
    end
    if self:GetGameFlags(const.gofPermanent) ~= 0 then
      o:SetGameFlags(const.gofPermanent)
    end
    arr[count] = o
    o.index = count
    return o
  end
  local prepAttach = function(arr, sc, variant, sideString, subvariant, material)
    local o = addAttchObj(arr)
    local e, suffix = self:ComposeBrokenDecName(sc, variant, count, subvariant, material)
    if not IsValidEntity(e) then
      self:ReportMissingBrokenDec(e)
    else
      o:ChangeEntity(e)
    end
    collision.SetAllowedMask(o, 0)
    self:Attach(o)
    if sideString == "Right" then
      o:SetMirrored(true)
    else
      o:SetMirrored(false)
    end
    return o, suffix
  end
  local prepArgs = function(variant, mat, slabAtAttchPos)
    local m1, m2
    if slabAtAttchPos then
      variant = slabAtAttchPos.variant
      mat = slabAtAttchPos.material
      m1 = variant == "IndoorIndoor" and slabAtAttchPos.indoor_material_2 or slabAtAttchPos.indoor_material_1
      m2 = slabAtAttchPos.indoor_material_1
    else
      m1 = self.material
    end
    return variant, mat, m1, m2
  end
  local function processNbr(nbr, sideFlag, sideString)
    if IsValid(nbr) then
      local isLeftOrRight = sideFlag & 12 ~= 0
      if IsKindOf(nbr, "SlabWallObject") then
        if not nbr.is_destroyed or isLeftOrRight and self:IsStructuralRow(sideFlag) then
          local c, oz, zs, oy, ys
          if isLeftOrRight then
            local hp = nbr:GetPos()
            local zd = Max(hp:z() - mp:z(), 0)
            local minz = mp:z() + zd
            local maxz = Min((nbr.height - 1) * voxelSizeZ + hp:z(), (h - 1) * voxelSizeZ + mp:z())
            c = (maxz - minz) / voxelSizeZ + 1
            oz = zd
            zs = voxelSizeZ
            ys = 0
            if sideString == "Left" then
              oy = leftOffset * voxelSizeY * flippedMultiplier
            else
              oy = rightOffset * voxelSizeY * flippedMultiplier
            end
          else
            zs = 0
            ys = voxelSizeX
            if sideString == "Top" then
              oz = (h - 1) * voxelSizeZ
            else
              oz = 0
            end
            local hp = nbr:GetPos()
            local calcHelper = function(ms, nbr, mpy, hpy)
              local mlo = leftOffset * ms
              local mly = mlo * voxelSizeX - halfVoxelSizeX * ms + mpy
              local hlo = nbr:GetLeftOffset() * ms
              local hly = hlo * voxelSizeX - halfVoxelSizeX * ms + hpy
              local mro = rightOffset * ms
              local mry = mro * voxelSizeX + halfVoxelSizeX * ms + mpy
              local hro = nbr:GetRightOffset() * ms
              local hry = hro * voxelSizeX + halfVoxelSizeX * ms + hpy
              local miniy = Max(Min(mly, mry), Min(hly, hry))
              local maxiy = Min(Max(mly, mry), Max(hly, hry))
              c = (maxiy - miniy) / voxelSizeY
              oy = miniy + halfVoxelSizeY - mpy
              oy = oy * ms * flippedMultiplier
              ys = ys * ms * flippedMultiplier
            end
            if side == "North" or side == "South" then
              local ms = side == "North" and -1 or 1
              calcHelper(ms, nbr, mp:x(), hp:x())
            else
              local ms = side == "East" and -1 or 1
              calcHelper(ms, nbr, mp:y(), hp:y())
            end
          end
          local osf = maskToOppositeMask[sideFlag]
          local arr = da[sideString]
          local sc = WallSlab.MaskToChar(self, osf)
          for i = 1, c do
            local attPos = point(0, oy + (i - 1) * ys, oz + (i - 1) * zs)
            local id = GetDestroyedSlabAttachId(sideFlag, attPos)
            local subvariant = self.da_subvariants and self.da_subvariants[id] or false
            if subvariant ~= 0 then
              local wAttPos = self:GetRelativePoint(attPos)
              local slabAtAttchPos = MapGetFirst(wAttPos, 0, "WallSlab", function(o)
                return o.invisible_reasons and not o.invisible_reasons.suppressed
              end)
              local variant, mat, m1, m2 = prepArgs("OutdoorIndoor", self.material, slabAtAttchPos)
              local o, suffix = prepAttach(arr, sc, variant, sideString, subvariant, mat)
              manageAttachsAttaches(self, o, sc, suffix, variant, count, m1, m2)
              o:SetAttachOffset(attPos)
            end
          end
        end
      else
        local osf = maskToOppositeMask[sideFlag]
        if (not nbr.is_destroyed or isLeftOrRight and self:IsStructuralRow(sideFlag)) and ((not isLeftOrRight or nbr.side == side) and nbr.destroyed_entity_side ~= osf or isLeftOrRight and nbr.side ~= side and nbr.destroyed_entity_side ~= sideFlag) then
          local attPos, worldAttPos = self:GetDestroyedAttachOffset(sideFlag, nbr, mp)
          local id = GetDestroyedSlabAttachId(sideFlag, attPos)
          local subvariant = self.da_subvariants and self.da_subvariants[id] or false
          if subvariant ~= 0 then
            local slabAtAttchPos = MapGetFirst(worldAttPos, 0, "WallSlab", function(o)
              return o.invisible_reasons and not o.invisible_reasons.suppressed
            end)
            local arr = da[sideString]
            local sc = WallSlab.MaskToChar(self, osf)
            local variant, mat, m1, m2 = prepArgs(false, false, slabAtAttchPos or nbr)
            local o, suffix = prepAttach(arr, sc, variant, sideString, subvariant, mat)
            local ad = abs(self:GetAngle() - nbr:GetAngle())
            manageAttachsAttaches(self, o, sc, suffix, variant, count, m1, m2)
            o:SetAttachOffset(attPos)
          end
        end
      end
    else
      for i = 1, #(nbr or "") do
        processNbr(nbr[i], sideFlag, sideString)
      end
    end
  end
  local cleanup = function(arr)
    for i = count + 1, #(arr or "") do
      DoneObject(arr[i])
      arr[i] = nil
    end
    count = 0
  end
  local appendNbrs = function(t1, t2)
    if IsValid(t1) then
      if IsValid(t2) then
        return {t1, t2}
      elseif t2 then
        return table.iappend({t1}, t2)
      else
        return t1
      end
    elseif t1 then
      if IsValid(t2) then
        table.insert(t1, t2)
        return t1
      elseif t2 then
        return table.iappend(t1, t2)
      else
        return t1
      end
    else
      return t2
    end
  end
  if self:ShouldHaveBrokenDecAttaches() then
    local lc = self:GetNeighbourCorner(SlabNeighbourMask.Left)
    left = appendNbrs(left, lc)
    local rc = self:GetNeighbourCorner(SlabNeighbourMask.Right)
    right = appendNbrs(right, rc)
    processNbr(left, SlabNeighbourMask.Left, "Left")
    cleanup(da.Left)
    processNbr(right, SlabNeighbourMask.Right, "Right")
    cleanup(da.Right)
    processNbr(top, SlabNeighbourMask.Top, "Top")
    cleanup(da.Top)
    processNbr(bottom, SlabNeighbourMask.Bottom, "Bottom")
    cleanup(da.Bottom)
  else
    cleanup(da.Left)
    cleanup(da.Right)
  end
  self:RefreshColors()
  local decs = self:GetDecorations()
  for i = 1, #(decs or "") do
    DecSetDestroyedEnt(decs[i], decs[i]:GetEntity(), nil, self)
  end
  self:UpdateDecorationsDestroyedState()
  return true
end
local ShouldProcessDecsDestroyedStateForNbrSWO = function(swo)
  return not swo.is_destroyed and swo.material == "Colonial" and swo.width > 0 and swo.height > 1
end
local ShouldProcessDecsDestroyedStateForSWO = function(swo)
  return swo.is_destroyed and swo.material == "Colonial" and swo.width > 0 and swo.height > 1
end
function SlabWallObject:UpdateDecorationsDestroyedState()
  if ShouldProcessDecsDestroyedStateForSWO(self) then
    local leftOffset = self:GetLeftOffset()
    local rightOffset = self:GetRightOffset()
    local ma = self:GetAngle()
    local side = self.side or slabAngleToDir[ma]
    local isFlipped = side ~= slabAngleToDir[ma]
    local x, y, z = self:GetPosXYZ()
    local lns = self:GetNeighbourWallSlab(SlabNeighbourMask.Left)
    local rns = self:GetNeighbourWallSlab(SlabNeighbourMask.Right)
    local topz = z + (self.height - 1) * voxelSizeZ
    local ln, rn
    for i = #(lns or ""), 1, -1 do
      local lnn = lns[i]
      if topz <= lnn:GetPos():z() then
        ln = lnn
        break
      end
    end
    for i = #(rns or ""), 1, -1 do
      local rnn = rns[i]
      if topz <= rnn:GetPos():z() then
        rn = rnn
        break
      end
    end
    local processWindowNbrs = function(wn)
      if wn then
        if #wn <= 0 then
          local hisz = wn:GetPos():z()
          if topz <= wn.height * voxelSizeZ + hisz and hisz <= topz then
            return wn
          end
        else
          for i = 1, #wn do
            local hisz = wn[i]:GetPos():z()
            if topz <= wn[i].height * voxelSizeZ + hisz and hisz <= topz then
              return wn[i]
            end
          end
        end
      end
      return nil
    end
    local lnIsWindow, rnIsWindow
    if not ln then
      local lw = self:GetNeighbourWindow(SlabNeighbourMask.Left)
      ln = processWindowNbrs(lw)
      ln = ln and ShouldProcessDecsDestroyedStateForNbrSWO(ln) and ln or false
      lnIsWindow = ln and true or false
    end
    if not rn then
      local rw = self:GetNeighbourWindow(SlabNeighbourMask.Right)
      rn = processWindowNbrs(rw)
      rn = rn and ShouldProcessDecsDestroyedStateForNbrSWO(rn) and rn or false
      rnIsWindow = rn and true or false
    end
    if ln and not ln.is_destroyed then
      local proceed = lnIsWindow or MapGetFirst(self:GetRelativePoint(point(0, -voxelSizeX * (leftOffset - 1), topz - z)), 10, "DestroyableWallDecoration")
      if proceed then
        local att = PlaceObject("Object", {use_self_colors = true})
        self:Attach(att)
        att:ChangeEntity("WallDec_Colonial_Frieze_Body_BrokenDec_R_01")
        att:SetAttachOffset(point(0, voxelSizeX * leftOffset, topz - z))
        att:SetColorization(IsValid(proceed) and proceed or self, "ignore_his_max")
        self.destroyed_attaches = self.destroyed_attaches or {
          Top = {},
          Bottom = {},
          Left = {},
          Right = {}
        }
        table.insert(self.destroyed_attaches.Left, att)
      end
    end
    if rn and not rn.is_destroyed then
      do
        local proceed = rnIsWindow or MapGetFirst(self:GetRelativePoint(point(0, -voxelSizeX * (rightOffset + 1), topz - z)), 10, "DestroyableWallDecoration")
        if proceed then
          local att = PlaceObject("Object", {use_self_colors = true})
          self:Attach(att)
          att:ChangeEntity("WallDec_Colonial_Frieze_Body_BrokenDec_L_01")
          att:SetAttachOffset(point(0, -voxelSizeX * rightOffset, topz - z))
          att:SetColorization(IsValid(proceed) and proceed or self, "ignore_his_max")
          self.destroyed_attaches = self.destroyed_attaches or {
            Top = {},
            Bottom = {},
            Left = {},
            Right = {}
          }
          table.insert(self.destroyed_attaches.Right, att)
        end
      end
    end
  end
end
function RoofPlaneSlab:UpdateDestroyedStateInternal()
  if self.roof_comp == "Gable" then
    return RoofEdgeSlab.UpdateDestroyedStateInternal(self)
  end
  local mask = self.destroyed_neighbours
  self.destroyed_attaches = self.destroyed_attaches or {
    Top = false,
    Bottom = false,
    Left = false,
    Right = false
  }
  local da = self.destroyed_attaches
  local isDestroyed = self.is_destroyed
  for i = 0, 3 do
    processSideHelper(self, da, 1 << i, mask)
  end
  local a = self:GetAngle()
  local isFlipped = a == 10800 or a == 16200
  if isDestroyed then
    self:SetDestroyedEntityAndFlags()
    local lOrRExist = da.Left or da.Right
    local rbPossible = (isFlipped and da.Top or not isFlipped and da.Bottom) and lOrRExist
    local rtPossible = (isFlipped and da.Bottom or not isFlipped and da.Top) and lOrRExist
    if (rtPossible or rbPossible) and self:GetSeed(100, 97577) >= 50 then
      local side
      if rtPossible and rbPossible then
        if 50 <= self:GetSeed(100, 7759) then
          side = "RT"
        else
          side = "RB"
        end
      elseif rtPossible then
        side = "RT"
      else
        side = "RB"
      end
      local e = self:ComposeBrokenEntityName(side)
      if IsValidEntity(e) then
        self:ChangeEntity(e)
        self:ResetVisibilityFlags()
        if not (side ~= "RB" or isFlipped) or isFlipped and side == "RT" then
          self:DestroyDestroyedAttach(SlabNeighbourMask.Bottom, self)
          self.diagonal_ent_mask = SlabNeighbourMask.Bottom
        else
          self:DestroyDestroyedAttach(SlabNeighbourMask.Top, self)
          self.diagonal_ent_mask = SlabNeighbourMask.Top
        end
        if da.Left then
          self.diagonal_ent_mask = self.diagonal_ent_mask | SlabNeighbourMask.Left
          self:DestroyDestroyedAttach(SlabNeighbourMask.Left, self)
        else
          self.diagonal_ent_mask = self.diagonal_ent_mask | SlabNeighbourMask.Right
          self:DestroyDestroyedAttach(SlabNeighbourMask.Right, self)
        end
      end
    end
  end
  if self.destroyed_entity and self:GetEntity() ~= self.destroyed_entity then
    if IsValidEntity(self.destroyed_entity) then
      self:ChangeEntity(self.destroyed_entity)
      self:ResetVisibilityFlags()
    end
    self:UpdateVariantEntities()
  end
  local isMirrored = not isFlipped and self.destroyed_entity_side & SlabNeighbourMask.Left ~= 0 or isFlipped and self.destroyed_entity_side & SlabNeighbourMask.Right ~= 0 or not isFlipped and self.diagonal_ent_mask & SlabNeighbourMask.Right ~= 0 or isFlipped and self.diagonal_ent_mask & SlabNeighbourMask.Left ~= 0
  self:SetMirrored(isMirrored)
  local hasAtLeastOneAttch = false
  if da.Right then
    local m = not isMirrored
    if isFlipped then
      m = not m
    end
    da.Right:SetMirrored(m)
    self:Attach(da.Right)
    hasAtLeastOneAttch = true
  end
  if da.Left then
    local m = isMirrored
    if isFlipped then
      m = not m
    end
    da.Left:SetMirrored(m)
    self:Attach(da.Left)
    hasAtLeastOneAttch = true
  end
  if da.Top then
    self:Attach(da.Top)
    hasAtLeastOneAttch = true
  end
  if da.Bottom then
    self:Attach(da.Bottom)
    hasAtLeastOneAttch = true
  end
  if not isDestroyed and not hasAtLeastOneAttch and not self.destroyed_entity then
    return false
  end
  self:RefreshColors()
  self:SetWarped(self:GetWarped())
  return true
end
function RoofCorner:UpdateDestroyedStateInternal()
  local isDestroyed = self.is_destroyed
  if isDestroyed then
    self:SetDestroyedEntityAndFlags()
  end
  self:RefreshColors()
  self:SetWarped(self:GetWarped())
  return isDestroyed
end
function RoomCorner:UpdateDestroyedStateInternal()
  local isDestroyed = self.is_destroyed
  if isDestroyed then
    self:SetDestroyedEntityAndFlags()
  end
  self:UpdateDecorationsDestroyedState()
  self:RefreshColors()
  self:SetWarped(self:GetWarped())
  return isDestroyed
end
function WallSlab:UpdateDestroyedStateInternal()
  local mask = self.destroyed_neighbours
  self.destroyed_attaches = self.destroyed_attaches or {
    Top = false,
    Bottom = false,
    Left = false,
    Right = false
  }
  local da = self.destroyed_attaches
  local isDestroyed = self.is_destroyed
  for i = 0, 3 do
    processSideHelper(self, da, 1 << i, mask)
  end
  if isDestroyed then
    local odem = self.diagonal_ent_mask
    self:SetDestroyedEntityAndFlags()
    if da.Top and (da.Left or da.Right) and not IsKindOf(self, "RoofWallSlab") and not self.always_visible and self:GetSeed(100, 97577) >= 50 then
      local e = self:ComposeBrokenEntityName("RB")
      if IsValidEntity(e) then
        self:ChangeEntity(e)
        self:ResetVisibilityFlags()
        self:DestroyDestroyedAttach(SlabNeighbourMask.Top, self)
        if da.Left then
          self.diagonal_ent_mask = SlabNeighbourMask.Left | SlabNeighbourMask.Top
          self:DestroyDestroyedAttach(SlabNeighbourMask.Left, self)
        else
          self.diagonal_ent_mask = SlabNeighbourMask.Right | SlabNeighbourMask.Top
          self:DestroyDestroyedAttach(SlabNeighbourMask.Right, self)
        end
      end
    end
    if odem ~= self.diagonal_ent_mask then
      self:UpdateVariantEntities()
    end
  end
  if self.destroyed_entity and self:GetEntity() ~= self.destroyed_entity then
    if IsValidEntity(self.destroyed_entity) then
      self:ChangeEntity(self.destroyed_entity)
      self:ResetVisibilityFlags()
    end
    self:UpdateVariantEntities()
  end
  local isMirrored = self.destroyed_entity_side & SlabNeighbourMask.Left ~= 0 or self.diagonal_ent_mask & SlabNeighbourMask.Right ~= 0
  self:SetMirrored(isMirrored)
  if self.variant_objects then
    local mi = self.destroyed_entity_side & (SlabNeighbourMask.Left | SlabNeighbourMask.Right) ~= 0
    self.variant_objects[1]:SetMirrored(mi)
    local o = self.variant_objects[2]
    if IsValid(o) then
      o:SetMirrored(not mi)
    end
  end
  local hasAtLeastOneAttch = false
  if da.Right then
    da.Right:SetMirrored(not isMirrored)
    self:Attach(da.Right)
    hasAtLeastOneAttch = true
  end
  if da.Left then
    da.Left:SetMirrored(isMirrored)
    self:Attach(da.Left)
    hasAtLeastOneAttch = true
  end
  if da.Top then
    self:Attach(da.Top)
    hasAtLeastOneAttch = true
  end
  if da.Bottom then
    self:Attach(da.Bottom)
    hasAtLeastOneAttch = true
  end
  if self.diagonal_ent_mask ~= 0 then
    local o1 = self.variant_objects and self.variant_objects[1]
    local o2 = self.variant_objects and self.variant_objects[2]
    if IsValid(o1) then
      o1:SetMirrored(true)
    end
    if IsValid(o2) then
      o2:SetMirrored(false)
    end
  end
  self:UpdateDecorationsDestroyedState()
  if not isDestroyed and not hasAtLeastOneAttch and not self.destroyed_entity then
    return false
  end
  self:RefreshColors()
  self:SetWarped(self:GetWarped())
  return true
end
local horizontalDecorationNames = {
  "Frieze",
  "Socle",
  "FenceTop"
}
local IsHorizontalDecoration = function(ent_name, obj)
  for i = 1, #horizontalDecorationNames do
    local str = horizontalDecorationNames[i]
    if string.find(ent_name, str) then
      local my_axis = obj:GetAxis()
      if my_axis ~= axis_z and my_axis ~= -axis_z then
        return false
      end
      return true
    end
  end
  return false
end
function _ENV:ComposeBrokenDecorationAttachName(e, sc, var, t, suppressError)
  t = t or "BrokenDec"
  if not var then
    local varStr = string.sub(e, -2)
    var = tonumber(varStr) or 1
  end
  local be = string.sub(e, 1, -3)
  local ret = string.format("%s%s_%s_%s", be, t, sc, var < 10 and string.format("0%d", var) or tostring(var))
  if IsValidEntity(ret) then
    return ret
  else
    local err
    if not slab_missing_entity_white_list[e] and not slab_missing_entity_white_list[ret] then
      err = "ComposeBrokenDecorationAttachName " .. ret .. " is invalid ent. " .. " Original ent " .. e .. ". " .. tostring(self.handle)
      if not suppressError then
        print("once", err)
      end
    end
    return "InvisibleObject", err
  end
end
local epsilon = 600
function Slab:UpdateDecorationsDestroyedState()
  local decs = self:GetDecorations()
  local da = self.destroyed_attaches
  local isDestroyed = self.is_destroyed
  local a = self:GetAngle()
  local mask = self.destroyed_neighbours
  local ds = self.destroyed_entity_side
  local ln = self:GetNeighbour(SlabNeighbourMask.Left)
  local rn = self:GetNeighbour(SlabNeighbourMask.Right)
  local tn = self:GetNeighbour(SlabNeighbourMask.Top)
  local bn = self:GetNeighbour(SlabNeighbourMask.Bottom)
  local diagt = self.diagonal_ent_mask & SlabNeighbourMask.Top ~= 0
  for i = 1, #(decs or "") do
    do
      local d = decs[i]
      local e = d:GetEntity()
      local na = 1
      local oe = rawget(d, "orig_decoration_ent") or d:GetEntity()
      local isHorizontal = IsHorizontalDecoration(oe, d)
      local isTop = string.find(oe, "_Top")
      local isBot = string.find(oe, "_Bottom")
      local varStr = string.sub(oe, -2)
      local var = tonumber(varStr) or 1
      local forceNoT = isBot and 1 < var
      local forceNoB = isTop and 1 < var
      local AddAttch = function(d, oe, sc)
        local ae = ComposeBrokenDecorationAttachName(self, oe, sc, var)
        if not IsValidEntity(ae) then
          print("once", "Failed to find entity for broken attach for decoration: " .. ae)
          return
        end
        local att
        repeat
          att = d:GetAttach(na) or PlaceObject("Object")
          na = na + 1
        until not rawget(att, "editor_ignore")
        att:ChangeEntity(ae)
        d:Attach(att)
        att:SetColorization(d, "ignore_his_max")
      end
      if not isDestroyed then
        d:DestroyAttaches()
        if not forceNoB and not isHorizontal and ds & SlabNeighbourMask.Top ~= 0 and e ~= "InvisibleObject" then
          local ne, err = ComposeBrokenDecorationAttachName(self, oe, "B", var, "Broken", "suppressError")
          if ne == "InvisibleObject" then
            ne = ComposeBrokenDecorationAttachName(self, oe, "B")
            if ne == "InvisibleObject" then
              print(err)
            end
          end
          DecSetDestroyedEnt(d, oe, ne, self)
        elseif not forceNoT and not isHorizontal and ds & SlabNeighbourMask.Bottom ~= 0 and e ~= "InvisibleObject" then
          local ne, err = ComposeBrokenDecorationAttachName(self, oe, "T", var, "Broken", "suppressError")
          if ne == "InvisibleObject" then
            ne = ComposeBrokenDecorationAttachName(self, oe, "T")
            if ne == "InvisibleObject" then
              print(err)
            end
          end
          DecSetDestroyedEnt(d, oe, ne, self)
        elseif e ~= oe then
          DecRestoreOrigEnt(d, e, self)
        end
      elseif isDestroyed then
        DecSetDestroyedEnt(d, e, nil, self)
        local decA = d:GetAngle()
        local x, y, z = d:GetPosXYZ()
        z = z or terrain.GetHeight(d:GetPos())
        local cls = "DestroyableWallDecoration"
        if isHorizontal then
          if ln and mask & SlabNeighbourMask.Left == 0 or da and da.Left then
            local sc = abs(decA - a) < epsilon and "R" or "L"
            AddAttch(d, oe, sc)
          end
          if rn and mask & SlabNeighbourMask.Right == 0 or da and da.Right then
            local sc = abs(decA - a) < epsilon and "L" or "R"
            AddAttch(d, oe, sc)
          end
        else
          local filter = function(o, test_str)
            local e = o:GetEntity()
            return e == o.class or string.find(e, test_str)
          end
          if not forceNoT and not isTop and (da and da.Top or diagt or tn and tn.destroyed_entity_side & SlabNeighbourMask.Bottom == 0 and mask & SlabNeighbourMask.Top == 0) then
            local nd = MapGetFirst(x, y, z + voxelSizeZ, 0, cls, filter, "Broken_B")
            if nd and nd:GetEntity() ~= "InvisibleObject" then
              AddAttch(d, oe, "T")
            end
          end
          if not forceNoB and (da and da.Bottom or bn and bn.destroyed_entity_side & SlabNeighbourMask.Top == 0 and mask & SlabNeighbourMask.Bottom == 0) then
            local nd = MapGetFirst(x, y, z - voxelSizeZ, 0, cls, filter, "Broken_T")
            if nd and nd:GetEntity() ~= "InvisibleObject" then
              AddAttch(d, oe, "B")
            end
          end
        end
      end
      while d:GetAttach(na) do
        DoneObject(d:GetAttach(na))
      end
    end
  end
end
function DestroyableFloorSlab:GetNeighbourCorner()
end
function DestroyableFloorSlab:UpdateDestroyedStateInternal()
  local mask = self.destroyed_neighbours
  self.destroyed_attaches = self.destroyed_attaches or {
    Top = false,
    Bottom = false,
    Left = false,
    Right = false
  }
  local da = self.destroyed_attaches
  local isDestroyed = self.is_destroyed
  if isDestroyed then
    self:SetDestroyedEntityAndFlags()
    self:SetAngle(0)
  end
  for i = 0, 3 do
    processSideHelper(self, da, 1 << i, mask)
  end
  local isFlipped = false
  if isDestroyed then
    local lOrRExist = da.Left or da.Right
    local rbPossible = da.Bottom and lOrRExist
    local rtPossible = da.Top and lOrRExist
    if (rtPossible or rbPossible) and self:GetSeed(100, 97577) >= 50 then
      local e = self:ComposeBrokenEntityName("RB")
      if IsValidEntity(e) then
        if rtPossible and rbPossible then
          if 50 > self:GetSeed(100, 7759) then
            isFlipped = true
          end
        elseif rbPossible then
          isFlipped = true
        end
        self:ChangeEntity(e)
        self:ResetVisibilityFlags()
        if isFlipped then
          self:DestroyDestroyedAttach(SlabNeighbourMask.Bottom, self)
          self.diagonal_ent_mask = SlabNeighbourMask.Bottom
          self:SetAngle(10800)
        else
          self:DestroyDestroyedAttach(SlabNeighbourMask.Top, self)
          self.diagonal_ent_mask = SlabNeighbourMask.Top
        end
        if da.Left then
          self.diagonal_ent_mask = self.diagonal_ent_mask | SlabNeighbourMask.Left
          self:DestroyDestroyedAttach(SlabNeighbourMask.Left, self)
        else
          self.diagonal_ent_mask = self.diagonal_ent_mask | SlabNeighbourMask.Right
          self:DestroyDestroyedAttach(SlabNeighbourMask.Right, self)
        end
      end
    end
  elseif self.destroyed_entity and self:GetEntity() ~= self.destroyed_entity then
    if IsValidEntity(self.destroyed_entity) then
      self:ChangeEntity(self.destroyed_entity)
      self:ResetVisibilityFlags()
    end
    if self.destroyed_entity_side & SlabNeighbourMask.Top ~= 0 then
      self:SetAngle(10800)
    else
      self:SetAngle(0)
    end
  end
  local isMirrored = self.destroyed_entity_side & SlabNeighbourMask.Left ~= 0 or not isFlipped and self.diagonal_ent_mask & SlabNeighbourMask.Right ~= 0 or isFlipped and self.diagonal_ent_mask & SlabNeighbourMask.Left ~= 0
  self:SetMirrored(isMirrored)
  local hasAtLeastOneAttch = false
  if da.Right then
    local m = not isMirrored
    if isFlipped then
      m = not m
    end
    da.Right:SetMirrored(m)
    self:Attach(da.Right)
    hasAtLeastOneAttch = true
  end
  if da.Left then
    local m = isMirrored
    if isFlipped then
      m = not m
    end
    da.Left:SetMirrored(m)
    self:Attach(da.Left)
    hasAtLeastOneAttch = true
  end
  if da.Top then
    self:Attach(da.Top)
    if isFlipped then
      da.Top:SetAttachAngle(10800)
    end
    hasAtLeastOneAttch = true
  end
  if da.Bottom then
    self:Attach(da.Bottom)
    if not isFlipped then
      da.Bottom:SetAttachAngle(10800)
    end
    hasAtLeastOneAttch = true
  end
  if not isDestroyed and not hasAtLeastOneAttch and not self.destroyed_entity then
    return false
  end
  self:RefreshColors()
  self:SetWarped(self:GetWarped())
  return true
end
function Slab:IsStructuralSlab(r)
  return self:IsInvulnerable() or self.force_structural
end
function Slab:IsStructuralRow(r)
  return false
end
function Slab:GetNeighbours()
end
function Slab:GetNeighbour()
end
function Slab:GetNeighboursAroundCorner()
end
function Slab:GetDecorationQueryBox()
end
function Slab:GetDecorations()
end
function Slab:GetNeighbourWindow()
end
function Slab:GetStairNeighbours()
end
function Slab:ClearDaSubvariants(sideFlag, attPos)
  if self.da_subvaraints then
    attPos = attPos or point30
    local id = GetDestroyedSlabAttachId(sideFlag, attPos)
    self.da_subvaraints[id] = nil
    if not next(self.da_subvaraints) then
      self.da_subvaraints = nil
    end
  end
end
function Slab:DestroyDestroyedAttach(sideFlag)
  local ss = maskToString[sideFlag]
  local att = self.destroyed_attaches and self.destroyed_attaches[ss]
  if att then
    DoneObject(att)
    self.destroyed_attaches[ss] = false
  end
  self:ClearDaSubvariants(sideFlag)
end
function RoofWallSlab:DestroyDestroyedAttach(sideFlag)
  MapForEach(self, 0, "RoofWallSlab", nil, const.efVisible, function(o, sideFlag, self)
    if sideFlag & 12 == 0 or o:GetAngle() == self:GetAngle() then
      Slab.DestroyDestroyedAttach(o, sideFlag)
    else
      local osf = maskToOppositeMask[sideFlag]
      Slab.DestroyDestroyedAttach(o, osf)
    end
  end, sideFlag, self)
end
function Slab:GetDestroyedAttachOffset()
  return point30
end
function SlabWallObject:GetDestroyedAttachOffset(sideFlag, nbr, mp)
  mp = mp or self:GetPos()
  local hp = nbr:GetPos()
  local dp = mp - hp
  local dx, dy, dz = dp:xyz()
  local attPos
  if sideFlag & 12 ~= 0 then
    local offs = IsKindOf(nbr, "WallSlab") and voxelSizeX or halfVoxelSizeX
    attPos = hp + point(sign(dx) * offs, sign(dy) * offs, 0)
  else
    attPos = hp + point(0, 0, sign(dz) * voxelSizeZ)
  end
  local localAttPos = self:GetLocalPoint(attPos)
  return localAttPos, attPos
end
function SlabWallObject:DestroyDestroyedAttach(sideFlag, nbr)
  local da = self.destroyed_attaches
  if not da then
    return
  end
  local attPos = self:GetDestroyedAttachOffset(sideFlag, nbr)
  self:ClearDaSubvariants(sideFlag, attPos)
  local atts = da[maskToString[sideFlag]]
  for i = #(atts or ""), 1, -1 do
    local a = atts[i]
    if not IsValid(a) then
      table.remove(atts, i)
      print(string.format("Found invalid attch h[%s] class[%s] i[%d] side[%s]", tostring(self.handle), self.class, i, maskToString[sideFlag]))
    elseif (a.offset or a:GetAttachOffset()) == attPos and IsKindOf(a, DestroyedAttachClass) then
      table.remove(atts, i)
      DoneObject(a)
      if #atts <= 0 then
        local canClear = true
        for side, satts in pairs(da) do
          if 0 < #satts then
            canClear = false
            break
          end
        end
        if canClear then
          self.destroyed_attaches = false
        end
      end
      return
    end
  end
end
function Slab:IsGrounded()
  local x, y, z = self:GetPosXYZ()
  local tz = terrain.GetHeight(x, y)
  if z <= tz or abs(z - tz) < voxelSizeZ then
    return true
  end
  return false
end
function Slab:ReportMissingDamagedEntity(ent)
  self:ReportMissingDestructionEntity(ent, "Failed to find damaged entity " .. ent)
end
function Slab:ReportMissingBrokenEntity(ent)
  self:ReportMissingDestructionEntity(ent, "Failed to find broken entity " .. ent)
end
function Slab:ReportMissingBrokenDecInteriorAttach(ent)
  self:ReportMissingDestructionEntity(ent, "Failed to find broken dec interior attach entity " .. ent)
end
function Slab:ReportMissingBrokenDec(ent)
  self:ReportMissingDestructionEntity(ent, "Failed to find broken dec entity " .. ent)
end
function Slab:ReportMissingDestructionEntity(ent, msg)
  if not slab_missing_entity_white_list[ent] then
    print(string.format("[%s][%s][%s] %s", tostring(rawget(self, "handle")), self.class, GetMapName(), msg))
    slab_missing_entity_white_list[ent] = true
  end
end
wallSidewaysOffsets = {
  North = {x = 1, y = 0},
  South = {x = -1, y = 0},
  East = {x = 0, y = 1},
  West = {x = 0, y = -1}
}
function RoofEdgeSlab:GetNeighbours()
  return self:GetNeighbour(SlabNeighbourMask.Left), self:GetNeighbour(SlabNeighbourMask.Right)
end
local RoofEdgeSlab_GetNeighbour = function(self, sideFlag, corner)
  if self.roof_comp == "RakeGable" then
    return
  end
  local x, y, z = self:GetPosXYZ()
  local pt
  local s = slabAngleToDir[self:GetAngle()]
  local xstep, ystep = voxelSizeX, voxelSizeY
  if corner then
    xstep, ystep = xstep / 2, ystep / 2
  end
  if sideFlag == SlabNeighbourMask.Left then
    local offs = wallSidewaysOffsets[s]
    pt = point(x + offs.x * xstep, y + offs.y * ystep)
  elseif sideFlag == SlabNeighbourMask.Right then
    local offs = wallSidewaysOffsets[s]
    pt = point(x - offs.x * xstep, y - offs.y * ystep)
  else
    return false
  end
  local room = self.room
  local oz = z
  if self.roof_comp ~= "Gable" then
    oz = room and room:GetRoofZAndDir(pt) or z
    oz = oz == const.InvalidZ and z or oz
  end
  local mirrored = self:GetMirrored()
  if not corner then
    local cls = self.class
    return MapGetFirst(pt:x(), pt:y(), oz, 0, cls, nil, const.efVisible, function(o, mirrored)
      return o:GetMirrored() == mirrored
    end, mirrored) or MapGetFirst(self, 0, cls, nil, const.efVisible, function(o, self)
      return o ~= self
    end, self) or MapGetFirst(pt:x(), pt:y(), oz, 0, cls, nil, const.efVisible)
  else
    local cls = "RoofCorner"
    return MapGetFirst(pt:x(), pt:y(), oz, 0, cls, nil, const.efVisible)
  end
end
function RoofEdgeSlab:GetNeighbourCorner(sideFlag)
  return RoofEdgeSlab_GetNeighbour(self, sideFlag, "corner")
end
function RoofEdgeSlab:GetNeighbour(sideFlag)
  return RoofEdgeSlab_GetNeighbour(self, sideFlag)
end
cornerAngleToSidewaysOffsets = {
  [0] = {x = 0, y = -1},
  [10800] = {x = 0, y = 1},
  [16200] = {x = 1, y = 0},
  [5400] = {x = -1, y = 0}
}
function RoofCorner:GetNeighbours()
  return self:GetNeighbourEdge(SlabNeighbourMask.Left), self:GetNeighbourEdge(SlabNeighbourMask.Right)
end
function RoofCorner:GetNeighbour(...)
  return self:GetNeighbourEdge(...)
end
function RoofCorner:GetNeighbourEdge(sideFlag)
  local x, y, z = self:GetPosXYZ()
  local pt
  local xstep, ystep = voxelSizeX / 2, voxelSizeY / 2
  local a = self:GetAngle()
  local offs = cornerAngleToSidewaysOffsets[a]
  local m = self:GetMirrored()
  if sideFlag == SlabNeighbourMask.Left then
    pt = point(x + offs.y * xstep, y + offs.x * ystep)
  elseif sideFlag == SlabNeighbourMask.Right then
    local mm = m and -1 or 1
    pt = point(x - offs.x * xstep * mm, y + offs.y * ystep * mm)
  else
    return false
  end
  return MapGetFirst(pt, 1, "RoofEdgeSlab", nil, const.efVisible)
end
function RoofPlaneSlab:IsStructuralSlab()
  return self:IsInvulnerable() or self.force_structural
end
function RoofPlaneSlab:IsStructuralRow(sideFlag)
  return false
end
function RoofPlaneSlab:GetNeighbourEdge(sideFlag, corner)
  local x, y, z = self:GetPosXYZ()
  local a = self:GetAngle()
  local flipped = a % 10800 ~= 0
  local pt
  if not flipped and sideFlag == SlabNeighbourMask.Left or flipped and sideFlag == SlabNeighbourMask.Bottom then
    if not corner then
      pt = point(x, y + halfVoxelSizeY)
    else
      pt = point(x - halfVoxelSizeX, y + halfVoxelSizeY)
    end
  elseif not flipped and sideFlag == SlabNeighbourMask.Right or flipped and sideFlag == SlabNeighbourMask.Top then
    if not corner then
      pt = point(x, y - halfVoxelSizeY)
    else
      pt = point(x + halfVoxelSizeX, y - halfVoxelSizeY)
    end
  elseif not flipped and sideFlag == SlabNeighbourMask.Top or flipped and sideFlag == SlabNeighbourMask.Left then
    if not corner then
      pt = point(x - halfVoxelSizeX, y)
    else
      pt = point(x - halfVoxelSizeX, y - halfVoxelSizeY)
    end
  elseif not flipped and sideFlag == SlabNeighbourMask.Bottom or flipped and sideFlag == SlabNeighbourMask.Right then
    if not corner then
      pt = point(x + halfVoxelSizeX, y)
    else
      pt = point(x + halfVoxelSizeX, y + halfVoxelSizeY)
    end
  else
    return false
  end
  local room = self.room
  local oz = room and room:GetRoofZAndDir(pt) or z
  oz = oz == const.InvalidZ and z or oz
  local anotherZWhereEdgesMayPreside = room:AdjustGableCapZ(oz)
  local cp = self:GetClipPlane()
  local cls = not corner and "RoofEdgeSlab" or "RoofCorner"
  if cp ~= 0 and (sideFlag == SlabNeighbourMask.Right or sideFlag == SlabNeighbourMask.Left) then
    local filter = function(o, cp)
      return o:GetClipPlane() == cp
    end
    return MapGetFirst(pt:x(), pt:y(), oz, 0, cls, nil, const.efVisible, filter, cp) or MapGetFirst(pt:x(), pt:y(), anotherZWhereEdgesMayPreside, 0, cls, nil, const.efVisible, filter, cp) or MapGetFirst(pt:x(), pt:y(), anotherZWhereEdgesMayPreside + 1, 0, cls, nil, const.efVisible, filter, cp)
  else
    return MapGetFirst(pt:x(), pt:y(), oz, 0, cls, nil, const.efVisible) or MapGetFirst(pt:x(), pt:y(), anotherZWhereEdgesMayPreside, 0, cls, nil, const.efVisible) or MapGetFirst(pt:x(), pt:y(), anotherZWhereEdgesMayPreside + 1, 0, cls, nil, const.efVisible)
  end
end
function RoofPlaneSlab:GetNeighbourWallSlab(sideFlag)
  local x, y, z = self:GetPosXYZ()
  z = snapZ(z)
  local nz = snapZ(z - 1)
  local a = self:GetAngle()
  local flipped = a % 10800 ~= 0
  if not flipped and sideFlag == SlabNeighbourMask.Left or flipped and sideFlag == SlabNeighbourMask.Bottom then
    return MapGetFirst(x, y + halfVoxelSizeY, z, 0, "WallSlab", nil, const.efVisible) or MapGetFirst(x, y + halfVoxelSizeY, nz, 0, "WallSlab", nil, const.efVisible)
  elseif not flipped and sideFlag == SlabNeighbourMask.Right or flipped and sideFlag == SlabNeighbourMask.Top then
    return MapGetFirst(x, y - halfVoxelSizeY, z, 0, "WallSlab", nil, const.efVisible) or MapGetFirst(x, y - halfVoxelSizeY, nz, 0, "WallSlab", nil, const.efVisible)
  elseif not flipped and sideFlag == SlabNeighbourMask.Top or flipped and sideFlag == SlabNeighbourMask.Left then
    return MapGetFirst(x - halfVoxelSizeX, y, z, 0, "WallSlab", nil, const.efVisible) or MapGetFirst(x - halfVoxelSizeX, y, nz, 0, "WallSlab", nil, const.efVisible)
  elseif not flipped and sideFlag == SlabNeighbourMask.Bottom or flipped and sideFlag == SlabNeighbourMask.Right then
    return MapGetFirst(x + halfVoxelSizeX, y, z, 0, "WallSlab", nil, const.efVisible) or MapGetFirst(x + halfVoxelSizeX, y, nz, 0, "WallSlab", nil, const.efVisible)
  end
  return false
end
function RoofPlaneSlab:GetNeighbour(sideFlag, all)
  if self.roof_comp == "Gable" then
    return RoofEdgeSlab.GetNeighbour(self, sideFlag)
  end
  local x, y, z = self:GetPosXYZ()
  local room = self.room
  local a = self:GetAngle()
  local flipped = a % 10800 ~= 0
  local pt
  if not flipped and sideFlag == SlabNeighbourMask.Left or flipped and sideFlag == SlabNeighbourMask.Bottom then
    pt = point(x, y + voxelSizeY)
  elseif not flipped and sideFlag == SlabNeighbourMask.Right or flipped and sideFlag == SlabNeighbourMask.Top then
    pt = point(x, y - voxelSizeY)
  elseif not flipped and sideFlag == SlabNeighbourMask.Bottom or flipped and sideFlag == SlabNeighbourMask.Right then
    pt = point(x + voxelSizeX, y)
  elseif not flipped and sideFlag == SlabNeighbourMask.Top or flipped and sideFlag == SlabNeighbourMask.Left then
    pt = point(x - voxelSizeX, y)
  end
  local oz = room and room:GetRoofZAndDir(pt) or z
  oz = oz == const.InvalidZ and z or oz
  local getfunc = all and MapGet or MapGetFirst
  return getfunc(pt:x(), pt:y(), oz, 0, "RoofPlaneSlab", nil, const.efVisible, function(o, a)
    return o:GetClipPlane() == 0 or o:GetAngle() == a
  end, a) or getfunc(pt:x(), pt:y(), z, 0, "RoofPlaneSlab", nil, const.efVisible, function(o, a)
    return o:GetClipPlane() == 0 or o:GetAngle() == a
  end, a)
end
function RoofPlaneSlab:GetNeighbours()
  return self:GetNeighbour(SlabNeighbourMask.Left, "all"), self:GetNeighbour(SlabNeighbourMask.Right, "all"), self:GetNeighbour(SlabNeighbourMask.Top, "all"), self:GetNeighbour(SlabNeighbourMask.Bottom, "all")
end
function WallSlab:IsStructuralSlab()
  return self:IsInvulnerable() or self:IsGrounded() or self:IsStructuralRow(SlabNeighbourMask.Left) or self:IsStructuralRow(SlabNeighbourMask.Right) or self.force_structural
end
function WallSlab:IsStructuralRow(sideFlag)
  local vx, vy, vz, a = WallWorldToVoxel(self)
  local s = slabAngleToDir[self:GetAngle()]
  if s == "North" then
    if sideFlag == SlabNeighbourMask.Left then
      return IsStructuralRow(vx + 1)
    elseif sideFlag == SlabNeighbourMask.Right then
      return IsStructuralRow(vx)
    end
  elseif s == "South" then
    if sideFlag == SlabNeighbourMask.Left then
      return IsStructuralRow(vx)
    elseif sideFlag == SlabNeighbourMask.Right then
      return IsStructuralRow(vx + 1)
    end
  elseif s == "West" then
    if sideFlag == SlabNeighbourMask.Left then
      return IsStructuralRow(vy)
    elseif sideFlag == SlabNeighbourMask.Right then
      return IsStructuralRow(vy + 1)
    end
  elseif s == "East" then
    if sideFlag == SlabNeighbourMask.Left then
      return IsStructuralRow(vy + 1)
    elseif sideFlag == SlabNeighbourMask.Right then
      return IsStructuralRow(vy)
    end
  end
  return false
end
RoofWallSlab.IsStructuralRow = empty_func
function RoomCorner:GetDecorationQueryBox()
  local e = self:GetEntity()
  if e ~= "InvisibleObject" then
    return self:GetObjectBBox():grow(1)
  end
  local min = self:GetRelativePoint(point(-10, -10, 0))
  local max = self:GetRelativePoint(point(110, 110, voxelSizeZ))
  local a, b, c = min:xyz()
  local d, e, f = max:xyz()
  return box(Min(a, d), Min(b, e), c, Max(a, d), Max(b, e), f)
end
function WallSlab:GetDecorationQueryBox()
  local e = self:GetEntity()
  local add = 0
  local minz = 0
  if not self:GetNeighbour(SlabNeighbourMask.Bottom) then
    minz = -voxelSizeZ
  end
  if e ~= "InvisibleObject" then
    local b = self:GetObjectBBox():grow(-add)
    if minz ~= 0 then
      local growth = abs(minz) / 2
      b = b:grow(0, 0, growth)
      b = Offset(b, point(0, 0, -growth))
    end
    return b
  end
  local min = self:GetRelativePoint(point(-86, -halfVoxelSizeX + add, minz))
  local max = self:GetRelativePoint(point(86, halfVoxelSizeX - add, voxelSizeZ))
  local a, b, c = min:xyz()
  local d, e, f = max:xyz()
  return box(Min(a, d), Min(b, e), c, Max(a, d), Max(b, e), f)
end
function SlabWallObject:GetDecorationQueryBox()
  local e = self:GetEntity()
  local add = -1
  local minz = 0
  if not self:GetNeighbour(SlabNeighbourMask.Bottom) then
    minz = -voxelSizeZ
  end
  if e ~= "InvisibleObject" then
    local b = self:GetObjectBBox():grow(-add)
    if minz ~= 0 then
      local growth = abs(minz) / 2
      b = b:grow(0, 0, growth)
      b = Offset(b, point(0, 0, -growth))
    end
    return b
  end
  local leftOffset = self:GetLeftOffset()
  local rightOffset = self:GetRightOffset()
  local min = self:GetRelativePoint(point(-100, -halfVoxelSizeX + add - rightOffset * voxelSizeX, minz))
  local max = self:GetRelativePoint(point(100, halfVoxelSizeX - add - leftOffset * voxelSizeX, voxelSizeZ * self.height))
  local a, b, c = min:xyz()
  local d, e, f = max:xyz()
  return box(Min(a, d), Min(b, e), c, Max(a, d), Max(b, e), f)
end
function WallSlab:GetCornerDecorations()
  return false
end
SlabWallObject.GetCornerDecorations = WallSlab.GetCornerDecorations
function RoomCorner:GetCornerDecorations()
  return true
end
function WallSlab:GetDecorations()
  local qb = self:GetDecorationQueryBox()
  local getCorners = self:GetCornerDecorations()
  local minz = qb:minz()
  local maxz = qb:maxz()
  return MapGet(qb, "CObject", function(o, minz, maxz)
    if o:GetParent() then
      return
    end
    local _, __, z = o:GetPosXYZ()
    if not z or minz <= z and maxz > z then
      local e = o:GetEntity()
      return not (rawget(o, "orig_decoration_ent") or e:starts_with("WallDec_")) or getCorners or not string.find(e, "Corner")
    end
  end, minz, maxz)
end
SlabWallObject.GetDecorations = WallSlab.GetDecorations
RoomCorner.GetDecorations = WallSlab.GetDecorations
function WallSlab:GetNeighboursAroundCorner(sideFlag)
  local s = slabAngleToDir[self:GetAngle()]
  local x, y, z = self:GetPosXYZ()
  local r1, r2
  local filter = function(o)
    return o:GetEnumFlags(const.efVisible) ~= 0 or o.wall_obj
  end
  if sideFlag == SlabNeighbourMask.Left then
    local offs = wallSidewaysOffsets[s]
    if offs.x ~= 0 then
      r1 = MapGetFirst(x + offs.x * halfVoxelSizeX, y + halfVoxelSizeY, z, 0, "WallSlab", filter)
      r2 = MapGetFirst(x + offs.x * halfVoxelSizeX, y - halfVoxelSizeY, z, 0, "WallSlab", filter)
    else
      r1 = MapGetFirst(x + halfVoxelSizeX, y + offs.y * halfVoxelSizeY, z, 0, "WallSlab", filter)
      r2 = MapGetFirst(x - halfVoxelSizeX, y + offs.y * halfVoxelSizeY, z, 0, "WallSlab", filter)
    end
  end
  if sideFlag == SlabNeighbourMask.Right then
    local offs = wallSidewaysOffsets[s]
    if offs.x ~= 0 then
      r1 = MapGetFirst(x - offs.x * halfVoxelSizeX, y + halfVoxelSizeY, z, 0, "WallSlab", filter)
      r2 = MapGetFirst(x - offs.x * halfVoxelSizeX, y - halfVoxelSizeY, z, 0, "WallSlab", filter)
    else
      r1 = MapGetFirst(x + halfVoxelSizeX, y - offs.y * halfVoxelSizeY, z, 0, "WallSlab", filter)
      r2 = MapGetFirst(x - halfVoxelSizeX, y - offs.y * halfVoxelSizeY, z, 0, "WallSlab", filter)
    end
  end
  r1 = r1 and not r1.isVisible and r1.wall_obj or r1
  r2 = r2 and not r2.isVisible and r2.wall_obj or r2
  return r1 or r2, r1 and r2
end
function WallSlab:GetNeighbourCorner(sideFlag, all)
  local s = slabAngleToDir[self:GetAngle()]
  local x, y, z = self:GetPosXYZ()
  local f = all and MapGet or MapGetFirst
  if sideFlag == SlabNeighbourMask.Left then
    local offs = wallSidewaysOffsets[s]
    return f(x + offs.x * halfVoxelSizeX, y + offs.y * halfVoxelSizeY, z, 0, "RoomCorner", nil, const.efVisible)
  end
  if sideFlag == SlabNeighbourMask.Right then
    local offs = wallSidewaysOffsets[s]
    return f(x - offs.x * halfVoxelSizeX, y - offs.y * halfVoxelSizeY, z, 0, "RoomCorner", nil, const.efVisible)
  end
end
function WallSlab:GetNeighbour(sideFlag, all, enumFlags)
  local rez = self:GetNeighbourWallSlab(sideFlag, all, enumFlags)
  if not IsValid(rez) and #(rez or "") <= 0 then
    rez = self:GetNeighbourWindow(sideFlag)
  end
  return rez
end
function WallSlab:GetNeighbourWallSlab(sideFlag, all, enumFlags)
  local s = slabAngleToDir[self:GetAngle()]
  local x, y, z = self:GetPosXYZ()
  enumFlags = enumFlags == nil and const.efVisible or enumFlags
  if sideFlag == SlabNeighbourMask.Left then
    local offs = wallSidewaysOffsets[s]
    return not all and MapGetFirst(x + offs.x * voxelSizeX, y + offs.y * voxelSizeY, z, 0, "WallSlab", nil, enumFlags) or all and (MapGet(x + offs.x * voxelSizeX, y + offs.y * voxelSizeY, z, 0, "WallSlab", nil, enumFlags) or empty_table)
  end
  if sideFlag == SlabNeighbourMask.Right then
    local offs = wallSidewaysOffsets[s]
    return not all and MapGetFirst(x - offs.x * voxelSizeX, y - offs.y * voxelSizeY, z, 0, "WallSlab", nil, enumFlags) or all and (MapGet(x - offs.x * voxelSizeX, y - offs.y * voxelSizeY, z, 0, "WallSlab", nil, enumFlags) or empty_table)
  end
  if sideFlag == SlabNeighbourMask.Top then
    return not all and MapGetFirst(x, y, z + voxelSizeZ, 0, "WallSlab", nil, enumFlags) or all and (MapGet(x, y, z + voxelSizeZ, 0, "WallSlab", nil, enumFlags) or empty_table)
  end
  if sideFlag == SlabNeighbourMask.Bottom then
    return not all and MapGetFirst(x, y, z - voxelSizeZ, 0, "WallSlab", nil, enumFlags) or all and (MapGet(x, y, z - voxelSizeZ, 0, "WallSlab", nil, enumFlags) or empty_table)
  end
end
function WallSlab:GetNeighbours()
  return self:GetNeighbour(SlabNeighbourMask.Left, "all"), self:GetNeighbour(SlabNeighbourMask.Right, "all"), self:GetNeighbour(SlabNeighbourMask.Top, "all"), self:GetNeighbour(SlabNeighbourMask.Bottom, "all")
end
function WallSlab:GetNeighbourWindow(sideFlag)
  local wallNbr = self:GetNeighbourWallSlab(sideFlag, false, ~const.efVisible)
  return wallNbr and wallNbr.wall_obj or false
end
function WallSlab:GetNeighbourFloor(sideFlag)
  local offs
  if sideFlag == SlabNeighbourMask.Top then
    offs = point(halfVoxelSizeX, 0, 0)
  elseif sideFlag == SlabNeighbourMask.Bottom then
    offs = point(-halfVoxelSizeX, 0, 0)
  else
    return
  end
  local f = self:GetRelativePoint(offs)
  return MapGetFirst(f, 0, "DestroyableFloorSlab", "RoofPlaneSlab", nil, const.efVisible)
end
local getNbrPosHelper = function(x, y, z, w, width, h, side, corner)
  local tx, ty, tz
  local wf = w - width / 2 - (width % 2 == 0 and 0 or 1)
  tz = z + (h - 1) * voxelSizeZ
  local cornerOffset = corner and halfVoxelSizeX or 0
  if side == "East" then
    tx = x
    ty = y - wf * voxelSizeY + cornerOffset * sign(wf)
  elseif side == "West" then
    tx = x
    ty = y + wf * voxelSizeY - cornerOffset * sign(wf)
  elseif side == "North" then
    tx = x - wf * voxelSizeX + cornerOffset * sign(wf)
    ty = y
  else
    tx = x + wf * voxelSizeX - cornerOffset * sign(wf)
    ty = y
  end
  return tx, ty, tz
end
local processPosHelper = function(tx, ty, tz, ret, all, enumFlags, class, class2)
  local rez
  if not class2 then
    rez = not all and MapGetFirst(tx, ty, tz, 0, class, nil, enumFlags) or all and MapGet(tx, ty, tz, 0, class, nil, enumFlags)
  else
    rez = not all and MapGetFirst(tx, ty, tz, 0, class, class2, nil, enumFlags) or all and MapGet(tx, ty, tz, 0, class, class2, nil, enumFlags)
  end
  if rez then
    ret = ret or {}
    if not all then
      table.insert(ret, rez)
    else
      table.iappend(ret, rez)
    end
  end
  return ret
end
local processVerticalNbrsHelper = function(height, tx, ty, z, ret, all, enumFlags, class)
  for h = 1, height do
    local tz = z + (h - 1) * voxelSizeZ
    ret = processPosHelper(tx, ty, tz, ret, all, enumFlags, class)
  end
  return ret
end
function SlabWallObject:GetNeighbours()
  return self:GetNeighbour(SlabNeighbourMask.Left, "all"), self:GetNeighbour(SlabNeighbourMask.Right, "all"), self:GetNeighbour(SlabNeighbourMask.Top, "all"), self:GetNeighbour(SlabNeighbourMask.Bottom, "all")
end
function SlabWallObject:GetNeighbour(sideFlag, all, enumFlags)
  local rez = self:GetNeighbourWallSlab(sideFlag, all, enumFlags)
  local rezw = self:GetNeighbourWindow(sideFlag)
  if rez then
    if IsValid(rezw) then
      table.insert(rez, rezw)
    elseif type(rezw) == "table" then
      table.iappend(rez, rezw)
    end
  else
    rez = rezw
  end
  return rez
end
function SlabWallObject:GetNeighbourCorner(sideFlag, all, enumFlags)
  return self:GetNeighbourWallSlab(sideFlag, all, enumFlags, "adjustForCorner")
end
function SlabWallObject:GetNeighbourFloor(sideFlag, all)
  local ret
  local side = self.side or slabAngleToDir[self:GetAngle()]
  local width = Max(self.width, 1)
  local height = self.height
  local x, y, z = self:GetPosXYZ()
  local enumFlags = const.efVisible
  z = z or terrain.GetHeight(x, y)
  local xOffs, yOffs = 0, 0
  if side == "West" then
    xOffs = halfVoxelSizeX
  elseif side == "East" then
    xOffs = -halfVoxelSizeX
  elseif side == "North" then
    yOffs = halfVoxelSizeY
  else
    yOffs = -halfVoxelSizeY
  end
  if sideFlag == SlabNeighbourMask.Top then
    for w = 1, width do
      local tx, ty, tz = getNbrPosHelper(x, y, z, w, width, 0, side)
      tx = tx - xOffs
      ty = ty - yOffs
      ret = processPosHelper(tx, ty, z, ret, all, enumFlags, "DestroyableFloorSlab", "RoofPlaneSlab")
    end
  end
  if sideFlag == SlabNeighbourMask.Bottom then
    for w = 1, width do
      local tx, ty, tz = getNbrPosHelper(x, y, z, w, width, 0, side)
      tx = tx + xOffs
      ty = ty + yOffs
      ret = processPosHelper(tx, ty, z, ret, all, enumFlags, "DestroyableFloorSlab", "RoofPlaneSlab")
    end
  end
  return ret
end
function SlabWallObject:GetNeighbourWallSlab(sideFlag, all, enumFlags, adjustForCorner)
  local ret
  local side = slabAngleToDir[self:GetAngle()]
  local width = Max(self.width, 1)
  local height = self.height
  local x, y, z = self:GetPosXYZ()
  enumFlags = enumFlags == nil and const.efVisible or enumFlags
  z = z or terrain.GetHeight(x, y)
  if sideFlag == SlabNeighbourMask.Left then
    local tx, ty, _ = getNbrPosHelper(x, y, z, 0, width, height, side, adjustForCorner)
    ret = processVerticalNbrsHelper(height, tx, ty, z, ret, all, enumFlags, not adjustForCorner and "WallSlab" or "RoomCorner")
  end
  if sideFlag == SlabNeighbourMask.Right then
    local tx, ty, _ = getNbrPosHelper(x, y, z, width + 1, width, height, side, adjustForCorner)
    ret = processVerticalNbrsHelper(height, tx, ty, z, ret, all, enumFlags, not adjustForCorner and "WallSlab" or "RoomCorner")
  end
  if sideFlag == SlabNeighbourMask.Top then
    for w = 1, width do
      local tx, ty, tz = getNbrPosHelper(x, y, z, w, width, height + 1, side, adjustForCorner)
      ret = processPosHelper(tx, ty, tz, ret, all, enumFlags, not adjustForCorner and "WallSlab" or "RoomCorner")
    end
  end
  if sideFlag == SlabNeighbourMask.Bottom then
    for w = 1, width do
      local tx, ty, tz = getNbrPosHelper(x, y, z, w, width, 0, side, adjustForCorner)
      ret = processPosHelper(tx, ty, tz, ret, all, enumFlags, not adjustForCorner and "WallSlab" or "RoomCorner")
    end
  end
  return ret
end
local getNbrAroundCornerPosHelper = function(x, y, z, w, width, h, side)
  local tx, ty, tz
  local wf = w - width / 2 - (width % 2 == 0 and 0 or 1)
  local sign = wf / abs(wf)
  tz = z + (h - 1) * voxelSizeZ
  if side == "East" then
    tx = x
    ty = y - wf * voxelSizeY + halfVoxelSizeY * sign
    return tx + halfVoxelSizeX, ty, tz, tx - halfVoxelSizeX, ty, tz
  elseif side == "West" then
    tx = x
    ty = y + wf * voxelSizeY - halfVoxelSizeY * sign
    return tx + halfVoxelSizeX, ty, tz, tx - halfVoxelSizeX, ty, tz
  elseif side == "North" then
    tx = x - wf * voxelSizeX + halfVoxelSizeX * sign
    ty = y
    return tx, ty + halfVoxelSizeY, tz, tx, ty - halfVoxelSizeY, tz
  else
    tx = x + wf * voxelSizeX - halfVoxelSizeX * sign
    ty = y
    return tx, ty + halfVoxelSizeY, tz, tx, ty - halfVoxelSizeY, tz
  end
end
function SlabWallObject:GetNeighboursAroundCorner(sideFlag)
  local ret
  local side = self.side
  local width = Max(self.width, 1)
  local height = self.height
  local x, y, z = self:GetPosXYZ()
  local enumFlags, all
  z = z or terrain.GetHeight(x, y)
  if sideFlag == SlabNeighbourMask.Left then
    local tx1, ty1, _, tx2, ty2, _ = getNbrAroundCornerPosHelper(x, y, z, 0, width, height, side)
    ret = processVerticalNbrsHelper(height, tx1, ty1, z, ret, all, enumFlags, "WallSlab")
    ret = processVerticalNbrsHelper(height, tx2, ty2, z, ret, all, enumFlags, "WallSlab")
  end
  if sideFlag == SlabNeighbourMask.Right then
    local tx1, ty1, _, tx2, ty2, _ = getNbrAroundCornerPosHelper(x, y, z, width + 1, width, height, side)
    ret = processVerticalNbrsHelper(height, tx1, ty1, z, ret, all, enumFlags, "WallSlab")
    ret = processVerticalNbrsHelper(height, tx2, ty2, z, ret, all, enumFlags, "WallSlab")
  end
  local swos = false
  for i = #(ret or ""), 1, -1 do
    local ws = ret[i]
    if not ws.isVisible then
      table.remove(ret, i)
      if ws.wall_obj then
        swos = swos or {}
        swos[ws.wall_obj] = true
      end
    end
  end
  for swo, _ in pairs(swos or empty_table) do
    table.insert(ret, swo)
  end
  return ret
end
function SlabWallObject:GetNeighbourWindow(sideFlag)
  local ret
  local retIsTable = false
  local wallNbrs = self:GetNeighbourWallSlab(sideFlag, "all", ~const.efVisible)
  if wallNbrs and 0 < #wallNbrs then
    for i = 1, #wallNbrs do
      local nbr = wallNbrs[i]
      if nbr.wall_obj then
        if not ret then
          ret = nbr.wall_obj
        elseif not retIsTable and ret ~= nbr.wall_obj then
          ret = {ret}
          table.insert_unique(ret, nbr.wall_obj)
          retIsTable = true
        elseif retIsTable then
          table.insert_unique(ret, nbr.wall_obj)
        end
      end
    end
  end
  return ret
end
function SlabWallObject:IsStructuralSlab()
  if self:IsGrounded() or self.force_structural then
    return true
  end
  local lo = self:GetLeftOffset()
  local ro = self:GetRightOffset()
  local vx, vy, vz, a = WallWorldToVoxel(self)
  local s = slabAngleToDir[self:GetAngle()]
  local min, max
  if s == "North" then
    min = vx - ro
    max = vx + lo + 1
  elseif s == "South" then
    min = vx - lo
    max = vx + ro + 1
  elseif s == "West" then
    min = vy - lo
    max = vy + ro + 1
  elseif s == "East" then
    min = vy - ro
    max = vy + lo + 1
  end
  for i = min, max do
    if IsStructuralRow(i) then
      return true
    end
  end
  return false
end
function SlabWallObject:IsStructuralRow(sideFlag)
  local vx, vy, vz, a = WallWorldToVoxel(self)
  local s = slabAngleToDir[self:GetAngle()]
  local lo = self:GetLeftOffset()
  local ro = self:GetRightOffset()
  if s == "North" then
    if sideFlag == SlabNeighbourMask.Left then
      return IsStructuralRow(vx + lo + 1)
    elseif sideFlag == SlabNeighbourMask.Right then
      return IsStructuralRow(vx - ro)
    end
  elseif s == "South" then
    if sideFlag == SlabNeighbourMask.Left then
      return IsStructuralRow(vx - lo)
    elseif sideFlag == SlabNeighbourMask.Right then
      return IsStructuralRow(vx + ro + 1)
    end
  elseif s == "West" then
    if sideFlag == SlabNeighbourMask.Left then
      return IsStructuralRow(vy - lo)
    elseif sideFlag == SlabNeighbourMask.Right then
      return IsStructuralRow(vy + ro + 1)
    end
  elseif s == "East" then
    if sideFlag == SlabNeighbourMask.Left then
      return IsStructuralRow(vy + lo + 1)
    elseif sideFlag == SlabNeighbourMask.Right then
      return IsStructuralRow(vy - ro)
    end
  end
  return false
end
function DestroyableFloorSlab:IsStructuralSlab()
  return self:IsInvulnerable() or self.force_structural or self:IsGrounded()
end
function DestroyableFloorSlab:GetNeighbourWallSlab(sideFlag)
  local x, y, z = self:GetPosXYZ()
  if sideFlag == SlabNeighbourMask.Left then
    return MapGetFirst(x, y + halfVoxelSizeY, z, 0, "WallSlab", nil, const.efVisible)
  elseif sideFlag == SlabNeighbourMask.Right then
    return MapGetFirst(x, y - halfVoxelSizeY, z, 0, "WallSlab", nil, const.efVisible)
  elseif sideFlag == SlabNeighbourMask.Top then
    return MapGetFirst(x - halfVoxelSizeX, y, z, 0, "WallSlab", nil, const.efVisible)
  elseif sideFlag == SlabNeighbourMask.Bottom then
    return MapGetFirst(x + halfVoxelSizeX, y, z, 0, "WallSlab", nil, const.efVisible)
  end
  return false
end
function DestroyableFloorSlab:GetNeighbour(sideFlag)
  local vx, vy, vz = WorldToVoxel(self)
  if sideFlag == SlabNeighbourMask.Left then
    return GetFloorAlignedObj(vx, vy + 1, vz, self.class)
  end
  if sideFlag == SlabNeighbourMask.Right then
    return GetFloorAlignedObj(vx, vy - 1, vz, self.class)
  end
  if sideFlag == SlabNeighbourMask.Top then
    return GetFloorAlignedObj(vx - 1, vy, vz, self.class)
  end
  if sideFlag == SlabNeighbourMask.Bottom then
    return GetFloorAlignedObj(vx + 1, vy, vz, self.class)
  end
end
function DestroyableFloorSlab:GetStairNeighbours()
  local ret
  local vx, vy, vz = WorldToVoxel(self)
  local cls = "StairSlab"
  local add = function(val)
    if val then
      ret = ret or {}
      ret[#ret + 1] = val
    end
  end
  add(GetFloorAlignedObj(vx, vy + 1, vz, cls))
  add(GetFloorAlignedObj(vx, vy + 1, vz + 1, cls))
  add(GetFloorAlignedObj(vx, vy - 1, vz, cls))
  add(GetFloorAlignedObj(vx, vy - 1, vz + 1, cls))
  add(GetFloorAlignedObj(vx - 1, vy, vz, cls))
  add(GetFloorAlignedObj(vx - 1, vy, vz + 1, cls))
  add(GetFloorAlignedObj(vx + 1, vy, vz, cls))
  add(GetFloorAlignedObj(vx + 1, vy, vz + 1, cls))
  return ret
end
function DestroyableFloorSlab:GetNeighbours()
  local vx, vy, vz = WorldToVoxel(self)
  local cls = self.class
  local left = GetFloorAlignedObj(vx, vy + 1, vz, cls)
  local right = GetFloorAlignedObj(vx, vy - 1, vz, cls)
  local top = GetFloorAlignedObj(vx - 1, vy, vz, cls)
  local bottom = GetFloorAlignedObj(vx + 1, vy, vz, cls)
  return left, right, top, bottom
end
function RoomCorner:GetNeighbourWallSlab(sideFlag, all, enumFlags)
  local s = self.side or slabAngleToDir[self:GetAngle()]
  local x, y, z = self:GetPosXYZ()
  enumFlags = enumFlags == nil and const.efVisible or enumFlags
  if sideFlag == SlabNeighbourMask.Left then
    local offs = wallSidewaysOffsets[s]
    return not all and MapGetFirst(x + offs.x * halfVoxelSizeX, y + offs.y * halfVoxelSizeY, z, 0, "WallSlab", nil, enumFlags) or all and (MapGet(x + offs.x * halfVoxelSizeX, y + offs.y * halfVoxelSizeY, z, 0, "WallSlab", nil, enumFlags) or empty_table)
  end
  if sideFlag == SlabNeighbourMask.Right then
    local offs = wallSidewaysOffsets[s]
    return not all and MapGetFirst(x - offs.y * halfVoxelSizeX, y + offs.x * halfVoxelSizeY, z, 0, "WallSlab", nil, enumFlags) or all and (MapGet(x - offs.y * halfVoxelSizeX, y + offs.x * halfVoxelSizeY, z, 0, "WallSlab", nil, enumFlags) or empty_table)
  end
end
RoomCorner.GetNeighbourWindow = WallSlab.GetNeighbourWindow
function RoomCorner:GetNeighbour(sideFlag, all, enumFlags)
  enumFlags = enumFlags == nil and const.efVisible or enumFlags
  local x, y, z = self:GetPosXYZ()
  if sideFlag == SlabNeighbourMask.Top then
    return not all and MapGetFirst(x, y, z + voxelSizeZ, 0, "RoomCorner", nil, enumFlags) or all and MapGet(x, y, z + voxelSizeZ, 0, "RoomCorner", nil, enumFlags)
  end
  if sideFlag == SlabNeighbourMask.Bottom then
    return not all and MapGetFirst(x, y, z - voxelSizeZ, 0, "RoomCorner", nil, enumFlags) or all and MapGet(x, y, z - voxelSizeZ, 0, "RoomCorner", nil, enumFlags)
  end
  return nil
end
function RoomCorner:GetNeighbours()
  return self:GetNeighbourWallSlab(SlabNeighbourMask.Left, "all"), self:GetNeighbourWallSlab(SlabNeighbourMask.Right, "all"), self:GetNeighbour(SlabNeighbourMask.Top, "all"), self:GetNeighbour(SlabNeighbourMask.Bottom, "all")
end
DefineClass.Destroyable = {
  __parents = {"Object"},
  properties = {
    {
      id = "is_destroyed",
      editor = "bool",
      default = false,
      no_edit = true
    }
  }
}
function Destroyable:SetupFlags()
end
AutoResolveMethods.OnDestroy = "call"
Destroyable.OnDestroy = empty_func
function Destroyable:Destroy()
  self.is_destroyed = true
  if not IsEditorActive() then
    self:PlayDestructionFX()
  end
  self:OnDestroy()
end
function Destroyable:Repair()
  self.is_destroyed = false
end
local touch = function(o, touchedSlabs)
  if IsValid(o) and not o.is_destroyed then
    touchedSlabs[o] = true
  end
end
local touchd = function(o, touchedDestroyedSlabs)
  if IsValid(o) and o.is_destroyed then
    touchedDestroyedSlabs[o] = true
  end
end
local processRepairedRoofEdgeNbrHelper = function(slab, sideFlag, touchedDestroyedSlabs, touchedSlabs, corner)
  local e = slab:GetNeighbourEdge(sideFlag, corner)
  if e and e.is_destroyed then
    e:Repair()
  end
end
local processRoofEdgeNbrHelper = function(slab, sideFlag, touchedDestroyedSlabs, touchedSlabs, corner)
  local e = slab:GetNeighbourEdge(sideFlag, corner)
  if e then
    if e.is_destroyed then
      touchedDestroyedSlabs[e] = true
    else
      e:Destroy()
    end
  end
end
local function _processCornerNbrHelper(c, slab, sideFlag, touchedDestroyedSlabs, touchedSlabs)
  if IsValid(c) then
    if c.is_destroyed then
      touchedDestroyedSlabs[c] = true
      local otherWall = c:GetNeighbourWallSlab(sideFlag) or c:GetNeighbourWindow(sideFlag)
      if otherWall then
        touchedDestroyedSlabs[otherWall] = true
      end
    else
      local s = slab.side or slabAngleToDir[slab:GetAngle()]
      local isStructuralCorner = (s == "North" or s == "South") and slab:IsStructuralRow(sideFlag) or false
      if not isStructuralCorner then
        local otherWall = c:GetNeighbourWallSlab(sideFlag) or c:GetNeighbourWindow(sideFlag)
        if otherWall then
          local osf = maskToOppositeMask[sideFlag]
          s = otherWall.side or slabAngleToDir[otherWall:GetAngle()]
          isStructuralCorner = (s == "North" or s == "South") and otherWall:IsStructuralRow(osf) or false
          if not isStructuralCorner and otherWall.is_destroyed then
            c:Destroy()
            touchedDestroyedSlabs[otherWall] = true
          else
            touch(otherWall, touchedSlabs)
          end
        else
          c:Destroy()
        end
      end
    end
  elseif type(c) == "table" then
    for i = 1, #c do
      _processCornerNbrHelper(c[i], slab, sideFlag, touchedDestroyedSlabs, touchedSlabs)
    end
  end
end
local processCornerNbrHelper = function(slab, sideFlag, touchedDestroyedSlabs, touchedSlabs)
  local c = slab:GetNeighbourCorner(sideFlag, "all")
  _processCornerNbrHelper(c, slab, sideFlag, touchedDestroyedSlabs, touchedSlabs)
end
local function _processRepairedCornerNbrHelper(c, slab, sideFlag, touchedDestroyedSlabs, touchedSlabs)
  if IsValid(c) then
    if c.is_destroyed then
      c:Repair()
      local otherWall = c:GetNeighbourWallSlab(sideFlag)
      if otherWall then
        if otherWall.is_destroyed then
          touchedDestroyedSlabs[otherWall] = true
        else
          touch(otherWall, touchedSlabs)
        end
      end
    end
  elseif type(c) == "table" then
    for i = 1, #c do
      _processRepairedCornerNbrHelper(c[i], slab, sideFlag, touchedDestroyedSlabs, touchedSlabs)
    end
  end
end
local processRepairedCornerNbrHelper = function(slab, sideFlag, touchedDestroyedSlabs, touchedSlabs)
  local c = slab:GetNeighbourCorner(sideFlag, "all")
  _processRepairedCornerNbrHelper(c, slab, sideFlag, touchedDestroyedSlabs, touchedSlabs)
end
local function _processRepairedNbr(n, sideFlag, touchedDestroyedSlabs, touchedSlabs, slab)
  if IsValid(n) then
    local osf = GetNeigbhourSideFlagTowardMe(sideFlag, n, slab)
    n.destroyed_neighbours = n.destroyed_neighbours & ~osf
    if n.is_destroyed then
      touchedDestroyedSlabs[n] = true
    else
      touch(n, touchedSlabs)
    end
  elseif type(n) == "table" then
    for i = 1, #n do
      _processRepairedNbr(n[i], sideFlag, touchedDestroyedSlabs, touchedSlabs, slab)
    end
  end
end
local processRepairedNbr = function(slab, sideFlag, touchedDestroyedSlabs, touchedSlabs)
  local n = slab:GetNeighbour(sideFlag, "all")
  _processRepairedNbr(n, sideFlag, touchedDestroyedSlabs, touchedSlabs, slab)
  return IsValid(n) or #(n or "") > 0
end
function processStackedRoofWalls(slab, method)
  MapForEach(slab, 0, slab.class, nil, const.efVisible, function(other, slab, method)
    if other ~= slab then
      other[method](other)
    end
  end, slab, method)
end
local processStackedRoofs = function(slab, method)
  if slab:GetClipPlane() ~= 0 then
    MapForEach(slab, 0, slab.class, nil, const.efVisible, function(obj, slab, method)
      if obj ~= slab then
        obj[method](obj)
      end
    end, slab, method)
    if slab.room then
      local other = MapGetFirst(slab, 1, slab.class, nil, const.efVisible, function(o)
        return o.roof_comp == "Gable"
      end)
      if other then
        other[method](other)
      end
    end
  end
end
local destroyRoffWallsHelper = function(x, y, z, method)
  local others = MapGet(x, y, z, 0, "RoofWallSlab", nil, const.efVisible)
  for i = 1, #(others or "") do
    local o = others[i]
    if o:GetClipPlane() ~= 0 then
      o[method](o)
    end
  end
end
local processWallsBelowEaves = function(slab, method)
  local x, y, z = slab:GetPosXYZ()
  z = snapZ(z)
  destroyRoffWallsHelper(x, y, z, method)
  local bz = snapZ(z - 1)
  destroyRoffWallsHelper(x, y, bz, method)
  local rp = slab:GetRelativePoint(point(0, -halfVoxelSizeY, 0))
  destroyRoffWallsHelper(rp:x(), rp:y(), z, method)
  destroyRoffWallsHelper(rp:x(), rp:y(), bz, method)
  local rp = slab:GetRelativePoint(point(0, halfVoxelSizeY, 0))
  destroyRoffWallsHelper(rp:x(), rp:y(), z, method)
  destroyRoffWallsHelper(rp:x(), rp:y(), bz, method)
end
local processWallsBelowRoofPlanes = function(slab, method)
  local x, y, z = slab:GetPosXYZ()
  local a = slab:GetAngle()
  local flipped = a % 10800 ~= 0
  local lx, ly, rx, ry
  if not flipped then
    ly = y + halfVoxelSizeY
    ry = y - halfVoxelSizeY
    rx = x
    lx = x
  else
    lx = x - halfVoxelSizeX
    rx = x + halfVoxelSizeX
    ry = y
    ly = y
  end
  z = snapZ(z)
  destroyRoffWallsHelper(lx, ly, z, method)
  destroyRoffWallsHelper(rx, ry, z, method)
  local bz = snapZ(z - 1)
  destroyRoffWallsHelper(lx, ly, bz, method)
  destroyRoffWallsHelper(rx, ry, bz, method)
  if not flipped then
    local ox = x - halfVoxelSizeX
    destroyRoffWallsHelper(ox, ly, z, method)
    destroyRoffWallsHelper(ox, ly, bz, method)
    destroyRoffWallsHelper(ox, ry, z, method)
    destroyRoffWallsHelper(ox, ry, bz, method)
    ox = x + halfVoxelSizeX
    destroyRoffWallsHelper(ox, ly, z, method)
    destroyRoffWallsHelper(ox, ly, bz, method)
    destroyRoffWallsHelper(ox, ry, z, method)
    destroyRoffWallsHelper(ox, ry, bz, method)
  else
    local oy = y - halfVoxelSizeY
    destroyRoffWallsHelper(lx, oy, z, method)
    destroyRoffWallsHelper(lx, oy, bz, method)
    destroyRoffWallsHelper(rx, oy, z, method)
    destroyRoffWallsHelper(rx, oy, bz, method)
    oy = y + halfVoxelSizeY
    destroyRoffWallsHelper(lx, oy, z, method)
    destroyRoffWallsHelper(lx, oy, bz, method)
    destroyRoffWallsHelper(rx, oy, z, method)
    destroyRoffWallsHelper(rx, oy, bz, method)
  end
end
local processGableEdges = function(slab, method)
  local cls
  local mp = slab:GetPos()
  local s = slabAngleToDir[slab:GetAngle()]
  local offs = wallSidewaysOffsets[s]
  if IsKindOf(slab, "RoofPlaneSlab") then
    cls = "RoofEdgeSlab"
  elseif IsKindOf(slab, "RoofEdgeSlab") then
    cls = "RoofCorner"
  end
  local l = MapGetFirst(mp:x() + offs.x * halfVoxelSizeX, mp:y() + offs.y * halfVoxelSizeY, mp:z(), 0, cls, nil, const.efVisible)
  local r = MapGetFirst(mp:x() - offs.x * halfVoxelSizeX, mp:y() - offs.y * halfVoxelSizeY, mp:z(), 0, cls, nil, const.efVisible)
  if l then
    l[method](l)
  end
  if r then
    r[method](r)
  end
end
local maxDist = voxelSizeZ * 2
function WallSlab:TryGetAdjacentRoofPlane(aboveOnly)
  local offs = point(-halfVoxelSizeX, 0, 0)
  local f = self:GetRelativePoint(offs)
  local _, _, selfZ = self:GetPosXYZ()
  local roof = MapGetFirst(f, 1, "RoofPlaneSlab", nil, const.efVisible, function(o, self, selfZ)
    return o.roof_comp == "Plane" and (not (self.room and o.room ~= self.room and o.room) or o.room:IsRoofOnly() and not self.room:HasRoofSet()) and (not aboveOnly or selfZ <= o:GetPos():z())
  end, self, selfZ)
  return roof and IsCloser(roof, f, maxDist) and roof or false
end
function WallSlab:TryGetAdjacentRoofPlaneInFront()
  local offs = point(halfVoxelSizeX, 0, 0)
  local f = self:GetRelativePoint(offs)
  local _, _, selfZ = self:GetPosXYZ()
  local roof = MapGetFirst(f, 1, "RoofPlaneSlab", nil, const.efVisible, function(o, self, selfZ)
    local _, _, oz = o:GetPosXYZ()
    return o.roof_comp == "Plane" and (not o.room or o.room:IsRoofOnly()) and selfZ <= oz and oz < selfZ + voxelSizeZ
  end, self, selfZ)
  return roof
end
RoofEdgeSlab.TryGetAdjacentRoofPlane = WallSlab.TryGetAdjacentRoofPlane
function ShouldDoDestructionPass()
  return not (#DestroyedCOThisTick <= 0) or not (0 >= #RepairedSlabsThisTick) or not (0 >= #DestroyedSlabsThisTick) or not (0 >= #DestroyedObjectsThisTick)
end
local debrisThisTick = 0
function ProcessDestroyedObjectsThisTick()
  if not ShouldDoDestructionPass() then
    return
  end
  SuspendPassEdits("ProcessDestroyedObjectsThisTick")
  local allDestroyed = {}
  debrisThisTick = 0
  while 0 < #DestroyedSlabsThisTick or 0 < #RepairedSlabsThisTick do
    table.iappend(allDestroyed, ProcessDestroyedSlabsThisTick())
  end
  local c = #allDestroyed
  if 0 < c then
    local fxPos = AveragePoint(allDestroyed)
    local fxAction = c < 5 and "BulkDestructionSmall" or c < 9 and "BulkDestructionMedium" or "BulkDestructionLarge"
    PlayFX(fxAction, "start", nil, nil, fxPos)
  end
  ProcessDestroyedGenericObjectsThisTick()
  ProcessDestroyedCOThisTick()
  ResumePassEdits("ProcessDestroyedObjectsThisTick")
  Msg("DestructionPassDone")
end
function ProcessDestroyedGenericObjectsThisTick()
end
function ProcessDestroyedCOThisTick()
  if #DestroyedCOThisTick <= 0 then
    return
  end
  DoneObjects(DestroyedCOThisTick)
  DestroyedCOThisTick = {}
end
local TouchNonDestroyedNeighbours = function(o, touchedSlabs)
  local nbrs = {
    o:GetNeighbours()
  }
  local function porcessNeighbours(lst)
    if IsValid(lst) then
      if not lst.is_destroyed then
        touch(lst, touchedSlabs)
      end
    else
      for i, nbr in ipairs(lst) do
        porcessNeighbours(nbr)
      end
    end
  end
  for _, lst in ipairs(nbrs) do
    porcessNeighbours(lst)
  end
end
function ProcessObjectsAroundSlabs(destroyedFloorBoxes, destroyedFloorMap, destroyedWallBoxes, destroyedRoofBoxes)
end
local point21 = point(1, 1, 0)
function ProcessDestroyedSlabsThisTick()
  if #RepairedSlabsThisTick <= 0 and 0 >= #DestroyedSlabsThisTick then
    return
  end
  local lst = DestroyedSlabsThisTick
  local touchedSlabs = {}
  local touchedDestroyedSlabs = {}
  DestroyedSlabsThisTick = {}
  local destroyedFloorMap = {}
  local destroyedFloorBoxes = {}
  local function AddFloorBox(box)
    local nb = box:grow(1)
    for i = 1, #destroyedFloorBoxes do
      local ob = destroyedFloorBoxes[i]
      local ir = ob:Intersect(nb)
      if ir == const.irInside or ob == nb then
        return
      end
      if ir ~= const.irOutside then
        local nb = AddRects(ob, box)
        table.remove(destroyedFloorBoxes, i)
        AddFloorBox(nb)
        return
      end
    end
    table.insert(destroyedFloorBoxes, box)
  end
  local appendBoxToBoxContainer = function(box, boxContainer)
    local x, y, z = box:sizexyz()
    for i, otherBox in ipairs(boxContainer) do
      local nb = AddRects(box, otherBox)
      local ox, oy, oz = otherBox:sizexyz()
      local nx, ny, nz = nb:sizexyz()
      if nz <= oz + z and (nx == x and ny <= oy + y + 1 or ny == y and nx <= ox + x + 1) then
        boxContainer[i] = nb
        return i
      end
    end
    table.insert(boxContainer, box)
    return #boxContainer
  end
  local extrudeBoxWith = 200
  local destroyedWallBoxes = {}
  local destroyedWallBoxesOnTop = {}
  local AddWallBox = function(box, growZ)
    local x, y, z = box:sizexyz()
    growZ = growZ or 0
    if x < y then
      box = box:grow(extrudeBoxWith, 0, growZ)
    elseif y < x then
      box = box:grow(0, extrudeBoxWith, growZ)
    else
      box = box:grow(extrudeBoxWith, extrudeBoxWith, growZ)
    end
    local i = appendBoxToBoxContainer(box, destroyedWallBoxes)
    if 0 < growZ then
      destroyedWallBoxesOnTop[i] = true
    end
  end
  local destroyedRoofBoxes = {}
  local AddRoofBox = function(b, slab)
    local z = slab.room and slab.room.roof_box:minz() or b:minz() - extrudeBoxWith
    b = box((b:min() + point21):SetZ(z), (b:max() + point21):AddZ(extrudeBoxWith))
    appendBoxToBoxContainer(b, destroyedRoofBoxes)
  end
  local roomsWithDestroyedRoofPlaneSlabs = {}
  local roomsWithDestroyedRoofEdgeSlabs = {}
  local roomsWithDestroyedSlabs = {}
  local inEditor = IsEditorActive()
  local i = 1
  while i <= #lst do
    local slab = lst[i]
    slab:SetDestroyedState(inEditor)
    touchedDestroyedSlabs[slab] = true
    if slab.room then
      roomsWithDestroyedSlabs[slab.room] = true
    end
    local ured = slab.use_replace_ent_destruction
    local left, right, top, bottom = slab:GetNeighbours()
    local function processNeighbours(o, sideFlag, touchedDestroyedSlabs, touchedSlabs)
      if IsValid(o) then
        if not ured then
          local f = GetNeigbhourSideFlagTowardMe(sideFlag, o, slab)
          o.destroyed_neighbours = o.destroyed_neighbours | f
        end
        if o.is_destroyed then
          touchedDestroyedSlabs[o] = true
          if o:GetStateText():starts_with("broken") then
            TouchNonDestroyedNeighbours(o, touchedSlabs)
          end
          if rawget(o, "always_visible") then
            touchd(MapGetFirst(o, 0, "SlabWallObject"), touchedDestroyedSlabs)
          end
        else
          touch(o, touchedSlabs)
        end
      elseif type(o) == "table" then
        for i = 1, #o do
          processNeighbours(o[i], sideFlag, touchedDestroyedSlabs, touchedSlabs)
        end
      end
    end
    local destroyAndPush = function(s)
      if IsValid(s) and not s.is_destroyed then
        touchedDestroyedSlabs[s] = true
        s:Destroy()
      end
    end
    if IsKindOf(slab, "WallSlab") then
      local ventWindowOwned = slab.always_visible
      if IsKindOf(slab, "RoofWallSlab") or ventWindowOwned then
        processStackedRoofWalls(slab, "Destroy")
      end
      if ventWindowOwned then
        local w = MapGetFirst(slab, 0, "SlabWallObject")
        if w and not w.is_destroyed then
          w:Destroy()
        end
      end
      local nbr = slab:TryGetAdjacentRoofPlane()
      touch(nbr, touchedSlabs)
      processCornerNbrHelper(slab, SlabNeighbourMask.Left, touchedDestroyedSlabs, touchedSlabs)
      processCornerNbrHelper(slab, SlabNeighbourMask.Right, touchedDestroyedSlabs, touchedSlabs)
      local offs = point(halfVoxelSizeX, 0, 0)
      local f = slab:GetRelativePoint(offs)
      local floor = MapGetFirst(f, 0, "FloorSlab", "CeilingSlab", nil, const.efVisible)
      destroyAndPush(floor)
      f = slab:GetRelativePoint(-offs)
      floor = MapGetFirst(f, 0, "FloorSlab", "CeilingSlab", nil, const.efVisible)
      destroyAndPush(floor)
      local lnbr1, lnbr2 = slab:GetNeighboursAroundCorner(SlabNeighbourMask.Left)
      local rnbr1, rnbr2 = slab:GetNeighboursAroundCorner(SlabNeighbourMask.Right)
      if IsValid(left) or 0 < #(left or "") then
        destroyAndPush(lnbr1)
        destroyAndPush(lnbr2)
      else
        touchd(lnbr1, touchedDestroyedSlabs)
        touchd(lnbr2, touchedDestroyedSlabs)
      end
      if IsValid(right) or 0 < #(right or "") then
        local nbr1, nbr2 = slab:GetNeighboursAroundCorner(SlabNeighbourMask.Right)
        destroyAndPush(rnbr1)
        destroyAndPush(rnbr2)
      else
        touchd(rnbr1, touchedDestroyedSlabs)
        touchd(rnbr2, touchedDestroyedSlabs)
      end
      AddWallBox(slab:GetObjectBBox(), not top and extrudeBoxWith)
    elseif IsKindOf(slab, "RoofPlaneSlab") and slab.roof_comp ~= "Gable" then
      MapForEach(slab:GetObjectBBox(), "RoofPlaneSlab", function(o, slab)
        if o ~= slab then
          o:Destroy()
        end
      end, slab)
      processStackedRoofs(slab, "Destroy")
      processWallsBelowRoofPlanes(slab, "Destroy")
      for i = 0, 3 do
        processRoofEdgeNbrHelper(slab, 1 << i, touchedDestroyedSlabs, touchedSlabs)
        processRoofEdgeNbrHelper(slab, 1 << i, touchedDestroyedSlabs, touchedSlabs, "corner")
      end
      roomsWithDestroyedRoofPlaneSlabs[slab.room] = true
      AddRoofBox(slab:GetObjectBBox(), slab)
      local ceiling = MapGetFirst(slab, 1, "CeilingSlab", nil, const.efVisible)
      if ceiling then
        local cx, cy, cz = ceiling:GetPosXYZ()
        local sx, sy, sz = slab:GetPosXYZ()
        local range = voxelSizeZ * (slab:GetSeed(2, 2179) + 1)
        if cz <= sz and range >= sz - cz then
          ceiling:Destroy()
        end
      end
    elseif IsKindOf(slab, "RoofEdgeSlab") then
      if slab.roof_comp ~= "Gable" then
        processWallsBelowEaves(slab, "Destroy")
        local nbr = slab:TryGetAdjacentRoofPlane()
        if IsValid(nbr) then
          nbr:Destroy()
        end
      end
      roomsWithDestroyedRoofEdgeSlabs[slab.room] = true
    elseif IsKindOf(slab, "SlabWallObject") then
      processCornerNbrHelper(slab, SlabNeighbourMask.Left, touchedDestroyedSlabs, touchedSlabs)
      processCornerNbrHelper(slab, SlabNeighbourMask.Right, touchedDestroyedSlabs, touchedSlabs)
      AddWallBox(slab:GetObjectBBox())
      for _, nbr in ipairs(slab:GetNeighboursAroundCorner(SlabNeighbourMask.Left) or empty_table) do
        touch(nbr, touchedSlabs)
      end
      for _, nbr in ipairs(slab:GetNeighboursAroundCorner(SlabNeighbourMask.Right) or empty_table) do
        touch(nbr, touchedSlabs)
      end
    elseif IsKindOf(slab, "FloorSlab") then
      destroyedFloorMap[EncodeVoxelPos(slab)] = true
      AddFloorBox(slab:GetObjectBBox())
    elseif IsKindOf(slab, "RoomCorner") then
      AddWallBox(slab:GetObjectBBox(), not top and extrudeBoxWith)
    end
    processNeighbours(left, SlabNeighbourMask.Left, touchedDestroyedSlabs, touchedSlabs)
    processNeighbours(right, SlabNeighbourMask.Right, touchedDestroyedSlabs, touchedSlabs)
    processNeighbours(top, SlabNeighbourMask.Top, touchedDestroyedSlabs, touchedSlabs)
    processNeighbours(bottom, SlabNeighbourMask.Bottom, touchedDestroyedSlabs, touchedSlabs)
    if rawget(slab, "roof_comp") == "Gable" then
      processGableEdges(slab, "Destroy")
    end
    if #DestroyedSlabsThisTick > 0 then
      table.iappend(lst, DestroyedSlabsThisTick)
      DestroyedSlabsThisTick = {}
    end
    i = i + 1
  end
  local processedDestroyedThisPass = lst
  lst = RepairedSlabsThisTick
  RepairedSlabsThisTick = {}
  i = 1
  while i <= #lst do
    local slab = lst[i]
    slab:SetRepairedState()
    touch(slab, touchedSlabs)
    for i = 0, 3 do
      processRepairedNbr(slab, 1 << i, touchedDestroyedSlabs, touchedSlabs)
    end
    if IsKindOf(slab, "WallSlab") then
      if IsKindOf(slab, "RoofWallSlab") then
        processStackedRoofWalls(slab, "Repair")
      end
      processRepairedCornerNbrHelper(slab, SlabNeighbourMask.Right, touchedDestroyedSlabs, touchedSlabs)
      processRepairedCornerNbrHelper(slab, SlabNeighbourMask.Left, touchedDestroyedSlabs, touchedSlabs)
    elseif IsKindOf(slab, "RoofPlaneSlab") and slab.roof_comp ~= "Gable" then
      processStackedRoofs(slab, "Repair")
      processWallsBelowRoofPlanes(slab, "Repair")
      for i = 0, 3 do
        processRepairedRoofEdgeNbrHelper(slab, 1 << i, touchedDestroyedSlabs, touchedSlabs)
        processRepairedRoofEdgeNbrHelper(slab, 1 << i, touchedDestroyedSlabs, touchedSlabs, "corner")
      end
    elseif IsKindOf(slab, "RoofEdgeSlab") and slab.roof_comp ~= "Gable" then
      processWallsBelowEaves(slab, "Repair")
    end
    if rawget(slab, "roof_comp") == "Gable" then
      processGableEdges(slab, "Repair")
    end
    if #RepairedSlabsThisTick > 0 then
      table.iappend(lst, RepairedSlabsThisTick)
      RepairedSlabsThisTick = {}
    end
    i = i + 1
  end
  local connectedSlabs = {}
  local disconnectedSlabs = {}
  local allDestroyed = SlabNeighbourMask.AllDestroyed
  for slab, _ in pairs(touchedSlabs) do
    if IsKindOf(slab, "RoofWallSlab") then
      local x1, y1, z1 = WallVoxelToWorld(WallWorldToVoxel(slab))
      local x2, y2, z2 = slab:GetPosXYZ()
      if x1 ~= x2 or y1 ~= y2 then
        connectedSlabs[slab] = true
      end
    end
    if not IsKindOfClasses(slab, "WallSlab", "FloorSlab", "RoofPlaneSlab", "CeilingSlab", "SlabWallObject", "RoofEdgeSlab", "RoofCorner") then
      connectedSlabs[slab] = true
    elseif IsKindOf(slab, "RoofPlaneSlab") and slab.roof_comp == "Gable" then
      connectedSlabs[slab] = true
    elseif not disconnectedSlabs[slab] and not connectedSlabs[slab] then
      local waveFront = {slab}
      local passed = {}
      local waveIsConnected = false
      local count = 0
      while 0 < #waveFront do
        local nxtSlab = waveFront[#waveFront]
        waveFront[#waveFront] = nil
        waveFront[nxtSlab] = nil
        passed[nxtSlab] = true
        local isLarge = IsKindOf(nxtSlab, "SlabWallObject")
        if not waveIsConnected and (connectedSlabs[nxtSlab] or nxtSlab:IsStructuralSlab()) then
          waveIsConnected = true
          break
        end
        local function pushNbr(nbr)
          if IsValid(nbr) then
            if nbr and (not nbr.is_destroyed or nbr.use_replace_ent_destruction) and not passed[nbr] and not waveFront[nbr] then
              table.insert(waveFront, nbr)
              waveFront[nbr] = true
            end
          elseif type(nbr) == "table" then
            for i = 1, #nbr do
              pushNbr(nbr[i])
            end
          end
        end
        local sm = nxtSlab.destroyed_neighbours
        local topNbr, botNbr, leftNbr, rightNbr
        if sm & SlabNeighbourMask.Top == 0 or isLarge then
          local nbr = nxtSlab:GetNeighbour(SlabNeighbourMask.Top)
          topNbr = nbr
          pushNbr(nbr)
        end
        if sm & SlabNeighbourMask.Left == 0 or isLarge then
          local nbr = nxtSlab:GetNeighbour(SlabNeighbourMask.Left)
          leftNbr = nbr
          pushNbr(nbr)
        end
        local snbr1, snbr2 = nxtSlab:GetNeighboursAroundCorner(SlabNeighbourMask.Left)
        pushNbr(snbr1)
        pushNbr(snbr2)
        if sm & SlabNeighbourMask.Right == 0 or isLarge then
          local nbr = nxtSlab:GetNeighbour(SlabNeighbourMask.Right)
          rightNbr = nbr
          pushNbr(nbr)
        end
        snbr1, snbr2 = nxtSlab:GetNeighboursAroundCorner(SlabNeighbourMask.Right)
        pushNbr(snbr1)
        pushNbr(snbr2)
        if sm & SlabNeighbourMask.Bottom == 0 or isLarge then
          local nbr = nxtSlab:GetNeighbour(SlabNeighbourMask.Bottom)
          botNbr = nbr
          pushNbr(nbr)
        end
        if IsKindOf(nxtSlab, "WallSlab") then
          pushNbr(nxtSlab:GetNeighbourFloor(SlabNeighbourMask.Top))
          pushNbr(nxtSlab:GetNeighbourFloor(SlabNeighbourMask.Bottom))
          if not topNbr then
            local nbr = nxtSlab:TryGetAdjacentRoofPlane("aboveOnly")
            pushNbr(nbr)
          end
          pushNbr(nxtSlab:TryGetAdjacentRoofPlaneInFront())
        elseif IsKindOfClasses(nxtSlab, "RoofPlaneSlab", "DestroyableFloorSlab") then
          if not topNbr then
            pushNbr(nxtSlab:GetNeighbourWallSlab(SlabNeighbourMask.Top))
          end
          if not botNbr then
            pushNbr(nxtSlab:GetNeighbourWallSlab(SlabNeighbourMask.Bottom))
          end
          if not leftNbr then
            pushNbr(nxtSlab:GetNeighbourWallSlab(SlabNeighbourMask.Left))
          end
          if not rightNbr then
            pushNbr(nxtSlab:GetNeighbourWallSlab(SlabNeighbourMask.Right))
          end
          pushNbr(nxtSlab:GetStairNeighbours())
          if IsKindOf(nxtSlab, "RoofPlaneSlab") then
            if not topNbr then
              pushNbr(nxtSlab:GetNeighbourEdge(SlabNeighbourMask.Top))
            end
            if not botNbr then
              pushNbr(nxtSlab:GetNeighbourEdge(SlabNeighbourMask.Bottom))
            end
            if not leftNbr then
              pushNbr(nxtSlab:GetNeighbourEdge(SlabNeighbourMask.Left))
            end
            if not rightNbr then
              pushNbr(nxtSlab:GetNeighbourEdge(SlabNeighbourMask.Right))
            end
          end
        elseif IsKindOf(nxtSlab, "RoofEdgeSlab") then
          pushNbr(nxtSlab:TryGetAdjacentRoofPlane())
          if not leftNbr then
            pushNbr(nxtSlab:GetNeighbourCorner(SlabNeighbourMask.Left))
          end
          if not rightNbr then
            pushNbr(nxtSlab:GetNeighbourCorner(SlabNeighbourMask.Right))
          end
        end
        count = count + 1
      end
      local t = waveIsConnected and connectedSlabs or disconnectedSlabs
      for slab2, _ in pairs(passed) do
        t[slab2] = true
      end
    end
  end
  local destroyed_disconnected = 0
  for slab, _ in sorted_handled_obj_key_pairs(disconnectedSlabs) do
    slab.invulnerable = false
    slab:Destroy()
    destroyed_disconnected = destroyed_disconnected + 1
  end
  if inEditor and 0 < destroyed_disconnected then
    print(string.format("<color 165 0 255>%d slabs were not connected to structural slabs and were destroyed!</color>", destroyed_disconnected))
  end
  for slab, _ in sorted_handled_obj_key_pairs(touchedSlabs) do
    if IsValid(slab) and connectedSlabs[slab] then
      slab:UpdateEntity()
      slab:UpdateVariantEntities()
      slab:UpdateDecorationsDestroyedState()
    end
  end
  for slab, _ in sorted_handled_obj_key_pairs(touchedDestroyedSlabs) do
    if not table.find(DestroyedSlabsThisTick, slab) then
      slab:UpdateEntity()
    end
  end
  for room, _ in pairs(roomsWithDestroyedRoofPlaneSlabs) do
    if room then
      Notify(room, "OnRoofPlaneTilesDestroyed")
    end
  end
  for room, _ in pairs(roomsWithDestroyedRoofEdgeSlabs) do
    if room then
      Notify(room, "OnRoofEdgeTilesDestroyed")
    end
  end
  for room, _ in pairs(roomsWithDestroyedSlabs) do
    Notify(room, "OnSlabsDestroyed")
  end
  ProcessObjectsAroundSlabs(destroyedFloorBoxes, destroyedFloorMap, destroyedWallBoxes, destroyedRoofBoxes, destroyedWallBoxesOnTop)
  if inEditor then
    local sel = editor.GetSel()
    for i = #(sel or ""), 1, -1 do
      local o = sel[i]
      if touchedDestroyedSlabs[o] then
        editor.RemoveObjFromSel(o, true)
      end
    end
  end
  return processedDestroyedThisPass
end
function Volume:CheckInteriorLightingOnDestruction()
  if self.dont_use_interior_lighting or self:IsRoofOnly() then
    return
  end
  if IsEditorActive() then
    return
  end
  local total = 0
  local destroyed = 0
  self:ForEachSpawnedObj(function(o)
    if o.isVisible then
      total = total + 1
      if o.is_destroyed then
        destroyed = destroyed + 1
      end
    end
  end)
  local perc = MulDivRound(destroyed, 100, total)
  if 40 <= perc then
    self:Setdont_use_interior_lighting(true)
  end
end
function Volume:OnSlabsDestroyed()
  self:CheckInteriorLightingOnDestruction()
end
MapGameTimeRepeat("DestructionPP", -1, function()
  WaitWakeup()
  Sleep(0)
  ProcessDestroyedObjectsThisTick()
end)
function WakeUpDestructionPP()
  local editor = IsEditorActive()
  if editor then
    DelayedCall(0, ProcessDestroyedObjectsThisTick)
  else
    Wakeup(PeriodicRepeatThreads.DestructionPP)
  end
end
function AppendDestroyedSlab(obj)
  NetUpdateHash("AppendDestroyedSlab", obj)
  table.insert(DestroyedSlabsThisTick, obj)
  WakeUpDestructionPP()
end
function AppendRepairedSlab(obj)
  table.insert(RepairedSlabsThisTick, obj)
  WakeUpDestructionPP()
end
function DoneCombatObject(obj)
  if IsKindOf(obj, "Unit") or not IsKindOf(obj, "CObject") then
    table.insert(DestroyedCOThisTick, obj)
    WakeUpDestructionPP()
  else
    obj:Destroy()
  end
end
DefineClass.DestroyableSlab = {
  __parents = {
    "Destroyable"
  },
  properties = {
    {
      id = "destroyed_neighbours",
      editor = "number",
      default = 0,
      no_edit = true
    },
    {
      id = "destroyed_entity",
      editor = "string",
      default = false,
      no_edit = true
    },
    {
      id = "destroyed_entity_side",
      editor = "number",
      default = 0,
      no_edit = true
    },
    {
      id = "pre_destruction_subvariant",
      editor = "number",
      default = -1,
      no_edit = true
    },
    {
      id = "da_subvariants",
      editor = "prop_table",
      default = false,
      no_edit = true
    },
    {
      id = "force_destroyed_entity",
      editor = "bool",
      default = false,
      no_edit = true
    },
    {
      category = "Slabs",
      id = "force_no_destroyed_entity",
      name = "Force No Destroyed Entity",
      editor = "bool",
      default = false,
      help = "If true, this slab will never look partially damaged due to neighbour being destroyed."
    },
    {
      category = "Slabs",
      id = "force_structural",
      name = "Force Structural",
      editor = "bool",
      default = false
    },
    {
      category = "Slabs",
      id = "buttons2",
      name = "Buttons",
      editor = "buttons",
      default = false,
      dont_save = true,
      read_only = true,
      buttons = {
        {
          name = "Destroy",
          func = "DestroyFromEditor"
        },
        {name = "Repair", func = "Repair"}
      }
    }
  },
  destroyed_attaches = false,
  diagonal_ent_mask = 0,
  invulnerable = true,
  origin_of_destruction = false,
  play_size_fx = false,
  selection_marker = false,
  collision_mask = false,
  use_replace_ent_destruction = false
}
local EnumNeighbours = function(nbr, func)
  if IsValid(nbr) then
    func(nbr)
  elseif type(nbr) == "table" then
    for i = 1, #nbr do
      func(nbr[i])
    end
  end
end
function DestroyableSlab:ManageSelectionMarker(create)
end
function DestroyableSlab:Setforce_no_destroyed_entity(val)
  self.force_no_destroyed_entity = val
  if val then
    self:Repair()
  else
    local t = {
      self:GetNeighbours()
    }
    for _, nbrs in ipairs(t) do
      EnumNeighbours(nbrs, function(nbr)
        if nbr.is_destroyed then
          AppendDestroyedSlab(nbr)
        end
      end)
    end
  end
end
function DestroyableSlab:RestorePreDestructionSubvariant()
  self.subvariant = self.pre_destruction_subvariant
  self.pre_destruction_subvariant = -1
end
function DestroyableSlab:UnlockSubvariantReversible()
  self.pre_destruction_subvariant = self.subvariant
  self.subvariant = -1
end
function DestroyableSlab:ResetDestroyedState()
  self.is_destroyed = nil
  self.destroyed_neighbours = nil
  self.destroyed_entity = nil
  self.destroyed_entity_side = nil
  self.force_no_destroyed_entity = nil
  self.force_destroyed_entity = nil
  self.da_subvariants = nil
  self.diagonal_ent_mask = nil
  self.use_replace_ent_destruction = nil
  for k, v in pairs(self.destroyed_attaches or empty_table) do
    DoneObject(v)
  end
  self.destroyed_attaches = nil
end
function DestroyableSlab:Die()
  CombatLog("debug", T({
    Untranslated("  <name> was destroyed"),
    name = self:GetLogName()
  }))
  self:Destroy()
end
Slab.Die = DestroyableSlab.Die
RoomCorner.Die = empty_func
function DestroyableSlab:DestroyFromEditor()
  self:SetforceInvulnerableBecauseOfGameRules(false)
  self:Destroy()
end
dbgForceUseDamaged = false
function DestroyableSlab:ShouldUseReplaceEntDestruction()
  if not IsEditorActive() or dbgForceUseDamaged then
    local svd = self:GetMaterialPreset()
    if svd.use_damaged or svd.use_damaged_first_floor and self.floor == 1 then
      return true
    end
  end
end
function DestroyableSlab:Destroy(origin_of_destruction)
  if self.is_destroyed or self:IsInvulnerable() then
    return
  end
  self:UnlockSubvariantReversible()
  self.origin_of_destruction = origin_of_destruction
  Destroyable.Destroy(self)
  self.use_replace_ent_destruction = self:ShouldUseReplaceEntDestruction()
  AppendDestroyedSlab(self)
  self:ManageSelectionMarker(not self.use_replace_ent_destruction)
end
function DestroyableSlab:Repair(dont_propagate)
  if not self.is_destroyed then
    if self.destroyed_entity then
      local side = self.destroyed_entity_side
      local isStacked = IsKindOf(self, "RoofWallSlab")
      local nbrs = self:GetNeighbour(side, isStacked or nil)
      self.destroyed_entity_side = 0
      self.destroyed_entity = false
      self.force_no_destroyed_entity = true
      self.force_destroyed_entity = false
      SuspendPassEdits("DestroyableSlab:Repair")
      if nbrs then
        nbrs = IsValid(nbrs) and {nbrs} or nbrs
        for _, nbr in ipairs(nbrs) do
          if nbr.da_subvariants then
            local f = GetNeigbhourSideFlagTowardMe(side, nbr, self)
            local offset = nbr:GetDestroyedAttachOffset(f, self)
            local id = GetDestroyedSlabAttachId(f, offset)
            nbr.da_subvariants[id] = nil
            if not next(nbr.da_subvariants) then
              nbr.da_subvariants = nil
            end
          end
          nbr:UpdateDestroyedState()
        end
      end
      self:RestorePreDestructionSubvariant()
      self:UpdateEntity()
      self:UpdateVariantEntities()
      if not dont_propagate and isStacked then
        local lst = MapGet(self, 0, self.class)
        for _, slab in ipairs(lst) do
          if slab ~= self then
            slab:Repair("dont_propagate")
          end
        end
      end
      ResumePassEdits("DestroyableSlab:Repair")
    end
    return
  end
  self:RestorePreDestructionSubvariant()
  self.da_subvariants = nil
  self.diagonal_ent_mask = nil
  Destroyable.Repair(self)
  AppendRepairedSlab(self)
  self:ManageSelectionMarker(false)
end
function SlabWallObject:SetDestroyedState()
  DestroyableSlab.SetDestroyedState(self)
  self:UpdateManagedSlabs()
  self:UpdateManagedObj()
  self:DestroyAttaches()
end
function DestroyableFloorSlab:SetDestroyedState(...)
  DestroyableSlab.SetDestroyedState(self, ...)
  if not self.use_replace_ent_destruction then
    self:SetAngle(0)
  end
end
function DestroyableSlab:SetDestroyedState(no_debris)
  self.collision_mask = collision.GetAllowedMask(self)
  self.force_no_destroyed_entity = nil
  self.force_destroyed_entity = nil
  if not no_debris then
    self:SpreadDebris()
  end
  self:DestroyAttaches()
  self.destroyed_attaches = false
  self:ClearEnumFlags(const.efCollision + const.efApplyToGrids)
  collision.SetAllowedMask(self, 0)
  Msg("DestroyableSlabDestroyed", self, no_debris)
end
function DestroyableSlab:SetRepairedState()
  self:DestroyAttaches()
  self.destroyed_attaches = false
  self.use_replace_ent_destruction = false
  self:SetEnumFlags(const.efCollision + const.efApplyToGrids)
  collision.SetAllowedMask(self, self.collision_mask or 0)
  self:SetState("idle")
end
local details_cache = {}
local GetDebrisLOD = function()
  local detail = EngineOptions.ObjectDetail
  local LOD = details_cache[detail]
  if LOD then
    return LOD
  end
  LOD = table.find_value(OptionsData.Options.ObjectDetail, "value", detail).ObjectLODPercents
  details_cache[detail] = LOD
  return LOD
end
function DestroyableSlab:GetDebrisInfo(entity)
  local classes, debris_min, debris_max = GetDebrisInfo(entity or self:GetEntity())
  if not classes then
    return 0
  end
  local LOD = GetDebrisLOD()
  local count = classes and (debris_min + self:Random(debris_max - debris_min + 1)) * LOD / 100 or 0
  local radius = const.DebrisExplodeRadius
  return count, classes, radius
end
function _ENV:SpreadDebris(count, debris_classes, radius, origin_of_destruction)
  PlayFX("SpreadDebris", "explosion", self, self.material)
  local slab_pos = self:GetPos()
  for i = 1, count do
    if not (100 < debrisThisTick) or count % 2 ~= 0 then
      local slot = self:Random(debris_classes.total_weight)
      local idx = GetRandomItemByWeight(debris_classes, slot, "weight")
      local class = debris_classes[idx].class
      local debris = PlaceObject(class)
      debris.spawning_obj = self
      debris:SetColorization(self)
      debris:StartPhase("Explode", slab_pos, radius, origin_of_destruction or self.origin_of_destruction)
      debrisThisTick = debrisThisTick + 1
    end
  end
end
function DestroyableSlab:SpreadDebris()
  MapForEach(self:GetObjectBBox(), "Debris", DoneObject)
  local count, debris_classes, radius = self:GetDebrisInfo()
  if count <= 0 then
    return
  end
  SpreadDebris(self, count, debris_classes, radius)
end
function WallSlab:SpreadDebris()
  MapForEach(self:GetObjectBBox(), "Debris", DoneObject)
  local count, debris_classes, radius = self:GetDebrisInfo()
  if 0 < count then
    SpreadDebris(self, count, debris_classes, radius)
  end
  for _, o in ipairs(self.variant_objects or empty_table) do
    count, debris_classes, radius = self:GetDebrisInfo(o:GetEntity())
    if 0 < count then
      SpreadDebris(o, count, debris_classes, radius, self.origin_of_destruction)
    end
  end
end
const.TestExplodeRadius = voxelSizeX * 2 + 10
function DbgTestExplode(pt, fx)
  if not pt then
    local eye = camera.GetEye()
    local cursor = ScreenToGame(terminal.GetMousePos())
    local sp = eye
    local ep = (cursor - eye) * 1000 + cursor
    local closest = false
    local objs = IntersectObjectsOnSegment(sp, ep, 0, "Slab", function(o)
      if o.isVisible and not o.is_destroyed then
        closest = not closest and o or IsCloser(sp, o, closest) and o or closest
        return true
      end
    end)
    if closest then
      do
        local p1, p2 = ClipSegmentWithBox3D(sp, ep, closest)
        pt = p1 or closest:GetPos()
      end
    end
  end
  pt = pt or GetTerrainCursor()
  if fx then
    local terrainPt = GetExplosionDecalPos(pt)
    local surf_fx_type = GetObjMaterial(pt)
    local fxPt = abs(terrainPt:z() - pt:z()) <= voxelSizeZ * 2 and terrainPt or pt
    PlayFX(fx, "start", "FragGrenade", surf_fx_type, fxPt)
  end
  local to_destroy = {}
  MapForEach(pt, const.TestExplodeRadius + voxelSizeX, "Slab", "CeilingSlab", const.efVisible, 0, 0, function(o, pt, rad)
    if IsCloser(o, pt, rad) then
      table.insert(to_destroy, {
        slab = o,
        dist = o:GetDist(pt)
      })
    end
  end, pt, const.TestExplodeRadius)
  table.sort(to_destroy, function(a, b)
    return a.dist < b.dist
  end)
  for _, descr in ipairs(to_destroy) do
    descr.slab:Destroy(pt)
  end
end
DefineClass.DestroyableWallDecoration = {
  __parents = {
    "Destroyable"
  },
  properties = {
    {
      id = "managed_by_slab",
      editor = "bool",
      default = true,
      no_edit = true
    }
  },
  orig_ent = false
}
function DestroyableWallDecoration:ChangeEntity(ne)
  if self.handle == 1415991251 then
    local a = 9
  end
  self.orig_ent = self.orig_ent or self:GetEntity()
  Destroyable.ChangeEntity(self, ne)
end
function DestroyableWallDecoration:GetNeighbour(sideFlag)
  local x, y, z = self:GetPosXYZ()
  local qx, qy, qz
  local s = slabAngleToDir[self:GetAngle()]
  if sideFlag == SlabNeighbourMask.Left then
    local offs = wallSidewaysOffsets[s]
    qx, qy, qz = x + offs.x * voxelSizeX, y + offs.y * voxelSizeY, z
  elseif sideFlag == SlabNeighbourMask.Right then
    local offs = wallSidewaysOffsets[s]
    qx, qy, qz = x - offs.x * voxelSizeX, y - offs.y * voxelSizeY, z
  elseif sideFlag == SlabNeighbourMask.Top then
    qx, qy, qz = x, y, z + voxelSizeZ
  elseif sideFlag == SlabNeighbourMask.Bottom then
    qx, qy, qz = x, y, z - voxelSizeZ
  else
    return false
  end
  return MapGetFirst(qx, qy, qz, 0, "CObject", function(o)
    return IsKindOf(o, self.class) or o:GetEntity():starts_with("WallDec_")
  end)
end
function DestroyableWallDecoration:GetNeighbours()
  local e = self.orig_ent or self:GetEntity()
  if IsHorizontalDecoration(e) then
    return self:GetNeighbour(SlabNeighbourMask.Left), self:GetNeighbour(SlabNeighbourMask.Right), false, false
  else
    return false, false, self:GetNeighbour(SlabNeighbourMask.Top), self:GetNeighbour(SlabNeighbourMask.Bottom)
  end
end
function DestroyableWallDecoration:Setcolors(val)
  self:SetColorization(val or self:GetDefaultColorizationSet())
end
function DestroyableWallDecoration:Setinterior_attach_colors()
end
function DestroyableWallDecoration:DelayedUpdateEntity()
end
function DestroyableWallDecoration:UpdateVariantEntities()
end
function DestroyableWallDecoration:UpdateEntity()
end
function DestroyableWallDecoration:UnlockSubvariant()
end
function DestroyableWallDecoration:AlignObj()
end
function MakeRoofWallSlabVulnerable()
  MapForEach("map", "RoofWallSlab", function(o)
    if o.room then
      o.invulnerable = false
      o.forceInvulnerableBecauseOfGameRules = false
    end
  end)
end
function EditorDestroyRepairSelectedObjs(destroy, class)
  local fname = destroy and "Destroy" or "Repair"
  local sel = editor.GetSel()
  for _, obj in ipairs(sel) do
    if obj:GetEnumFlags(const.efVisible) ~= 0 and (not class or IsKindOf(obj, class)) and obj:HasMember(fname) then
      obj[fname](obj)
    end
  end
end
