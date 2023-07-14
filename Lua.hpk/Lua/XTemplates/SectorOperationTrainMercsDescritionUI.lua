PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu",
  id = "SectorOperationTrainMercsDescritionUI",
  PlaceObj("XTemplateWindow", {
    "comment",
    "table",
    "__condition",
    function(parent, context)
      return context.operation and context.operation.id == "TrainMercs"
    end,
    "__class",
    "XContentTemplate",
    "Id",
    "idStatsTable",
    "Dock",
    "bottom",
    "VAlign",
    "bottom",
    "LayoutMethod",
    "VList",
    "FoldWhenHidden",
    true,
    "ContextUpdateOnOpen",
    true,
    "OnContextUpdate",
    function(self, context, ...)
      XContentTemplate.OnContextUpdate(self, context, ...)
      self.idTrainingHint:SetText(T(744535905368, "Training<style PDASM_PowerFlavor><valign bottom 0> / change stat to improve</style>"))
      local sector = context.sector_id and gv_Sectors[item.sector_id]
      local stat_name = table.find_value(UnitPropertiesStats:GetProperties(), "id", sector and sector.training_stat)
      self.idTrainingStat:SetText(stat_name and stat_name.name or "")
    end,
    "RespawnOnContext",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idTrainingHint",
      "HandleMouse",
      false,
      "TextStyle",
      "PDARolloverHeaderDark",
      "Translate",
      true,
      "Text",
      T(280247885791, "Sector Details")
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "VAlign",
      "top",
      "Image",
      "UI/PDA/separate_line_vertical",
      "FrameBox",
      box(2, 0, 2, 0),
      "SqueezeY",
      false
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "Id",
      "idTrainingStat",
      "HandleMouse",
      false,
      "TextStyle",
      "PDABrowserPoints",
      "Translate",
      true,
      "Text",
      T(280247885791, "Sector Details")
    })
  })
})
