DefineClass.StoryBitWithWeight = {
  __parents = {
    "PropertyObject"
  },
  __generated_by_class = "ClassDef",
  properties = {
    {
      id = "StoryBitId",
      name = "Id",
      editor = "preset_id",
      default = false,
      preset_class = "StoryBit"
    },
    {
      id = "NoCooldown",
      help = "Don't activate any cooldowns for subsequent StoryBit activations",
      editor = "bool",
      default = false
    },
    {
      id = "ForcePopup",
      name = "Force Popup",
      help = "Specifying true skips the notification phase, and directly displays the popup",
      editor = "bool",
      default = true
    },
    {
      id = "Weight",
      name = "Weight",
      editor = "number",
      default = 100,
      min = 0
    },
    {
      id = "StorybitSets",
      name = "Storybit sets",
      editor = "text",
      default = "<StorybitSets>",
      dont_save = true,
      read_only = true
    },
    {
      id = "OneTime",
      editor = "bool",
      default = false,
      dont_save = true,
      read_only = true
    }
  },
  EditorView = Untranslated("\"Activate StoryBit <StoryBitId> (weight: <Weight>)\"")
}
function StoryBitWithWeight:GetStorybitSets()
  local preset = StoryBits[self.StoryBitId]
  if not preset or not next(preset.Sets) then
    return "None"
  end
  local items = {}
  for set in sorted_pairs(preset.Sets) do
    items[#items + 1] = set
  end
  return table.concat(items, ", ")
end
function StoryBitWithWeight:GetOneTime()
  local preset = StoryBits[self.StoryBitId]
  return preset and preset.OneTime
end
function StoryBitWithWeight:GetError()
  local story_bit = StoryBits[self.StoryBitId]
  if not story_bit then
    return "Invalid StoryBit preset"
  end
end
