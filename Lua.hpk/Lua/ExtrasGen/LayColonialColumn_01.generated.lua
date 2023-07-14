rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayColonialColumn_01(seed, initial_selection)
  local li = {
    id = "LayColonialColumn_01"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(LaySlabsAlongGuides.Exec, LaySlabsAlongGuides, rand, initial_selection, nil, true, true, true, 0, true, 1, 0, 0, true, true, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "Column_Colonial_Bottom_01"
    })
  }, false, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "Column_Colonial_Body_01"
    })
  }, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "Column_Colonial_Top_01"
    })
  }, false, false, false, true, true, 0, 0, false, false)
end
