if FirstLoad then
  g_TerrainAreaMeshes = {}
  g_AreaUndoQueue = false
  LocalStorage.XAreaCopyTool = LocalStorage.XAreaCopyTool or {}
end
local snap_size = Max(const.SlabSizeX or 0, const.HeightTileSize, const.TypeTileSize)
local SnapPt = function(pt)
  local x, y = pt:xy()
  return point(x / snap_size * snap_size, y / snap_size * snap_size)
end
DefineClass.XAreaCopyTool = {
  __parents = {
    "XEditorTool"
  },
  properties = {},
  ToolTitle = "Copy terrain & objects",
  ToolSection = "Misc",
  Description = {
    [[
Copies entire areas of the map.

Drag to add new selection areas, then
use <style GedHighlight>Ctrl-C</style> to copy and <style GedHighlight>Ctrl-V</style> twice to paste.]]
  },
  ActionIcon = "CommonAssets/UI/Editor/Tools/EnrichTerrain.tga",
  ActionShortcut = "O",
  ActionSortKey = "5",
  UsesCodeRenderables = true,
  old_undo = false,
  start_pos = false,
  operation = false,
  current_box = false,
  highlighted_objset = false,
  drag_area = false,
  drag_helper_id = false,
  filter_roofs = false,
  filter_floor = false
}
function XAreaCopyTool:Init()
  Collection.UnlockAll()
  for _, a in ipairs(self:GetAreas()) do
    a:SetVisible(true)
    a:Setbox(a.box)
  end
  self.filter_floor = LocalStorage.FilteredCategories.HideFloor
  self.filter_roofs = LocalStorage.FilteredCategories.Roofs
  LocalStorage.FilteredCategories.HideFloor = 0
  LocalStorage.FilteredCategories.Roofs = true
  XEditorFilters:UpdateHiddenRoofsAndFloors()
  XEditorFilters:SuspendHighlights()
  local objset = {}
  MapGet(true, function(obj)
    objset[obj] = true
  end)
  self.highlighted_objset = objset
  self:UpdateHighlights(true)
  self.old_undo = XEditorUndo
  g_AreaUndoQueue = g_AreaUndoQueue or XEditorUndoQueue:new()
  XEditorUndo = g_AreaUndoQueue
  XEditorUpdateToolbars()
end
function XAreaCopyTool:Done()
  for _, a in ipairs(self:GetAreas()) do
    a:SetVisible(false)
  end
  MapGet(true, function(obj)
    obj:ClearGameFlags(const.gofWhiteColored)
  end)
  self.highlighted_objset = false
  LocalStorage.FilteredCategories.HideFloor = self.filter_floor
  LocalStorage.FilteredCategories.Roofs = self.filter_roofs
  XEditorFilters:UpdateHiddenRoofsAndFloors()
  XEditorFilters:ResumeHighlights()
  XEditorUndo = self.old_undo
  if GetDialog("XEditor") then
    XEditorUpdateToolbars()
  end
end
function XAreaCopyTool:GetAreas()
  for i = #g_TerrainAreaMeshes, 1, -1 do
    local area = g_TerrainAreaMeshes[i]
    if not IsValid(area) or area.box:IsEmpty() then
      table.remove(g_TerrainAreaMeshes, i)
    end
  end
  return g_TerrainAreaMeshes
end
function XAreaCopyTool:GetObjects(box_list)
  local objset = {}
  for _, b in ipairs(box_list) do
    b = IsKindOf(b, "XTerrainAreaMesh") and b.box or b
    for _, obj in ipairs(MapGet(b, "attached", false, CanSelect)) do
      objset[obj] = obj:GetGameFlags(const.gofPermanent) ~= 0 and not IsKindOf(obj, "XTerrainAreaMesh") or nil
    end
  end
  return XEditorPropagateParentAndChildObjects(table.keys(objset))
end
function XAreaCopyTool:UpdateHighlights(highlight)
  PauseInfiniteLoopDetection("XAreaCopyTool:UpdateHighlights")
  local new = highlight and self:GetObjects(self:GetAreas()) or empty_table
  local old_set = self.highlighted_objset or empty_table
  local new_set = {}
  for _, obj in ipairs(new) do
    if not old_set[obj] then
      obj:ClearHierarchyGameFlags(const.gofWhiteColored)
    else
      old_set[obj] = nil
    end
    new_set[obj] = true
  end
  for obj in pairs(old_set) do
    obj:SetHierarchyGameFlags(const.gofWhiteColored)
  end
  self.highlighted_objset = new_set
  ResumeInfiniteLoopDetection("XAreaCopyTool:UpdateHighlights")
