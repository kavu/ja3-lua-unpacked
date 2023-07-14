const.TunnelTypeWalk = 1
const.TunnelTypeStairs = 2
const.TunnelTypeLadder = 4
const.TunnelTypeDrop1 = 8
const.TunnelTypeDrop2 = 16
const.TunnelTypeDrop3 = 32
const.TunnelTypeDrop4 = 64
const.TunnelTypeClimb1 = 128
const.TunnelTypeClimb2 = 256
const.TunnelTypeClimb3 = 512
const.TunnelTypeClimb4 = 1024
const.TunnelTypeJumpOver1 = 2048
const.TunnelTypeJumpOver2 = 4096
const.TunnelTypeJumpAcross1 = 8192
const.TunnelTypeJumpAcross2 = 16384
const.TunnelTypeDoor = 32768
const.TunnelTypeDoorBlocked = 65536
const.TunnelTypeWindow = 131072
const.TunnelMaskWalkFlat = const.TunnelTypeWalk
const.TunnelMaskWalk = const.TunnelTypeWalk | const.TunnelTypeStairs
const.TunnelMaskClimb = const.TunnelTypeClimb1 | const.TunnelTypeClimb2 | const.TunnelTypeClimb3 | const.TunnelTypeClimb4
const.TunnelMaskDrop = const.TunnelTypeDrop1 | const.TunnelTypeDrop2 | const.TunnelTypeDrop3 | const.TunnelTypeDrop4
const.TunnelMaskClimbDrop = const.TunnelMaskClimb | const.TunnelMaskDrop
const.TunnelMaskSmallAnimals = const.TunnelMaskWalk | const.TunnelTypeClimb1 | const.TunnelTypeClimb2 | const.TunnelTypeDrop1 | const.TunnelTypeDrop2
const.TunnelMaskLargeAnimals = const.TunnelMaskWalk
const.TunnelMaskPlayerStanding = -1
const.TunnelMaskPlayerProne = const.TunnelTypeWalk
const.TunnelMaskAIStanding = const.TunnelMaskPlayerStanding & ~const.TunnelTypeDoorBlocked
const.TunnelMaskAIProne = const.TunnelMaskPlayerProne & ~const.TunnelTypeDoorBlocked
const.TunnelMaskCivilian = const.TunnelMaskPlayerStanding & ~(const.TunnelTypeDoorBlocked | const.TunnelTypeWindow | const.TunnelMaskClimbDrop) | const.TunnelTypeDrop1 | const.TunnelTypeClimb1
const.TunnelMaskMeleeRange = const.TunnelMaskWalk | const.TunnelTypeClimb1 | const.TunnelTypeDrop1 | const.TunnelTypeJumpOver1
const.TunnelMaskTraverseWait = const.TunnelTypeLadder | const.TunnelTypeDrop2 | const.TunnelTypeDrop3 | const.TunnelTypeDrop4 | const.TunnelTypeClimb1 | const.TunnelTypeClimb2 | const.TunnelTypeClimb3 | const.TunnelTypeClimb4 | const.TunnelTypeJumpOver1 | const.TunnelTypeJumpOver2 | const.TunnelTypeJumpAcross1 | const.TunnelTypeJumpAcross2 | const.TunnelTypeDoorBlocked | const.TunnelTypeWindow
const.TunnelMaskWalkStopAnim = const.TunnelTypeLadder | const.TunnelTypeDrop3 | const.TunnelTypeDrop4 | const.TunnelTypeClimb2 | const.TunnelTypeClimb3 | const.TunnelTypeClimb4 | const.TunnelTypeDoor | const.TunnelTypeDoorBlocked | const.TunnelTypeWindow
local costWalk = 500
local difficult_terrain_modifier = 50
local costDifficultTerrain = costWalk * (100 + difficult_terrain_modifier) / 100
if Platform.desktop and Platform.developer then
  function OnMsg.Autorun()
  end
end
pathfind_pass_types = {
  "DefaultPass",
  "DifficultTerrain",
  "AmbientLifeAvoid",
  "FireTerrain"
}
pathfind_pass_grid_types = {
  "DefaultPass",
  "AmbientLifeAvoid",
  "FireTerrain"
}
pathfind_water_pass_type = "DifficultTerrain"
pathfind_water_pass_type_idx = (table.find(pathfind_pass_types, pathfind_water_pass_type) or 0) - 1
local default_pfcontext_meta = {
  __index = {
    depth = 100000,
    min_depth = 100000,
    max_path_search_radius_coef = 1000,
    heuristic_mul = 8,
    heuristic_start_depth = 20000,
    task_sleep = 0,
    tunnel_mask = -1,
    DefaultPass = costWalk,
    DifficultTerrain = costDifficultTerrain,
    AmbientLifeAvoid = costWalk,
    FireTerrain = costWalk * 3
  }
}
pathfind = {
  {
    tunnel_mask = const.TunnelMaskPlayerStanding
  },
  {
    tunnel_mask = const.TunnelMaskPlayerProne,
    DifficultTerrain = const.pfImpassableCost
  },
  {
    tunnel_mask = const.TunnelMaskAIStanding
  },
  {
    tunnel_mask = const.TunnelMaskAIProne,
    DifficultTerrain = const.pfImpassableCost
  },
  {
    tunnel_mask = const.TunnelMaskCivilian,
    AmbientLifeAvoid = 4 * costWalk,
    FireTerrain = 4 * costWalk
  },
  {
    tunnel_mask = const.TunnelMaskSmallAnimals
  },
  {
    tunnel_mask = const.TunnelMaskLargeAnimals,
    large_unit_pass_radius = 1,
    large_unit_collision_cost = 4 * costWalk
  }
}
for i, t in ipairs(pathfind) do
  setmetatable(t, default_pfcontext_meta)
end
function CalcPFClass(side, stance, body_type)
  if body_type == "Large animal" then
    return 6
  elseif body_type == "Small animal" then
    return 5
  elseif not side or side == "neutral" then
    return 4
  elseif side ~= "player1" and side ~= "player2" then
    return stance == "Prone" and 3 or 2
  end
  return stance == "Prone" and 1 or 0
end
pathfind_surf_types = {}
const.MaxPassableTerrainSlope = atan(const.SlabSizeZ, const.SlabSizeX)
const.PathMaxUnitRadius = 6 * guim
const.PathMaxZTolerance = 2 * guim
const.PathStrandedArea = 0
const.MaxPassableWaterDepth = 0
const.passSpheroidWidth = 60 * guic
const.passSpheroidHeight = 165 * guic
const.passSpheroidCollisionOffsetZ = 10 * guic
const.passVoxelTileSpheroidWidth = 80 * guic
const.passVoxelTileSpheroidHeight = 175 * guic
const.passVoxelTileSpheroidCollisionOffsetZ = 10 * guic
