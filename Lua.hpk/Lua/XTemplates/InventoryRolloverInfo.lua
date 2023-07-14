PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu Rollover",
  id = "InventoryRolloverInfo",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextControl",
    "Id",
    "idContentInfo",
    "Margins",
    box(6, 0, 6, 0),
    "Padding",
    box(6, 6, 6, 6),
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MinWidth",
    356,
    "MaxWidth",
    356,
    "LayoutMethod",
    "VList",
    "LayoutVSpacing",
    5,
    "Background",
    RGBA(52, 55, 61, 255),
    "BackgroundRectGlowSize",
    2,
    "BackgroundRectGlowColor",
    RGBA(32, 35, 47, 255),
    "OnContextUpdate",
    function(self, context, ...)
      local ctx = ResolvePropObj(context)
      if IsKindOf(ctx, "Ordnance") then
        self.idType:SetText(ctx.DisplayName)
        return
      end
      local weaponType = ctx:GetRolloverType()
      local preset = Presets.WeaponType.Default[weaponType]
      self.idType:SetText(preset and preset.Name or "")
      if preset and preset.Icon then
        self.idIcon:SetImage(preset.Icon)
      end
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(0, 0, 0, 3),
      "Dock",
      "top",
      "DrawOnTop",
      true,
      "Background",
      RGBA(52, 55, 61, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idTitle",
        "Margins",
        box(10, 0, 0, 0),
        "Dock",
        "left",
        "Clip",
        false,
        "UseClipBox",
        false,
        "Visible",
        false,
        "FoldWhenHidden",
        true,
        "TextStyle",
        "PDACombatActionHeader",
        "Translate",
        true,
        "Text",
        T(748182260365, "Info"),
        "TextVAlign",
        "bottom"
      }),
      PlaceObj("XTemplateWindow", nil, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idType",
          "Margins",
          box(10, 0, 0, 0),
          "Dock",
          "left",
          "TextStyle",
          "PDACombatActionHeader",
          "Translate",
          true,
          "Text",
          T(642600109542, "<DisplayName>"),
          "TextVAlign",
          "bottom"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextImage",
          "Id",
          "idIcon",
          "HAlign",
          "right",
          "VAlign",
          "center"
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "LayoutMethod",
      "VList",
      "LayoutVSpacing",
      6,
      "ContextUpdateOnOpen",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextWindow",
        "IdNode",
        true,
        "LayoutMethod",
        "VList",
        "Background",
        RGBA(32, 35, 47, 255),
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local ctx = ResolvePropObj(context)
          if IsKindOf(ctx, "Ordnance") then
            self.idDescription:SetText(ctx.Description)
            return
          end
          local weaponType = ctx:GetRolloverType()
          local preset = Presets.WeaponType.Default[weaponType]
          self.idDescription:SetText(preset and preset.Description or "")
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idDescription",
          "Padding",
          box(8, 8, 8, 8),
          "TextStyle",
          "RolloverTextItalic",
          "Translate",
          true
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return next(context.AvailableAttacks)
        end,
        "__class",
        "XContextWindow",
        "IdNode",
        true,
        "Padding",
        box(8, 8, 8, 8),
        "LayoutMethod",
        "VList",
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            return context.AvailableAttacks
          end,
          "condition",
          function(parent, context, item, i)
            return item ~= "DualShot" and item ~= "CancelShot" and item ~= "CancelShotCone"
          end,
          "run_after",
          function(child, context, item, i, n, last)
            child.idPropVal:SetNameText(CombatActions[item].DisplayName)
            local weapon = ResolvePropObj(context)
            local owner_id = child.parent:GetContext().owner
            local unit = owner_id and g_Units[owner_id]
            local args = {weapon = weapon}
            if unit and (table.find(unit:GetEquippedWeapons("Handheld A", "BaseWeapon"), weapon) or table.find(unit:GetEquippedWeapons("Handheld B", "BaseWeapon"), weapon)) then
              local ap = CombatActions[item]:GetAPCost(unit, args)
              if ap ~= -1 then
                child.idPropVal:SetValueText(T({
                  499138807753,
                  "<val><style PDABrowserTitleSmall> AP</style>",
                  val = ap / const.Scale.AP
                }))
                return
              end
            end
            child.idPropVal:SetValueText(T({
              499138807753,
              "<val><style PDABrowserTitleSmall> AP</style>",
              val = (CombatActions[item].ActionPointDelta + (weapon.AttackAP or weapon.ShootAP)) / const.Scale.AP
            }))
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "RolloverPropTextRight"
          }, {
            PlaceObj("XTemplateFunc", {
              "name",
              "Open(self,...)",
              "func",
              function(self, ...)
                self.idPropVal:SetTextStyle("PDABrowserTitleSmall")
                self.idPropVal:SetTextStyleRight("PDASectorInfo_SectionItem")
                XPropControl.Open(self, ...)
              end
            })
          })
        })
      })
    })
  })
})
