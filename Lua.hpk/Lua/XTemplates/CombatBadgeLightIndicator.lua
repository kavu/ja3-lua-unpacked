PlaceObj("XTemplate", {
  __is_kind_of = "XContextImage",
  group = "Zulu Badges",
  id = "CombatBadgeLightIndicator",
  PlaceObj("XTemplateWindow", {
    "__condition",
    function(parent, context)
      return GameState.Night or GameState.Underground
    end,
    "__class",
    "XContextImage",
    "Dock",
    "right",
    "HAlign",
    "right",
    "MinWidth",
    12,
    "MinHeight",
    12,
    "MaxWidth",
    12,
    "MaxHeight",
    12,
    "FoldWhenHidden",
    true,
    "Image",
    "UI/PDA/MercPortrait/CircleMask",
    "ImageFit",
    "stretch"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self, ...)",
      "func",
      function(self, ...)
        XImage.Open(self, ...)
        local unit = self.context
        self:CreateThread("updateVis", function()
          local badge = self:ResolveId("node")
          if not IsKindOf(badge, "CombatBadge") then
            badge = false
          end
          while self.window_state ~= "destroying" do
            if badge then
              local mode = badge.mode
              self:SetVisible(mode ~= "npc" and mode ~= "npc-ambient")
            end
            local inDark = unit:HasStatusEffect("Darkness")
            self:SetImageColor(inDark and white or GameColors.C)
            self:SetImage(inDark and "UI/PDA/MercPortrait/LightIndicatorDark" or "UI/PDA/MercPortrait/CircleMask")
            Sleep(100)
          end
        end)
      end
    })
  })
})
