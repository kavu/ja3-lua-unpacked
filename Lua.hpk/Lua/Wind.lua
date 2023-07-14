MapVar("WindModifiersUnitTrail", {})
WindModifiersVegetationMinDistance = 200 * guic
local WindModifiersUnitTrailDistance = 100 * guic
local HarmonicDamping = 500
WindModifierParams = {
  Bullet = {
    HalfHeight = 10 * guic,
    Range = 10 * guic,
    OuterRange = 300 * guic,
    Strength = 500,
    ObjHalfHeight = guim,
    ObjRange = 40 * guic,
    ObjOuterRange = 120 * guic,
    ObjStrength = 1000,
    SizeAttenuation = 5000,
    HarmonicConst = 30000,
    HarmonicDamping = HarmonicDamping,
    WindModifierMask = -1
  },
  Explosion = {
    HalfHeight = 10 * guic,
    Range = 10,
    OuterRange = 3000,
    Strength = 0,
    ObjHalfHeight = 10 * guic,
    ObjRange = 600,
    ObjOuterRange = 2000,
    ObjStrength = 14000,
    SizeAttenuation = 5000,
    HarmonicConst = 15000,
    HarmonicDamping = HarmonicDamping,
    WindModifierMask = -1
  },
  Human_Bush = {
    AttachOffset = point(0, 0, 210 * guic),
    HalfHeight = 120 * guic,
    Range = 30 * guic,
    OuterRange = 50 * guic,
    Strength = 3000,
    ObjHalfHeight = 50 * guic,
    ObjRange = 10 * guic,
    ObjOuterRange = 120 * guic,
    ObjStrength = 10000,
    SizeAttenuation = 5000,
    HarmonicConst = 20000,
    HarmonicDamping = HarmonicDamping,
    WindModifierMask = const.WindModifierMaskBush
  },
  Human_Corn = {
    AttachOffset = point(0, 0, 210 * guic),
    HalfHeight = 200 * guic,
    Range = 30 * guic,
    OuterRange = 120 * guic,
    Strength = 3000,
    ObjHalfHeight = 50 * guic,
    ObjRange = 50 * guic,
    ObjOuterRange = 80 * guic,
    ObjStrength = 10000,
    SizeAttenuation = 5000,
    HarmonicConst = 20000,
    HarmonicDamping = HarmonicDamping,
    WindModifierMask = const.WindModifierMaskCorn
  },
  Human_Grass = {
    AttachOffset = point(0, 0, 30 * guic),
    HalfHeight = 50 * guic,
    Range = 20 * guic,
    OuterRange = 50 * guic,
    Strength = 3000,
    ObjHalfHeight = 50 * guic,
    ObjRange = 20 * guic,
    ObjOuterRange = 60 * guic,
    ObjStrength = 600,
    SizeAttenuation = 5000,
    HarmonicConst = 4000,
    HarmonicDamping = HarmonicDamping,
    WindModifierMask = const.WindModifierMaskGrass
  }
}
local SetWindModifier = function(params_id, pos, range_mod)
  local params = WindModifierParams[params_id]
  terrain.SetWindModifier(pos or params.AttachOffset or point30, params.HalfHeight, range_mod and MulDivRound(params.Range, range_mod, 1000) or params.Range, range_mod and MulDivRound(params.OuterRange, range_mod, 1000) or params.OuterRange, params.Strength, params.ObjHalfHeight, range_mod and MulDivRound(params.ObjRange, range_mod, 1000) or params.ObjRange, range_mod and MulDivRound(params.ObjOuterRange, range_mod, 1000) or params.ObjOuterRange, params.ObjStrength, params.SizeAttenuation, params.HarmonicConst, params.HarmonicDamping, 0, 0, params.WindModifierMask or -1)
end
function PlaceWindModifierExplosion(pos, radius)
  SetWindModifier("Explosion", pos, radius)
end
function PlaceWindModifierBullet(pos)
  SetWindModifier("Bullet", pos)
end
local PlaceUnitTrailWindModifier = function(unit)
  if not unit:GetVisible() then
    return
  end
  local pos = unit:GetVisualPos()
  SetWindModifier("Human_Bush", pos)
  SetWindModifier("Human_Corn", pos)
  SetWindModifier("Human_Grass", pos)
end
function PlaceUnitWindModifierTrail(unit)
  unit.place_wind_mod_trails = true
  if IsValidThread(WindModifiersUnitTrail[unit]) then
    return
  end
  WindModifiersUnitTrail[unit] = CreateGameTimeThread(function(unit)
    while IsValid(unit) do
      PlaceUnitTrailWindModifier(unit)
      if not unit.place_wind_mod_trails then
        WindModifiersUnitTrail[unit] = nil
        return
      end
      local speed = unit:GetSpeed()
      if 0 < speed then
        Sleep(MulDivRound(WindModifiersUnitTrailDistance, 1000, speed))
      else
        Sleep(100)
      end
    end
  end, unit)
end
function RemoveUnitWindModifierTrail(unit)
  unit.place_wind_mod_trails = false
end
