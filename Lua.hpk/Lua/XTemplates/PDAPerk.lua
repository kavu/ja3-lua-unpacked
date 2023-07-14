PlaceObj("XTemplate", {
  group = "Zulu PDA",
  id = "PDAPerk",
  PlaceObj("XTemplateWindow", {
    "IdNode",
    true,
    "RolloverDrawOnTop",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "background",
      "__class",
      "XContextFrame",
      "RolloverTemplate",
      "PDAPerkRollover",
      "RolloverAnchor",
      "custom",
      "RolloverOffset",
      box(0, 0, 0, 10),
      "BorderWidth",
      2,
      "Dock",
      "box",
      "MinWidth",
      70,
      "MinHeight",
      70,
      "MaxWidth",
      70,
      "MaxHeight",
      70,
      "BorderColor",
      RGBA(60, 63, 68, 255),
      "HandleMouse",
      true,
      "MouseCursor",
      "UI/Cursors/Pda_Hand.tga",
      "DisabledBorderColor",
      RGBA(60, 63, 68, 255),
      "FrameBox",
      box(2, 2, 2, 2),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local node = self:ResolveId("node")
        local perk = CharacterEffectDefs[node.PerkId]
        if perk and perk.Tier == "Personal" then
          self:SetImage("UI/PDA/talent_background")
          self:SetBorderColor(RGBA(0, 0, 0, 0))
          self:SetDisabledBorderColor(RGBA(0, 0, 0, 0))
          self:SetBorderWidth(0)
        elseif perk and perk.Tier == "Quirk" or perk.Tier == "Specialization" or perk.Tier == "Personality" then
          self:SetImage("UI/PDA/quirks_background")
          self:SetBorderColor(RGBA(0, 0, 0, 0))
          self:SetDisabledBorderColor(RGBA(0, 0, 0, 0))
          self:SetBorderWidth(0)
        else
          self:SetBackground(RGBA(42, 45, 54, 120))
          self:SetDisabledBackground(RGBA(42, 45, 54, 120))
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "icon",
      "__class",
      "XContextImage",
      "RolloverTemplate",
      "PDAPerkRollover",
      "RolloverAnchor",
      "custom",
      "RolloverOffset",
      box(0, 0, 0, 10),
      "MinWidth",
      70,
      "MinHeight",
      70,
      "MaxWidth",
      70,
      "MaxHeight",
      70,
      "RolloverDrawOnTop",
      true,
      "HandleMouse",
      true,
      "MouseCursor",
      "UI/Cursors/Pda_Hand.tga",
      "FXMouseIn",
      "PerkRollover",
      "FXPress",
      "PerkPress",
      "ImageScale",
      point(700, 700),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local node = self:ResolveId("node")
        local perk = CharacterEffectDefs[node.PerkId]
        if perk then
          self:SetImage(perk.Icon)
          self:SetRolloverTitle(T({
            perk.DisplayName,
            perk
          }))
          self:SetRolloverText(T({
            perk.Description,
            perk
          }))
        end
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "Perk",
    "id",
    "PerkId",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.PerkId = value
    end,
    "Get",
    function(self)
      return self.PerkId
    end,
    "name",
    T(285357351922, "Perk Id")
  })
})
