PlaceObj("XTemplate", {
  group = "Zulu",
  id = "MoreInfo",
  PlaceObj("XTemplateWindow", {
    "comment",
    "hint",
    "__context",
    function(parent, context)
      return "GamepadUIStyleChanged"
    end,
    "__class",
    "XContextWindowVisibleReasons",
    "Id",
    "idMoreInfo",
    "IdNode",
    true,
    "Margins",
    box(5, 3, 0, -2),
    "MinHeight",
    34,
    "LayoutMethod",
    "HList",
    "FoldWhenHidden",
    true,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      self:SetVisible(not GetUIStyleGamepad())
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return "g_RolloverShowMoreInfo"
      end,
      "__class",
      "XText",
      "Margins",
      box(3, 0, 0, 0),
      "VAlign",
      "center",
      "Clip",
      false,
      "UseClipBox",
      false,
      "TextStyle",
      "SatelliteContextMenuKeybind",
      "Translate",
      true,
      "Text",
      T(232022358024, "<MoreInfoDynamic()>")
    })
  })
})
