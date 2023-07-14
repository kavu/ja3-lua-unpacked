rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.BetweenSlabs(seed, initial_selection)
  local li = {
    id = "BetweenSlabs"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, guides
  prgdbg(li, 1, 1)
  _, guides = sprocall(PlaceGuidesBetweenSlabs.Exec, PlaceGuidesBetweenSlabs, initial_selection, guides)
  prgdbg(li, 1, 2)
  sprocall(SelectInEditor.Exec, SelectInEditor, guides, true, true)
end
