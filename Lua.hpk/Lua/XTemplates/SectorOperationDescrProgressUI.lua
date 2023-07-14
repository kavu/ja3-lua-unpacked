PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu",
  id = "SectorOperationDescrProgressUI",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XContextWindow",
    "Id",
    "idOperationDescr",
    "Margins",
    box(26, 25, 26, 16),
    "Dock",
    "left",
    "MinWidth",
    366,
    "MaxWidth",
    366,
    "LayoutMethod",
    "VList"
  }, {
    PlaceObj("XTemplateWindow", {
      "comment",
      "title",
      "Dock",
      "top",
      "LayoutMethod",
      "HList"
    }, {
      PlaceObj("XTemplateWindow", {
        "Padding",
        box(2, 2, 2, 2)
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextWindow",
        "IdNode",
        true,
        "Margins",
        box(0, -10, 0, 0),
        "LayoutMethod",
        "VList",
        "LayoutVSpacing",
        -10,
        "UseClipBox",
        false,
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local sector = context.sector
          local operation = context.operation
          local mercs = GetOperationProfessionals(sector.Id, operation.id)
          local c_title = self.idTitle
          self.idTitle:SetText(operation.display_name)
          self.idSubtitle:SetText(operation.progress_sub_title and operation.progress_sub_title ~= "" and operation.progress_sub_title or T({
            250567545113,
            "in progress",
            operation
          }))
          self.idTime:SetVisible(next(mercs))
          if next(mercs) then
            local left_time = GetOperationTimeLeft(mercs[1], operation.id, {
              mercs = mercs,
              prediction = true,
              all = true
            })
            self.idTime:SetText(T({
              795605774721,
              " <timeDuration(left_time)>",
              left_time = left_time
            }))
          end
          if operation.id == "TrainMercs" then
            local stat = sector.training_stat
            local prop_meta = table.find_value(UnitPropertiesStats:GetProperties(), "id", stat)
            local stat_name = prop_meta.name
            self.idSubtitle:SetText(T({
              273655031960,
              "Training <stat>",
              stat = stat_name
            }))
          end
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idTitle",
          "HAlign",
          "left",
          "VAlign",
          "center",
          "Clip",
          false,
          "UseClipBox",
          false,
          "TextStyle",
          "PDAActivitiesTitle",
          "Translate",
          true,
          "Text",
          T(326409416767, "Operations"),
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "MinWidth",
          366,
          "MaxWidth",
          366
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idSubtitle",
            "Margins",
            box(0, 4, 0, 0),
            "HAlign",
            "left",
            "VAlign",
            "top",
            "Clip",
            false,
            "UseClipBox",
            false,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "PDAActivitiesSubTitle",
            "Translate",
            true,
            "HideOnEmpty",
            true
          }),
          PlaceObj("XTemplateWindow", {
            "HAlign",
            "right",
            "VAlign",
            "top",
            "LayoutMethod",
            "HList"
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "resources",
              "__context",
              function(parent, context)
                local operation_id = context.operation.id
                local sector_id = context.sector.Id
                local mercs = GetOperationProfessionals(sector_id, operation_id)
                local costs = {}
                costs = GetOperationCostsProcessed(mercs, operation_id)
                if operation_id == "RepairItems" then
                  costs[#costs + 1] = {
                    {
                      resource = "Parts",
                      value = SectorOperation_ItemsCalcRes(sector_id, operation_id)
                    }
                  }
                end
                if operation_id == "CraftAmmo" or operation_id == "CraftExplosives" then
                  costs[#costs + 1] = {
                    {
                      resource = "Parts",
                      value = SectorOperation_ItemsCalcRes(sector_id, operation_id)
                    }
                  }
                end
                local combinedCosts = CombineOperationCosts(costs)
                return combinedCosts
              end,
              "__condition",
              function(parent, context)
                return next(context)
              end,
              "__class",
              "XContextWindow",
              "Margins",
              box(0, 0, 10, 0),
              "LayoutMethod",
              "HList",
              "LayoutHSpacing",
              10
            }, {
              PlaceObj("XTemplateWindow", {
                "Margins",
                box(10, 0, 0, 0),
                "LayoutMethod",
                "HList",
                "LayoutHSpacing",
                20
              }, {
                PlaceObj("XTemplateForEach", {
                  "comment",
                  "item",
                  "__context",
                  function(parent, context, item, i, n)
                    return item
                  end,
                  "run_after",
                  function(child, context, item, i, n, last)
                    child:SetContext(item)
                    if item.resource == "Money" then
                      return
                    end
                    local def = InventoryItemDefs[item.resource]
                    child.RolloverTitle = T({
                      def.DisplayName
                    })
                    child.RolloverText = T({
                      def.Description or def.AdditionalHint
                    })
                  end
                }, {
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XContextWindow",
                    "RolloverTemplate",
                    "RolloverGenericOperation",
                    "RolloverAnchor",
                    "bottom",
                    "IdNode",
                    true,
                    "HAlign",
                    "center",
                    "LayoutMethod",
                    "HList",
                    "HandleMouse",
                    true,
                    "ContextUpdateOnOpen",
                    true,
                    "OnContextUpdate",
                    function(self, context, ...)
                      self.idVal:SetText(Untranslated(context.value))
                      self.idImg:SetImage(SectorOperationResouces[context.resource].icon)
                    end
                  }, {
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XImage",
                      "Id",
                      "idImg",
                      "Margins",
                      box(0, 3, 0, 0),
                      "HAlign",
                      "left",
                      "VAlign",
                      "center",
                      "ImageColor",
                      RGBA(195, 189, 172, 255)
                    }),
                    PlaceObj("XTemplateWindow", {
                      "__class",
                      "XText",
                      "Id",
                      "idVal",
                      "Margins",
                      box(0, 4, 0, 0),
                      "VAlign",
                      "center",
                      "TextStyle",
                      "PDAActivitiesVal",
                      "Translate",
                      true
                    })
                  })
                })
              })
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XImage",
              "Margins",
              box(0, 3, 0, 0),
              "HAlign",
              "left",
              "VAlign",
              "center",
              "Image",
              "UI/SectorOperations/T_Icon_Activity_Resting",
              "ImageScale",
              point(500, 500),
              "ImageColor",
              RGBA(195, 189, 172, 255)
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idTime",
              "Margins",
              box(0, 4, 0, 0),
              "VAlign",
              "center",
              "Clip",
              false,
              "UseClipBox",
              false,
              "FoldWhenHidden",
              true,
              "TextStyle",
              "PDAActivitiesVal",
              "Translate",
              true
            })
          })
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "Dock",
      "top",
      "MinHeight",
      30,
      "MaxHeight",
      30,
      "Background",
      RGBA(32, 35, 47, 255)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "ZuluFrameProgress",
        "Id",
        "idOperationProgress",
        "Margins",
        box(4, 0, 4, 0),
        "VAlign",
        "center",
        "MinHeight",
        22,
        "MaxHeight",
        22,
        "Background",
        RGBA(32, 35, 47, 255),
        "OnContextUpdate",
        function(self, context, ...)
          if not context or not next(context) then
            return
          end
          local dlg_context = GetDialog(self).context
          local sector = dlg_context
          local progress
          local operation = context.operation
          if not operation then
            return
          end
          local max
          local mercs = GetOperationProfessionals(sector.Id, operation.id)
          max = operation:ProgressCompleteThreshold(next(mercs) and mercs[1], sector, "prediction")
          progress = 0 < max and MulDivRound(operation:ProgressCurrent(next(mercs) and mercs[1], sector, "prediction") or 0, 100, max) or 0
          if operation.id == "RepairItems" then
            max = next(mercs) and mercs[1].OperationInitialETA or 0
            if 0 < max then
              local current = max - GetOperationTimerETA(mercs[1])
              progress = MulDivRound(current or 0, 100, max)
            end
          end
          if progress and progress ~= 0 then
            self:SetProgress(progress)
            self:SetVisible(true)
          else
          end
        end,
        "MinProgressSize",
        3
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
    }),
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return context.operation.image
      end,
      "__class",
      "XContextImage",
      "Id",
      "idActivityImage",
      "Margins",
      box(0, 18, 0, 0),
      "Dock",
      "top",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "MinWidth",
      368,
      "MinHeight",
      260,
      "MaxWidth",
      368,
      "MaxHeight",
      260,
      "Background",
      RGBA(189, 171, 149, 255),
      "ImageFit",
      "largest",
      "ContextUpdateOnOpen",
      true,
      "OnContextUpdate",
      function(self, context, ...)
        self:SetImage(context)
      end
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XScrollArea",
      "Id",
      "idScrollArea",
      "IdNode",
      false,
      "Margins",
      box(0, 18, 0, 0),
      "Dock",
      "box",
      "LayoutMethod",
      "VList",
      "VScroll",
      "idScrollbar"
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return context.operation
        end,
        "__class",
        "XText",
        "Id",
        "idOperationDescrText",
        "VAlign",
        "top",
        "MinHeight",
        120,
        "MaxWidth",
        366,
        "HandleMouse",
        false,
        "TextStyle",
        "PDAActivityDescription",
        "Translate",
        true,
        "Text",
        T(680437447125, "<description>"),
        "Shorten",
        true
      }, {
        PlaceObj("XTemplateCode", {
          "run",
          function(self, parent, context)
            if not context then
              parent:SetText(T(803405378927, "You can assign mercs in this sector to different Operations like healing wounds, repairing items or training. Operations take time and often require additional resources in the sector. Some sectors offer special Operations and opportunities."))
            end
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XZuluScroll",
        "Id",
        "idScrollbar",
        "Margins",
        box(0, 0, 3, 0),
        "Dock",
        "right",
        "UseClipBox",
        false,
        "Target",
        "idScrollArea",
        "SnapToItems",
        true,
        "AutoHide",
        true
      })
    })
  })
})
