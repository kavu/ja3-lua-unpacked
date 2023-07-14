rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayColonialColumn_02(seed, initial_selection)
  local li = {
    id = "LayColonialColumn_02"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(LaySlabsAlongGuides.Exec, LaySlabsAlongGuides, rand, initial_selection, nil, false, true, true, 0, true, 1, 0, 0, true, true, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "Column_Colonial_Bottom_01"
    })
  }, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "Column_Colonial_Bottom_02"
    })
  }, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "Column_Colonial_Body_01"
    })
  }, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "Column_Colonial_Top_01"
    })
  }, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "Column_Colonial_Top_02"
    })
  }, false, false, true, true, 300, 610, false, false)
end
