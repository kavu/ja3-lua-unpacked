PlaceObj("XTemplate", {
  __is_kind_of = "SatelliteConflictSquadsAndMercsClass",
  group = "Zulu Satellite UI",
  id = "SatelliteConflictSquadsAndMercs",
  PlaceObj("XTemplateWindow", {
    "__class",
    "SatelliteConflictSquadsAndMercsClass",
    "LayoutMethod",
    "VList",
    "ContextUpdateOnOpen",
    true
  }, {
    PlaceObj("XTemplateWindow", {
      "__context",
      function(parent, context)
        return parent.selected_squad
      end,
      "__class",
      "XContextWindow",
      "Id",
      "idTitle",
      "VAlign",
      "top",
      "MinWidth",
      380,
      "LayoutMethod",
      "HList",
      "OnContextUpdate",
      function(self, context, ...)
        self:ResolveId("idName"):SetContext(self.parent.selected_squad, true)
        self:ResolveId("idSquadImage"):SetContext(self.parent.selected_squad, true)
      end
    }, {
      PlaceObj("XTemplateWindow", {
        "comment",
        "squad icon",
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Dock",
        "left",
        "MinWidth",
        28,
        "MinHeight",
        28,
        "MaxWidth",
        28,
        "MaxHeight",
        28,
        "Image",
        "UI/PDA/os_header",
        "FrameBox",
        box(8, 8, 8, 8)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextImage",
          "Id",
          "idSquadImage",
          "Padding",
          box(3, 3, 3, 3),
          "Image",
          "UI/PDA/T_Icon_SquadPlaceholder_Large_2",
          "ImageFit",
          "scale-down",
          "ImageColor",
          RGBA(89, 146, 170, 255),
          "OnContextUpdate",
          function(self, context, ...)
            self:SetImage(context.militia and "UI/Icons/SateliteView/militia_large" or context.image)
          end
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XFrame",
        "IdNode",
        false,
        "Dock",
        "box",
        "Image",
        "UI/PDA/sector_ally",
        "FrameBox",
        box(8, 8, 8, 8)
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XText",
          "Id",
          "idName",
          "Padding",
          box(4, 2, 2, 2),
          "HandleMouse",
          false,
          "TextStyle",
          "ConflictSquadName",
          "OnContextUpdate",
          function(self, context, ...)
            local node = self:ResolveId("node")
            local squadsCount = #node.context
            local squadIndex = node.currentSquadIndex
            local squadName = context.militia and T(977391598484, "Militia") or Untranslated(context.Name)
            local text
            if 1 < squadsCount then
              text = T({
                658569841912,
                "<squadName> <squadIndex>/<squadsCount>",
                squadName = squadName,
                squadIndex = squadIndex,
                squadsCount = squadsCount
              })
            else
              text = squadName
            end
            self:SetText(text)
            XContextControl.OnContextUpdate(self, context)
          end,
          "Translate",
          true,
          "Text",
          T(929058176410, "<u(Name)>"),
          "WordWrap",
          false
        })
      }),
      PlaceObj("XTemplateTemplate", {
        "comment",
        "next squad",
        "__condition",
        function(parent, context)
          return parent and parent:ResolveId("node") and parent:ResolveId("node").context and #parent:ResolveId("node").context > 1
        end,
        "__template",
        "PDASmallButton",
        "IdNode",
        false,
        "Dock",
        "right",
        "MinWidth",
        28,
        "MinHeight",
        28,
        "MaxWidth",
        28,
        "MaxHeight",
        28,
        "ScaleModifier",
        point(1000, 1000),
        "OnPress",
        function(self, gamepad)
          self:ResolveId("node"):NextSquad()
        end,
        "CenterImage",
        ""
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XImage",
          "Image",
          "UI/PDA/T_PDA_ScrollArrow",
          "ImageColor",
          RGBA(89, 146, 170, 255),
          "Angle",
          5400
        })
      })
    }),
    PlaceObj("XTemplateWindow", {
      "comment",
      "Mercs Themselves (Updates on Sel Squad Change)",
      "__context",
      function(parent, context)
        return parent.selected_squad
      end,
      "__class",
      "XContentTemplate",
      "Id",
      "idParty",
      "IdNode",
      false,
      "Padding",
      box(12, 12, 12, 12),
      "HandleMouse",
      true
    }, {
      PlaceObj("XTemplateWindow", {
        "Margins",
        box(8, 8, 8, 8),
        "Padding",
        box(28, 0, 16, 0),
        "Dock",
        "box",
        "GridStretchX",
        false,
        "GridStretchY",
        false,
        "LayoutMethod",
        "Grid",
        "LayoutHSpacing",
        16,
        "LayoutVSpacing",
        8
      }, {
        PlaceObj("XTemplateForEach", {
          "comment",
          "Mercs in the Current Team",
          "array",
          function(parent, context)
            return GetDialog(parent).context.autoResolve and table.find_value(GetDialog(parent).context.allySquads, "UniqueId", context.UniqueId).units or context.units
          end,
          "__context",
          function(parent, context, item, i, n)
            return gv_UnitData[item] or UnitDataDefs[context.units.templateNames[item]]
          end,
          "run_after",
          function(child, context, item, i, n, last)
            local i = i - 1
            child:SetGridX(i % 3 + 1)
            child:SetGridY(i / 3 + 1)
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__template",
            "HUDMerc",
            "Margins",
            box(0, 7, 0, 0),
            "HandleMouse",
            false,
            "ChildrenHandleMouse",
            false
          })
        })
      })
    })
  })
})
