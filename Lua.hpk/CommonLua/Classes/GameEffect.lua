DefineClass.GameEffect = {
  __parents = {
    "PropertyObject"
  },
  StoreAsTable = true,
  EditorName = false,
  Description = "",
  EditorView = Untranslated("<color 128 128 128><u(EditorName)></color> <Description> <color 75 105 198><u(comment)></color>"),
  properties = {
    {
      category = "General",
      id = "comment",
      name = T(964541079092, "Comment"),
      default = "",
      editor = "text",
      editor_update = "Subitems"
    }
  }
}
function GameEffect:OnInitEffect(player, parent)
end
function GameEffect:OnApplyEffect(player, parent)
end
DefineClass.GameEffectsContainer = {
  __parents = {"Container"},
  ContainerClass = "GameEffect"
}
function GameEffectsContainer:EffectsInit(player)
  for _, effect in ipairs(self) do
    procall(effect.OnInitEffect, effect, player, self)
  end
end
function GameEffectsContainer:EffectsApply(player)
  for _, effect in ipairs(self) do
    procall(effect.OnApplyEffect, effect, player, self)
  end
end
function GameEffectsContainer:EffectsGatherTech(map)
  for _, effect in ipairs(self) do
    if IsKindOf(effect, "Effect_GrantTech") then
      map[effect.Research] = true
    end
  end
end
function GameEffectsContainer:GetEffectIdentifier()
  return "GameEffect"
end
