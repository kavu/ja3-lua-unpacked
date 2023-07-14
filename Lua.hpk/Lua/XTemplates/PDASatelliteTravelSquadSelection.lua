PlaceObj("XTemplate", {
  group = "Zulu Satellite UI",
  id = "PDASatelliteTravelSquadSelection",
  PlaceObj("XTemplateWindow", {
    "__class",
    "XPopup",
    "ZOrder",
    0,
    "Margins",
    box(0, 5, 0, 0),
    "MinWidth",
    355,
    "MaxWidth",
    355,
    "BorderColor",
    RGBA(0, 0, 0, 0),
    "Background",
    RGBA(0, 0, 0, 0),
    "BackgroundRectGlowColor",
    RGBA(0, 0, 0, 0),
    "MouseCursor",
    "UI/Cursors/Pda_Cursor.tga",
    "FocusedBorderColor",
    RGBA(0, 0, 0, 0),
    "FocusedBackground",
    RGBA(0, 0, 0, 0),
    "DisabledBorderColor",
    RGBA(0, 0, 0, 0),
    "AnchorType",
    "right"
  }, {
    PlaceObj("XTemplateWindow", {
      "__class",
      "XFrame",
      "Padding",
      box(20, 10, 10, 10),
      "LayoutMethod",
      "VList",
      "HandleMouse",
      true,
      "Image",
      "UI/PDA/os_background",
      "FrameBox",
      box(2, 2, 56, 56)
    }, {
      PlaceObj("XTemplateForEach", {
        "array",
        function(parent, context)
          return GetPlayerMercSquads()
        end,
        "__context",
        function(parent, context, item, i, n)
          return item
        end,
        "run_after",
        function(child, context, item, i, n, last)
          child.idLine:SetVisible(i ~= last)
          local canTravel = SatelliteCanTravelState(context)
          child[1]:SetEnabled(canTravel == "enabled")
        end
      }, {
        PlaceObj("XTemplateWindow", {
          "__class",
          "XContextWindow",
          "IdNode",
          true,
          "LayoutMethod",
          "VList"
        }, {
          PlaceObj("XTemplateWindow", {
            "__class",
            "XButton",
            "RolloverTemplate",
            "SquadRollover",
            "RolloverAnchor",
            "right",
            "RolloverText",
            T(314554616502, "<u(Name)>"),
            "RolloverTitle",
            T(658387709843, "<u(Name)>"),
            "LayoutMethod",
            "HList",
            "LayoutHSpacing",
            5,
            "BorderColor",
            RGBA(0, 0, 0, 0),
            "Background",
            RGBA(0, 0, 0, 0),
            "MouseCursor",
            "UI/Cursors/Pda_Hand.tga",
            "OnContextUpdate",
            function(self, context, ...)
              local startSectorId = context.CurrentSector
              local endSectorId, notTravelling = GetSquadFinalDestination(startSectorId, context.route)
              if notTravelling then
                local _, color = GetSectorControlColor(gv_Sectors[startSectorId].Side)
                self.idLocation:SetText(T({
                  857749023735,
                  "<clr><u(sectorId)></color>",
                  clr = color,
                  sectorId = startSectorId
                }))
              else
                local _, color = GetSectorControlColor(gv_Sectors[startSectorId].Side)
                local _, colorEnd = GetSectorControlColor(gv_Sectors[endSectorId].Side)
                self.idLocation:SetText(T({
                  908950852075,
                  "<clr><u(sectorId)>-</color><clrEnd><u(endSectorId)></color>",
                  clr = color,
                  sectorId = startSectorId,
                  clrEnd = colorEnd,
                  endSectorId = endSectorId
                }))
              end
              self.idLogo:SetContext({
                squad = context.UniqueId,
                side = "ally"
              })
            end,
            "FocusedBorderColor",
            RGBA(0, 0, 0, 0),
            "FocusedBackground",
            RGBA(0, 0, 0, 0),
            "DisabledBorderColor",
            RGBA(0, 0, 0, 0),
            "OnPress",
            function(self, gamepad)
              g_SatelliteUI:SelectSquad(self.context)
              g_SatelliteUI:RemoveContextMenu()
            end,
            "RolloverBackground",
            RGBA(0, 0, 0, 0),
            "PressedBackground",
            RGBA(0, 0, 0, 0)
          }, {
            PlaceObj("XTemplateTemplate", {
              "__template",
              "SatelliteIconCombined",
              "Id",
              "idLogo",
              "ScaleModifier",
              point(625, 625)
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idName",
              "HAlign",
              "left",
              "VAlign",
              "center",
              "FoldWhenHidden",
              true,
              "TextStyle",
              "PDASectorInfo_Yellow",
              "Translate",
              true,
              "Text",
              T(931625862646, "<u(Name)> [<u(SquadMemberCount())>]"),
              "TextVAlign",
              "center"
            }),
            PlaceObj("XTemplateWindow", {
              "__class",
              "XText",
              "Id",
              "idLocation",
              "Dock",
              "right",
              "HAlign",
              "right",
              "VAlign",
              "center",
              "TextStyle",
              "PDASectorInfo_ValueLight",
              "Translate",
              true,
              "TextHAlign",
              "center",
              "TextVAlign",
              "center"
            }),
            PlaceObj("XTemplateFunc", {
              "name",
              "OnSetRollover(self, rollover)",
              "func",
              function(self, rollover)
                local travelCtx = g_SatelliteUI.travel_mode
                if not travelCtx then
                  return
                end
                g_SatelliteUI:SetTravelPreviewSquad(rollover and self.context)
              end
            })
          }),
          PlaceObj("XTemplateWindow", {
            "comment",
            "h line",
            "__class",
            "XImage",
            "Id",
            "idLine",
            "Margins",
            box(0, 10, 0, 10),
            "VAlign",
            "top",
            "FoldWhenHidden",
            true,
            "Image",
            "UI/PDA/separate_line_vertical",
            "ImageFit",
            "stretch-x"
          })
        })
      })
    }),
    PlaceObj("XTemplateFunc", {
      "name",
      "OnDelete()",
      "func",
      function()
        ObjModified(g_SatelliteUI.travel_mode)
      end
    })
  })
})
