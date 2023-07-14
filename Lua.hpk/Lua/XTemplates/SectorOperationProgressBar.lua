PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu",
  id = "SectorOperationProgressBar",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "VAlign",
    "bottom",
    "MinWidth",
    190,
    "MinHeight",
    15,
    "MaxWidth",
    190,
    "MaxHeight",
    15,
    "Background",
    RGBA(32, 35, 47, 255),
    "ContextUpdateOnOpen",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "SetProgress(self, value)",
      "func",
      function(self, value)
        self.idOperationProgress:SetProgress(value)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "OperationProgressBar",
      "Id",
      "idOperationProgress",
      "Margins",
      box(3, 3, 3, 3),
      "MinWidth",
      190,
      "MinHeight",
      9,
      "MaxWidth",
      190,
      "MaxHeight",
      9,
      "SeparatorImage",
      "UI/Hud/weapon_marker_black"
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(6, 0, 0, 0),
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        6,
        "Clip",
        "parent & self"
      }, {
        PlaceObj("XTemplateForEach", {
          "array",
          function(parent, context)
            local max = context.max_array or 50
            local t = {}
            for i = 1, max do
              t[i] = i
            end
            return t
          end
        }, {
          PlaceObj("XTemplateWindow", {
            "HAlign",
            "left",
            "VAlign",
            "center",
            "MinWidth",
            4,
            "MinHeight",
            9,
            "MaxWidth",
            4,
            "MaxHeight",
            9,
            "Background",
            RGBA(32, 35, 47, 255)
          })
        })
      })
    })
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "Layout",
    "id",
    "Width",
    "editor",
    "number",
    "default",
    190,
    "Set",
    function(self, value)
      self:SetMinWidth(value)
      self:SetMaxWidth(value)
      self.idOperationProgress:SetMinWidth(value)
      self.idOperationProgress:SetMaxWidth(value)
    end,
    "Get",
    function(self)
      return self:GetMinWidth()
    end,
    "name",
    T(986419598057, "Bar Width")
  }),
  PlaceObj("XTemplateProperty", {
    "category",
    "Layout",
    "id",
    "Height",
    "editor",
    "number",
    "default",
    15,
    "Set",
    function(self, value)
      self:SetMinWidth(value)
      self:SetMaxWidth(value)
      self.idOperationProgress:SetMinWidth(value)
      self.idOperationProgress:SetMaxWidth(value)
    end,
    "Get",
    function(self)
      return self:GetMinWidth()
    end,
    "name",
    T(986419598057, "Bar Width")
  })
})
