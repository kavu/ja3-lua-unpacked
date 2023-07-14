rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.SoclesBelowWindows(seed, initial_selection)
  local li = {
    id = "SoclesBelowWindows"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  local __sel = initial_selection
  local windows = {}
  for _, obj in ipairs(__sel) do
    if IsKindOf(obj, "Room") then
      PrgSelectRoomComponents.Add(obj, "Windows", 1, 10, windows, ExtrasGenParams.North, ExtrasGenParams.South, ExtrasGenParams.East, ExtrasGenParams.West)
    end
  end
  local _, guides
  prgdbg(li, 1, 2)
  _, guides = sprocall(PlaceGuidesAroundSlabs.Exec, PlaceGuidesAroundSlabs, windows, guides, false, true, false, false, true, true)
  prgdbg(li, 1, 3)
  sprocall(MoveSizeGuides.Exec, MoveSizeGuides, guides, 700, -700, "m", 0, "m", 0, false)
  prgdbg(li, 1, 4)
  sprocall(LaySlabsAlongGuides.Exec, LaySlabsAlongGuides, rand, guides, nil, true, true, true, 0, true, 1, 0, 0, true, false, false, false, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "WallDec_Colonial_Socle_Body_01"
    })
  }, false, false, false, false, false, false, 0, 0, false, false)
  prgdbg(li, 1, 5)
  sprocall(DeleteObjects.Exec, DeleteObjects, guides)
end
