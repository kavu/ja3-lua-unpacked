PlaceObj("XTemplate", {
  __is_kind_of = "XWindow",
  group = "Zulu",
  id = "SectorOperationButtonUI",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return context.operation
    end,
    "__class",
    "XTextButton",
    "Padding",
    box(9, 9, 9, 9),
    "HAlign",
    "left",
    "VAlign",
    "top",
    "MinWidth",
    208,
    "MinHeight",
    198,
    "MaxWidth",
    208,
    "MaxHeight",
    198,
    "LayoutMethod",
    "VList",
    "LayoutHSpacing",
    0,
    "MouseCursor",
    "UI/Cursors/Pda_Hand.tga",
    "OnContextUpdate",
    function(self, context, ...)
      self:SetFXMouseIn("activityButtonHover_" .. context.id)
      self:SetFXPress("activityButtonPress_" .. context.id)
      self:SetFXPressDisabled("activityButtonDisabled_" .. context.id)
      local limit = self.UpdateTimeLimit
      if limit == 0 or limit <= RealTime() - self.last_update_time then
        self:SetText(self.Text)
      elseif not self:GetThread("ContextUpdate") then
        self:CreateThread("ContextUpdate", function(self)
          Sleep(self.last_update_time + self.UpdateTimeLimit - RealTime())
          self:OnContextUpdate()
        end, self)
      end
      local sector = GetDialog(self).context.sector
      local mercs = GetOperationProfessionals(sector.Id, context.id)
      self.idTimer:SetVisible(next(mercs))
      if next(mercs) then
        local left_time = GetOperationTimeLeft(mercs[1], context.id, {
          mercs = mercs,
          prediction = true,
          all = true
        })
        self.idTimer:SetText(T({
          847408442453,
          "<image UI/SectorOperations/T_Icon_Activity_Resting 900 130 128 120> <timeDuration(left_time)>",
          left_time = left_time
        }))
      end
    end,
    "DisabledBackground",
    RGBA(255, 255, 255, 255),
    "OnPress",
    function(self, gamepad)
      local dlg = GetDialog(self)
      dlg:SetMode("Operation", {
        operation = self.context.id
      })
    end,
    "Image",
    "UI/PDA/os_background",
    "FrameBox",
    box(5, 5, 5, 5),
    "Translate",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "OnSetRollover(self, rollover)",
      "func",
      function(self, rollover)
        XTextButton.OnSetRollover(self, rollover)
        local parent = self.parent.parent
        self:SetImage(rollover and "UI/PDA/os_portrait_selection" or "UI/PDA/os_background")
        self.idTextBack:SetBackground(rollover and GameColors.C or RGB(32, 35, 47))
        local dlg = GetDialog(self)
        if dlg.window_state == "destroying" then
          return
        end
        local ac = self.context
        local sector = dlg.context.sector
        if sector.started_operations and sector.started_operations[ac.id] then
          local uds = GetOperationProfessionals(sector.Id, ac.id)
          local eventId, is_personal_event = GetOperationEventId(uds and uds[1], ac.id)
          local idx = table.find(gv_Timeline, "id", eventId or "")
          if idx then
            local event = gv_Timeline[idx]
            local icon
            for idx, icon_data in ipairs(g_SatTimelineUI.icons_created) do
              local ev = icon_data.event
              if ev.id == event.id then
                icon = icon_data
              end
              if not icon then
                for i, ev in ipairs(icon_data.otherEvents) do
                  if ev.id == event.id then
                    icon = icon_data
                    break
                  end
                end
              end
              if icon then
                break
              end
            end
            if icon then
              icon:OnSetRollover(rollover)
            end
          end
        end
        if rollover then
          dlg:SetContext({
            sector = dlg.context.sector,
            operation = ac
          })
          dlg.idOperationDescr:SetContext({
            sector = dlg.context,
            operation = ac
          })
          dlg.idOperationDescr:ResolveId("idOperationDescrText"):SetText(ac.description)
        else
          dlg:SetContext({
            sector = dlg.context.sector,
            operation = false
          })
          dlg.idOperationDescr:ResolveId("idOperationDescrText"):SetText(T(803405378927, "You can assign mercs in this sector to different Operations like healing wounds, repairing items or training. Operations take time and often require additional resources in the sector. Some sectors offer special Operations and opportunities."))
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "SetSelected(self, selected)",
      "func",
      function(self, selected)
        self:SetFocus(selected)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "IsSelectable(self)",
      "func",
      function(self)
        return self:GetEnabled()
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextImage",
      "IdNode",
      false,
      "MinHeight",
      135,
      "MaxHeight",
      135,
      "ImageFit",
      "largest",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        if context.image then
          self:SetImage(context.image)
        end
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idCustom",
        "HAlign",
        "left",
        "VAlign",
        "top",
        "MinWidth",
        36,
        "MinHeight",
        36,
        "MaxWidth",
        36,
        "MaxHeight",
        36,
        "Image",
        "UI/SectorOperations/T_Activities_Icon_New"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "Id",
        "idQuest",
        "Margins",
        box(0, 0, 0, 10),
        "HAlign",
        "center",
        "VAlign",
        "bottom",
        "ScaleModifier",
        point(800, 800),
        "Visible",
        false,
        "Image",
        "UI/PDA/T_Icon_MainQuest"
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 2, 2, 0),
        "HAlign",
        "right",
        "VAlign",
        "top",
        "Background",
        RGBA(52, 55, 61, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTimer",
          "Margins",
          box(0, -1, 0, -1),
          "Padding",
          box(2, 0, 2, 0),
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "TextStyle",
          "PDASectorInfo_SectionItem",
          "Translate",
          true,
          "HideOnEmpty",
          true,
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(0, 0, 0, 5),
        "VAlign",
        "bottom",
        "MinWidth",
        190,
        "MinHeight",
        15,
        "MaxWidth",
        190,
        "MaxHeight",
        15,
        "Background",
        RGBA(124, 130, 96, 255)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "ZuluFrameProgress",
          "Id",
          "idOperationProgress",
          "VAlign",
          "bottom",
          "MinWidth",
          190,
          "MinHeight",
          15,
          "MaxWidth",
          190,
          "MaxHeight",
          15,
          "Visible",
          false,
          "Background",
          RGBA(88, 92, 68, 255),
          "OnContextUpdate",
          function(self, context, ...)
            if not context then
              self:SetVisible(false)
              self.parent:SetVisible(false)
              return
            end
            local sector = GetDialog(self).context.sector
            local progress, max
            local mercs = GetOperationProfessionals(sector.Id, context.id)
            if #mercs <= 0 then
              self:SetVisible(false)
              self.parent:SetVisible(false)
              return
            end
            max = context:ProgressCompleteThreshold(mercs[1], sector, "prediction")
            progress = 0 < max and MulDivRound(context:ProgressCurrent(mercs[1], sector, "prediction") or 0, 100, max)
            if context.id == "RepairItems" then
              local mercs = GetOperationProfessionals(sector.Id, "RepairItems")
              max = next(mercs) and mercs[1].OperationInitialETA or 0
              if 0 < max then
                local current = max - GetOperationTimerETA(mercs[1], "prediction")
                progress = MulDivRound(current or 0, 100, max)
              end
            end
            if progress and 0 <= progress then
              self:SetProgress(progress)
              self:SetVisible(true)
              self.parent:SetVisible(true)
            else
              self:SetVisible(false)
              self.parent:SetVisible(false)
            end
          end
        }, {
          PlaceObj("XTemplateFunc", {
            "name",
            "DrawBackground(self)",
            "func",
            function(self)
              XWindow.DrawBackground(self)
              local b = self.box
              local w = Max(3, MulDivRound(b:sizex(), self.Progress, 100))
              b = sizebox(b:minx(), b:miny(), w, b:sizey())
              UIL.DrawSolidRect(b, GameColors.J)
            end
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContextWindow",
      "Id",
      "idTextBack",
      "Margins",
      box(0, -5, 0, 0),
      "VAlign",
      "top",
      "MinWidth",
      190,
      "MinHeight",
      50,
      "MaxWidth",
      190,
      "MaxHeight",
      50,
      "Background",
      RGBA(32, 35, 47, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "Padding",
        box(5, 0, 5, 0),
        "HAlign",
        "center"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "AutoFitText",
          "Id",
          "idButtonText",
          "HAlign",
          "center",
          "TextStyle",
          "PDAActivitiesButton",
          "Translate",
          true,
          "WordWrap",
          true,
          "TextHAlign",
          "center",
          "TextVAlign",
          "center"
        })
      })
    })
  })
})
