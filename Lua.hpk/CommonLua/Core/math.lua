if Platform.cmdline then
  return
end
function ClosestAngle(a, ...)
  local best_diff, angle = 1000000, false
  for _, v in pairs({
    ...
  }) do
    local diff = abs(AngleDiff(v, a))
    if best_diff > diff then
      best_diff = diff
      angle = v
    end
  end
  return angle, angle and best_diff or false
end
function ClampAngle(a, min, max)
  local diff1, diff2 = AngleDiff(a, min), AngleDiff(a, max)
  if diff1 < 0 and 0 < diff2 then
    return diff2 < -diff1 and max or min
  end
  return a
end
function RotateAroundCenter(center, pt, angle, new_len)
  local len = new_len or (pt - center):Len()
  return center + SetLen(Rotate(pt - center, angle), len)
end
function MulDivTrunc2(a, b, c)
  return MulDivTrunc(MulDivTrunc(a, b, c), b, c)
end
function TrajectoryTime(from, to, time, g)
  local delta = (to - from):SetInvalidZ()
  local d = delta:Len()
  local angle = atan(MulDivTrunc(time, time * g, 1000000), 2 * d)
  local v = sqrt(d * g) * 4096 / sin(2 * angle)
  local z_error = 0
  local f = function(t)
    local error_compensation = z_error * t / time
    local x = d * t / time
    local h = x * sin(angle) / cos(angle) - MulDivTrunc2(MulDivTrunc2(g / 2, x, v), 4096, cos(angle))
    return from + (delta * Clamp(t, 0, time) / time):SetZ(h + from:z() + error_compensation)
  end
  z_error = to:z() - f(time):z()
  return f, angle / 60
end
function TrajectoryAngle(from, to, angle, g)
  local delta = (to - from):SetInvalidZ()
  local d = delta:Len()
  local v = sqrt(d * g) * 4096 / sin(2 * angle)
  local time = MulDivTrunc(d, 4098000, v * cos(angle))
  local z_error = 0
  local f = function(t)
    local error_compensation = z_error * t / time
    local x = d * t / time
    local h = x * sin(angle) / cos(angle) - MulDivTrunc2(MulDivTrunc2(g / 2, x, v), 4096, cos(angle))
    return from + (delta * Clamp(t, 0, time) / time):SetZ(h + error_compensation)
  end
  z_error = to:z() - f(time):z()
  return f, time
end
function Qerp(from, to, med, total_time, capped)
  if total_time == 0 then
    return function()
      return to
    end
  end
  local a, b = 200 - 4 * med, 4 * med - 100
  local delta = to - from
  return function(time)
    if capped then
      if time < 0 then
        return from
      end
      if time >= total_time then
        return to
      end
    end
    local t = delta * time / total_time * time / total_time * a / 100 + delta * time / total_time * b / 100
    return from + t
  end
end
function CalcZForInterpolation(p1, p2)
  local p1_isvalid_z, p2_isvalid_z = p1:IsValidZ(), p2:IsValidZ()
  if p1_isvalid_z ~= p2_isvalid_z then
    return p1_isvalid_z and p1 or p1:SetZ(terrain.GetHeight(p1)), p2_isvalid_z and p2 or p2:SetZ(terrain.GetHeight(p2))
  end
  return p1, p2
end
function ValueLerp(from, to, total_time, capped)
  if IsPoint(from) then
    from, to = CalcZForInterpolation(from, to)
  end
  local delta = to - from
  if total_time == 0 then
    return function()
      return to
    end
  end
  local useMulDiv = not capped
  if not useMulDiv then
    local o = MulDivTrunc(delta, total_time, 2147483647)
    if type(o) == "number" then
      useMulDiv = o ~= 0
    else
      useMulDiv = 0 < o:Len()
    end
  end
  if useMulDiv then
    if capped then
      return function(time)
        return from + MulDivTrunc(delta, Clamp(time, 0, total_time), total_time)
      end
    else
      return function(time)
        return from + MulDivTrunc(delta, time, total_time)
      end
    end
  else
    return function(time)
      return from + delta * Clamp(time, 0, total_time) / total_time
    end
  end
end
function GameTimeLerp(from, to, total_time, capped)
  local start_time = GameTime()
  if IsPoint(from) then
    from, to = CalcZForInterpolation(from, to)
  end
  local delta = to - from
  if total_time == 0 then
    return function()
      return to
    end
  end
  local useMulDiv = not capped
  if not useMulDiv then
    local o = MulDivTrunc(delta, total_time, 2147483647)
    if type(o) == "number" then
      useMulDiv = o ~= 0
    else
      useMulDiv = 0 < o:Len()
    end
  end
  if useMulDiv then
    if capped then
      return function(time)
        return from + MulDivTrunc(delta, Clamp(time - start_time, 0, total_time), total_time)
      end
    else
      return function(time)
        return from + MulDivTrunc(delta, time - start_time, total_time)
      end
    end
  else
    return function(time)
      return from + delta * Clamp(time - start_time, 0, total_time) / total_time
    end
  end
end
function AngleLerp(from, to, total_time, capped)
  local delta = AngleDiff(to, from)
  if total_time == 0 then
    return function()
      return to
    end
  end
  return function(time)
    if capped then
      if time <= 0 then
        return from
      end
      if time >= total_time then
        return to
      end
    end
    return AngleNormalize(from + delta * time / total_time)
  end
end
function MovePoint(src, dest, dist)
  dest, src = CalcZForInterpolation(dest, src)
  local v = dest - src
  if dist < v:Len() then
    v = SetLen(v, dist)
  end
  return src + v
end
function MovePointAwayPass(src, dest, dist)
  local v = dest - src
  v = SetLen(v, dist)
  local pt = src - v
  local pass = GetPassablePointNearby(pt)
  return pass and terrain.IsPointInBounds(pass) and pass or pt
end
function MovePointAway(src, dest, dist)
  dest, src = CalcZForInterpolation(dest, src)
  local v = dest - src
  v = SetLen(v, dist)
  return src - v
end
function Angle3dVectors(v1, v2)
  return acos(MulDivTrunc(Dot(v1, v2), 4096, v1:Len() * v2:Len()))
end
function GetRadialOffsets(n, pos, direction, radius)
  local off1 = point(-direction:y(), direction:x(), 0)
  if off1 == point30 then
    off1 = point(1, 0, 0)
  end
  off1 = SetLen(off1, radius)
  local offs = {off1}
  for i = 1, n - 1 do
    table.insert(offs, RotateAxis(off1, direction, 21600 * i / n))
  end
  return offs
end
function GetRadialPoints(n, pos, direction, radius)
  local ps = GetRadialOffsets(n, pos, direction, radius)
  for i = 1, n do
    ps[i] = pos + ps[i]
  end
  return ps
end
function GetScaledValue(min, max, perc, div)
  div = div or 100
  return min + MulDivRound(max - min, perc, div)
end
function DivCeil(v, d)
  v = v + d - 1
  return v / d
end
function MapRange(value, new_range_max, new_range_min, old_range_max, old_range_min)
  if old_range_max == old_range_min then
    return new_range_max
  end
  return MulDivRound(new_range_max - new_range_min, value - old_range_max, old_range_max - old_range_min) + new_range_max
end
