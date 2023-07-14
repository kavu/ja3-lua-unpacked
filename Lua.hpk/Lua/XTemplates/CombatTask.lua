PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu",
  id = "CombatTask",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "IdNode",
    true
  }, {
    PlaceObj("XTemplateTemplate", {
      "__template",
      "GenericHUDButtonFrame",
      "IdNode",
      false,
      "Margins",
      box(0, 0, 0, 8),
      "MinWidth",
      360,
      "MaxWidth",
      360
    }, {
      PlaceObj("XTemplateWindow", {
        "Padding",
        box(4, 4, 4, 4),
        "Dock",
        "left",
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "icon",
          "__class",
          "XContextImage",
          "Id",
          "idIcon",
          "Image",
          "UI/Hud/combat_task",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local task = context
            if task.state == "completed" then
              self:SetImage("UI/Hud/combat_task_completed")
            elseif task.state == "failed" then
              self:SetImage("UI/Hud/combat_task_failed")
            end
          end
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "progress",
          "__class",
          "XText",
          "HAlign",
          "center",
          "VAlign",
          "center",
          "FoldWhenHidden",
          true,
          "TextStyle",
          "CombatTask_Progress",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local task = context
            if task.hideProgress then
              self:SetVisible(false)
            else
              local text = T({
                418643651117,
                "<current>/<required>",
                current = task.currentProgress,
                required = task.requiredProgress
              })
              self:SetText(text)
            end
          end,
          "Translate",
          true
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Padding",
        box(4, 4, 4, 4),
        "LayoutMethod",
        "VList"
      }, {
        PlaceObj("XTemplateWindow", nil, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "header",
            "__class",
            "XText",
            "Dock",
            "left",
            "TextStyle",
            "CombatTask_Header",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local task = context
              local text
              if task.state == "inProgress" then
                text = task.name
              elseif task.state == "completed" then
                text = T(405547919134, "Completed")
                self:SetTextStyle("CombatTask_HeaderCompleted")
              elseif task.state == "failed" then
                text = T(823801140652, "Failed")
                self:SetTextStyle("CombatTask_HeaderFailed")
              end
              self:SetText(text)
            end,
            "Translate",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "associatedMerc",
            "__class",
            "XText",
            "Dock",
            "right",
            "TextStyle",
            "CombatTask_MercName",
            "ContextUpdateOnOpen",
            true,
            "OnContextUpdate",
            function(self, context, ...)
              local task = context
              local unit = g_Units[task.unitId]
              if unit then
                self:SetText(unit.Nick)
              end
            end,
            "Translate",
            true
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "description",
          "__class",
          "XText",
          "TextStyle",
          "CombatTask_Description",
          "ContextUpdateOnOpen",
          true,
          "OnContextUpdate",
          function(self, context, ...)
            local task = context
            local unit = g_Units[task.unitId]
            local text = T({
              task.description,
              unit
            })
            self:SetText(text)
            if task.state ~= "inProgress" then
              self:SetTextStyle("CombatTask_DescriptionFinished")
            end
          end,
          "Translate",
          true
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Animate(self, startTime)",
      "func",
      function(self, startTime)
        self:CreateThread(function()
          local icon = self:ResolveId("idIcon")
          local pulseStart = startTime or GetPreciseTicks()
          local loopTimes = 5
          local duration = self.animPulseDuration / loopTimes
          icon:AddInterpolation({
            id = "iconPulse",
            type = const.intRect,
            start = pulseStart,
            duration = duration,
            originalRect = box(0, 0, 1000, 1000),
            targetRect = box(0, 0, 1100, 1100),
            OnLayoutComplete = IntRectCenterRelative,
            flags = bor(const.intfPingPong, const.intfLooping)
          })
          local hideStart = pulseStart + self.animPulseDuration
          if hideStart > GetPreciseTicks() then
            Sleep(hideStart - GetPreciseTicks())
          end
          self:AddInterpolation({
            id = "windowToEdge",
            type = const.intRect,
            start = hideStart,
            duration = self.animHideDuration,
            originalRect = box(0, 0, 1000, 1000),
            targetRect = box(1000, 0, 2000, 1000)
          })
        end)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        local task = self.context
        local taskAnim = CombatTaskUIAnimations[task]
        if taskAnim and GetPreciseTicks() - taskAnim.startTime < self.animPulseDuration + self.animHideDuration then
          self:Animate(taskAnim.startTime)
        end
        XContextWindow.Open(self)
      end
    })
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "animPulseDuration",
    "editor",
    "number",
    "default",
    3000
  }),
  PlaceObj("XTemplateProperty", {
    "id",
    "animHideDuration",
    "editor",
    "number",
    "default",
    500
  })
})
