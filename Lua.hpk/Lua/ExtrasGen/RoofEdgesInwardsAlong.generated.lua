rawset(_G, "ExtrasGenPrgs", rawget(_G, "ExtrasGenPrgs") or {})
function ExtrasGenPrgs.RoofEdgesInwardsAlong(seed, initial_selection)
  local li = {
    id = "RoofEdgesInwardsAlong"
  }
  initial_selection = initial_selection or editor.GetSel()
  local rand = BraidRandomCreate(seed or AsyncRand())
  local _, guides
  prgdbg(li, 1, 1)
  _, guides = sprocall(PlaceRoomGuides.Exec, PlaceRoomGuides, initial_selection, guides, "Roof", false, true, true, true, true, true, "Both", 1, 0, 0, "Inwards (wall)")
  prgdbg(li, 1, 2)
  for i, value in ipairs(initial_selection) do
    prgdbg(li, 2, 1)
    if value.roof_type == "Gable" then
      local _
      prgdbg(li, 3, 1)
      _, guides = sprocall(PlaceRoomGuides.Exec, PlaceRoomGuides, value, guides, "Roof", false, true, true, true, true, true, "Middle", 1, 0, 0, "Inwards (wall)")
      li[3] = nil
    end
    li[2] = nil
  end
  prgdbg(li, 1, 3)
  sprocall(SelectInEditor.Exec, SelectInEditor, guides, true, true)
end
