PlaceObj("XTemplate", {
  __is_kind_of = "XContextWindow",
  group = "Zulu",
  id = "SectorOperationDescrUI",
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
      }, {
        PlaceObj("XTemplateWindow", {
          "__condition",
          function(parent, context)
            return not context.operation
          end,
          "__class",
          "XSquareWindow",
          "IdNode",
          true,
          "VAlign",
          "top",
          "MinWidth",
          54,
          "MinHeight",
          54,
          "MaxHeight",
          54,
          "FoldWhenHidden",
          true
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idSector",
            "HAlign",
            "center",
            "VAlign",
            "center",
            "Clip",
            false,
            "TextStyle",
            "PDAActivitiesSectorIdBig",
            "Translate",
            true,
            "TextHAlign",
            "center",
            "TextVAlign",
            "center"
          }),
          PlaceObj("XTemplateCode", {
            "run",
            function(self, parent, context)
              local sector = context.sector or GetDialog(parent).context
              if sector then
                local color, _, _, textColor = GetSectorControlColor(sector.Side)
                local text = textColor .. sector.Id .. "</color>"
                parent:SetBackground(color)
                parent.idSector:SetText(T({
                  764093693143,
                  "<SectorIdColored(id)>",
                  id = sector.Id
                }))
              end
            end
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return not context.operation
        end,
        "MinWidth",
        10,
        "MaxWidth",
        10,
        "FoldWhenHidden",
        true
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XContextWindow",
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
          local id = context.operation
          local operation = type(id) == "string" and SectorOperations[id] or id
          if context.operation then
            local c_title = self:ResolveId("idTitle")
            local c_subtitle = self:ResolveId("idSubtitle")
            c_title:SetText(operation.display_name)
            c_subtitle:SetText(operation.sub_title or "")
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
          T(502856071518, "Operations"),
          "TextVAlign",
          "center"
        }),
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idSubtitle",
          "Margins",
          box(0, 4, 0, 0),
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
        }, {
          PlaceObj("XTemplateCode", {
            "run",
            function(self, parent, context)
              if IsKindOf(context, "SectorOperation") then
                parent:SetText(context.sub_title)
              else
                local sector = context.sector
                local operations = GetOperationsInSector(sector.Id)
                local max = #operations
                local num = table.count(operations, "enabled", true)
                parent:SetText(T({
                  992386523035,
                  "AVAILABLE <count>/<max>",
                  count = num,
                  max = max
                }))
              end
            end
          })
        })
      })
    }),
    PlaceObj("XTemplateGroup", {
      "__context",
      function(parent, context)
        return GetCurrentResourcesContext(context.operation, context.sector)
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "resources",
        "__condition",
        function(parent, context)
          return next(context)
        end,
        "__class",
        "XContextWindow",
        "Margins",
        box(0, 18, 0, 0),
        "Dock",
        "top",
        "LayoutMethod",
        "HList",
        "LayoutHSpacing",
        20
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "available resources",
          "MinWidth",
          366,
          "MinHeight",
          30,
          "MaxWidth",
          366,
          "MaxHeight",
          30,
          "Background",
          RGBA(88, 92, 68, 128)
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
                  self.idImg:SetImage(context.icon)
                end
              }, {
                PlaceObj("XTemplateWindow", {
                  "LayoutMethod",
                  "VList"
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
                      "VAlign",
                      "center",
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
                      "VAlign",
                      "center",
                      "ImageColor",
                      RGBA(124, 130, 96, 255)
                    })
                  }),
                  PlaceObj("XTemplateWindow", {
                    "__class",
                    "XText",
                    "Id",
                    "idCost",
                    "Padding",
                    box(2, -5, 4, 2),
                    "HAlign",
                    "left",
                    "TextStyle",
                    "ActivityDescrRed",
                    "Translate",
                    true
                  })
                })
              })
            })
          })
        }),
        PlaceObj("XTemplateWindow", {
          "comment",
          "time",
          "__class",
          "XContextWindow",
          "LayoutMethod",
          "HList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XText",
            "Id",
            "idTimeCost",
            "Margins",
            box(0, 0, 0, 14),
            "VAlign",
            "center",
            "Visible",
            false,
            "FoldWhenHidden",
            true,
            "TextStyle",
            "ActivityDescrRed",
            "Translate",
            true
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "comment",
        "line",
        "__condition",
        function(parent, context)
          return not next(context)
        end,
        "__class",
        "XFrame",
        "Dock",
        "top",
        "VAlign",
        "top",
        "Image",
        "UI/PDA/separate_line_vertical",
        "FrameBox",
        box(2, 0, 2, 0),
        "SqueezeY",
        false
      })
    }),
    PlaceObj("XTemplateTemplate", {
      "comment",
      "table",
      "__condition",
      function(parent, context)
        return not context.operation or context.operation.id ~= "TrainMercs" and context.operation.id ~= "CraftAmmo" and context.operation.id ~= "CraftExplosives"
      end,
      "__template",
      "SectorOperationStatsTableUI"
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "SectorOperationTrainMercsDescritionUI"
    }),
    PlaceObj("XTemplateTemplate", {
      "__condition",
      function(parent, context)
        return GetDialog(parent).Mode == "pick_item"
      end,
      "__template",
      "SectorOperationCraftResTableUI",
      "Margins",
      box(0, 0, 0, 10)
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XScrollArea",
      "Id",
      "idScrollArea",
      "IdNode",
      false,
      "Margins",
      box(0, 18, 0, 10),
      "Dock",
      "box",
      "VAlign",
      "top",
      "MaxWidth",
      366,
      "LayoutMethod",
      "VList",
      "VScroll",
      "idScrollbar"
    }, {
      PlaceObj("XTemplateWindow", {
        "__condition",
        function(parent, context)
          return context and context.operation and context.sector and context.sector.operations_prev_data and context.sector.operations_prev_data.prev_start_time and GetDialog(parent).Mode ~= "pick_item"
        end,
        "__class",
        "XText",
        "Id",
        "idConfirmation",
        "Margins",
        box(0, 0, 0, 18),
        "MaxWidth",
        366,
        "FoldWhenHidden",
        true,
        "HandleMouse",
        false,
        "TextStyle",
        "PDAActivityDescription",
        "Translate",
        true,
        "Text",
        T(176366347160, "<GameColorI>If confirmed, the operation will restart with the new parameters. Resources and end time may change based on this.</GameColorI>"),
        "HideOnEmpty",
        true
      }),
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return context.operation
        end,
        "__class",
        "XText",
        "Id",
        "idOperationDescrText",
        "HandleMouse",
        false,
        "TextStyle",
        "PDAActivityDescription",
        "Translate",
        true,
        "Text",
        T(425929996411, "<description>"),
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
        "AutoHide",
        true
      })
    })
  })
})
