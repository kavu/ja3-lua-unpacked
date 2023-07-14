PlaceObj("XTemplate", {
  group = "Zulu",
  id = "SectorOperationsAssignDlgUI",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Background",
    RGBA(30, 30, 35, 115),
    "HandleMouse",
    true,
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga"
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Close",
      "func",
      function(self, ...)
        RemoveTimelineEvent("activity-temp")
        XDialog.Close(self)
      end
    }),
    PlaceObj("XTemplateFunc", {
      "comment",
      "-- repair operation",
      "name",
      "UpdateItemsLists(self, operation_id, sector)",
      "func",
      function(self, operation_id, sector)
        if IsCraftOperation(operation_id) then
          local data = sector.operations_temp_data[operation_id]
          NetSyncEvent("SectorOperationItemsUpdateLists", sector.Id, operation_id, TableWithItemsToNet(data.all_items), TableWithItemsToNet(data.queued_items))
        end
      end
    }),
    PlaceObj("XTemplateWindow", {
      "BorderWidth",
      1,
      "HAlign",
      "center",
      "VAlign",
      "center",
      "MinWidth",
      300
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextFrame",
        "Dock",
        "top",
        "VAlign",
        "top",
        "MinHeight",
        32,
        "MaxHeight",
        32,
        "Image",
        "UI/PDA/os_header",
        "FrameBox",
        box(2, 2, 37, 37)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "Margins",
          box(16, 0, 0, 0),
          "HAlign",
          "left",
          "VAlign",
          "center",
          "HandleMouse",
          false,
          "TextStyle",
          "UIDlgTitle",
          "Translate",
          true,
          "Text",
          T(767451291768, "ADD MERC"),
          "TextVAlign",
          "center"
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextWindow",
        "Dock",
        "box",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local node = self:ResolveId("node")
          local nslots = context.other_free_slots and #context.other_free_slots or -1
          local text = ""
          if 0 <= nslots then
            nslots = nslots + 1
            text = T({
              602532449686,
              "Select up to <em_style><free_slots><em_style_close> mercs to assign to this Operation",
              free_slots = nslots,
              em_style = Untranslated("<style PDAActivityAssignDlgDescriptionEm>"),
              em_style_close = Untranslated("</style>")
            })
            node.idMsgText:SetText(text)
            node.idMsgText:SetVisible(true)
          else
            node.idMsgText:SetVisible(false)
          end
          local operation_preset = SectorOperations[context.operation]
          if operation_preset.related_stat_2 then
            local statProp1 = table.find_value(UnitPropertiesStats:GetProperties(), "id", operation_preset.related_stat).name
            local statProp2 = table.find_value(UnitPropertiesStats:GetProperties(), "id", operation_preset.related_stat_2).name
            text = text .. "\n" .. T({
              404190626821,
              "<em>Mercs are compared by their <related_stat> and <related_stat_2><em>",
              related_stat = statProp1,
              related_stat_2 = statProp2
            })
            node.idMsgText:SetText(text)
            node.idMsgText:SetVisible(true)
          end
          if table.find(operation_preset.RequiredResources, "Meds") and context.profession ~= "Doctor" then
            local res_t = SectorOperationResouces.Meds
            local all_meds = res_t and res_t.current(context.sector) or 0
            node.idResText:SetValueText(FormatInt(all_meds))
            node.idResText:SetVisible(true)
          else
            node.idResText:SetVisible(false)
          end
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XFrame",
          "IdNode",
          false,
          "LayoutMethod",
          "VList",
          "Image",
          "UI/PDA/os_background",
          "FrameBox",
          box(2, 2, 56, 56)
        }, {
          PlaceObj("XTemplateWindow", {
            "comment",
            "description text",
            "__class",
            "XText",
            "Id",
            "idMsgText",
            "Margins",
            box(12, 8, 10, -8),
            "HAlign",
            "left",
            "OnLayoutComplete",
            function(self)
              local node = self:ResolveId("node")
              self:SetMaxWidth(Max(300, node.idMercsList.parent.box:sizex() + 100))
            end,
            "FoldWhenHidden",
            true,
            "HandleMouse",
            false,
            "TextStyle",
            "PDAActivityAssignDlgDescription",
            "Translate",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "description text",
            "__class",
            "XNameValueText",
            "Id",
            "idResText",
            "Margins",
            box(16, 8, 16, -8),
            "FoldWhenHidden",
            true,
            "HandleMouse",
            false,
            "NameText",
            T(107206855853, "Available meds"),
            "TextStyle",
            "PDAActivitiesAssignDlgResName",
            "TextStyleRight",
            "PDAActivitiesAssignDlgResValue"
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XFrame",
            "IdNode",
            false,
            "Margins",
            box(16, 16, 16, 16),
            "Padding",
            box(20, 5, 20, 5),
            "LayoutMethod",
            "VList",
            "Image",
            "UI/PDA/os_background_2",
            "FrameBox",
            box(2, 2, 56, 56)
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "portraits",
              "__class",
              "XContextWindow",
              "Id",
              "idMercsList",
              "HAlign",
              "center",
              "LayoutMethod",
              "Grid",
              "LayoutHSpacing",
              20,
              "LayoutVSpacing",
              20
            }, {
              PlaceObj("XTemplateForEach", {
                "comment",
                "item",
                "array",
                function(parent, context)
                  return GetOperationMercsListContext(context.sector, context)[1].mercs
                end,
                "__context",
                function(parent, context, item, i, n)
                  return {
                    list_as_prof = context.list_as_prof,
                    merc = item
                  }
                end,
                "run_after",
                function(child, context, item, i, n, last)
                  rawset(child, "slot_idx", i)
                  local host = GetActionsHost(child, true)
                  local mode_param = host.context
                  local operation = mode_param.operation
                  local prof = mode_param.profession
                  local merc = context.merc
                  local cost = SectorOperations[operation]:GetOperationCost(merc, prof)
                  local cost_t = GetOperationCostText(cost, "img_tag", false, "no_name")
                  child.idCost:SetText(cost_t)
                  child.idCostLine:SetVisible(cost_t and cost_t ~= "")
                  local dev = 10
                  if 10 < last and last % 10 < 3 then
                    dev = last / 2 + last % 2
                  end
                  local row = i % dev == 0 and i / dev or i / dev + 1
                  child:SetGridY(row)
                  child:SetGridX(i % dev == 0 and dev or i % dev)
                end
              }, {
                PlaceObj("XTemplateTemplate", {
                  "__template",
                  "OperationMerc"
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "OnMouseButtonDown(self, pos, button)",
                    "func",
                    function(self, pos, button)
                      local merc = self.context.merc
                      local host = GetActionsHost(self.parent, true)
                      local mode_param = host.context
                      local operation = mode_param.operation
                      local operation_preset = SectorOperations[operation]
                      local prof = mode_param.profession
                      local list_prof = self.context.list_as_prof
                      local slots = operation_preset:GetSectorSlots(prof, host.context)
                      local node = self:ResolveId("node")
                      if slots ~= -1 then
                        slots = 1 + (mode_param.other_free_slots and #mode_param.other_free_slots)
                      end
                      if merc.class == "free_space" then
                      elseif merc.class == "empty" then
                        local other_free_slots = slots ~= -1 and {}
                        if other_free_slots then
                          for i, v in ipairs(self.parent) do
                            if IsKindOf(v, "XContentTemplate") and v.context.merc.class == "empty" and v.slot_idx ~= self.slot_idx then
                              table.insert(other_free_slots, v.slot_idx)
                            end
                          end
                        end
                      else
                        local parent = self.parent.parent
                        local selected = not rawget(self, "selected")
                        local selected_items = rawget(parent, "selected_items")
                        if not selected_items then
                          rawset(parent, "selected_items", {})
                          selected_items = rawget(parent, "selected_items")
                        end
                        if slots and #selected_items == slots and selected then
                          local item = table.remove(selected_items, 1)
                          if item then
                            rawset(item, "selected", false)
                            item:SetStyle(false)
                          end
                        end
                        if selected then
                          table.insert(selected_items, self)
                        else
                          table.remove_entry(selected_items, self)
                          rawset(self, "selected", false)
                          self:SetStyle(false)
                        end
                        rawset(self, "selected", selected)
                        self:SetStyle(selected)
                        host.idActionBar:OnUpdateActions()
                        local selected_mercs = {}
                        local selected_mercs_witout_me = {}
                        for _, btn in ipairs(selected_items) do
                          local mc = btn.context.merc
                          selected_mercs[#selected_mercs + 1] = mc
                          if mc ~= merc then
                            selected_mercs_witout_me[#selected_mercs_witout_me + 1] = mc
                          end
                        end
                        local costs = GetOperationCosts(selected_mercs, operation, prof, mode_param.operation_slot_idx, mode_param.other_free_slots)
                        host.idCosts:SetVisible(next(costs))
                        host.idCosts:SetContext(costs)
                        local healing = IsOperationHealing(operation)
                        local nselected_idx = 0
                        RemoveTimelineEvent("activity-temp")
                        for i, m in ipairs(host.idMercsList) do
                          local merc = m.context.merc
                          local is_selected = rawget(m, "selected")
                          if is_selected then
                            nselected_idx = nselected_idx + 1
                          end
                          local cost = SectorOperations[operation]:GetOperationCost(merc, prof, rawget(m, "selected") and nselected_idx or #selected_mercs + 1)
                          local cost_t = GetOperationCostText(cost, "img_tag", false, "no_name")
                          m.idCost:SetText(cost_t)
                        end
                        local eta = GetOperationTimeLeftAssign(false, operation, {
                          sector = mode_param.sector,
                          prediction = true,
                          list_as_prof = prof,
                          add_units = selected_mercs
                        })
                        local timeLeft = eta and Game.CampaignTime + eta
                        if timeLeft then
                          local already_assigned = GetOperationProfessionals(mode_param.sector.Id, operation, prof)
                          local list = table.iappend(table.map(selected_mercs, "session_id"), table.map(already_assigned, "session_id"))
                          AddTimelineEvent("activity-temp", timeLeft, "operation", {
                            profession = prof,
                            operationId = operation,
                            sectorId = mode_param.sector.Id,
                            mercs = list
                          })
                        end
                      end
                      return "break"
                    end
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "cost",
              "__class",
              "XContentTemplate",
              "Id",
              "idCosts",
              "IdNode",
              false,
              "VAlign",
              "top",
              "MinHeight",
              40,
              "MaxHeight",
              40,
              "LayoutMethod",
              "VList",
              "Visible",
              false,
              "FoldWhenHidden",
              true
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XFrame",
                "VAlign",
                "top",
                "Image",
                "UI/PDA/separate_line_vertical",
                "FrameBox",
                box(2, 0, 2, 0),
                "SqueezeY",
                false
              }),
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(10, 4, 0, 4),
                "HAlign",
                "center",
                "VAlign",
                "center",
                "LayoutMethod",
                "HList"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "VAlign",
                  "center",
                  "TextStyle",
                  "PDAActivitiesButton",
                  "Translate",
                  true,
                  "Text",
                  T(487432574538, "Cost:")
                }),
                PlaceObj("XTemplateWindow", {
                  "LayoutMethod",
                  "HList",
                  "LayoutHSpacing",
                  10
                }, {
                  PlaceObj("XTemplateForEach", {
                    "comment",
                    "resource",
                    "__context",
                    function(parent, context, item, i, n)
                      return item
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                      child:SetContext(item)
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContextWindow",
                      "RolloverTemplate",
                      "SmallRolloverGeneric",
                      "RolloverAnchor",
                      "bottom",
                      "IdNode",
                      true,
                      "HAlign",
                      "center",
                      "VAlign",
                      "center",
                      "LayoutMethod",
                      "HList",
                      "HandleMouse",
                      true,
                      "ContextUpdateOnOpen",
                      true,
                      "OnContextUpdate",
                      function(self, context, ...)
                        if context.resource ~= "Money" then
                          local res_t = SectorOperationResouces[context.resource]
                          local all_res = res_t and res_t.current(GetDialog(self).context.sector) or 0
                          local all = FormatInt(all_res)
                          self.idVal:SetText(T({
                            261978178683,
                            "<val>/<GameColorD><max>",
                            val = context.value,
                            max = all
                          }))
                        else
                          self.idVal:SetText(Untranslated(context.value))
                        end
                        local ts = table.find_value(SectorOperationResouces, "id", context.resource)
                        self.idImg:SetImage(ts and ts.icon)
                      end
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "LayoutMethod",
                        "HList"
                      }, {
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XText",
                          "Id",
                          "idVal",
                          "TextStyle",
                          "PDAActivitiesVal",
                          "Translate",
                          true
                        }),
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XImage",
                          "Id",
                          "idImg",
                          "HAlign",
                          "left",
                          "ImageColor",
                          RGBA(124, 130, 96, 255)
                        })
                      })
                    })
                  })
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "__class",
            "XToolBarList",
            "Id",
            "idActionBar",
            "ZOrder",
            3,
            "Margins",
            box(20, 0, 20, 20),
            "HAlign",
            "center",
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
          })
        })
      })
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idSelect",
      "ActionName",
      T(130203409953, "Confirm"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "Enter",
      "ActionState",
      function(self, host)
        local mercs_list = host.idMercsList
        local selected = {}
        for i, m in ipairs(mercs_list) do
          if rawget(m, "selected") then
            selected[#selected + 1] = m.context.merc
          end
        end
        return 0 < #selected and "enabled" or "disabled"
      end,
      "OnAction",
      function(self, host, source, ...)
        local mercs_list = host.idMercsList
        local selected = {}
        for i, m in ipairs(mercs_list) do
          if rawget(m, "selected") then
            selected[#selected + 1] = m.context.merc
          end
        end
        if #selected == 0 then
          return
        end
        local mode_param = host.context
        local operation = mode_param.operation
        local prof = mode_param.profession
        CreateRealTimeThread(function()
          if host.window_state == "destroying" then
            return
          end
          local has_slot = SectorOperations[operation]:GetSectorSlots(prof, selected[1]:GetSector()) ~= -1
          MercsOperationsFillTempData(host.context.sector, operation)
          local assigned = TryMercsSetOperation(host, selected, operation, prof, mode_param.operation_slot_idx, has_slot and mode_param.other_free_slots)
          if assigned and host.window_state ~= "destroying" then
            host:UpdateItemsLists(operation, host.context.sector)
            host:Close()
          end
        end)
      end
    }),
    PlaceObj("XTemplateAction", {
      "ActionId",
      "idClose",
      "ActionName",
      T(225864359825, "Close"),
      "ActionToolbar",
      "ActionBar",
      "ActionShortcut",
      "Escape",
      "ActionGamepad",
      "ButtonB",
      "OnActionEffect",
      "close"
    })
  })
})
