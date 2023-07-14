PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu",
  id = "SectorOperationTopUI",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextFrame",
    "Dock",
    "top",
    "VAlign",
    "top",
    "MinHeight",
    32,
    "MaxHeight",
    32,
    "UseClipBox",
    false,
    "DrawOnTop",
    true,
    "Image",
    "UI/PDA/os_header",
    "FrameBox",
    box(2, 2, 37, 37),
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      local sector = context.sector or GetDialog(self).context
      if sector then
        if sector.Side == "enemy1" then
          self.idSectorBackground:SetImage("UI/PDA/sector_enemy")
        else
          self.idSectorBackground:SetImage("UI/PDA/sector_ally")
        end
        self.idSectorId:SetText(T({
          333114402012,
          "<SectorId(sector_Id)>",
          sector_Id = sector.Id
        }))
      end
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "Id",
      "idSectorSquare",
      "Dock",
      "left",
      "VAlign",
      "center",
      "MinWidth",
      32,
      "MinHeight",
      32,
      "MaxHeight",
      32
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idSectorBackground",
        "ImageFit",
        "stretch"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idSectorId",
        "HAlign",
        "center",
        "VAlign",
        "center",
        "Clip",
        false,
        "TextStyle",
        "PDASatelliteRollover_SectorTitle",
        "Translate",
        true,
        "TextHAlign",
        "center",
        "TextVAlign",
        "center"
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idVersion",
      "Margins",
      box(20, 0, 10, 0),
      "HAlign",
      "right",
      "VAlign",
      "center",
      "UseClipBox",
      false,
      "TextStyle",
      "UIDlgTitleLogo",
      "Text",
      "V.1.1.b"
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idTitle",
      "Padding",
      box(6, 2, 2, 2),
      "HAlign",
      "left",
      "VAlign",
      "center",
      "HandleMouse",
      false,
      "TextStyle",
      "UIDlgTitle",
      "Translate",
      true,
      "Text",
      T(600389692781, "SECTOR OPERATIONS"),
      "TextVAlign",
      "center"
    })
  })
})
