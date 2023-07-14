function IsValid(obj)
end
function GetRandomSpot(entity, state, typeID)
end
function GetEntitySpotPos(entity, idx)
end
function GetEntitySpotAngle(entity, idx)
end
function GetEntitySpotScale(entity, idx)
end
function GetSpotsType(pchEnt, idx)
end
function HasState(entity, state)
end
function GetEntityStepVector(entity, state)
end
function PlaceAndInit(class, pos, angle, scale, axis)
end
function PlaceAndInit2(class, posx, posy, posz, angle, scale, axisx, axisy, axisz, state, groupID)
end
function Group(list)
end
function Ungroup(list)
end
function GetTopmostParent(obj, classname)
end
function object:Clone(classname)
end
function object:ChangeClass(classname)
end
function object:HasEntity()
end
function object:GetDestlock()
end
function object:GetDestination()
end
function object:GetVelocityVector()
end
function object:GetVelocity()
end
function object:GetStepLength(stateID)
end
function object:GetStepVector(stateID, direction, phase, duration, step_mod)
end
function object:DetachFromMap()
end
function object:ChangeEntity(newEntity)
end
function object:SetColorModifier(colorModifier)
end
function object:GetColorModifier()
end
function object:SetAnimSpeedModifier(modifier)
end
function object:GetAnimSpeedModifier()
end
function object:GetFrameMark()
end
function object:GotoFastForward(dst, time)
end
function object:Attach(child, spot)
end
function object:Detach()
end
function object:GetNumAttaches()
end
function object:GetAttach(idx)
end
function object:GetAttachSpot()
end
function object:GetParent()
end
function object:GetSpotBeginIndex(state, typeID)
end
function object:GetSpotEndIndex(state, typeID)
end
function object:GetSpotRange(state, typeID)
end
function object:GetNearestSpot(state, typeID, pt)
end
function object:GetRandomSpot(state, typeID)
end
function object:GetRandomSpotPos(state, typeID)
end
function object:HasSpot(state, typeID)
end
function object:GetSpotPos(spotID)
end
function object:GetSpotVisualPos(spotID)
end
function object:GetSpotAxisAngle(spotID)
end
function object:GetSpotAnnotation(spotID)
end
function object:GetHeight()
end
function object:GetRadius()
end
function object:GetBSphere()
end
function object:GetEntityBBox()
end
function object:GetSpotName(spotID)
end
function object:GetGameFlags(object, mask)
end
function object:ClearGameFlags(flags)
end
function object:ClearHierarchyGameFlags(flags)
end
function object:SetGameFlags(flags)
end
function object:SetHierarchyGameFlags(flags)
end
function object:GetEnumFlags(mask)
end
function object:ClearEnumFlags(flags)
end
function object:ClearHierarchyEnumFlags(flags)
end
function object:SetEnumFlags(flags)
end
function object:GetClassFlags(mask)
end
function object:SetHierarchyEnumFlags(flags)
end
function object:GetVisualPos(time_offset, bExtrapolate)
end
function object:GetVisualPosXYZ(time_offset, bExtrapolate)
end
function object:GetVisualPosPrecise()
end
function object:GetPos()
end
function object:HasFov(map_pos, fov_arc_angle)
end
function object:IsValidPos()
end
function object:GetLocalPoint(world_pos)
end
function object:GetLocalPoint(x, y, z)
end
function object:GetLocalPointXYZ(world_pos)
end
function object:GetLocalPointXYZ(x, y, z)
end
function object:GetRelativePoint(local_pos)
end
function object:GetRelativePoint(x, y, z)
end
function object:GetRelativePointXYZ(local_pos)
end
function object:GetRelativePointXYZ(x, y, z)
end
function object:GetSpotAngle(idx)
end
function object:GetSpotScale(idx)
end
function object:GetVisualPos2D()
end
function object:GetSoundPosAndDist()
end
function object:SetGravity(accel)
end
function object:GetGravityFallTime(fall_height, start_speed_z, accel)
end
function object:GetGravityHeightTime(target, height, accel)
end
function object:GetGravityAngleTime(target, angle, accel)
end
function object:SetAcceleration(accel)
end
function object:GetAccelerationAndTime(destination, final_speed, starting_speed)
end
function object:GetAccelerationAndStartSpeed(destination, final_speed, time)
end
function object:GetAccelerationAndFinalSpeed(destination, starting_speed, time)
end
function object:GetFinalSpeedAndTime(destination, acceleration, starting_speed)
end
function object:GetFinalPosAndTime(final_speed, acceleration)
end
function object:SetCurvature(set)
end
function object:GetCurvature()
end
function object:GetCurvatureTime(pos, angle, axis, speed)
end
function object:SetPos(pos, time)
end
function object:SetLocationToObjSpot(this, target_obj, spotidx, time)
end
function object:SetLocationToRandomObjSpot(this, target_obj, spot_type, time)
end
function object:SetLocationToRandomObjStateSpot(this, target_obj, state, spot_type, time)
end
function object:GetAngle()
end
function object:SetAngle(angle, time)
end
function object:GetVisualAngle()
end
function object:Face(pt, time)
end
function object:GetAxis()
end
function object:GetVisualAxis()
end
function object:GetVisualAxisXYZ()
end
function object:SetAxis(axis, time)
end
function object:SetAxisAngle(axis, angle, time)
end
function object:InvertAxis()
end
function object:SetOrientation(dir, angle, time)
end
function object:GetOrientation()
end
function object:Rotate(this, axis, angle, time)
end
function object:GetFaceDir(len)
end
function object:AngleToObject(other)
end
function object:AngleToPoint(point)
end
function object:VectorTo2D(other)
end
function object:GetDist2D(other)
end
function object:PredictPos(time, extrapolate)
end
function object:GetVisualDist2D(other)
end
function object:GetDist(other)
end
function object:GetVisualDist(other)
end
function object:GetPlayer()
end
function object:SetPlayer(player)
end
function object:SetState(nState, nFlags, tCrossfade, nSpeed, bChangeOnly)
end
function object:PlayState(nState, count)
end
function object:GetState()
end
function object:SetStaticFrame(nState, time)
end
function object:HasState(state)
end
function object:GetScale()
end
function object:SetScale(scale)
end
function object:GetWorldScale()
end
function object:GetAnimDuration(state)
end
function object:TimeFromAnimStart()
end
function object:TimeToAnimEnd()
end
function object:TimeToPosInterpolationEnd()
end
function object:TimeToAngleInterpolationEnd()
end
function object:TimeToAxisInterpolationEnd()
end
function object:TimeToInterpolationEnd()
end
function object:StopInterpolation()
end
function object:IsGrouped()
end
function object:SetSound(sound, __type, volume, fade_time, looping, loud_distance)
end
function object:StopSound(fade_time)
end
function object:SetSoundVolume(volume, time)
end
function object:GetColorModifier()
end
function object:SetColorModifier(argb)
end
function object:GetOpacity()
end
function object:SetOpacity(val, time, recursive)
end
function object:SetDebugTexture(texture_file)
end
function object:DestroyRenderObj()
end
function object:GetNumTris()
end
function object:GetNumVertices()
end
function object:GetParticlesName()
end
function GetSIModulation()
end
function SetSIModulation(modulation)
end
function FindNearestObject(objlist, pt, filter)
end
function EnumValidStates()
end
function object:GetAnim(channel)
end
function object:GetAnimDebug(channel)
end
function object:SetAnim(channel, anim, flags, crossfade, speed, weight, phase)
end
function object:GetAnimFlags(channel)
end
function object:GetAnimSpeed(channel)
end
function object:SetAnimSpeed(channel, speed, time)
end
function object:GetAnimWeight(channel)
end
function object:SetAnimWeight(channel, weight, time, easing)
end
function object:GetAnimStartTime(channel)
end
function object:SetAnimStartTime(channel, time)
end
function object:GetAnimPhase(channel)
end
function object:SetAnimPhase(channel, phase)
end
function object:ClearAnim(channel)
end
function object:HasAnim(anim)
end
function object:FindAnimChannel(anim)
end
function object:IsStaticAnim()
end
function object:IsAnimLooping(channel)
end
function object:GetAnimComponentIndexFromLabel(channel, label)
end
function object:SetAnimComponentTarget(channel, animComponentIndex, params)
end
function object:RemoveAnimComponentTarget(channel, animComponentIndex)
end
function IsErrorState(entity, anim)
end
function IsEntityAnimLooping(entity, anim)
end
function GetNumStates()
end
function GetMirrored()
end
function IsPointOverObject()
end
function SetCustomData(index, value)
end
function GetCustomData(index)
end
function object:GetSurfacesBBox(request_surfaces, fallback_surfaces)
end
function object:GetAttaches(classes)
end
function object:DestroyAttaches(classes, filter, ...)
end
function object:CountAttaches(classes, filter, ...)
end
function object:ForEachAttach(classes, exec, ...)
end
function object:IsValidZ()
end
function object:IsEqualPos(pos)
end
function object:IsEqualPos2D(pos)
end
function object:IsEqualVisualPos(pos)
end
function object:IsEqualVisualPos2D(pos)
end
function AveragePoint(pt1, pt2, ...)
end
function AveragePoint2D(pt1, pt2, ...)
end
