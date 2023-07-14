PlaceObj("XTemplate", {
  __is_kind_of = "XListItem",
  group = "GedControls",
  id = "GedTextPickerItem",
  save_in = "Ged",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XListItem",
    "BorderWidth",
    0,
    "OnContextUpdate",
    function(self, context, ...)
      self.selectable = context.selectable
    end
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XText",
      "RolloverTemplate",
      "GedPropRollover",
      "RolloverAnchor",
      "bottom",
      "Padding",
      box(2, 1, 2, 1),
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self:SetText(context.text)
        self:SetRolloverText(context.help)
        self:SetTextStyle(context.font)
        XContextControl.OnContextUpdate(self, context)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XTextButton",
      "Id",
      "idToggleBookmark",
      "Dock",
      "right",
      "Visible",
      false,
      "FoldWhenHidden",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        if context.bookmarked ~= nil then
          self:SetVisible(true)
          self:SetText(context.bookmarked and "<image CommonAssets/UI/Editor/fav_star 450 220 165 18>" or "<image CommonAssets/UI/Editor/fav_star 450 128 128 128>")
        end
        self:SetTextStyle(context.font)
        self.idLabel:SetPadding(box(0, 2, 0, 2))
      end,
      "OnPress",
      function(self, gamepad)
        local item = (GetParentOfKind(self, "XVirtualContent") or GetParentOfKind(self, "XListItem")).item
        item.bookmarked = not item.bookmarked
        self:SetText(item.bookmarked and "<image CommonAssets/UI/Editor/fav_star 450 220 165 18>" or "<image CommonAssets/UI/Editor/fav_star 450 128 128 128>")
        local editor = GetParentOfKind(self, "GedPropListPicker")
        editor.panel:Op("GedInvokeMethod", editor.panel.context, editor.prop_meta.bookmark_fn, item.id, item.bookmarked)
      end,
      "UseXTextControl",
      true
    })
  })
})
