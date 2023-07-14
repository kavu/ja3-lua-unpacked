rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.DirtOnWalls(seed, initial_selection)
  local li = {
    id = "DirtOnWalls"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  local __sel = initial_selection
  initial_selection = {}
  for _, obj in ipairs(__sel) do
    if IsKindOf(obj, "Room") then
      PrgSelectRoomComponents.Add(obj, "Walls", 1, 10, initial_selection, ExtrasGenParams.North, ExtrasGenParams.South, ExtrasGenParams.East, ExtrasGenParams.West)
    end
  end
  local _
  prgdbg(li, 1, 2)
  _, initial_selection = sprocall(ReduceSpaceOut.Exec, ReduceSpaceOut, rand, initial_selection, 2000)
  prgdbg(li, 1, 3)
  local selection
  prgdbg(li, 1, 4)
  for i, value in ipairs(initial_selection) do
    local _
    prgdbg(li, 2, 1)
    _, selection = sprocall(PrgPlaceObject.Exec, PrgPlaceObject, rand, {
      PlaceObj("PlaceObjectData", {
        EditorClass = "DecBunkerFloor_02"
      })
    }, value, "Add to", selection)
    li[2] = nil
  end
  prgdbg(li, 1, 5)
  sprocall(PrgAlign.Exec, PrgAlign, rand, selection, "Wall exterior")
  prgdbg(li, 1, 6)
  sprocall(PrgRotate.Exec, PrgRotate, rand, selection, false, true, point(0, 0, 4096), 0, 10800)
  prgdbg(li, 1, 7)
  sprocall(SelectInEditor.Exec, SelectInEditor, selection, true, true)
end
