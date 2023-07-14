rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.MoveBack(seed, initial_selection)
  local li = {id = "MoveBack"}
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(MoveSizeGuides.Exec, MoveSizeGuides, initial_selection, "m", 0, 1, -1, "m", 0, true)
end
