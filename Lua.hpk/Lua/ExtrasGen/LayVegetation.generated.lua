rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayVegetation(seed, initial_selection)
  local li = {
    id = "LayVegetation"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(LayObjectsAlongGuides.Exec, LayObjectsAlongGuides, rand, initial_selection, nil, 0, 350, 5400, 0, true, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "BunkerInterior_AmmoBox_02"
    })
  }, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "TropicalPlant_06_Tree_01"
    })
  }, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "TreeAttach_02"
    })
  }, {
    PlaceObj("PlaceObjectData", {
      EditorClass = "BunkerInterior_AmmoBox_02"
    })
  })
end
