function Crash()
end
function GetFrameNo()
end
function ResetMemStats()
end
function ResetProfile(file_name)
end
function SetUIMouseCursor(filename)
end
function SetAppMouseCursor(filename)
end
function HideMouseCursor()
end
function ShowMouseCursor()
end
function IsMouseCursorHidden()
end
function GetMouseCursor()
end
function GetMap()
end
function OpenBrowseDialog(initail_dir, file_type, exists, multiple, initial_file)
end
function GetExecDirectory()
end
function GetCWD()
end
function CopyToClipboard(clip)
end
function GetFromClipboard()
end
function GetSurfaces(box, type)
end
function OpenAddress(name)
end
function len(utf8)
end
function Advance(utf8, pointer, letters)
end
function Retreat(utf8, pointer, letters)
end
function GetCameraLH(pitch, dist, dist_to_ground)
end
function IntersectSegmentCylinder(pt1, pt2, center, radius, height)
end
function IntersectLineCone(pt1, pt2, vertex, dir, angle, height)
end
function IntersectRayCone(pt1, pt2, vertex, dir, angle, height)
end
function IntersectSegmentCone(pt1, pt2, vertex, dir, angle, height)
end
function DistSegmentToPt2D2(pt1, pt2, pt)
end
function IntersectLineWithLine2D(pt1, pt2, pt3, pt4)
end
function IntersectSegmentWithSegment2D(pt1, pt2, pt3, pt4)
end
function IntersectRayWithSegment2D(origin, dir, pt1, pt2)
end
function IntersectLineWithCircle2D(pt1, pt2, center, radius)
end
function IntersectSegmentWithCircle2D(pt1, pt2, center, radius)
end
function IntersectSegmentWithClosestObj(pt1, pt2, class, enum_radius, enum_flags_all, game_flags_all, enum_flags_ignore, game_flags_ignore, exact, offset_z, filter, ...)
end
function IntersectPolyWithCircle2D(poly, center, radius)
end
function IntersectPolyWithPoly2D(poly1, poly2)
end
function IntersectPolyWithSpline2D(poly, spline, width, precision)
end
function BoundSegmentInBox(pt1, pt2, box)
end
function WriteScreenshot(file)
end
function quit()
end
function IsQuitInProcess()
end
function GetUsername()
end
function gettablesizes(table)
end
function GetEngineVar(prefix, name)
end
function SetEngineVar(prefix, name, value)
end
function EnumEngineVars(prefix)
end
function SetPerformanceTimeMarker()
end
function PerformanceTimeAdd(id1, id2)
end
function GetPerformanceTime(id)
end
function GetPerformanceTimesMinMax(id)
end
function ResetPerformanceTimes()
end
function CancelUpsampledScreenshot()
end
function StretchTextShadow(text, rc, font, color, shadow_color, shadow_size, shadow_dir)
end
function StretchTextOutline(text, rc, font, color, outline_color, outline_size)
end
function FullscreenMode()
end
function GetFontID(font_description)
end
function GetFontDescription(font_id)
end
function GetMultiPathDistances(origin, destinations, pfClass)
end
function UpdateTerrainDebugDraw()
end
function GetPath()
end
function GetSafeArea()
end
function __DumpObjPropsForSave()
end
function Clamp()
end
function GetRenderStatistics()
end
function dbgMemoryAllocationTest()
end
function GameToScreen(pt)
end
function ScreenToGame(pt, precision)
end
function GameToCamera(pt, camPos, camLookAt)
end
function GetWalkableObject(pt)
end
function GetWalkableZ(pt)
end
function procall(f, arg1, ...)
end
function sprocall(f, arg1, ...)
end
function DebugPrint(text)
end
function GetTerrainTextureFiles(layer)
end
function SetPostProcSSAOParam(param, value)
end
function GetPostProcSSAOParam(param)
end
function GetPreciseTicks(precision)
end
function GetAllocationsCount()
end
function DbgClearVectors()
end
function DbgClearTexts()
end
function DbgAddVector(origin, vector, color)
end
function DbgAddSegment(pt1, pt2, color)
end
function DbgAddSpline(spline, color, zplane)
end
function DbgAddPoly(poly, color, dont_close)
end
function DbgAddTerrainRect(rect, color)
end
function DbgSetVectorOffset(offset)
end
function DbgSetVectorZTest(enable)
end
function DbgAddCircle(center, radius, color, point_count, ground_offset)
end
function DbgAddBox(box, color)
end
function DbgAddTriangle(pt1, pt2, pt3, color)
end
function DbgAddText(text, pos, color, font_face, back_color)
end
function CertDelete(certificate_name)
end
function CertRead(certificate_name, certificate_file)
end
function CertRegister(certificate_name, certificate_data)
end
function SplitPath(file_path)
end
function Lerp(from, to, time, interval)
end
