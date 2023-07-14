PlaceObj("XTemplate", {
  __is_kind_of = "XDialog",
  group = "Zulu",
  id = "SectorOperationsListUI",
  PlaceObj("XTemplateWindow", {
    "__context",
    function(parent, context)
      return {sector = context, operation = false}
    end,
    "__class",
    "XDialog",
    "Id",
    "idMain",
    "LayoutMethod",
    "HList",
    "HandleMouse",
    true,
    "HostInParent",
    true
  }, {
    PlaceObj("XTemplateFunc", {
      "name",
      "Open",
      "func",
      function(self, ...)
        XDialog.Open(self)
        self.idList:SetFocus(true)
      end
    }),
    PlaceObj("XTemplateTemplate", {
      "__template",
      "SectorOperationDescrUI"
    }, {
      PlaceObj("XTemplateFunc", {
        "name",
        "Open",
        "func",
        function(self, ...)
          XContextWindow.Open(self)
          local node = self:ResolveId("node")
          local squads = GetPlayerMercSquads()
          local all_mercs, others_count = 0, 0
          local profs, profs_count = {}, {}
          for _, squad in ipairs(squads) do
            for _, id in pairs(squad.units) do
              all_mercs = all_mercs + 1
              local u = gv_UnitData[id]
              local op = SectorOperations[u.Operation]
              local prof = table.find_value(op.Professions or empty_table, "id", u.OperationProfession)
              if prof then
                profs_count[prof.id] = profs_count[prof.id] and profs_count[prof.id] + 1 or 1
                profs[prof.id] = prof
              else
                others_count = others_count + 1
              end
            end
          end
          if rawget(node, "idStatsTable") then
            local txt_entries = {
              {
                text = T(555509617729, "Squads"),
                value = Untranslated(#squads)
              },
              {
                text = T(656958980161, "Mercs"),
                value = Untranslated(all_mercs)
              }
            }
            for k, v in sorted_pairs(profs) do
              txt_entries[#txt_entries + 1] = {
                text = v.display_name_plural,
                value = Untranslated(profs_count[k])
              }
            end
            txt_entries[#txt_entries + 1] = {
              text = T(903415942850, "Others"),
              value = Untranslated(others_count)
            }
            node.idStatsTable:SetContext(txt_entries)
            node.idStatsTable:RespawnContent()
          end
        end
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "IdNode",
      false,
      "Margins",
      box(0, 16, 16, 16),
      "Dock",
      "box",
      "MinWidth",
      764,
      "MaxWidth",
      764,
      "Image",
      "UI/PDA/os_background_2",
      "FrameBox",
      box(5, 5, 5, 5)
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return GetOperationsInSector(context.sector.Id)
        end,
        "__class",
        "SnappingScrollArea",
        "Id",
        "idList",
        "Margins",
        box(38, 38, 38, 0),
        "LayoutMethod",
        "HWrap",
        "LayoutHSpacing",
        32,
        "LayoutVSpacing",
        42,
        "UniformRowHeight",
        true,
        "Clip",
        false,
        "VScroll",
        "idScroll",
        "LeftThumbScroll",
        false
      }, {
        PlaceObj("XTemplateFunc", {
          "name",
          "OnShortcut(self, shortcut, source, ...)",
          "func",
          function(self, shortcut, source, ...)
            if shortcut == "RightThumbUp" or shortcut == "RightThumbUpLeft" or shortcut == "RightThumbUpRight" then
              return self:OnMouseWheelForward()
            elseif shortcut == "RightThumbDown" or shortcut == "RightThumbDownLeft" or shortcut == "RightThumbDownRight" then
              return self:OnMouseWheelBack()
            end
            if XActionsHost.OnShortcut(self, shortcut, source, ...) == "break" then
              return "break"
            end
          end
        }),
        PlaceObj("XTemplateForEach", {
          "comment",
          "item",
          "__context",
          function(parent, context, item, i, n)
            return item
          end,
          "run_after",
          function(child, context, item, i, n, last)
            local button = child
            button:SetMinWidth(200)
            button:SetMaxWidth(200)
            local w, h = UIL.MeasureText(_InternalTranslate(context.operation.display_name), button.idButtonText:GetFontId(TextStyles.PDAActivitiesButton.TextFont))
            if h > button.idButtonText.box:sizey() then
              button.idButtonText:SetTextStyle("PDAActivitiesButtonSmall")
            end
            button.idButtonText:SetText(context.operation.display_name)
            button:SetEnabled(context.enabled)
            button.RolloverTemplate = "OperationButtonRollover"
            button.RolloverAnchor = "center-bottom"
            button.RolloverOffset = box(0, 0, 0, -10)
            button:SetRolloverText(context.rollover)
            child.idCustom:SetVisible(context.operation.Custom)
            child:SetGridX((i - 1) % 3 + 1)
            child:SetGridY((i - 1) / 3 + 1)
            if button:GetEnabled() then
              button.idOperationProgress:OnContextUpdate(context.operation)
            end
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "SectorOperationButtonUI"
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "MessengerScrollbar",
        "Id",
        "idScroll",
        "HAlign",
        "right",
        "Target",
        "idList",
        "SnapToItems",
        true,
        "AutoHide",
        true
      })
    })
  })
})
