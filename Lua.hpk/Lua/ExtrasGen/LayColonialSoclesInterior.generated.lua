rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayColonialSoclesInterior(seed, initial_selection)
  local li = {
    id = "LayColonialSoclesInterior"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(LaySlabsAlongGuides.Exec, LaySlabsAlongGuides, rand, initial_selection, nil, true, true, true, 0, true, 1, 0, 0, true, false, false, false, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "WallDec_Colonial_Socle_Body_01"
    })
  }, false, false, true, true, false, false, 0, 0, false, false)
end
