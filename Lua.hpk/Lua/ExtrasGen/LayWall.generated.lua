rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayWall(seed, initial_selection)
  local li = {id = "LayWall"}
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(LaySlabsAlongGuides.Exec, LaySlabsAlongGuides, rand, initial_selection, nil, true, true, false, 0, true, 1, 0, 0, true, false, {
    PlaceObj("PlaceObjectData", {EditorClass = "RoomCorner"})
  }, false, {
    PlaceObj("PlaceObjectData", {EditorClass = "WallSlab"})
  }, false, false, true, false, false, false, 0, 0, false, false)
end
