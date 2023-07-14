rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LayColonialStairs(seed, initial_selection)
  local li = {
    id = "LayColonialStairs"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(MoveSizeGuides.Exec, MoveSizeGuides, initial_selection, 700, 700, 1200, -1200, 1200, -2400, false)
  prgdbg(li, 1, 2)
  if 4 <= #initial_selection then
    prgdbg(li, 2, 1)
    sprocall(LaySlabsAlongGuides.Exec, LaySlabsAlongGuides, rand, initial_selection, nil, true, false, false, 0, true, 1, 0, 0, true, false, {
      PlaceObj("PlaceObjectData", {
        EditorClass = "Stairs_Colonial_Edge_01",
        Mirror = true
      })
    }, false, {
      PlaceObj("PlaceObjectData", {
        EditorClass = "Stairs_Colonial_01",
        Rotate = 5400,
        Weight = 80
      }),
      PlaceObj("PlaceObjectData", {
        EditorClass = "Stairs_Colonial_02",
        Rotate = 5400,
        Weight = 20
      })
    }, false, false, false, false, false, false, 0, 0, true, false)
    li[2] = nil
  else
    prgdbg(li, 1, 3)
    prgdbg(li, 2, 1)
    sprocall(LaySlabsAlongGuides.Exec, LaySlabsAlongGuides, rand, initial_selection, nil, true, false, false, 0, true, 1, 0, 0, true, false, {
      PlaceObj("PlaceObjectData", {
        EditorClass = "Stairs_Colonial_Edge_01",
        Mirror = true
      })
    }, false, {
      PlaceObj("PlaceObjectData", {
        EditorClass = "Stairs_Colonial_01",
        Rotate = 5400,
        Weight = 80
      }),
      PlaceObj("PlaceObjectData", {
        EditorClass = "Stairs_Colonial_02",
        Rotate = 5400,
        Weight = 20
      })
    }, {
      PlaceObj("PlaceObjectData", {
        EditorClass = "Stairs_Colonial_Edge_01"
      })
    }, false, false, false, false, false, 0, 0, true, true)
    li[2] = nil
  end
end
