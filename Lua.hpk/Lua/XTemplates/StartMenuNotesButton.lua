PlaceObj("XTemplate", {
  group = "Zulu ContextMenu",
  id = "StartMenuNotesButton",
  PlaceObj("XTemplateTemplate", {
    "__template",
    "ContextMenuButton",
    "MinHeight",
    28,
    "MaxHeight",
    28,
    "OnPressEffect",
    "action",
    "OnPressParam",
    "actionOpenNotes"
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "PDAQuestUnreadIndicator",
      "ZOrder",
      -1,
      "Margins",
      box(-9, -4, 0, 0),
      "Visible",
      true,
      "FoldWhenHidden",
      true
    }),
    PlaceObj("XTemplateCode", {
      "run",
      function(self, parent, context)
        local unreadQuests = GetAnyQuestUnread()
        parent.idUnread:SetVisible(unreadQuests)
        local pda = GetDialog("PDADialog")
        parent:SetMouseCursor(gv_SatelliteView and pda and pda.visible and "UI/Cursors/Pda_Hand.tga" or "UI/Cursors/Hand.tga")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self:base_OnSetRollover(rollover)
        self.idUnread[1]:SetRollover(rollover)
      end
    })
  }),
  PlaceObj("XTemplateTemplate", {
    "__template",
    "ContextMenuButton",
    "MinHeight",
    28,
    "MaxHeight",
    28,
    "OnPressEffect",
    "action",
    "OnPressParam",
    "actionOpenEmail"
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "PDAQuestUnreadIndicator",
      "ZOrder",
      -1,
      "Margins",
      box(-9, -4, 0, 0),
      "Visible",
      true,
      "FoldWhenHidden",
      true
    }),
    PlaceObj("XTemplateCode", {
      "run",
      function(self, parent, context)
        local unreadMails = GetUnreadEmails()
        unreadMails = unreadMails and 0 < #unreadMails
        parent.idUnread:SetVisible(unreadMails)
        local pda = GetDialog("PDADialog")
        parent:SetMouseCursor(gv_SatelliteView and pda and pda.visible and "UI/Cursors/Pda_Hand.tga" or "UI/Cursors/Hand.tga")
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        self:base_OnSetRollover(rollover)
        self.idUnread[1]:SetRollover(rollover)
      end
    })
  })
})
