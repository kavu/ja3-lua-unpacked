PlaceObj("XTemplate", {
  __is_kind_of = "SatelliteConflictSquadsAndMercsClass",
  group = "Zulu Satellite UI",
  id = "SatelliteConflictSquadsAndEnemies",
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
          "XImage",
          "Id",
          "idSquadImage",
          "Padding",
          box(3, 3, 3, 3),
          "Image",
          "UI/PDA/T_Icon_SquadPlaceholder_Large_2",
          "ImageFit",
          "scale-down",
          "ImageColor",
          RGBA(182, 58, 52, 255)
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
        "UI/PDA/sector_enemy",
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
            local text
            if context then
              local node = self:ResolveId("node")
              local squadsCount = #node.context
              local squadIndex = node.currentSquadIndex
              local squadName = IsT(context.Name) and context.Name or Untranslated(context.Name)
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
            else
              text = T(496804530535, "UNKNOWN ENEMIES")
            end
            self:SetText(text)
            XContextControl.OnContextUpdate(self, context)
          end,
          "Translate",
          true,
          "Text",
          T(512042932753, "<u(Name)>"),
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
          RGBA(191, 67, 77, 255),
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
      "__condition",
      function(parent, context)
        return context
      end,
      "__class",
      "XContentTemplate",
      "Id",
      "idParty",
      "IdNode",
      false,
      "Padding",
      box(12, 12, 12, 12)
    }, {
      PlaceObj("XTemplateWindow", {
        "__context",
        function(parent, context)
          return GroupEnemyMercs({context}, true)
        end,
        "__class",
        "XScrollArea",
        "Id",
        "idScrollArea",
        "Margins",
        box(8, 8, 8, 8),
        "Padding",
        box(16, 0, 28, 0),
        "Dock",
        "box",
        "MaxHeight",
        228,
        "GridStretchX",
        false,
        "GridStretchY",
        false,
        "LayoutMethod",
        "Grid",
        "LayoutHSpacing",
        16,
        "LayoutVSpacing",
        8,
        "VScroll",
        "idScroll"
      }, {
        PlaceObj("XTemplateForEach", {
          "comment",
          "Mercs in the Current Team",
          "__context",
          function(parent, context, item, i, n)
            return item
          end,
          "run_after",
          function(child, context, item, i, n, last)
            local i = i - 1
            child:SetGridX(i % 3 + 1)
            child:SetGridY(i / 3 + 1)
            if 1 < context.count then
              child.idCountIcon:SetVisible(true)
              child.idCountText:SetText(T({
                118551763994,
                "x<count>",
                count = context.count
              }))
            end
            child.idBar:SetVisible(false)
            child.idBottomBar:SetVisible(false)
            child.idBottomPart:SetVisible(false)
          end
        }, {
          PlaceObj("XTemplateTemplate", {
            "__context",
            function(parent, context)
              return context.template
            end,
            "__template",
            "HUDMerc",
            "RolloverTemplate",
            "SmallRolloverLine",
            "RolloverAnchor",
            "center-bottom",
            "RolloverAnchorId",
            "idPortraitBG",
            "RolloverText",
            T(831801658535, "<DisplayName>"),
            "Margins",
            box(0, 7, 0, 0),
            "LayoutMethod",
            "Box",
            "ChildrenHandleMouse",
            false
          }, {
            PlaceObj("XTemplateWindow", {
              "comment",
              "unit count icon",
              "__class",
              "XImage",
              "Id",
              "idCountIcon",
              "IdNode",
              false,
              "ZOrder",
              0,
              "Margins",
              box(0, 0, -32, 0),
              "HAlign",
              "left",
              "VAlign",
              "top",
              "Visible",
              false,
              "DrawOnTop",
              true,
              "Image",
              "UI/PDA/sector_enemy",
              "ImageScale",
              point(600, 600)
            }, {
              PlaceObj("XTemplateWindow", {
                "__class",
                "XText",
                "Id",
                "idCountText",
                "HAlign",
                "center",
                "VAlign",
                "center",
                "HandleMouse",
                false,
                "TextStyle",
                "PDASelectedSquad",
                "Translate",
                true,
                "Text",
                T(600116519425, "x8")
              })
            })
          })
        })
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "MessengerScrollbar",
        "Id",
        "idScroll",
        "Margins",
        box(16, 0, 0, 32),
        "HAlign",
        "right",
        "ScaleModifier",
        point(750, 750),
        "OnContextUpdate",
        function(self, context, ...)
          local prop_id = self.BindTo
          local prop_meta = self.prop_meta
          self.color_default = RGB(195, 189, 172)
          self.color_active = RGB(195, 189, 172)
          if context and (prop_id ~= "" or prop_meta) then
            if prop_meta then
              prop_id = prop_meta.id
              local name = self:ResolveId("idName")
              if name then
                name:SetText(prop_meta.name or prop_meta.id)
              end
            end
            local value = ResolveValue(context, prop_id)
            if value ~= rawget(self, "value") then
              self.value = value
              self:OnPropUpdate(context, prop_meta, value)
            end
          end
          XContextControl.OnContextUpdate(self, context)
        end,
        "Target",
        "idScrollArea",
        "SnapToItems",
        true,
        "AutoHide",
        true
      })
    }),
    PlaceObj("XTemplateWindow", {
      "__condition",
      function(parent, context)
        return not parent.selected_squad
      end,
      "Margins",
      box(40, 20, 0, 0),
      "HAlign",
      "left",
      "VAlign",
      "top",
      "MinWidth",
      80,
      "MinHeight",
      118,
      "MaxWidth",
      80,
      "MaxHeight",
      118
    }, {
      PlaceObj("XTemplateWindow", {
        "Dock",
        "bottom",
        "VAlign",
        "bottom",
        "MinHeight",
        30,
        "MaxHeight",
        30,
        "Visible",
        false,
        "Background",
        RGBA(32, 35, 47, 255)
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "IdNode",
        false,
        "Margins",
        box(0, 10, 0, 0),
        "Dock",
        "box",
        "Image",
        "UI/Hud/portrait_background",
        "ImageFit",
        "largest"
      }),
      PlaceObj("XTemplateWindow", {
        "__class",
        "XImage",
        "IdNode",
        false,
        "Margins",
        box(0, 0, 0, -10),
        "Dock",
        "box",
        "Image",
        "UI/EnemiesPortraits/Unknown",
        "ImageFit",
        "largest"
      })
    })
  })
})
