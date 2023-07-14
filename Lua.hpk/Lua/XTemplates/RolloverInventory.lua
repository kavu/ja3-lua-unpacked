PlaceObj("XTemplate", {
  __is_kind_of = "XRolloverWindow",
  group = "Zulu",
  id = "RolloverInventory",
  PlaceObj("XTemplateWindow", {
    "__condition",
    function(parent, context)
      return not UseNewInventoryRollover(ResolvePropObj(context))
    end,
    "__class",
    "PDARolloverClass",
    "Margins",
    box(50, 30, 0, 0),
    "BorderWidth",
    0,
    "UseClipBox",
    false,
    "Background",
    RGBA(240, 240, 240, 0),
    "FocusedBackground",
    RGBA(240, 240, 240, 0)
  }, {
    PlaceObj("XTemplateTemplate", {
      "__condition",
      function(parent, context)
        local cnt = ResolvePropObj(context)
        return cnt and not cnt:IsWeapon()
      end,
      "__template",
      "RolloverInventoryBase",
      "MinWidth",
      400,
      "MaxWidth",
      450
    })
  }),
  PlaceObj("XTemplateTemplate", {
    "__condition",
    function(parent, context)
      return UseNewInventoryRollover(ResolvePropObj(context))
    end,
    "__template",
    "RolloverInventoryWeapon"
  })
})
