PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "SectorOperationSelectItemsUI",
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
    PlaceObj("XTemplateFunc", {
      "name",
      "OnKillFocus(self)",
      "func",
      function(self)
        if DragSource then
          DragSource:InternalDragStop(terminal.GetMousePos())
        end
        XDialog.OnKillFocus(self)
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
                  T(714594754425, "Queued Items"),
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
                "XContentTemplate",
                "Id",
                "idQueueList",
                "Margins",
                box(0, 10, 0, 0),
                "OnContextUpdate",
                function(self, context, ...)
                  XContextWindow.OnContextUpdate(self, context, ...)
                  local node = self.parent:ResolveId("node")
                  local sector = GetDialog(self.parent).context
                  local sector_id = sector.Id
                  local operation_id = context[1].operation
                  local itm_res_icon = SectorOperationResouces.Parts.icon
                  local mercs = GetOperationProfessionals(sector_id, operation_id)
                  local time = next(mercs) and mercs[1].OperationInitialETA or 0
                  if time < 0 then
                    time = 0
                  end
                  local res_count = SectorOperation_ItemsCalcRes(sector_id, operation_id)
                  node.idQueuedText:SetText(T({
                    539301898339,
                    "Queued Items<right><GameColorF><res_icon> <res>  <image UI/SectorOperations/T_Icon_Activity_Resting 1500 130 128 120><timeDuration(time)>",
                    res_icon = "<image " .. itm_res_icon .. " 2500 130 128 120>",
                    res = res_count,
                    time = time
                  }))
                  local cur = GetSectorOperationResource(sector, "Parts")
                  node.idNotRes:SetVisible(res_count > cur)
                  local timeLeft = time and Game.CampaignTime + time
                  AddTimelineEvent("activity-temp", timeLeft, "operation", {operationId = operation_id, sectorId = sector_id})
                end
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "Open(self)",
                  "func",
                  function(self)
                    XContentTemplate.Open(self)
                    self:OnContextUpdate(self.context, true)
                  end
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XDragContextWindow",
                  "Id",
                  "idQueue",
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
                  "ChildrenHandleMouse",
                  true,
                  "ContextUpdateOnOpen",
                  false,
                  "slot_name",
                  "ItemsQueue"
                }, {
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
                      local not_repair = child.parent.context[1].operation ~= "RepairItems"
                      rawset(child.idItem, "slot", item.slot)
                      rawset(child.idItem, "item", item)
                      child.idItem:SetContext(ctx)
                      child.idOperationProgressBar:SetVisible(i == 1)
                      child.idOperationProgressBar:SetContext(ctx)
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
                          "RolloverTemplate",
                          "RolloverOperationCraftRecipe",
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
                          true,
                          "OnContextUpdate",
                          function(self, context, ...)
                            XActivityItem.OnContextUpdate(self, context, ...)
                            local node = self:ResolveId("node")
                            local not_repair = node.parent.context[1].operation ~= "RepairItems"
                            self.idText:SetVisible(not_repair)
                            self.idText:SetText(T({
                              641971138327,
                              "<style InventoryItemsCountMax><amount></style>",
                              amount = self.item.amount
                            }))
                            if not_repair then
                              self:SetRolloverTitle(T({
                                412158497796,
                                "<amount> x <name>",
                                name = context.DisplayName,
                                amount = self.item.amount
                              }))
                              local recipe_id = self.item.recipe
                              local recipe = CraftOperationsRecipes[recipe_id]
                              local text
                              if context.Description and context.Description ~= "" then
                                text = {
                                  context.Description,
                                  T(521200788637, "Ingredients")
                                }
                              else
                                text = {
                                  T(521200788637, "Ingredients")
                                }
                              end
                              for _, ing in ipairs(recipe.Ingredients) do
                                text[#text + 1] = T({
                                  412158497796,
                                  "<amount> x <name>",
                                  amount = ing.amount,
                                  name = g_Classes[ing.item].DisplayName
                                })
                              end
                              self:SetRolloverText(table.concat(text, "\n"))
                            end
                          end
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
                          72,
                          "MinHeight",
                          72,
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
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "no mercs text",
              "__class",
              "XText",
              "Id",
              "idNotRes",
              "HAlign",
              "center",
              "VAlign",
              "bottom",
              "LayoutMethod",
              "HList",
              "Visible",
              false,
              "TextStyle",
              "PDAActivityAssignDlgDescriptionRed",
              "Translate",
              true,
              "Text",
              T(660038414565, "Not enough parts to finish"),
              "TextVAlign",
              "bottom"
            }),
            PlaceObj("XTemplateWindow", {
              "comment",
              "repair items",
              "Margins",
              box(0, -5, 0, 24),
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
                  "idRepairItems",
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
                  T(913464112067, "Damaged Gear"),
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
                "XContentTemplate",
                "Id",
                "idAllList",
                "Margins",
                box(0, 10, 0, 0),
                "OnContextUpdate",
                function(self, context, ...)
                  XContextWindow.OnContextUpdate(self, context, ...)
                  local node = self.parent:ResolveId("node")
                  local sector_id = GetDialog(self.parent).context.Id
                  local operation_id = context[1].operation
                  local count = #(SectorOperationItems_GetAllItems(sector_id, operation_id) or empty_table)
                  local text = T({
                    948764566986,
                    "Damaged Gear<right><GameColorF><count>",
                    count = count
                  })
                  if operation_id == "CraftAmmo" or operation_id == "CraftExplosives" then
                    text = T({
                      215483657916,
                      "Recipes<right><GameColorF><count>",
                      count = count
                    })
                  end
                  node.idRepairItems:SetText(text)
                end
              }, {
                PlaceObj("XTemplateFunc", {
                  "name",
                  "Open(self)",
                  "func",
                  function(self)
                    XContentTemplate.Open(self)
                    self:OnContextUpdate(self.context, true)
                  end
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XScrollArea",
                  "Id",
                  "idItemsList",
                  "IdNode",
                  false,
                  "Margins",
                  box(0, 10, 0, 0),
                  "VAlign",
                  "top",
                  "MinWidth",
                  800,
                  "MinHeight",
                  260,
                  "MaxWidth",
                  800,
                  "MaxHeight",
                  260,
                  "UniformColumnWidth",
                  true,
                  "UniformRowHeight",
                  true,
                  "Clip",
                  "self",
                  "VScroll",
                  "idScrollbarAll",
                  "MouseWheelStep",
                  130
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XDragContextWindow",
                    "Id",
                    "idAllItems",
                    "HAlign",
                    "left",
                    "MinWidth",
                    720,
                    "MinHeight",
                    260,
                    "MaxWidth",
                    720,
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
                    "ChildrenHandleMouse",
                    true,
                    "ContextUpdateOnOpen",
                    false,
                    "slot_name",
                    "AllItems"
                  }, {
                    PlaceObj("XTemplateForEach", {
                      "comment",
                      "item",
                      "array",
                      function(parent, context)
                        local sector = GetDialog(parent).context.Id
                        return SectorOperationItems_GetAllItems(sector, context[1].operation) or empty_table
                      end,
                      "condition",
                      function(parent, context, item, i)
                        return not item.hidden
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
                        local not_repair = child.parent.context[1].operation ~= "RepairItems"
                        rawset(child.idItem, "slot", item.slot)
                        rawset(child.idItem, "item", item)
                        if not_repair then
                          child.idItem:SetEnabled(item.enabled)
                          if not item.enabled then
                            child.idItem.idItemPad:SetEnabled(true)
                            child.idItem:SetTransparency(140)
                            child.idItem.idItemImg:SetVisible(true)
                            child.idItem.idItemImg:SetDesaturation(255)
                            child.idItem.idItemImg:SetTransparency(140)
                          end
                        end
                        child.idItem:SetContext(ctx)
                        child.idOperationProgressBar:SetVisible(false)
                        child.idOperationProgressBar:SetContext(ctx)
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
                            "RolloverTemplate",
                            "RolloverOperationCraftRecipe",
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
                            true,
                            "OnContextUpdate",
                            function(self, context, ...)
                              XActivityItem.OnContextUpdate(self, context, ...)
                              local node = self:ResolveId("node")
                              local is_craft = node.parent.context[1].operation ~= "RepairItems"
                              if not is_craft then
                                return
                              end
                              self.idText:SetVisible(is_craft)
                              self.idText:SetText(T({
                                641971138327,
                                "<style InventoryItemsCountMax><amount></style>",
                                amount = self.item.amount
                              }))
                              self:SetRolloverTitle(T({
                                412158497796,
                                "<amount> x <name>",
                                name = context.DisplayName,
                                amount = self.item.amount
                              }))
                              local recipe_id = self.item.recipe
                              local recipe = CraftOperationsRecipes[recipe_id]
                              local text
                              if context.Description and context.Description ~= "" then
                                text = {
                                  context.Description,
                                  T(521200788637, "Ingredients")
                                }
                              else
                                text = {
                                  T(521200788637, "Ingredients")
                                }
                              end
                              for _, ing in ipairs(recipe.Ingredients) do
                                text[#text + 1] = T({
                                  412158497796,
                                  "<amount> x <name>",
                                  amount = ing.amount,
                                  name = g_Classes[ing.item].DisplayName
                                })
                              end
                              self:SetRolloverText(table.concat(text, "\n"))
                            end
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
                                  self:SetVisible(false)
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
                                self.idText:SetPadding(box(2, 2, 2, 2))
                                self.idTopRightText:SetPadding(box(2, 2, 2, 2))
                              end
                            })
                          })
                        })
                      })
                    })
                  })
                }),
                PlaceObj("XTemplateWindow", {
                  "__class",
                  "XZuluScroll",
                  "Id",
                  "idScrollbarAll",
                  "Margins",
                  box(0, 10, 0, 0),
                  "Dock",
                  "right",
                  "HAlign",
                  "right",
                  "ScaleModifier",
                  point(800, 800),
                  "Transparency",
                  125,
                  "Target",
                  "idItemsList",
                  "AutoHide",
                  true
                })
              })
            })
          })
        })
      })
    })
  })
})
