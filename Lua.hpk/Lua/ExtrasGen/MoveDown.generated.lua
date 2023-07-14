rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.MoveDown(seed, initial_selection)
  local li = {id = "MoveDown"}
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(MoveSizeGuides.Exec, MoveSizeGuides, initial_selection, 700, -700, "m", 0, "m", 0, true)
end
