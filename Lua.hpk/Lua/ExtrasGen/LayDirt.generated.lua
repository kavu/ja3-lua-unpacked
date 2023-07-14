rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayDirt(seed, initial_selection)
  local li = {id = "LayDirt"}
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(LayDecalsAlongGuide.Exec, LayDecalsAlongGuide, rand, initial_selection, nil, {
    PlaceObj("PlaceObjectDataDecal", {
      EditorClass = "DecWallDirt_03",
      FlipVertically = true,
      MoveDownPercent = 5,
      ScaleAfterPlace = 108
    }),
    PlaceObj("PlaceObjectDataDecal", {
      EditorClass = "DecWallDirt_06",
      MoveDownPercent = 50
    }),
    PlaceObj("PlaceObjectDataDecal", {
      EditorClass = "DecWallDirt_07",
      MoveDownPercent = 50
    })
  }, false)
end
