rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.LengthDown(seed, initial_selection)
  local li = {id = "LengthDown"}
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(MoveSizeGuides.Exec, MoveSizeGuides, initial_selection, "m", 0, "m", 0, 1, -1, true)
end
