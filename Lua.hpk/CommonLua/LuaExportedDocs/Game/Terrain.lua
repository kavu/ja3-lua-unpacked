function terrain.IsPointInBounds(pos, border)
end
function terrain.ClampPoint(pos, border)
end
function terrain.ClampBox(box, border)
end
function terrain.ClampVector(ptFrom, ptTo)
end
function terrain.IsMapBox(box)
end
function terrain.IsPassable(pos)
end
function terrain.CirclePassable(center, radius, pfclass)
end
function terrain.CirclePassable(x, y, z, radius, pfclass)
end
function terrain.CirclePassable(obj, radius)
end
function terrain.AreaPassable(pos, area, pfclass, avoid_tunnels)
end
function terrain.AreaPassable(x, y, z, area, pfclass, avoid_tunnels)
end
function terrain.AreaPassable(obj, area, avoid_tunnels)
end
function terrain.FindAreaPassable(pos, area, radius, pfclass, avoid_tunnels, destlock_radius, filter, ...)
end
function terrain.FindAreaPassable(pos, obj, area, radius, avoid_tunnels, can_destlock, filter, ...)
end
function terrain.FindAreaPassable(x, y, z, area, radius, pfclass, avoid_tunnels, destlock_radius, filter, ...)
end
function terrain.FindAreaPassable(x, y, z, obj, area, radius, avoid_tunnels, can_destlock, filter, ...)
end
function terrain.FindAreaPassable(obj, area, radius, avoid_tunnels, can_destlock, filter, ...)
end
function terrain.IsVerticalTerrain(pt)
end
function terrain.GetTerrainType()
end
function terrain.SetTerrainType()
end
function terrain.GetSurfaceHeight(pos)
end
function terrain.GetHeight(pos)
end
function terrain.GetMinMaxHeight(box)
end
function terrain.FindPassable(pos, pfclass, radius, destlock_radius)
end
function terrain.FindPassable(x, y, z, pfclass, radius, destlock_radius)
end
function terrain.FindPassableZ(pos, pfclass, max_below, max_above)
end
function terrain.FindPassableZ(x, y, z, pfclass, max_below, max_above)
end
function terrain.FindReachable(start, mode, ...)
end
function terrain.FindPassableTile(pos, flags, ...)
end
function terrain.FindPassableTile(x, y, z, flags, ...)
end
function terrain.GetSurfaceNormal(pos)
end
function terrain.GetTerrainNormal(pos)
end
function terrain.GetMapSize()
end
function terrain.GetGrassMapSize()
end
function terrain.GetMapWidth()
end
function terrain.GetMapHeight()
end
function terrain.GetAreaHeight(pos, radius)
end
function terrain.SetHeightCircle(center, innerRadius, outerRadius, height)
end
function terrain.SmoothHeightCircle(center, radius)
end
function terrain.ChangeHeightCircle(center, innerRadius, outerRadius, heightdiff)
end
function terrain.SetTypeCircle(pos, radius, type)
end
function terrain.ReplaceTypeCircle(pos, radius, type_old, type_new)
end
function terrain.IntersectSegment(pt1, pt2)
end
function terrain.IntersectRay(pt1, pt2)
end
function terrain.ScaleHeight(mul, div)
end
function terrain.RemapType(remap)
end
function terrain.GetHeightGrid()
end
function terrain.GetTypeGrid()
end
