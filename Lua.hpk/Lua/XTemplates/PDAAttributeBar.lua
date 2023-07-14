PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu PDA",
  id = "PDAAttributeBar",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "RolloverTemplate",
    "PDAAttributeRollover",
    "RolloverAnchor",
    "center-top",
    "RolloverOffset",
    box(0, 0, 0, 5),
    "IdNode",
    true,
    "RolloverDrawOnTop",
    true,
    "HandleMouse",
    true,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      if not self.Attribute then
        return
      end
      local prop = table.find_value(UnitPropertiesStats:GetProperties(), "id", self.Attribute)
      local number = context[self.Attribute]
      self:ResolveId("idName"):SetText(prop.name)
      self:ResolveId("idNumber"):SetText(Untranslated(number))
      local maxBarSize = self:ResolveId("idBarBackground"):GetMinWidth() - 2
      local barSize = MulDivRound(maxBarSize, number, 100)
      local bar = self:ResolveId("idBar")
      bar:SetMinWidth(barSize)
      bar:SetMaxWidth(barSize)
      local boostAmount = context.modifications and context.modifications[self.Attribute]
      local boostAmount = boostAmount and boostAmount.add or 0
      if boostAmount ~= 0 then
        local boostSize = MulDivRound(maxBarSize, boostAmount, 100)
        local boostBar = self:ResolveId("idBoostBar")
        boostBar:SetMinWidth(boostSize)
        boostBar:SetMaxWidth(boostSize)
        local push = MulDivRound(maxBarSize, number - boostAmount, 100) + 1
        boostBar:SetMargins(box(push, 0, 0, 0))
      end
      self:SetRolloverTitle(prop.name)
      self:SetRolloverText(prop.help)
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextImage",
      "Id",
      "idStatIcon",
      "Margins",
      box(2, 2, 2, 2),
      "Dock",
      "left",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "ImageScale",
      point(560, 560),
      "ImageColor",
      RGBA(130, 128, 120, 128),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local stat = self:ResolveId("node"):GetAttribute()
        local preset = Presets.MercStat.Default[stat]
        self:SetImage(preset.Icon)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(4, 0, 0, 0),
      "Dock",
      "left",
      "LayoutMethod",
      "VList"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idName",
        "TextStyle",
        "PDABrowserText",
        "Translate",
        true
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, -12, 0, 0),
        "LayoutMethod",
        "HList"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "bar",
          "Padding",
          box(2, 2, 2, 2)
        }, {
          PlaceObj("XTemplateWindow", {
            "Id",
            "idBarBackground",
            "HAlign",
            "left",
            "VAlign",
            "center",
            "MinWidth",
            170,
            "MinHeight",
            10,
            "Background",
            RGBA(32, 35, 47, 255)
          }),
          PlaceObj("XTemplateWindow", {
            "Id",
            "idBar",
            "Margins",
            box(1, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "center",
            "MinHeight",
            8,
            "MaxHeight",
            8,
            "Background",
            RGBA(61, 122, 153, 255)
          }),
          PlaceObj("XTemplateWindow", {
            "Id",
            "idBoostBar",
            "Margins",
            box(1, 0, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "center",
            "MinHeight",
            8,
            "MaxHeight",
            8,
            "Visible",
            false,
            "Background",
            RGBA(42, 173, 228, 255)
          })
        }),
        PlaceObj("XTemplateWindow", nil, {
          PlaceObj("XTemplateWindow", {
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idNumber",
              "Margins",
              box(2, 0, 0, 0),
              "TextStyle",
              "PDABrowserTextLightBold",
              "Translate",
              true,
              "Text",
              T(978537317768, "3")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContextImage",
              "Id",
              "idChangeImage",
              "Margins",
              box(2, 0, 0, 0),
              "Visible",
              false,
              "Image",
              "UI/PDA/attributes_up",
              "ContextUpdateOnOpen",
              true,
              "OnContextUpdate",
              function(self, context, ...)
                local stat = self:ResolveId("node"):GetAttribute()
                if NewModifications[context.session_id] and NewModifications[context.session_id][stat] then
                  self:SetVisible(true)
                end
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "placeholder for case where it is 100 or 99 with increase",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Margins",
              box(2, 0, 0, 0),
              "Visible",
              false,
              "TextStyle",
              "PDABrowserTextLightBold",
              "Translate",
              true,
              "Text",
              T(680431107320, "99")
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Margins",
              box(2, 0, 0, 0),
              "Visible",
              false,
              "Image",
              "UI/PDA/attributes_up"
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self.idName:SetTextStyle(rollover and "PDABrowserTextHighlight" or "PDABrowserText")
        self.idBoostBar:SetVisible(rollover)
        self.idChangeImage:SetVisible(false)
        local id = self:GetContext().session_id
        local stat = self:GetAttribute()
        if NewModifications[id] and NewModifications[id][stat] then
          NewModifications[id][stat] = false
        end
        if rollover then
          PlayFX("buttonRollover", "start")
        end
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "Attribute",
    "id",
    "Attribute",
    "editor",
    "text",
    "translate",
    false,
    "Set",
    function(self, value)
      self.Attribute = value
    end,
    "Get",
    function(self)
      return self.Attribute
    end
  })
})
