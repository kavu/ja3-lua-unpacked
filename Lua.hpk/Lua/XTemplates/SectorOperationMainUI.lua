PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "SectorOperationMainUI",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Id",
    "idMain",
    "LayoutMethod",
    "HList",
    "HandleMouse",
    true,
    "HostInParent",
    true,
    "InitialMode",
    "change",
    "InternalModes",
    "change, progress, pick_item"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDialog.Open(self, ...)
        local host = GetActionsHost(self, true)
        local operation_id = host.mode_param.operation
        local sector = host.context
        local mercs = #GetOperationProfessionals(sector.Id, operation_id)
        local mode = sector.started_operations and sector.started_operations[operation_id] and "progress" or "change"
        if IsCraftOperation(operation_id) then
          if mode == "progress" and sector.operations_temp_data and sector.operations_temp_data[operation_id] then
            sector.operations_temp_data[operation_id].pick_item = false
          end
          if sector.operations_temp_data and sector.operations_temp_data[operation_id] and sector.operations_temp_data[operation_id].pick_item then
            mode = "pick_item"
          end
        end
        self:SetMode(mode, self:GetContext())
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        local dlg = GetDialog("SectorOperationsAssignDlgUI")
        if dlg then
          dlg:Close()
        end
        local host = GetActionsHost(self, true)
        local operation_id = host.mode_param.operation
        local sector = host.context
        if sector.operations_temp_data and sector.operations_temp_data[operation_id] then
          sector.operations_temp_data[operation_id].pick_item = false
        end
        return XDialog.Close(self, ...)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDialogModeChange(self, mode, dialog)",
      "func",
      function(self, mode, dialog)
        if mode == "Main" then
          RemoveTimelineEvent("activity-temp")
        end
      end
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "StartOperation(self, host)",
      "func",
      function(self, host)
        local dlg = GetDialog("SectorOperationsAssignDlgUI")
        if dlg then
          dlg:Close()
        end
        local operation_id = host.mode_param.operation
        local sector = host.context
        CreateRealTimeThread(function()
          sector.started_operations = sector.started_operations or {}
          local start_time
          local has_prev_data = sector.operations_prev_data and sector.operations_prev_data.operation_id == operation_id
          local diff = has_prev_data and SectorOperations_DataHasDifference(sector.operations_prev_data, sector.operations_temp_data[operation_id], operation_id, sector)
          if has_prev_data and not diff then
            start_time = sector.operations_prev_data.prev_start_time
          end
          if has_prev_data and diff then
            local qdlg = CreateQuestionBox(terminal.desktop, T(824112417429, "Warning"), T(176326810773, "Do you want to start the operation? If confirmed, the operation will restart with the new parameters. Resources and end time may change based on this"), T(1138, "Yes"), T(1139, "No"))
            qdlg:SetModal()
            local res = qdlg:Wait() == "ok"
            if not res and has_prev_data then
              SectorOperations_InterruptCurrent(sector, operation_id, "no log")
              SectorOperations_RestorePrev(host, sector, operation_id, start_time)
            elseif res then
              start_time = Game.CampaignTime
            end
            sector.operations_prev_data = false
          end
          NetSyncEvent("LogOperationStart", operation_id, sector.Id)
          NetSyncEvent("StartOperation", sector.Id, operation_id, start_time or sector.started_operations[operation_id] or Game.CampaignTime, sector.training_stat)
          SetBackDialogMode(host)
        end)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "IdNode",
      false,
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateMode", {
        "mode",
        "change, pick_item"
      }, {
        PlaceObj("XTemplateTemplate", {
          "__context",
          function(parent, context)
            return {
              operation = SectorOperations[GetActionsHost(parent, true).mode_param.operation],
              sector = GetActionsHost(parent, true).context
            }
          end,
          "__template",
          "SectorOperationDescrUI"
        })
      }),
      PlaceObj("XTemplateMode", {"mode", "progress"}, {
        PlaceObj("XTemplateTemplate", {
          "__context",
          function(parent, context)
            return {
              operation = SectorOperations[GetActionsHost(parent, true).mode_param.operation],
              sector = GetActionsHost(parent, true).context
            }
          end,
          "__template",
          "SectorOperationDescrProgressUI"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Margins",
        box(0, 16, 16, 16),
        "HAlign",
        "left",
        "Image",
        "UI/PDA/os_background_2",
        "FrameBox",
        box(2, 2, 56, 56)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContentTemplate",
          "Id",
          "idLeft",
          "IdNode",
          false,
          "MinWidth",
          764,
          "MaxWidth",
          764
        }, {
          PlaceObj("XTemplateMode", {"mode", "change"}, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContentTemplate",
              "IdNode",
              false
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "SectorOperationSelectMercUI",
                "VAlign",
                "top"
              })
            }),
            PlaceObj("XTemplateAction", {
              "comment",
              "train mercs",
              "ActionId",
              "ChangeStat",
              "ActionName",
              T(286944520992, "Change Stat"),
              "ActionToolbar",
              "ActionBar",
              "ActionState",
              function(self, host)
                local is_assign = GetDialog("SectorOperationsAssignDlgUI")
                local operation_id = host.mode_param.operation
                return not (operation_id ~= "TrainMercs" or is_assign) and "enabled" or "hidden"
              end,
              "OnAction",
              function(self, host, source, ...)
                local dlg = GetDialog("SectorOperationsAssignDlgUI")
                if dlg then
                  dlg:Close()
                end
                local dlg = host.idBase.idMain
                local ctxMenu = XTemplateSpawn("SectorOperationStatsPopupUI", host, dlg)
                local button = host.idActionBar[1][1]
                ctxMenu:SetAnchor(button.box)
                ctxMenu:SetMaxWidth(button.MaxWidth)
                ctxMenu:SetMinWidth(button.MinWidth)
                ctxMenu:Open()
                ctxMenu:SetModal()
              end,
              "FXMouseIn",
              "activityAssignStartHover",
              "FXPress",
              "activityAssignStartPress",
              "FXPressDisabled",
              "activityAssignStartDisabled",
              "replace_matching_id",
              true
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "Start",
              "ActionName",
              T(723674552406, "Start"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "S",
              "ActionState",
              function(self, host)
                local operation_id = host.mode_param.operation
                local sector = host.context
                local operation = SectorOperations[operation_id]
                if IsCraftOperation(operation_id) then
                  return "hidden"
                end
                if GetDialog("SectorOperationsAssignDlgUI") then
                  return "disabled"
                end
                for _, prof in ipairs(operation.Professions) do
                  local profession = prof.id
                  if #GetOperationProfessionals(sector.Id, operation_id, profession) <= 0 then
                    return "disabled"
                  end
                end
                return "enabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                local dlg = GetDialog("SectorOperationsAssignDlgUI")
                if dlg then
                  dlg:Close()
                end
                host.idBase.idMain:StartOperation(host)
                PlayFX("ActivityStarted", "start", host.mode_param.operation)
              end,
              "FXMouseIn",
              "activityAssignStartHover",
              "FXPressDisabled",
              "activityAssignStartDisabled",
              "replace_matching_id",
              true
            }),
            PlaceObj("XTemplateAction", {
              "comment",
              "repair items",
              "ActionId",
              "PickItem",
              "ActionName",
              T(630423773669, "Pick Item"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "P",
              "ActionState",
              function(self, host)
                local operation_id = host.mode_param.operation
                local sector = host.context
                local operation = SectorOperations[operation_id]
                if not IsCraftOperation(operation_id) then
                  return "hidden"
                end
                if GetDialog("SectorOperationsAssignDlgUI") then
                  return "disabled"
                end
                for _, prof in ipairs(operation.Professions) do
                  local profession = prof.id
                  if #GetOperationProfessionals(sector.Id, operation_id, profession) <= 0 then
                    return "disabled"
                  end
                end
                return "enabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                local dlg = GetDialog("SectorOperationsAssignDlgUI")
                if dlg then
                  dlg:Close()
                end
                local dlg = host.idBase.idMain
                if dlg then
                  local sector = host.context
                  local operation_id = host.mode_param.operation
                  sector.operations_temp_data = sector.operations_temp_data or {}
                  sector.operations_temp_data[operation_id] = sector.operations_temp_data[operation_id] or {}
                  sector.operations_temp_data[operation_id].pick_item = true
                  if operation_id == "CraftAmmo" or operation_id == "CraftExplosives" then
                    SectorOperationValidateItemsToCraft(sector.Id, operation_id)
                    local qid, aid = GetCraftOperationListsIds(operation_id)
                    NetSyncEvent("ChangeSectorOperationItemsOrder", sector.Id, operation_id, TableWithItemsToNet(sector[aid]), TableWithItemsToNet(sector[qid]))
                  end
                  dlg:SetMode("pick_item")
                end
              end,
              "FXMouseIn",
              "activityAssignStartHover",
              "FXPress",
              "activityAssignStartPress",
              "FXPressDisabled",
              "activityAssignStartDisabled",
              "replace_matching_id",
              true
            })
          }),
          PlaceObj("XTemplateMode", {
            "comment",
            "repair item",
            "mode",
            "pick_item"
          }, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContentTemplate",
              "IdNode",
              false
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "SectorOperationSelectItemsUI",
                "VAlign",
                "top"
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "PickMechanics",
              "ActionName",
              T(198244177822, "Pick Mechanics"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "P",
              "ActionState",
              function(self, host)
                local operation_id = host.mode_param.operation
                local sector = host.context
                local operation = SectorOperations[operation_id]
                if not IsCraftOperation(operation_id) then
                  return "hidden"
                end
                self.ActionName = operation_id == "RepairItems" and T(101121777005, "Pick Mechanic") or T(393929951034, "Pick Crafter")
                return "enabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                local dlg = host.idBase.idMain
                if dlg then
                  local sector = host.context
                  local operation_id = host.mode_param.operation
                  sector.operations_temp_data[operation_id].pick_item = false
                  dlg:SetMode("change")
                end
              end,
              "FXMouseIn",
              "activityAssignStartHover",
              "FXPress",
              "activityAssignStartPress",
              "FXPressDisabled",
              "activityAssignStartDisabled",
              "replace_matching_id",
              true
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "Autofill",
              "ActionName",
              T(237841394105, "Auto-fill"),
              "ActionToolbar",
              "ActionBar",
              "ActionState",
              function(self, host)
                local operation_id = host.mode_param.operation
                return operation_id == "RepairItems" and "enabled" or "hidden"
              end,
              "OnAction",
              function(self, host, source, ...)
                local dlg = GetDialog("SectorOperationsAssignDlgUI")
                if dlg then
                  dlg:Close()
                end
                local operation_id = host.mode_param.operation
                local sector = host.context
                local sector = host.context
                sector.operations_temp_data[operation_id].pick_item = true
                SectorOperationRepairItems_FillMostDamagedItems(sector.Id)
                NetSyncEvent("RecalcOperationETAs", sector.Id, "RepairItems", true)
                local dlg = host.idBase.idMain
                SectorOperation_ItemsUpdateItemLists(dlg)
              end,
              "FXMouseIn",
              "activityAssignStartHover",
              "FXPress",
              "activityAssignStartPress",
              "FXPressDisabled",
              "activityAssignStartDisabled",
              "replace_matching_id",
              true
            }),
            PlaceObj("XTemplateAction", {
              "comment",
              "repair item",
              "ActionId",
              "Start",
              "ActionName",
              T(723674552406, "Start"),
              "ActionToolbar",
              "ActionBar",
              "ActionShortcut",
              "S",
              "ActionState",
              function(self, host)
                local operation_id = host.mode_param.operation
                local sector = host.context
                local operation = SectorOperations[operation_id]
                if IsCraftOperation(operation_id) then
                  local queued = SectorOperationItems_GetItemsQueue(sector.Id, operation_id)
                  if not next(queued) then
                    return "disabled"
                  end
                end
                for _, prof in ipairs(operation.Professions) do
                  local profession = prof.id
                  if #GetOperationProfessionals(sector.Id, operation_id, profession) <= 0 then
                    return "disabled"
                  end
                end
                return "enabled"
              end,
              "OnAction",
              function(self, host, source, ...)
                host.idBase.idMain:StartOperation(host)
                PlayFX("ActivityStarted", "start", host.mode_param.operation)
              end,
              "FXMouseIn",
              "activityAssignStartHover",
              "FXPressDisabled",
              "activityAssignStartDisabled",
              "replace_matching_id",
              true
            })
          }),
          PlaceObj("XTemplateMode", {"mode", "progress"}, {
            PlaceObj("XTemplateWindow", {
              "__class",
              "XContentTemplate",
              "IdNode",
              false
            }, {
              PlaceObj("XTemplateTemplate", {
                "__template",
                "SectorOperationSelectMercProgressUI",
                "VAlign",
                "top"
              })
            }),
            PlaceObj("XTemplateAction", {
              "ActionId",
              "Change",
              "ActionName",
              T(790902536696, "Change"),
              "ActionToolbar",
              "ActionBar",
              "OnAction",
              function(self, host, source, ...)
                local operation_id = host.mode_param.operation
                local sector = host.context
                sector.started_operations = sector.started_operations or {}
                local prev_start_time = sector.started_operations[operation_id]
                sector.started_operations[operation_id] = false
                local mercs = GetOperationProfessionals(sector.Id, operation_id)
                for _, m in ipairs(mercs) do
                  Msg("OperationTimeUpdated", m, operation_id)
                end
                local dlg = host.idBase.idMain
                FillTempDataOnOpen(sector, operation_id)
                local mercs = GetOperationProfessionals(sector.Id, operation_id)
                local costs = {}
                local costs = GatOperationCostsArray(sector.Id, SectorOperations[operation_id])
                RemoveTimelineEvent("activity-temp")
                RemoveTimelineEvent("sector-activity-" .. sector.Id .. "-" .. operation_id)
                for i, merc in ipairs(mercs) do
                  NetSyncEvent("RestoreOperationCost", merc.session_id, costs[i])
                end
                local temp = table.copy(sector.operations_temp_data[operation_id] or empty_table)
                NetSyncEvent("InterruptSectorOperation", sector.Id, operation_id)
                dlg:SetMode("change", {operation = operation_id})
                sector.operations_prev_data = false
                sector.operations_prev_data = table.copy(temp)
                sector.operations_prev_data.prev_start_time = prev_start_time
                sector.operations_prev_data.training_stat = sector.training_stat
                sector.operations_prev_data.operation_id = operation_id
                CreateRealTimeThread(function(temp, host)
                  for m_id, merc_data in pairs(temp) do
                    for i, m_prof_data in ipairs(merc_data) do
                      if SectorOperations_IsValidMercId(m_id) then
                        table.remove(m_prof_data, 3)
                        local unit_data = gv_UnitData[m_id]
                        TryMercsSetOperation(host, {unit_data}, table.unpack(m_prof_data))
                        NetSyncEvent("MercSyncOperationsData", m_id, merc_data.Tiredness, merc_data.RestTimer, merc_data.TravelTime, merc_data.TravelTimerStart)
                      end
                    end
                  end
                  sector.operations_prev_data = false
                  sector.operations_prev_data = table.copy(temp)
                  sector.operations_prev_data.prev_start_time = prev_start_time
                  sector.operations_prev_data.training_stat = sector.training_stat
                  sector.operations_prev_data.operation_id = operation_id
                  if IsCraftOperation(operation_id) then
                    local data = sector.operations_temp_data[operation_id]
                    NetSyncEvent("SectorOperationItemsUpdateLists", sector.Id, operation_id, TableWithItemsToNet(data.all_items), TableWithItemsToNet(data.queued_items))
                  end
                end, temp, host)
              end,
              "FXMouseIn",
              "activityAssignChangeHover",
              "FXPress",
              "activityAssignChangePress",
              "FXPressDisabled",
              "activityAssignChangeDisabled",
              "replace_matching_id",
              true
            })
          }),
          PlaceObj("XTemplateAction", {
            "ActionId",
            "InterruptActivity",
            "ActionName",
            T(580187632077, "Abort"),
            "ActionToolbar",
            "ActionBar",
            "ActionState",
            function(self, host)
              local operation = host.mode_param.operation
              local sector_id = host.context.Id
              local mercs = GetOperationProfessionals(sector_id, operation)
              if #mercs <= 0 then
                return "hidden"
              end
              if GetDialog("SectorOperationsAssignDlgUI") then
                return "disabled"
              end
              return "enabled"
            end,
            "OnAction",
            function(self, host, source, ...)
              local dlg = GetDialog("SectorOperationsAssignDlgUI")
              if dlg then
                dlg:Close()
              end
              local args = {
                ...
              }
              CreateRealTimeThread(function(args)
                if host.window_state == "destroying" then
                  return
                end
                local operation = host.mode_param.operation
                local sector_id = host.context.Id
                local sector_operation = SectorOperations[operation]
                local mercs = GetOperationProfessionals(sector_id, operation)
                local costs = GetOperationCostsProcessed(mercs, operation, false, "both", "refund")
                local res
                if args and args[1] then
                  res = true
                else
                  local warning_txt = T({
                    178768095923,
                    "Are you sure you want to stop <display_name>?",
                    sector_operation
                  })
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
                  res = dlg:Wait() == "ok"
                end
                if res then
                  RemoveTimelineEvent("activity-temp")
                  for i, merc in ipairs(mercs) do
                    NetSyncEvent("RestoreOperationCost", merc.session_id, costs[i])
                  end
                  NetSyncEvent("InterruptSectorOperation", host.context.Id, host.mode_param.operation)
                  local sector = host.context
                  local has_prev_data = sector.operations_prev_data and sector.operations_prev_data.operation_id == operation
                  if has_prev_data then
                    for m_id, merc_data in pairs(sector.operations_prev_data) do
                      if SectorOperations_IsValidMercId(m_id) and merc_data and merc_data[1] and merc_data[1].prev_Operation == "Idle" then
                        NetSyncEvent("MercSetOperationIdle", m_id, merc_data[1].Tiredness, merc_data[1].RestTimer, merc_data[1].TravelTime, merc_data[1].TravelTimerStart)
                      end
                    end
                    sector.operations_prev_data = false
                  end
                  if sector.operations_temp_data then
                    sector.operations_temp_data[operation] = false
                  end
                  if host.window_state == "destroying" then
                    return
                  end
                  SetBackDialogMode(host)
                end
              end, args)
            end,
            "FXMouseIn",
            "activityAssignInterruptHover",
            "FXPress",
            "activityAssignInterruptPress",
            "FXPressDisabled",
            "activityAssignInterruptDisabled",
            "replace_matching_id",
            true
          })
        })
      })
    })
  })
})
