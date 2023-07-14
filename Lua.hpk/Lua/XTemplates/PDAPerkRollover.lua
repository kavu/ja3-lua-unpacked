PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu Rollover",
  id = "PDAPerkRollover",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDATermClarifyingRollover",
    "BorderWidth",
    0,
    "LayoutMethod",
    "Box",
    "UseClipBox",
    false,
    "Background",
    RGBA(0, 0, 0, 0),
    "OnContextUpdate",
    function(self, context, ...)
      local terms = TermClarifyingRollover.OnContextUpdate(self, context, ...)
      self.idContent.idMoreInfo:SetVisible(terms and 0 < #terms)
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextControl",
      "Id",
      "idContent",
      "Padding",
      box(6, 4, 6, 6),
      "VAlign",
      "bottom",
      "MaxWidth",
      400,
      "LayoutMethod",
      "VList",
      "UseClipBox",
      false,
      "Background",
      RGBA(52, 55, 61, 255),
      "BackgroundRectGlowSize",
      2,
      "BackgroundRectGlowColor",
      RGBA(32, 35, 47, 255),
      "OnContextUpdate",
      function(self, context, ...)
        local control = context.control
        local perksDlg = GetDialog(control)
        local enabled = control:GetEnabled()
        local title = not enabled and context.RolloverDisabledTitle ~= "" and context.RolloverDisabledTitle or control:GetRolloverTitle() or context.RolloverTitle ~= "" and context.RolloverTitle
        self.idTitle:SetText(title)
        local show = self.idTitle.text ~= ""
        self.idTitle:SetVisible(show)
        self.idTitle:SetContext(context)
        self.idText:SetText(not enabled and context.RolloverDisabledText ~= "" and context.RolloverDisabledText or control:GetRolloverText() or context.RolloverText ~= "" and context.RolloverText)
        self.idText:SetContext(context)
        if control.yellow then
          self.idText:SetTextStyle("PDASectorInfo_Section")
          self:SetBackground(0)
        end
        if not control.ShowPerkRequirements then
          return
        end
        local perk = CharacterEffectDefs[control:GetPerkId()]
        if not perksDlg:CanUnlockPerk(context, perk) then
          local statName = table.find_value(UnitPropertiesStats:GetProperties(), "id", perk.Stat).name
          self.idRequirements:SetVisible(true)
          if context[perk.Stat] < perk.StatValue then
            self.idStatReq:SetVisible(true)
            self.idStatText:SetText(T({
              358818089889,
              "Required <stat>",
              stat = statName
            }))
            self.idStatValueText:SetText(T({
              481242531729,
              "<stat>",
              stat = perk.StatValue
            }))
          end
          if perk.Tier == "Silver" and #context:GetPerksByStat(perk.Stat) < const.RequiredPerksForSilver then
            self.idPerksReq:SetVisible(true)
            self.idPerksText:SetText(T({
              295162270293,
              "Required <stat> Perks",
              stat = statName
            }))
            self.idPerksValueText:SetText(T({
              227251647374,
              "<value>",
              value = const.RequiredPerksForSilver
            }))
          elseif perk.Tier == "Gold" and #context:GetPerksByStat(perk.Stat) < const.RequiredPerksForGold then
            self.idPerksReq:SetVisible(true)
            self.idPerksText:SetText(T({
              295162270293,
              "Required <stat> Perks",
              stat = statName
            }))
            self.idPerksValueText:SetText(T({
              227251647374,
              "<value>",
              value = const.RequiredPerksForGold
            }))
          end
        end
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return context and context.control and context.control.yellow
        end,
        "__class",
        "XFrame",
        "Id",
        "idYellowBackground",
        "IdNode",
        false,
        "Margins",
        box(-7, -5, -7, -7),
        "Dock",
        "box",
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        5,
        "UseClipBox",
        false,
        "Image",
        "UI/PDA/imp_panel_2",
        "FrameBox",
        box(5, 5, 5, 5)
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "Open",
        "func",
        function(self, ...)
          XContextControl.Open(self, ...)
          local control = self.context.control
          local offset = control and control:GetRolloverOffset()
          if offset and offset ~= box(0, 0, 0, 0) then
            self.parent:SetMargins(self.parent.Margins + offset)
          end
        end
      }),
      PlaceObj("XTemplateWindow", nil, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(10, 0, 0, 0),
          "Padding",
          box(0, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "MaxWidth",
          450,
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "TextStyle",
          "PDACombatActionHeader",
          "Translate",
          true,
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idParent",
        "Margins",
        box(0, 5, 0, 0),
        "Padding",
        box(6, 4, 6, 6),
        "LayoutMethod",
        "VList",
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return context and context.control and context.control.yellow
          end,
          "__class",
          "XFrame",
          "Id",
          "idYellowSubBackground",
          "IdNode",
          false,
          "Margins",
          box(-6, -4, -6, -6),
          "Dock",
          "box",
          "Image",
          "UI/PDA/imp_bar",
          "FrameBox",
          box(5, 5, 5, 5)
        }),
        PlaceObj("XTemplateWindow", {
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idText",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverText",
            "Translate",
            true,
            "HideOnEmpty",
            true
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Id",
        "idRequirements",
        "Margins",
        box(0, 5, 0, 0),
        "Padding",
        box(6, 4, 6, 6),
        "LayoutMethod",
        "VList",
        "Visible",
        false,
        "FoldWhenHidden",
        true,
        "Background",
        RGBA(32, 35, 47, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "Id",
          "idStatReq",
          "LayoutMethod",
          "HList",
          "Visible",
          false,
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idStatText",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverRequirements",
            "Translate",
            true,
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idStatValueText",
            "Dock",
            "right",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverRequirements",
            "Translate",
            true,
            "HideOnEmpty",
            true,
            "TextHAlign",
            "right"
          })
        }),
        PlaceObj("XTemplateWindow", {
          "Id",
          "idPerksReq",
          "LayoutMethod",
          "HList",
          "Visible",
          false,
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idPerksText",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverRequirements",
            "Translate",
            true,
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idPerksValueText",
            "Dock",
            "right",
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDARolloverRequirements",
            "Translate",
            true,
            "Text",
            T(946936053464, "2"),
            "HideOnEmpty",
            true,
            "TextHAlign",
            "right"
          })
        })
      }),
      PlaceObj("XTemplateTemplate", {"__template", "MoreInfo"})
    })
  })
})
