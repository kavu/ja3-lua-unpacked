rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.DeleteGuides(seed, initial_selection)
  local li = {
    id = "DeleteGuides"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  prgdbg(li, 1, 1)
  sprocall(RemoveRoomGuides.Exec, RemoveRoomGuides, initial_selection)
end
