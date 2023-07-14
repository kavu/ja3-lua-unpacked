PlaceObj("XTemplate", {
  group = "Zulu",
  id = "SectorOperationsUI",
  PlaceObj("XTemplateWindow", {
    "__class",
    "ZuluModalDialog",
    "Background",
    RGBA(30, 30, 35, 115),
    "FadeInTime",
    200,
    "FadeOutTime",
    200,
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga",
    "OnContextUpdate",
    function(self, context, ...)
      if self.mode_param and self.mode_param.operation then
        local op = SectorOperations[self.mode_param.operation]
        if not op:HasOperation(context) then
          self:SetMode("Main")
        end
      end
    end,
    "InitialMode",
    "Main",
    "InternalModes",
    "Main, Operation",
    "GamepadVirtualCursor",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XHideDialogs",
      "LeaveDialogIds",
      {"PDADialog"}
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Open(self, ...)",
      "func",
      function(self, ...)
        g_SatelliteUI:ShowCursorHint(false)
        self.hidden_UI = {}
        local infopanel = GetSectorInfoPanel()
        if infopanel then
          self.hidden_UI[infopanel] = true
          infopanel:SetVisible(false)
        end
        local speeds_ctrl = g_SatelliteUI.parent.idSpeedsWnd
        if speeds_ctrl then
          self.hidden_UI[speeds_ctrl] = true
          speeds_ctrl:SetVisible(false)
        end
        SetCampaignSpeed(0, GetUICampaignPauseReason("SectorOperations"))
        PlayFX("OperationsOpen", "start")
        ZuluModalDialog.Open(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close(self, ...)",
      "func",
      function(self, ...)
        local sector = self:GetContext()
        if sector then
          sector.operations_prev_data = false
        end
        self:CreateThread(function()
          self:AddInterpolation({
            id = "alpha",
            type = const.intAlpha,
            duration = 200,
            startValue = 255,
            endValue = 0
          })
          Sleep(200)
          PlayFX("OperationsClose", "start")
          SetCampaignSpeed(nil, GetUICampaignPauseReason("SectorOperations"))
          for ui, _ in pairs(self.hidden_UI) do
            ui:SetVisible(true)
          end
          return ZuluModalDialog.Close(self)
        end)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "GetModeDlg(self)",
      "func",
      function(self)
        return self.idBase.idMain
      end
    }),
    PlaceObj("XTemplateWindow", {
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      1240,
      "MinHeight",
      665,
      "MaxWidth",
      1240,
      "MaxHeight",
      665,
      "OnLayoutComplete",
      function(self)
        if not g_SatTimelineUI then
          return
        end
        local _, ySize = ScaleXY(self.scale, 0, self.MaxHeight)
        local parBx = self.parent.box
        local spaceLeft = parBx:sizey() - ySize
        spaceLeft = spaceLeft / 2
        local timelineBox = g_SatTimelineUI.box
        local bottomLine = parBx:maxy() - spaceLeft
        if bottomLine > timelineBox:miny() then
          self:SetVAlign("top")
          self:SetMargins(box(0, 30, 0, 0))
        else
          self:SetVAlign("center")
          self:SetMargins(empty_box)
        end
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContentTemplate",
        "IdNode",
        false
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "IdNode",
          false,
          "Image",
          "UI/PDA/os_background",
          "FrameBox",
          box(2, 2, 56, 56)
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "SectorOperationTopUI"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "Margins",
            box(20, 16, 20, 57),
            "Dock",
            "box"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XFrame",
              "Id",
              "idBase",
              "Image",
              "UI/PDA/os_background",
              "FrameBox",
              box(2, 2, 56, 56)
            }, {
              PlaceObj("XTemplateMode", {"mode", "Main"}, {
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idAbortAll",
                  "ActionSortKey",
                  "10",
                  "ActionName",
                  T(919358300788, "Stop All"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionShortcut",
                  "A",
                  "ActionGamepad",
                  "ButtonX",
                  "ActionState",
                  function(self, host)
                    local sector_id = host.context.Id
                    local operations = GetOperationsInSector(sector_id)
                    for _, operation_data in ipairs(operations) do
                      local operation = operation_data.operation
                      local mercs = GetOperationProfessionals(sector_id, operation.id)
                      if 0 < #mercs then
                        return "enabled"
                      end
                    end
                    return "disabled"
                  end,
                  "OnAction",
                  function(self, host, source, ...)
                    CreateRealTimeThread(function()
                      if host.window_state == "destroying" then
                        return
                      end
                      local sector_id = host.context.Id
                      local operations = GetOperationsInSector(sector_id)
                      local mercs = {}
                      local costs = {}
                      for _, operation_data in ipairs(operations) do
                        local sector_operation = operation_data.operation
                        local amercs = GetOperationProfessionals(sector_id, sector_operation.id)
                        local ocosts = GetOperationCostsProcessed(amercs, sector_operation, false, "both", "refund")
                        table.iappend(costs, ocosts)
                        for i, merc in ipairs(amercs) do
                          mercs[#mercs + 1] = merc
                        end
                      end
                      local warning_txt = T(423021484293, "Are you sure you want to stop all Operations?")
                      local restore_txt = GetOperationCostText(CombineOperationCosts(costs), "img_tag", true, "no_name")
                      if restore_txt ~= "" then
                        restore_txt = T({
                          548330460792,
                          "You will be refunded <cost>.",
                          cost = restore_txt
                        })
                      end
                      local dlg = CreateQuestionBox(terminal.desktop, T(824112417429, "Warning"), restore_txt ~= "" and T({
                        653728009504,
                        [[
<warning>
<restore>]],
                        warning = warning_txt,
                        restore = restore_txt
                      }) or warning_txt, T(689884995409, "Yes"), T(782927325160, "No"))
                      dlg:SetModal()
                      if dlg:Wait() == "ok" then
                        for i, merc in ipairs(mercs) do
                          NetSyncEvent("RestoreOperationCost", merc.session_id, costs[i])
                        end
                        for _, operation_data in ipairs(operations) do
                          local sector_operation = operation_data.operation
                          NetSyncEvent("InterruptSectorOperation", sector_id, sector_operation.id)
                        end
                        SetCampaignSpeed(0, "UI")
                        if host.window_state == "destroying" then
                          return
                        end
                        host:UpdateActionViews(host)
                        ObjModified(host.context)
                      end
                    end)
                  end
                }),
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idClose",
                  "ActionSortKey",
                  "9",
                  "ActionName",
                  T(378882267964, "Close"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionShortcut",
                  "Escape",
                  "ActionGamepad",
                  "ButtonB",
                  "OnActionEffect",
                  "close"
                }),
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "SectorOperationsListUI"
                })
              }),
              PlaceObj("XTemplateMode", {"mode", "Operation"}, {
                PlaceObj("XTemplateAction", {
                  "ActionId",
                  "idClose",
                  "ActionSortKey",
                  "8",
                  "ActionName",
                  T(831318011207, "Back"),
                  "ActionToolbar",
                  "ActionBar",
                  "ActionShortcut",
                  "Escape",
                  "ActionGamepad",
                  "ButtonB",
                  "OnActionEffect",
                  "back",
                  "OnAction",
                  function(self, host, source, ...)
                    local dlg = GetDialog("SectorOperationsAssignDlgUI")
                    if dlg then
                      dlg:Close()
                    end
                    local effect = self.OnActionEffect
                    local param = self.OnActionParam
                    CreateRealTimeThread(function()
                      local subdlg = host.idBase.idMain
                      local mode = subdlg and subdlg:GetMode()
                      if mode == "progress" then
                        SetBackDialogMode(host)
                        return
                      end
                      local operation_id = host.mode_param.operation
                      if mode == "pick_item" and IsCraftOperation(operation_id) then
                        local cancel = false
                        local drag = subdlg.idQueueList.idQueue
                        if drag and drag.drag_win then
                          drag.drag_win:delete()
                          drag.drag_win = false
                          drag:StopDrag()
                          cancel = true
                        end
                        drag = subdlg.idAllList.idAllItems
                        if drag and drag.drag_win then
                          drag.drag_win:delete()
                          drag.drag_win = false
                          drag:StopDrag()
                          cancel = true
                        end
                        if cancel then
                          SectorOperation_ItemsUpdateItemLists(subdlg)
                          return
                        end
                      end
                      if mode == "change" or mode == "pick_item" then
                        local sector = host.context
                        if not sector.operations_temp_data or not sector.operations_temp_data[operation_id] then
                          SetBackDialogMode(host)
                          return
                        end
                        local question_text = T(616270408863, "Are you sure you want to cancel? All changes will be reverted and returned to the previous state of the operation")
                        local qdlg = CreateQuestionBox(terminal.desktop, T(824112417429, "Warning"), question_text, T(1138, "Yes"), T(1139, "No"))
                        qdlg:SetModal()
                        local res = qdlg:Wait() == "ok"
                        if res then
                          local start_time = sector.operations_prev_data and sector.operations_prev_data.prev_start_time
                          SectorOperations_InterruptCurrent(sector, operation_id, "no log")
                          SectorOperations_RestorePrev(host, sector, operation_id, start_time)
                          SetBackDialogMode(host)
                          return
                        end
                        if not res then
                          return
                        end
                      end
                    end)
                  end
                }),
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "SectorOperationMainUI"
                })
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Id",
        "idVersion",
        "Margins",
        box(20, 0, 0, 16),
        "HAlign",
        "left",
        "VAlign",
        "bottom",
        "UseClipBox",
        false,
        "TextStyle",
        "PDAActivityVersion",
        "Text",
        "\194\169 A.I.M. 2001"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XToolBarList",
        "Id",
        "idActionBar",
        "ZOrder",
        3,
        "Margins",
        box(0, 10, 20, 12),
        "HAlign",
        "right",
        "VAlign",
        "bottom",
        "LayoutHSpacing",
        20,
        "DrawOnTop",
        true,
        "Background",
        RGBA(255, 255, 255, 0),
        "Toolbar",
        "ActionBar",
        "Show",
        "text",
        "ButtonTemplate",
        "PDACommonButton"
      }),
      PlaceObj("XTemplateFunc", {
        "name",
        "Open(self)",
        "func",
        function(self)
          XWindow.Open(self)
          RunWhenXWindowIsReady(self, function()
            local popUpTime = 200
            local fadeInTime = 200
            self:AddInterpolation({
              id = "size",
              type = const.intRect,
              duration = popUpTime,
              originalRect = self.box,
              targetRect = self:CalcZoomedBox(800),
              flags = const.intfInverse
            })
            self:AddInterpolation({
              id = "alpha",
              type = const.intAlpha,
              duration = popUpTime,
              startValue = 0,
              endValue = 255
            })
          end)
        end
      })
    })
  })
})
