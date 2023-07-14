PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "SectorOperationSelectMercProgressUI",
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
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return GetOperationMercsListContext(context, GetActionsHost(parent, true).mode_param, "in progress")
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
            "LayoutMethod",
            "VList",
            "LayoutVSpacing",
            18
          }, {
            PlaceObj("XTemplateForEach", {
              "comment",
              "operation section",
              "__context",
              function(parent, context, item, i, n)
                return item
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
                  "ContextUpdateOnOpen",
                  true
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
                        "condition",
                        function(parent, context, item, i)
                          return item.class ~= "empty" and item.class ~= "free_slot"
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
                          context.click = false
                          child:SetContext(context)
                        end
                      }, {
                        PlaceObj("XTemplateTemplate", {
                          "__template",
                          "OperationMerc"
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "SetupStyle(self, rollover)",
                            "func",
                            function(self, rollover)
                              local class = self.context.merc.class
                              local is_militia = self.context.merc.prof == "Militia"
                              if class == "free_space" then
                                return
                              end
                              local noClr = const.PDAUIColors.noClr
                              local selectedColored = const.HUDUIColors.selectedColored
                              local defaultColor = GameColors.B
                              if class ~= "empty" or is_militia then
                                self.idMerc:SetImage("")
                                self.idBottomPart:SetBackground(defaultColor)
                                self.idBottomPart:SetBackgroundRectGlowColor(defaultColor)
                                self.idMerc:SetBackground(noClr)
                                self.idPortrait:SetDesaturation(255)
                                self.idPortrait:SetTransparency(140)
                                if not is_militia then
                                  self.idCost:SetTextStyle("PDAActivityMercNameCard_Text_Unselected")
                                  self.idEta:SetTextStyle("PDAActivityMercNameCard_Text_Unselected")
                                end
                                self.idStat:SetVisible(false)
                                self.idStatVal:SetVisible(false)
                              end
                              local name = self:ResolveId("idName")
                              if name then
                                self.idName:SetTextStyle("PDAActivityMercNameCard_Light")
                              end
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
                      T(284267057178, "Active Militia"),
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
                      T(740578488287, "In Training"),
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
                  true
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
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "SetupStyle(self, rollover)",
                            "func",
                            function(self, rollover)
                              local class = self.context.merc.class
                              local is_militia = self.context.merc.prof == "Militia"
                              if class == "free_space" then
                                return
                              end
                              local noClr = const.PDAUIColors.noClr
                              local selectedColored = const.HUDUIColors.selectedColored
                              local defaultColor = GameColors.B
                              if class ~= "empty" or is_militia then
                                self.idMerc:SetImage("")
                                self.idBottomPart:SetBackground(defaultColor)
                                self.idBottomPart:SetBackgroundRectGlowColor(defaultColor)
                                self.idMerc:SetBackground(noClr)
                                self.idPortrait:SetDesaturation(255)
                                self.idPortrait:SetTransparency(140)
                                self.idStat:SetVisible(false)
                                self.idStatVal:SetVisible(false)
                              end
                              local name = self:ResolveId("idName")
                              if name then
                                self.idName:SetTextStyle("PDAActivityMercNameCard_Light")
                              end
                            end
                          })
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
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "SetupStyle(self, rollover)",
                            "func",
                            function(self, rollover)
                              local class = self.context.merc.class
                              local is_militia = self.context.merc.prof == "Militia"
                              if class == "free_space" then
                                return
                              end
                              local noClr = const.PDAUIColors.noClr
                              local selectedColored = const.HUDUIColors.selectedColored
                              local defaultColor = GameColors.B
                              if class ~= "empty" or is_militia then
                                self.idMerc:SetImage("")
                                self.idBottomPart:SetBackground(defaultColor)
                                self.idBottomPart:SetBackgroundRectGlowColor(defaultColor)
                                self.idMerc:SetBackground(noClr)
                                self.idPortrait:SetDesaturation(255)
                                self.idPortrait:SetTransparency(140)
                                self.idStat:SetVisible(false)
                                self.idStatVal:SetVisible(false)
                              end
                              local name = self:ResolveId("idName")
                              if name then
                                self.idName:SetTextStyle("PDAActivityMercNameCard_Light")
                              end
                            end
                          })
                        })
                      })
                    })
                  })
                })
              })
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "repair items",
            "__condition",
            function(parent, context)
              local operation = not context.operation and context[1] and context[1].operation
              return IsCraftOperation(operation)
            end,
            "LayoutMethod",
            "VList"
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "items queue",
              "VAlign",
              "top",
              "LayoutMethod",
              "VList",
              "Clip",
              "parent & self"
            }, {
              PlaceObj("XTemplateWindow", {
                "comment",
                "items title",
                "LayoutMethod",
                "VList"
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XText",
                  "Id",
                  "idQueuedText",
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
                  "Text",
                  T(417907734731, "Queued Items"),
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
                "Margins",
                box(0, 10, 0, 0),
                "ContextUpdateOnOpen",
                true,
                "OnContextUpdate",
                function(self, context, ...)
                  XContextWindow.OnContextUpdate(self, context, ...)
                  local node = self.parent:ResolveId("node")
                  local sector_id = GetDialog(self.parent).context.Id
                  local operation_id = context[1].operation
                  local itm_res_icon = SectorOperationResouces.Parts.icon
                  local mercs = GetOperationProfessionals(sector_id, operation_id)
                  local time = next(mercs) and mercs[1].OperationInitialETA or 0
                  if time < 0 then
                    time = 0
                  end
                  node.idQueuedText:SetText(T({
                    539301898339,
                    "Queued Items<right><GameColorF><res_icon> <res>  <image UI/SectorOperations/T_Icon_Activity_Resting 1500 130 128 120><timeDuration(time)>",
                    res_icon = "<image " .. itm_res_icon .. " 2500 130 128 120>",
                    res = SectorOperation_ItemsCalcRes(sector_id, operation_id),
                    time = time
                  }))
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XDragContextWindow",
                  "Id",
                  "idList",
                  "Margins",
                  box(0, 10, 0, 0),
                  "GridStretchX",
                  false,
                  "GridStretchY",
                  false,
                  "LayoutMethod",
                  "HWrap",
                  "LayoutHSpacing",
                  6,
                  "LayoutVSpacing",
                  10,
                  "ContextUpdateOnOpen",
                  false,
                  "disable_drag",
                  true
                }, {
                  PlaceObj("XTemplateFunc", {
                    "name",
                    "IsDropTarget(self,drag_win, pt, source)",
                    "func",
                    function(self, drag_win, pt, source)
                      return false
                    end
                  }),
                  PlaceObj("XTemplateForEach", {
                    "comment",
                    "item",
                    "array",
                    function(parent, context)
                      local sector = GetDialog(parent).context.Id
                      return SectorOperationItems_GetItemsQueue(sector, context[1].operation) or empty_table
                    end,
                    "__context",
                    function(parent, context, item, i, n)
                      return SectorOperation_FindItemDef(item)
                    end,
                    "run_after",
                    function(child, context, item, i, n, last)
                      rawset(child, "slot_idx", i)
                      local ctx = SectorOperation_FindItemDef(item)
                      child:SetContext(ctx)
                      rawset(child.idItem, "slot", item.slot)
                      child.idItem:SetContext(ctx)
                      child.idOperationProgressBar:SetVisible(i == 1)
                      child.idOperationProgressBar:SetContext(ctx)
                      rawset(child.idItem, "item", item)
                      local not_repair = child.parent.context[1].operation ~= "RepairItems"
                      child.idItem.idText:SetVisible(not_repair)
                      child.parent:SetChildrenHandleMouse(not_repair)
                      child.idItem.idText:SetText(T({
                        641971138327,
                        "<style InventoryItemsCountMax><amount></style>",
                        amount = item.amount
                      }))
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContextWindow",
                      "IdNode",
                      true,
                      "HAlign",
                      "left"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XFrame",
                        "IdNode",
                        false,
                        "HAlign",
                        "left",
                        "BorderColor",
                        RGBA(255, 255, 255, 0),
                        "Background",
                        RGBA(255, 255, 255, 0),
                        "BackgroundRectGlowColor",
                        RGBA(255, 255, 255, 0),
                        "FocusedBorderColor",
                        RGBA(255, 255, 255, 0),
                        "FocusedBackground",
                        RGBA(255, 255, 255, 0),
                        "DisabledBorderColor",
                        RGBA(255, 255, 255, 0)
                      }, {
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XActivityItem",
                          "Id",
                          "idItem",
                          "IdNode",
                          false,
                          "HAlign",
                          "left",
                          "VAlign",
                          "center",
                          "OnLayoutComplete",
                          function(self)
                            self.idText:SetPadding(box(2, 2, 2, 2))
                            self.idTopRightText:SetPadding(box(2, 2, 2, 2))
                          end,
                          "UniformColumnWidth",
                          true,
                          "UniformRowHeight",
                          true
                        }, {
                          PlaceObj("XTemplateWindow", {
                            "__class",
                            "OperationProgressBar",
                            "Id",
                            "idOperationProgressBar",
                            "IdNode",
                            false,
                            "HAlign",
                            "stretch",
                            "VAlign",
                            "bottom",
                            "MinHeight",
                            5,
                            "MaxHeight",
                            5,
                            "Visible",
                            false,
                            "FoldWhenHidden",
                            true,
                            "SqueezeX",
                            false,
                            "OnContextUpdate",
                            function(self, context, ...)
                              if not context or not context.repair_progress then
                                self:SetVisible(false)
                                return
                              end
                              local max_condition = context:GetMaxCondition()
                              local progress = MulDivRound(context.Condition, 100, max_condition)
                              if progress <= 0 or max_condition <= progress then
                                self:SetVisible(false)
                                return
                              end
                              if progress ~= 0 then
                                self:SetProgress(progress)
                              end
                            end
                          }),
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "IsDropTarget(self,drag_win, pt, source)",
                            "func",
                            function(self, drag_win, pt, source)
                              return false
                            end
                          }),
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "Open(self, ...)",
                            "func",
                            function(self, ...)
                              local node = self:ResolveId("node")
                              XInventoryItem.Open(self, ...)
                              self.idItemPad:SetImage(false)
                              self.idItemPad:SetMinWidth(self:GetMinWidth())
                              self.idItemPad:SetMaxWidth(self:GetMaxWidth())
                              self.idItemPad:SetBackground(GameColors.B)
                              node.idOperationProgressBar:SetMargins(box(0, 0, 0, 0))
                              self:SetTransparency(140)
                              self.idItemImg:SetDesaturation(255)
                              self.idItemImg:SetTransparency(140)
                              self.idText:SetPadding(box(2, 2, 2, 2))
                              self.idTopRightText:SetPadding(box(2, 2, 2, 2))
                            end
                          })
                        })
                      })
                    })
                  }),
                  PlaceObj("XTemplateForEach", {
                    "comment",
                    "item empty",
                    "array",
                    function(parent, context)
                      local sector = GetDialog(parent).context.Id
                      local full_table = SectorOperationItems_GetItemsQueue(sector, context[1].operation) or empty_table
                      local to_return = {}
                      local count = 9
                      for i, itm_data in ipairs(full_table) do
                        local itm = SectorOperation_FindItemDef(itm_data)
                        count = count - (itm.LargeItem and 2 or 1)
                      end
                      for i = 1, count do
                        to_return[i] = i
                      end
                      return to_return
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XContextWindow",
                      "IdNode",
                      true,
                      "HAlign",
                      "left"
                    }, {
                      PlaceObj("XTemplateWindow", {
                        "__class",
                        "XFrame",
                        "IdNode",
                        false,
                        "HAlign",
                        "left",
                        "BorderColor",
                        RGBA(255, 255, 255, 0),
                        "Background",
                        RGBA(255, 255, 255, 0),
                        "BackgroundRectGlowColor",
                        RGBA(255, 255, 255, 0),
                        "FocusedBorderColor",
                        RGBA(255, 255, 255, 0),
                        "FocusedBackground",
                        RGBA(255, 255, 255, 0),
                        "DisabledBorderColor",
                        RGBA(255, 255, 255, 0)
                      }, {
                        PlaceObj("XTemplateWindow", {
                          "__class",
                          "XOperationItemTile",
                          "Id",
                          "idItem",
                          "IdNode",
                          false,
                          "HAlign",
                          "left",
                          "VAlign",
                          "center",
                          "MinWidth",
                          74,
                          "MinHeight",
                          74,
                          "MaxWidth",
                          72,
                          "MaxHeight",
                          72,
                          "UniformColumnWidth",
                          true,
                          "UniformRowHeight",
                          true
                        }, {
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "IsDropTarget(self,drag_win, pt, source)",
                            "func",
                            function(self, drag_win, pt, source)
                              return false
                            end
                          }),
                          PlaceObj("XTemplateFunc", {
                            "name",
                            "Open(self, ...)",
                            "func",
                            function(self, ...)
                              local node = self:ResolveId("node")
                              XInventoryItem.Open(self, ...)
                              self.idBackImage:SetImage(false)
                              self.idBackImage:SetMinWidth(self:GetMinWidth())
                              self.idBackImage:SetMaxWidth(self:GetMaxWidth())
                              self.idBackImage:SetBackground(GameColors.B)
                            end
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
      })
    })
  })
})
