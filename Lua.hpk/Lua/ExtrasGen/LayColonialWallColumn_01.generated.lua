rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayColonialWallColumn_01(seed, initial_selection)
  local li = {
    id = "LayColonialWallColumn_01"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(LaySlabsAlongGuides.Exec, LaySlabsAlongGuides, rand, initial_selection, nil, false, true, true, 0, true, 1, 0, 0, true, true, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "WallDec_Colonial_Column_Bottom_01"
    })
  }, false, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "WallDec_Colonial_Column_Body_01"
    })
  }, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "WallDec_Colonial_Column_Top_01"
    })
  }, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "WallDec_Colonial_01"
    })
  }, false, false, false, false, 0, 0, false, false)
end