end
function XAreaCopyTool:OnMouseButtonDown(pt, button)
  if button == "L" then
    self.desktop:SetMouseCapture(self)
    self.start_pos = SnapPt(GetTerrainCursor())
    for _, a in ipairs(self:GetAreas()) do
      local helper_id = a:UpdateHelpers(pt)
      if helper_id then
        self.operation = "movesize"
        self.drag_area = a
        self.drag_helper_id = helper_id
        XEditorUndo:BeginOp({
          name = "Moves/sized area",
          objects = {
            self.drag_area
          }
        })
        self.drag_area:DragStart(self.drag_helper_id, self.start_pos)
        return "break"
      end
    end
    self.operation = "place"
    self.current_box = XEditableTerrainAreaMesh:new()
    g_TerrainAreaMeshes[#g_TerrainAreaMeshes + 1] = self.current_box
    return "break"
  end
  if button == "R" then
    for _, a in ipairs(self:GetAreas()) do
      a:delete()
    end
    self:UpdateHighlights(true)
    return "break"
  end
end
local MinMaxPtXY = function(f, p1, p2)
  return point(f(p1:x(), p2:x()), f(p1:y(), p2:y()))
end
function XAreaCopyTool:OnMousePos(pt)
  XEditorRemoveFocusFromToolbars()
  if self.operation == "place" then
    local pt1, pt2 = self.start_pos, SnapPt(GetTerrainCursor())
    local new_box = box(MinMaxPtXY(Min, pt1, pt2), MinMaxPtXY(Max, pt1, pt2) + point(snap_size, snap_size))
    local old_box = self.current_box.box
    self.current_box:Setbox(new_box, "force_setpos")
    self:UpdateHighlights(true)
    return "break"
  end
  if self.operation == "movesize" then
    self.drag_area:DragMove(self.drag_helper_id, SnapPt(GetTerrainCursor()))
    self:UpdateHighlights(true)
    return "break"
  end
  local areas = self:GetAreas()
  for _, a in ipairs(areas) do
    a:UpdateHelpers(pt)
  end
  local hovered
  for _, a in ipairs(areas) do
    a:UpdateHover(hovered)
    hovered = hovered or a.hovered
  end
end
function XAreaCopyTool:OnMouseButtonUp(pt, button)
  if self.operation then
    self.desktop:SetMouseCapture()
    return "break"
  end
end
function XAreaCopyTool:OnCaptureLost()
  if self.operation == "place" then
    XEditorUndo:BeginOp({name = "Added area"})
    XEditorUndo:EndOp({
      self.current_box
    })
  end
  if self.operation == "movesize" then
    XEditorUndo:EndOp({
      self.drag_area
    })
  end
  self.start_pos = nil
  self.operation = nil
  self.current_box = nil
  self.drag_area = nil
  self.drag_helper_id = nil
end
function XAreaCopyTool:OnShortcut(shortcut, source, ...)
  if terminal.desktop:GetMouseCapture() and shortcut ~= "Ctrl-F1" and shortcut ~= "Escape" then
    return "break"
  end
  if shortcut == "Ctrl-C" then
    ExecuteWithStatusUI("Copying terrain & objects...", function()
      self:CopyToClipboard()
    end)
    return "break"
  elseif shortcut == "Delete" then
    for _, a in ipairs(self:GetAreas()) do
      if a.hovered then
        XEditorUndo:BeginOp({
          name = "Deleted area",
          objects = {a}
        })
        a:delete()
        XEditorUndo:EndOp()
        self:UpdateHighlights(true)
        return "break"
      end
    end
  end
  return XEditorTool.OnShortcut(self, shortcut, source, ...)
end
function XAreaCopyTool:CopyToClipboard()
  local areas = self:GetAreas()
  if #areas == 0 then
    return
  end
  local area_datas = {}
  for _, a in ipairs(areas) do
    local data = XTerrainGridData:new()
    data:CaptureData(a.box)
    area_datas[#area_datas + 1] = data
  end
  local data = XEditorSerialize(area_datas)
  data.objs = XEditorSerialize(XEditorCollapseChildObjects(self:GetObjects(areas)))
  data.pivot = CenterPointOnBase(areas)
  data.paste_fn = "PasteTerrainAndObjects"
  CopyToClipboard(XEditorToClipboardFormat(data))
  XEditorUndo:BeginOp({
    objects = table.copy(areas),
    name = "Copied terrain & objects"
  })
  for _, a in ipairs(areas) do
    a:delete()
  end
  for _, a in ipairs(area_datas) do
    a:delete()
  end
  XEditorUndo:EndOp()
  XEditorSetDefaultTool()
end
function OnMsg.PreSaveMap()
  MapForEach("map", "XTerrainAreaMesh", function(obj)
    obj:ClearGameFlags(const.gofPermanent)
  end)
end
function OnMsg.PostSaveMap()
  MapForEach("map", "XTerrainAreaMesh", function(obj)
    obj:SetGameFlags(const.gofPermanent)
  end)
end
DefineClass.XTerrainAreaMesh = {
  __parents = {
    "Mesh",
    "EditorCallbackObject"
  },
  properties = {
    {id = "box", editor = "box"}
  },
  outer_color = RGB(255, 255, 255),
  inner_color = RGBA(255, 255, 255, 80),
  outer_border = 6 * guic,
  inner_border = 4 * guic,
  box = empty_box
}
function XTerrainAreaMesh:Init()
  self:SetGameFlags(const.gofPermanent)
  self:SetShader(ProceduralMeshShaders.default_mesh)
  self:SetDepthTest(true)
end
function XTerrainAreaMesh:GetPivot()
  local pivot = self.box:Center()
  return pivot:SetZ(self:GetHeight(pivot))
end
function XTerrainAreaMesh:GetHeight(pt)
  return terrain.GetHeight(pt)
end
function XTerrainAreaMesh:AddQuad(v_pstr, pivot, pt1, pt2, pt3, pt4, color)
  local offs = 30 * guic
  pt1 = (pt1 - pivot):SetZ(self:GetHeight(pt1) - pivot:z() + offs)
  pt2 = (pt2 - pivot):SetZ(self:GetHeight(pt2) - pivot:z() + offs)
  pt3 = (pt3 - pivot):SetZ(self:GetHeight(pt3) - pivot:z() + offs)
  pt4 = (pt4 - pivot):SetZ(self:GetHeight(pt4) - pivot:z() + offs)
  v_pstr:AppendVertex(pt1, color)
  v_pstr:AppendVertex(pt2)
  v_pstr:AppendVertex(pt3)
  v_pstr:AppendVertex(pt2)
  v_pstr:AppendVertex(pt3)
  v_pstr:AppendVertex(pt4)
end
function XTerrainAreaMesh:AddTriangle(v_pstr, pivot, pt1, pt2, pt3, color)
  local offs = 30 * guic
  pt1 = (pt1 - pivot):SetZ(self:GetHeight(pt1) - pivot:z() + offs)
  pt2 = (pt2 - pivot):SetZ(self:GetHeight(pt2) - pivot:z() + offs)
  pt3 = (pt3 - pivot):SetZ(self:GetHeight(pt3) - pivot:z() + offs)
  v_pstr:AppendVertex(pt1, color)
  v_pstr:AppendVertex(pt2)
  v_pstr:AppendVertex(pt3)
end
function XTerrainAreaMesh:Setbox(bbox, force_setpos)
  self.box = bbox
  local treshold_size = snap_size * 32
  local n = Max(bbox:sizex(), bbox:sizey()) / treshold_size + 1
  local inner_border = self.inner_border + self.inner_border * (n - 1) / 2
  local outer_border = self.outer_border + self.outer_border * (n - 1) / 2
  local step = snap_size
  local v_pstr = pstr("", 65536)
  local pivot = self:GetPivot()
  for x = bbox:minx(), bbox:maxx(), step do
    for y = bbox:miny(), bbox:maxy(), step do
      if x + step <= bbox:maxx() then
        local outer = y == bbox:miny() or y + step > bbox:maxy()
        if outer or (y - bbox:miny()) / step % n == 0 then
          local d = outer and outer_border or inner_border
          local pt1, pt2 = point(x, y - d), point(x + step, y - d)
          local pt3, pt4 = point(x, y + d), point(x + step, y + d)
          self:AddQuad(v_pstr, pivot, pt1, pt2, pt3, pt4, outer and self.outer_color or self.inner_color)
        end
      end
      if y + step <= bbox:maxy() then
        local outer = x == bbox:minx() or x + step > bbox:maxx()
        if outer or (x - bbox:minx()) / step % n == 0 then
          local d = outer and outer_border or inner_border
          local pt1, pt2 = point(x - d, y), point(x - d, y + step)
          local pt3, pt4 = point(x + d, y), point(x + d, y + step)
          self:AddQuad(v_pstr, pivot, pt1, pt2, pt3, pt4, outer and self.outer_color or self.inner_color)
        end
      end
    end
  end
  if force_setpos or self:GetPos() == InvalidPos() then
    self:SetPos(pivot)
  end
  self:SetMesh(v_pstr)
end
function XTerrainAreaMesh:Getbox(bbox)
  return self.box
end
local UpdateAreas = function(self)
  if self then
    table.insert_unique(g_TerrainAreaMeshes, self)
  end
  if GetDialogMode("XEditor") == "XAreaCopyTool" then
    CreateRealTimeThread(function()
      XAreaCopyTool:UpdateHighlights(true)
    end)
  end
end
XTerrainAreaMesh.EditorCallbackPlace = UpdateAreas
XTerrainAreaMesh.EditorCallbackDelete = UpdateAreas
OnMsg.EditorFiltersChanged = UpdateAreas
local helpers_data = {
  {
    x = 0,
    y = 0,
    x1 = true,
    y1 = true,
    x2 = false,
    y2 = false,
    point(0, 0),
    point(3, 0),
    point(0, 3)
  },
  {
    x = 1,
    y = 0,
    x1 = false,
    y1 = true,
    x2 = false,
    y2 = false,
    point(-2, 0),
    point(2, 0),
    point(0, 2),
    stretch_x = true
  },
  {
    x = 2,
    y = 0,
    x1 = false,
    y1 = true,
    x2 = true,
    y2 = false,
    point(-3, 0),
    point(0, 0),
    point(0, 3)
  },
  {
    x = 0,
    y = 1,
    x1 = true,
    y1 = false,
    x2 = false,
    y2 = false,
    point(0, -2),
    point(0, 2),
    point(2, 0),
    stretch_y = true
  },
  {
    x = 1,
    y = 1,
    x1 = true,
    y1 = true,
    x2 = true,
    y2 = true,
    point(-3, 0),
    point(3, 0),
    point(0, 3),
    point(-3, 0),
    point(3, 0),
    point(0, -3)
  },
  {
    x = 2,
    y = 1,
    x1 = false,
    y1 = false,
    x2 = true,
    y2 = false,
    point(0, -2),
    point(0, 2),
    point(-2, 0),
    stretch_y = true
  },
  {
    x = 0,
    y = 2,
    x1 = true,
    y1 = false,
    x2 = false,
    y2 = true,
    point(0, 0),
    point(3, 0),
    point(0, -3)
  },
  {
    x = 1,
    y = 2,
    x1 = false,
    y1 = false,
    x2 = false,
    y2 = true,
    point(-2, 0),
    point(2, 0),
    point(0, -2),
    stretch_x = true
  },
  {
    x = 2,
    y = 2,
    x1 = false,
    y1 = false,
    x2 = true,
    y2 = true,
    point(-3, 0),
    point(0, 0),
    point(0, -3)
  }
}
DefineClass.XEditableTerrainAreaMesh = {
  __parents = {
    "XTerrainAreaMesh"
  },
  hover_color = RGBA(240, 230, 150, 100),
  helper_color = RGBA(255, 255, 255, 30),
  helper_size = 40 * guic,
  helpers = false,
  hovered = false,
  start_pt = false,
  start_box = false,
  last_delta = false
}
function XEditableTerrainAreaMesh:Done()
  self:DoneHelpers()
end
function XEditableTerrainAreaMesh:DoneHelpers()
  for _, helper in ipairs(self.helpers) do
    helper:delete()
  end
end
function XEditableTerrainAreaMesh:SetVisible(value)
  for _, helper in ipairs(self.helpers) do
    helper:SetVisible(value)
  end
  XTerrainAreaMesh.SetVisible(self, value)
end
function XEditableTerrainAreaMesh:Setbox(bbox, force_setpos)
  XTerrainAreaMesh.Setbox(self, bbox, force_setpos)
  self:UpdateHelpers()
end
function XEditableTerrainAreaMesh:UpdateHelpers(pt, active_idx)
  local pt1, pt2
  if pt then
    pt1, pt2 = camera.GetEye(), ScreenToGame(pt)
  end
  local treshold_size = snap_size * 32
  local n = Max(self.box:sizex(), self.box:sizey()) / treshold_size + 1
  local helper_size = self.helper_size + self.helper_size * (n - 1) / 2
  if self.box:sizex() <= snap_size * 2 or self.box:sizey() <= snap_size * 2 then
    helper_size = helper_size / 2
  end
  local pivot = self:GetPivot()
  self.helpers = self.helpers or {}
  for idx, data in ipairs(helpers_data) do
    local active = idx == active_idx or pt and self.helpers[idx] and IntersectRayMesh(self, pt1, pt2, self.helpers[idx].vertices_pstr)
    active_idx = active_idx or active and idx
    local color = active and self.hover_color or self.helper_color
    local helper = self.helpers[idx] or Mesh:new()
    local v_pstr = pstr("", 64)
    helper:SetShader(ProceduralMeshShaders.default_mesh)
    helper:SetDepthTest(false)
    for t = 1, #data, 3 do
      local trans = function(pt)
        if data.stretch_x then
          pt = pt:SetX(pt:x() * self.box:sizex() / (helper_size * 6))
        end
        if data.stretch_y then
          pt = pt:SetY(pt:y() * self.box:sizey() / (helper_size * 6))
        end
        return pt * helper_size + point(self.box:minx() + data.x * self.box:sizex() / 2, self.box:miny() + data.y * self.box:sizey() / 2)
      end
      self:AddTriangle(v_pstr, pivot, trans(data[t]), trans(data[t + 1]), trans(data[t + 2]), color)
    end
    helper:SetMesh(v_pstr)
    helper:SetPos(self:GetPos())
    self.helpers[idx] = helper
  end
  return active_idx
end
function XEditableTerrainAreaMesh:UpdateHover(unhover_only)
  local hovered = not unhover_only and GetTerrainCursor():InBox2D(self.box)
  if hovered ~= self.hovered then
    self.hovered = hovered
    self.outer_color = hovered and RGB(240, 220, 120) or nil
    XTerrainAreaMesh.Setbox(self, self.box)
  end
  return hovered
end
function XEditableTerrainAreaMesh:DragStart(idx, pt)
  self.start_pt = pt
  self.start_box = self.box
  self.last_delta = nil
end
function XEditableTerrainAreaMesh:DragMove(idx, pt)
  local data = helpers_data[idx]
  local x1, y1, x2, y2 = self.start_box:xyxy()
  local delta = pt - self.start_pt
  if delta ~= self.last_delta then
    if data.x1 then
      x1 = Min(x2 - snap_size, x1 + delta:x())
    end
    if data.y1 then
      y1 = Min(y2 - snap_size, y1 + delta:y())
    end
    if data.x2 then
      x2 = Max(x1 + snap_size, x2 + delta:x())
    end
    if data.y2 then
      y2 = Max(y1 + snap_size, y2 + delta:y())
    end
    self:Setbox(box(x1, y1, x2, y2), "force_setpos")
    self:UpdateHelpers(pt, idx)
    self.last_delta = delta
  end
end
DefineClass.XTerrainGridData = {
  __parents = {
    "XTerrainAreaMesh",
    "AlignedObj"
  }
}
function XTerrainGridData:Done()
  for _, grid in ipairs(editor.GetGridNames()) do
    local data = rawget(self, grid .. "_grid")
    if data then
      data:free()
    end
  end
end
function XTerrainGridData:AlignObj(pos, angle)
  local pivot = self:GetPivot()
  local offs = (pos or self:GetPos()) - pivot
  if const.SlabSizeX then
    local x = offs:x() / const.SlabSizeX * const.SlabSizeX
    local y = offs:y() / const.SlabSizeY * const.SlabSizeY
    local z = offs:z() and (offs:z() + const.SlabSizeZ / 2) / const.SlabSizeZ * const.SlabSizeZ
    offs = point(x, y, z)
  end
  if XEditorSettings:GetSnapMode() == "BuildLevel" and offs:z() then
    local step = const.BuildLevelHeight
    offs = offs:SetZ((offs:z() + step / 2) / step * step)
  end
  self:SetPosAngle(pivot + offs, angle or self:GetAngle())
end
function XTerrainGridData:GetProperties()
  local props = table.copy(XTerrainAreaMesh:GetProperties())
  for _, grid in ipairs(editor.GetGridNames()) do
    props[#props + 1] = {
      id = grid .. "_grid",
      editor = "grid",
      default = false
    }
  end
  return props
end
function XTerrainGridData:SetProperty(prop_id, value)
  if prop_id == "box" then
    self.box = value
    return
  end
  if prop_id:ends_with("_grid") then
    rawset(self, prop_id, value)
    return
  end
  PropertyObject.SetProperty(self, prop_id, value)
end
function XTerrainGridData:PostLoad(reason)
  self:Setbox(self.box)
end
function XTerrainGridData:CaptureData(bbox)
  for _, grid in ipairs(editor.GetGridNames()) do
    rawset(self, grid .. "_grid", editor.GetGrid(grid, bbox) or false)
  end
  self.box = bbox
end
function XTerrainGridData:RotateGrids()
  local angle = self:GetAngle() / 60
  if angle == 0 then
    return
  end
  local transform, transpose
  if angle == 90 then
    function transform(x, y, w, h)
      return y, w - x
    end
    transpose = true
  elseif angle == 180 then
    function transform(x, y, w, h)
      return w - x, h - y
    end
    transpose = false
  elseif angle == 270 then
    function transform(x, y, w, h)
      return h - y, x
    end
    transpose = true
  end
  for _, grid in ipairs(editor.GetGridNames()) do
    local old = rawget(self, grid .. "_grid")
    if old then
      local new = old:clone()
      local sx, sy = old:size()
      if transpose then
        sx, sy = sy, sx
        new:resize(sx, sy)
      end
      local sx1, sy1 = sx - 1, sy - 1
      for x = 0, sx do
        for y = 0, sy do
          new:set(x, y, old:get(transform(x, y, sx1, sy1)))
        end
      end
      rawset(self, grid .. "_grid", new)
    end
  end
  if transpose then
    local b = self.box - self:GetPivot()
    b = box(b:miny(), b:minx(), b:maxy(), b:maxx())
    self.box = b + self:GetPivot()
  end
end
function XTerrainGridData:ApplyData(paste_grids)
  local pos = self:GetPos()
  if not pos:IsValidZ() then
    pos = pos:SetTerrainZ()
  end
  local offset = pos - self:GetPivot()
  for _, grid in ipairs(editor.GetGridNames()) do
    if paste_grids[grid] then
      local data = rawget(self, grid .. "_grid")
      if data then
        if grid == "height" then
          data = data:clone()
          local offset_z_scaled = offset:z() / const.TerrainHeightScale
          local sx, sy = data:size()
          for x = 0, sx do
            for y = 0, sy do
              local new_z = data:get(x, y) + offset_z_scaled
              new_z = Clamp(new_z, 0, const.MaxTerrainHeight / const.TerrainHeightScale)
              data:set(x, y, new_z)
            end
          end
          editor.SetGrid(grid, data, self.box + offset)
          data:free()
        else
          editor.SetGrid(grid, data, self.box + offset)
        end
      end
    end
  end
end
function XTerrainGridData:GetHeight(pt)
  pt = (pt - self.box:min() + point(const.HeightTileSize / 2, const.HeightTileSize / 2)) / const.HeightTileSize
  return self.height_grid:get(pt) * const.TerrainHeightScale
end
XTerrainGridData.EditorCallbackPlace = UpdateAreas
XTerrainGridData.EditorCallbackDelete = UpdateAreas
local areas, undo_index, op_in_progress
local UpdatePasteOpState = function()
  if op_in_progress then
    return
  end
  op_in_progress = true
  if not areas then
    if IsKindOf(selo(), "XTerrainGridData") then
      local ops = XEditorUndo:GetOpNames()
      local index
      for i = #ops, 2, -1 do
        if string.find(ops[i], "Started pasting", 1, true) then
          index = i - 1
          break
        end
      end
      undo_index = index or XEditorUndo:GetCurrentOpNameIdx()
      areas = editor.GetSel()
      XEditorSetDefaultTool("MoveGizmo", {rotation_arrows_on = true, rotation_arrows_z_only = true})
    end
  else
    if not XEditorUndo.undoredo_in_progress then
      XEditorUndo:RollToOpIndex(undo_index)
    end
    areas = nil
    undo_index = nil
  end
  op_in_progress = false
end
OnMsg.EditorToolChanged = UpdatePasteOpState
OnMsg.EditorSelectionChanged = UpdatePasteOpState
function calculate_center(objs, method)
  local pos = point30
  for _, obj in ipairs(objs) do
    pos = pos + obj[method](obj)
  end
  return pos / #objs
end
function XEditorPasteFuncs.PasteTerrainAndObjects(clipboard_data, clipboard_text)
  CreateRealTimeThread(function()
    if not LocalStorage.FilteredCategories.Roofs then
      print("Please paste with Roof visibility enabled.")
      return
    end
    PauseInfiniteLoopDetection("PasteTerrainAndObjects")
    local grid_to_item_map = {
      BiomeGrid = "Biome",
      height = "Terrain height",
      terrain_type = "Terrain texture",
      grass_density = "Grass density",
      impassability = "Impassability",
      passability = "Passability",
      colorize = "Terrain colorization",
      Biome = "BiomeGrid",
      ["Terrain height"] = "height",
      ["Terrain texture"] = "terrain_type",
      ["Grass density"] = "grass_density",
      Impassability = "impassability",
      Passability = "passability",
      ["Terrain colorization"] = "colorize"
    }
    if const.CaveTileSize then
      grid_to_item_map.CaveGrid = "Caves"
      grid_to_item_map.Caves = "CaveGrid"
    end
    if not areas or #table.validate(areas) == 0 then
      op_in_progress = true
      XEditorUndo:BeginOp({
        name = "Started pasting",
        clipboard = clipboard_text
      })
      local areas = XEditorDeserialize(clipboard_data)
      XEditorSelectAndMoveObjects(areas, editor.GetPlacementPoint(GetTerrainCursor()) - clipboard_data.pivot)
      XEditorUndo:EndOp(areas)
      op_in_progress = false
      UpdatePasteOpState()
    else
      op_in_progress = true
      XEditorSetDefaultTool()
      local op = {}
      local grids = {}
      local items = {}
      local starting_selection = {}
      for idx, grid in ipairs(editor.GetGridNames()) do
        op[grid] = true
        grids[idx] = grid
        if LocalStorage.XAreaCopyTool[grid] then
          table.insert(starting_selection, idx)
        end
        if grid_to_item_map[grid] then
          table.insert(items, grid_to_item_map[grid])
        end
      end
      local result = WaitListMultipleChoice(nil, items, "Choose grids to paste:", starting_selection)
      if not result then
        for _, a in ipairs(areas) do
          a:delete()
        end
        areas = nil
        undo_index = nil
        op_in_progress = nil
        ResumeInfiniteLoopDetection("PasteTerrainAndObjects")
        return
      end
      if #result == 0 then
        result = items
      end
      local paste_grids = {}
      for _, item in ipairs(result) do
        if grid_to_item_map[item] then
          local grid = grid_to_item_map[item]
          paste_grids[grid] = true
        end
      end
      LocalStorage.XAreaCopyTool = table.copy(paste_grids)
      SaveLocalStorage()
      op.name = "Pasted terrain & objects"
      op.objects = areas
      op.clipboard = clipboard_text
      XEditorUndo:BeginOp(op)
      local offs = calculate_center(areas, "GetPos") - calculate_center(areas, "GetPivot")
      local angle = areas[1]:GetAngle()
      local center = CenterOfMasses(areas)
      for _, a in ipairs(areas) do
        a:RotateGrids()
        a:ApplyData(paste_grids)
        a:delete()
      end
      local objs = XEditorDeserialize(clipboard_data.objs, nil, "paste")
      objs = XEditorSelectAndMoveObjects(objs, offs)
      editor.ClearSel()
      if angle ~= 0 then
        local rotate_logic = XEditorRotateLogic:new()
        SuspendPassEditsForEditOp()
        rotate_logic:InitRotation(objs, center, 0)
        rotate_logic:Rotate(objs, "group_rotation", center, axis_z, angle)
        ResumePassEditsForEditOp()
      end
      XEditorUndo:EndOp(objs)
      areas = nil
      undo_index = nil
      op_in_progress = nil
    end
    ResumeInfiniteLoopDetection("PasteTerrainAndObjects")
  end)
end
function OnMsg.ChangeMap()
  areas = nil
  undo_index = nil
  op_in_progress = nil
end
