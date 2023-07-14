rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayPlatformInside(seed, initial_selection)
  local li = {
    id = "LayPlatformInside"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  if #initial_selection ~= 4 then
    prgdbg(li, 2, 1)
    sprocall(PrgPrint.Exec, "Four guides in a rectangle required - use the New Guides tool to place them.")
    li[2] = nil
  else
    prgdbg(li, 1, 2)
    prgdbg(li, 2, 1)
    local guide1 = initial_selection[1]
    prgdbg(li, 2, 2)
    local guide2 = initial_selection[2]
    prgdbg(li, 2, 3)
    if guide1:GetNormal() + guide2:GetNormal() ~= point30 then
      prgdbg(li, 3, 1)
      guide2 = initial_selection[3]
      li[3] = nil
    end
    prgdbg(li, 2, 4)
    if guide1:GetNormal() + guide2:GetNormal() ~= point30 then
      prgdbg(li, 3, 1)
      guide2 = initial_selection[4]
      li[3] = nil
    end
    prgdbg(li, 2, 5)
    local counter = 0
    prgdbg(li, 2, 6)
    local slabs = {}
    prgdbg(li, 2, 7)
    while 0 > Dot(guide2:GetPos() - guide1:GetPos(), guide1:GetNormal()) do
      prgdbg(li, 3, 1)
      sprocall(MoveSizeGuides.Exec, MoveSizeGuides, guide1, "m", 0, 1200, -1200, "m", 0, false)
      local _
      prgdbg(li, 3, 2)
      _, slabs = sprocall(LaySlabsAlongGuides.Exec, LaySlabsAlongGuides, rand, guide1, slabs, true, false, false, 0, true, 1, 0, 0, true, false, false, false, {
        PlaceObj("PlaceObjectData", {EditorClass = "FloorSlab"})
      }, false, false, false, false, false, false, 0, 0, false, false)
      prgdbg(li, 3, 3)
      counter = counter + 1
      li[3] = nil
    end
    prgdbg(li, 2, 8)
    while 0 < counter do
      prgdbg(li, 3, 1)
      sprocall(MoveSizeGuides.Exec, MoveSizeGuides, guide1, "m", 0, 1200, 1200, "m", 0, false)
      prgdbg(li, 3, 2)
      counter = counter - 1
      li[3] = nil
    end
    prgdbg(li, 2, 9)
    sprocall(SelectInEditor.Exec, SelectInEditor, slabs, false, true)
    li[2] = nil
  end
end
