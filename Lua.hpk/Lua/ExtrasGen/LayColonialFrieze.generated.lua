rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayColonialFrieze(seed, initial_selection)
  local li = {
    id = "LayColonialFrieze"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(MoveSizeGuides.Exec, MoveSizeGuides, initial_selection, 700, -700, "m", 0, "m", 0, false)
  prgdbg(li, 1, 2)
  sprocall(LaySlabsAlongGuides.Exec, LaySlabsAlongGuides, rand, initial_selection, nil, true, true, true, 0, true, 1, 0, 0, true, true, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "WallDec_Colonial_Frieze_Corner_01"
    })
  }, false, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "WallDec_Colonial_Frieze_Body_01"
    })
  }, false, false, true, true, false, false, 0, 0, false, false)
  prgdbg(li, 1, 3)
  sprocall(MoveSizeGuides.Exec, MoveSizeGuides, initial_selection, 700, 700, "m", 0, "m", 0, false)
end
