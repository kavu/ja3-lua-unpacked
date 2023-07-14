rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LeaksBelowWindows(seed, initial_selection)
  local li = {
    id = "LeaksBelowWindows"
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
  _, guides = sprocall(PlaceGuidesAroundSlabs.Exec, PlaceGuidesAroundSlabs, windows, guides, false, true, false, false, true, false)
  prgdbg(li, 1, 3)
  sprocall(LayDecalsAlongGuide.Exec, LayDecalsAlongGuide, rand, guides, nil, {
    PlaceObj("PlaceObjectDataDecal", {
      EditorClass = "DecWallLeak_02"
    })
  }, true)
  prgdbg(li, 1, 4)
  sprocall(DeleteObjects.Exec, DeleteObjects, guides)
end
