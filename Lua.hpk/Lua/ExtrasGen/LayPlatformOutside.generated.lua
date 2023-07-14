rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayPlatformOutside(seed, initial_selection)
  local li = {
    id = "LayPlatformOutside"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(LaySlabsAlongGuides.Exec, LaySlabsAlongGuides, rand, initial_selection, nil, true, false, false, 0, true, 1, 0, 0, true, false, {
    PlaceObj("PlaceObjectData", {EditorClass = "FloorSlab"})
  }, false, {
    PlaceObj("PlaceObjectData", {EditorClass = "FloorSlab"})
  }, false, false, false, false, false, false, 0, 0, true, false)
end
