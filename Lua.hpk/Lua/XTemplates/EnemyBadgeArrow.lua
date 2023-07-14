PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu Badges",
  id = "EnemyBadgeArrow",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "HAlign",
    "left",
    "VAlign",
    "top",
    "ChildrenHandleMouse",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XBadgeArrow",
      "Id",
      "idArrow",
      "IdNode",
      false,
      "Image",
      "UI/Hud/enemy_marker"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "IdNode",
      true,
      "HAlign",
      "left",
      "VAlign",
      "top",
      "UseClipBox",
      false,
      "BorderColor",
      RGBA(0, 0, 0, 0),
      "OnContextUpdate",
      function(self, context, ...)
        self:UpdateStyle()
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "precalc observer",
        "__context",
        function(parent, context)
          return "unit_precalc"
        end,
        "__class",
        "XContextWindow",
        "OnContextUpdate",
        function(self, context, ...)
          self.parent:OnContextUpdate()
        end
      }),
      PlaceObj("XTemplateWindow", {
        "VAlign",
        "top",
        "UseClipBox",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idHeadIcon",
          "IdNode",
          false,
          "HAlign",
          "center",
          "VAlign",
          "top",
          "UseClipBox",
          false,
          "Image",
          "UI/Hud/enemy_head",
          "Rows",
          2,
          "Columns",
          2
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Id",
          "idSpecialIcon",
          "Padding",
          box(0, 0, -5, 0),
          "HAlign",
          "right",
          "VAlign",
          "top",
          "UseClipBox",
          false,
          "FoldWhenHidden",
          true,
          "ImageScale",
          point(750, 750)
        })
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "Open(self)",
        "func",
        function(self)
          XContextWindow.Open(self)
          local arrowMod = table.copy(self:ResolveId("node").modifiers[1])
          arrowMod.faceTargetOffScreen = const.badgeNoRotate
          self:AddDynamicPosModifier(arrowMod)
          self:UpdateStyle()
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "OnStyleUpdated(self, greyOut, boss)",
        "func",
        function(self, greyOut, boss)
          local arrow = self:ResolveId("idArrow")
          arrow:SetTransparency(greyOut and 20 or 0)
          arrow:SetDesaturation(greyOut and 255 or 0)
          if boss then
            self:SetMargins(box(10, 10, 0, 0))
          else
            self:SetMargins(box(17, 15, 0, 0))
          end
        end
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "UpdateStyle(self, rollover)",
        "func",
        function(self, rollover)
          if not self.visible then
            return
          end
          local firstParentDialog = GetDialog(self)
          local dialog = firstParentDialog and firstParentDialog.parent and GetDialog(firstParentDialog.parent)
          local unit = self.context
          if rollover then
            SetActiveBadgeExclusive(self.context)
          elseif unit.ui_badge then
            unit.ui_badge:SetActive(false)
          end
          local isVisibleCurrent = false
          local action = false
          if SelectedObj then
            isVisibleCurrent = UIEnemyCanSee(unit)
          end
          local node = self:ResolveId("node")
          node:SetVisible(isVisibleCurrent)
          local headIcon = self.idHeadIcon
          local image = false
          if unit.villain then
            image = "UI/Hud/enemy_boss"
          else
            local rolePreset = Presets.EnemyRole.Default[unit.role or "Default"]
            image = rolePreset.Icon or "UI/Hud/enemy_head"
          end
          if headIcon.Image ~= image then
            headIcon:SetImage(image)
          end
          self:OnStyleUpdated(false, unit.villain)
        end
      })
    })
  })
})
