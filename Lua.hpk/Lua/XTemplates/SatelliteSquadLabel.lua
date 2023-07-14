PlaceObj("XTemplate", {
  group = "Zulu Satellite UI",
  id = "SatelliteSquadLabel",
  PlaceObj("XTemplateWindow", {
    "IdNode",
    true,
    "OnLayoutComplete",
    function(self)
      local background = self.idBackground
      local leftRightPadding, bottomMove = ScaleXY(background.scale, 10, 5)
      local width = background.measure_width + leftRightPadding
      local height = background.measure_height
      local parentB = self.box
      local parentBXCenter = parentB:minx() + parentB:sizex() / 2
      local x = parentBXCenter - width / 2
      local y = parentB:miny() - height - bottomMove
      self.idBackground:SetBox(x, y, width, height)
    end,
    "UseClipBox",
    false
  }, {
    PlaceObj("XTemplateWindow", {
      "Id",
      "idBackground",
      "Dock",
      "ignore",
      "HAlign",
      "left",
      "VAlign",
      "top",
      "UseClipBox",
      false,
      "Background",
      RGBA(32, 35, 47, 127)
    }, {
      PlaceObj("XTemplateWindow", {
        "__class",
        "XText",
        "Clip",
        false,
        "UseClipBox",
        false,
        "TextStyle",
        "PDASelectedSquad",
        "ContextUpdateOnOpen",
        true,
        "OnContextUpdate",
        function(self, context, ...)
          local squadSector = context.CurrentSector
          if gv_Sectors[squadSector].conflict then
            self:SetText(T(347870949694, "Engaged"))
            return
          end
          if IsSquadTravelling(context, "skip_tick") then
            self:SetText(T(531647396983, "Traveling"))
            return
          end
          local squadExhausted = GetSquadExhaustedUnitIds(context)
          squadExhausted = squadExhausted == #context.units
          if squadExhausted then
            self:SetText(T(357027445663, "Exhausted"))
            return
          end
          local otherSquads = GetSquadsInSector(squadSector)
          local operation
          for i, s in ipairs(context.units) do
            local ud = gv_UnitData[s]
            if ud.Operation ~= "Idle" then
              if not operation then
                operation = ud.Operation
              elseif operation ~= ud.Operation then
                operation = "many"
                break
              end
            end
          end
          operation = operation or "Idle"
          if operation == "many" then
            self:SetText(T(520902754959, "Operations"))
            return
          end
          local operationPreset = SectorOperations[operation]
          self:SetText(operationPreset.short_name)
        end,
        "Translate",
        true,
        "WordWrap",
        false,
        "TextHAlign",
        "center"
      }, {
        PlaceObj("XTemplateWindow", {
          "comment",
          "update observer",
          "__context",
          function(parent, context)
            return "SquadLabel" .. context.UniqueId
          end,
          "__class",
          "XContextWindow",
          "OnContextUpdate",
          function(self, context, ...)
            self.parent:OnContextUpdate(self.parent.context)
          end
        }),
        PlaceObj("XTemplateFunc", {
          "name",
          "UpdateDrawCache(self, width, height, force)",
          "func",
          function(self, width, height, force)
            return XText.UpdateDrawCache(self, 9999, height, force)
          end
        })
      })
    })
  })
})
