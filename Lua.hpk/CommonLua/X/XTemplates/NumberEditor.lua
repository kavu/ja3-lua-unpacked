PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Editor",
  id = "NumberEditor",
  save_in = "Common",
  PlaceObj("XTemplateWindow", {"IdNode", true}, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XNumberEdit",
      "Id",
      "idEdit",
      "Dock",
      "box",
      "MinWidth",
      50,
      "IsInRange",
      true
    }),
    PlaceObj("XTemplateWindow", {"Dock", "right"}, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XTextButton",
        "Id",
        "idUp",
        "Margins",
        box(1, 1, 1, 0),
        "Padding",
        box(1, 2, 1, 1),
        "Dock",
        "top",
        "Background",
        RGBA(0, 0, 0, 0),
        "OnPress",
        function(self, gamepad)
          local edit = self:ResolveId("idEdit")
          local value = edit:GetNumber()
          value = value + 1
          edit:SetNumber(value)
        end,
        "RolloverBackground",
        RGBA(204, 232, 255, 255),
        "PressedBackground",
        RGBA(121, 189, 241, 255),
        "Icon",
        "CommonAssets/UI/arrowup-40.tga",
        "IconScale",
        point(500, 500),
        "IconColor",
        RGBA(0, 0, 0, 255),
        "DisabledIconColor",
        RGBA(0, 0, 0, 128)
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XTextButton",
        "Id",
        "idDown",
        "Margins",
        box(1, 0, 1, 1),
        "Padding",
        box(1, 2, 1, 1),
        "Dock",
        "bottom",
        "Background",
        RGBA(0, 0, 0, 0),
        "OnPress",
        function(self, gamepad)
          local edit = self:ResolveId("idEdit")
          local value = edit:GetNumber()
          value = value - 1
          edit:SetNumber(value)
        end,
        "RolloverBackground",
        RGBA(204, 232, 255, 255),
        "PressedBackground",
        RGBA(121, 189, 241, 255),
        "Icon",
        "CommonAssets/UI/arrowdown-40.tga",
        "IconScale",
        point(500, 500),
        "IconColor",
        RGBA(0, 0, 0, 255),
        "DisabledIconColor",
        RGBA(0, 0, 0, 128)
      })
    })
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "Number",
    "editor",
    "number",
    "translate",
    false,
    "Set",
    function(self, value)
      local edit = self.idEdit
      edit:SetNumber(value)
    end,
    "Get",
    function(self)
      local edit = self.idEdit
      return edit:GetNumber()
    end,
    "name",
    T(591685668698, "Number")
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "MaxNumber",
    "editor",
    "number",
    "Set",
    function(self, value)
      local edit = self.idEdit
      edit:SetMaxValue(value)
    end,
    "Get",
    function(self)
      local edit = self.idEdit
      return edit:GetMaxValue()
    end,
    "name",
    T(329682598515, "MaxNumber")
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "MinNumber",
    "editor",
    "number",
    "Set",
    function(self, value)
      local edit = self.idEdit
      edit:SetMinValue(value)
    end,
    "Get",
    function(self)
      local edit = self.idEdit
      return edit:GetMinValue()
    end,
    "name",
    T(287817186783, "MinNumber")
  })
})
