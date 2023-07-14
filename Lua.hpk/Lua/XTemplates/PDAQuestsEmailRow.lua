PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu PDA",
  id = "PDAQuestsEmailRow",
  PlaceObj("XTemplateWindow", {
    "LayoutMethod",
    "VList"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XButton",
      "MinHeight",
      38,
      "MaxHeight",
      38,
      "LayoutMethod",
      "HList",
      "FoldWhenHidden",
      true,
      "Background",
      RGBA(255, 255, 255, 0),
      "MouseCursor",
      "UI/Cursors/Pda_Hand.tga",
      "OnContextUpdate",
      function(self, context, ...)
        local dlg = GetDialog(self)
        local selected = dlg.selectedEmail and dlg.selectedEmail.uniqueId == context.uniqueId
        if selected then
          self:SetBackground(RGBA(215, 159, 80, 255))
          self.idFrom:SetTextStyle("PDAQuests_EmailDateSelected")
          self.idSubject:SetTextStyle("PDAQuests_EmailTitleSelected")
          self.idDate:SetTextStyle("PDAQuests_EmailDateSelected")
        end
      end,
      "FXMouseIn",
      "buttonRollover",
      "FXPress",
      "buttonPress",
      "FXPressDisabled",
      "IactDisabled",
      "OnPress",
      function(self, gamepad)
        local emailDialog = GetDialog(self)
        local context = self:GetContext()
        emailDialog:SelectEmail(context)
      end,
      "RolloverBackground",
      RGBA(215, 159, 80, 128),
      "PressedBackground",
      RGBA(215, 159, 80, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "mail/trash",
        "__class",
        "XContextImage",
        "MinWidth",
        36,
        "MinHeight",
        36,
        "MaxWidth",
        36,
        "MaxHeight",
        36,
        "Image",
        "UI/PDA/Quest/tab_email",
        "Columns",
        2,
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          if context.read then
            local trashIcon = "UI/PDA/Quest/e_trash"
            self:SetImage(trashIcon)
            self:SetColumns(1)
            self:SetTransparency(MulDivRound(255, 10, 100))
            self:SetDesaturation(MulDivRound(255, 100, 100))
          end
        end
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "attachment",
        "__class",
        "XContextImage",
        "MinWidth",
        36,
        "MinHeight",
        36,
        "MaxWidth",
        36,
        "MaxHeight",
        36,
        "Visible",
        false,
        "Transparency",
        25,
        "Image",
        "UI/PDA/Quest/e_attach",
        "Desaturation",
        255,
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local preset = Emails[context.id]
          self:SetVisible(preset.attachments and #preset.attachments > 0)
        end
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "from",
        "__class",
        "XText",
        "Id",
        "idFrom",
        "Padding",
        box(2, 2, 5, 2),
        "MinWidth",
        192,
        "MaxWidth",
        192,
        "TextStyle",
        "PDAQuests_EmailSender",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local preset = Emails[context.id]
          local text = preset.sender
          self:SetText(text)
          return XContextControl.OnContextUpdate(self, context)
        end,
        "Translate",
        true,
        "WordWrap",
        false,
        "Shorten",
        true,
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "subject",
        "__class",
        "XText",
        "Id",
        "idSubject",
        "Padding",
        box(2, 2, 5, 2),
        "MinWidth",
        548,
        "MaxWidth",
        548,
        "TextStyle",
        "PDAQuests_EmailTitle",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          if context.read then
            self:SetEnabled(false)
          end
          local preset = Emails[context.id]
          self:SetText(T({
            preset.title,
            context.context
          }))
          return XContextControl.OnContextUpdate(self, context)
        end,
        "Translate",
        true,
        "WordWrap",
        false,
        "Shorten",
        true,
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "date",
        "__class",
        "XText",
        "Id",
        "idDate",
        "Padding",
        box(2, 2, 5, 2),
        "TextStyle",
        "PDAQuests_EmailDate",
        "Translate",
        true,
        "Text",
        T(354457286355, "<EmailDate()>"),
        "WordWrap",
        false,
        "Shorten",
        true,
        "TextVAlign",
        "center"
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "OnSetRollover(self, rollover)",
        "func",
        function(self, rollover)
          local dlg = GetDialog(self)
          local selected = dlg.selectedEmail and dlg.selectedEmail.uniqueId == self:GetContext().uniqueId
          if rollover or selected then
            self:SetBackground(rollover and RGBA(215, 159, 80, 128) or RGBA(215, 159, 80, 255))
            self.idFrom:SetTextStyle("PDAQuests_EmailDateSelected")
            self.idSubject:SetTextStyle("PDAQuests_EmailTitleSelected")
            self.idDate:SetTextStyle("PDAQuests_EmailDateSelected")
          else
            self:SetBackground(RGBA(0, 0, 0, 0))
            self.idFrom:SetTextStyle("PDAQuests_EmailDate")
            self.idSubject:SetTextStyle("PDAQuests_EmailTitle")
            self.idDate:SetTextStyle("PDAQuests_EmailDate")
          end
        end
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Image",
      "UI/PDA/separate_line_vertical",
      "FrameBox",
      box(3, 3, 3, 3),
      "SqueezeY",
      false
    })
  })
})
