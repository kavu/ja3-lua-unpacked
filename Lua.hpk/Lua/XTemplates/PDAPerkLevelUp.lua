PlaceObj("XTemplate", {
  __is_kind_of = "XToggleButton",
  group = "Zulu PDA",
  id = "PDAPerkLevelUp",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XToggleButton",
    "RolloverAnchor",
    "custom",
    "RolloverOffset",
    box(0, 0, 0, 10),
    "MinWidth",
    74,
    "MinHeight",
    74,
    "MaxWidth",
    74,
    "MaxHeight",
    74,
    "DrawOnTop",
    true,
    "MouseCursor",
    "UI/Cursors/Pda_Hand.tga",
    "OnContextUpdate",
    function(self, context, ...)
      local perkId = self:GetPerkId()
      local perk = CharacterEffectDefs[self.PerkId]
      local perksDlg = GetDialog(self)
      self:SetRolloverTitle(T({
        perk.DisplayName,
        perk
      }))
      self:SetRolloverText(T({
        perk.Description,
        perk
      }))
      if context[perk.Stat] < perk.StatValue then
        local text = T({
          646447383292,
          "Required <stat> <halign right><statValue>",
          stat = perk.Stat,
          statValue = perk.StatValue
        })
      end
      if table.find(perksDlg.SelectedPerkIds, perkId) then
        self:SetToggled(true)
      else
        self:SetToggled(false)
      end
    end,
    "FXMouseIn",
    "buttonRollover",
    "FXPress",
    "buttonPress",
    "FXPressDisabled",
    "IactDisabled",
    "OnPress",
    function(self, gamepad)
      local perksDlg = GetDialog(self)
      local perkId = self:GetPerkId()
      if not HasPerk(perksDlg.unit, perkId) then
        if self.Toggled then
          perksDlg:SelectPerk(perkId, false)
        elseif perksDlg.PerkPoints > 0 then
          perksDlg:SelectPerk(perkId, true)
        elseif perksDlg.SelectedPerkIds and #perksDlg.SelectedPerkIds == 1 then
          local oldPerkId = perksDlg.SelectedPerkIds[1]
          perksDlg:SelectPerk(oldPerkId, false)
          if perksDlg:CanUnlockPerk(perksDlg.unit, CharacterEffectDefs[perkId]) then
            perksDlg:SelectPerk(perkId, true)
          else
            perksDlg:SelectPerk(oldPerkId, true)
            perksDlg:CreateThread(function()
              perksDlg.idPerksContent.idPointsText:SetEnabled(false)
              Sleep(1500)
              perksDlg.idPerksContent.idPointsText:SetEnabled(true)
            end)
          end
        else
          if perksDlg.SelectedPerkIds and #perksDlg.SelectedPerkIds > 1 then
            perksDlg.idPerksContent.idPerksScrollArea.idPerksWarning:SetVisible(true)
          end
          perksDlg:CreateThread(function()
            perksDlg.idPerksContent.idPointsText:SetEnabled(false)
            Sleep(1500)
            perksDlg.idPerksContent.idPointsText:SetEnabled(true)
          end)
        end
      else
      end
      XTextButton.OnPress(self)
    end,
    "AltPress",
    true,
    "OnAltPress",
    function(self, gamepad)
      local perksDlg = GetDialog(self)
      local perkId = self:GetPerkId()
      if self.Toggled then
        perksDlg:SelectPerk(perkId, false)
      end
    end
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        if rollover and not self:TryMarkUIFX(self.FXMouseIn) then
          return false
        end
        self:PlayFX(self.FXMouseIn, rollover and "start" or "end")
        self:ResolveId("idPerkRollover"):SetVisible(rollover)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextFrame",
      "Id",
      "idPerkLearned",
      "IdNode",
      false,
      "Dock",
      "box",
      "Visible",
      false,
      "Image",
      "UI/Inventory/perk_achieved",
      "FrameBox",
      box(3, 3, 3, 3),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local unit = GetDialog(self).unit
        local button = self:ResolveId("node")
        if HasPerk(unit, button.PerkId) then
          self:SetVisible(true)
          button:ResolveId("idPerkSelected"):SetVisible(false)
        end
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "HAlign",
        "right",
        "VAlign",
        "bottom",
        "Image",
        "UI/Inventory/perk_achieved_marker"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "icon",
      "__class",
      "XContextImage",
      "IdNode",
      false,
      "BorderWidth",
      2,
      "Dock",
      "box",
      "HAlign",
      "left",
      "MinWidth",
      74,
      "MinHeight",
      74,
      "MaxWidth",
      74,
      "MaxHeight",
      74,
      "BorderColor",
      RGBA(52, 55, 61, 255),
      "Background",
      RGBA(32, 35, 47, 255),
      "HandleMouse",
      true,
      "DisabledBorderColor",
      RGBA(52, 55, 61, 255),
      "DisabledBackground",
      RGBA(32, 35, 47, 255),
      "ImageScale",
      point(700, 700),
      "DisabledImageColor",
      RGBA(255, 255, 255, 78),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local perkId = self:ResolveId("node").PerkId
        local perk = CharacterEffectDefs[perkId]
        self:SetImage(perk.Icon)
        self:SetRolloverTitle(T({
          perk.DisplayName,
          perk
        }))
        self:SetRolloverText(T({
          perk.Description,
          perk
        }))
        local unit = GetDialog(self).unit
        if HasPerk(unit, perkId) then
          self:SetBorderColor(RGBA(215, 159, 80, 0))
          self:SetBackground(RGBA(215, 159, 80, 0))
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextImage",
      "Id",
      "idPerkRollover",
      "Dock",
      "box",
      "Visible",
      false,
      "Image",
      "UI/Inventory/T_Backpack_Slot_Small_Hover",
      "ImageFit",
      "stretch"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextImage",
      "Id",
      "idPerkSelected",
      "Dock",
      "box",
      "Visible",
      false,
      "Image",
      "UI/Inventory/perk_selected",
      "ImageFit",
      "stretch",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local parent = self:ResolveId("node")
        local perkId = parent:GetPerkId()
        local perksDlg = GetDialog(self)
        if table.find(perksDlg.SelectedPerkIds, perkId) then
          self:SetVisible(true)
        else
          self:SetVisible(false)
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Animate(self)",
      "func",
      function(self)
        local frame = self:ResolveId("idPerkLearned")
        local duration = 300
        frame:SetTransparency(255)
        frame:AddInterpolation({
          id = "size",
          type = const.intRect,
          duration = duration,
          originalRect = box(0, 0, 1000, 1000),
          targetRect = box(0, 0, 1500, 1500),
          OnLayoutComplete = IntRectCenterRelative,
          flags = const.intfInverse
        })
        frame:SetTransparency(0, duration)
      end
    }),
    PlaceObj("XTemplateCode", {
      "run",
      function(self, parent, context)
        rawset(parent, "ShowPerkRequirements", true)
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
      self:SetId("id" .. value)
    end,
    "Get",
    function(self)
      return self.PerkId
    end,
    "name",
    T(781869729879, "Perk Id")
  })
})
