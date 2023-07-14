rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayLeaks(seed, initial_selection)
  local li = {id = "LayLeaks"}
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(LayDecalsAlongGuide.Exec, LayDecalsAlongGuide, rand, initial_selection, nil, {
    PlaceObj("PlaceObjectDataDecal", {
      EditorClass = "DecWallLeak_01"
    }),
    PlaceObj("PlaceObjectDataDecal", {
      EditorClass = "DecWallLeak_02"
    }),
    PlaceObj("PlaceObjectDataDecal", {
      EditorClass = "DecWallLeak_03"
    }),
    PlaceObj("PlaceObjectDataDecal", {
      EditorClass = "DecWallLeak_04"
    })
  }, false)
end
