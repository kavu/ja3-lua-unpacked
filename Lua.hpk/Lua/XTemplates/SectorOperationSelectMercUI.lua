PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "SectorOperationSelectMercUI",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XDialog",
    "Id",
    "idList",
    "IdNode",
    false,
    "Dock",
    "box",
    "OnContextUpdate",
    function(self, context, ...)
      local node = self:ResolveId("node")
      node.idMercsList:OnContextUpdate(GetOperationMercsListContext(context, GetActionsHost(self, true).mode_param))
    end,
    "HostInParent",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "delete(self, ...)",
      "func",
      function(self, ...)
        if DragSource then
          DragSource:InternalDragStop(terminal.GetMousePos())
        end
        return XDialog.delete(self, ...)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return GetOperationMercsListContext(context, GetActionsHost(parent, true).mode_param)
      end,
      "__class",
      "XContextWindow",
      "VAlign",
      "top",
      "Clip",
      "self"
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContentTemplate",
        "Id",
        "idMercsList",
        "IdNode",
        false,
        "VAlign",
        "top",
        "MaxWidth",
        800,
        "Clip",
        "self"
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idText",
          "VAlign",
          "top",
          "FoldWhenHidden",
          true,
          "HandleMouse",
          false,
          "TextStyle",
          "PDAActivitiesSubTitleDark",
          "Translate",
          true,
          "HideOnEmpty",
          true,
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "Margins",
          box(24, 18, 24, 18),
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XContextWindow",
            "Id",
            "idSections",
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            18,
            "ContextUpdateOnOpen",
            true
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "operation section",
              "__context",
              function(parent, context, item, i, n)
                return item
              end,
              "run_before",
              function(parent, context, item, i, n, last)
                local sector = item.sector_id and gv_Sectors[item.sector_id]
                if item.operation == "TrainMercs" and item.list_as_prof == "Teacher" then
                  sector.training_stat = sector.training_stat or "Health"
                end
              end,
              "run_after",
              function(child, context, item, i, n, last)
                local infinite_slots = item.infinite_slots
                local title = item.title
                local sector = item.sector_id and gv_Sectors[item.sector_id]
                if item.operation == "TrainMercs" and item.list_as_prof == "Teacher" then
                  local stat_name = table.find_value(UnitPropertiesStats:GetProperties(), "id", sector and sector.training_stat)
                  title = title .. (sector and stat_name and Untranslated("<style PDAActivitiesButton> (") .. stat_name.name .. Untranslated(")</style>") or "")
                end
                if n ~= 1 then
                  if item.infinite_slots then
                    if item.occupied_slots then
                      title = title .. T({
                        577121182372,
                        "<right><GameColorF><occupied_slots></GameColorF>",
                        item
                      })
                    end
                  elseif item.occupied_slots then
                    local count = table.count(item.mercs) - (item.free_space or 0)
                    title = title .. T({
                      137933144149,
                      "<right><GameColorF><occupied_slots></GameColorF>/<GameColorD><count></GameColorD>",
                      count = count,
                      item
                    })
                  elseif item.mercs then
                    title = title .. T({
                      571633925764,
                      "<right><GameColorF><count(mercs)></GameColorF>",
                      item
                    })
                  end
                else
                  local sector_id = item.sector_id
                  local operation_id = item.operation
                  local mercs = GetOperationProfessionals(sector_id, operation_id)
                  local time = next(mercs) and mercs[1].OperationInitialETA or 0
                  if time < 0 then
                    time = 0
                  end
                  title = title .. T({
                    818535186344,
                    "<right><GameColorF><image UI/SectorOperations/T_Icon_Activity_Resting 1500 130 128 120><timeDuration(time)>",
                    time = time
                  })
                end
                if context.operation ~= "MilitiaTraining" or context.list_as_prof == "Trainer" then
                  child[1][1]:SetText(title)
                end
              end
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "non militia sections",
                "__condition",
                function(parent, context)
                  return context.operation ~= "MilitiaTraining" or context.list_as_prof == "Trainer"
                end,
                "__class",
                "XContextWindow",
                "VAlign",
                "top",
                "LayoutMethod",
                "VList",
                "Clip",
                "parent & self"
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "section title",
                  "LayoutMethod",
                  "VList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "VAlign",
                    "top",
                    "LayoutMethod",
                    "HList",
                    "FoldWhenHidden",
                    true,
                    "HandleMouse",
                    false,
                    "TextStyle",
                    "PDAActivitiesSubTitleDark",
                    "Translate",
                    true,
                    "HideOnEmpty",
                    true,
                    "TextVAlign",
                    "center"
                  }),
                  PlaceObj("XTemplateWindow", {
                    "VAlign",
                    "top",
                    "MinHeight",
                    2,
                    "MaxHeight",
                    2,
                    "Background",
                    RGBA(124, 130, 96, 255),
                    "Transparency",
                    160
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XContextWindow",
                  "IdNode",
                  true,
                  "OnLayoutComplete",
                  function(self)
                    if self.context.operation == "RepairItems" then
                      self.idNotAvailableMercs:SetMargins(box(0, 165, 0, 0))
                    end
                  end,
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local dlg_context = GetDialog(self):GetContext()
                    local sector_id = dlg_context.Id
                    local operation = context.operation
                    local to_add_mercs = GetOperationProfessionals(sector_id, "Idle")
                    local available = GetAvailableMercs(sector_id, operation, context.list_as_prof)
                    local empty = false
                    if #to_add_mercs <= 0 then
                      for _, item in ipairs(context.mercs) do
                        if item.prof ~= "Militia" and item.class == "empty" then
                          empty = true
                        end
                      end
                    end
                    self.idNotAvailableMercs:SetText(T(896654085057, "\208\144ll mercs are assigned to other Operations. "))
                    local idx = next(context.mercs)
                    if context.mercs[idx].class == "empty" and operation == "TrainMercs" and #available <= 0 then
                      self.idNotAvailableMercs:SetText(T(844787113687, "No suitable merc"))
                      empty = true
                    end
                    if empty then
                      local playerMercs = GetPlayerMercsInSector(sector_id)
                      if #playerMercs == #GetOperationProfessionals(sector_id, operation) then
                        empty = false
                      end
                    end
                    if empty and context then
                      local teachers = GetOperationProfessionals(sector_id, operation, "Teacher")
                      if (idx and context.mercs[idx].OperationProfession == "Student" or context.list_as_prof == "Student") and #teachers <= 0 then
                        empty = false
                      end
                      local assigned = GetOperationProfessionals(sector_id, "TreatWounds", context.list_as_prof)
                      if operation == "TreatWounds" and (assigned or 0 < #available) then
                        empty = false
                      end
                    end
                    self.idNotAvailableMercs:SetVisible(empty)
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XScrollArea",
                    "Id",
                    "idPortraitsList",
                    "IdNode",
                    false,
                    "VAlign",
                    "top",
                    "MaxWidth",
                    800,
                    "MaxHeight",
                    200,
                    "Clip",
                    "self",
                    "VScroll",
                    "idScrollbar",
                    "MouseWheelStep",
                    130
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContextWindow",
                      "Id",
                      "idList",
                      "LayoutMethod",
                      "HWrap",
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
                          return context.mercs
                        end,
                        "__context",
                        function(parent, context, item, i, n)
                          return {
                            list_as_prof = context.list_as_prof,
                            merc = item,
                            click = context.click,
                            operation = context.operation
                          }
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                          rawset(child, "slot_idx", i)
                          local dlg_context = GetDialog(child):GetContext()
                          local to_add_mercs = #GetOperationMercsListContext(dlg_context, SubContext(context, {
                            assign_merc = true,
                            profession = context.list_as_prof
                          }))[1].mercs
                          if context.merc.class == "empty" and to_add_mercs <= 0 then
                            context.click = false
                            child:SetContext(SubContext(context, {unavailable = true}))
                          end
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
                              if merc.class == "free_space" then
                                return
                              end
                              local host = GetActionsHost(self.parent, true)
                              local mode_param = host.mode_param
                              local operation = self.context.operation
                              local operation_preset = SectorOperations[operation]
                              local prof = mode_param.profession
                              local list_prof = self.context.list_as_prof
                              local click = self.context.click
                              local slots = operation_preset:GetSectorSlots(prof or list_prof, host.context)
                              if self.context.click == false then
                                PlayFX("activityDisabled", "start", self)
                                return
                              end
                              if merc.class == "empty" then
                                PlayFX("activityAddPress", "start", self)
                                local other_free_slots = slots ~= -1 and {}
                                if other_free_slots then
                                  for i, v in ipairs(self:ResolveId("idList")) do
                                    if v.context.merc.class == "empty" and v.slot_idx ~= self.slot_idx then
                                      table.insert(other_free_slots, v.slot_idx)
                                    end
                                  end
                                end
                                local context = {
                                  sector = host.context,
                                  assign_merc = true,
                                  operation = operation,
                                  profession = merc.prof,
                                  operation_slot_idx = self.slot_idx,
                                  other_free_slots = other_free_slots,
                                  selected = {}
                                }
                                if context.operation == "TrainMercs" and merc.prof == "Teacher" or next(GetOperationMercsListContext(context.sector, context)[1].mercs) then
                                  OpenDialog("SectorOperationsAssignDlgUI", GetDialog("SectorOperationsUI")[1], context)
                                end
                              elseif not mode_param.assign_merc then
                                PlayFX("activityAssign", "start", self)
                                CreateRealTimeThread(function()
                                  if host.window_state == "destroying" then
                                    return
                                  end
                                  local sector = merc:GetSector()
                                  local cost = operation_preset:GetOperationCost(merc, list_prof or merc.OperationProfession)
                                  if operation == "TreatWounds" and IsPatient(merc) and IsDoctor(merc) then
                                    if list_prof == "Doctor" then
                                      cost = operation_preset:GetOperationCost(merc, "Patient")
                                      for _, cst in ipairs(operation_preset:GetOperationCost(merc, "Doctor")) do
                                        table.insert(cost, cst)
                                      end
                                    elseif list_prof == "Patient" then
                                      local count = SectorOperationCountPatients(sector.Id, merc.session_id)
                                      if count == 0 then
                                        cost = operation_preset:GetOperationCost(merc, "Patient")
                                        for _, cst in ipairs(operation_preset:GetOperationCost(merc, "Doctor")) do
                                          table.insert(cost, cst)
                                        end
                                      end
                                    end
                                  end
                                  local cost_txt = GetOperationCostText(cost, "img_tag", true, "no_name")
                                  local warning_txt = T({
                                    399236738734,
                                    "Are you sure you want to release <DisplayName> from Operation <activity>?",
                                    merc,
                                    activity = operation_preset.display_name
                                  })
                                  local restore_txt
                                  if cost_txt ~= "" then
                                    restore_txt = T({
                                      548330460792,
                                      "You will be refunded <cost>.",
                                      cost = cost_txt
                                    })
                                  end
                                  self:SetSelected(true)
                                  local dlg = CreateQuestionBox(nil, T(824112417429, "Warning"), restore_txt and T({
                                    653728009504,
                                    [[
<warning>
<restore>]],
                                    warning = warning_txt,
                                    restore = restore_txt
                                  }) or warning_txt, T(689884995409, "Yes"), T(782927325160, "No"))
                                  dlg:SetModal()
                                  if dlg:Wait() == "ok" then
                                    if operation == "TreatWounds" then
                                      NetSyncEvent("MercRemoveOperationTreatWounds", merc.session_id, list_prof)
                                    else
                                      NetSyncEvent("MercSetOperation", merc.session_id, "Idle")
                                    end
                                    NetSyncEvent("RestoreOperationCost", merc.session_id, cost)
                                    local d = host.idBase.idMain
                                    if IsCraftOperation(operation) then
                                      NetSyncEvent("RecalcOperationETAs", sector.Id, operation, true)
                                      SectorOperation_ItemsUpdateItemLists(d)
                                    end
                                  else
                                    self:SetSelected(false)
                                  end
                                end)
                              else
                                asert(false, "Assign mercs")
                              end
                              return "break"
                            end
                          })
                        })
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XZuluScroll",
                    "Id",
                    "idScrollbar",
                    "Margins",
                    box(0, 10, 0, 0),
                    "Dock",
                    "right",
                    "HAlign",
                    "right",
                    "Transparency",
                    125,
                    "Target",
                    "idPortraitsList",
                    "AutoHide",
                    true
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "no mercs text",
                    "__class",
                    "XText",
                    "Id",
                    "idNotAvailableMercs",
                    "Margins",
                    box(0, 180, 0, 0),
                    "HAlign",
                    "left",
                    "VAlign",
                    "bottom",
                    "LayoutMethod",
                    "HList",
                    "FoldWhenHidden",
                    true,
                    "TextStyle",
                    "PDAActivityAssignDlgDescriptionRed",
                    "Translate",
                    true,
                    "Text",
                    T(896654085057, "\208\144ll mercs are assigned to other Operations. "),
                    "TextVAlign",
                    "bottom"
                  })
                })
              }),
              PlaceObj("XTemplateWindow", {
                "comment",
                "militia section",
                "__condition",
                function(parent, context)
                  return context.operation == "MilitiaTraining" and not context.list_as_prof
                end,
                "__class",
                "XContextWindow",
                "VAlign",
                "top",
                "LayoutMethod",
                "VList",
                "Clip",
                "parent & self"
              }, {
                PlaceObj("XTemplateWindow", {
                  "comment",
                  "section title",
                  "LayoutMethod",
                  "VList"
                }, {
                  PlaceObj("XTemplateWindow", {
                    "LayoutMethod",
                    "HList",
                    "LayoutHSpacing",
                    20
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "active title",
                      "__class",
                      "XText",
                      "VAlign",
                      "top",
                      "MinWidth",
                      350,
                      "MaxWidth",
                      350,
                      "LayoutMethod",
                      "HList",
                      "FoldWhenHidden",
                      true,
                      "HandleMouse",
                      false,
                      "TextStyle",
                      "PDAActivitiesSubTitleDark",
                      "Translate",
                      true,
                      "Text",
                      T(931984554766, "Active Militia"),
                      "HideOnEmpty",
                      true,
                      "TextVAlign",
                      "center"
                    }),
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "training title",
                      "__class",
                      "XText",
                      "VAlign",
                      "top",
                      "MinWidth",
                      350,
                      "MaxWidth",
                      350,
                      "LayoutMethod",
                      "HList",
                      "FoldWhenHidden",
                      true,
                      "HandleMouse",
                      false,
                      "TextStyle",
                      "PDAActivitiesSubTitleDark",
                      "Translate",
                      true,
                      "Text",
                      T(355331223587, "In Training"),
                      "HideOnEmpty",
                      true,
                      "TextVAlign",
                      "center"
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "VAlign",
                    "top",
                    "MinHeight",
                    2,
                    "MaxHeight",
                    2,
                    "Background",
                    RGBA(124, 130, 96, 255),
                    "Transparency",
                    160
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XContextWindow",
                  "IdNode",
                  true,
                  "ContextUpdateOnOpen",
                  true,
                  "OnContextUpdate",
                  function(self, context, ...)
                    local dlg_context = GetDialog(self):GetContext()
                    local to_add_mercs = GetOperationProfessionals(dlg_context.Id, "Idle")
                    local empty = false
                    if #to_add_mercs <= 0 then
                      for _, item in ipairs(context.mercs) do
                        if item.prof ~= "Militia" and item.class == "empty" then
                          empty = true
                        end
                      end
                    end
                    if empty then
                      local playerMercs = GetPlayerMercsInSector(dlg_context.Id)
                      if #playerMercs == #GetOperationProfessionals(dlg_context.Id, context.operation) then
                        empty = false
                      end
                    end
                    self.idNotAvailableMercs:SetVisible(empty)
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "LayoutMethod",
                    "HList",
                    "LayoutHSpacing",
                    20
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "active",
                      "__class",
                      "XContextWindow",
                      "MinWidth",
                      350,
                      "MaxWidth",
                      350,
                      "LayoutMethod",
                      "HWrap",
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
                          return table.ifilter(context.mercs, function(idx, m)
                            return not m.in_progress
                          end)
                        end,
                        "__context",
                        function(parent, context, item, i, n)
                          return {
                            list_as_prof = context.list_as_prof,
                            merc = item,
                            click = false,
                            operation = context.operation
                          }
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                          rawset(child, "slot_idx", i)
                        end
                      }, {
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "OperationMerc"
                        })
                      })
                    }),
                    PlaceObj("XTemplateWindow", {
                      "comment",
                      "training",
                      "__class",
                      "XContextWindow",
                      "MinWidth",
                      350,
                      "MaxWidth",
                      350,
                      "LayoutMethod",
                      "HWrap",
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
                          return table.ifilter(context.mercs, function(idx, m)
                            return not not m.in_progress
                          end)
                        end,
                        "__context",
                        function(parent, context, item, i, n)
                          return {
                            list_as_prof = context.list_as_prof,
                            merc = item,
                            click = false,
                            operation = context.operation
                          }
                        end,
                        "run_after",
                        function(child, context, item, i, n, last)
                          rawset(child, "slot_idx", i)
                        end
                      }, {
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "OperationMerc"
                        })
                      })
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "comment",
                    "no mercs text",
                    "__class",
                    "XText",
                    "Id",
                    "idNotAvailableMercs",
                    "Margins",
                    box(0, 180, 0, 0),
                    "HAlign",
                    "left",
                    "VAlign",
                    "bottom",
                    "LayoutMethod",
                    "HList",
                    "FoldWhenHidden",
                    true,
                    "TextStyle",
                    "PDAActivityAssignDlgDescriptionRed",
                    "Translate",
                    true,
                    "Text",
                    T(896654085057, "\208\144ll mercs are assigned to other Operations. "),
                    "TextVAlign",
                    "bottom"
                  })
                })
              })
            })
          })
        })
      })
    })
  })
})
