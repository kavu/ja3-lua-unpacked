rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.TopInwards(seed, initial_selection)
  local li = {id = "TopInwards"}
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, guides
  prgdbg(li, 1, 1)
  _, guides = sprocall(PlaceRoomGuides.Exec, PlaceRoomGuides, initial_selection, guides, "Wall interior", true, true, true, true, true, true, "Top", 1, 0, 0, "Inwards (room)")
  prgdbg(li, 1, 2)
  sprocall(SelectInEditor.Exec, SelectInEditor, guides, true, true)
end
