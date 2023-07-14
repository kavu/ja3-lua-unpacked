PlaceObj("XTemplate", {
  group = "Zulu",
  id = "SectorOperationStatsPopupUI",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPopup",
    "Padding",
    box(0, 4, 0, 4),
    "DrawOnTop",
    true,
    "Background",
    RGBA(195, 189, 172, 255),
    "FocusedBackground",
    RGBA(195, 189, 172, 255),
    "AnchorType",
    "top"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XContentTemplate",
      "IdNode",
      false,
      "Padding",
      box(0, 4, 0, 4),
      "LayoutMethod",
      "VList",
      "Background",
      RGBA(195, 189, 172, 255)
    }, {
      PlaceObj("XTemplateForEach", {
        "array",
        function(parent, context)
          return GetUnitStatsComboTranslated("Wisdom")
        end,
        "__context",
        function(parent, context, item, i, n)
          return item
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XTextButton",
          "Padding",
          box(4, 0, 0, 0),
          "Background",
          RGBA(195, 189, 172, 0),
          "OnContextUpdate",
          function(self, context, ...)
            self:SetText(context.name)
            local node = self:ResolveId("node")
            local sector = node:GetContext()
            self:SetEnabled(not sector or sector.training_stat ~= context.value)
          end,
          "OnPress",
          function(self, gamepad)
            local node = self:ResolveId("node")
            if not node then
              return
            end
            local lists_dlg = GetDialog(self).idBase.idMain
            local mercs_list = lists_dlg.idMercsList
            local sector = node:GetContext()
            local items = GetUnitStatsComboTranslated("Wisdom")
            local prev_val = sector.training_stat
            local item = self.context
            local value = item.value
            if value == prev_val then
              return
            end
            PlayFX("activityTrainingPress", "start", self)
            local mercs = GetOperationProfessionals(sector.Id, "TrainMercs")
            if next(mercs) then
              CreateRealTimeThread(function(self, parent)
                local prop_meta_old = table.find_value(UnitPropertiesStats:GetProperties(), "id", prev_val)
                local prop_meta_new = table.find_value(UnitPropertiesStats:GetProperties(), "id", value)
                local dlg = CreateQuestionBox(terminal.desktop, T(1000599, "Warning"), T({
                  464840818810,
                  "Do you want to end current <stat_name> training and start training <new_stat_name>",
                  stat_name = prop_meta_old.name,
                  new_stat_name = prop_meta_new.name
                }), T(689884995409, "Yes"), T(782927325160, "No"))
                dlg:SetModal()
                local res = dlg:Wait()
                if res == "ok" then
                  sector.training_stat = value
                  mercs_list:OnContextUpdate()
                  self.parent:OnContextUpdate(self.parent.context, true)
                  local costs = GetOperationCostsProcessed(mercs, "TrainMercs")
                  for i, merc in ipairs(mercs) do
                    NetSyncEvent("RestoreOperationCostAndSetOperation", merc.session_id, costs[i], "Idle")
                  end
                else
                  local prev_item = table.find_value(items, "value", prev_val)
                  sector.training_stat = prev_val
                  mercs_list:OnContextUpdate()
                  self.parent:OnContextUpdate(self.parent.context, true)
                end
                NetSyncEvent("SetTrainingStat", sector.Id, sector.training_stat)
                ObjModified(sector)
              end, self, GetDialog(self))
            else
              sector.training_stat = value
              mercs_list:OnContextUpdate()
              self.parent:OnContextUpdate(self.parent.context, true)
              NetSyncEvent("SetTrainingStat", sector.Id, value)
            end
          end,
          "RolloverBackground",
          RGBA(32, 35, 47, 255),
          "PressedBackground",
          RGBA(195, 189, 172, 255),
          "TextStyle",
          "PDACommonButtonWithRollover",
          "Translate",
          true
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnMouseButtonDown(self, pos, button)",
      "func",
      function(self, pos, button)
        if button == "R" or not self:MouseInWindow(pos) then
          self:Close()
        end
      end
    })
  })
})
