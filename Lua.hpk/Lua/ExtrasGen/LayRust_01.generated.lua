rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayRust_01(seed, initial_selection)
  local li = {id = "LayRust_01"}
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(LayDecalsAlongGuide.Exec, LayDecalsAlongGuide, rand, initial_selection, nil, {
    PlaceObj("PlaceObjectDataDecal", {
      EditorClass = "DecWallRust_01",
      MoveDownPercent = 15,
      Scale = 150
    })
  }, false)
end
