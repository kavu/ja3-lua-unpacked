PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu PDA",
  id = "PDAQuestHeader",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true,
    "MinHeight",
    42,
    "MaxHeight",
    42,
    "FoldWhenHidden",
    true,
    "HandleMouse",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "active quest change observer",
      "__context",
      function(parent, context)
        return gv_Quests
      end,
      "__class",
      "XContextWindow",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local node = self:ResolveId("node")
        node:UpdateStyle()
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "selected quest change observer",
      "__context",
      function(parent, context)
        return "selected_quest"
      end,
      "__class",
      "XContextWindow",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local node = self:ResolveId("node")
        node:UpdateStyle()
      end
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "read quest observer",
      "__context",
      function(parent, context)
        return "quest_read"
      end,
      "__class",
      "XContextWindow",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        local node = self:ResolveId("node")
        local nodeCtx = node.context
        local questDlg = GetDialog(self)
        local questData = table.find_value(questDlg.questData, "id", nodeCtx.questPreset.id)
        nodeCtx.read = not table.find(questData.questNotes, "read", false)
        node:UpdateStyle()
      end
    }),
    PlaceObj("XTemplateWindow", {
      "Margins",
      box(3, 0, 0, 0),
      "VAlign",
      "center"
    }, {
      PlaceObj("XTemplateTemplate", {
        "__template",
        "PDAQuestUnreadIndicator",
        "Dock",
        "left"
      }),
      PlaceObj("XTemplateWindow", nil, {
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(10, 0, 5, 0),
          "Dock",
          "left"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XImage",
            "Id",
            "idIcon",
            "MinWidth",
            32,
            "MinHeight",
            32
          })
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Id",
          "idButton",
          "IdNode",
          false,
          "VAlign",
          "center",
          "Background",
          RGBA(215, 159, 80, 255),
          "MouseCursor",
          "UI/Cursors/Pda_Hand.tga",
          "FXMouseIn",
          "buttonRollover",
          "FXPress",
          "buttonPressNotesList",
          "FXPressDisabled",
          "IactDisabled",
          "FocusedBorderColor",
          RGBA(215, 159, 80, 255),
          "FocusedBackground",
          RGBA(215, 159, 80, 255),
          "DisabledBorderColor",
          RGBA(0, 0, 0, 0),
          "OnPress",
          function(self, gamepad)
            local dlg = GetDialog(self)
            local node = self:ResolveId("node")
            local questId = node.context.questPreset and node.context.questPreset.id
            if dlg.selected_quest == questId then
              return
            end
            dlg:SetSelectedQuest(questId)
          end,
          "RolloverBackground",
          RGBA(215, 159, 80, 255),
          "PressedBackground",
          RGBA(215, 159, 80, 255)
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idText",
            "FoldWhenHidden",
            true,
            "HandleMouse",
            false,
            "TextStyle",
            "PDAQuestTitle",
            "Translate",
            true
          }),
          PlaceObj("XTemplateFunc", {
            "name",
            "OnMouseButtonDoubleClick(self, pt, button)",
            "func",
            function(self, pt, button)
              if button ~= "L" then
                return
              end
              local questId = self:ResolveId("node").context.questPreset.id
              if self:ResolveId("node").context.state ~= "completed" then
                SetActiveQuest(questId)
              end
            end
          })
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self)",
      "func",
      function(self)
        self:UpdateStyle()
        XContextWindow.Open(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "UpdateStyle(self)",
      "func",
      function(self)
        local questPreset = self.context.questPreset
        local overrideCtx = SubContext(questPreset, {
          em = "<color EmStyleDark>"
        })
        local text = self.context.preset and self.context.preset.Text
        text = text and Untranslated(_InternalTranslate(text, overrideCtx))
        self.idText:SetText(text)
        local state = self.context.state
        local questId = questPreset and questPreset.id
        if questId == GetActiveQuest() then
          state = "active"
        end
        local dlg = GetDialog(self)
        local selected = dlg.selected_quest == questId
        local bgColor = selected and GameColors.Yellow or RGBA(0, 0, 0, 0)
        self.idButton:SetBackground(bgColor)
        self.idButton:SetRolloverBackground(bgColor)
        self.idButton:SetPressedBackground(bgColor)
        self.idUnread:SetVisible(questPreset and not self.context.read)
        local textStyle
        if state == "completed" then
          textStyle = "PDAQuestTitleCompleted"
        elseif state == "failed" then
          textStyle = "PDAQuestTitleFailed"
        elseif selected then
          textStyle = "PDAQuestTitleSelected"
        else
          textStyle = "PDAQuestTitle"
        end
        self.idText:SetTextStyle(textStyle)
        local icon = GetQuestIcon(questId)
        self.idIcon:SetImage(icon)
      end
    })
  })
})
