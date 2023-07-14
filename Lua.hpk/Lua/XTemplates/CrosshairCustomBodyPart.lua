PlaceObj("XTemplate", {
  __is_kind_of = "CrosshairCircleButton",
  group = "Zulu",
  id = "CrosshairCustomBodyPart",
  PlaceObj("XTemplateWindow", {
    "__class",
    "CrosshairCircleButton",
    "RolloverTemplate",
    "CrosshairAttackRollover",
    "RolloverAnchorId",
    "idContainer",
    "RolloverText",
    T(429409916961, "placeholder"),
    "RolloverOffset",
    box(20, 20, 20, 20),
    "HAlign",
    "left",
    "VAlign",
    "top",
    "UseClipBox",
    false,
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(0, 0, 0, 0),
    "OnContextUpdate",
    function(self, context, ...)
      local crosshair = self:ResolveId("node")
      local crosshairCtx = crosshair.context
      local attacker = crosshairCtx.attacker
      local action = crosshairCtx.action
      local weapon = action:GetAttackWeapons(attacker)
      local bodyPartId = self.context.id
      self.idBodyImage:SetImage(self.context.Icon)
      local allParts = crosshairCtx.body_parts
      local defaultPart = crosshair.defaultTargetPart
      local defaultPartIdx = table.find(allParts, defaultPart)
      local x, y = CalculateCrosshairButtonOffset(defaultPartIdx, #allParts)
      self.circle_offset_x = x
      self.circle_offset_y = y
      local icon = false
      local attackResultTable = crosshairCtx.attackResultTable
      attackResultTable = attackResultTable and attackResultTable[bodyPartId]
      local errors = GetCrosshairAttackStatusEffects(crosshairCtx, weapon, bodyPartId, action, attackResultTable)
      if 0 < #errors then
        local firstError = errors[1]
        icon = firstError.Icon
      end
      if icon then
        self.idHitIcon:SetImage(icon)
        self.idHitIcon:SetVisible(true)
      else
        self.idHitIcon:SetVisible(false)
      end
      local cachedResults = crosshair.cached_results
      cachedResults = cachedResults and cachedResults[crosshairCtx.action.id]
      cachedResults = cachedResults and cachedResults.attackResultCalc
      self:SetVisible(cachedResults and cachedResults[bodyPartId])
      self:SetMouseCursor(crosshair.attack_cursor or "UI/Cursors/Hand.tga")
      self.idLabel:SetVisible(GetUIStyleGamepad())
      self.idLabel:SetText(self.context.display_name)
    end,
    "FXMouseIn",
    "CrosshairCircleButtonRollover",
    "FXPress",
    "CrosshairCircleButtonPress",
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "OnPress",
    function(self, gamepad)
      self:ResolveId("node"):Attack()
    end,
    "RolloverBackground",
    RGBA(0, 0, 0, 0),
    "PressedBackground",
    RGBA(0, 0, 0, 0)
  }, {
    PlaceObj("XTemplateWindow", {
      "Dock",
      "left",
      "UseClipBox",
      false,
      "DrawOnTop",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idBackground",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "UseClipBox",
        false,
        "DrawOnTop",
        true,
        "Image",
        "UI/Hud/target_icon_circle"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idBodyImage",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "UseClipBox",
        false,
        "DrawOnTop",
        true,
        "Columns",
        2
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idHitIcon",
        "Margins",
        box(0, 0, -20, -10),
        "HAlign",
        "center",
        "VAlign",
        "center",
        "UseClipBox",
        false,
        "Visible",
        false,
        "FoldWhenHidden",
        true,
        "DrawOnTop",
        true,
        "ImageScale",
        point(750, 750)
      })
    }),
    PlaceObj("XTemplateWindow", {
      "Id",
      "idTextContainer",
      "Margins",
      box(-15, 6, 0, 6),
      "Padding",
      box(20, 0, 4, 0),
      "OnLayoutComplete",
      function(self)
        local anyVisible = false
        for i, c in ipairs(self) do
          if c.visible then
            anyVisible = true
          end
        end
        self:SetVisible(anyVisible)
      end,
      "LayoutMethod",
      "HList",
      "UseClipBox",
      false
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idLabel",
        "Margins",
        box(0, 0, 0, -1),
        "VAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "FoldWhenHidden",
        true,
        "DrawOnTop",
        true,
        "Translate",
        true
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idHitChance",
        "Margins",
        box(5, 0, 0, 0),
        "VAlign",
        "center",
        "Clip",
        false,
        "UseClipBox",
        false,
        "FoldWhenHidden",
        true,
        "DrawOnTop",
        true,
        "Translate",
        true
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetRollover(self, rollover)",
      "func",
      function(self, rollover)
        local nodeParent = self:ResolveId("node")
        nodeParent:SetSelectedPart(rollover and self.context)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, value)",
      "func",
      function(self, value)
        self:OnSetRollover(value)
        self.idBodyImage:SetColumn(value and 2 or 1)
        self.idLabel:SetTextStyle(value and "Crosshair_Label_Selected" or "Crosshair_Label")
        self.idHitChance:SetTextStyle(value and "Crosshair_Label_Selected" or "Crosshair_Label")
        self.idTextContainer:SetBackground(value and GameColors.L or GetColorWithAlpha(GameColors.A, 200))
      end
    })
  })
})
