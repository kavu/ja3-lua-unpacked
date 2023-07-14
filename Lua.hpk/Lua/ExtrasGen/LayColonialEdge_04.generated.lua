rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayColonialEdge_04(seed, initial_selection)
  local li = {
    id = "LayColonialEdge_04"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(LaySlabsAlongGuides.Exec, LaySlabsAlongGuides, rand, initial_selection, nil, true, true, true, 0, true, 1, 0, 0, true, true, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "WallDec_Colonial_Column_Bottom_04",
      Rotate = 5400
    })
  }, false, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "WallDec_Colonial_Column_Body_04",
      Rotate = 5400
    })
  }, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "WallDec_Colonial_Column_Top_04",
      Rotate = 5400
    })
  }, false, false, false, true, true, 0, 0, false, false)
end
