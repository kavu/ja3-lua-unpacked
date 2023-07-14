PlaceObj("XTemplate", {
  __is_kind_of = "PDARolloverClass",
  group = "Zulu",
  id = "RolloverInventoryWeapon",
  PlaceObj("XTemplateWindow", {
    "__class",
    "PDARolloverClass",
    "Margins",
    box(10, 10, 10, 10),
    "BorderWidth",
    0,
    "OnLayoutComplete",
    function(self)
      local anchor = self:GetAnchor()
      local x = self.box:minx()
      local onTheLeft = x < anchor:minx()
      local dock = onTheLeft and "left" or "right"
      local mercStatusInfo = self.idMoreInfo
      if not mercStatusInfo then
        return
      end
      mercStatusInfo:SetZOrder(onTheLeft and -10 or 10)
    end,
    "Background",
    RGBA(240, 240, 240, 0),
    "FocusedBackground",
    RGBA(240, 240, 240, 0)
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "GetCustomAnchor(self, ...)",
      "func",
      function(self, ...)
        self.idMoreInfo:SetVAlign("bottom")
        self.idContent:SetVAlign("bottom")
        self.termUI = self.idMoreInfo
        return TermClarifyingRollover.GetCustomAnchor(self, ...)
      end
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "InventoryRolloverInfo",
      "Id",
      "idMoreInfo",
      "Dock",
      "left"
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return "g_RolloverShowMoreInfo"
        end,
        "__class",
        "XContextWindow",
        "Dock",
        "ignore",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          self.parent:SetVisible(g_RolloverShowMoreInfo)
        end
      })
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "RolloverInventoryWeaponBase",
      "Dock",
      "left"
    })
  })
})
