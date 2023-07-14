PlaceObj("XTemplate", {
  __is_kind_of = "XToggleButton",
  group = "Zulu Satellite UI",
  id = "PDASmallToggleButton",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XToggleButton",
    "ScaleModifier",
    point(1250, 1250),
    "LayoutMethod",
    "Box",
    "FXMouseIn",
    "buttonRollover",
    "FXPress",
    "buttonPress",
    "FXPressDisabled",
    "IactDisabled",
    "DisabledBackground",
    RGBA(255, 255, 255, 255),
    "Image",
    "UI/PDA/T_SmallButton",
    "ColumnsUse",
    "abcca",
    "Toggled",
    true,
    "ToggledBackground",
    RGBA(255, 255, 255, 255)
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idCenterImg",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "HandleKeyboard",
      false,
      "Image",
      "UI/PDA/T_Icon_Pause",
      "ImageColor",
      RGBA(52, 55, 61, 255)
    })
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "CenterImage",
    "editor",
    "text",
    "default",
    "UI/PDA/T_Icon_Pause",
    "translate",
    false,
    "Set",
    function(self, value)
      self.idCenterImg:SetImage(value)
      self.idCenterImg:SetFlipX(self.FlipX)
    end,
    "Get",
    function(self)
      return self.idCenterImg:GetImage()
    end
  })
})
