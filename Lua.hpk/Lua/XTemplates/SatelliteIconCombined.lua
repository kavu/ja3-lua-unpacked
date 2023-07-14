PlaceObj("XTemplate", {
  __is_kind_of = "XMapRollerableContext",
  group = "Zulu Satellite UI",
  id = "SatelliteIconCombined",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XMapRollerableContext",
    "IdNode",
    true,
    "HAlign",
    "left",
    "VAlign",
    "top",
    "UseClipBox",
    false,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      local base, up = GetSatelliteIconImages(context)
      self.idBase:SetImage(base)
      self.idUpperIcon:SetImage(up)
      if context.squad and context.side == "player1" or context.side == "player2" then
        self.idUpperIcon:SetMargins(box(0, 4, 0, 0))
        self.idUpperIcon:SetScaleModifier(point(800, 800))
        self.idUpperIcon:SetHAlign("center")
        self.idUpperIcon:SetVAlign("top")
      end
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idBase",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "UseClipBox",
      false,
      "Image",
      "UI/Icons/SateliteView/icon_neutral"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XImage",
      "Id",
      "idUpperIcon",
      "HAlign",
      "center",
      "VAlign",
      "center",
      "UseClipBox",
      false,
      "Image",
      "UI/Icons/SateliteView/hospital_neutral"
    })
  })
})
