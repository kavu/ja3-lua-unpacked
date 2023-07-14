rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.CracksOnFloor(seed, initial_selection)
  local li = {
    id = "CracksOnFloor"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  local __sel = initial_selection
  initial_selection = {}
  for _, obj in ipairs(__sel) do
    if IsKindOf(obj, "Room") then
      PrgSelectRoomComponents.Add(obj, "Floors", 1, 10, initial_selection, true, true, true, true)
    end
  end
  local _
  prgdbg(li, 1, 2)
  _, initial_selection = sprocall(ReduceSpaceOut.Exec, ReduceSpaceOut, rand, initial_selection, 4000)
  prgdbg(li, 1, 3)
  local selection
  prgdbg(li, 1, 4)
  for i, value in ipairs(initial_selection) do
    local _
    prgdbg(li, 2, 1)
    _, selection = sprocall(PrgPlaceObject.Exec, PrgPlaceObject, rand, {
      PlaceObj("PlaceObjectData", {
        EditorClass = "DecBunkerFloor_03"
      }),
      PlaceObj("PlaceObjectData", {
        EditorClass = "DecBunkerFloor_04"
      })
    }, value, "Add to", selection)
    li[2] = nil
  end
  prgdbg(li, 1, 5)
  sprocall(PrgRotate.Exec, PrgRotate, rand, selection, false, true, point(0, 0, 4096), 0, 10800)
  prgdbg(li, 1, 6)
  sprocall(SelectInEditor.Exec, SelectInEditor, selection, true, true)
end
